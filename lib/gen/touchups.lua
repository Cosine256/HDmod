local removelib = require 'lib.spawning.remove'

local module = {}

optionslib.register_option_bool("hd_og_cursepot_enable", "OG: Enable curse pot spawning", nil, false) -- Defaults to HD
optionslib.register_option_bool("hd_debug_magmar_spawn_enable", "Level gen - Initialize magmar spawn logic", nil, true, true)

local function onlevel_create_impostorlake()
	if feelingslib.feeling_check(feelingslib.FEELING_ID.RUSHING_WATER) then
		local x, y = 22.5, 88.5--80.5
		local w, h = 40, 12
		spawn_impostor_lake(
			AABB:new(
				x-(w/2),
				y+(h/2),
				x+(w/2),
				y-(h/2)
			),
			LAYER.FRONT, ENT_TYPE.LIQUID_IMPOSTOR_LAKE, 1.0
		)
	end
end

local function onlevel_removeborderfloor()
	if (
		state.theme == THEME.NEO_BABYLON
		-- or state.theme == THEME.OLMEC -- Lava touching the void ends up in a crash
	) then
		local xmin, _, xmax, ymax = get_bounds()
		for yi = ymax-0.5, (ymax-0.5)-2, -1 do
			for xi = xmin+0.5, xmax-0.5, 1 do
				local uid = get_grid_entity_at(xi, yi, LAYER.FRONT)
				if uid ~= -1 then get_entity(uid):destroy() end
			end
		end
	end
end

set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
		if state.theme == THEME.NEO_BABYLON then
			return spawn_grid_entity(ENT_TYPE.FLOORSTYLED_MOTHERSHIP, x, y, layer)
		elseif state.theme == THEME.EGGPLANT_WORLD then
			return spawn_grid_entity(ENT_TYPE.FLOORSTYLED_GUTS, x, y, layer)
		elseif state.theme == THEME.TEMPLE and options.hd_og_floorstyle_temple then
			return spawn_grid_entity(ENT_TYPE.FLOORSTYLED_STONE, x, y, layer)
		end
	end
end, SPAWN_TYPE.LEVEL_GEN_FLOOR_SPREADING, MASK.FLOOR, {ENT_TYPE.FLOOR_GENERIC, ENT_TYPE.FLOORSTYLED_TEMPLE})


local function onlevel_replace_border_textures()
	if (
		state.theme == THEME.EGGPLANT_WORLD
		or state.theme == THEME.VOLCANA
	) then
		
		local texture_def = get_texture_definition(TEXTURE.DATA_TEXTURES_BORDER_MAIN_0)
		if state.theme == THEME.EGGPLANT_WORLD then
			texture_def.texture_path = "res/worm_border.png"
		elseif state.theme == THEME.VOLCANA then
			texture_def.texture_path = "res/hell_border.png"
		end
		local boneder_texture = define_texture(texture_def)

		local bonebordere = get_entities_by_type(ENT_TYPE.FLOOR_BORDERTILE) -- get all entities of these types
		for _, boneborder_uid in pairs(bonebordere) do 
			get_entity(boneborder_uid):set_texture(boneder_texture)

			local boneborderdecoratione = entity_get_items_by(boneborder_uid, ENT_TYPE.DECORATION_BORDER, 0)
			for _, boneborderdecoration_uid in pairs(boneborderdecoratione) do
				get_entity(boneborderdecoration_uid):set_texture(boneder_texture)
			end
		end
	end
end

local function onlevel_remove_cursedpot()
	if not options.hd_og_cursepot_enable then
		local cursedpot_uids = get_entities_by_type(ENT_TYPE.ITEM_CURSEDPOT)
		for _, uid in pairs(cursedpot_uids) do
			local pot = get_entity(uid)
			if pot then
				pot.flags = set_flag(pot.flags, ENT_FLAG.INVISIBLE)
				pot:destroy()
			end
		end
	end
end

local function onlevel_remove_mounts()
	local mounts = get_entities_by_type({
		ENT_TYPE.MOUNT_TURKEY
		-- ENT_TYPE.MOUNT_ROCKDOG,
		-- ENT_TYPE.MOUNT_AXOLOTL,
		-- ENT_TYPE.MOUNT_MECH
	})
	-- Avoid removing mounts players are riding or holding
	-- avoid = {}
	-- for i = 1, #players, 1 do
		-- holdingmount = get_entity(players[1].uid):as_movable().holding_uid
		-- mount = get_entity(players[1].uid):topmost()
		-- -- message(tostring(mount.uid))
		-- if (
			-- mount ~= players[1].uid and
			-- (
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_TURKEY or
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_ROCKDOG or
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_AXOLOTL
			-- )
		-- ) then
			-- table.insert(avoid, mount)
		-- end
		-- if (
			-- holdingmount ~= -1 and
			-- (
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_TURKEY or
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_ROCKDOG or
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_AXOLOTL
			-- )
		-- ) then
			-- table.insert(avoid, holdingmount)
		-- end
	-- end
	if state.theme == THEME.DWELLING and (state.level == 2 or state.level == 3) then
		for t, mount in ipairs(mounts) do
			-- stop_remove = false
			-- for _, avoidmount in ipairs(avoid) do
				-- if mount == avoidmount then stop_remove = true end
			-- end
			local mov = get_entity(mount)
			if test_flag(mov.flags, ENT_FLAG.SHOP_ITEM) == false then --and stop_remove == false then
				move_entity(mount, 0, 0, 0, 0)
			end
		end
	end
end

function module.remove_boulderstatue()
	if state.theme == THEME.ICE_CAVES then
		for _, uid in ipairs(get_entities_by_type(ENT_TYPE.BG_BOULDER_STATUE)) do
			get_entity(uid):destroy()
		end
	end
end

function module.remove_neobab_decorations()
	if state.theme == THEME.NEO_BABYLON then
		for _, uid in ipairs(get_entities_by_type({ENT_TYPE.DECORATION_BABYLON_NEON_SIGN, ENT_TYPE.DECORATION_HANGING_WIRES})) do
			get_entity(uid):destroy()
		end
	end
end

local function onlevel_remove_cobwebs_on_pushblocks()
	if (--only run on any themes that have pushblocks
		state.theme == THEME.DWELLING
		or state.theme == THEME.TEMPLE
		or state.theme == THEME.OLMEC
		or state.theme == THEME.VOLCANA
	) then
		local pushblocks = get_entities_by({ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, ENT_TYPE.ACTIVEFLOOR_POWDERKEG}, MASK.ACTIVEFLOOR, LAYER.FRONT)
		for _, pushblock in ipairs(pushblocks) do
			local x, y, _ = get_position(pushblock)
			local webs = get_entities_at(ENT_TYPE.ITEM_WEB, MASK.ITEM, x, y+1, LAYER.FRONT, 0.5)
			if (
				#webs ~= 0
				and get_entity_type(webs[1]) == ENT_TYPE.ITEM_WEB
			) then
				kill_entity(webs[1])
			end
		end
	end
end

local function remove_door_items()
	if state.theme ~= THEME.OLMEC then
		local items_to_remove = {
			ENT_TYPE.ITEM_POT,
			ENT_TYPE.ITEM_SKULL,
			ENT_TYPE.ITEM_BONES,
			ENT_TYPE.ITEM_ROCK,
			ENT_TYPE.ITEM_WEB,
			ENT_TYPE.ITEM_CHEST,
			ENT_TYPE.ITEM_CRATE,
			ENT_TYPE.ITEM_RUBY,
			ENT_TYPE.ITEM_SAPPHIRE,
			ENT_TYPE.ITEM_EMERALD,
			ENT_TYPE.ITEM_GOLDBAR,
			ENT_TYPE.ITEM_GOLDBARS
		}
		removelib.remove_non_held_item(
			items_to_remove,
			roomgenlib.global_levelassembly.exit.x, roomgenlib.global_levelassembly.exit.y
		)
		removelib.remove_non_held_item(
			items_to_remove,
			roomgenlib.global_levelassembly.entrance.x, roomgenlib.global_levelassembly.entrance.y
		)
	end
end

-- remove pots and rocks that weren't placed via scripting
set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
    if (
		spawn_flags & SPAWN_TYPE.SCRIPT == 0
		and (
			worldlib.HD_WORLDSTATE_STATE == worldlib.HD_WORLDSTATE_STATUS.TUTORIAL
			or state.theme == THEME.NEO_BABYLON
			or feelingslib.feeling_check(feelingslib.FEELING_ID.SPIDERLAIR)
		)
	) then
        return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
    end
end, SPAWN_TYPE.LEVEL_GEN_GENERAL | SPAWN_TYPE.LEVEL_GEN_PROCEDURAL, 0, ENT_TYPE.ITEM_ROCK, ENT_TYPE.ITEM_POT)

-- remove spiderwebs from tutorial
set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
    if (
		spawn_flags & SPAWN_TYPE.SCRIPT == 0
		and worldlib.HD_WORLDSTATE_STATE == worldlib.HD_WORLDSTATE_STATUS.TUTORIAL
	) then
        return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
    end
end, SPAWN_TYPE.LEVEL_GEN_GENERAL | SPAWN_TYPE.LEVEL_GEN_PROCEDURAL, 0, ENT_TYPE.ITEM_WEB)

-- remove nonscript critters
set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
    if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
        return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
    end
end,
	SPAWN_TYPE.ANY,-- SPAWN_TYPE.LEVEL_GEN_GENERAL | SPAWN_TYPE.LEVEL_GEN_PROCEDURAL,
	0,
	ENT_TYPE.MONS_CRITTERANCHOVY,
	ENT_TYPE.MONS_CRITTERBUTTERFLY,
	ENT_TYPE.MONS_CRITTERCRAB,
	ENT_TYPE.MONS_CRITTERDRONE,
	ENT_TYPE.MONS_CRITTERDUNGBEETLE,
	ENT_TYPE.MONS_CRITTERFIREFLY,
	ENT_TYPE.MONS_CRITTERFISH,
	ENT_TYPE.MONS_CRITTERLOCUST,
	ENT_TYPE.MONS_CRITTERPENGUIN,
	ENT_TYPE.MONS_CRITTERSLIME,
	ENT_TYPE.MONS_CRITTERSNAIL
)

-- remove hide decorations
set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
    if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
        return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
    end
end, SPAWN_TYPE.ANY, MASK.DECORATION, ENT_TYPE.DECORATION_HANGING_HIDE)

function module.postlevelgen_remove_items()
	remove_door_items()
end

function module.postlevelgen_spawn_dar_fog()
	if (
		not feelingslib.feeling_check(feelingslib.FEELING_ID.RESTLESS)
		and not feelingslib.feeling_check(feelingslib.FEELING_ID.HAUNTEDCASTLE)
	) then return end

	local random_entity = get_entities_by(ENT_TYPE.BG_LEVEL_BACKWALL, MASK.SHADOW, LAYER.FRONT)[1]
	for rx = 1, state.width, 2 do
		for ry = 1, state.height, 2 do
			local part = generate_world_particles(PARTICLEEMITTER.TOMB_FOG, random_entity)
			part.entity_uid = -1
			part.x, part.y = get_room_pos(rx, ry)
		end
	end
end

function module.postlevelgen_fix_door_ambient_sound()
	if worldlib.HD_WORLDSTATE_STATE == worldlib.HD_WORLDSTATE_STATUS.NORMAL then
		if state.theme == THEME.DWELLING and state.level == 4 then
			local door = get_entities_by(ENT_TYPE.FLOOR_DOOR_EXIT, MASK.FLOOR, LAYER.FRONT)[1]

			local old_ambient = entity_get_items_by(door, ENT_TYPE.LOGICAL_DOOR_AMBIENT_SOUND, MASK.LOGICAL)[1]
			kill_entity(old_ambient)

			--Spawn ambient on the left, so it becomes the jungle ambient (must have an overlay)
			local x, y = get_position(door)
			local left_bordertile = get_grid_entity_at(0, y, LAYER.FRONT)
			local ambient = spawn_over(ENT_TYPE.LOGICAL_DOOR_AMBIENT_SOUND, left_bordertile, 0, 0)

			--Move it and attach to the door
			move_entity(ambient, x, y, 0, 0)
			attach_entity(door, ambient)
		elseif state.theme == THEME.ICE_CAVES and state.level == 4 then
			local doors = get_entities_by(ENT_TYPE.FLOOR_DOOR_EXIT, MASK.FLOOR, LAYER.FRONT)
			for _, door in pairs(doors) do
				local x, y = get_position(door)
				local rx, ry = get_room_index(x, y)
				local room_template = get_room_template(rx, ry, LAYER.FRONT)
				--Ignore MS door and moai door
				if room_template == ROOM_TEMPLATE.EXIT or room_template == ROOM_TEMPLATE.EXIT_NOTOP then
					-- messpect("main door room", get_room_template_name(room_template))
					spawn_over(ENT_TYPE.LOGICAL_DOOR_AMBIENT_SOUND, door, 0, 0)
					break
				end
			end
		end
	end
end

function module.postlevelgen_replace_wooden_shields()
	local wooden_shields = get_entities_by(ENT_TYPE.ITEM_WOODEN_SHIELD, MASK.ITEM, LAYER.FRONT)
	for _, uid in pairs(wooden_shields) do
		local shield = get_entity(uid)
		local overlay = shield.overlay
		if overlay and overlay.type.id == ENT_TYPE.MONS_TIKIMAN then
			shield:destroy()
			local x, y = get_position(overlay.uid)
			pick_up(overlay.uid, spawn_entity(ENT_TYPE.ITEM_BOOMERANG, x, y, LAYER.FRONT, 0, 0))
		end
	end
end

local walltorch_rooms = {
	ROOM_TEMPLATE.PATH_NORMAL,
	ROOM_TEMPLATE.PATH_DROP,
	ROOM_TEMPLATE.PATH_NOTOP,
	ROOM_TEMPLATE.PATH_DROP_NOTOP,
	ROOM_TEMPLATE.EXIT,
	ROOM_TEMPLATE.EXIT_NOTOP,
}

local function spawn_walltorch_at_room(room_x, room_y)
	local spots, spot_index = {}, 0
	local start_x, start_y = get_room_pos(room_x, room_y)
	start_x, start_y = math.ceil(start_x), math.ceil(start_y)
	for x = start_x, start_x + CONST.ROOM_WIDTH - 1 do
		for y = start_y, start_y - CONST.ROOM_HEIGHT + 1, -1 do
			if validlib.is_valid_walltorch_spawn(x, y, LAYER.FRONT) then
				spot_index = spot_index + 1
				spots[spot_index] = {x, y}
			end
		end
	end

	if spot_index == 0 then return -1 end
	local spawn_x, spawn_y = table.unpack(spots[prng:random_index(spot_index, PRNG_CLASS.PROCEDURAL_SPAWNS)])
	return spawn(ENT_TYPE.ITEM_WALLTORCH, spawn_x, spawn_y+.2, LAYER.FRONT, .0, .0)
end

function module.postlevelgen_spawn_walltorches()
	if test_flag(state.level_flags, 18) then
		for ry = 0, state.height do
			for rx = 0, state.width do
				local room = get_room_template(rx, ry, LAYER.FRONT)
				if commonlib.has(walltorch_rooms, room) then
					spawn_walltorch_at_room(rx, ry)
				end
			end
		end
	end
end

set_pre_entity_spawn(function (_, x, y, layer, _, spawn_flags)
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
		return spawn_grid_entity(ENT_TYPE.FX_SHADOW, x, y, layer)
	end
end, SPAWN_TYPE.LEVEL_GEN_GENERAL, MASK.ITEM, ENT_TYPE.ITEM_WALLTORCH)

-- Magmar spawn logic isn't normally created for most of the themes that need it. The logic does get created for volcana, but the game creates it before the custom level generation has added lava, so no spawn positions are added. This function will set up the logic and spawn positions for themes that need it.
function module.postloadscreen_init_magmar_spawn_logic()
	if options.hd_debug_magmar_spawn_enable and state.screen == SCREEN.LEVEL
		and (state.theme == THEME.TEMPLE or state.theme == THEME.CITY_OF_GOLD or state.theme == THEME.OLMEC or state.theme == THEME.VOLCANA)
	then
		local logic = state.logic.magmaman_spawn
		if not logic then
			logic = state.logic:start_logic(LOGIC.MAGMAMAN_SPAWN)
		end
		local added_spawns = {}
		for _, id in ipairs(get_entities_by({ ENT_TYPE.LIQUID_LAVA, ENT_TYPE.LIQUID_COARSE_LAVA }, MASK.LAVA, LAYER.FRONT)) do
			local ent = get_entity(id)
			local x = math.floor(ent.x + 0.5)
			local y = math.floor(ent.y + 0.5)
			local key = x..","..y
			if not added_spawns[key] then
				logic:add_spawn(x, y)
				added_spawns[key] = true
			end
		end
	end
end

-- Prevent magmars from spawning inside Olmec. Instead of being crushed, they often get instantly warped up to the top of Olmec.
set_pre_entity_spawn(function(_, x, y, layer, _, _)
	if options.hd_debug_magmar_spawn_enable then
		local olmec_id = get_entities_by(ENT_TYPE.ACTIVEFLOOR_OLMEC, MASK.ACTIVEFLOOR, layer)[1]
		if olmec_id and get_hitbox(olmec_id, 0.4):is_point_inside(x, y) then
			return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, layer, 0, 0)
		end
	end
end, SPAWN_TYPE.ANY, MASK.MONSTER, ENT_TYPE.MONS_MAGMAMAN)

function module.onlevel_touchups()
	onlevel_remove_cursedpot()
	onlevel_remove_mounts()
	onlevel_replace_border_textures()
	onlevel_removeborderfloor()
	onlevel_create_impostorlake()
	onlevel_remove_cobwebs_on_pushblocks()
end

local present_entities = {
	ENT_TYPE.ITEM_PICKUP_ROPEPILE,
	ENT_TYPE.ITEM_PICKUP_BOMBBAG,
	ENT_TYPE.ITEM_PICKUP_BOMBBOX,
	ENT_TYPE.ITEM_PICKUP_SPECTACLES,
	ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES,
	ENT_TYPE.ITEM_PICKUP_PITCHERSMITT,
	ENT_TYPE.ITEM_PICKUP_SPRINGSHOES,
	ENT_TYPE.ITEM_PICKUP_SPIKESHOES,
	ENT_TYPE.ITEM_PICKUP_PASTE,
	ENT_TYPE.ITEM_PICKUP_COMPASS,
	ENT_TYPE.ITEM_MATTOCK,
	ENT_TYPE.ITEM_BOOMERANG,
	ENT_TYPE.ITEM_MACHETE,
	ENT_TYPE.ITEM_WEBGUN,
	ENT_TYPE.ITEM_SHOTGUN,
	ENT_TYPE.ITEM_FREEZERAY,
	ENT_TYPE.ITEM_CAMERA,
	ENT_TYPE.ITEM_TELEPORTER,
	ENT_TYPE.ITEM_PICKUP_PARACHUTE,
	ENT_TYPE.ITEM_CAPE,
	ENT_TYPE.ITEM_JETPACK,
}
local present_entities_num = #present_entities

set_post_entity_spawn(function(e)
	local tospawn
	if e.type.id == ENT_TYPE.ITEM_PRESENT then
		tospawn = present_entities[prng:random_index(present_entities_num, PRNG_CLASS.PROCEDURAL_SPAWNS)]
	else
		if prng:random_index(10000, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PLASMACANNON
		elseif prng:random_index(500, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_JETPACK
		elseif prng:random_index(200, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_FREEZERAY
		elseif prng:random_index(200, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_CAPE
		elseif prng:random_index(100, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_SHOTGUN
		elseif prng:random_index(100, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_MATTOCK
		elseif prng:random_index(100, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_TELEPORTER
		elseif prng:random_index(90, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES
		elseif prng:random_index(90, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_SPECTACLES
		elseif prng:random_index(80, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_WEBGUN
		elseif prng:random_index(80, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_CAMERA
		elseif prng:random_index(80, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_PITCHERSMITT
		elseif prng:random_index(60, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_PASTE
		elseif prng:random_index(60, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_SPRINGSHOES
		elseif prng:random_index(60, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_SPIKESHOES
		elseif prng:random_index(60, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_BOOMERANG
		elseif prng:random_index(40, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_MACHETE
		elseif prng:random_index(40, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_BOMBBOX
		elseif prng:random_index(20, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_COMPASS
		elseif prng:random_index(10, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_PARACHUTE
		elseif prng:random_index(2, PRNG_CLASS.PROCEDURAL_SPAWNS) == 1 then
			tospawn = ENT_TYPE.ITEM_PICKUP_BOMBBAG
		else
			tospawn = ENT_TYPE.ITEM_PICKUP_ROPEPILE
		end
	end
	e.inside = tospawn
end, SPAWN_TYPE.ANY, MASK.ITEM, {ENT_TYPE.ITEM_CRATE, ENT_TYPE.ITEM_PRESENT})

local HD_CRUST_ITEMS = {
	ENT_TYPE.ITEM_PICKUP_ROPEPILE,
	ENT_TYPE.ITEM_PICKUP_BOMBBAG,
	ENT_TYPE.ITEM_PICKUP_BOMBBOX,
	ENT_TYPE.ITEM_PICKUP_SPECTACLES,
	ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES,
	ENT_TYPE.ITEM_PICKUP_PITCHERSMITT,
	ENT_TYPE.ITEM_PICKUP_SPRINGSHOES,
	ENT_TYPE.ITEM_PICKUP_SPIKESHOES,
	ENT_TYPE.ITEM_PICKUP_PASTE,
	ENT_TYPE.ITEM_PICKUP_COMPASS,
	ENT_TYPE.ITEM_MATTOCK,
	ENT_TYPE.ITEM_BOOMERANG,
	ENT_TYPE.ITEM_MACHETE,
	ENT_TYPE.ITEM_WEBGUN,
	ENT_TYPE.ITEM_SHOTGUN,
	ENT_TYPE.ITEM_FREEZERAY,
	ENT_TYPE.ITEM_CAMERA,
	ENT_TYPE.ITEM_TELEPORTER,
	ENT_TYPE.ITEM_PICKUP_PARACHUTE,
	ENT_TYPE.ITEM_CAPE,
	ENT_TYPE.ITEM_JETPACK,
}
local HD_CRUST_ITEMS_NUM = #HD_CRUST_ITEMS

local S2_EXCLUSIVE_CRUST_ITEMS = {
	ENT_TYPE.ITEM_CROSSBOW,
	ENT_TYPE.ITEM_TELEPORTER_BACKPACK,
	ENT_TYPE.ITEM_HOVERPACK,
	ENT_TYPE.ITEM_POWERPACK,
}

function module.replace_s2_crust_items()
	local items = get_entities_by(S2_EXCLUSIVE_CRUST_ITEMS, MASK.ITEM, LAYER.FRONT)
	local crust_items_visible = test_flag(state.special_visibility_flags, 1)
	for _, uid in pairs(items) do
		local ent = get_entity(uid)
		if ent.overlay and ent.overlay.type.search_flags & MASK.FLOOR ~= 0 and not embedlib.script_embedded_item_uids[uid] then
			local overlay = ent.overlay

			removelib.remove_item_entities(uid)
			ent:destroy()

			local tospawn = HD_CRUST_ITEMS[prng:random_index(HD_CRUST_ITEMS_NUM, PRNG_CLASS.LEVEL_GEN)]
			local spawned_uid = spawn_entity_over(tospawn, overlay.uid, 0, 0)
			embedlib.embed_item(spawned_uid, overlay.uid, crust_items_visible)
			messpect("embedded at", enum_get_name(ENT_TYPE, ent.type.id), enum_get_name(ENT_TYPE, tospawn), get_position(uid))
		end
	end
end

-- set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
-- 	if get_type(get_entity_type(state.next_entity_uid-1)).search_flags & MASK.FLOOR ~= 0 then
-- 		messpect("valid", x, y)
-- 		-- return HD_CRUST_ITEMS[prng:random_index(HD_CRUST_ITEMS_NUM, PRNG_CLASS.LEVEL_GEN)]
-- 	end
-- end, SPAWN_TYPE.LEVEL_GEN, MASK.ITEM, s2_crust_items)

set_pre_entity_spawn(function(ent_type, x, y, l, overlay)
	return spawn_grid_entity(ENT_TYPE.FLOOR_BORDERTILE_METAL, x, y, l)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD)

set_pre_entity_spawn(function(ent_type, x, y, l, overlay)
	return spawn_grid_entity(ENT_TYPE.FLOOR_BORDERTILE_METAL, x, y, l)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD_TOP)

set_post_entity_spawn(function(entity)
	entity:fix_decorations(true, true)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD)

set_post_entity_spawn(function(entity)
	entity:fix_decorations(true, true)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD_TOP)

set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
    if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
        -- print("BYE PET")
        return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
    end
    -- print("HI PET")
end, SPAWN_TYPE.LEVEL_GEN_GENERAL | SPAWN_TYPE.LEVEL_GEN_PROCEDURAL, 0, ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_HAMSTER)

--Set transition tiles for temple
set_pre_tile_code_callback(function (x, y, layer)
	if not options.hd_og_floorstyle_temple then return false end
    spawn_grid_entity(ENT_TYPE.FLOORSTYLED_STONE, x, y, layer)
    return true
end, "temple_floor")

--Set transition tiles for mothership
set_pre_tile_code_callback(function (x, y, layer)
    spawn_grid_entity(ENT_TYPE.FLOORSTYLED_MOTHERSHIP, x, y, layer)
    return true
end, "babylon_floor")

--Set ending tiles
set_pre_tile_code_callback(function (x, y, layer)
	if state.screen ~= SCREEN.WIN then return false end
    spawn_grid_entity(
		state.win_state == WIN_STATE.TIAMAT_WIN
			and (
				-- options.hd_og_floorstyle_temple and 
				ENT_TYPE.FLOORSTYLED_STONE
				-- or ENT_TYPE.FLOORSTYLED_TEMPLE
			)
			or ENT_TYPE.FLOORSTYLED_VLAD,
		x, y, layer
	)
    return true
end, "minewood_floor")

-- Prevent fog at the bottom of the worm
state.level_gen.themes[THEME.EGGPLANT_WORLD]:set_pre_spawn_effects(function(theme)
	state.level_gen.themes[THEME.DWELLING]:spawn_effects()
	return true
end)

local KALI_POWERUPS = {
	ENT_TYPE.ITEM_POWERUP_COMPASS,
	ENT_TYPE.ITEM_CAPE,
	ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES,
	ENT_TYPE.ITEM_POWERUP_SPECTACLES,
	ENT_TYPE.ITEM_POWERUP_PITCHERSMITT,
	ENT_TYPE.ITEM_POWERUP_SPRING_SHOES,
	ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES,
}
local KALI_PICKUPS = {
	ENT_TYPE.ITEM_PICKUP_COMPASS,
	ENT_TYPE.ITEM_CAPE,
	ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES,
	ENT_TYPE.ITEM_PICKUP_SPECTACLES,
	ENT_TYPE.ITEM_PICKUP_PITCHERSMITT,
	ENT_TYPE.ITEM_PICKUP_SPRINGSHOES,
	ENT_TYPE.ITEM_PICKUP_SPIKESHOES,
}
local function get_grid_type_at(x, y, layer)
	return get_entity_type(get_grid_entity_at(x, y, layer))
end
-- Replace skeleton key drop from altar, doesn't replace bomb bag drop since it would only drop if having skele, which shouldn't be possible with only HD drops
set_pre_entity_spawn(function (entity_type, x, y, layer)
	if (
		get_grid_type_at(math.floor(x), y-1, layer) == ENT_TYPE.FLOOR_ALTAR or
		get_grid_type_at(math.ceil(x), y-1, layer) == ENT_TYPE.FLOOR_ALTAR
	) then
		local has_paste = false
		local has_jp = false
		--Get the closest player, game gets player by ownership but doing so now might be quite difficult
		local closest_player = players[1]
		if players[2] then
			local last_dist = math.huge
			for _, player in ipairs(players) do
				local xdist, ydist = (player.abs_x - x), (player.abs_y - y)
				local dist = (xdist*xdist + ydist*ydist)
				if dist < last_dist then
					closest_player = player
					last_dist = dist
				end
			end
		end
		if closest_player then
			has_paste = closest_player:has_powerup(ENT_TYPE.ITEM_POWERUP_PASTE)
			has_jp = closest_player:has_powerup(ENT_TYPE.ITEM_JETPACK)
		end
		if not has_paste then
			return spawn(ENT_TYPE.ITEM_PICKUP_PASTE, x, y, layer, 0, 0)
		end
		for i, powerup_id in ipairs(KALI_POWERUPS) do
			if not closest_player:has_powerup(powerup_id) and (powerup_id ~= ENT_TYPE.ITEM_CAPE or not has_jp) then -- and don't give cape if has jp
				return spawn(KALI_PICKUPS[i], x, y, layer, 0, 0)
			end
		end
		-- if player has all random powerups already
		if not has_jp then
			return spawn(ENT_TYPE.ITEM_JETPACK, x, y, layer, 0, 0)
		end
		return spawn(ENT_TYPE.ITEM_PICKUP_BOMBBOX, x, y, layer, 0, 0)
	end
end, SPAWN_TYPE.SYSTEMIC, MASK.ITEM, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)

return module