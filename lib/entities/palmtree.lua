local module = {}
local decorlib = require('lib.gen.decor')

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

local debug_relative_deco
local DEBUG_RGB_GREEN = rgba(153, 196, 19, 170)

function module.debug_init()
	debug_relative_deco = {}
end

local function debug_add_deco(overlay_uid, uid, offx, offy, color)
	debug_relative_deco[#debug_relative_deco+1] = {}
	debug_relative_deco[#debug_relative_deco].uid = uid
	debug_relative_deco[#debug_relative_deco].overlay_uid = overlay_uid
	debug_relative_deco[#debug_relative_deco].offx = offx
	debug_relative_deco[#debug_relative_deco].offy = offy
	debug_relative_deco[#debug_relative_deco].color = color
end

function module.create_palmtree(relative_x, relative_y, animation_frame, depth, flipped)
    local flipped = flipped or false
    local size = 1
    if depth == decorlib.SURFACE_BG_DEPTH.FOREGROUND then
        size = 1.2
    elseif depth == decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND then
        size = 0.6
    elseif depth == decorlib.SURFACE_BG_DEPTH.BACK_BACKGROUND then
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
        texture_id = depth > decorlib.SURFACE_BG_DEPTH.BACKGROUND and night_layered_texture_id or night_texture_id
    else
        texture_id = depth > decorlib.SURFACE_BG_DEPTH.BACKGROUND and day_layered_texture_id or day_texture_id
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
    local palmtree = get_entity(module.create_palmtree(overlay.relative_x+offset_x, overlay.relative_y+offset_y, animation_frame, depth, flipped))
    palmtree:set_post_update_state_machine(function (self)
        self.x = overlay.x + offset_x
        self.y = overlay.y + offset_y
    end)
    -- debug_add_deco(overlay.uid, palmtree.uid, offset_x, offset_y, DEBUG_RGB_GREEN)
end

-- set_callback(function(draw_ctx)
--     if debug_relative_deco and #debug_relative_deco > 0 then
--         for _, debug_attr in pairs(debug_relative_deco) do
--             local overlay = get_entity(debug_attr.overlay_uid)
--             if get_entity(debug_attr.uid) and overlay then
--                 -- local x, y, _ = get_render_position(debug_attr.uid)--doesn't work
--                 local ox, oy = overlay.x+debug_attr.offx, overlay.y+debug_attr.offy
--                 local x, y, _ = screen_position(ox, oy)
--                 draw_ctx:draw_text(
--                     x, y, 25,
--                     string.format("%s on %s: offset %s, %s", debug_attr.overlay_uid, debug_attr.uid, debug_attr.offx, debug_attr.offy),
--                     debug_attr.color
--                 )
--                 -- if state.pause == 0 then
--                 --     message(string.format("%s on %s: offset %s, %s applied off: %s, %s", debug_attr.overlay_uid, debug_attr.uid, debug_attr.offx, debug_attr.offy, ox, oy))
--                 -- end
--             end
--         end
--     end
-- end, ON.GUIFRAME)

return module