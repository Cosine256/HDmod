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
    BACKWALL = 49,
    BACKGROUND = 50,
    -- FRONT_BACKGROUND = 50,
    MID_BACKGROUND = 51,
    BACK_BACKGROUND = 52,
    SUN = 53,
    SKY = 53,
}

function module.create_palmtree(relative_x, relative_y, animation_frame, depth, flipped)
    local flipped = flipped or false
    local size = 1
    if depth == module.SURFACE_BG_DEPTH.FOREGROUND then
        size = 1.2
    elseif depth == module.SURFACE_BG_DEPTH.MID_BACKGROUND then
        size = 0.6
    elseif depth == module.SURFACE_BG_DEPTH.BACK_BACKGROUND then
        size = 0.3
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
    local texture_id
    if state.win_state == WIN_STATE.HUNDUN_WIN then
        texture_id = depth > module.SURFACE_BG_DEPTH.BACKGROUND and night_layered_texture_id or night_texture_id
    else
        texture_id = depth > module.SURFACE_BG_DEPTH.BACKGROUND and day_layered_texture_id or day_texture_id
    end
    palmtree:set_texture(texture_id)
    palmtree.animation_frame = animation_frame
    if flipped then
        flip_entity(palmtree.uid)
    end
    return palmtree.uid
end

function module.create_palmtree_relative(offset_x, offset_y, animation_frame, depth, overlay, flipped)
    --spawn a palmtree offset from those coordinates
    --every frame, update the palmtree with the offset applied to the overlay's coordinates
    get_entity(module.create_palmtree(overlay.relative_x+offset_x, overlay.relative_y+offset_y, animation_frame, depth, flipped)):set_post_update_state_machine(function (self)
        self.x = overlay.x + offset_x
        self.y = overlay.y + offset_y
    end)
end

return module