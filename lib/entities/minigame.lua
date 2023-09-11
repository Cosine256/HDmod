local module = {}

local hud_texture_id
do
    local hud_texture_def = TextureDefinition:new()
    hud_texture_def.width = 128
    hud_texture_def.height = 64
    hud_texture_def.tile_width = 128
    hud_texture_def.tile_height = 64
    hud_texture_def.texture_path = "res/cannon_hud.png"
    hud_texture_id = define_texture(hud_texture_def)
end

local GAME_STATE <const> = {
    PRE_GAME = 0,
    GAME_LOAD = 1,
    IN_GAME = 2,
    POST_GAME = 3
}
local TIMEOUT_MIN = 60
local TIMEOUT_MAX = 160
local LOAD_TIME = 130

local minigame_state
local timeout
local spawn_timeout
local target_uid
---@type integer[]
local camels

local X_SPAWN = 3
local X_LIMIT = 27

local function add_to_score(player_uid)
    for _, uid in pairs(camels) do
        ---@type Mount
        local camel = get_entity(uid)
        if camel.rider_uid ~= -1
        and camel.rider_uid == player_uid then
            camel.user_data.score = camel.user_data.score + 1
        end
    end
end

local function update_offscreen_ent(self)
    if self.x > X_LIMIT then
        self:destroy()
    end
end

local function update_ufo(self)
    update_offscreen_ent(self)
end

---@param self Movable
---@param damage_dealer Movable
---@param damage_amount any
---@param stun_time any
---@param velocity_x any
---@param velocity_y any
---@param iframes any
local function post_damage_minigame_handling(self, damage_dealer, damage_amount, stun_time, velocity_x, velocity_y, iframes)
    if damage_dealer.type.id == ENT_TYPE.MOUNT_ROCKDOG then
        damage_dealer.last_owner_uid = damage_dealer.rider_uid
    end
    message(string.format("%s attacked by %s", self.uid, damage_dealer.last_owner_uid))
    add_to_score(damage_dealer.last_owner_uid)
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
    entity:set_post_damage(post_damage_minigame_handling)
    entity:set_pre_update_state_machine(function()
        lamassu_db.id = 0
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
    if minigame_state == GAME_STATE.GAME_LOAD then
        if timeout > 0 then
            timeout = timeout - 1
        else
            minigame_state = GAME_STATE.IN_GAME
        end
    elseif minigame_state == GAME_STATE.IN_GAME then
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
        alien:set_post_damage(post_damage_minigame_handling)
    end, SPAWN_TYPE.ANY, MASK.MONSTER, ENT_TYPE.MONS_ALIEN)
    local item_cb = set_post_entity_spawn(function(item, spawn_flags)
        if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
            item:set_post_update_state_machine(function(self)
                if self.standing_on_uid ~= -1 then
                    self.velocityx = 0.08
                end
                update_offscreen_ent(self)
            end)
        end
    end, SPAWN_TYPE.ANY, MASK.ITEM)
    local fx_cb = set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
        if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
            return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
        end
    end, SPAWN_TYPE.ANY, MASK.BG, ENT_TYPE.BG_LEVEL_BOMB_SOOT)
    set_callback(function ()
        clear_callback(alien_cb)
        clear_callback(item_cb)
        clear_callback(fx_cb)
        clear_callback()
    end, ON.CAMP)
end

function module.init(_target_uid, _camels)
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
    camels = _camels
end

local function get_team_total()
    local total = 0
    for _, camel in pairs(camels) do
        total = total + camels.user_data.score
    end
    return total
end

set_callback(
    ---@param render_ctx VanillaRenderContext
function(render_ctx)
    if state.screen == SCREEN.CREDITS
    and minigame_state == GAME_STATE.IN_GAME
    or minigame_state == GAME_STATE.GAME_LOAD then
        for c_i, camel_uid in ipairs(camels) do
            local camel = get_entity(camel_uid)
            if camel.user_data.state == 3 then -- MINIGAME_STATE.MINIGAME
                --loop over the camels spawned, check their status
                --shadow
                local icon_offset_y = 0.045
                local x, y = get_hud_position(c_i):center()
                local src = Quad:new()
                src.top_left_x = 0
                src.top_left_y = 0
                src.top_right_x = 1/2
                src.top_right_y = 0
                src.bottom_left_x = 0
                src.bottom_left_y = 1/8
                src.bottom_right_x = 1/2
                src.bottom_right_y = 1/8
                local w = (1/16)*4
                local h = (1/16)/0.5625
                local dest = Quad:new()
                dest.top_left_x = -w/2
                dest.top_left_y = h/2
                dest.top_right_x = w/2
                dest.top_right_y = h/2
                dest.bottom_left_x = -w/2
                dest.bottom_left_y = -h/2
                dest.bottom_right_x = w/2
                dest.bottom_right_y = -h/2
                dest:offset(x, y-icon_offset_y)
                render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_HUD_2, src, dest, Color:white())
        
        
                --cannon icon
                src.top_left_x = 0
                src.top_left_y = 0
                src.top_right_x = 1/2
                src.top_right_y = 0
                src.bottom_left_x = 0
                src.bottom_left_y = 1
                src.bottom_right_x = 1/2
                src.bottom_right_y = 1
                w = 1/16
                h = w/0.5625
                dest = Quad:new()
                dest.top_left_x = -w/2
                dest.top_left_y = h/2
                dest.top_right_x = w/2
                dest.top_right_y = h/2
                dest.bottom_left_x = -w/2
                dest.bottom_left_y = -h/2
                dest.bottom_right_x = w/2
                dest.bottom_right_y = -h/2
                dest:offset(x-0.055, y)
                render_ctx:draw_screen_texture(hud_texture_id, src, dest, Color:white())
        
                --hit icon
                src.top_left_x = 1/2
                src.top_left_y = 0
                src.top_right_x = 1
                src.top_right_y = 0
                src.bottom_left_x = 1/2
                src.bottom_left_y = 1
                src.bottom_right_x = 1
                src.bottom_right_y = 1
                local w = 1/16
                local h = w/0.5625
                dest = Quad:new()
                dest.top_left_x = -w/2
                dest.top_left_y = h/2
                dest.top_right_x = w/2
                dest.top_right_y = h/2
                dest.bottom_left_x = -w/2
                dest.bottom_left_y = -h/2
                dest.bottom_right_x = w/2
                dest.bottom_right_y = -h/2
                dest:offset(x+0.02, y)
                render_ctx:draw_screen_texture(hud_texture_id, src, dest, Color:white())
        
                local hit_text = TextRenderingInfo:new(string.format("x%s", camel.user_data.score), 0.0012, 0.0012, VANILLA_TEXT_ALIGNMENT.LEFT, VANILLA_FONT_STYLE.BOLD)
                hit_text.x, hit_text.y = x+0.04, y
                render_ctx:draw_text(hit_text, Color:white())
            end
        end
    end
end, ON.RENDER_PRE_HUD)

function module.started_minigame()
    return minigame_state ~= GAME_STATE.PRE_GAME
end

function module.start_minigame()
    if minigame_state ~= GAME_STATE.POST_GAME then
        minigame_state = GAME_STATE.GAME_LOAD
        timeout = LOAD_TIME
    end
end

return module