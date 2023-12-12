local module = {}

optionslib.register_option_bool("hd_debug_worm_tongue_info", "Worm tongue - Show info", nil, false, true)

local ANIMATION_FRAMES_ENUM = {
	DECO_HOLE = 1,
	DECO_TONGUE = 2,
}

local ANIMATION_FRAMES_RES = {
    { 0 },
    { 0 },
}

local ANIMATIONS <const> = {
	EMERGE_OR_RECEDING = {3, loop = true, frames = 1, frame_time = 4},
	OPENING = {1, 2, loop = false, frames = 2, frame_time = 4},
	OPEN = {0, loop = false, frames = 1, frame_time = 8},
	CLOSING = {2, 1, loop = false, frames = 2, frame_time = 4},
}

local worm_texture_id
local wormtongue_jungle_texture_id
local hole_jungle_texture_id
local wormtongue_ice_texture_id
local hole_ice_texture_id
do
	local worm_texture_def = TextureDefinition.new()
	worm_texture_def.width = 1024
	worm_texture_def.height = 1024
	worm_texture_def.tile_width = 512
	worm_texture_def.tile_height = 512
	worm_texture_def.texture_path = "res/worm.png"
	worm_texture_id = define_texture(worm_texture_def)

	local wormtongue_jungle_texture_def = TextureDefinition.new()
	wormtongue_jungle_texture_def.width = 768
	wormtongue_jungle_texture_def.height = 512
	wormtongue_jungle_texture_def.tile_width = 256
	wormtongue_jungle_texture_def.tile_height = 256
	wormtongue_jungle_texture_def.sub_image_width = 256
	wormtongue_jungle_texture_def.sub_image_height = 768
	wormtongue_jungle_texture_def.sub_image_offset_x = 512
	wormtongue_jungle_texture_def.sub_image_offset_y = 0
	wormtongue_jungle_texture_def.texture_path = "res/wormtongue_deco_jungle.png"
	wormtongue_jungle_texture_id = define_texture(wormtongue_jungle_texture_def)
	local hole_jungle_texture_def = TextureDefinition.new()
	hole_jungle_texture_def.width = 768
	hole_jungle_texture_def.height = 512
	hole_jungle_texture_def.tile_width = 512
	hole_jungle_texture_def.tile_height = 512
	hole_jungle_texture_def.texture_path = "res/wormtongue_deco_jungle.png"
	hole_jungle_texture_id = define_texture(hole_jungle_texture_def)

	local wormtongue_ice_texture_def = TextureDefinition.new()
	wormtongue_ice_texture_def.width = 768
	wormtongue_ice_texture_def.height = 512
	wormtongue_ice_texture_def.tile_width = 256
	wormtongue_ice_texture_def.tile_height = 256
	wormtongue_ice_texture_def.sub_image_width = 256
	wormtongue_ice_texture_def.sub_image_height = 768
	wormtongue_ice_texture_def.sub_image_offset_x = 512
	wormtongue_ice_texture_def.sub_image_offset_y = 0
	wormtongue_ice_texture_def.texture_path = "res/wormtongue_deco_ice.png"
	wormtongue_ice_texture_id = define_texture(wormtongue_ice_texture_def)
	local hole_ice_texture_def = TextureDefinition.new()
	hole_ice_texture_def.width = 768
	hole_ice_texture_def.height = 512
	hole_ice_texture_def.tile_width = 512
	hole_ice_texture_def.tile_height = 512
	hole_ice_texture_def.texture_path = "res/wormtongue_deco_ice.png"
	hole_ice_texture_id = define_texture(hole_ice_texture_def)
end


local wormtongue_uid = nil
local bg_uid = nil
local worm_uid = nil
local TONGUE_ACCEPTTIME = 200
local IDLE_TICK_TIMEOUT = 15
local tongue_tick = TONGUE_ACCEPTTIME
local idle_tick = IDLE_TICK_TIMEOUT
local CHECK_RADIUS = 1.5
local TONGUE_SEQUENCE = {
	READY = 1,
	RUMBLE = 2,
	EMERGE = 3,
	RECEDE = 4,
	FINISH_RUMBLE = 5,
	GONE = 6
}
local tongue_state = nil
local animation_state
local animation_timer
local rumble_sound = nil -- Refers to a looped sound that we need to stop either on a new screen or shortly after the worm leaves

function module.init()
	wormtongue_uid = -1
	bg_uid = -1
	worm_uid = -1
	tongue_state = nil
	tongue_tick = TONGUE_ACCEPTTIME
	idle_tick = IDLE_TICK_TIMEOUT
	animation_state = nil
	animation_timer = 0
end

local function tongue_exit()
	local x, y, l = get_position(wormtongue_uid)
	local checkradius = 1.5
	local damsels = get_entities_at({ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_HAMSTER}, 0, x, y, l, checkradius)
	local ensnaredplayers = get_entities_at(0, 0x1, x, y, l, checkradius)
	
	local exits_doors = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)
	-- exits_worm = get_entities_at(ENT_TYPE.FLOOR_DOOR_EXIT, 0, x, y, l, 1)
	-- worm_exit_uid = exits_worm[1]
	local exitdoor = nil
	for _, exits_door in ipairs(exits_doors) do
		-- if exits_door ~= worm_exit_uid then
			exitdoor = exits_door
		-- end
	end
	if exitdoor ~= nil then
		local exit_x, exit_y, _ = get_position(exitdoor)
		for _, damsel_uid in ipairs(damsels) do
			local damsel = get_entity(damsel_uid)
			local stuck_in_web = test_flag(damsel.more_flags, 8)
			local dead = test_flag(damsel.flags, ENT_FLAG.DEAD)
			if (
				(stuck_in_web == true)
			) then
				if dead then
					damsel:destroy()
				else
					damsel.stun_timer = 0
					if options.hd_debug_scripted_enemies_show == false then
						damsel.flags = set_flag(damsel.flags, ENT_FLAG.INVISIBLE)
					end
					damsel.flags = clr_flag(damsel.flags, ENT_FLAG.INTERACT_WITH_WEBS)-- disable interaction with webs
					-- damsel.flags = clr_flag(damsel.flags, ENT_FLAG.STUNNABLE)-- disable stunable
					damsel.flags = set_flag(damsel.flags, ENT_FLAG.TAKE_NO_DAMAGE)--6)-- enable take no damage
					move_entity(damsel_uid, exit_x, exit_y+0.1, 0, 0)
				end
			end
		end
	else
		message("No Level Exitdoor found, can't force-rescue damsels.")
	end

	if #ensnaredplayers > 0 then
		
		for _, ensnaredplayer_uid in ipairs(ensnaredplayers) do
			local ensnaredplayer = get_entity(ensnaredplayer_uid)
			ensnaredplayer.stun_timer = 0
			ensnaredplayer.more_flags = set_flag(ensnaredplayer.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)-- disable input
			
			if options.hd_debug_scripted_enemies_show == false then
				ensnaredplayer.flags = set_flag(ensnaredplayer.flags, ENT_FLAG.INVISIBLE)-- make each player invisible
				-- Also make the players back item and held items invisible
				if get_entity(ensnaredplayer.holding_uid) ~= nil then
					local item = get_entity(ensnaredplayer.holding_uid)
					item.flags = set_flag(item.flags, ENT_FLAG.INVISIBLE)
				end
				if get_entity(ensnaredplayer:worn_backitem()) ~= nil then
					local item = get_entity(ensnaredplayer:worn_backitem())
					item:remove()
				end
			end
				-- disable interactions with anything else that may interfere with entering the door
			ensnaredplayer.flags = clr_flag(ensnaredplayer.flags, ENT_FLAG.INTERACT_WITH_WEBS)-- disable interaction with webs
			ensnaredplayer.flags = set_flag(ensnaredplayer.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)-- disable interaction with objects
			ensnaredplayer.flags = set_flag(ensnaredplayer.flags, ENT_FLAG.NO_GRAVITY)-- disable gravity
			
			-- -- teleport player to the newly created invisible door (platform is at y+0.05)
			-- move_entity(ensnaredplayer_uid, x, y+0.15, 0, 0)
		end
		set_timeout(function()
			state.fadeout = 15
		end, 115)
		set_timeout(function()
			state.fadein = 15
		end, 145)
		set_timeout(function()
			state.loading = 1--SCREEN.INTRO?
			state.screen_next = SCREEN.TRANSITION
			state.world_next = state.world
			state.level_next = state.level+1
			state.theme_next = THEME.EGGPLANT_WORLD
			state.pause = 0
		end, 146)
	end
	
	-- -- hide worm tongue
	-- local tongue = get_entity(wormtongue_uid)
	-- if options.hd_debug_scripted_enemies_show == false then
	-- 	tongue.flags = set_flag(tongue.flags, ENT_FLAG.INVISIBLE)
	-- end
	-- tongue.flags = set_flag(tongue.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)-- disable interaction with objects
end

local function kill_wormtongue()
	local wormtongue = get_entity(wormtongue_uid)
	wormtongue.flags = set_flag(wormtongue.flags, ENT_FLAG.DEAD)
	wormtongue:destroy()
	-- kill_entity(wormtongue_uid)
	wormtongue_uid = -1
end

local function onframe_tonguetimeout()
	-- Wormtongue existence states
	if tongue_state == TONGUE_SEQUENCE.READY then
		if wormtongue_uid == -1 then
			message("wormtongue_uid is not expected to be -1 at this point!")
			return
		end
		local x, y, l = get_position(wormtongue_uid)
		message(string.format("%s: %s, %s", wormtongue_uid, x, y))
		local damsels = get_entities_at({ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_HAMSTER}, 0, x, y, l, CHECK_RADIUS)
		if #damsels > 0 then
			message(string.format("damsel: %s", damsels[1]))
			local damsel = get_entity(damsels[1])
			if damsel ~= nil and test_flag(damsel.more_flags, 8) then
				message(string.format("damsel is_caught: %s", test_flag(damsel.more_flags, 8)))
				if tongue_tick <= 0 then
					tongue_state = TONGUE_SEQUENCE.RUMBLE
					tongue_tick = 65
					if rumble_sound == nil then
						commonlib.shake_camera(180, 180, 3, 3, 3, false)
						local rumble_sound = commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_WARN_LOOP, wormtongue_uid, 1, false)
						-- If we don't stop the rumble sound in the timeout, we need to stop it here
						set_callback(function()
							if rumble_sound then
								rumble_sound:stop()
								rumble_sound = nil
							end
							clear_callback()
						end, ON.SCREEN)
						rumble_sound = rumble_sound
					end
				else
					tongue_tick = tongue_tick - 1
				end
			else
				tongue_tick = TONGUE_ACCEPTTIME
			end
		end
	elseif tongue_state == TONGUE_SEQUENCE.RUMBLE then
		if wormtongue_uid == -1 then
			message("wormtongue_uid is not expected to be -1 at this point!")
			return
		end
		local x, y, l = get_position(wormtongue_uid)
		-- Start the rumble sound and shake screen
		if tongue_tick > 0 then
			tongue_tick = tongue_tick - 1
		else
			local background = get_entity(bg_uid)
			if background then
				background:set_texture(state.theme == THEME.JUNGLE and hole_jungle_texture_id or hole_ice_texture_id)
				background.width, background.height = 4, 4
				background.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DECO_HOLE][1]
			end
			
			for _ = 1, 45, 1 do
				local rubble = get_entity(spawn_entity(ENT_TYPE.ITEM_RUBBLE,
					x+prng:random_int(-15, 15, PRNG_CLASS.PARTICLES)/10, (y-0.2)+prng:random_int(-7, 7, PRNG_CLASS.PARTICLES)/10, l,
					prng:random_int(-10, 10, PRNG_CLASS.PARTICLES)/100, 0.11+prng:random_int(0, 3, PRNG_CLASS.PARTICLES)/10))
				-- Area specific rubble
				if state.theme == THEME.JUNGLE then
					rubble.animation_frame = 8
				end
				if state.theme == THEME.ICE_CAVES then
					rubble.animation_frame = 40
				end
			end
			
			local blocks_to_break = get_entities_at(
				0, MASK.FLOOR,
				x, y, l,
				3.0
			)
			for _, block_uid in pairs(blocks_to_break) do
				local entity_type = get_entity(block_uid).type.id
				-- message("Type: " .. tostring(entity_type)
				if entity_type ~= ENT_TYPE.FLOOR_BORDERTILE then
					kill_entity(block_uid)
				end
			end

			local worm = get_entity(spawn_entity(ENT_TYPE.BG_LEVEL_DECO, x, y, l, 0, 0))
			worm:set_texture(worm_texture_id)
			worm.width, worm.height = 2, 2
			animation_state = ANIMATIONS.EMERGE_OR_RECEDING
			animation_timer = ANIMATIONS.EMERGE_OR_RECEDING.frames * ANIMATIONS.EMERGE_OR_RECEDING.frame_time
			-- # TODO: If animations break, try setting the animation_timer like this every time you change animation_state, or removing this.
			worm_uid = worm.uid

			commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE, worm_uid, 1, false)
			commonlib.shake_camera(20, 20, 12, 12, 12, false)

			tongue_state = TONGUE_SEQUENCE.EMERGE
		end
	elseif tongue_state == TONGUE_SEQUENCE.EMERGE then
		local worm = get_entity(worm_uid)
		if worm == nil then
			message("worm nil")
			return
		end
		if worm.width >= 4 then
			if animation_state == ANIMATIONS.EMERGE_OR_RECEDING then
				message("PRE SET OPENING")
				animation_state = ANIMATIONS.OPENING
				animation_timer = ANIMATIONS.OPENING.frames * ANIMATIONS.OPENING.frame_time
			elseif animation_state == ANIMATIONS.OPENING
			and animation_timer == 0 then
				message("PRE SET OPEN")
				animation_state = ANIMATIONS.OPEN
				animation_timer = ANIMATIONS.OPEN.frames * ANIMATIONS.OPEN.frame_time
			elseif animation_state == ANIMATIONS.OPEN
			and animation_timer == 0 then
				tongue_exit()

				local x, y, l = get_position(wormtongue_uid)

				kill_wormtongue()

				-- # TODO: Improve this iFrames quick fix
				-- Quick fix: the player can become visible again during this sequence if they have iFrames during it, so let's keep setting them to invisible to avoid this
				local ensnaredplayers = get_entities_at(0, 0x1, x, y, l, CHECK_RADIUS)
				if #ensnaredplayers > 0 then
					for _, ensnaredplayer_uid in ipairs(ensnaredplayers) do
						local ensnaredplayer = get_entity(ensnaredplayer_uid)
						if options.hd_debug_scripted_enemies_show == false then
							ensnaredplayer.flags = set_flag(ensnaredplayer.flags, ENT_FLAG.INVISIBLE)-- make each player invisible
							-- Also make the players back item and held items invisible
							if get_entity(ensnaredplayer.holding_uid) ~= nil then
								local item = get_entity(ensnaredplayer.holding_uid)
								item.flags = set_flag(item.flags, ENT_FLAG.INVISIBLE)
							end
							if get_entity(ensnaredplayer:worn_backitem()) ~= nil then
								local item = get_entity(ensnaredplayer:worn_backitem())
								item:remove()
							end
						end
					end
				end
	
				tongue_state = TONGUE_SEQUENCE.RECEDE
				animation_state = ANIMATIONS.CLOSING
				animation_timer = ANIMATIONS.CLOSING.frames * ANIMATIONS.CLOSING.frame_time
			end
		else
			--grow worm
			worm.width, worm.height = worm.width + 0.08, worm.height + 0.08
		end
	elseif tongue_state == TONGUE_SEQUENCE.RECEDE then
		local worm = get_entity(worm_uid)
		if worm == nil then
			message("worm nil")
			return
		end

		if animation_state == ANIMATIONS.CLOSING
		and animation_timer == 0 then
			animation_state = ANIMATIONS.EMERGE_OR_RECEDING
			animation_timer = ANIMATIONS.EMERGE_OR_RECEDING.frames * ANIMATIONS.EMERGE_OR_RECEDING.frame_time
		elseif animation_state == ANIMATIONS.EMERGE_OR_RECEDING then
			if worm.width > 2 then
				worm.width, worm.height = worm.width - 0.1, worm.height - 0.1
			else
				kill_entity(worm_uid)
				worm_uid = -1
				tongue_state = TONGUE_SEQUENCE.FINISH_RUMBLE
				tongue_tick = 10
			end
		end
	end

	if tongue_state == TONGUE_SEQUENCE.FINISH_RUMBLE then
		if tongue_tick > 0 then
			tongue_tick = tongue_tick - 1
		else
			-- Stop the rumble grumble
			if rumble_sound ~= nil then
				rumble_sound:stop()
			end
			rumble_sound = nil

			tongue_state = TONGUE_SEQUENCE.GONE
		end
	end

	--create particle effects on wormtongue during the states it exists in
	if tongue_state == TONGUE_SEQUENCE.READY
	or tongue_state == TONGUE_SEQUENCE.RUMBLE then
		if wormtongue_uid == -1 then
			message("wormtongue_uid is not expected to be -1 at this point!")
			return
		end
		local x, y, l = get_position(wormtongue_uid)
		if idle_tick > 0 then
			idle_tick = idle_tick - 1
		else
			for _ = 1, 3, 1 do
				if prng:random_chance(2, PRNG_CLASS.PARTICLES) then spawn_entity(ENT_TYPE.FX_WATER_DROP, x+((prng:random_float(PRNG_CLASS.PARTICLES)*1.5)-1), y+((prng:random_float(PRNG_CLASS.PARTICLES)*1.5)-1), l, 0, 0) end
			end
			-- message("WORMTONGUE IDLE PARTICLES")
			idle_tick = IDLE_TICK_TIMEOUT
		end
	end

	--animate worm on the states it exists in using animation library
	if tongue_state == TONGUE_SEQUENCE.EMERGE
	or tongue_state == TONGUE_SEQUENCE.RECEDE then
		if worm_uid == -1 then
			message("worm_uid not expected to be -1 at this point!")
			return
		end
		local worm = get_entity(worm_uid)
		if worm == nil
		or worm.animation_frame == nil
		or animation_state == nil
		or animation_timer == nil then
			return
		end
		local index = math.ceil(animation_timer / animation_state.frame_time)
		-- After the loop runs out it goes to index 0, which is wrong in lua
		message(string.format("Setting animation_frame %s using index %s", animation_state[index], index))
		worm.animation_frame = animation_state[index]
		animation_timer =
			animation_timer > 1
			and animation_timer - 1
			or animation_state.loop
				and animation_state.frames * animation_state.frame_time
				or 0
	end
end
-- If we don't stop the rumble sound in the timeout, we need to stop it here
set_callback(function()
	if rumble_sound ~= nil then
		rumble_sound:stop()
	end
	rumble_sound = nil
end, ON.SCREEN)
-- Fix having the wrong tileset on transition
set_callback(function()
    if state.screen == SCREEN.TRANSITION then
        if state.theme_next == THEME.EGGPLANT_WORLD then
            for _, v in ipairs(get_entities_by({ENT_TYPE.FLOOR_TUNNEL_NEXT, ENT_TYPE.FLOOR_TUNNEL_CURRENT}, MASK.ANY, LAYER.BOTH)) do
                local fx, fy, fl = get_position(v)
                local old_floor = get_entity(v)
                old_floor:remove()
                local new_floor = get_entity(spawn_on_floor(ENT_TYPE.FLOORSTYLED_GUTS, fx, fy, fl))
				new_floor.animation_frame = 31
				set_global_timeout(function()
					new_floor:decorate_internal()
				end, 1)
            end
			for _, v in ipairs(get_entities_by({ENT_TYPE.BG_DOOR}, MASK.ANY, LAYER.BOTH)) do
				local ent = get_entity(v)
				ent:set_texture(TEXTURE.DATA_TEXTURES_FLOOR_EGGPLANT_2)
			end
			for _, v in ipairs(get_entities_by({ENT_TYPE.BG_LEVEL_BACKWALL}, MASK.ANY, LAYER.BOTH)) do
				local ent = get_entity(v)
				ent:set_texture(TEXTURE.DATA_TEXTURES_BG_EGGPLANT_0)
			end
			for _, v in ipairs(get_entities_by({ENT_TYPE.MIDBG}, MASK.ANY, LAYER.BOTH)) do
				local ent = get_entity(v)
				ent:destroy()
			end
        end
    end
end, ON.POST_LOAD_SCREEN)

function module.create_wormtongue(x, y, l)
	local piece_uid = spawn_entity(ENT_TYPE.ITEM_STICKYTRAP_PIECE, x, y, l, 0, 0)
	local piece = get_entity(piece_uid)
    piece.flags = set_flag(piece.flags, ENT_FLAG.INVISIBLE)
	piece.flags = clr_flag(piece.flags, ENT_FLAG.INTERACT_WITH_WEBS)
	piece.flags = clr_flag(piece.flags, ENT_FLAG.CLIMBABLE)
    piece.flags = set_flag(piece.flags, ENT_FLAG.NO_GRAVITY)

	local lastpiece_uid = spawn_over(ENT_TYPE.ITEM_STICKYTRAP_LASTPIECE, piece.uid, 0, 0)
	local lastpiece = get_entity(lastpiece_uid)
    lastpiece.flags = set_flag(lastpiece.flags, ENT_FLAG.INVISIBLE)
	lastpiece.flags = clr_flag(lastpiece.flags, ENT_FLAG.INTERACT_WITH_WEBS)
	lastpiece.flags = clr_flag(lastpiece.flags, ENT_FLAG.CLIMBABLE)
    lastpiece.flags = set_flag(lastpiece.flags, ENT_FLAG.NO_GRAVITY)

	-- sticky part creation
	wormtongue_uid = spawn_over(ENT_TYPE.ITEM_STICKYTRAP_BALL, lastpiece.uid, 0, 0)
	local ball = get_entity(wormtongue_uid)
	ball.width = 1.35
	ball.height = 1.35
	ball.hitboxx = 0.3375
	ball.hitboxy = 0.3375

	lastpiece.flags = set_flag(lastpiece.flags, ENT_FLAG.INVISIBLE)
	lastpiece.flags = clr_flag(lastpiece.flags, ENT_FLAG.CLIMBABLE)
	lastpiece.user_data = {
		orig_x = 0; -- Original x position
		orig_y = -0.15; -- Original y position
		xelas = 0; -- A multiplier for the jiggle effect
		yelas = 0;
		counter = 0; -- Counts up, used for cos and sin functions
	}
	-- Cool elastic effect when an entity sticks onto the tongue
	lastpiece:set_post_update_state_machine(function(self --[[@as Movable]])
		--check if an entity is in the tongue
		local d = self.user_data
		for _, v in ipairs(get_entities_overlapping_hitbox(0, MASK.PLAYER | MASK.MONSTER | MASK.ITEM, get_hitbox(wormtongue_uid), self.layer)) do
			if v ~= wormtongue_uid
			and v ~= piece.uid
			and v ~= lastpiece.uid then
				local mons = get_entity(v) --[[@as Movable]]
				d.xelas = d.xelas + math.abs(mons.velocityx)*1.1
				d.yelas = d.yelas + math.abs(mons.velocityy)
				if d.xelas > 0.125 then d.xelas = 0.125 end
				if d.yelas > 0.125 then d.yelas = 0.125 end
				if test_flag(mons.flags, ENT_FLAG.INTERACT_WITH_WEBS) and (d.xelas > 0.1 or d.yelas > 0.1) and (
					mons.type.search_flags & MASK.PLAYER == 0 or (mons.input.buttons_gameplay & (INPUTS.LEFT | INPUTS.RIGHT) == 0) -- don't move further down if already will
					) then
					mons.y = mons.y - 0.01
				end
			end
		end
		-- Decrease counters and our cos and sin multipliers
		d.counter = d.counter + 0.36
		if d.xelas > 0 then
			d.xelas = d.xelas - 0.0075
		end
		if d.yelas > 0 then
			d.yelas = d.yelas - 0.0075
		end
		if d.xelas < 0.015 then
			d.xelas = 0
		end
		if d.yelas < 0.015 then
			d.yelas = 0
		end
		-- Jiggle effect
		local target_x = d.orig_x+math.cos(d.counter)*d.xelas
		local target_y = d.orig_y+math.sin(d.counter)*d.yelas
		local diff_x, diff_y = target_x - self.x, target_y - self.y
		self.velocityx, self.velocityy = diff_x, diff_y
		local ball = get_entity(wormtongue_uid)
		if ball then
			ball.velocityx, ball.velocityy = diff_x, diff_y --By applying velocity to the ball, it applies velocity to the entities on it, though it doesn't move, so move the last piece (overlay)
		end
	end)
	bg_uid = spawn_entity(ENT_TYPE.BG_LEVEL_DECO, x, y, l, 0, 0)
	local worm_background = get_entity(bg_uid)
	worm_background:set_texture(state.theme == THEME.JUNGLE and wormtongue_jungle_texture_id or wormtongue_ice_texture_id)
	worm_background.width, worm_background.height = 2, 2
	worm_background.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DECO_TONGUE][1]
	-- Change type to BG_DOOR to prevent it getting removed by beehive, not spawn it as BG_DOOR directly due do draw_depth problems (I've tried changing it later)
	worm_background.type = get_type(ENT_TYPE.BG_DOOR)

	local balltriggers = get_entities_by_type(ENT_TYPE.LOGICAL_SPIKEBALL_TRIGGER)
	for _, balltrigger in ipairs(balltriggers) do kill_entity(balltrigger) end
	
    animation_state = ANIMATIONS.EMERGE_OR_RECEDING
    animation_timer = ANIMATIONS.EMERGE_OR_RECEDING.frames * ANIMATIONS.EMERGE_OR_RECEDING.frame_time

	tongue_state = TONGUE_SEQUENCE.READY

	set_interval(onframe_tonguetimeout, 1)
end


-- debug
---@param draw_ctx GuiDrawContext
set_callback(function(draw_ctx)
	if options.hd_debug_worm_tongue_info == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		if state.level == 1 and (state.theme == THEME.JUNGLE or state.theme == THEME.ICE_CAVES) then
			local text_x = -0.95
			local text_y = -0.45
			local white = rgba(255, 255, 255, 255)
			
			local tongue_debugtext_sequence = "UNKNOWN"
			if tongue_state == TONGUE_SEQUENCE.READY then tongue_debugtext_sequence = "READY"
			elseif tongue_state == TONGUE_SEQUENCE.RUMBLE then tongue_debugtext_sequence = "RUMBLE"
			elseif tongue_state == TONGUE_SEQUENCE.EMERGE then tongue_debugtext_sequence = "EMERGE"
			elseif tongue_state == TONGUE_SEQUENCE.RECEDE then tongue_debugtext_sequence = "RECEDE"
			elseif tongue_state == TONGUE_SEQUENCE.FINISH_RUMBLE then tongue_debugtext_sequence = "FINISH_RUMBLE"
			elseif tongue_state == TONGUE_SEQUENCE.GONE then tongue_debugtext_sequence = "GONE" end
			draw_ctx:draw_text(text_x, text_y, 0, "Worm Tongue State: " .. tongue_debugtext_sequence, white)
			text_y = text_y-0.1
			
			local tongue_debugtext_uid = tostring(wormtongue_uid)
			if wormtongue_uid == nil then tongue_debugtext_uid = "nil" end
			draw_ctx:draw_text(text_x, text_y, 0, "Worm Tongue UID: " .. tongue_debugtext_uid, white)
			text_y = text_y-0.1
			
			local tongue_debugtext_tick = tostring(tongue_tick)
			if tongue_tick == nil then tongue_debugtext_tick = "nil" end
			draw_ctx:draw_text(text_x, text_y, 0, "Worm Tongue Acceptance tic: " .. tongue_debugtext_tick, white)
		end
	end
end, ON.GUIFRAME)


return module