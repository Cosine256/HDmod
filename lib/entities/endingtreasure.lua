local module = {}
local decorlib = require('lib.gen.decor')

local idol_texture_id
local idol_normal_texture_id
do
    local idol_texture_def = TextureDefinition.new()
    idol_texture_def.width = 512
    idol_texture_def.height = 512
    idol_texture_def.tile_width = 512
    idol_texture_def.tile_height = 512
    idol_texture_def.texture_path = "res/ending_giantidol.png"
    idol_texture_id = define_texture(idol_texture_def)

    local idol_normal_texture_def = TextureDefinition.new()
    idol_normal_texture_def.width = 512
    idol_normal_texture_def.height = 512
    idol_normal_texture_def.tile_width = 512
    idol_normal_texture_def.tile_height = 512
    idol_normal_texture_def.texture_path = "res/ending_giantidol_normal.png"
    idol_normal_texture_id = define_texture(idol_normal_texture_def)
end

---treasure
---@param ent Treasure | HundunChest
function module.set_ending_treasure(ent)
    ent:set_texture(
        -- state.win_state == WIN_STATE.HUNDUN_WIN and yama_treasure_id or
        idol_texture_id)
    ent.rendering_info:set_normal_map_texture(
        -- state.win_state == WIN_STATE.HUNDUN_WIN and yama_treasure_normal_id or
    idol_normal_texture_id)
    ent.rendering_info.shader = 30

    ent.hitboxx = 1.150
    if state.screen == SCREEN.CREDITS then
        ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    end
    if state.screen == SCREEN.SCORES then
        ent:set_post_update_state_machine(
        ---@param self HundunChest | Treasure    
        function (self)
            self.move_state = 0
        end)
    end
end

function module.create_ending_treasure(x, y, l, vx, vy)
    local ent = get_entity(spawn_entity(ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, x, y, l, vx, vy))
    module.set_ending_treasure(ent)
    return ent.uid
end

function module.create_credits_treasure(x, y, l)
    -- use a no-gravity rock as a base
    local base = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_ROCK, x, y, l))
    local _, _y, _ = get_position(base.uid)

    -- base.flags = set_flag(base.flags, ENT_FLAG.NO_GRAVITY)
    base.flags = set_flag(base.flags, ENT_FLAG.INVISIBLE)
    base.flags = set_flag(base.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    -- base.flags = set_flag(base.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)

    -- spawn the cavemen and treasure offset from rock base
    local treasure = get_entity(module.create_ending_treasure(x, _y+2.65, l, 0, 0))
    attach_entity(base.uid, treasure.uid)
    -- # TODO: move treasure in a sine-wave **use yama's phase 2 as an example

    -- move the entity to the left until decorlib.CREDITS_SCROLL is true
    set_post_statemachine(base.uid, function (self)
        if not decorlib.CREDITS_SCROLLING then
            self.velocityx = -0.095
        end
    end)
    return base.uid
end

return module