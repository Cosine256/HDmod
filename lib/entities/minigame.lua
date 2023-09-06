local module = {}

local GAME_STATE <const> = {
    PRE_GAME = 0,
    IN_GAME = 1,
    POST_GAME = 2
}
local TIMEOUT_MIN = 60
local TIMEOUT_MAX = 160

local minigame_state
local spawn_timeout
local target_uid

local X_SPAWN = 3
local X_LIMIT = 27

local function update_offscreen_ent(self)
    if self.x > X_LIMIT then
        self:destroy()
    end
end

local function update_ufo(self)
    update_offscreen_ent(self)
end

-- Force velocity of ufo to go to the right slowly
-- destroy the ufo once reaching a certain point of the stage
-- UFO beams during the credits should not destroy floor (Mark floor as indestructable)
local function create_minigame_ufo(y)
    ---@type UFO
    local entity = get_entity(spawn_entity(ENT_TYPE.MONS_UFO, X_SPAWN, y, LAYER.FRONT, 0, 0))
    entity.velocityx = 0.04
    entity:set_post_update_state_machine(update_ufo)
    entity:set_pre_update_state_machine(function(self)
        self.chased_target_uid = target_uid
        self.patrol_distance = 10
        return false
    end)
end

-- Force velocity of the imp to go to the right slowly
-- destroy the imp and its item once reaching a certain point of the stage
-- Maybe the imp holds random stuff?
local function create_minigame_imp(y)
    local entity = get_entity(spawn_entity(ENT_TYPE.MONS_IMP, X_SPAWN, y, LAYER.FRONT, 0, 0))
    entity.velocityx = 0.04
    entity:set_post_update_state_machine(update_offscreen_ent)
end

local function update_minigame(_)
    if minigame_state == GAME_STATE.IN_GAME then
        --randomly spawn enemies, but pad them out so it isn't too spammy or empty
        if spawn_timeout <= 0 then
            local enemy_total = #get_entities_by({ENT_TYPE.MONS_IMP, ENT_TYPE.MONS_UFO}, MASK.MONSTER, LAYER.FRONT)
            if enemy_total < 7 then
                local y = 114.5 + prng:random_int(0, 5, PRNG_CLASS.PARTICLES)
                spawn_timeout = prng:random_int(TIMEOUT_MIN, TIMEOUT_MAX, PRNG_CLASS.PARTICLES)
                if state.win_state == WIN_STATE.HUNDUN_WIN
                and prng:random_chance(5, PRNG_CLASS.PARTICLES) then
                    create_minigame_imp(y)
                else
                    create_minigame_ufo(y)
                end
            end
        else
            spawn_timeout = spawn_timeout - 1
        end
        if state.screen_credits.render_timer >= 240 then
            minigame_state = GAME_STATE.POST_GAME
        end
    -- elseif minigame_state == GAME_STATE.POST_GAME then
        -- # TODO: Program recap
    end
end

local alien_credits_type = EntityDB:new(get_type(ENT_TYPE.MONS_ALIEN))
alien_credits_type.max_speed = 0.06

local function init_minigame_ents()
    local alien_cb = set_post_entity_spawn(function(alien)
        alien.type = alien_credits_type
        alien:set_post_update_state_machine(function(self)
            if self.standing_on_uid ~= -1 then
                self.velocityx = 0.06
            end
            if test_flag(self.flags, ENT_FLAG.FACING_LEFT) then
                self.flags = clr_flag(self.flags, ENT_FLAG.FACING_LEFT)
            end
            update_offscreen_ent(self)
        end)
    end, SPAWN_TYPE.ANY, MASK.MONSTER, ENT_TYPE.MONS_ALIEN)
    local parachute_cb = set_post_entity_spawn(function(parachute)
        parachute:set_post_update_state_machine(function(self)
            if self.standing_on_uid ~= -1 then
                self.velocityx = 0.08
            end
            update_offscreen_ent(self)
        end)
    end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_DEPLOYED_PARACHUTE)
    local fx_cb = set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
        if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
            return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
        end
    end, SPAWN_TYPE.ANY, MASK.BG, ENT_TYPE.BG_LEVEL_BOMB_SOOT)
    set_callback(function ()
        clear_callback(alien_cb)
        clear_callback(parachute_cb)
        clear_callback(fx_cb)
        clear_callback()
    end, ON.CAMP)
end

function module.init(_target_uid)
    minigame_state = GAME_STATE.PRE_GAME
    spawn_timeout = TIMEOUT_MIN
    --have to create a physical entity to be able to use a state machine
    local entity = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, 3, 109, LAYER.FRONT, 0, 0))
    entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
    entity.flags = set_flag(entity.flags, ENT_FLAG.NO_GRAVITY)
    entity.flags = set_flag(entity.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    entity:set_post_update_state_machine(update_minigame)
    target_uid = _target_uid
    init_minigame_ents()
end

function module.start_minigame()
    minigame_state = GAME_STATE.IN_GAME
end

return module