local module = {}

local idol_texture_id
do
    local idol_texture_def = TextureDefinition.new()
    idol_texture_def.width = 512
    idol_texture_def.height = 512
    idol_texture_def.tile_width = 512
    idol_texture_def.tile_height = 512
    idol_texture_def.texture_path = "res/ending_giantidol.png"
    idol_texture_id = define_texture(idol_texture_def)
end

---@param hard boolean
function module.set_ending_treasure_texture(ent, hard)
    ent:set_texture(idol_texture_id)
end

---@param hard boolean
function module.create_ending_treasure(x, y, l, vx, vy, hard)
    local ent = get_entity(spawn_entity(ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, x, y, l, vx, vy))
    module.set_ending_treasure_texture(ent, hard)
    return ent.uid
end

function module.set_ending_treasure_texture(ent, hard)
    ent:set_texture(idol_texture_id)
end

return module