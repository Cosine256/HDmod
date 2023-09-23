local module = {}

local hud_texture_id
local total_texture_id
do
    local hud_texture_def = TextureDefinition:new()
    hud_texture_def.width = 128
    hud_texture_def.height = 64
    hud_texture_def.tile_width = 128
    hud_texture_def.tile_height = 64
    hud_texture_def.texture_path = "res/cannon_hud.png"
    hud_texture_id = define_texture(hud_texture_def)

    local total_texture_def = TextureDefinition:new()
    total_texture_def.width = 768
    total_texture_def.height = 512
    total_texture_def.tile_width = 768
    total_texture_def.tile_height = 512
    total_texture_def.texture_path = "res/minigame_total.png"
    total_texture_id = define_texture(total_texture_def)

    local total_team_texture_def = TextureDefinition:new()
    total_team_texture_def.width = 384
    total_team_texture_def.height = 192
    total_team_texture_def.tile_width = 384
    total_team_texture_def.tile_height = 192
    total_team_texture_def.texture_path = "res/minigame_teamtotal.png"
    total_team_texture_id = define_texture(total_team_texture_def)
end

local GAME_STATE <const> = {
    PRE_GAME = 0,
    GAME_LOAD = 1,
    IN_GAME = 2,
    POST_GAME = 3
}
local TIMEOUT_MIN = 60
local TIMEOUT_MAX = 160
local LOAD_TIME = 150

local minigame_state
local timeout
local spawn_timeout
local target_uid
---@type integer[]
local camels
local hitmarks

local X_LEFT_LIMIT = 3
local X_RIGHT_LIMIT = 27

local function get_team_total()
    local total = 0
    for _, uid in pairs(camels) do
        local camel = get_entity(uid)
        total = total + camel.user_data.score
    end
    return math.floor(total)
end

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

local function subtract_from_total_score(amount, responsible_uid)
    local sub_amount = amount/#camels
    local distributed_amount = amount % #camels
    for _, uid in pairs(camels) do
        ---@type Mount
        local camel = get_entity(uid)
        --[[ # TODO:
            distribute the remainder first to the one responsible, then
            amongst the players with the most
        ]]
        -- if camel.rider_uid ~= -1
        -- and camel.rider_uid == player_uid then
        -- end
        local amount_to_subtract = sub_amount - (distributed_amount > 0 and 1 or 0)
        local total = get_team_total()
        camel.user_data.score = (total - amount_to_subtract < 0) and 0 or camel.user_data.score - amount_to_subtract
        distributed_amount = distributed_amount - 1
    end
end

local function update_kill_left_offscreen(self)
    if self.x < X_LEFT_LIMIT then
        self:destroy()
    end
end

local function update_kill_right_offscreen(self)
    if self.x > X_RIGHT_LIMIT then
        self:destroy()
    end
end

local function add_hitmarker(amount, damager_uid)
    local x, y, _ = get_position(damager_uid)
    hitmarks[#hitmarks+1] = {
        amount = amount,
        timeout = 100,
        x = x,
        y = y
    }
end

---@param self Movable
---@param damage_dealer Movable
---@param _damage_amount any
---@param stun_time any
---@param velocity_x any
---@param velocity_y any
---@param iframes any
local function pre_caveman_damage_minigame_handling(self, damage_dealer, _damage_amount, stun_time, velocity_x, velocity_y, iframes)
    -- message(string.format("caveman attacked by %s", damage_dealer.last_owner_uid))
    if damage_dealer.type.id == ENT_TYPE.ITEM_BULLET then
        return false
    end
    local was_player = false
    for _, uid in pairs(camels) do
        ---@type Mount
        local camel = get_entity(uid)
        if camel.rider_uid ~= -1
        and camel.rider_uid == damage_dealer.last_owner_uid then
            was_player = true
        end
    end
    local score_loss_multiplier = 4
    local score_loss = _damage_amount*score_loss_multiplier
    subtract_from_total_score(score_loss, was_player and damage_dealer.last_owner_uid or nil)
    add_hitmarker(-score_loss, damage_dealer.uid)
    self.invincibility_frames_timer = 45
    commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_CAVEMAN_TRIGGER, self.uid, 1, false)
    return false
end

---@param self Movable
---@param damage_dealer Movable
---@param damage_amount any
---@param stun_time any
---@param velocity_x any
---@param velocity_y any
---@param iframes any
local function pre_enemy_damage_minigame_handling(self, damage_dealer, damage_amount, stun_time, velocity_x, velocity_y, iframes)
    if damage_dealer.type.id == ENT_TYPE.MOUNT_ROCKDOG then
        damage_dealer.last_owner_uid = damage_dealer.rider_uid
    end
    if self.type.id == ENT_TYPE.MONS_UFO and self.move_state == 4 then
        return
    end
    -- message(string.format("%s attacked by %s", self.uid, damage_dealer.last_owner_uid))
    add_to_score(damage_dealer.last_owner_uid)
    add_hitmarker(1, damage_dealer.uid)
end

-- local type_amazon = get_type(ENT_TYPE.CHAR_AMAZON)
-- local type_ana = get_type(ENT_TYPE.CHAR_ANA_SPELUNKY)
-- local type_au = get_type(ENT_TYPE.CHAR_AU)
-- local type_banda = get_type(ENT_TYPE.CHAR_BANDA)
-- local type_classic = get_type(ENT_TYPE.CHAR_CLASSIC_GUY)
-- local type_coco = get_type(ENT_TYPE.CHAR_COCO_VON_DIAMONDS)
-- local type_colin = get_type(ENT_TYPE.CHAR_COLIN_NORTHWARD)
-- local type_demi = get_type(ENT_TYPE.CHAR_DEMI_VON_DIAMONDS)
-- local type_dirk = get_type(ENT_TYPE.CHAR_DIRK_YAMAOKA)
-- local type_eggplant = get_type(ENT_TYPE.CHAR_EGGPLANT_CHILD)
-- local type_green = get_type(ENT_TYPE.CHAR_GREEN_GIRL)
-- local type_guy = get_type(ENT_TYPE.CHAR_GUY_SPELUNKY)
-- local type_hired = get_type(ENT_TYPE.CHAR_HIREDHAND)
-- local type_lise = get_type(ENT_TYPE.CHAR_LISE_SYSTEM)
-- local type_manfred = get_type(ENT_TYPE.CHAR_MANFRED_TUNNEL)
-- local type_margaret = get_type(ENT_TYPE.CHAR_MARGARET_TUNNEL)
-- local type_otaku = get_type(ENT_TYPE.CHAR_OTAKU)
-- local type_pilot = get_type(ENT_TYPE.CHAR_PILOT)
-- local type_airyn = get_type(ENT_TYPE.CHAR_PRINCESS_AIRYN)
-- local type_roffy = get_type(ENT_TYPE.CHAR_ROFFY_D_SLOTH)
-- local type_tina = get_type(ENT_TYPE.CHAR_TINA_FLAN)
-- local type_valerie = get_type(ENT_TYPE.CHAR_VALERIE_CRUMP)
local function create_minigame_ufo(spawn_left, y)
    ---@type UFO
    local entity = get_entity(spawn_entity(ENT_TYPE.MONS_UFO, spawn_left and X_LEFT_LIMIT or X_RIGHT_LIMIT, y, LAYER.FRONT, 0, 0))
    entity:set_pre_update_state_machine(function(self)
        -- type_amazon.id = 0
        -- type_ana.id = 0
        -- type_au.id = 0
        -- type_banda.id = 0
        -- type_classic.id = 0
        -- type_coco.id = 0
        -- type_colin.id = 0
        -- type_demi.id = 0
        -- type_dirk.id = 0
        -- type_eggplant.id = 0
        -- type_green.id = 0
        -- type_guy.id = 0
        -- type_hired.id = 0
        -- type_lise.id = 0
        -- type_manfred.id = 0
        -- type_margaret.id = 0
        -- type_otaku.id = 0
        -- type_pilot.id = 0
        -- type_airyn.id = 0
        -- type_roffy.id = 0
        -- type_tina.id = 0
        -- type_valerie.id = 0
        self.chased_target_uid = target_uid
        self.patrol_distance = 10*(spawn_left and 1 or -1)
        return false
    end)
    entity:set_post_update_state_machine(function (self)
        -- type_amazon.id = ENT_TYPE.CHAR_AMAZON
        -- type_ana.id = ENT_TYPE.CHAR_ANA_SPELUNKY
        -- type_au.id = ENT_TYPE.CHAR_AU
        -- type_banda.id = ENT_TYPE.CHAR_BANDA
        -- type_classic.id = ENT_TYPE.CHAR_CLASSIC_GUY
        -- type_coco.id = ENT_TYPE.CHAR_COCO_VON_DIAMONDS
        -- type_colin.id = ENT_TYPE.CHAR_COLIN_NORTHWARD
        -- type_demi.id = ENT_TYPE.CHAR_DEMI_VON_DIAMONDS
        -- type_dirk.id = ENT_TYPE.CHAR_DIRK_YAMAOKA
        -- type_eggplant.id = ENT_TYPE.CHAR_EGGPLANT_CHILD
        -- type_green.id = ENT_TYPE.CHAR_GREEN_GIRL
        -- type_guy.id = ENT_TYPE.CHAR_GUY_SPELUNKY
        -- type_hired.id = ENT_TYPE.CHAR_HIREDHAND
        -- type_lise.id = ENT_TYPE.CHAR_LISE_SYSTEM
        -- type_manfred.id = ENT_TYPE.CHAR_MANFRED_TUNNEL
        -- type_margaret.id = ENT_TYPE.CHAR_MARGARET_TUNNEL
        -- type_otaku.id = ENT_TYPE.CHAR_OTAKU
        -- type_pilot.id = ENT_TYPE.CHAR_PILOT
        -- type_airyn.id = ENT_TYPE.CHAR_PRINCESS_AIRYN
        -- type_roffy.id = ENT_TYPE.CHAR_ROFFY_D_SLOTH
        -- type_tina.id = ENT_TYPE.CHAR_TINA_FLAN
        -- type_valerie.id = ENT_TYPE.CHAR_VALERIE_CRUMP
        -- self.chased_target_uid = target_uid

        if spawn_left then
            update_kill_right_offscreen(self)
        else
            update_kill_left_offscreen(self)
        end
        return false
    end)
    if not spawn_left then
        entity.flags = set_flag(entity.flags, ENT_FLAG.FACING_LEFT)
    end
    entity:set_pre_damage(pre_enemy_damage_minigame_handling)
    -- entity:set_pre_update_state_machine(function (self)
    --     ---@type UFO
    --     if self.t then
            
    --     end
    --     return false
    -- end)
end

-- Force velocity of the imp to go to the right slowly
-- destroy the imp and its item once reaching a certain point of the stage
-- Maybe the imp holds random stuff?
local function create_minigame_imp(spawn_left, y)
    local entity = get_entity(spawn_entity(ENT_TYPE.MONS_IMP, spawn_left and X_LEFT_LIMIT or X_RIGHT_LIMIT, y, LAYER.FRONT, 0, 0))
    entity.velocityx = 0.04*(spawn_left and 1 or -1)
    entity:set_post_update_state_machine(spawn_left and update_kill_right_offscreen or update_kill_left_offscreen)
end

local function remove_all_minigame_ents()
    for _, v in pairs(get_entities_by_type({ENT_TYPE.MONS_IMP, ENT_TYPE.MONS_UFO, ENT_TYPE.MONS_ALIEN, ENT_TYPE.ITEM_UFO_LASER_SHOT})) do
        get_entity(v):destroy()
        generate_world_particles(PARTICLEEMITTER.MERCHANT_APPEAR_POOF, v)
    end
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
                local spawn_left = prng:random_chance(2, PRNG_CLASS.PARTICLES)
                if state.win_state == WIN_STATE.HUNDUN_WIN
                and prng:random_chance(5, PRNG_CLASS.PARTICLES) then
                    create_minigame_imp(spawn_left, y)
                else
                    create_minigame_ufo(spawn_left, y)
                end
            end
        else
            spawn_timeout = spawn_timeout - 1
        end
        if state.screen_credits.render_timer >= 240 then
        -- if state.screen_credits.render_timer >= 20 then -- UNCOMMENT TO TEST END OF MINIGAME
            minigame_state = GAME_STATE.POST_GAME
            timeout = 600
            
            remove_all_minigame_ents()
            local sound = get_sound(VANILLA_SOUND.DEATHMATCH_DM_ITEM_SPAWN)
            local audio = sound:play(true)
            audio:set_pause(false, SOUND_TYPE.SFX)
        end
    end
end

local function create_minigame_statemachine()
    local entity = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, 3, 109, LAYER.FRONT, 0, 0))
    entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
    entity.flags = set_flag(entity.flags, ENT_FLAG.NO_GRAVITY)
    entity.flags = set_flag(entity.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    entity:set_post_update_state_machine(update_minigame)
end

local alien_type_moveright = EntityDB:new(get_type(ENT_TYPE.MONS_ALIEN))
alien_type_moveright.max_speed = 0.06
local alien_type_moveleft = EntityDB:new(get_type(ENT_TYPE.MONS_ALIEN))
alien_type_moveleft.max_speed = 0.02
local ufo_laser_type = EntityDB:new(get_type(ENT_TYPE.ITEM_UFO_LASER_SHOT))
ufo_laser_type.damage = 2

local function init_minigame_ent_properties()
    local alien_cb = set_post_entity_spawn(function(alien)
        local x, _, _ = get_position(target_uid)
        local ax, _, _ = get_position(alien.uid)
        local move_left = x <= ax
        alien.type = move_left and alien_type_moveleft or alien_type_moveright
        alien:set_post_update_state_machine(function(self)
            if self.standing_on_uid ~= -1 then
                self.velocityx = move_left and 0.02 or 0.06
            end
            if test_flag(self.flags, ENT_FLAG.FACING_LEFT) and not move_left then
                self.flags = clr_flag(self.flags, ENT_FLAG.FACING_LEFT)
            elseif not test_flag(self.flags, ENT_FLAG.FACING_LEFT) and move_left then
                self.flags = set_flag(self.flags, ENT_FLAG.FACING_LEFT)
            end
            -- damage credits cavemen
            for _, v in ipairs(get_entities_by(ENT_TYPE.MONS_CAVEMAN, MASK.MONSTER, LAYER.FRONT)) do
                local other_ent = get_entity(v)
                if self:overlaps_with(other_ent) and other_ent.invincibility_frames_timer == 0 then
                    other_ent:damage(self.uid, 1, 0, 0, 0, 45)
                end
            end
            if move_left then
                update_kill_left_offscreen(self)
            else
                update_kill_right_offscreen(self)
            end
        end)
        alien:set_pre_damage(pre_enemy_damage_minigame_handling)
    end, SPAWN_TYPE.ANY, MASK.MONSTER, ENT_TYPE.MONS_ALIEN)
    local parachute_cb = set_post_entity_spawn(function(parachute)
        if parachute.animation_frame == 57 then
            -- message("GOLDEN PARACHUTE PREVENTED")
            parachute.animation_frame = prng:random_int(44, 46, PRNG_CLASS.ENTITY_VARIATION)
        end
    end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_POWERUP_PARACHUTE)
    local item_cb = set_post_entity_spawn(function(item, spawn_flags)
        if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
            if item.type.id == ENT_TYPE.ITEM_UFO_LASER_SHOT then
                item.type = ufo_laser_type
            end
            item:set_post_update_state_machine(function(self)
                if self.standing_on_uid ~= -1 then
                    self.velocityx = 0.08
                end
                update_kill_right_offscreen(self)
            end)
        end
    end, SPAWN_TYPE.ANY, MASK.ITEM)
    local fx_cb = set_pre_entity_spawn(function(ent_type, x, y, l, overlay, spawn_flags)
        if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
            return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
        end
    end, SPAWN_TYPE.ANY, MASK.BG, ENT_TYPE.BG_LEVEL_BOMB_SOOT)
    set_callback(function ()
        clear_callback(parachute_cb)
        clear_callback(alien_cb)
        clear_callback(item_cb)
        clear_callback(fx_cb)
        clear_callback()
    end, ON.CAMP)
end

function module.init(_target_uid, _camels, caveman1, caveman2)
    minigame_state = GAME_STATE.PRE_GAME
    spawn_timeout = TIMEOUT_MIN
    create_minigame_statemachine()--have to create a physical entity to be able to use a state machine
    init_minigame_ent_properties()
    target_uid = _target_uid
    camels = _camels
    get_entity(caveman1):set_pre_damage(pre_caveman_damage_minigame_handling)
    get_entity(caveman2):set_pre_damage(pre_caveman_damage_minigame_handling)
    hitmarks = {}

    set_callback(
        ---@param render_ctx VanillaRenderContext
    function(render_ctx)
        if state.screen == SCREEN.CREDITS then
            if minigame_state == GAME_STATE.IN_GAME
            or minigame_state == GAME_STATE.GAME_LOAD then
                local num_of_engaged = 0
                for c_i, camel_uid in ipairs(camels) do
                    local camel = get_entity(camel_uid)
                    --loop over the camels spawned, check if they are engaged in the MINIGAME state
                    if camel.user_data.state == 3 then -- MINIGAME_STATE.MINIGAME
                        num_of_engaged = num_of_engaged + 1

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
                
                        local hit_text = TextRenderingInfo:new(string.format("x%s", math.floor(camel.user_data.score)), 0.0012, 0.0012, VANILLA_TEXT_ALIGNMENT.LEFT, VANILLA_FONT_STYLE.BOLD)
                        hit_text.x, hit_text.y = x+0.04, y
                        render_ctx:draw_text(hit_text, Color:white())
                    end
                end
                --draw team total hud counter
                if num_of_engaged > 1 then
                    --bg
                    local x, y = 0.45, 0.82
                    local src = Quad:new()
                    src.top_left_x = 0
                    src.top_left_y = 0
                    src.top_right_x = 1
                    src.top_right_y = 0
                    src.bottom_left_x = 0
                    src.bottom_left_y = 1
                    src.bottom_right_x = 1
                    src.bottom_right_y = 1
                    local w = (1/6)*2
                    local h = (1/6)/0.5625
                    local dest = Quad:new()
                    dest.top_left_x = -w/2
                    dest.top_left_y = h/2
                    dest.top_right_x = w/2
                    dest.top_right_y = h/2
                    dest.bottom_left_x = -w/2
                    dest.bottom_left_y = -h/2
                    dest.bottom_right_x = w/2
                    dest.bottom_right_y = -h/2
                    dest:offset(x, y)
                    render_ctx:draw_screen_texture(total_team_texture_id, src, dest, Color:white())

                    ---@type TextRenderingInfo
                    local skip_text = TextRenderingInfo:new("Team Total:", 0.001, 0.001, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.NORMAL)
                    y = y+0.025
                    skip_text.x, skip_text.y = x, y
                    render_ctx:draw_text(skip_text, Color:black())
                    
                    ---@type TextRenderingInfo
                    local totalscore_value = TextRenderingInfo:new(string.format(get_team_total()), 0.001, 0.001, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.NORMAL)
                    totalscore_value.x, totalscore_value.y = x, y-0.065
                    render_ctx:draw_text(totalscore_value, Color:black())
                end
            elseif minigame_state == GAME_STATE.POST_GAME then
                if timeout > 0 then
                    timeout = timeout - 1
                end
        
                if timeout == 300 then
                    local sound = get_sound(VANILLA_SOUND.MENU_NAVI)
                    local audio = sound:play(true)
                    audio:set_pause(false, SOUND_TYPE.SFX)
                end
                if timeout <= 300 then
                    --Draw final total background
                    local team_total_cx, team_total_cy = 0, 0.15
            
                    local src = Quad:new()
                    src.top_left_x = 0
                    src.top_left_y = 0
                    src.top_right_x = 1
                    src.top_right_y = 0
                    src.bottom_left_x = 0
                    src.bottom_left_y = 1
                    src.bottom_right_x = 1
                    src.bottom_right_y = 1
                    local w = (1/2)*3/2
                    local h = (1/2)/0.5625
                    local dest = Quad:new()
                    dest.top_left_x = -w/2
                    dest.top_left_y = h/2
                    dest.top_right_x = w/2
                    dest.top_right_y = h/2
                    dest.bottom_left_x = -w/2
                    dest.bottom_left_y = -h/2
                    dest.bottom_right_x = w/2
                    dest.bottom_right_y = -h/2
                    dest:offset(team_total_cx, team_total_cy)
                    render_ctx:draw_screen_texture(total_texture_id, src, dest, Color:white())
            
                    ---@type TextRenderingInfo
                    local totalscore_text = TextRenderingInfo:new("Final Score:", 0.0023, 0.0023, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
                    totalscore_text.x, totalscore_text.y = team_total_cx, team_total_cy+0.15
                    render_ctx:draw_text(totalscore_text, Color:black())
                    totalscore_text.x, totalscore_text.y = totalscore_text.x-0.0035, totalscore_text.y+0.0035
                    render_ctx:draw_text(totalscore_text, Color:white())
                    
                    if timeout == 1 then
                        local sound = get_sound(VANILLA_SOUND.UI_SECRET2)
                        local audio = sound:play(true)
                        audio:set_pause(false, SOUND_TYPE.SFX)
                    end
                    if timeout == 0 then
                        ---@type TextRenderingInfo
                        local totalscore_value = TextRenderingInfo:new(string.format(get_team_total()), 0.0025, 0.0025, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
                        totalscore_value.x, totalscore_value.y = team_total_cx, team_total_cy-0.155
                        render_ctx:draw_text(totalscore_value, Color:black())
                        totalscore_value.x, totalscore_value.y = totalscore_value.x-0.0035, totalscore_value.y+0.0035
                        render_ctx:draw_text(totalscore_value, Color:white())
                    end
                end
            end
            for i=#hitmarks, 1, -1 do
                local amount = hitmarks[i].amount
                local is_positive = amount >= 0
                local color = is_positive and Color:green() or Color:red()
                amount = string.format(is_positive and "+%s" or "%s", amount)
                local hitmark_text = TextRenderingInfo:new(amount, 0.0025, 0.0025, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)

                local ix = hitmarks[i].x
                local iy = hitmarks[i].y + 0.5-1*(hitmarks[i].timeout/100)
                hitmark_text.x, hitmark_text.y = screen_position(ix, iy)

                render_ctx:draw_text(hitmark_text, Color:black())
                hitmark_text:set_text(amount, 0.0025, 0.0025, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
                hitmark_text.x, hitmark_text.y = hitmark_text.x-0.0035, hitmark_text.y+0.0035
                render_ctx:draw_text(hitmark_text, color)

                if hitmarks[i].timeout > 0 then
                    hitmarks[i].timeout = hitmarks[i].timeout - 1
                else
                    table.remove(hitmarks, i)
                end
            end
        else
            clear_callback()
        end
    end, ON.RENDER_PRE_HUD)
end

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