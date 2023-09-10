local module = {}

local texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 128
    texture_def.height = 128
    texture_def.tile_width = 128
    texture_def.tile_height = 128
    texture_def.texture_path = "res/restless_crown.png"
    texture_id = define_texture(texture_def)
end

function module.create_kingbones(x, y, l)
    spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_BONES, x-0.1, y, l)
    local skull_uid = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_SKULL, x+0.1, y, l)
    flip_entity(skull_uid)

    -- local dar_crown = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_DIAMOND, x, y, l))
    local dar_crown_uid = spawn_entity_over(ENT_TYPE.ITEM_DIAMOND, skull_uid, -0.15, 0.42)
    local dar_crown = get_entity(dar_crown_uid)
    -- Correct the angle once not on the skull
    dar_crown.angle = -0.15
    dar_crown:set_post_update_state_machine(function (self)
        if not self.overlay then
            dar_crown.angle = 0
            clear_callback()
        end
    end)
    dar_crown:set_texture(texture_id)
end

return module