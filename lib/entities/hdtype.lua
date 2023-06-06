-- commonlib = require 'common'

local module = {}

module.HD_KILL_ON = {
	STANDING = 1,
	STANDING_OUTOFWATER = 2
}

module.HD_BEHAVIOR = {
	OLMEC_SHOT = {
		velocity_set = {
			velocityx = nil,
			velocityy = nil,
			timer = 25
		}
	},
}
module.HD_ENT = {
    FROG = {
        tospawn = ENT_TYPE.MONS_FROG,
    },
    FIREFROG = {
        tospawn = ENT_TYPE.MONS_FIREFROG,
    },
}

module.HD_ENT.OLMEC_SHOT = {
	tospawn = ENT_TYPE.ITEM_TIAMAT_SHOT,
	kill_on_standing = module.HD_KILL_ON.STANDING,
	behavior = module.HD_BEHAVIOR.OLMEC_SHOT,
	itemdrop = {
		item = {
			module.HD_ENT.FROG,
			module.HD_ENT.FIREFROG,
		},
		chance = 1.0
	},
	-- Enable "collides walls", uncheck "No Gravity", uncheck "Passes through objects".
	flags = {
		{13},
		{4, 10}
	},
}

module.danger_tracker = {}

function module.init()
    module.danger_tracker = {}
end

local create_hd_behavior

local function danger_track(uid_to_track, x, y, l, hd_type)
	local danger_object = {
		["uid"] = uid_to_track,
		["x"] = x, ["y"] = y, ["l"] = l,
		["hd_type"] = hd_type,
		["behavior"] = create_hd_behavior(hd_type.behavior)
	}
	module.danger_tracker[#module.danger_tracker+1] = danger_object
end

function create_hd_behavior(behavior)
	local decorated_behavior = {}
	if behavior ~= nil then
		decorated_behavior = commonlib.TableCopy(behavior)
		if behavior == module.HD_BEHAVIOR.OLMEC_SHOT then
			local xvel = prng:random_int(7, 30, PRNG_CLASS.PARTICLES)/100
			local yvel = prng:random_int(5, 10, PRNG_CLASS.PARTICLES)/100
			if prng:random_chance(2, PRNG_CLASS.PARTICLES) then xvel = -xvel end
			decorated_behavior.velocity_set.velocityx = xvel
			decorated_behavior.velocity_set.velocityy = yvel
		end
	end
	return decorated_behavior
end

local function applyflags_to_uid(uid_assignto, flags)
	if #flags > 0 then
		local ability_e = get_entity(uid_assignto)
		local flags_set = flags[1]
		for _, flag in ipairs(flags_set) do
			if (
				flag ~= 1 or
				(flag == 1 and options.hd_debug_scripted_enemies_show == false)
			) then
				ability_e.flags = set_flag(ability_e.flags, flag)
			end
		end
		if #flags > 1 then
			local flags_clear = flags[2]
			for _, flag in ipairs(flags_clear) do
				ability_e.flags = clr_flag(ability_e.flags, flag)
			end
		end
	else message("No flags") end
end

local function danger_applydb(uid, hd_type)
	if hd_type.flags ~= nil then
		applyflags_to_uid(uid, hd_type.flags)
	end

	apply_entity_db(uid)
end


-- velocity defaults to 0
local function create_hd_type_notrack(hd_type, x, y, l, _vx, _vy)
	return spawn(hd_type.tospawn, x, y, l, _vx or 0, _vy or 0)
end

-- velocity defaults to 0 (by extension of `create_hd_type_notrack()`)
function module.create_hd_type(hd_type, x, y, l, collision_detection, _vx, _vy)
	local offset_collision = { 0, 0 }
	if collision_detection == true then
		offset_collision = conflictdetection(hd_type, x, y, l)
	end
	if offset_collision ~= nil then
		local offset_spawn_x, offset_spawn_y = 0, 0
		if hd_type.offset_spawn ~= nil then
			offset_spawn_x, offset_spawn_y = hd_type.offset_spawn[1], hd_type.offset_spawn[2]
		end
		local uid = create_hd_type_notrack(hd_type, x+offset_spawn_x+offset_collision[1], y+offset_spawn_y+offset_collision[2], l, _vx, _vy)
		if uid ~= -1 then
			danger_applydb(uid, hd_type)
			danger_track(uid, x, y, l, hd_type)
			return uid
		end
	end
end

-- DANGER MODIFICATIONS - ON.FRAME
-- Massive enemy behavior handling method
set_callback(function()

	local n = # module.danger_tracker
	for i, danger in ipairs( module.danger_tracker) do
		---@type Movable
		local danger_mov = get_entity(danger.uid)
		local killbool = false
		if danger_mov == nil then
			killbool = true
		elseif danger_mov ~= nil then
			danger.x, danger.y, danger.l = get_position(danger.uid)
			if danger.behavior ~= nil then
				if danger.behavior.velocity_set ~= nil then
					if danger.behavior.velocity_set.timer > 0 then
						danger.behavior.velocity_set.timer = danger.behavior.velocity_set.timer - 1
					else
						if danger.behavior.velocity_set.velocityx ~= nil then
							danger_mov.velocityx = danger.behavior.velocity_set.velocityx
						end
						if danger.behavior.velocity_set.velocityy ~= nil then
							danger_mov.velocityy = danger.behavior.velocity_set.velocityy
						end
						message("Olmec behavior 'YEET' velocityx: " .. tostring(danger_mov.velocityx))
						danger.behavior.velocity_set = nil
					end
				end
			end

			if (
				danger.hd_type.kill_on_standing ~= nil
				and danger.hd_type.kill_on_standing == module.HD_KILL_ON.STANDING
				and danger_mov.standing_on_uid ~= -1
			) then
				killbool = true
			end
		end
		if killbool == true then
			if danger.hd_type.itemdrop ~= nil then -- if dead and has possible item drops
				if danger.hd_type.itemdrop.item ~= nil and #danger.hd_type.itemdrop.item > 0 then
					if (
						danger.hd_type.itemdrop.chance == nil or
						(
							danger.hd_type.itemdrop.chance ~= nil and
							-- danger.itemdrop.chance > 0 and
							prng:random_float(PRNG_CLASS.PARTICLES) <= danger.hd_type.itemdrop.chance
						)
					) then
						local itemdrop = danger.hd_type.itemdrop.item[prng:random_index(#danger.hd_type.itemdrop.item, PRNG_CLASS.PARTICLES)]
						hdtypelib.create_hd_type(itemdrop, danger.x, danger.y, danger.l, false, 0, 0)--spawn(itemdrop, etc)
					end
				end
			end
			if danger.hd_type.treasuredrop ~= nil then -- if dead and has possible item drops
				if danger.hd_type.treasuredrop.item ~= nil and #danger.hd_type.treasuredrop.item > 0 then
					if (
						danger.hd_type.treasuredrop.chance == nil or
						(
							danger.hd_type.treasuredrop.chance ~= nil and
							-- danger.treasuredrop.chance > 0 and
							prng:random_float(PRNG_CLASS.PARTICLES) <= danger.hd_type.treasuredrop.chance
						)
					) then
						local itemdrop = danger.hd_type.treasuredrop.item[prng:random_index(#danger.hd_type.treasuredrop.item, PRNG_CLASS.PARTICLES)]
						hdtypelib.create_hd_type(itemdrop, danger.x, danger.y, danger.l, false, 0, 0)
					end
				end
			end
			kill_entity(danger.uid)
			 module.danger_tracker[i] = nil
		end
	end
	-- compact danger_tracker
	commonlib.CompactList( module.danger_tracker, n)
end, ON.FRAME)

return module