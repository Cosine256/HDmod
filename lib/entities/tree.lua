local validlib = require('lib.spawning.valid')

local module = {}

local ANIMATION_FRAMES_ENUM = {
    FACE = 1,
    BLOCK_DECO = 2,
	TREETOP_FRONT_CENTER = 3,
	TREETOP_FRONT_SIDE = 4,
	TREETOP_BACK = 5,
	DEAD_BRANCH_DECO = 6,
	DEAD_DAMAGE_DECO = 7,
	DEAD_BRANCH = 8,
	DEAD_TRUNK = 9,
	DEAD_BASE = 10,
	DEAD_TRUNK_DECO = 11,
	DEAD_TREETOP_BACK = 12,
	DEAD_TREETOP_FRONT = 13,
	DEAD_TRUNK_SIDE_DECO = 14,
}

local ANIMATION_FRAMES_RES = {
    { 0 },
    { 1, 2, 3 },
    { 0 },
    { 2 },
    { 3, 4 },
    { 0, 3, 6 },
    { 1 },
    { 4 },
    { 9 },
    { 12 },
    { 7, 10, 13 },
    { 8 },
    { 11 },
    { 14 },
}

local top_center_texture_id
local top_texture_id
local restless_texture_id
local dead_texture_id
do
	local top_center_texture_def = TextureDefinition.new()
	top_center_texture_def.width = 384
	top_center_texture_def.height = 256
	top_center_texture_def.tile_width = 256
	top_center_texture_def.tile_height = 128
	top_center_texture_def.texture_path = "res/treetop.png"
	top_center_texture_id = define_texture(top_center_texture_def)

	local top_texture_def = TextureDefinition.new()
	top_texture_def.width = 384
	top_texture_def.height = 256
	top_texture_def.tile_width = 128
	top_texture_def.tile_height = 128
	top_texture_def.texture_path = "res/treetop.png"
	top_texture_id = define_texture(top_texture_def)

	local restless_texture_def = TextureDefinition.new()
	restless_texture_def.width = 512
	restless_texture_def.height = 128
	restless_texture_def.tile_width = 128
	restless_texture_def.tile_height = 128
	restless_texture_def.texture_path = "res/restless_deco.png"
	restless_texture_id = define_texture(restless_texture_def)

	local dead_texture_def = TextureDefinition.new()
	dead_texture_def.width = 384
	dead_texture_def.height = 640
	dead_texture_def.tile_width = 128
	dead_texture_def.tile_height = 128
	dead_texture_def.texture_path = "res/templedeadtree.png"
	dead_texture_id = define_texture(dead_texture_def)
end

local function is_haunted()
	return (
		feelingslib.feeling_check(feelingslib.FEELING_ID.RESTLESS) == true
		or feelingslib.feeling_check(feelingslib.FEELING_ID.HAUNTEDCASTLE) == true
	)
end

local function is_dead_tree_area()
	return is_haunted()
	or state.theme == THEME.TEMPLE and not options.hd_og_floorstyle_temple
end

local function apply_properties_to_topbranch_and_deco(branch, front_deco)
	local left = test_flag(branch.flags, ENT_FLAG.FACING_LEFT)

	front_deco:set_texture(top_texture_id)
	front_deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.TREETOP_FRONT_SIDE][1]
	front_deco.x = left and 0.03 or -0.03
	front_deco.y = 0.15

	local back_deco = get_entity(spawn_entity_over(ENT_TYPE.DECORATION_TREETRUNK_TOPBACK, branch.uid, 0, 1.025))
	back_deco:set_texture(top_texture_id)
	back_deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.TREETOP_BACK][2]
	if left then flip_entity(back_deco.uid) end
end

-- HD-style tree decorating methods
local function decorate_tree(type, uid_to_spawn_over, x_off, y_off, radius, right)
	if uid_to_spawn_over == 0 then return 0 end
	local p_x, p_y, p_l = get_position(uid_to_spawn_over)
	-- get entities of type
	local entities = get_entities_at(type, 0, p_x+x_off, p_y, p_l, radius)
	local no_previous_entity_found = #entities == 0

	local entity = get_entity(not no_previous_entity_found and entities[1] or spawn_entity_over(type, uid_to_spawn_over, x_off, y_off))

	-- apply textures
	if type == ENT_TYPE.DECORATION_TREE then
		local index = prng:random_index(3, PRNG_CLASS.LEVEL_DECO)
		if is_dead_tree_area() then
			entity:set_texture(dead_texture_id)
			entity.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_BRANCH_DECO][index]
		else
			entity.animation_frame = 75+12*index
		end
	elseif type == ENT_TYPE.FLOOR_TREE_BRANCH
	and is_dead_tree_area() then
		entity:set_texture(dead_texture_id)
		entity.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_BRANCH][1]
	elseif type == ENT_TYPE.DECORATION_TREE_VINE_TOP then
		apply_properties_to_topbranch_and_deco(get_entity(uid_to_spawn_over), entity)
	end

	-- flip if you just created it and it's a 0x100 and it's on the left or if it's 0x200 and on the right.
	-- flipped = test_flag(entity.flags, ENT_FLAG.FACING_LEFT)
	if (
		type == ENT_TYPE.FLOOR_TREE_BRANCH
		and x_off == -1
		and entity.type.search_flags == 0x100
		and no_previous_entity_found
	) then -- to flip entities
		flip_entity(entity.uid)
	elseif (entity.type.search_flags == 0x200 and right == false) then -- to flip decorations
		entity.flags = set_flag(entity.flags, ENT_FLAG.FACING_LEFT)
	end
	return entity.uid
end

local function apply_trunk_textures(trunk)
	local to_decorate = {ENT_TYPE.DECORATION_TREETRUNK_TOPFRONT, ENT_TYPE.DECORATION_TREETRUNK_TOPBACK}
	if is_dead_tree_area() then
		to_decorate = {ENT_TYPE.DECORATION_TREETRUNK_CLIMBINGHINT, ENT_TYPE.DECORATION_TREE, ENT_TYPE.DECORATION_TREETRUNK_TOPFRONT, ENT_TYPE.DECORATION_TREETRUNK_TOPBACK}
		trunk:set_texture(dead_texture_id)
		trunk.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TRUNK][1]
	end
	for _, deco_uid in pairs(entity_get_items_by(trunk.uid, to_decorate, MASK.DECORATION)) do
		local deco = get_entity(deco_uid)
		if deco.type.id == ENT_TYPE.DECORATION_TREETRUNK_CLIMBINGHINT then
			deco:set_texture(dead_texture_id)
			deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TRUNK_SIDE_DECO][1]
		elseif deco.type.id == ENT_TYPE.DECORATION_TREE then
			if is_haunted()
			and prng:random_chance(12, PRNG_CLASS.LEVEL_DECO) then
				deco:set_texture(restless_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.FACE][1]
			elseif deco.animation_frame == 100 then
				deco:destroy()--remove since the texture has no replacement
			elseif deco.animation_frame == 112 then
				deco:set_texture(dead_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TRUNK_DECO][1]
			elseif deco.animation_frame == 124 then
				deco:set_texture(dead_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TRUNK_DECO][2]
			elseif deco.animation_frame == 136 then
				deco:set_texture(dead_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TRUNK_DECO][3]
			end
		elseif deco.type.id == ENT_TYPE.DECORATION_TREETRUNK_TOPFRONT then
			if is_dead_tree_area() then
				deco:set_texture(dead_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TREETOP_FRONT][1]
			else
				deco:set_texture(top_center_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.TREETOP_FRONT_CENTER][1]
				deco.width = 2
				deco:set_draw_depth(10)
				deco.y = 0.15
			end
		elseif deco.type.id == ENT_TYPE.DECORATION_TREETRUNK_TOPBACK then
			if is_dead_tree_area() then
				deco:set_texture(dead_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_TREETOP_BACK][1]
			else
				deco:set_texture(top_texture_id)
				deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.TREETOP_BACK][1]
			end
		end
	end
end

local function add_top_branches(treetop_uid)
	local branch_uid_left = decorate_tree(ENT_TYPE.FLOOR_TREE_BRANCH, treetop_uid, -1, 0, 0.1, false)
	local branch_uid_right = decorate_tree(ENT_TYPE.FLOOR_TREE_BRANCH, treetop_uid, 1, 0, 0.1, false)
	if is_dead_tree_area() then
		decorate_tree(ENT_TYPE.DECORATION_TREE, branch_uid_left, 0.03, 0.47, 0.5, false)
		decorate_tree(ENT_TYPE.DECORATION_TREE, branch_uid_right, -0.03, 0.47, 0.5, true)
	else
		decorate_tree(ENT_TYPE.DECORATION_TREE_VINE_TOP, branch_uid_left, 0.03, 0.47, 0.5, false)
		decorate_tree(ENT_TYPE.DECORATION_TREE_VINE_TOP, branch_uid_right, -0.03, 0.47, 0.5, true)
	end
	-- apply textures to treetop
	apply_trunk_textures(get_entity(treetop_uid))
end

local vine_top_positions = {}
-- Since once the VINE_TREE_TOP spawns over a branch, it can't be fixed, we have to prevent it from spawning. Another way would be to just spawn another branch
set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
	if spawn_flags & SPAWN_TYPE.SCRIPT ~= 0 then return end
	-- messpect("Removed tree vine at:", x, y)
	local uid_at = get_grid_entity_at(x, y, layer)
	vine_top_positions[#vine_top_positions+1] = {x, y}
	if uid_at ~= -1 then
		return uid_at
	end
end, SPAWN_TYPE.LEVEL_GEN_GENERAL, MASK.FLOOR, ENT_TYPE.FLOOR_VINE_TREE_TOP)

function module.postlevelgen_decorate_trees()
	if (
		state.theme == THEME.JUNGLE or state.theme == THEME.TEMPLE
	) then
		-- remove tree vines
		for _, pos in pairs(vine_top_positions) do
			local x, top_y = pos[1], pos[2]
			local floor_at_uid = get_grid_entity_at(x, top_y, LAYER.FRONT)
			if get_entity_type(floor_at_uid) == ENT_TYPE.FLOOR_VINE_TREE_TOP then
				get_entity(floor_at_uid):destroy()
			end
			local is_left = get_entity_type(get_grid_entity_at(x+1, top_y-1, LAYER.FRONT)) == ENT_TYPE.FLOOR_TREE_TOP
			local is_right = get_entity_type(get_grid_entity_at(x-1, top_y-1, LAYER.FRONT)) == ENT_TYPE.FLOOR_TREE_TOP
			-- Update branch decorations
			local is_top = (
				is_right
				or is_left
			)
			local branch_uid = get_grid_entity_at(x, top_y-1, LAYER.FRONT)
			local deco = get_entity(entity_get_items_by(branch_uid, ENT_TYPE.DECORATION_TREE_VINE_TOP, 0)[1])
			local x_offset = is_left and 0.03 or -0.03
			-- decorate normal branches
			if
				not is_top
				and is_haunted()
			then
				deco:destroy()
				decorate_tree(ENT_TYPE.DECORATION_TREE, branch_uid, x_offset, 0.47, 0.5, false)
			end
			-- apply top branch texture
			if
				is_top
				and not is_dead_tree_area()
			then
				apply_properties_to_topbranch_and_deco(get_entity(branch_uid), deco)
			end

			local y = top_y
			repeat
				y = y - 1
				local branch_vine_uid = get_grid_entity_at(x, y, LAYER.FRONT)
				if entity_has_item_type(branch_vine_uid, ENT_TYPE.DECORATION_TREE_VINE) then
					local vine_decor_uid = entity_get_items_by(branch_vine_uid, ENT_TYPE.DECORATION_TREE_VINE, MASK.DECORATION)[1]
					get_entity(vine_decor_uid):destroy()
					set_entity_flags(branch_vine_uid, clr_flag(get_entity_flags(branch_vine_uid), ENT_FLAG.CLIMBABLE))
				elseif get_entity_type(branch_vine_uid) == ENT_TYPE.FLOOR_VINE then
					get_entity(branch_vine_uid):destroy()
				end
			until get_entity_type(branch_vine_uid) ~= ENT_TYPE.FLOOR_TREE_BRANCH and get_entity_type(branch_vine_uid) ~= ENT_TYPE.FLOOR_VINE
		end
	end
	vine_top_positions = {}
end

function module.create_hd_tree(x, y, l)
	-- create base
	local cur_trunk = get_entity(spawn_grid_entity(ENT_TYPE.FLOOR_TREE_BASE, x, y, l))
	if is_dead_tree_area() then
		cur_trunk:set_texture(dead_texture_id)
		cur_trunk.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.DEAD_BASE][1]
	end

	local max_height = 6
	-- if 1/3 chance passes, set maximum to 5
	if prng:random_chance(3, PRNG_CLASS.LEVEL_GEN) then max_height = 5 end

	for i = 3, max_height, 1 do
		-- if any of the 3 blocks above i are occupied, spawn 2 branches and break
		local topleft2 = get_grid_entity_at(x-1, y+i, l)
		local topmid2 = get_grid_entity_at(x, y+i, l)
		local topright2 = get_grid_entity_at(x+1, y+i, l)
		if (
			(topleft2 ~= -1 or topmid2 ~= -1 or topright2 ~= -1)
			or i == max_height
		) then
			add_top_branches(spawn_entity_over(ENT_TYPE.FLOOR_TREE_TOP, cur_trunk.uid, 0, 1))
			break
		end
		-- spawn trunk at i
		cur_trunk = get_entity(spawn_entity_over(ENT_TYPE.FLOOR_TREE_TRUNK, cur_trunk.uid, 0, 1))
		apply_trunk_textures(cur_trunk)

		-- if if 1/3 chance passes, spawn branch on left side
		if prng:random_chance(3, PRNG_CLASS.LEVEL_GEN) then
			decorate_tree(ENT_TYPE.DECORATION_TREE, decorate_tree(ENT_TYPE.FLOOR_TREE_BRANCH, cur_trunk.uid, -1, 0, 0.1, false), 0.03, 0.47, 0.5, false)
		end
		-- if if 1/3 chance passes, spawn branch on right side
		if prng:random_chance(3, PRNG_CLASS.LEVEL_GEN) then
			decorate_tree(ENT_TYPE.DECORATION_TREE, decorate_tree(ENT_TYPE.FLOOR_TREE_BRANCH, cur_trunk.uid, 1, 0, 0.1, false), -0.03, 0.47, 0.5, true)
		end
	end
end

function module.onlevel_decorate_haunted()
	-- decorate grass
	if feelingslib.feeling_check(feelingslib.FEELING_ID.RESTLESS) then
		for _, uid in pairs(get_entities_by_type(ENT_TYPE.DECORATION_JUNGLEBUSH)) do
			local x, y, _ = get_position(uid)
			if (
				not validlib.is_invalid_dar_decor_spawn(x, y)
				and prng:random_chance(2, PRNG_CLASS.LEVEL_DECO)
			) then
				local deco = get_entity(uid)
				deco:set_texture(restless_texture_id)
				if deco.animation_frame == 53 then
					deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.BLOCK_DECO][1]
				elseif deco.animation_frame == 54 then
					deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.BLOCK_DECO][2]
				elseif deco.animation_frame == 55 then
					deco.animation_frame = ANIMATION_FRAMES_RES[ANIMATION_FRAMES_ENUM.BLOCK_DECO][3]
				end
			end
		end
	end
end

return module