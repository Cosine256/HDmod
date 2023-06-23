local animationlib = require "animation"

local module = {}

local texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 128
    texture_def.height = 384
    texture_def.tile_width = 128
    texture_def.tile_height = 128
    texture_def.texture_path = 'res/babyspider.png'
    texture_id = define_texture(texture_def)
end

local CRITTERSPIDER_STATE <const> = {
    IDLE = 0,
    JUMP = 1,
}
local ANIMATIONS <const> = {
    IDLE = {0, 1, loop = true, frames = 2, frame_time = 12},
    JUMP = {2, loop = true, frames = 1, frame_time = 4},
}

local function face_target(mons_uid, target_uid)
    local mx = get_position(mons_uid)
    local tx = get_position(target_uid)
    if tx-mx < 0 then
        set_entity_flags(mons_uid, set_flag(get_entity_flags(mons_uid), ENT_FLAG.FACING_LEFT))
    else
        set_entity_flags(mons_uid, clr_flag(get_entity_flags(mons_uid), ENT_FLAG.FACING_LEFT))
    end
end

---@param ent CritterCrab | Entity
local function critterspider_update(ent)
    ent:set_behavior(18) -- stop its default moving behavior
    
    if ent.user_data.state == CRITTERSPIDER_STATE.IDLE then
        if ent.user_data.action_timer > 0 then
            ent.user_data.action_timer = ent.user_data.action_timer - 1
        end
        local x, y, layer = get_position(ent.uid)
        local target_uid = get_entities_at(0, MASK.PLAYER, x, y, layer, 8.0)[1]
        
        if ent.user_data.action_timer == 0 and target_uid then
            ent.user_data.state = CRITTERSPIDER_STATE.JUMP
            --when jumping, change facing to match chased uid
            face_target(ent.uid, target_uid)

            animationlib.set_animation(ent.user_data, ANIMATIONS.JUMP)
            local move_dir = 1
            if test_flag(ent.flags, ENT_FLAG.FACING_LEFT) then
                move_dir = -1
            end
            ent.velocityx = 0.065*move_dir
            ent.velocityy = 0.16
            commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_SPIDER_JUMP, ent.uid, 0.90, false)
        end
    elseif ent.user_data.state == CRITTERSPIDER_STATE.JUMP then
        if ent.standing_on_uid ~= -1 then
            ent.user_data.state = CRITTERSPIDER_STATE.IDLE
            ent.user_data.action_timer = prng:random_int(50, 100, PRNG_CLASS.AI)
            animationlib.set_animation(ent.user_data, ANIMATIONS.IDLE)
        end
    end
    ent.animation_frame = animationlib.get_animation_frame(ent.user_data)
    animationlib.update_timer(ent.user_data)
end

---@param ent CritterCrab | Entity
local function critterspider_set(ent)
    ent:set_texture(texture_id)
    ent.user_data = {
        ent_type = HD_ENT_TYPE.MONS_CRITTERSPIDER,
        state = CRITTERSPIDER_STATE.IDLE,
        animation_timer = 0,
        action_timer = prng:random_int(50, 100, PRNG_CLASS.AI)
    }
    animationlib.set_animation(ent.user_data, ANIMATIONS.IDLE)
    set_post_statemachine(ent.uid, critterspider_update)
end

---@param x integer
---@param y integer
---@param layer integer
function module.create_critterspider(x, y, layer)
    local uid = spawn_entity_snapped_to_floor(ENT_TYPE.MONS_CRITTERCRAB, x, y, layer)
    critterspider_set(get_entity(uid))
    return uid
end

optionslib.register_entity_spawner("Baby spider", module.create_critterspider)

return module