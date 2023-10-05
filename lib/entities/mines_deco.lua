local commonlib = require 'lib.common'
local validlib = require 'lib.spawning.valid'

local module = {}

local support_texture_id
local lantern_texture_id
local brace_texture_id
do
    local support_texture_definition = TextureDefinition.new()
    support_texture_definition.width = 256
    support_texture_definition.height = 256
    support_texture_definition.tile_width = 128
    support_texture_definition.tile_height = 256
    support_texture_definition.texture_path = "res/supportbeam.png"
    support_texture_id = define_texture(support_texture_definition)

    local lantern_texture_definition = TextureDefinition.new()
    lantern_texture_definition.width = 256
    lantern_texture_definition.height = 256
    lantern_texture_definition.tile_width = 128
    lantern_texture_definition.tile_height = 128
	lantern_texture_definition.sub_image_width = 128
	lantern_texture_definition.sub_image_height = 128
	lantern_texture_definition.sub_image_offset_x = 128
	lantern_texture_definition.sub_image_offset_y = 0
    lantern_texture_definition.texture_path = "res/supportbeam.png"
    lantern_texture_id = define_texture(lantern_texture_definition)

    local brace_texture_definition = TextureDefinition.new()
    brace_texture_definition.width = 256
    brace_texture_definition.height = 256
    brace_texture_definition.tile_width = 128
    brace_texture_definition.tile_height = 128
	brace_texture_definition.sub_image_width = 128
	brace_texture_definition.sub_image_height = 128
	brace_texture_definition.sub_image_offset_x = 128
	brace_texture_definition.sub_image_offset_y = 128
    brace_texture_definition.texture_path = "res/supportbeam.png"
    brace_texture_id = define_texture(brace_texture_definition)
end

local VALID_DECORATION_FLOOR = {ENT_TYPE.FLOOR_GENERIC, ENT_TYPE.FLOORSTYLED_MINEWOOD, ENT_TYPE.FLOOR_BORDERTILE}

function module.create_support_at_floor_uid(uid, flipped)
    local x, y, l = get_position(uid)
    local decoration = get_entity(spawn_entity(ENT_TYPE.DECORATION_MINEWOOD_POLE, x, y+1, l, 0, 0))
    decoration:set_draw_depth(6)
    if flipped then
        flip_entity(decoration.uid)
    end

    set_on_destroy(get_grid_entity_at(x, y+2, l), function(entity)
        decoration.flags = set_flag(decoration.flags, ENT_FLAG.INVISIBLE)
    end)
    set_on_destroy(uid, function(entity)
        decoration.flags = set_flag(decoration.flags, ENT_FLAG.INVISIBLE)
    end)
end

--1/2 chance to spawn a brace on either side
local function create_braces(x, y, random_flip)
    if not random_flip
    or (
        random_flip
        and prng:random_chance(2, PRNG_CLASS.LEVEL_DECO)
        and commonlib.has(VALID_DECORATION_FLOOR, get_entity_type(get_grid_entity_at(x-1, y+3, LAYER.FRONT)))
    ) then
        local brace = get_entity(spawn_entity(ENT_TYPE.MIDBG_STYLEDDECORATION, x-0.4, y+1.1, LAYER.FRONT, 0, 0))
        brace:set_texture(brace_texture_id)
        brace.animation_frame = 0
        brace.width = 1
        brace.height = 1
        brace:set_draw_depth(43)
    end

    if not random_flip
    or (
        random_flip
        and prng:random_chance(2, PRNG_CLASS.LEVEL_DECO)
        and commonlib.has(VALID_DECORATION_FLOOR, get_entity_type(get_grid_entity_at(x+1, y+3, LAYER.FRONT)))
    ) then
        local brace = get_entity(spawn_entity(ENT_TYPE.MIDBG_STYLEDDECORATION, x+0.4, y+1.1, LAYER.FRONT, 0, 0))
        brace:set_texture(brace_texture_id)
        brace.animation_frame = 0
        brace.width = 1
        brace.height = 1
        brace:set_draw_depth(43)
        flip_entity(brace.uid)
    end
end

function module.create_cutscene_support_bg(x, y, flipped)
    create_braces(x, y)

    local support = get_entity(spawn_entity(ENT_TYPE.MIDBG_STYLEDDECORATION, x, y+0.5, LAYER.FRONT, 0, 0))
    support:set_texture(support_texture_id)
    support.animation_frame = 0
    support.width = 1
    support.height = 2
    support:set_draw_depth(43)
    if flipped then
        flip_entity(support.uid)
    end
end

function module.create_support_bg(x, y, l)
    create_braces(x, y, true)

    local support = get_entity(spawn_entity(ENT_TYPE.MIDBG_STYLEDDECORATION, x, y+0.5, l, 0, 0))
    support:set_texture(support_texture_id)
    support.animation_frame = 0
    support.width = 1
    support.height = 2
    support:set_draw_depth(43)
    if test_flag(state.level_flags, 18) == false
    and prng:random_chance(7, PRNG_CLASS.LEVEL_DECO) then -- # TODO: Check real chance in Ghidra
        local lantern = get_entity(spawn_entity(ENT_TYPE.MIDBG_STYLEDDECORATION, x, y+0.5, l, 0, 0))
        lantern:set_texture(lantern_texture_id)
        lantern.animation_frame = 0
        lantern.width = 1
        lantern.height = 1
        lantern:set_draw_depth(43)
        flip_entity(lantern.uid)
    end
end

function module.add_mines_decorations()
	if state.theme == THEME.DWELLING then
		for _, uid in pairs(get_entities_by(VALID_DECORATION_FLOOR, MASK.FLOOR, LAYER.FRONT)) do
			local x, y, _ = get_position(uid)
			if get_grid_entity_at(x, y+1, LAYER.FRONT) == -1
            and not validlib.is_gurenteed_mines_ground_at(x, y+1) then
				if commonlib.has(VALID_DECORATION_FLOOR, get_entity_type(get_grid_entity_at(x, y+2, LAYER.FRONT)))
				and prng:random_chance(7, PRNG_CLASS.LEVEL_DECO)
				-- # TODO: and no mine pole currently in empty space
				then
                    module.create_support_at_floor_uid(uid, prng:random_chance(2, PRNG_CLASS.LEVEL_DECO))
				else
                    if get_grid_entity_at(x, y+2, LAYER.FRONT) == -1
                    and commonlib.has(VALID_DECORATION_FLOOR, get_entity_type(get_grid_entity_at(x, y+3, LAYER.FRONT)))
                    and #get_entities_at(ENT_TYPE.BG_DOOR, MASK.BG, x, y+1, LAYER.FRONT, 2) == 0
                    and prng:random_chance(7, PRNG_CLASS.LEVEL_DECO)
                    then
                        module.create_support_bg(x, y+1, LAYER.FRONT)
                    end
				end
			end
		end
	end
end

return module