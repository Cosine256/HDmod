local module = {}

local valid_ash_tombstones = {}
local tombstones_texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 384
    texture_def.height = 128
    texture_def.tile_width = 128
    texture_def.tile_height = 128
	texture_def.texture_path = "res/tombstones.png"
	tombstones_texture_id = define_texture(texture_def)
end

function module.init()
	valid_ash_tombstones = {}
end

local function _create_tombstone(x, y, l)
    local tomb_uid = spawn(ENT_TYPE.FLOOR_EGGPLANT_ALTAR, x, y, l, 0, 0)
    set_entity_flags2(tomb_uid, set_flag(get_entity_flags2(tomb_uid), 22))
    local tomb = get_entity(tomb_uid)
    tomb:set_texture(tombstones_texture_id)
    return tomb_uid, tomb
end

function module.create_tombstone_common(x, y, l)
    local tomb_uid, tomb = _create_tombstone(x, y, l)
    tomb.animation_frame = 0

    if get_entity(get_grid_entity_at(x, y-1, l)).type.id ~= ENT_TYPE.FLOOR_BORDERTILE then
        valid_ash_tombstones[#valid_ash_tombstones+1] = tomb_uid
    end
end

function module.create_tombstone_king(x, y, l)
    get_entity(_create_tombstone(x, y, l)).animation_frame = 2
end

function module.set_ash_tombstone()
    if feelingslib.feeling_check(feelingslib.FEELING_ID.RESTLESS) then
        local tombstone = get_entity(valid_ash_tombstones[prng:random_index(#valid_ash_tombstones, PRNG_CLASS.LEVEL_GEN)])
        if tombstone then
            tombstone.animation_frame = 1

            local x, y, l = get_position(tombstone.uid)
            removelib.remove_embedded_at(x, y-1, l)
            embedlib.embed_item(
                spawn_entity(ENT_TYPE.ITEM_SHOTGUN, x, y-1, l, 0, 0),
                get_grid_entity_at(x, y-1, l),
                test_flag(state.special_visibility_flags, 1)
            )
        end
    end
end

return module