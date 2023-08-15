local module = {}
local decorlib = require('lib.gen.decor')
local animationlib = require('lib.entities.animation')

local CAVEMAN_ANIMATIONS = {
    WALK = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0, loop = true, frames = 10, frame_time = 6}
}

local idol_texture_id
local caveman_texture_id
do
    local idol_texture_def = TextureDefinition.new()
    idol_texture_def.width = 512
    idol_texture_def.height = 512
    idol_texture_def.tile_width = 512
    idol_texture_def.tile_height = 512
    idol_texture_def.texture_path = "res/ending_giantidol.png"
    idol_texture_id = define_texture(idol_texture_def)

    local caveman_texture_def = TextureDefinition.new()
    caveman_texture_def.width = 640
    caveman_texture_def.height = 256
    caveman_texture_def.tile_width = 128
    caveman_texture_def.tile_height = 128
    caveman_texture_def.texture_path = "res/ending_caveman.png"
    caveman_texture_id = define_texture(caveman_texture_def)
end

function module.set_ending_treasure(ent)
    ent:set_texture(
        -- state.win_state == WIN_STATE.HUNDUN_WIN and yama_treasure_id or
    idol_texture_id)
    if state.screen == SCREEN.CREDITS then
        ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    end
end

function module.create_ending_treasure(x, y, l, vx, vy)
    local ent = get_entity(spawn_entity(ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, x, y, l, vx, vy))
    module.set_ending_treasure(ent)
    return ent.uid
end

---@param ent Caveman
local function credits_caveman_update(ent)
    ent.animation_frame = animationlib.get_animation_frame(ent.user_data)
    animationlib.update_timer(ent.user_data)
end

local function create_credits_caveman(base_uid, x, y, l)
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
    caveman.flags = set_flag(caveman.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    caveman.flags = set_flag(caveman.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    caveman.flags = set_flag(caveman.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    caveman.user_data = {
        animation_timer = 0,
    }
    -- custom animate cavemen
    animationlib.set_animation(caveman.user_data, CAVEMAN_ANIMATIONS.WALK)
    set_post_statemachine(caveman.uid, credits_caveman_update)
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
    create_credits_caveman(base.uid, x-.5, y, l)
    create_credits_caveman(base.uid, x+.5, y, l)
    -- # TODO: move treasure in a sine-wave **use yama's phase 2 as an example

    -- move the entity to the left until decorlib.CREDITS_SCROLL is true
    set_post_statemachine(base.uid, function (self)
        if not decorlib.CREDITS_SCROLLING then
            self.velocityx = -0.095
        end
    end)
end

return module