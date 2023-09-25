local module = {}

-- Setup texture sheet
local scorpionfly_texture_id
do
    local scorpionfly_texture_def = TextureDefinition.new()
    scorpionfly_texture_def.width = 1152
    scorpionfly_texture_def.height = 384
    scorpionfly_texture_def.tile_width = 128
    scorpionfly_texture_def.tile_height = 128
    scorpionfly_texture_def.texture_path = 'res/scorpionfly.png'
    scorpionfly_texture_id = define_texture(scorpionfly_texture_def)
end

-- Create a custom entity with the sacrafice value in HD
local MONS_SCORPIONFLY = EntityDB:new(ENT_TYPE.MONS_SCORPION)
MONS_SCORPIONFLY.sacrifice_value = 6
local MONS_SCORPIONFLY_FLYING = EntityDB:new(MONS_SCORPIONFLY)
MONS_SCORPIONFLY_FLYING.friction = 0.0

-- Animations
local ANIMATION_INFO = {
    IDLE = {
        start = 0;
        finish = 3;
        speed = 7;
    };
    WALK = {
        start = 9;
        finish = 13;
        speed = 6;
    };
    ATTACK = {
        start = 5;
        finish = 8;
        speed = 6;
    };
    FLY = {
        start = 18;
        finish = 23;
        speed = 3;
    };
    STUN = {
        start = 14;
        finish = 14;
        speed = 1;
    };
}

---@enum FLYING_STATE
local FLYING_STATE = {
    IDLE = 1,
    MOVING = 2,
    CONSTANT_MOVE = 3,
}
-- State enum
---@enum SCORPIONFLY_STATE
local SCORPIONFLY_STATE = {
    ATTACK = 1;
    FLY = 2;
    SCORPION = 3;
}
---@param self Scorpion
local function stop_scorpion_behiavor(self)
    self:set_behavior(9)
    self.jump_cooldown_timer = 100
    self.lock_input_timer = 5
    self.state = 9
    self.last_state = 9
    self.move_state = 0
end

---@param self Scorpion
local function state_fly(self)
    -- No gravity 
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    stop_scorpion_behiavor(self)
    local udata = self.user_data --[[@as ScorpFlyData]]

    if udata.flying_state == FLYING_STATE.IDLE then
        if udata.flying_timer > 0 then
            udata.flying_timer = udata.flying_timer - 1
        else
            if prng:random_chance(3, PRNG_CLASS.AI) then
                udata.flying_state = FLYING_STATE.CONSTANT_MOVE
                udata.flying_timer = 12
            else
                udata.flying_state = FLYING_STATE.MOVING
                udata.flying_timer = prng:random_int(10, 30, PRNG_CLASS.AI) --[[@as integer]]
            end
            -- Between -0.05 and 0.05
            self.velocityx = prng:random_float(PRNG_CLASS.AI)*0.1-0.05
            self.velocityy = prng:random_float(PRNG_CLASS.AI)*0.1-0.05
        end
    elseif udata.flying_state == FLYING_STATE.MOVING then
        -- If stopped by a wall
        if self.velocityx == 0.0 and math.abs(udata.prev_velx) > 0.002 then
            self.velocityx = udata.prev_velx * -0.25
        end
        self.velocityx = self.velocityx + (.0005 * (self.velocityx > 0 and -1.0 or 1.0))
        self.velocityy = self.velocityy + (.0005 * (self.velocityy > 0 and -1.0 or 1.0))
        local stop_x, stop_y = math.abs(self.velocityx) <= 0.00075, math.abs(self.velocityy) <= 0.00075
        if stop_x then
            self.velocityx = 0.0
        end
        if stop_y then
            self.velocityy = 0.0
        end
        if stop_x and stop_y then
            udata.flying_state = FLYING_STATE.IDLE
        end
    elseif udata.flying_state == FLYING_STATE.CONSTANT_MOVE then
        if udata.flying_timer > 0 then
            udata.flying_timer = udata.flying_timer - 1
        else
            udata.flying_timer = prng:random_int(50, 100, PRNG_CLASS.AI) --[[@as integer]]
            udata.flying_state = FLYING_STATE.MOVING
        end
    end
    if self.velocityx > 0.0 then
        self.flags = clr_flag(self.flags, ENT_FLAG.FACING_LEFT)
    elseif self.velocityx < 0.0 then
        self.flags = set_flag(self.flags, ENT_FLAG.FACING_LEFT)
    end
    udata.prev_velx = self.velocityx

    -- Enter attack state when a player is in range
    local player_uid = commonlib.get_closest_player_in_dist(self, 5)
    if player_uid ~= -1 then
        self.user_data.state = SCORPIONFLY_STATE.ATTACK
        self.chased_target_uid = player_uid
    end
end
---@param self Scorpion
local function state_chase(self)
    if self.target_selection_timer > 0 then
        self.target_selection_timer = self.target_selection_timer - 1
    else
        local new_target = commonlib.get_closest_player_in_dist(self, math.huge)
        if new_target ~= -1 then
            self.chased_target_uid = new_target
        end
        self.target_selection_timer = 60
    end
    local target_uid = self.chased_target_uid
    -- No gravity 
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)

    stop_scorpion_behiavor(self)

    -- Move towards chased target
    local target = get_entity(target_uid)
    if target ~= nil then
        local dist = distance(target.uid, self.uid)
        local tx, ty, _ = get_position(target.uid)
        local sx, sy, _ = get_position(self.uid)
        local abs_x = (sx - tx)
        local abs_y = (sy - ty)
        local move_rate = 0.0475
        local movex = (abs_x/dist)*move_rate
        local movey = (abs_y/dist)*move_rate
        -- Minimum speed for movex and movey
        if movex > 0 then
            if movex < 0.015 then
                movex = 0.015
            end
        elseif movex < 0 then
            if movex > -0.015 then
                movex = -0.015
            end            
        end
        if movey > 0 then
            if movey < 0.015 then
                movey = 0.015
            end
        elseif movey < 0 then
            if movey > -0.015 then
                movey = -0.015
            end            
        end
        if math.abs(abs_x) < 0.015 then
            movex = 0
        end
        if math.abs(abs_y) < 0.02 then
            movey = 0
        end
        self.velocityx, self.velocityy = -movex, -movey
        -- Face direction moving
        if not test_flag(self.more_flags, 9) then --if not stuck in smth (web or honey, flag 8 is reset on statemachine, so only 9 works)
            if abs_x > 0 and not test_flag(self.flags, ENT_FLAG.FACING_LEFT) then
                flip_entity(self.uid)
            end
            if abs_x < 0 and test_flag(self.flags, ENT_FLAG.FACING_LEFT) then
                flip_entity(self.uid)
            end
        end
    end
end
local function state_scorpion(self)
    -- This state just uses the regular scorpion AI for the most part, we just need to properly update the animations since we use a custom texture sheet

    -- ai state 1 == walk
    -- ai state 0 == idle
    -- ai state 5 =  attack
    if self.stun_timer == 0 then
        if self.move_state == 0 then
            if self.user_data.animation_info ~= ANIMATION_INFO.IDLE then
                self.user_data.animation_frame = 0
                self.user_data.animation_info = ANIMATION_INFO.IDLE
            end
        elseif self.move_state == 5 and not self:can_jump() then
            if self.user_data.animation_info ~= ANIMATION_INFO.ATTACK then
                self.user_data.animation_frame = 5
                self.user_data.animation_info = ANIMATION_INFO.ATTACK
            end
            -- Lock the animation to the last frame when falling
            if self.velocityy < 0 then
                self.user_data.animation_frame = 8
                self.user_data.animation_timer = 0
                self.animation_frame = 8
            end          
        elseif (self.move_state == 1) or (self.velocityx ~= 0 and self:can_jump()) then
            if self.user_data.animation_info ~= ANIMATION_INFO.WALK then
                self.user_data.animation_frame = 9
                self.user_data.animation_info = ANIMATION_INFO.WALK
            end
        end
    else
        self.user_data.animation_frame = 14
        self.user_data.animation_info = ANIMATION_INFO.STUN
    end
end

local function become_scorpion(self, _, amount)
    local d = self.user_data
    if amount - self.health ~= 0 then
        self.type = MONS_SCORPIONFLY
        self.offsety = MONS_SCORPIONFLY.offsety
        -- Change state
        d.state = SCORPIONFLY_STATE.SCORPION
        -- Change gravity flag and restore state info
        self.flags = clr_flag(self.flags, ENT_FLAG.NO_GRAVITY)

        self.jump_cooldown_timer = 60
        self.move_state = 0
        self.state = 1
        self.lock_input_timer = 0
    end
    local bee = get_entity(d.bee_uid)
    -- Kill the extra entities used
    if bee ~= nil then
        bee:destroy()
        d.bee_uid = -1
    end
end

---@param self Scorpion
local function scorpionfly_update(self)
    local d = self.user_data
    if self.frozen_timer > 0 then
        self.type = MONS_SCORPIONFLY -- Change friction to normal if flying
        self.animation_frame = d.animation_frame
        if d.bee_uid ~= -1 then
            -- pause the sound
            move_entity(d.bee_uid, self.abs_x, 1000.0, 0, 0)
        end
        return
    elseif d.state ~= SCORPIONFLY_STATE.SCORPION then -- if flying
        if self.stun_timer > 0 then -- If hit by camera flash
            become_scorpion(self, nil, 0)
            self.velocityx = 0.0
        else
            self.type = MONS_SCORPIONFLY_FLYING
        end
    end
    -- ANIMATION
    -- Increase animation timer
    d.animation_timer = d.animation_timer + 1
    --- Animate the entity and reset the timer
    if d.animation_timer >= d.animation_info.speed then
        d.animation_timer = 1
        -- Advance the animation
        d.animation_frame = d.animation_frame + 1
        -- Loop if the animation has reached the end
        if d.animation_frame > d.animation_info.finish then
            d.animation_frame = d.animation_info.start
        end
    end
    -- Change the actual animation frame
    self.animation_frame = d.animation_frame

    -- Place the bee on the scorpionfly for the bees sound effects
    if d.bee_uid ~= -1 then
        move_entity(d.bee_uid, self.abs_x, self.abs_y, 0, 0)
    end

    -- STATEMACHINE
    if d.state == SCORPIONFLY_STATE.FLY then
        state_fly(self)
    elseif d.state == SCORPIONFLY_STATE.ATTACK then
        state_chase(self)
    elseif d.state == SCORPIONFLY_STATE.SCORPION then
        state_scorpion(self)
    end
end

---@class ScorpFlyData
---@field ent_type ENT_TYPE
---@field animation_timer integer
---@field animation_frame integer
---@field animation_info integer
---@field state SCORPIONFLY_STATE
---@field flying_state FLYING_STATE
---@field flying_timer integer
---@field prev_velx number
---@field bee_uid integer

local function scorpionfly_set(self)
    self.target_selection_timer = 60
    -- This custom type awards the player 6 favor like in HD
    self.type = MONS_SCORPIONFLY_FLYING
    self.offsety = 0.0
    -- Userdata stuff
    self.user_data = {
        ent_type = HD_ENT_TYPE.MONS_SCORPIONFLY;

        -- ANIMATION
        animation_timer = 1;
        animation_frame = 0;
        animation_info = ANIMATION_INFO.FLY; -- Info about animation speed, start frame, stop frame

        -- AI 
        state = SCORPIONFLY_STATE.FLY;
        flying_state = FLYING_STATE.IDLE;
        flying_timer = 0;
        prev_velx = 0.0;

        -- Bee for the sound effects
        bee_uid = spawn(ENT_TYPE.MONS_BEE, self.x, self.y, self.layer, 0, 0);
    };
    self.user_data.animation_frame = self.user_data.animation_info.start
    -- Same for the bee
    local bee = get_entity(self.user_data.bee_uid)
    bee.flags = set_flag(bee.flags, ENT_FLAG.INVISIBLE)
    bee.flags = set_flag(bee.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    -- No gravity since this starts as a flying entity
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    self:set_texture(scorpionfly_texture_id)
    -- Set up the damage callback for turning the scorpionfly into a scorpion
    self:set_pre_damage(function(self, _, amount)
        become_scorpion(self, _, amount)
    end)
    -- Statemachine
    self:set_post_update_state_machine(scorpionfly_update)
    -- Custom gibs
    self:set_pre_kill(function(self)
        local sx, sy, sl = get_position(self.uid)
        -- Make our own rubble and blood
        -- TODO no idea how to color rubble right, the values I tweaked in OL dont transfer to these values
        local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, sx, sy, sl, -0.05, 0.015))
        rubble.color:set_rgba(255, 80, 20, 255)
        rubble.animation_frame = 39
        local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, sx, sy, sl, 0.05, 0.015))
        rubble.color:set_rgba(255, 80, 20, 255)
        rubble.animation_frame = 39
        -- Defeat sfx
        local audio = commonlib.play_vanilla_sound(VANILLA_SOUND.SHARED_DAMAGED, self.uid, 1, false)
        audio:set_volume(1)
        audio:set_parameter(VANILLA_SOUND_PARAM.COLLISION_MATERIAL, 2)
        -- Spawn a spider for the blood
        local spider = get_entity(spawn(ENT_TYPE.MONS_SPIDER, sx, sy, sl, 0, 0))
        spider:kill(true, nil)
        -- move original entity OOB
        self.x = -900
    end)
end

function module.create_scorpionfly(x, y, l)
    local fly = get_entity(spawn(ENT_TYPE.MONS_SCORPION, x, y, l, 0, 0))
    scorpionfly_set(fly)
end

optionslib.register_entity_spawner("Scorpionfly", module.create_scorpionfly, false)

return module