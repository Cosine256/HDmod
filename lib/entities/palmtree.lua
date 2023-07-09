local module = {}

local day_texture_id
local night_texture_id
do
    local day_texture_def = TextureDefinition.new()
	day_texture_def.width = 1024
	day_texture_def.height = 1024
	day_texture_def.tile_width = 256
	day_texture_def.tile_height = 512
    day_texture_def.texture_path = 'res/palmtrees.png'
    day_texture_id = define_texture(day_texture_def)
    local day_layered_texture_def = TextureDefinition.new()
	day_layered_texture_def.width = 1024
	day_layered_texture_def.height = 1024
    day_layered_texture_def.sub_image_height = 512
    day_layered_texture_def.sub_image_width = 1024
    day_layered_texture_def.sub_image_offset_x = 0
    day_layered_texture_def.sub_image_offset_y = 512
	day_layered_texture_def.tile_width = 256
	day_layered_texture_def.tile_height = 512
    day_layered_texture_def.texture_path = 'res/palmtrees.png'
    day_layered_texture_id = define_texture(day_layered_texture_def)

    local night_texture_def = TextureDefinition.new()
	night_texture_def.width = 1024
	night_texture_def.height = 1024
	night_texture_def.tile_width = 256
	night_texture_def.tile_height = 512
    night_texture_def.texture_path = 'res/palmtrees_hardending.png'
    night_texture_id = define_texture(night_texture_def)
    local night_layered_texture_def = TextureDefinition.new()
	night_layered_texture_def.width = 1024
	night_layered_texture_def.height = 1024
    night_layered_texture_def.sub_image_height = 512
    night_layered_texture_def.sub_image_width = 1024
    night_layered_texture_def.sub_image_offset_x = 0
    night_layered_texture_def.sub_image_offset_y = 512
	night_layered_texture_def.tile_width = 256
	night_layered_texture_def.tile_height = 512
    night_layered_texture_def.texture_path = 'res/palmtrees_hardending.png'
    night_layered_texture_id = define_texture(night_layered_texture_def)
end

module.SURFACE_BG_DEPTH = {
    FOREGROUND = 5,
    BACKGROUND = 51
    -- FRONT BACKGROUND
    -- MID BACKGROUND
    -- BACK BACKGROUND
    -- SUN
    -- SKY
}

local function _create_palmtree(relative_x, relative_y, animation_frame, texture_id, depth, flipped)
    local flipped = flipped or false
    local size = 1
    if depth == module.SURFACE_BG_DEPTH.FOREGROUND then
        size = 1.2
    end
    ---@type BGSurfaceLayer
    local palmtree = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_ENTITY, 0, 0, LAYER.FRONT, 0, 0))
    palmtree.relative_x = relative_x
    palmtree.relative_y = relative_y
    palmtree:set_draw_depth(depth)
    palmtree.width = 3.75*size
    palmtree.height = 7.5*size
    palmtree.hitboxx = 1.875*size
    palmtree.hitboxy = 3.75*size
    palmtree:set_texture(texture_id)
    palmtree.animation_frame = animation_frame
    if flipped then
        flip_entity(palmtree.uid)
    end
    return palmtree.uid
end

function module.create_palmtree_day(relative_x, relative_y, animation_frame, depth, flipped)
    return _create_palmtree(relative_x, relative_y, animation_frame, day_texture_id, depth, flipped)
end

function module.create_palmtree_day_layered(relative_x, relative_y, animation_frame, depth, flipped)
    return _create_palmtree(relative_x, relative_y, animation_frame, day_layered_texture_id, depth, flipped)
end

function module.create_palmtree_night(relative_x, relative_y, animation_frame, depth, flipped)
    return _create_palmtree(relative_x, relative_y, animation_frame, night_texture_id, depth, flipped)
end

function module.create_palmtree_night_layered(relative_x, relative_y, animation_frame, depth, flipped)
    return _create_palmtree(relative_x, relative_y, animation_frame, night_layered_texture_id, depth, flipped)
end

return module