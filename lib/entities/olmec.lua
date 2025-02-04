local scorpionflylib = require 'lib.entities.scorpionfly'
local snaillib = require 'lib.entities.snail'
local hawkmanlib = require 'lib.entities.hawkman'

local module = {}

local HELL_Y = 86

local BOSS_SEQUENCE = { ["CUTSCENE"] = 1, ["FIGHT"] = 2, ["DEAD"] = 3 }
local BOSS_STATE = nil

local OLMEC_UID = nil
local OLMEC_SEQUENCE = { ["STILL"] = 1, ["FALL"] = 2 }
local OLMEC_STATE = 0

local HAWKMAN_UID = nil
local THREW_HAWKMAN = false

module.DOOR_ENDGAME_OLMEC_UID = nil

function module.init()
	BOSS_STATE = nil

	OLMEC_UID = nil
	OLMEC_STATE = 0

	HAWKMAN_UID = nil
	THREW_HAWKMAN = false

	module.DOOR_ENDGAME_OLMEC_UID = nil
end


local function cutscene_arrange_olmec_pre()
	local olmecs = get_entities_by_type(ENT_TYPE.ACTIVEFLOOR_OLMEC)
	if #olmecs > 0 then
		OLMEC_UID = olmecs[1]
		move_entity(OLMEC_UID, 24.500, 99.500, 0, 0)
	end
	local olmec_cutscene_skins = get_entities_by_type(ENT_TYPE.FX_OLMECPART_LARGE)
	if #olmec_cutscene_skins then
		get_entity(olmec_cutscene_skins[1]):set_post_update_state_machine(function (self)
			if self.animation_frame == 2 and not THREW_HAWKMAN then
				---@type Entity | Movable
				local hawkman = get_entity(HAWKMAN_UID)
				hawkman:stun(600)
				hawkman.velocityx = -0.15
				hawkman.velocityy = 0.20
				THREW_HAWKMAN = true
				hawkmanlib.set_state_vanilla(hawkman)
			end
		end)
	end
end

local function set_post_cutscene_hawkman()
	---@type Movable
	local ent = get_entity(HAWKMAN_UID)
	ent:stun(300)
	THREW_HAWKMAN = true
	hawkmanlib.set_state_vanilla(ent)
end

local function cutscene_move_hawkman_post()
	move_entity(HAWKMAN_UID, 15.475, 98.050, 0, 0)
end

local function cutscene_move_olmec_post()
	move_entity(OLMEC_UID, 22.500, 98.500, 0, 0)
end

local function cutscene_arrange_worshipers()
	local cavemen = get_entities_by_type(ENT_TYPE.MONS_CAVEMAN)
	for i = 1, #cavemen, 1 do
		local caveman = get_entity(cavemen[i])
		move_entity(caveman.uid, 17.500+i, 98.05, 0, 0)--99.05, 0, 0)
		caveman.move_state = 1
		caveman.animation_frame = 64

		-- prevent these cavemen from picking anything up during the cutscene

		local held_item = get_entity(caveman.holding_uid)
		if held_item ~= nil then
			drop(caveman.uid, held_item.uid)
		end
		---@type self Caveman
		caveman:set_post_update_state_machine(function (self)
			self.can_pick_up_timer = 10
			self.cooldown_timer = -1
			if self.move_state == 2 then
				self.move_state = 1
			end
		end)
	end
	HAWKMAN_UID = hawkmanlib.create_hawkman(22.0, 98.05, LAYER.FRONT)
	local hawkman = get_entity(HAWKMAN_UID)
	if not test_flag(hawkman.flags, ENT_FLAG.FACING_LEFT) then
		flip_entity(hawkman.uid)
	end
	hawkmanlib.set_state_worship(hawkman)
end

function module.onlevel_olmec_init()
	if state.theme == THEME.OLMEC then
		BOSS_STATE = BOSS_SEQUENCE.CUTSCENE
		cutscene_arrange_olmec_pre()
		cutscene_arrange_worshipers()

		olmeclib.DOOR_ENDGAME_OLMEC_UID = doorslib.create_door_ending(41, 98, LAYER.FRONT)

		botdlib.set_hell_x()
		doorslib.create_door_exit_to_hell(botdlib.hell_x, HELL_Y, LAYER.FRONT)
	end
end

local function onframe_olmec_cutscene() -- **Move to set_interval() that you can close later
	local c_logics = get_entities_by_type(ENT_TYPE.LOGICAL_CINEMATIC_ANCHOR)
	if #c_logics > 0 then
		local c_logics_e = get_entity(c_logics[1])
		local dead = test_flag(c_logics_e.flags, ENT_FLAG.DEAD)
		if dead == true then
			-- If you skip the cutscene before olmec smashes the blocks, this will teleport him outside of the map and crash.
			-- kill the blocks olmec would normally smash.
			for b = 1, 4, 1 do
				local blocks = get_entities_at({ENT_TYPE.FLOORSTYLED_STONE, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK}, 0, 21+b, 97, LAYER.FRONT, 0.5)--98, LAYER.FRONT, 0.5)
				if #blocks > 0 then
					kill_entity(blocks[1])
				end
				b = b + 1
			end
			cutscene_move_olmec_post()
			cutscene_move_hawkman_post()
			set_post_cutscene_hawkman()
			BOSS_STATE = BOSS_SEQUENCE.FIGHT
			custommusiclib.play_boss_music()
		end
	end
end

replace_drop(DROP.TIAMAT_BAT, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_BEE, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_CAVEMAN, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_COBRA, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_HERMITCRAB, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_MONKEY, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_MOSQUITO, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_OCTOPUS, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_OLMITE, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_SCORPION, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_SNAKE, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_UFO, ENT_TYPE.FX_SHADOW)
replace_drop(DROP.TIAMAT_YETI, ENT_TYPE.FX_SHADOW)

local function olmec_attack(x, y, l)
	local type = ENT_TYPE.ITEM_TIAMAT_SHOT
	---@type TiamatShot
	local entity = get_entity(spawn(type, x, y, l, 0, 150))
	entity.flags = set_flag(entity.flags, ENT_FLAG.COLLIDES_WALLS)
	entity.flags = clr_flag(entity.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
	entity.flags = clr_flag(entity.flags, ENT_FLAG.NO_GRAVITY)

	local set_velocity
	set_timeout(function ()
		---@param entity Movable
		set_post_statemachine(entity.uid, function (entity)
			if not set_velocity then

				local xvel = prng:random_int(7, 30, PRNG_CLASS.PARTICLES)/100
				if prng:random_chance(2, PRNG_CLASS.PARTICLES) then xvel = -xvel end
				entity.velocityx = xvel
				entity.velocityy = prng:random_int(5, 10, PRNG_CLASS.PARTICLES)/100

				-- message("Olmec behavior 'YEET' velocityx: " .. tostring(entity.velocityx))
				set_velocity = true
			end
			if (entity.standing_on_uid ~= -1) then
				kill_entity(entity.uid)
			end
		end)
	end, 40)
	entity:set_post_kill(function (entity)
		local chance = prng:random_int(1, 6, PRNG_CLASS.AI)
		x, y, l = get_position(entity.uid)
		if chance == 1 then
			if prng:random_chance(8, PRNG_CLASS.AI) then
				spawn_entity(ENT_TYPE.MONS_COBRA, x, y, l, 0, 0)
			else
				spawn_entity(ENT_TYPE.MONS_SNAKE, x, y, l, 0, 0)
			end
		elseif chance == 2 then
			spawn_entity(ENT_TYPE.MONS_SPIDER, x, y, l, 0, 0)
		elseif chance == 3 then
			if prng:random_chance(8, PRNG_CLASS.AI) then
				spawn_entity(ENT_TYPE.MONS_BEE, x, y, l, 0, 0)
			else
				spawn_entity(ENT_TYPE.MONS_BAT, x, y, l, 0, 0)
			end
		elseif chance == 4 then
			if prng:random_chance(8, PRNG_CLASS.AI) then
				spawn_entity(ENT_TYPE.MONS_FIREFROG, x, y, l, 0, 0)
			else
				spawn_entity(ENT_TYPE.MONS_FROG, x, y, l, 0, 0)
			end
		elseif chance == 5 then
			spawn_entity(ENT_TYPE.MONS_MONKEY, x, y, l, 0, 0)
		elseif chance == 6 then
			if prng:random_chance(8, PRNG_CLASS.AI) then
				if prng:random_chance(4, PRNG_CLASS.AI) then
					scorpionflylib.create_scorpionfly(x, y, l)
				else
					spawn_entity(ENT_TYPE.MONS_SCORPION, x, y, l, 0, 0)
				end
			else
				snaillib.create_snail(x, y, l)
			end
		end
		commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_SORCERESS_ATK_SPAWN, entity.uid, 1, false)
	end)
end


local has_hit_floor = false
local function onframe_olmec_behavior()
	---@type Olmec
	local olmec = get_entity(OLMEC_UID)
	if olmec ~= nil then
		-- Enemy Spawning: Detect when olmec is about to smash down
		-- set has_hit_floor when olmec's move_state goes from 4 to 0
		local move_state = get_entity(OLMEC_UID).move_state
		if move_state == 0 and OLMEC_STATE == OLMEC_SEQUENCE.FALL then
			OLMEC_STATE = OLMEC_SEQUENCE.STILL
			local x, y, l = get_position(OLMEC_UID)
			if prng:random_chance(3, PRNG_CLASS.PARTICLES) then
				commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_TIAMAT_SCEPTER, OLMEC_UID, 1, false)
				olmec_attack(x, y+2, l)
				olmec_attack(x, y+2, l)
				olmec_attack(x, y+2, l)
			end
		elseif move_state == 4 then
			OLMEC_STATE = OLMEC_SEQUENCE.FALL
		end
	end
end

local function onframe_boss_wincheck()
	if BOSS_STATE == BOSS_SEQUENCE.FIGHT then
		---@type Olmec
		local olmec = get_entity(OLMEC_UID)
		if olmec ~= nil then
			if olmec.attack_phase == 3 then
				local sound = get_sound(VANILLA_SOUND.UI_SECRET)
				if sound ~= nil then sound:play() end
				BOSS_STATE = BOSS_SEQUENCE.DEAD
				local _olmec_door = get_entity(module.DOOR_ENDGAME_OLMEC_UID)
				_olmec_door.flags = set_flag(_olmec_door.flags, ENT_FLAG.ENABLE_BUTTON_PROMPT)
				local _x, _y, _ = get_position(module.DOOR_ENDGAME_OLMEC_UID)
				-- unlock_door_at(41, 99)
				unlock_door_at(_x, _y)
			end
		end
	end
end

set_callback(function()
	if state.theme == THEME.OLMEC then
		if OLMEC_UID then
			if BOSS_STATE == BOSS_SEQUENCE.CUTSCENE then
				onframe_olmec_cutscene()
			elseif BOSS_STATE == BOSS_SEQUENCE.FIGHT then
				onframe_olmec_behavior()
				onframe_boss_wincheck()
			end
		end
	end
end, ON.FRAME)

---@param draw_ctx GuiDrawContext
set_callback(function(draw_ctx)
	if options.hd_debug_info_boss == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		if state.theme == THEME.OLMEC and OLMEC_UID ~= nil then
			---@type Olmec
			local olmec = get_entity(OLMEC_UID)
			local text_x = -0.95
			local text_y = -0.50
			local white = rgba(255, 255, 255, 255)
			if olmec ~= nil then
				local olmec_attack_state = "UNKNOWN"
				if OLMEC_STATE == OLMEC_SEQUENCE.STILL then olmec_attack_state = "STILL"
				elseif OLMEC_STATE == OLMEC_SEQUENCE.FALL then olmec_attack_state = "FALL" end
				
				-- BOSS_SEQUENCE = { ["CUTSCENE"] = 1, ["FIGHT"] = 2, ["DEAD"] = 3 }
				local boss_attack_state = "UNKNOWN"
				if BOSS_STATE == BOSS_SEQUENCE.CUTSCENE then boss_attack_state = "CUTSCENE"
				elseif BOSS_STATE == BOSS_SEQUENCE.FIGHT then boss_attack_state = "FIGHT"
				elseif BOSS_STATE == BOSS_SEQUENCE.DEAD then boss_attack_state = "DEAD" end
				
				draw_ctx:draw_text(text_x, text_y, 0, "OLMEC_STATE: " .. olmec_attack_state, white)
				text_y = text_y - 0.1
				draw_ctx:draw_text(text_x, text_y, 0, "BOSS_STATE: " .. boss_attack_state, white)
			else draw_ctx:draw_text(text_x, text_y, 0, "olmec is nil", white) end
		end
	end
end, ON.GUIFRAME)

set_callback(function()
	force_olmec_phase_0(true)
end, ON.LOGO)

return module