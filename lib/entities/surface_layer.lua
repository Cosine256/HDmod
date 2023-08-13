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
    if depth ~= decorlib.SURFACE_BG_DEPTH.FOREGROUND then
        ent.width = 60
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

local function _create_surface_layer_looping_sub(x, y, depth)
    local bg_surface_layer = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_LAYER, 0, 0, LAYER.FRONT, 0, 0))
    bg_surface_layer.relative_x, bg_surface_layer.relative_y = x, y--seems to be 10 higher than intro
    module.set(bg_surface_layer, depth)

    local speed = 0.02
    if depth == decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND then
        speed = 0.015
        bg_surface_layer.animation_frame = 2
    elseif depth == decorlib.SURFACE_BG_DEPTH.BACK_BACKGROUND then
        speed = 0.01
        bg_surface_layer.animation_frame = 1
    end

    bg_surface_layer:set_post_update_state_machine(
        ---@param self Movable | Entity | BGSurfaceLayer
        function (self)
            if self.relative_x >= 93 then
                self.relative_x = self.relative_x - 119.97
            elseif decorlib.CREDITS_SCROLLING then
                self.relative_x = self.relative_x + speed
            end
        end
    )
end

function module.create_surface_layer_looping(x, y, depth)
    _create_surface_layer_looping_sub(x, y, depth)
    _create_surface_layer_looping_sub(x - 60, y, depth)
end

return module