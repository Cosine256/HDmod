local module = {}

local texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 128
    texture_def.height = 128
    texture_def.tile_width = 128
    texture_def.tile_height = 128
    texture_def.texture_path = "res/pushblock_temple_stone.png"
    texture_id = define_texture(texture_def)
end

function module.create_pushblock(x, y, l)
    ---@type Floor
    local ent = get_entity(spawn_grid_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, l))
    if ent then
        if state.theme == THEME.TEMPLE and options.hd_og_floorstyle_temple then
            ent:set_texture(texture_id)
            ent.animation_frame = 0
        elseif state.theme == THEME.CITY_OF_GOLD then
            ent:set_post_destroy(function (entity)
                spawn(ENT_TYPE.ITEM_NUGGET, x, y, l, prng:random_float(PRNG_CLASS.AI)*0.2-0.1, prng:random_float(PRNG_CLASS.AI)*0.1+0.1)
            end)
        end
    end
end

return module