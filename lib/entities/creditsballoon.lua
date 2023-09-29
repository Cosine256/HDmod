local module = {}
local decorlib = require('lib.gen.decor')

local texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 1536
    texture_def.height = 1024
    texture_def.tile_width = 512
    texture_def.tile_height = 512
    texture_def.texture_path = "res/bloons.png"
    texture_id = define_texture(texture_def)
end

function module.create_creditsballoon(x, y, l, animation_frame, timeout)
    ---@type Movable | Entity
    local base = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, x, y, l, 0, 0))
    base.flags = set_flag(base.flags, ENT_FLAG.INVISIBLE)
    base.flags = set_flag(base.flags, ENT_FLAG.NO_GRAVITY)
    base.flags = set_flag(base.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)

    local ent = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, x, y, l, 0, 0))
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    attach_entity(base.uid, ent.uid)
    ent:set_texture(texture_id)
    ent.animation_frame = animation_frame
    ent.width, ent.height = 4, 4
    ent:set_draw_depth(decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND)
    
    local enter = false
    base:set_post_update_state_machine(function (self)
        if timeout > 0 then
            timeout = timeout - 1
        elseif not enter then
            base.velocityx = -0.00265
            base.velocityy = 0.00025
            enter = true
        else
            -- apply a sinewave effect to the y offset position
            local basex, _, _ = get_position(base.uid)
            ent.y = math.sin(basex*4)*0.25
            -- message(string.format("ent.y: %s", ent.y))
        end
    end)

    -- gradually shrink overtime
end

return module