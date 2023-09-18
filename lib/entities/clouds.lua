local module = {}
local decorlib = require('lib.gen.decor')

local texture_id
local hard_texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 1024
    texture_def.height = 512
    texture_def.tile_width = 1024
    texture_def.tile_height = 512
    texture_def.texture_path = "res/cloudday.png"
    texture_id = define_texture(texture_def)

    local hard_texture_def = TextureDefinition.new()
    hard_texture_def.width = 1024
    hard_texture_def.height = 512
    hard_texture_def.tile_width = 1024
    hard_texture_def.tile_height = 512
    hard_texture_def.texture_path = "res/cloudnight.png"
    hard_texture_id = define_texture(hard_texture_def)
end

local function set(ent)
    ent.width = decorlib.SURFACE_BG_WIDTH
    ent.height = 7.5
    ent.hitboxx = 30
    ent.hitboxy = 1.875
    ent.tile_width = 4
    ent.tile_height = 1
    ent:set_draw_depth(decorlib.SURFACE_BG_DEPTH.CLOUDS)
    ent:set_texture(state.win_state == WIN_STATE.HUNDUN_WIN and hard_texture_id or texture_id)
    ent.animation_frame = 0
end

local function _create_cloud(y, x)
    local ent = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_LAYER, 0, 0, LAYER.FRONT, 0, 0))
    ent.relative_x, ent.relative_y = decorlib.SURFACE_BG_CENTER + x, y
    set(ent)

    ent:set_post_update_state_machine(
        ---@param self Movable | Entity | BGSurfaceLayer
        function (self)
            if self.relative_x >= 93 then
                self.relative_x = self.relative_x - 119.97
            else
                self.relative_x = self.relative_x + decorlib.get_surface_bg_speed(decorlib.SURFACE_BG_DEPTH.CLOUDS)
            end
        end
    )
    return ent
end

function module.create_clouds(y)
    _create_cloud(y, decorlib.SURFACE_BG_WIDTH)
    _create_cloud(y, 0)
end

return module