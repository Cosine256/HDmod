local module = {}
local decorlib = require('lib.gen.decor')

local surface_hard_texture_id
local surface_foreground_hard_texture_id
do
    local surface_hard_texture_def = TextureDefinition.new()
    surface_hard_texture_def.width = 1024
    surface_hard_texture_def.height = 1024
    surface_hard_texture_def.tile_width = 1024
    surface_hard_texture_def.tile_height = 256
    surface_hard_texture_def.texture_path = "res/base_surface_hardending.png"
    surface_hard_texture_id = define_texture(surface_hard_texture_def)

    local surface_foreground_hard_texture_def = TextureDefinition.new()
    surface_foreground_hard_texture_def.width = 1024
    surface_foreground_hard_texture_def.height = 1024
    surface_foreground_hard_texture_def.tile_width = 512
    surface_foreground_hard_texture_def.tile_height = 256
    surface_foreground_hard_texture_def.texture_path = "res/base_surface_hardending.png"
    surface_foreground_hard_texture_id = define_texture(surface_foreground_hard_texture_def)
end

function module.set(ent, depth)
    if depth == decorlib.SURFACE_BG_DEPTH.FOREGROUND then
        ent.width = 7.5
        ent.height = 3.75
        ent.hitboxx = 3.75
        ent.hitboxy = 1.875
        ent.tile_width = 1
        ent.tile_height = 1
        ent:set_texture(TEXTURE.DATA_TEXTURES_BASE_SURFACE_1)
    else
        ent.width = decorlib.BG_WIDTH
        ent.height = 3.75
        ent.hitboxx = 30
        ent.hitboxy = 1.875
        ent.tile_width = 4
        ent.tile_height = 1
        if depth == decorlib.SURFACE_BG_DEPTH.BACKGROUND then
            ent.animation_frame = 3
        elseif depth == decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND then
            ent.animation_frame = 2
        elseif depth == decorlib.SURFACE_BG_DEPTH.BACK_BACKGROUND then
            ent.animation_frame = 1
        end
    end
    ent:set_draw_depth(depth)
    if state.win_state == WIN_STATE.HUNDUN_WIN then
        ent:set_texture(depth == decorlib.SURFACE_BG_DEPTH.FOREGROUND and surface_foreground_hard_texture_id or surface_hard_texture_id)
    end
end

function module.create_surface_layer_looping(y, depth, is_offset, animation_frame)
    local ent = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_LAYER, 0, 0, LAYER.FRONT, 0, 0))
    ent.relative_x, ent.relative_y = decorlib.BG_CENTER + (is_offset and decorlib.BG_WIDTH or 0), y--seems to be 10 higher than intro
    module.set(ent, depth)

    if animation_frame then -- # TODO: Refactor setting animation frame into module.set()
        ent.animation_frame = animation_frame
    elseif depth == decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND then
        ent.animation_frame = 2
    elseif depth == decorlib.SURFACE_BG_DEPTH.BACK_BACKGROUND then
        ent.animation_frame = 1
    end

    ent:set_post_update_state_machine(
        ---@param self Movable | Entity | BGSurfaceLayer
        function (self)
            if self.relative_x >= 93 then
                self.relative_x = self.relative_x - 119.97
            elseif decorlib.CREDITS_SCROLLING then
                self.relative_x = self.relative_x + decorlib.get_surface_bg_speed(depth)
            end
        end
    )
    return ent
end

function module.create_surface_layer_foreground_relative(offset_x, offset_y, animation_frame, overlay)
    local ent = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_LAYER, 0, 0, LAYER.FRONT, 0, 0))
    module.set(ent, decorlib.SURFACE_BG_DEPTH.FOREGROUND)
    ent.animation_frame = animation_frame
    ent.relative_x, ent.relative_y = overlay.relative_x+offset_x, overlay.relative_y+offset_y
    ent:set_post_update_state_machine(function (self)
        self.x = overlay.x + offset_x
        self.y = overlay.y + offset_y
    end)
end

return module