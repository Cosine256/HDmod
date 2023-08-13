local module = {}
local decorlib = require('lib.gen.decor')

local sky_hard_texture_id
local surface_hard_texture_id
local surface_foreground_hard_texture_id
do
    local sky_hard_texture_def = TextureDefinition.new()
    sky_hard_texture_def.width = 512
    sky_hard_texture_def.height = 512
    sky_hard_texture_def.tile_width = 512
    sky_hard_texture_def.tile_height = 512
    sky_hard_texture_def.texture_path = "res/base_sky_hardending.png"
    sky_hard_texture_id = define_texture(sky_hard_texture_def)

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

local function _create_surface_layer_looping_sub(x, y, depth)
    local bg_surface_layer = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_LAYER, 0, 0, LAYER.FRONT, 0, 0))
    bg_surface_layer.relative_x, bg_surface_layer.relative_y = x, y--seems to be 10 higher than intro
    bg_surface_layer.width = 60
    bg_surface_layer.height = 3.75
    bg_surface_layer.hitboxx = 30
    bg_surface_layer.hitboxy = 1.875
    bg_surface_layer.tile_width = 4
    bg_surface_layer.tile_height = 1
    bg_surface_layer.animation_frame = 3
    bg_surface_layer:set_draw_depth(depth)
    if state.win_state == WIN_STATE.HUNDUN_WIN then
        bg_surface_layer:set_texture(surface_hard_texture_id)
    end

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