local celib = require "lib.entities.custom_entities"
local optionslib = require "lib.options"

local module = {}

local ANIMATION_INFO = {
    THROW = {
        start = 160;
        finish = 164;
        speed = 3;
    };
}

local function hawkman_set(uid)
    ---@type Movable
    local ent = get_entity(uid)
    local x, y, l = get_position(uid)

    -- user_data
    ent.user_data = {
        ent_type = HD_ENT_TYPE.MONS_HAWKMAN;
        throw_state = 0; -- When zero we will use vanilla statemachine and when 1 we will use a custom statemachine for the throw
        thrown_ent = nil; -- Points to the entity the hawkman is trying to throw
        --ANIMATION
        animation_info = ANIMATION_INFO.THROW;
        animation_timer = 1;
        animation_speed = 4;
        animation_frame = 160;
    };

    --remove any items hawkman is holding
    local held_item = get_entity(ent.holding_uid)
    if held_item ~= nil then
        drop(ent.uid, held_item.uid)
        held_item:destroy()
    end
end

local function hawkman_update(ent)
    if ent.user_data.throw_state == 0 then
        if test_flag(ent.flags, ENT_FLAG.DEAD) or ent.stun_timer ~= 0 then return end
        --wait for player to get near
        for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, ent.layer)) do
            local player = get_entity(v)
            if player ~= nil then
                local dist = distance(ent.uid, player.uid)
                local sx, sy, sl = get_position(ent.uid)
                local px, py, pl = get_position(player.uid)
                -- Go into throw state
                if ent:overlaps_with(player) and (sy > py) then
                    ent.user_data.thrown_ent = player
                    ent.user_data.throw_state = 1
                    ent.user_data.animation_frame = 160
                end
            end
        end
        --give the tikiman a speedbost to his movement (as fast as shoppie)
        if ent.movex ~= 0 and ent.move_state == 6 then
            ent.x = ent.x + 0.025*ent.movex
        end
        if ent.move_state == 6 then
            -- Always jump when aggro'd
            if ent.stand_counter > 1 and ent:can_jump() then
                ent.velocityy = 0.17
                if math.random(2) == 1 then
                    ent.velocityy = 0.25
                end
            end
            -- Flip when hitting a wall
            local held_item = get_entity(ent.holding_uid)
            local hb = get_hitbox(ent.uid, 0, 0.18, 0)
            for _, v in ipairs(get_entities_overlapping_hitbox({0}, MASK.FLOOR | MASK.ACTIVEFLOOR, hb, ent.layer)) do
                local w = get_entity(v)
                if test_flag(w.flags, ENT_FLAG.SOLID) and test_flag(ent.flags, ENT_FLAG.COLLIDES_WALLS) then
                    if held_item ~= nil then
                        held_item.flags = set_flag(held_item.flags, ENT_FLAG.FACING_LEFT)
                    end
                    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
                    ent.movex = -1
                    ent.x = ent.x-0.1                  
                end
            end
            local hb = get_hitbox(ent.uid, 0, -0.18, 0)
            for _, v in ipairs(get_entities_overlapping_hitbox({0}, MASK.FLOOR | MASK.ACTIVEFLOOR, hb, ent.layer)) do
                local w = get_entity(v)
                if test_flag(w.flags, ENT_FLAG.SOLID) and test_flag(ent.flags, ENT_FLAG.COLLIDES_WALLS) then
                    if held_item ~= nil then
                        held_item.flags = clr_flag(held_item.flags, ENT_FLAG.FACING_LEFT)
                    end
                    ent.flags = clr_flag(ent.flags, ENT_FLAG.FACING_LEFT)
                    ent.movex = 1
                    ent.x = ent.x+0.1                  
                end
            end
            if ent.velocityx == 0 then
                ent.velocityx = 1*ent.movex
            end
        end
    elseif ent.user_data.throw_state == 1 then
        ent.move_state = 30
        ent.state = 30
        ent.lock_input_timer = 3
        ---- ANIMATION SYSTEM ----
        -- Increase animation timer
        ent.user_data.animation_timer = ent.user_data.animation_timer + 1
        --- Animate the entity and reset the timer
        if ent.user_data.animation_timer >= ent.user_data.animation_info.speed then
            ent.user_data.animation_timer = 1
            -- Advance the animation
            ent.user_data.animation_frame = ent.user_data.animation_frame + 1
            -- Loop if the animation has reached the end
            if ent.user_data.animation_frame > ent.user_data.animation_info.finish then
                ent.user_data.animation_frame = ent.user_data.animation_info.start
            end
        end
        -- Change the actual animation frame
        ent.animation_frame = ent.user_data.animation_frame
        --------------------------------------
        -- Perform the throw (start of second frame of animation)
        if ent.user_data.animation_frame == ent.user_data.animation_info.start+1 and ent.user_data.animation_timer == 2 then
            -- Make sure the entity exists first
            if ent.user_data.thrown_ent ~= nil then
                -- Make sure the thrown entity is still overlapping with the hawkman
                if ent:overlaps_with(ent.user_data.thrown_ent) then
                    local lor = 1
                    if test_flag(ent.flags, ENT_FLAG.FACING_LEFT) then lor = -1 end
                    ent.user_data.thrown_ent:stun(100)
                    ent.user_data.thrown_ent.state = 18
                    ent.user_data.thrown_ent.velocityx = 0.3*lor
                    ent.user_data.thrown_ent.velocityy = 0.2
                    ent.user_data.thrown_ent.last_owner_uid = ent.uid
                    -- This gives the thrown entity the property of taking damage after being thrown
                    ent.user_data.thrown_ent.more_flags = set_flag(ent.user_data.thrown_ent.more_flags, 1)
                    -- Throw sound goes here
                    commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_TOSS, ent.uid, 1)
                    -- Give the hawkman a bit of invincibility so he doesn't get damaged by the thrown player
                    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
                    set_timeout(function()
                        ent.flags = clr_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)  
                        -- No more aggro after throw
                        ent.state = 1
                        ent.move_state = 0              
                    end, 10)
                end
            end
        end
        -- Once the animation finishes go back to vanilla state
        if ent.user_data.animation_frame == ent.user_data.animation_info.finish and ent.user_data.animation_timer == 2 then
            ent.user_data.throw_state = 0
            ent.move_state = 6
        end
    end
end
local function hawkman_death(ent, damage_dealer, damage_amount, velocityx, velocityy, stun_amount, iframes)
    if ent.health - damage_amount <= 0 then
        --set it temporarily to tikiman makes no sound on death then set it back 1 frame later
        --technically its possible that if a tikiman and black knight die on the same frame, tikiman makes no sound, but he should never be near a black knight anyways
        local tikiman_db = get_type(ENT_TYPE.MONS_TIKIMAN)
        local sound_killed_by_player = tikiman_db.sound_killed_by_player
        local sound_killed_by_other = tikiman_db.sound_killed_by_other
        tikiman_db.sound_killed_by_player = -1
        tikiman_db.sound_killed_by_other = -1
        set_timeout(function()
            tikiman_db.sound_killed_by_player = sound_killed_by_player
            tikiman_db.sound_killed_by_other = sound_killed_by_other
        end, 1)
        --play a death sound, sounds weird otherwise
        commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_DAMAGED, ent.uid)
    end
end
-- Make players ignore damage from tikimen that have our user_data for the hawkman type
set_post_entity_spawn(function(self)
    self:set_pre_damage(function(self, other)
        if other == nil then return end
        if type(other.user_data) == "table" then
            if other.user_data.ent_type == HD_ENT_TYPE.MONS_HAWKMAN then
                return false
            end
        end
    end)
end, SPAWN_TYPE.ANY, MASK.PLAYER)

function module.create_hawkman(x, y, l)
    local hawkman = spawn_on_floor(ENT_TYPE.MONS_TIKIMAN, x, y, l)
    hawkman_set(hawkman)
    set_post_statemachine(hawkman, hawkman_update)
    set_on_damage(hawkman, hawkman_death)
end

optionslib.register_entity_spawner("Hawkman", module.create_hawkman)

return module