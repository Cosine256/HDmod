local module = {}

local blocks = {}

local texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 128
    texture_def.height = 128
    texture_def.tile_width = 128
    texture_def.tile_height = 128
    texture_def.texture_path = "res/idoltrap_floor.png"
    texture_id = define_texture(texture_def)
end


function module.init()
    blocks = {}
end

function module.create_endingplatform(x, y, l)
    local block = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, l, 0, 0))
    block.flags = set_flag(block.flags, ENT_FLAG.NO_GRAVITY)
    block.more_flags = set_flag(block.more_flags, 17)
    block:set_texture(texture_id)

    blocks[#blocks+1] = block.uid
end

return module