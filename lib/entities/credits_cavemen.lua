local module = {}
local animationlib = require('lib.entities.animation')

local CAVEMAN_ANIMATIONS = {
    WALK = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0, loop = true, frames = 10, frame_time = 6}
}

local caveman_texture_id
do
    local caveman_texture_def = TextureDefinition.new()
    caveman_texture_def.width = 640
    caveman_texture_def.height = 256
    caveman_texture_def.tile_width = 128
    caveman_texture_def.tile_height = 128
    caveman_texture_def.texture_path = "res/ending_caveman.png"
    caveman_texture_id = define_texture(caveman_texture_def)
end

---@param ent Caveman
local function credits_caveman_update(ent)
    ent.animation_frame = animationlib.get_animation_frame(ent.user_data)
    animationlib.update_timer(ent.user_data)
end

function module.create_credits_caveman(base_uid, x, y, l)
    -- spawn cavemen as corpses so we don't have to worry about state
    local caveman = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.MONS_CAVEMAN, x, y, l))
    attach_entity(base_uid, caveman.uid)
    caveman:set_texture(caveman_texture_id)
    caveman.animation_frame = 0
    caveman.health = 0
    caveman.last_state = caveman.state
    caveman.state = 22
    caveman.stand_counter = 0
    caveman.flags = set_flag(caveman.flags, ENT_FLAG.DEAD)
    caveman.flags = set_flag(caveman.flags, ENT_FLAG.FACING_LEFT)
    -- caveman.flags = set_flag(caveman.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    -- caveman.flags = set_flag(caveman.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    -- caveman.flags = set_flag(caveman.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    caveman.flags = set_flag(caveman.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    caveman.user_data = {
        animation_timer = 0,
    }
    -- custom animate cavemen
    animationlib.set_animation(caveman.user_data, CAVEMAN_ANIMATIONS.WALK)
    set_post_statemachine(caveman.uid, credits_caveman_update)

    return caveman.uid
end

return module