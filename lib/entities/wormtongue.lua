local module = {}

optionslib.register_option_bool("hd_debug_worm_tongue_info", "Worm tongue - Show info", nil, false, true)

local ANIMATION_FRAMES_ENUM = {
    WORM = 1,
	DECO_HOLE = 2,
	DECO_TONGUE = 3,
}

local ANIMATION_FRAMES_RES = {
    { 0, 1, 2, 3 },
    { 0 },
    { 0 },
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


local WORMTONGUE_UID = nil
local WORMTONGUE_BG_UID = nil
local WORM_UID = nil
local TONGUE_ACCEPTTIME = 200
local tongue_tick = TONGUE_ACCEPTTIME
local TONGUE_SEQUENCE = { ["READY"] = 1, ["RUMBLE"] = 2, ["EMERGE"] = 3, ["SWALLOW"] = 4 , ["GONE"] = 5 }
local TONGUE_STATE = nil
local TONGUE_STATECOMPLETE = false
local WORMTONGUE_RUMBLE_SOUND = nil -- Refers to a looped sound that we need to stop either on a new screen or shortly after the worm leaves

function module.init()
	WORMTONGUE_UID = nil
	WORMTONGUE_BG_UID = nil
	WORM_UID = nil
	TONGUE_STATE = nil
	TONGUE_STATECOMPLETE = false
	tongue_tick = TONGUE_ACCEPTTIME
end

local function tongue_idle()
	if (
		(
			state.theme == THEME.JUNGLE
			or state.theme == THEME.ICE_CAVES
		)
		and WORMTONGUE_UID ~= nil
		and (
			TONGUE_STATE == TONGUE_SEQUENCE.READY
			or TONGUE_STATE == TONGUE_SEQUENCE.RUMBLE
		)
	) then
		local x, y, l = get_position(WORMTONGUE_UID)
		for _ = 1, 3, 1 do
			if prng:random_chance(2, PRNG_CLASS.PARTICLES) then spawn_entity(ENT_TYPE.FX_WATER_DROP, x+((prng:random_float(PRNG_CLASS.PARTICLES)*1.5)-1), y+((prng:random_float(PRNG_CLASS.PARTICLES)*1.5)-1), l, 0, 0) end
		end
	end
end


local function tongue_exit()
	local x, y, l = get_position(WORMTONGUE_UID)
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
	
	-- hide worm tongue
	local tongue = get_entity(WORMTONGUE_UID)
	if options.hd_debug_scripted_enemies_show == false then
		tongue.flags = set_flag(tongue.flags, ENT_FLAG.INVISIBLE)
	end
	tongue.flags = set_flag(tongue.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)-- disable interaction with objects
end

local function onframe_tonguetimeout()
	if WORMTONGUE_UID ~= nil and TONGUE_STATE ~= TONGUE_SEQUENCE.GONE then
		local tongue = get_entity(WORMTONGUE_UID)
		local x, y, l = get_position(WORMTONGUE_UID)
		local checkradius = 1.5
		
		if tongue ~= nil and TONGUE_STATECOMPLETE == false then
			if TONGUE_STATE == TONGUE_SEQUENCE.READY then
				local damsels = get_entities_at({ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_HAMSTER}, 0, x, y, l, checkradius)
				if #damsels > 0 then
					local damsel = get_entity(damsels[1])
					local stuck_in_web = test_flag(damsel.more_flags, 8)
					if (
						(stuck_in_web == true)
					) then
						if tongue_tick <= 0 then
							TONGUE_STATE = TONGUE_SEQUENCE.RUMBLE
						else
							tongue_tick = tongue_tick - 1
						end
					else
						tongue_tick = TONGUE_ACCEPTTIME
					end
				end
			elseif TONGUE_STATE == TONGUE_SEQUENCE.RUMBLE then
				-- Start the rumble sound and shake screen
				if WORMTONGUE_RUMBLE_SOUND == nil then
					commonlib.shake_camera(180, 180, 3, 3, 3, false)
					WORMTONGUE_RUMBLE_SOUND = commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_WARN_LOOP, WORMTONGUE_UID, 1, false)
				end
				set_timeout(function()
					if WORMTONGUE_BG_UID ~= nil and get_entity(WORMTONGUE_BG_UID) ~= nil then
						local worm_background = get_entity(WORMTONGUE_BG_UID)
						worm_background:set_texture(state.theme == THEME.JUNGLE and hole_jungle_texture_id or hole_ice_texture_id)
						worm_background.width, worm_background.height = 4, 4
						worm_background.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DECO_HOLE][1]
					else message("WORMTONGUE_BG_UID is nil :(") end
					
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
						if (
							entity_type ~= ENT_TYPE.FLOOR_STICKYTRAP_CEILING
							and entity_type ~= ENT_TYPE.FLOOR_BORDERTILE
						) then
							kill_entity(block_uid)
						end
					end

					local worm = get_entity(spawn_entity(ENT_TYPE.BG_LEVEL_DECO, x, y, l, 0, 0))
					worm:set_texture(worm_texture_id)
					WORM_UID = worm.uid

					commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE, WORM_UID, 1, false)
					commonlib.shake_camera(20, 20, 12, 12, 12, false)

					-- animate worm
					worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][4]
					worm.width, worm.height = 2, 2
					set_interval(function()
						if WORM_UID ~= nil then
							local worm = get_entity(WORM_UID)
							if worm ~= nil then
								if worm.width >= 4 then
									if worm.animation_frame == ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][4] then
										worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][3]
									elseif worm.animation_frame == ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][3] then
										worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][2]
									elseif worm.animation_frame == ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][2] then
										worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][1]
									else
										return false
									end
								else
									worm.width, worm.height = worm.width + 0.08, worm.height + 0.08
								end
							end
						end
					end, 1)

					TONGUE_STATE = TONGUE_SEQUENCE.EMERGE
					TONGUE_STATECOMPLETE = false
				end, 65)
				TONGUE_STATECOMPLETE = true
			elseif TONGUE_STATE == TONGUE_SEQUENCE.EMERGE then
				set_timeout(function() -- level exit should activate here
					tongue_exit()
					
					-- animate worm
					set_interval(function()
						if WORM_UID ~= nil then
							local worm = get_entity(WORM_UID)
							if worm ~= nil then
								if worm.animation_frame == ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][1] then
									worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][2]
								elseif worm.animation_frame == ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][2] then
									worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][3]
								elseif worm.animation_frame == ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][3] then
									worm.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.WORM][4]
								else
									if worm.width > 2 then
										worm.width, worm.height = worm.width - 0.1, worm.height - 0.1
									else
										kill_entity(WORM_UID)
										WORM_UID = nil
										return false
									end
								end
							end
						end
					end, 1)
					

					TONGUE_STATE = TONGUE_SEQUENCE.SWALLOW
					TONGUE_STATECOMPLETE = false
				end, 40)
				TONGUE_STATECOMPLETE = true
			elseif TONGUE_STATE == TONGUE_SEQUENCE.SWALLOW then
				-- Quick fix: the player can become visible again during this sequence if they have iFrames during it, so let's keep setting them to invisible to avoid this
				local ensnaredplayers = get_entities_at(0, 0x1, x, y, l, checkradius)
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
				set_timeout(function()
					
					local wormtongue = get_entity(WORMTONGUE_UID)
					wormtongue.flags = set_flag(wormtongue.flags, ENT_FLAG.DEAD)
					wormtongue:destroy()
					-- kill_entity(WORMTONGUE_UID)
					WORMTONGUE_UID = nil

					TONGUE_STATE = TONGUE_SEQUENCE.GONE
				end, 40)
				set_timeout(function()
					-- Stop the rumble grumble
					if WORMTONGUE_RUMBLE_SOUND ~= nil then
						WORMTONGUE_RUMBLE_SOUND:stop()
					end			
					WORMTONGUE_RUMBLE_SOUND = nil
				end, 50)

				TONGUE_STATECOMPLETE = true
				
				return false
			end
		end
	end
end
-- If we don't stop the rumble sound in the timeout, we need to stop it here
set_callback(function()
	if WORMTONGUE_RUMBLE_SOUND ~= nil then
		WORMTONGUE_RUMBLE_SOUND:stop()
	end
	WORMTONGUE_RUMBLE_SOUND = nil
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
	-- message("created wormtongue:")
	set_interval(tongue_idle, 15)
	set_interval(onframe_tonguetimeout, 1)
	-- currently using level generation to place stickytraps
	local stickytrap_uid = spawn_entity(ENT_TYPE.FLOOR_STICKYTRAP_CEILING, x, y, l, 0, 0)
	local sticky = get_entity(stickytrap_uid)
	sticky.flags = set_flag(sticky.flags, ENT_FLAG.INVISIBLE)
	sticky.flags = clr_flag(sticky.flags, ENT_FLAG.SOLID)
	move_entity(stickytrap_uid, x, y+1.15, 0, 0) -- avoids breaking surfaces by spawning trap on top of them

	local ball_uid = get_entities_by_type(ENT_TYPE.ITEM_STICKYTRAP_BALL)[1] -- HAH ball
	if ball_uid == -1 then
		message("No STICKYTRAP_BALL found, no tongue generated.")
		kill_entity(stickytrap_uid)
		TONGUE_STATE = TONGUE_SEQUENCE.GONE
		return
	end
	local ballstem_uid = get_entities_by(ENT_TYPE.ITEM_STICKYTRAP_LASTPIECE, MASK.ITEM, LAYER.FRONT)[1]
	local ballstem = get_entity(ballstem_uid)
	ballstem.flags = set_flag(ballstem.flags, ENT_FLAG.INVISIBLE)
	ballstem.flags = clr_flag(ballstem.flags, ENT_FLAG.CLIMBABLE)
	ballstem.user_data = {
		orig_x = 0; -- Original x position
		orig_y = -0.15; -- Original y position
		xelas = 0; -- A multiplier for the jiggle effect
		yelas = 0;
		counter = 0; -- Counts up, used for cos and sin functions
	}
	-- Cool elastic effect when an entity sticks onto the tongue
	ballstem:set_post_update_state_machine(function(self --[[@as Movable]])
		--check if an entity is in the tongue
		local d = self.user_data
		for _, v in ipairs(get_entities_overlapping_hitbox(0, MASK.PLAYER | MASK.MONSTER | MASK.ITEM, get_hitbox(ball_uid), self.layer)) do
			if v ~= ball_uid then
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
		local ball = get_entity(ball_uid)
		if ball then
			ball.velocityx, ball.velocityy = diff_x, diff_y --By applying velocity to the ball, it applies velocity to the entities on it, though it doesn't move, so move the last piece (overlay)
		end
	end)
	-- sticky part creation
	local ball = get_entity(ball_uid)
	ball.width = 1.35
	ball.height = 1.35
	ball.hitboxx = 0.3375
	ball.hitboxy = 0.3375
	WORMTONGUE_UID = ball.uid -- HAHA tongue and balls

	local worm_background = get_entity(spawn_entity(ENT_TYPE.BG_LEVEL_DECO, x, y, l, 0, 0))
	worm_background:set_texture(state.theme == THEME.JUNGLE and wormtongue_jungle_texture_id or wormtongue_ice_texture_id)
	worm_background.width, worm_background.height = 2, 2
	worm_background.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DECO_TONGUE][1]
	-- Change type to BG_DOOR to prevent it getting removed by beehive, not spawn it as BG_DOOR directly due do draw_depth problems (I've tried changing it later)
	worm_background.type = get_type(ENT_TYPE.BG_DOOR)
	WORMTONGUE_BG_UID = worm_background.uid

	local balltriggers = get_entities_by_type(ENT_TYPE.LOGICAL_SPIKEBALL_TRIGGER)
	for _, balltrigger in ipairs(balltriggers) do kill_entity(balltrigger) end

	TONGUE_STATE = TONGUE_SEQUENCE.READY
end


-- debug
---@param draw_ctx GuiDrawContext
set_callback(function(draw_ctx)
	if options.hd_debug_worm_tongue_info == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		if state.level == 1 and (state.theme == THEME.JUNGLE or state.theme == THEME.ICE_CAVES) then
			local text_x = -0.95
			local text_y = -0.45
			local white = rgba(255, 255, 255, 255)
			
			-- TONGUE_SEQUENCE = { ["READY"] = 1, ["RUMBLE"] = 2, ["EMERGE"] = 3, ["SWALLOW"] = 4 , ["GONE"] = 5 }
			local tongue_debugtext_sequence = "UNKNOWN"
			if TONGUE_STATE == TONGUE_SEQUENCE.READY then tongue_debugtext_sequence = "READY"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.RUMBLE then tongue_debugtext_sequence = "RUMBLE"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.EMERGE then tongue_debugtext_sequence = "EMERGE"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.SWALLOW then tongue_debugtext_sequence = "SWALLOW"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.GONE then tongue_debugtext_sequence = "GONE" end
			draw_ctx:draw_text(text_x, text_y, 0, "Worm Tongue State: " .. tongue_debugtext_sequence, white)
			text_y = text_y-0.1
			
			local tongue_debugtext_uid = tostring(WORMTONGUE_UID)
			if WORMTONGUE_UID == nil then tongue_debugtext_uid = "nil" end
			draw_ctx:draw_text(text_x, text_y, 0, "Worm Tongue UID: " .. tongue_debugtext_uid, white)
			text_y = text_y-0.1
			
			local tongue_debugtext_tick = tostring(tongue_tick)
			if tongue_tick == nil then tongue_debugtext_tick = "nil" end
			draw_ctx:draw_text(text_x, text_y, 0, "Worm Tongue Acceptance tic: " .. tongue_debugtext_tick, white)
		end
	end
end, ON.GUIFRAME)


return module