local module = {}

local stone_door_texture_id
do
    local stone_door_texture_def = TextureDefinition.new()
    stone_door_texture_def.width = 386
    stone_door_texture_def.height = 640
    stone_door_texture_def.tile_width = 386
    stone_door_texture_def.tile_height = 320
    stone_door_texture_def.texture_path = "res/stone_doors.png"
    stone_door_texture_id = define_texture(stone_door_texture_def)
end

optionslib.register_option_bool("hd_debug_boss_exits_unlock", "Unlock boss exits", nil, false, true)

local HD_THEMEORDER = {
	THEME.DWELLING,
	THEME.JUNGLE,
	THEME.ICE_CAVES,
	THEME.TEMPLE,
	THEME.VOLCANA
}

local DOOR_EXIT_TO_HAUNTEDCASTLE_POS = nil
local DOOR_EXIT_TO_BLACKMARKET_POS = nil

function module.init()
	DOOR_EXIT_TO_HAUNTEDCASTLE_POS = nil
	DOOR_EXIT_TO_BLACKMARKET_POS = nil
end

local function hd_exit_levelhandling()
	-- local next_world, next_level, next_theme = state.world or 1, state.level or 1, state.theme or THEME.DWELLING
	local next_world, next_level, next_theme = state.world, state.level, state.theme

	if state.level < 4 then
		
		next_level = state.level + 1

		if state.theme == THEME.EGGPLANT_WORLD then
			next_level = 4
		elseif state.level == 3 then
			-- -- fake 1-4
			-- if state.theme == THEME.DWELLING then
			-- 	next_level = 5
			-- elseif
			if state.theme == THEME.TEMPLE or state.theme == THEME.CITY_OF_GOLD then
				return 4, 4, THEME.OLMEC
			end
		end
	else
		next_world = state.world + 1
		next_level = 1
	end
	next_theme = HD_THEMEORDER[next_world]

	return next_world, next_level, next_theme
end

function module.create_door_entrance(x, y, l)
	-- # create the entrance door at the specified game coordinates.
	local door_bg = spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0)
	if (
		feelingslib.feeling_check(feelingslib.FEELING_ID.HAUNTEDCASTLE) == true
		or (state.theme == THEME.TEMPLE and options.hd_og_floorstyle_temple)
	) then
		get_entity(door_bg):set_texture(stone_door_texture_id)
		get_entity(door_bg).animation_frame = 0
	end
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	if (
		test_flag(state.level_flags, 18) == true
		and state.theme ~= THEME.VOLCANA
	) then
		---@type Torch
		local ent = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_TORCH, x, y, l))
		ent:light_up(true)
	end
	-- assign coordinates to a global variable to define the game coordinates the player needs to be
	roomgenlib.global_levelassembly.entrance = {x = x, y = y}
	state.level_gen.spawn_x, state.level_gen.spawn_y = x, y
end

function module.create_door_exit(x, y, l)
	local door_target = spawn(ENT_TYPE.FLOOR_DOOR_EXIT, x, y, l, 0, 0)
	spawn_entity_over(ENT_TYPE.FX_COMPASS, door_target, 0, 0)
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	local door_bg = get_entity(spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0))
	if state.theme == THEME.TEMPLE and options.hd_og_floorstyle_temple then
		door_bg:set_texture(stone_door_texture_id)
	end
	door_bg.animation_frame = 1
	local _w, _l, _t = hd_exit_levelhandling()
	set_door_target(door_target, _w, _l, _t)
	-- spawn_door(x, y, l, state.world_next, state.level_next, state.theme_next)

	roomgenlib.global_levelassembly.exit = {x = x, y = y}
	
	-- local format_name = F'levelcode_bake_spawn(): Created Exit Door with targets: {state.world_next}, {state.level_next}, {state.theme_next}'
	-- message(format_name)
	if state.shoppie_aggro_next > 0 then
		local shopkeeper = get_entity(spawn_entity(ENT_TYPE.MONS_SHOPKEEPER, x, y, l, 0, 0))
		shopkeeper.is_patrolling = true
		-- shopkeeper.room_index(get_room_index(x, y)) -- fix this. Room index of shopkeeper value isn't in the same format as the value that get_rom_index outputs.
	end
end

function module.create_door_exit_moai(x, y, l)
	local door_target = spawn(ENT_TYPE.FLOOR_DOOR_EXIT, x, y, l, 0, 0)
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	local door_bg = spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0)
	get_entity(door_bg).animation_frame = 1
	local _w, _l, _t = hd_exit_levelhandling()
	set_door_target(door_target, _w, _l, _t)
	roomgenlib.global_levelassembly.moai_exit = {x = x, y = y}
end

function module.create_door_exit_to_hell(x, y, l)
	local door_target = spawn(ENT_TYPE.FLOOR_DOOR_EGGPLANT_WORLD, x, y, l, 0, 0)
	set_door_target(door_target, 5, 1, THEME.VOLCANA)
	
	local locked_for_demo = not (5 <= demolib.DEMO_MAX_WORLD or options.hd_debug_demo_enable_all_worlds)
	if locked_for_demo then
		local construction_sign = get_entity(spawn_entity(ENT_TYPE.ITEM_CONSTRUCTION_SIGN, x, y, l, 0, 0))
		construction_sign:set_draw_depth(40)
		construction_sign.flags = set_flag(construction_sign.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
	end

	if botdlib.HAS_BOOKOFDEAD == true and not locked_for_demo then
		local helldoor_e = get_entity(door_target)
		helldoor_e.flags = set_flag(helldoor_e.flags, ENT_FLAG.ENABLE_BUTTON_PROMPT)
		helldoor_e.flags = clr_flag(helldoor_e.flags, ENT_FLAG.LOCKED)
	end
end

-- creates mothership entrance
function module.create_door_exit_to_mothership(x, y, l)
	-- _door_uid = spawn_door(x, y, l, 3, 3, THEME.NEO_BABYLON)
	local door_target = spawn(ENT_TYPE.FLOOR_DOOR_EXIT, x, y, l, 0, 0)
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	local door_bg = spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0)
	get_entity(door_bg):set_texture(TEXTURE.DATA_TEXTURES_FLOOR_BABYLON_1)
	get_entity(door_bg).animation_frame = 1
	set_door_target(door_target, 3, 3, THEME.NEO_BABYLON)
end

local function entrance_force_feeling(_feeling_to_force)
	local x, y = nil, nil
	if _feeling_to_force == feelingslib.FEELING_ID.BLACKMARKET and DOOR_EXIT_TO_BLACKMARKET_POS ~= nil then
		x, y = DOOR_EXIT_TO_BLACKMARKET_POS.x, DOOR_EXIT_TO_BLACKMARKET_POS.y
	elseif _feeling_to_force == feelingslib.FEELING_ID.HAUNTEDCASTLE and DOOR_EXIT_TO_HAUNTEDCASTLE_POS ~= nil then
		x, y = DOOR_EXIT_TO_HAUNTEDCASTLE_POS.x, DOOR_EXIT_TO_HAUNTEDCASTLE_POS.y
	end

	if x ~= nil and y ~= nil then
		local door_exits_here = get_entities_at(0, ENT_TYPE.FLOOR_DOOR_EXIT, x, y, LAYER.FRONT, 0.5)
		local door_spawned =  #door_exits_here ~= 0
		local door_exit_ent = door_spawned == true and get_entity(door_exits_here[1]) or nil
		local floor_removed = #get_entities_at(0, MASK.FLOOR, x, y, LAYER.FRONT, 0.5) == 0

		if floor_removed == true and door_spawned == false then
			local door_target = spawn(ENT_TYPE.FLOOR_DOOR_EXIT, x, y, LAYER.FRONT, 0, 0)
			local _w, _l, _t = hd_exit_levelhandling()
			set_door_target(door_target, _w, _l, _t)

			local sound = get_sound(VANILLA_SOUND.UI_SECRET)
			if sound ~= nil then sound:play() end

			door_spawned = true -- for those who can frame-perfect :spelunkoid:
			door_exit_ent = get_entity(door_target)
		end
		if door_spawned == true then
			for i = 1, #players, 1 do
				if (
					door_exit_ent:overlaps_with(get_entity(players[i].uid)) == true and
					players[i].state == CHAR_STATE.ENTERING
				) then
					feelingslib.feeling_set_once(_feeling_to_force, {state.level+1})
					break;
				end
			end
		end
	end
end

local function entrance_blackmarket()
	entrance_force_feeling(feelingslib.FEELING_ID.BLACKMARKET)
end

local function entrance_hauntedcastle()
	entrance_force_feeling(feelingslib.FEELING_ID.HAUNTEDCASTLE)
end

-- creates blackmarket entrance
function module.create_door_exit_to_blackmarket(x, y, l)
	spawn_entity(ENT_TYPE.LOGICAL_BLACKMARKET_DOOR, x, y, l, 0, 0)
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	local door_bg = spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0)
	-- get_entity(door_bg):set_texture(TEXTURE.DATA_TEXTURES_FLOOR_JUNGLE_1)
	get_entity(door_bg).animation_frame = 1
	DOOR_EXIT_TO_BLACKMARKET_POS = {x = x, y = y}
	set_interval(entrance_blackmarket, 1)
end

function module.create_door_exit_to_hauntedcastle(x, y, l)
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	local door_bg = spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0)
	get_entity(door_bg):set_texture(stone_door_texture_id)
	get_entity(door_bg).animation_frame = 1
	DOOR_EXIT_TO_HAUNTEDCASTLE_POS = {x = x, y = y}
	set_interval(entrance_hauntedcastle, 1)
end

function module.create_door_ending(x, y, l)
	-- # TODO: Remove exit door from the editor and spawn it manually here.
	-- Why? Currently the exit door spawns tidepool-specific critters and ambience sounds, which will probably go away once an exit door isn't there initially.
	-- ALTERNATIVE: kill ambient entities and critters. May allow compass to work.
	local door = spawn_entity(ENT_TYPE.FLOOR_DOOR_EXIT, x, y, l, 0, 0)
	local door_bg = spawn_entity(ENT_TYPE.BG_DOOR, x, y+0.31, l, 0, 0)
	if options.hd_debug_boss_exits_unlock then
		get_entity(door_bg).animation_frame = 1
	else
		lock_door_at(x, y)
	end
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, l, 0, 0)
	
	roomgenlib.global_levelassembly.exit = {x = x, y = y}

	return door
end

return module