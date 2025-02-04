local roomdeflib = require "lib.gen.roomdef"
local module = {}

local debug_valid_spaces

---@diagnostic disable unused-local
local DEBUG_RGB_BROWN = rgba(204, 51, 0, 170)
local DEBUG_RGB_ORANGE = rgba(255, 153, 0, 170)
local DEBUG_RGB_GREEN = rgba(153, 196, 19, 170)
---@diagnostic enable unused-local

function module.debug_init()
	debug_valid_spaces = {}
end

---@param x number
---@param y number
---@param color integer
---@param is_trap_spawn boolean? @ Pass nil to allow any, false for procedural, true for traps
---@diagnostic disable-next-line unused-local
local function debug_add_valid_space(x, y, color, is_trap_spawn)
	if is_trap_spawn == nil then
	elseif is_trap_spawn == true and not spawndeflib.is_trap_spawn then
		return
	elseif is_trap_spawn == false and spawndeflib.is_trap_spawn then
		return
	end
	debug_valid_spaces[#debug_valid_spaces+1] = {}
	debug_valid_spaces[#debug_valid_spaces].x = x
	debug_valid_spaces[#debug_valid_spaces].y = y
	debug_valid_spaces[#debug_valid_spaces].color = color
end

set_callback(function(draw_ctx)
	if state.pause == 0 and state.screen == 12 and debug_valid_spaces then
		for _, space in pairs(debug_valid_spaces) do
			draw_ctx:draw_rect_filled(screen_aabb(AABB:new():offset(space.x, space.y):extrude(0.5)), 0, space.color)
		end
	end
end, ON.GUIFRAME)

--[[
	START PROCEDURAL/EXTRA SPAWN DEF
--]]

--[[
	-- Notes:
		-- kays:
			-- "I believe it's a 1/N chance that any possible place for that enemy to spawn, it spawns. so in your example, for level 2 about 1/20 of the possible tiles for that enemy to spawn will actually spawn it"
	
		-- Dr.BaconSlices (regarding the S2 screenshot with all dwelling enemies set to max spawn rates):
			--[[
				"Yup, all it does is roll that chance on any viable tile. There are a couple more quirks, or so I've heard,
				like enemies spawning with more air around them rather than in enclosed areas, whereas treasure is
				more likely to be in cramped places. And of course, it checks for viable tiles instead of any tile,
				so it won't place things inside of floors or other solids, within a liquid it isn't supposed to be in, etc.
				There's also stuff like bats generating along celiengs instead of the ground,
				but I don't think I need to explain that haha"
				"Oh yeah, I forgot to mention that. The priority is determined based on the list,
				which you can see here with 50 million bats but 0 spiders. I'm assuming both of
				their chances are set to 1,1,1,1 but you're still only seeing bats, and that's
				because they're generating in all of the places that spiders are able to."
			--]]
	-- Spawn requirements:
		-- Traps
			-- Notes:
				-- replaces FLOOR_* and FLOORSTYLED_* (so platforms count as spaces)
				-- don't spawn in place of gold/rocks/pots
			-- Arrow Trap:
				-- Notes:
					-- are the only damaging entity to spawn in the entrance 
				-- viable tiles:
					-- if there are two blocks and two spaces, mark the inside block for replacement, unless the trigger hitbox would touch the entrance door
				-- while spawning:
					-- don't spawn if it would result in its back touching another arrow trap
				
			-- Tiki Traps:
				-- Notes:
					-- Spawn after arrow traps
					-- are the only damaging entity to spawn in the entrance 
				-- viable space to place:
					-- Require a block on both sides of the block it's standing on
					-- Require a 3x2 space above the spawn
				-- viable tile to replace:
					-- 
				-- while spawning:
					-- don't spawn if it would result in its sides touching another tiki trap 
						-- HD doesn't check for this
--]]

module.hideyhole_items_to_keep = {ENT_TYPE.ITEM_CURSEDPOT, ENT_TYPE.ITEM_LOCKEDCHEST, ENT_TYPE.ITEM_LOCKEDCHEST_KEY}

local valid_floors = {ENT_TYPE.FLOOR_GENERIC, ENT_TYPE.FLOOR_JUNGLE, ENT_TYPE.FLOORSTYLED_MINEWOOD, ENT_TYPE.FLOORSTYLED_STONE, ENT_TYPE.FLOORSTYLED_TEMPLE, ENT_TYPE.FLOORSTYLED_COG, ENT_TYPE.FLOORSTYLED_PAGODA, ENT_TYPE.FLOORSTYLED_BABYLON, ENT_TYPE.FLOORSTYLED_SUNKEN, ENT_TYPE.FLOORSTYLED_BEEHIVE, ENT_TYPE.FLOORSTYLED_VLAD, ENT_TYPE.FLOORSTYLED_MOTHERSHIP, ENT_TYPE.FLOORSTYLED_DUAT, ENT_TYPE.FLOORSTYLED_PALACE, ENT_TYPE.FLOORSTYLED_GUTS, ENT_TYPE.FLOOR_SURFACE, ENT_TYPE.FLOOR_ICE}

local TEMPLE_PATH_ROOMS = {
	roomdeflib.HD_SUBCHUNKID.PATH,
	roomdeflib.HD_SUBCHUNKID.PATH_DROP,
	roomdeflib.HD_SUBCHUNKID.PATH_DROP_NOTOP,
	roomdeflib.HD_SUBCHUNKID.PATH_NOTOP,
}
local TEMPLE_PATH_EXIT_ROOMS = {
	roomdeflib.HD_SUBCHUNKID.EXIT,
	roomdeflib.HD_SUBCHUNKID.EXIT_NOTOP,
	table.unpack(TEMPLE_PATH_ROOMS),
}

local function is_liquid_at(x, y)
	local lvlcode = locatelib.get_levelcode_at_gpos(x, y)
	return lvlcode == "w" or
		(lvlcode == "3" and get_grid_entity_at(x, y, LAYER.FRONT) == -1) or
		(lvlcode == "c" and state.theme == THEME.EGGPLANT_WORLD) or
		(feelingslib.feeling_check(feelingslib.FEELING_ID.RUSHING_WATER) and y < 96)
end

function module.is_gurenteed_mines_ground_at(x, y)
	return locatelib.get_levelcode_at_gpos(x, y) == "1"
	or locatelib.get_levelcode_at_gpos(x, y) == "2"
	or locatelib.get_levelcode_at_gpos(x, y) == "#"
	or locatelib.get_levelcode_at_gpos(x, y) == "4"
end

local function is_anti_trap_at(x, y)
	return locatelib.get_levelcode_at_gpos(x, y) == "q"
end

local function check_empty_space(origin_x, origin_y, layer, width, height)
	for y = origin_y, origin_y+1-height, -1 do
		for x = origin_x, origin_x+width-1 do
			if get_grid_entity_at(x, y, layer) ~= -1 or is_liquid_at(x, y) then
				return false
			end
		end
	end
	return true
end

local function is_door_at(x, y, l)
	return #get_entities_at({ENT_TYPE.FLOOR_DOOR_EXIT, ENT_TYPE.FLOOR_DOOR_COG}, MASK.FLOOR, x, y, l, 0.5) ~= 0
end

local shop_templates = {
	ROOM_TEMPLATE.SHOP,
	ROOM_TEMPLATE.SHOP_LEFT,
	ROOM_TEMPLATE.DICESHOP,
	ROOM_TEMPLATE.DICESHOP_LEFT
}
local function detect_shop_room_template(x, y, l) -- is this position inside an entrance room?
	local rx, ry = get_room_index(x, y)
	return (
		commonlib.has(shop_templates, get_room_template(rx, ry, l))
	)
end

local function detect_entrance_room_template(x, y, l) -- is this position inside an entrance room?
	local rx, ry = get_room_index(x, y)
	local id = get_room_template(rx, ry, l)
	return (
		id == ROOM_TEMPLATE.ENTRANCE
		or id == ROOM_TEMPLATE.ENTRANCE_DROP
		or id == ROOM_TEMPLATE.YAMA_ENTRANCE
		or id == ROOM_TEMPLATE.YAMA_ENTRANCE_2
	)
end

local function is_fountainhead_at(x, y)
	return locatelib.get_levelcode_at_gpos(x, y) == "&"
end

function module.is_valid_climbable_space(x, y, l)
	return not (
		get_entities_at(0, MASK.FLOOR | MASK.ACTIVEFLOOR, x, y-1, l, 0.5)[1] ~= nil
		or is_door_at(x, y-1, l)
		or is_liquid_at(x, y-1)
		or is_fountainhead_at(x, y-1)
	)
end

local nonshop_nontree_solids = {
	ENT_TYPE.FLOOR_ALTAR,
	ENT_TYPE.FLOOR_TREE_BASE,
	ENT_TYPE.FLOOR_TREE_TRUNK,
	ENT_TYPE.FLOOR_TREE_TOP,
	ENT_TYPE.FLOOR_IDOL_BLOCK,
	ENT_TYPE.FLOOR_TOTEM_TRAP
}
local function detect_solid_nonshop_nontree(x, y, l)
    local entity_here = get_grid_entity_at(x, y, l)
	if entity_here ~= -1 then
		local entity_type = get_entity_type(entity_here)
		local entity_flags = get_entity_flags(entity_here)
		return (
			test_flag(entity_flags, ENT_FLAG.SOLID) == true
			and test_flag(entity_flags, ENT_FLAG.SHOP_FLOOR) == false
			and not commonlib.has(nonshop_nontree_solids, entity_type)
		)
	end
	return false
end

local function is_activefloor_at(x, y, l)
	return #get_entities_overlapping_hitbox(0, MASK.ACTIVEFLOOR, AABB:new(x-0.5, y+0.5, x+0.5, y-0.5), l) ~= 0
end

local function is_non_grid_entity_at(x, y, l)
	return #get_entities_overlapping_hitbox({ENT_TYPE.FLOOR_TREE_BRANCH, ENT_TYPE.ACTIVEFLOOR_SLIDINGWALL, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK}, 0, AABB:new(x-0.5, y+0.5, x+0.5, y-0.5), l) ~= 0
end

function module.is_solid_grid_entity(x, y, l)
	local ent = get_entity(get_grid_entity_at(x, y, l))
	if not ent then
		return #get_entities_overlapping_hitbox({ENT_TYPE.ACTIVEFLOOR_SLIDINGWALL, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK}, MASK.ACTIVEFLOOR, AABB:new(x-0.5, y+0.5, x+0.5, y-0.5), l) ~= 0
	end
	return test_flag(ent.flags, ENT_FLAG.SOLID)
end

local function is_valid_monster_floor(x, y, l)
	local flags = get_entity_flags(get_grid_entity_at(x, y, l))
    return test_flag(flags, ENT_FLAG.SOLID)
	--or test_flag(flags, ENT_FLAG.IS_PLATFORM)
end

local function default_ground_monster_condition(x, y, l)
	return get_grid_entity_at(x, y, l) == -1
	and is_valid_monster_floor(x, y-1, l)
	and detect_entrance_room_template(x, y, l) == false
	and not is_liquid_at(x, y)
end

local function is_ladder_tile_at(x, y)
	local lvlcode = locatelib.get_levelcode_at_gpos(x, y)
	return lvlcode == "G"
	or lvlcode == "H"
	or lvlcode == "L"
	or lvlcode == "P"
	or lvlcode == "Q"
end

local function is_falling_platform_at(x, y, l)
	return #get_entities_overlapping_hitbox(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, MASK.ACTIVEFLOOR, AABB:new(x-0.5, y+0.5, x+0.5, y-0.5), l) ~= 0
end

local function ceiling_entity_condition(x, y, l)
	return get_grid_entity_at(x, y, l) == -1
	and not is_ladder_tile_at(x, y)
	and module.is_solid_grid_entity(x, y+1, l)
	and detect_entrance_room_template(x, y, l) == false
	and not is_liquid_at(x, y)
end

local function ceiling_entity_condition_clearance_1(x, y, l)
	return ceiling_entity_condition(x, y, l)
	and get_grid_entity_at(x, y-1, l) == -1
end

local function ceiling_entity_condition_clearance_2(x, y, l)
	return ceiling_entity_condition(x, y, l)
	and get_grid_entity_at(x, y-1, l) == -1
	and get_grid_entity_at(x, y-2, l) == -1
end

local function default_hell_ceiling_entity_condition(x, y, l)
	return get_grid_entity_at(x, y, l) == -1
	and not is_ladder_tile_at(x, y)
	and module.is_solid_grid_entity(x, y+1, l)
	and get_grid_entity_at(x, y-1, l) == -1
	and not is_falling_platform_at(x, y-1, l)
	and detect_entrance_room_template(x, y, l) == false
	and not is_liquid_at(x, y)
end

local function run_spiderlair_ground_enemy_chance()
	--[[
		if not spiderlair
		or 1/3 chance passes
	]]
	local current_ground_chance = get_procedural_spawn_chance(spawndeflib.global_spawn_procedural_spiderlair_ground_enemy)
	if (
		feelingslib.feeling_check(feelingslib.FEELING_ID.SPIDERLAIR) == false
		or (
			current_ground_chance ~= 0
			and prng:random_chance(current_ground_chance, PRNG_CLASS.LEVEL_GEN)
		)
	) then
		return true
	end
	return false
end

local function spiderlair_ground_monster_condition(x, y, l)
	return run_spiderlair_ground_enemy_chance()
		and default_ground_monster_condition(x, y, l)
end

function module.is_valid_walltorch_spawn(x, y, layer)
	local floor_flags = get_entity_flags(get_grid_entity_at(x, y, layer))
	return get_grid_entity_at(x, y+1, layer) == -1
			and not module.is_solid_grid_entity(x, y, layer)
			and not test_flag(floor_flags, ENT_FLAG.IS_PLATFORM)
			and not test_flag(floor_flags, ENT_FLAG.INDESTRUCTIBLE_OR_SPECIAL_FLOOR) -- Doors
			and module.is_solid_grid_entity(x, y-1, layer)
			and not is_liquid_at(x, y)
			and get_entities_overlapping_hitbox(0, MASK.ITEM | MASK.MONSTER | MASK.MOUNT, AABB:new(x-0.5, y+0.5, x+0.5, y-0.5), layer)[1] == nil
end

local function only_useless_items_at(x, y, l)
	if #get_entities_at(0, MASK.MONSTER | MASK.ACTIVEFLOOR, x, y, l, 0.4) > 0 then return false end
	for i,v in pairs(get_entities_at(0, MASK.ITEM, x, y, l, 0.4)) do
		local ent = get_entity(v)
		if commonlib.has(module.hideyhole_items_to_keep, ent.type.id) then return false end
	end
	return true
end

-- Only spawn in a space that has floor above, below, and at least one left or right of it
function module.is_valid_hideyhole_spawn(x, y, l)
	if detect_shop_room_template(x, y, l) then return false end
    if not default_spawn_is_valid(x, y, l) then return false end
	if (
		(
			x == roomgenlib.global_levelassembly.exit.x
			and y == roomgenlib.global_levelassembly.exit.y
		)
		or (
			x == roomgenlib.global_levelassembly.entrance.x
			and y == roomgenlib.global_levelassembly.entrance.y
		)
	) then
		return false
	end
    if module.is_solid_grid_entity(x, y-1, l) and module.is_solid_grid_entity(x, y+1, l) and (module.is_solid_grid_entity(x-1, y, l) or module.is_solid_grid_entity(x+1, y, l)) then
        return only_useless_items_at(x, y, l)
    end
    return false
end

-- 4 spaces available
function module.is_valid_anubis_spawn(x, y, l)
	local cx, cy = x+.5, y-.5
	local w, h = 2, 2
	local entity_uids = get_entities_overlapping_hitbox(
		0, MASK.ACTIVEFLOOR,
		AABB:new(
			cx-(w/2),
			cy+(h/2),
			cx+(w/2),
			cy-(h/2)
		),
		l
	)
	-- local rx, ry = get_room_index(x, y)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	return (
		check_empty_space(x, y, l, 2, 2)
		and #entity_uids == 0
		and commonlib.has(TEMPLE_PATH_EXIT_ROOMS, _subchunk_id)
		-- and detect_entrance_room_template(x, y, l) == false
		-- and detect_shop_room_template(x, y, l) == false
		-- and get_room_template(rx, ry, l) ~= ROOM_TEMPLATE.VAULT
		and locatelib.get_levelcode_at_gpos(x, y-1) ~= "&" -- Prevent from spawing on lava fountain
		and locatelib.get_levelcode_at_gpos(x+1, y-1) ~= "&"
	)
end

-- in path room
-- space available: 3x4 for jungle, 3x3 for icecaves
function module.is_valid_wormtongue_spawn(x, y, l)
	-- if (
	-- 	roomgenlib.global_levelassembly ~= nil
	-- 	and roomgenlib.global_levelassembly.modification ~= nil
	-- 	and roomgenlib.global_levelassembly.modification.levelrooms ~= nil
	-- ) then

	-- end
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	-- local _subchunk_id = roomgenlib.global_levelassembly.modification.levelrooms[roomy][roomx]
	if roomy < 5 then

		local cx, cy = x, y
		local w, h = 3, state.theme == THEME.JUNGLE and 3 or 4
		local entity_uids = get_entities_overlapping_hitbox(
			0, MASK.FLOOR,
			AABB:new(
				cx-(w/2),
				cy+(h/2),
				cx+(w/2),
				cy-((h/2)+(state.theme == THEME.JUNGLE and 1 or 0))
			),
			l
		)
		return (
			#entity_uids == 0
			and not is_liquid_at(x, y)
			and not is_liquid_at(x, y-1)
			and detect_shop_room_template(x, y, l) == false
		)
	end
	return false
end

local blackmarket_invalid_floors = {
	ENT_TYPE.FLOORSTYLED_MINEWOOD,
	ENT_TYPE.FLOOR_BORDERTILE,
	ENT_TYPE.FLOORSTYLED_STONE,
	ENT_TYPE.FLOOR_TREE_BASE,
	ENT_TYPE.FLOOR_TREE_TRUNK,
	ENT_TYPE.FLOOR_TREE_TOP,
	ENT_TYPE.FLOOR_ALTAR,
	ENT_TYPE.FLOOR_EGGPLANT_ALTAR, -- Tombstones
	ENT_TYPE.FLOOR_TOTEM_TRAP,
}
function module.is_valid_blackmarket_spawn(x, y, l)
	local floor_uid = get_grid_entity_at(x, y, l)
	local floor_uid2 = get_grid_entity_at(x, y-1, l)
	if (
		floor_uid ~= -1
		and floor_uid2 ~= -1
	) then
		local floor_flags = get_entity_flags(floor_uid)
		local floor_type = get_entity_type(floor_uid)

		local floor_flags2 = get_entity_flags(floor_uid2)
		local floor_type2 = get_entity_type(floor_uid2)
		return (
			(
				test_flag(floor_flags, ENT_FLAG.SOLID) == true
				and test_flag(floor_flags, ENT_FLAG.SHOP_FLOOR) == false
				and not commonlib.has(blackmarket_invalid_floors, floor_type)
			)
			and (
				test_flag(floor_flags2, ENT_FLAG.SOLID) == true
				and test_flag(floor_flags2, ENT_FLAG.SHOP_FLOOR) == false
				and not commonlib.has(blackmarket_invalid_floors, floor_type2)
			)
		)
	end
	return false
end

function module.is_valid_landmine_spawn(x, y, l)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	return default_ground_monster_condition(x, y, l)
	and get_grid_entity_at(x, y+1, l) == -1
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING_NOTOP
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING_DROP
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING_DROP_NOTOP
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.UFO_LEFTSIDE
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.UFO_MIDDLE
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.UFO_RIGHTSIDE
end

function module.is_valid_bouncetrap_spawn(x, y, l)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	local ent = get_grid_entity_at(x, y-1, l)
	if (ent ~= -1 and commonlib.has({ENT_TYPE.FLOOR_ALTAR, ENT_TYPE.FLOOR_FORCEFIELD, ENT_TYPE.FLOOR_TIMED_FORCEFIELD}, get_entity(ent).type.id)) then return false end
	return default_ground_monster_condition(x, y, l)
	and check_empty_space(x, y+4, l, 1, 4)
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING_NOTOP
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING_DROP
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.YETIKINGDOM_YETIKING_DROP_NOTOP
	and _subchunk_id ~= roomdeflib.HD_SUBCHUNKID.UFO_RIGHTSIDE
end

module.is_valid_caveman_spawn = spiderlair_ground_monster_condition
module.is_valid_scorpion_spawn = spiderlair_ground_monster_condition
module.is_valid_cobra_spawn = spiderlair_ground_monster_condition
module.is_valid_snake_spawn = spiderlair_ground_monster_condition

module.is_valid_mantrap_spawn = default_ground_monster_condition
module.is_valid_tikiman_spawn = default_ground_monster_condition
module.is_valid_snail_spawn = default_ground_monster_condition
module.is_valid_firefrog_spawn = default_ground_monster_condition
module.is_valid_frog_spawn = default_ground_monster_condition

function module.is_valid_yeti_spawn(x, y, l)
	local room = locatelib.get_levelroom_at_game_position(x, y)
	return default_ground_monster_condition(x, y, l)
	and get_grid_entity_at(x, y+1, l) == -1
	and room ~= roomdeflib.HD_SUBCHUNKID.UFO_RIGHTSIDE
end

module.is_valid_hawkman_spawn = default_ground_monster_condition

module.is_valid_crocman_spawn = default_ground_monster_condition

module.is_valid_scorpionfly_spawn = default_ground_monster_condition

module.is_valid_critter_rat_spawn = spiderlair_ground_monster_condition

module.is_valid_critter_frog_spawn = default_ground_monster_condition

function module.is_valid_critter_maggot_spawn(x, y, l) return false end -- # TODO: Implement method for valid critter_maggot spawn

module.is_valid_critter_penguin_spawn = default_ground_monster_condition

function module.is_valid_critter_locust_spawn(x, y, l) return false end -- # TODO: Implement method for valid critter_locust spawn

module.is_valid_jiangshi_spawn = default_ground_monster_condition

module.is_valid_devil_spawn = default_ground_monster_condition

module.is_valid_greenknight_spawn = default_ground_monster_condition

function module.is_valid_alientank_spawn(x, y, l)
	local room = locatelib.get_levelroom_at_game_position(x, y)
	return (
		room ~= roomdeflib.HD_SUBCHUNKID.MOTHERSHIP_ALIENQUEEN
		and get_grid_entity_at(x, y+1, l) == -1
		and default_ground_monster_condition(x, y, l)
	)
end

function module.is_valid_critter_fish_spawn(x, y, l) return false end -- # TODO: Implement method for valid critter_fish spawn

function module.is_valid_piranha_spawn(x, y, l)
	local _, room_y = locatelib.locate_levelrooms_position_from_game_position(x, y)
	return (is_liquid_at(x, y) and is_liquid_at(x, y+1))
		or (
			feelingslib.feeling_check(feelingslib.FEELING_ID.RUSHING_WATER)
			and room_y == 5
			and get_grid_entity_at(x, y, l) == -1
		)
end

function module.is_valid_monkey_spawn(x, y, l)
	local floor = get_grid_entity_at(x, y, l)
	if floor ~= -1 then
		return commonlib.has({ENT_TYPE.FLOOR_VINE}, get_entity_type(floor))
		and not is_liquid_at(x, y)
	end
	return false
end

function module.is_valid_hangspider_spawn(x, y, l)
	return (
		ceiling_entity_condition_clearance_2(x, y, l)
		and get_grid_entity_at(x, y-3, l) == -1
	)
end

module.is_valid_bat_spawn = ceiling_entity_condition_clearance_2

module.is_valid_spider_spawn = ceiling_entity_condition_clearance_2

module.is_valid_vampire_spawn = ceiling_entity_condition_clearance_2

module.is_valid_imp_spawn = default_hell_ceiling_entity_condition

function module.is_valid_scarab_spawn(x, y, l) return false end -- # TODO: Implement method for valid scarab spawn

function module.is_valid_mshiplight_spawn(x, y, l)
	return get_grid_entity_at(x, y, l) == -1
		and module.is_solid_grid_entity(x, y+1, l)
end

module.is_valid_lantern_spawn = ceiling_entity_condition_clearance_2

module.is_valid_webnest_spawn = ceiling_entity_condition_clearance_1

function module.is_valid_turret_spawn(x, y, l)
	local room = locatelib.get_levelroom_at_game_position(x, y)
	return get_grid_entity_at(x, y, l) == -1
		and get_entity_type(get_grid_entity_at(x, y+1, l)) == ENT_TYPE.FLOORSTYLED_MOTHERSHIP
		and check_empty_space(x-1, y, l, 3, 3)
		and room ~= roomdeflib.HD_SUBCHUNKID.UFO_RIGHTSIDE
end

local function is_over_or_next_to_liquid(x, y)
	return is_liquid_at(x, y)
	or is_liquid_at(x-1, y)
	or is_liquid_at(x+1, y)
	or is_liquid_at(x, y+1)
	or is_liquid_at(x, y-1)
end

function module.is_valid_pushblock_spawn(x, y, l)
	if is_over_or_next_to_liquid(x, y) then return false end
	-- Replaces floor with spawn where it has floor underneath
    local above = get_grid_entity_at(x, y+1, l)
	if above ~= -1 then
		if commonlib.has({ENT_TYPE.FLOOR_ALTAR, ENT_TYPE.FLOOR_TREE_BASE, ENT_TYPE.FLOOR_SPIKES}, get_entity_type(above)) then
			return false
		end
	end

	if not detect_solid_nonshop_nontree(x, y, l)
	or not detect_solid_nonshop_nontree(x, y - 1, l)
	then
		return false
	end
	-- debug_add_valid_space(x, y, DEBUG_RGB_GREEN)
    return true
end

function module.is_valid_spikeball_spawn(x, y, l)
	if is_over_or_next_to_liquid(x, y) then return false end
	-- need subchunkid of what room we're in
	local _subchunk_id = locatelib.get_levelroom_at_game_position(x, y)
	if (
		_subchunk_id == roomdeflib.HD_SUBCHUNKID.VLAD_TOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.VLAD_MIDSECTION
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.VLAD_BOTTOM
	) then
		return false
	end

	local lvlcode = locatelib.get_levelcode_at_gpos(x, y)
	if is_anti_trap_at(x, y) == true or lvlcode == "y" then return false end

	local above = get_grid_entity_at(x, y+1, l)
	if above ~= -1 then
		if commonlib.has({ENT_TYPE.FLOOR_ALTAR, ENT_TYPE.FLOOR_SPIKES}, get_entity_type(above)) then
			return false
		end
	end

	if not detect_solid_nonshop_nontree(x, y, l)
	or not detect_solid_nonshop_nontree(x, y - 1, l)
	then
		return false
	end

    return true
end

local function is_invalid_block_against_arrowtrap(x, y, l)
	if #get_entities_overlapping_hitbox({ENT_TYPE.FLOOR_TOTEM_TRAP, ENT_TYPE.FLOOR_LION_TRAP, ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP}, 0, AABB:new(x-0.5, y+0.5, x+0.5, y-0.5), l) ~= 0 then
		return true
	end
	return is_anti_trap_at(x, y)
end

function module.is_valid_arrowtrap_spawn(x, y, l)
	local rx, _ = get_room_index(x, y)
    if y == state.level_gen.spawn_y and (rx >= state.level_gen.spawn_room_x-1 and rx <= state.level_gen.spawn_room_x+1) then return false end

	if is_anti_trap_at(x, y) then return false end

	-- Prevent arrowtraps from spawning in front of tikitraps and crushtraps
	if (
		is_invalid_block_against_arrowtrap(x-1, y, l)
		or is_invalid_block_against_arrowtrap(x+1, y, l)
	) then
		-- message("arrowtrap avoided other trap")
		return false
	end

    local floor = get_grid_entity_at(x, y, l)

	if floor == -1 then
		return false
	end

    local left = module.is_solid_grid_entity(x-1, y, l)
    local left2 = module.is_solid_grid_entity(x-2, y, l)
    local right = module.is_solid_grid_entity(x+1, y, l)
    local right2 = module.is_solid_grid_entity(x+2, y, l)

	if (
		(left or left2 or not right or is_liquid_at(x-1, y))
		and (not left or right or right2 or is_liquid_at(x+1, y))
	) then
        return false
    end

	if not commonlib.has(valid_floors, get_entity_type(floor)) then
		return false
	end

	local above = get_grid_entity_at(x, y+1, l)
	if commonlib.has({ENT_TYPE.FLOOR_TOTEM_TRAP, ENT_TYPE.FLOOR_LION_TRAP}, get_entity_type(above)) then
		return false
	end

	-- debug_add_valid_space(x, y, DEBUG_RGB_GREEN)
    return true
end

local function is_valid_generic_trap_room(x, y)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)

	-- avoid temple altar rooms
	if state.theme == THEME.TEMPLE
	and _subchunk_id == roomdeflib.HD_SUBCHUNKID.ALTAR then
		return false
	end

	return (
		_subchunk_id == roomdeflib.HD_SUBCHUNKID.SIDE
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.EXIT
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.EXIT_NOTOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.PATH
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.PATH_DROP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.PATH_DROP_NOTOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.PATH_NOTOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_DROP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_NOTOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_DROP_NOTOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_NOTOP_LEFT
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_NOTOP_RIGHT
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_DROP_NOTOP_LEFT
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.TIKIVILLAGE_PATH_DROP_NOTOP_RIGHT
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.RUSHING_WATER_EXIT
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.RUSHING_WATER_PATH
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.RUSHING_WATER_SIDE
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.SACRIFICIALPIT_TOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.SACRIFICIALPIT_MIDSECTION
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.SACRIFICIALPIT_BOTTOM
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.VLAD_TOP
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.VLAD_MIDSECTION
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.VLAD_BOTTOM
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.ALTAR
		or _subchunk_id == roomdeflib.HD_SUBCHUNKID.IDOL
	)
end

function module.is_valid_tikitrap_spawn(x, y, l)
	-- need subchunkid of what room we're in
	local _, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	--prevent spawing in lake
	if roomy > 4 then return false end

	if (
		is_anti_trap_at(x, y)
		or is_anti_trap_at(x, y-1)
	) then return false end

	-- Prevent it spawning on pushblock, that causes the pushblock to move to the side and probably fall. The check at same pos probably isn't needed
	if is_activefloor_at(x, y, l)
	or is_activefloor_at(x, y+1, l) then
		return false
	end

	if not is_valid_generic_trap_room(x, y) then
		return false
	end

	local here = get_grid_entity_at(x, y, l)
	if commonlib.has({ENT_TYPE.FLOOR_ALTAR, ENT_TYPE.FLOOR_SPIKES, ENT_TYPE.FLOOR_IDOL_BLOCK}, get_entity_type(here)) then
		return false
	end

	if is_liquid_at(x, y)
	or is_liquid_at(x, y+1) then
		return false
	end

	if is_door_at(x, y, l)
	or is_door_at(x, y+1, l) then
		return false
	end

	-- Does it have 3 spaces across unoccupied above it?
	local topleft2 = get_grid_entity_at(x-1, y+2, l)
	local topmid2 = get_grid_entity_at(x, y+2, l)
	local topright2 = get_grid_entity_at(x+1, y+2, l)
	if (topleft2 ~= -1 or topmid2 ~= -1 or topright2 ~= -1) then
		return false
	end

	-- Does it have at least one tile unoccupied next to it? (not counting tiki trap tiles)
	local topleft = get_grid_entity_at(x-1, y+1, l)
	local topright = get_grid_entity_at(x+1, y+1, l)
	local left = get_grid_entity_at(x-1, y, l)
	local right = get_grid_entity_at(x+1, y, l)
	local num_of_blocks = 0
	local avoid_both_top = false

	-- is not up against an arrowtrap?
	if (
		(topleft ~= -1 and get_entity(topleft).type.id == ENT_TYPE.FLOOR_ARROW_TRAP)
		or (topright ~= -1 and get_entity(topright).type.id == ENT_TYPE.FLOOR_ARROW_TRAP)
		or (left ~= -1 and get_entity(left).type.id == ENT_TYPE.FLOOR_ARROW_TRAP)
		or (right ~= -1 and get_entity(right).type.id == ENT_TYPE.FLOOR_ARROW_TRAP)
	) then
		-- message("tikitrap avoided arrowtrap")
		return false
	end

	if (
		topleft ~= -1
		and commonlib.has(valid_floors, get_entity_type(topleft))
	) then
		avoid_both_top = true
		num_of_blocks = num_of_blocks + 1
	end
	if (
		topright ~= -1
		and commonlib.has(valid_floors, get_entity_type(topright))
	) then
		if avoid_both_top then return false end
		num_of_blocks = num_of_blocks + 1
	end
	if (
		left ~= -1
		and commonlib.has(valid_floors, get_entity_type(left))
	) then
		num_of_blocks = num_of_blocks + 1
	end
	if (
		right ~= -1
		and commonlib.has(valid_floors, get_entity_type(right))
	) then
		num_of_blocks = num_of_blocks + 1
	end

	if num_of_blocks == 4 then return false end

	-- Is the top tiki part placed over an unoccupied space?
	local topmid = get_grid_entity_at(x, y+1, l)
	if topmid ~= -1 then return false end

	-- Does it have a block underneith?
	local bottom = get_grid_entity_at(x, y-1, l)
	if bottom == -1 then
		return false
	end
	if commonlib.has({ENT_TYPE.FLOOR_ALTAR, ENT_TYPE.FLOOR_SPIKES, ENT_TYPE.FLOOR_IDOL_BLOCK}, get_entity_type(bottom)) then
		return false
	end

	if not commonlib.has(valid_floors, get_entity_type(bottom)) then
		return false
	end

	-- debug_add_valid_space(x, y, DEBUG_RGB_BROWN)
	return true
end

local function is_valid_block_against_crushtrap(x, y, l)
	local uid = get_grid_entity_at(x, y, l)
	if uid == -1 then return false end
	local type = get_entity(uid).type.id
	return (
		type == ENT_TYPE.FLOORSTYLED_TEMPLE
		or type == ENT_TYPE.FLOORSTYLED_STONE
		or type == ENT_TYPE.FLOORSTYLED_MINEWOOD
		or type == ENT_TYPE.FLOORSTYLED_COG
		or type == ENT_TYPE.FLOOR_JUNGLE
		or type == ENT_TYPE.FLOOR_GENERIC
		or type == ENT_TYPE.FLOOR_ALTAR
		or type == ENT_TYPE.FLOOR_BORDERTILE
	)
end

local function is_invalid_block_against_crushtrap(x, y, l)
	local uid = get_grid_entity_at(x, y, l)
	if uid ~= -1 and get_entity(uid).type.id == ENT_TYPE.FLOOR_ARROW_TRAP then
		-- message("crushtrap avoided arrowtrap")
		return true
	end
	return false
end

function module.is_valid_crushtrap_spawn(x, y, l)
    if get_grid_entity_at(x, y, l) ~= -1 then return false end
	if is_non_grid_entity_at(x, y, l) then return false end
	if is_liquid_at(x, y) then return false end

	-- can only spawn in certain room ids
	if not is_valid_generic_trap_room(x, y) then
		return false
	end

	-- Has a floor below
	if not is_valid_block_against_crushtrap(x, y-1, l) then
		return false
	end

	-- cannot be up against an arrow trap or anti-trap block
	if (
		is_invalid_block_against_crushtrap(x-1, y, l)
		or is_invalid_block_against_crushtrap(x+1, y, l)
	) then
		return false
	end

	if is_anti_trap_at(x, y-1) then return false end

	-- debug_add_valid_space(x, y, DEBUG_RGB_ORANGE)
	return true
end

function module.is_valid_tombstone_spawn(x, y, l)
	-- need subchunkid of what room we're in
	local _, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	-- prevent spawning in lake
	if roomy > 4 then return false end

	if not is_valid_generic_trap_room(x, y) then
		return false
	end

	if is_door_at(x, y, l)
	or is_door_at(x, y+1, l) then
		return false
	end

	if get_grid_entity_at(x, y, l) ~= -1
	or get_grid_entity_at(x, y+1, l) ~= -1 then
		return false
	end

    return (
		detect_solid_nonshop_nontree(x, y - 1, l)
		and check_empty_space(x-1, y+1, l, 3, 1)
		and not is_liquid_at(x, y)
	)
end

module.is_invalid_dar_decor_spawn = is_liquid_at

function module.is_valid_giantfrog_spawn(x, y, l)
	return default_ground_monster_condition(x, y, l)
	and is_valid_monster_floor(x+1, y-1, l)
	and check_empty_space(x, y+1, l, 2, 2)
end

function module.is_valid_mammoth_spawn(x, y, l)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	return (
		_subchunk_id ~= roomdeflib.HD_SUBCHUNKID.UFO_RIGHTSIDE
		and check_empty_space(x-1, y+1, l, 4, 2)
		and is_valid_monster_floor(x+1, y-1, l)
		and default_ground_monster_condition(x, y, l)
	)
end

function module.is_valid_giantspider_spawn(x, y, l)
	local cx, cy = x+.5, y-.5
	local w, h = 2, 2
	local entity_uids = get_entities_overlapping_hitbox(
		0, MASK.FLOOR,
		AABB:new(
			cx-(w/2),
			cy+(h/2),
			cx+(w/2),
			cy-(h/2)
		),
		l
	)
	return (
		#entity_uids == 0
		and module.is_solid_grid_entity(x, y+1, l)
		and module.is_solid_grid_entity(x+1, y+1, l)
		and createlib.GIANTSPIDER_SPAWNED == false
		and detect_entrance_room_template(x, y, l) == false
	)
end

function module.is_valid_bee_spawn(x, y, l)
	return get_entity_type(get_grid_entity_at(x, y+1, l)) == ENT_TYPE.FLOORSTYLED_BEEHIVE
		and check_empty_space(x, y, l, 1, 2)
end

function module.is_valid_honey_spawn(x, y, l)
	return get_grid_entity_at(x, y, l) == -1
		and (
			get_entity_type(get_grid_entity_at(x, y+1, l)) == ENT_TYPE.FLOORSTYLED_BEEHIVE
			or get_entity_type(get_grid_entity_at(x, y-1, l)) == ENT_TYPE.FLOORSTYLED_BEEHIVE
		)
end

function module.is_valid_queenbee_spawn(x, y, l)
	local rx, ry = get_room_index(x, y)
	local levelrooms = roomgenlib.global_levelassembly.modification.levelrooms
	local _template_hd = levelrooms[ry+1] and (levelrooms[ry+1][rx+1] or 0) or 0
	return _template_hd >= 1300 and _template_hd < 1400 and check_empty_space(x, y, l, 3, 3)
end

function module.is_valid_ufo_spawn(x, y, l)
	local room = locatelib.get_levelroom_at_game_position(x, y)
	return (
		-- HD also avoids the coffin rooms here, but I think the API already accounts for that since we set S2 coffin rooms
		room ~= roomdeflib.HD_SUBCHUNKID.MOTHERSHIP_ALIENQUEEN
		and room ~= roomdeflib.HD_SUBCHUNKID.UFO_RIGHTSIDE
		and ceiling_entity_condition(x, y, l)
	)
end

function module.is_valid_bacterium_spawn(x, y, l)
	return get_grid_entity_at(x, y, l) == -1
	and not is_ladder_tile_at(x, y)
	and not is_liquid_at(x, y)
	and (
		module.is_solid_grid_entity(x, y+1, l)
		or module.is_solid_grid_entity(x+1, y, l)
		or module.is_solid_grid_entity(x, y-1, l)
		or module.is_solid_grid_entity(x-1, y, l)
	)
end

module.is_valid_eggsac_spawn = module.is_valid_bacterium_spawn

local function is_valid_window_spawn(x, y, l)
	return (
		get_grid_entity_at(x, y, l) == -1
		and get_grid_entity_at(x, y-1, l) == -1
		and #get_entities_at(0, MASK.DECORATION, x, y, l, 2) == 0
	)
end

function module.is_valid_hcastle_window_spawn(x, y, l)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	return (
		(
			_subchunk_id >= 202
			and _subchunk_id <= 207
		)
		and is_valid_window_spawn(x, y, l)
	)
end

function module.is_valid_vlad_window_spawn(x, y, l)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	return (
		(
			_subchunk_id > roomdeflib.HD_SUBCHUNKID.VLAD_TOP
			and _subchunk_id <= roomdeflib.HD_SUBCHUNKID.VLAD_BOTTOM
		)
		and is_valid_window_spawn(x, y, l)
	)
end

function module.is_valid_cog_door_spawn(x, y, layer)
	local roomx, roomy = locatelib.locate_levelrooms_position_from_game_position(x, y)
	local _subchunk_id = locatelib.get_levelroom_at(roomx, roomy)
	return get_grid_entity_at(x, y, layer) == -1
		and is_valid_monster_floor(x, y-1, layer)
		and not is_liquid_at(x, y)
		and not is_activefloor_at(x, y, layer)
		and commonlib.has(TEMPLE_PATH_ROOMS, _subchunk_id)
end

return module