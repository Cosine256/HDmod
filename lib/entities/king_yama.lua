local module = {}

-- Setup texture sheet
local yama_texture_id
do
    local yama_texture_def = TextureDefinition.new()
    yama_texture_def.width = 1792
    yama_texture_def.height = 1158
    yama_texture_def.tile_width = 256
    yama_texture_def.tile_height = 386
    yama_texture_def.texture_path = 'res/king_yama.png'
    yama_texture_id = define_texture(yama_texture_def)
end
local yama_2_texture_id
do
    local yama_2_texture_def = TextureDefinition.new()
    yama_2_texture_def.width = 1536
    yama_2_texture_def.height = 772
    yama_2_texture_def.tile_width = 256
    yama_2_texture_def.tile_height = 386
    yama_2_texture_def.texture_path = 'res/king_yama_2.png'
    yama_2_texture_id = define_texture(yama_2_texture_def)
end
-- Sound effect path
local fart = create_sound('res/sounds/fart.wav')
local yell = create_sound('res/sounds/yamascream.wav')
local yell2 = create_sound('res/sounds/yamascream2.wav')
local yell3 = create_sound('res/sounds/yamascream3.wav')
local hurt = create_sound('res/sounds/yamahurt.wav')
local hurt2 = create_sound('res/sounds/yamahurt2.wav')
local hurt3 = create_sound('res/sounds/yamahurt3.wav')
local hurt4 = create_sound('res/sounds/yamahurt4.wav')
local hurt5 = create_sound('res/sounds/yamahurt5.wav')
local hurt6 = create_sound('res/sounds/yamahurt6.wav')
local defeat = create_sound('res/sounds/yamadead.wav')
local sfx = create_sound('')
local sfx_volume = 0.2
-- Custom ent type (we need yama's pieces to be fireproof)
local yama_piece = EntityDB:new(ENT_TYPE.MONS_AMMIT)
yama_piece.properties_flags = set_flag(yama_piece.properties_flags, 8)

-- Animations
local ANIMATION_INFO = {
    HEAD_IDLE = {
        start = 0;
        finish = 5;
        speed = 8;
    };
    HEAD_SPIT = {
        start = 7;
        finish = 12;
        speed = 8;
    };
    HEAD_EGGPLANT = {
        start = 6;
        finish = 6;
        speed = 1;        
    };
    HAND_IDLE = {
        start = 14;
        finish = 14;
        speed = 1; 
    };
    HAND_OPEN = {
        start = 14;
        finish = 20;
        speed = 7; 
    };
}

-- State enum
local HEAD_STATE = {
    IDLE = 2;
    FLY = 3;
    FLY_CHASE = 4;
    IMP = 5;
    CEILING_SLAM = 6;
    RAGE = 7;
    ATTACK = 8;
    EGGPLANT = 9;
    RETURN = 10;
}
local HAND_STATE = {
    SLAM = 1;
    SWING = 2;
    MAGMARS = 3;
    OPEN = 4;
    RETURN = 5;
    INTRO_SLAM = 6;
    DEACTIVATE = 7;
}
local function animate_entity(self)
    local hurt_pause = false
    if self.user_data.hurt_timer ~= nil then
        if self.user_data.hurt_timer > 0 then
            hurt_pause = true
        end
    end
    if self.user_data.custom_animation and not hurt_pause then
        -- Increase animation timer
        self.user_data.animation_timer = self.user_data.animation_timer + 1
        --- Animate the entity and reset the timer
        if self.user_data.animation_timer >= self.user_data.animation_info.speed then
            self.user_data.animation_timer = 1
            -- Advance the animation
            self.user_data.animation_frame = self.user_data.animation_frame + 1
            -- Loop if the animation has reached the end
            if self.user_data.animation_frame > self.user_data.animation_info.finish then
                self.user_data.animation_frame = self.user_data.animation_info.start
            end
        end
        -- Change the actual animation frame
        self.animation_frame = self.user_data.animation_frame
    end
    if hurt_pause then
        -- Still maintain custom animation frame
        self.animation_frame = self.user_data.animation_frame
    end
end
-- Remove the vanilla yama head and replace it with our own
set_post_entity_spawn(function(self)
    module.create_yama_head(self.x, self.y, self.layer)
    self:destroy()
end, SPAWN_TYPE.ANY, 0, {ENT_TYPE.MONS_YAMA})
------------------------------------
--------- YAMA'S HEAD --------------
local function slam(self)
    -- This does the screen shake and fx of a Yama hand slam. Also spawns skulls above player(s)
    commonlib.shake_camera(14, 14, 7, 7, 7, false)
    local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_OLMEC_STOMP, self.uid, 1)
    audio:set_volume(0.8)
    local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_OLMITE_ARMOR_BREAK, self.uid, 1)
    audio:set_volume(0.65)
    audio:set_parameter(VANILLA_SOUND_PARAM.COLLISION_MATERIAL, math.random(2, 3))
    audio:set_pitch(math.random(60, 80)/100)
end
local function yama_return(self, return_state)
    if self.overlay == nil then
        local sx, sy, _ = get_position(self.uid)
        local abs_x = (sx - self.user_data.home_x)
        local abs_y = (sy - self.user_data.home_y)
        local dist = math.sqrt((abs_x^2)+(abs_y^2))
        local move_rate = 0.07
        local movex = (abs_x/dist)*move_rate
        local movey = (abs_y/dist)*move_rate
        -- He'll get stuck if we cant move through walls
        self.flags = clr_flag(self.flags, ENT_FLAG.COLLIDES_WALLS)
        self.flags = clr_flag(self.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
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
        if math.abs(abs_y) < 0.069 then
            movey = 0
        end
        if movex == 0 and movey == 0 then
            self.user_data.state = return_state
            self.flags = set_flag(self.flags, ENT_FLAG.COLLIDES_WALLS)
            self.flags = set_flag(self.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
            -- Close enough!
            self.x = self.user_data.home_x
            self.y = self.user_data.home_y
            -- Sync up the attack timer to the opposite hand
            if return_state == HAND_STATE.SLAM then
                -- Stop the other hand from attacking temporarily to sync up with the other hand
                if self.user_data.other_hand ~= nil then
                    if type(self.user_data.other_hand.user_data) == "table" then
                        if self.user_data.other_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                            self.user_data.wait = true
                            self.user_data.attack_timer = self.user_data.other_hand.user_data.attack_timer
                        end
                    end
                end
                -- Make the hand face the right direction
                self.flags = set_flag(self.flags, ENT_FLAG.FACING_LEFT)
                if self.user_data.left_hand then
                    self.flags = clr_flag(self.flags, ENT_FLAG.FACING_LEFT)
                end
            end
            -- For Yama's head, remove gravity once back on his head
            if return_state == HEAD_STATE.IDLE then
                self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
            end
        end
        move_entity(self.uid, sx-movex, sy-movey, 0, 0)
    end
end
local function phase2_fireballs(self)
    -- This will override animations and spawn fireballs every 60 frames
    if self.user_data.fireball_timer > 0 then
        self.user_data.fireball_timer = self.user_data.fireball_timer - 1
        self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
    end
    if self.user_data.fireball_timer == 1 then
        self.user_data.fireball_timer = 0
        self.user_data.animation_info = ANIMATION_INFO.HEAD_SPIT
        self.user_data.animation_frame = self.user_data.animation_info.start
        self.animation_frame = self.user_data.animation_info.start
        commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_FROG_GIANT_OPEN, self.uid, 1)
        set_timeout(function()
            if self ~= nil then
                if not test_flag(self.flags, ENT_FLAG.DEAD) then
                    local m = get_entity(spawn(ENT_TYPE.MONS_MAGMAMAN, self.x, self.y+0.1, self.layer, math.random(-20, 20)/100, 0.1))
                    local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_FIRE_IGNITE, self.uid, 1)
                    commonlib.shake_camera(12, 12, 3, 3, 3, false)
                    local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_LAVAMANDER_ATK, self.uid, 1)
                    local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_FIRE_IGNITE, self.uid, 1)
                    generate_world_particles(PARTICLEEMITTER.SMALLFLAME_WARP, m.uid)
                    generate_world_particles(PARTICLEEMITTER.SMALLFLAME_SMOKE, m.uid)
                end
            end
        end, 18)
    end
    -- The spit animation ending indicates the end of the sequence, go back to idle
    if self.user_data.animation_info == ANIMATION_INFO.HEAD_SPIT and self.user_data.animation_frame == self.user_data.animation_info.finish and self.user_data.animation_timer and self.user_data.animation_timer == self.user_data.animation_info.speed-1 then
        self.user_data.fireball_timer = 80
        self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
        self.user_data.animation_frame = 0
    end
end
local function yama_head_fly(self)
    -- Passively reduce the timer for the slam attack
    if self.user_data.attack_timer > 0 then
        self.user_data.attack_timer = self.user_data.attack_timer - 1
    end
    self.velocityy = math.cos(self.idle_counter*0.09)/18
    self.velocityx = self.user_data.dir/14
    -- Flip when hitting a wall
    if test_flag(self.more_flags, ENT_MORE_FLAG.HIT_WALL) then
        if self.user_data.dir == 1 then
            self.x = self.x-0.1
        else
            self.x = self.x+0.1
        end
        self.user_data.dir = self.user_data.dir*-1
        self.more_flags = clr_flag(self.more_flags, ENT_MORE_FLAG.HIT_WALL) 
    end
    -- If offset from the bobbing range slowly creep our way back
    if self.y-self.velocityy < 115 then
        self.y = self.y + 0.06
        self.velocityy = 0
    end
    if self.y-self.velocityy > 118 then
        self.y = self.y - 0.06
        self.velocityy = 0
    end
    -- Countdown for spitting a magmar
    if self.x > 14 or self.x < 31 then
        phase2_fireballs(self)
    end
    -- If the slam timer is up and we're in the range to slam, do it
    if self.user_data.attack_timer == 0 then
        if self.x < 14 or self.x > 31 then
            self.user_data.state = HEAD_STATE.CEILING_SLAM
        end
    end
    -- If the player and yama are both within the range to chase, chase instead of fly
    for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
        local char = get_entity(v)
        local px, py, _ = get_position(v)
        local sx, sy, _ = get_position(self.uid)
        if commonlib.in_range(px, 14, 31) and commonlib.in_range(sx, 14, 31) and
        commonlib.in_range(py, 111, 123) and commonlib.in_range(sy, 111, 123) then
            self.user_data.state = HEAD_STATE.FLY_CHASE
        end
    end
end
local function yama_head_slam(self)
    -- Update animation info
    self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
    self.user_data.attack_timer = self.user_data.attack_timer + 1
    -- Go down
    if self.user_data.attack_timer <= 60 then
        self.velocityy = -0.03
    end
    -- Fly up
    if self.user_data.attack_timer >= 60 then
        self.velocityy = 0.33
        -- Do the slam sequence when hitting a ceiling
        local hb = get_hitbox(self.uid, -0.125, 0, 0.3)
        for _, v in ipairs(get_entities_overlapping_hitbox({0}, MASK.FLOOR | MASK.ACTIVEFLOOR, hb, self.layer)) do
            local w = get_entity(v)
            if test_flag(w.flags, ENT_FLAG.SOLID) then
                -- Slam SFX
                slam(self)
                -- Skulls
                for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
                    local char = get_entity(v)
                    local px, py, _ = get_position(v)
                    for i=-1, 1 do 
                        local skull = get_entity(spawn(ENT_TYPE.ITEM_SKULL, px+i, 122.5, self.layer, 0, 0))
                        skull.angle = math.random(0, 51)/5
                    end
                end
                -- Go back to fly state
                self.user_data.attack_timer = 180
                self.user_data.state = HEAD_STATE.FLY
            end
        end  
    end  
end
local function create_yama_flame(x, y, l)
    local f = get_entity(spawn(ENT_TYPE.ITEM_ROCK, x+math.random(-5, 5)/10, y+math.random(-5, 5)/10, l, math.random(-11, 11)/650, math.random(3, 15)/350))
    f.flags = set_flag(f.flags, ENT_FLAG.NO_GRAVITY)
    f.flags = set_flag(f.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    f.flags = clr_flag(f.flags, ENT_FLAG.COLLIDES_WALLS)
    f.user_data = {
        turn_rate = math.random(-3, 3)/100;
        decay_timer = math.random(90, 110);
        frame = math.random(1, 3);
    }
    f:set_texture(TEXTURE.DATA_TEXTURES_FX_SMALL_0)
    f:set_post_update_state_machine(function(self)
        f.animation_frame = self.user_data.frame
        self.user_data.decay_timer = self.user_data.decay_timer - 1
        if self.user_data.decay_timer == 0 then
            self:destroy()
        end
        f.color:set_rgba(255, 255, 255, math.floor(255*self.user_data.decay_timer/90))
        self.angle = self.angle + self.user_data.turn_rate
        -- Random deviation
        if math.random(100) then
            self.velocityx = math.random(-11, 11)/650
        end
    end)
    generate_world_particles(PARTICLEEMITTER.LAVAHEAT, f.uid)
    generate_world_particles(PARTICLEEMITTER.SMALLFLAME_SMOKE, f.uid)
    generate_world_particles(PARTICLEEMITTER.SMALLFLAME_WARP, f.uid)
end
local function yama_idle(self)
    -- Update animation
    self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
    -- Cutscene --
    if self.user_data.cutscene_timer ~= 0 then
        self.user_data.cutscene_timer = self.user_data.cutscene_timer - 1
        -- Black bars, invincible players
        if self.user_data.cutscene_timer == 599 then
            -- Create blackbars
            set_timeout(function()
                -- The blackbars dont handle moving the camera the way we are and it makes the bars shakey
                -- To fix this, we're just gonna make the bars show up later!
                self.user_data.blackbars = get_entity(spawn(ENT_TYPE.LOGICAL_CINEMATIC_ANCHOR, 0, 0, self.layer, 0, 0))           
            end, 40)
            -- Hide HUD
            state.level_flags = set_flag(state.level_flags, 22)
            -- Make players invincible and unable to move
            for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
                local char = get_entity(v)
                char.flags = set_flag(char.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
                char.more_flags = set_flag(char.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
            end
        end
        -- Set camera to Yama
        if self.user_data.cutscene_timer < 599 then
            if state.camera.focus_offset_y < 24 then
                state.camera.focus_offset_y = state.camera.focus_offset_y + 0.2 
            end
        end
        -- Skip cutscene
        if self.user_data.cutscene_timer < 500 and self.user_data.cutscene_timer > 20 then
            for _, v in ipairs(get_entities_by({}, MASK.PLAYER, self.layer)) do
                local char = get_entity(v)
                -- Jump button
                if char.input.buttons == 1 then
                    self.user_data.cutscene_timer = 1
                end
            end
        end
        if self.user_data.cutscene_timer == 1 then
            -- Trigger horse and Ox guy
            set_timeout(function()
                for _, v in ipairs(get_entities_by({ENT_TYPE.MONS_CAVEMAN_BOSS}, MASK.ANY, self.layer)) do
                    local mons = get_entity(v)
                    if type(mons.user_data) == "table" then
                        if mons.user_data.ent_type == HD_ENT_TYPE.MONS_HELL_MINIBOSS then
                            -- Oxguy
                            if not mons.user_data.is_horsehead then
                                --  Face left and jump left
                                mons.flags = set_flag(mons.flags, ENT_FLAG.FACING_LEFT)
                                mons.velocityy = 0.10
                                mons.velocityx = -0.17
                                mons.x = mons.x - 2
                                mons.y = mons.y + 1.5
                            end
                            -- Horsedude
                            if mons.user_data.is_horsehead then
                                --  Face right and jump right
                                mons.flags = clr_flag(mons.flags, ENT_FLAG.FACING_LEFT)
                                mons.velocityy = 0.10
                                mons.velocityx = 0.17  
                                mons.x = mons.x + 2
                                mons.y = mons.y + 1.5                      
                            end
                        end
                    end
                end           
            end, 10)
            -- Make players damageable and able to move, also give iframes
            for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
                local char = get_entity(v)
                char.flags = clr_flag(char.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
                char.more_flags = clr_flag(char.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
            end
            -- Kill black bars, enable hud + player movement
            self.user_data.blackbars:kill(false, nil)
            state.level_flags = clr_flag(state.level_flags, 22)
            -- Reset camera
            state.camera.focus_offset_y = 0
        end
        if self.user_data.cutscene_timer > 0 then
            self.user_data.cutscene_timer = self.user_data.cutscene_timer - 1
        end
    end
    -- Phase 1 imp spit attack
    if not self.user_data.phase2 then
        local in_range = false
        for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
            local char = get_entity(v)
            local _, y, _ = get_position(self.uid)
            local _, py, _ = get_position(char.uid)
            if py > y-5 then
                in_range = true
                break
            end
        end
        -- This way if he's started an attack he will complete it instead of just stopping
        if (in_range or self.user_data.imp_timer < 260) and self.user_data.missing_hand then
            self.user_data.imp_timer = self.user_data.imp_timer - 1
        end
        -- Warning
        if self.user_data.imp_timer == 30 then
            commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_FROG_GIANT_OPEN, self.uid, 1)
        end
        if self.user_data.imp_timer == 0 then
            -- Update animation info
            self.user_data.animation_info = ANIMATION_INFO.HEAD_SPIT
            self.user_data.animation_frame = self.user_data.animation_info.start
            self.animation_frame = self.user_data.animation_info.start
            -- Reset timer and spawn imp
            self.user_data.imp_timer = 260
            self.user_data.state = HEAD_STATE.IMP
            set_timeout(function()
                local imp = get_entity(spawn(ENT_TYPE.MONS_IMP, self.x, self.y, self.layer, 0, 0))
                get_entity(imp.carrying_uid):destroy()
                -- effects
                commonlib.shake_camera(12, 12, 3, 3, 3, false)
                local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_LAVAMANDER_ATK, self.uid, 1)
                local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_FIRE_IGNITE, self.uid, 1)
                generate_world_particles(PARTICLEEMITTER.SMALLFLAME_WARP, imp.uid)
                generate_world_particles(PARTICLEEMITTER.SMALLFLAME_SMOKE, imp.uid)
            end, 18)
        end
    end
    -- Enter pre phase 2 rage
    if self.user_data.phase2 then
        self.user_data.animation_info = ANIMATION_INFO.HEAD_SPIT
        self.user_data.animation_frame = self.user_data.animation_info.start
        self.animation_frame = self.user_data.animation_info.start
        self.user_data.state = HEAD_STATE.RAGE
        self.user_data.attack_timer = 0
        self.user_data.custom_animation = false
        -- Sfx
        local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.TRAPS_BOULDER_WARN_LOOP, self.uid, 1)
        set_global_timeout(function()
            audio:stop()
        end, 110)
    end
end
local function yama_head_rage(self)
    -- Invincible while enraged
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    self.user_data.attack_timer = self.user_data.attack_timer + 1
    -- Shake in rage!
    if self.user_data.attack_timer <= 100 then
        self.x = self.x + math.cos(self.idle_counter)/50
        self.y = self.y + math.cos(self.idle_counter)/50
        -- Keep face from animating
        self.user_data.custom_animation = false
        self.animation_frame = 7
    end
    -- Scream + sfx
    if self.user_data.attack_timer == 100 then
        local roll = math.random(2)
        local chosen_yell = yell
        if roll == 1 then
            chosen_yell = yell2
        elseif roll == 2 then
            chosen_yell = yell3
        end
        -- Sound effect
        local audio = chosen_yell:play()
        local x, y, _ = get_position(self.uid)
        local sx, sy = screen_position(x, y)
        local d = screen_distance(distance(self.uid, self.uid))
        if players[1] ~= nil then
            d = screen_distance(distance(self.uid, players[1].uid))
        end
        audio:set_parameter(VANILLA_SOUND_PARAM.POS_SCREEN_X, sx)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_X, math.abs(sx)*1.5)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_Y, math.abs(sy)*1.5)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_Z, 0.0)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_PLAYER, d)
        audio:set_parameter(VANILLA_SOUND_PARAM.VALUE, sfx_volume)
        audio:set_volume(sfx_volume)
        audio:set_pause(false)
        -- Particle effect
        generate_world_particles(PARTICLEEMITTER.TIAMAT_SCREAM_WARP, self.uid)
        generate_world_particles(PARTICLEEMITTER.GHOST_WARP, self.uid)
        commonlib.shake_camera(15, 15, 8, 8, 8, false)
        -- Center back onto his face
        self.x = self.user_data.home_x
        self.y = self.user_data.home_y
        -- Start animation
        self.user_data.custom_animation = true
        -- These effects only happen during phase2
        if not self.user_data.intro_yell then
            -- Start the flame effects
            self.user_data.phase2_flames = true
            -- Update texture
            self:set_texture(yama_2_texture_id)
            -- Looping fire effect
            local snd = commonlib.play_sound_at_entity(VANILLA_SOUND.ENEMIES_FIREBUG_ATK_LOOP, self.uid, 1)
            self:set_post_update_state_machine(function()
                commonlib.update_sound_volume(snd, self.uid, 1)
            end)
            -- Flags
            self.flags = clr_flag(self.flags, ENT_FLAG.PICKUPABLE)
            self.flags = clr_flag(self.flags, ENT_FLAG.THROWABLE_OR_KNOCKBACKABLE)
            self.flags = clr_flag(self.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
            -- Stop fire SFX
            self:set_pre_destroy(function()
                snd:stop()
            end)
            local cb = set_callback(function()
                if snd ~= nil then
                    snd:stop()
                end
            end, ON.POST_ROOM_GENERATION)
        end
    end
    if self.user_data.attack_timer > 100 then
        -- Animate the face up until the scream
        if self.user_data.animation_frame == 10 then
            self.user_data.custom_animation = false
            self.user_data.animation_frame = 10
            self.animation_frame = 10
        end
    end
    -- Finish animation before we go into phase 2
    if self.user_data.attack_timer >= 200 then
        self.user_data.custom_animation = true
    end
    -- Change state after animation finishes
    if self.user_data.animation_frame == self.user_data.animation_info.finish and self.user_data.animation_timer == self.user_data.animation_info.speed-1 then
        if not self.user_data.intro_yell then
            self.flags = clr_flag(self.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
            self.user_data.home_y = 117
            self.user_data.state = HEAD_STATE.FLY
            self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
            self.user_data.animation_frame = 0
            self.animation_frame = 0
            self.user_data.attack_timer = 0     
            -- Update hitbox so we can do the HD crush kill
            self.hitboxx = self.hitboxx*1.2  
        else
            self.user_data.state = HEAD_STATE.IDLE
            self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
            self.flags = clr_flag(self.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
            self.user_data.animation_frame = 0
            self.animation_frame = 0
            self.user_data.attack_timer = 0
            self.user_data.intro_yell = false
        end
    end
end
local function yama_head_chase(self)
    local closest_player_distance = 9999
    local cpx, cpy = 0, 0
    for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
        local char = get_entity(v)
        local _, y, _ = get_position(self.uid)
        local px, py, _ = get_position(char.uid)
        -- calculate closest player distance
        local dist = distance(self.uid, char.uid)
        if dist < closest_player_distance then
            closest_player_distance = dist
            cpx = px
            cpy = py
        end
    end
    -- Deal damage to the player
    self.flags = clr_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    self.user_data.target_x = cpx
    self.user_data.target_y = cpy
    self.flags = clr_flag(self.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
    -- Move towards target
    local sx, sy, _ = get_position(self.uid)
    local abs_x = (sx - self.user_data.target_x)
    local abs_y = (sy - self.user_data.target_y)
    local dist = math.sqrt((abs_x^2)+(abs_y^2))
    local move_rate = 0.06
    local movex = (abs_x/dist)*move_rate
    local movey = (abs_y/dist)*move_rate
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
    if math.abs(abs_y) < 0.069 then
        movey = 0
    end
    move_entity(self.uid, sx-movex, sy-movey, 0, 0)
    -- Passively reduce the timer for the slam attack
    if self.user_data.attack_timer > 0 then
        self.user_data.attack_timer = self.user_data.attack_timer - 1
    end
    -- Countdown for spitting a magmar
    phase2_fireballs(self)
    -- If the slam timer is up and we're in the range to slam, do it
    if self.user_data.attack_timer == 0 then
        if self.x < 14 or self.x > 31 then
            self.user_data.state = HEAD_STATE.CEILING_SLAM
        end
    end
    -- If there isnt a player in the chase range go back to flying
    local in_range = false
    for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
        local char = get_entity(v)
        local px, py, _ = get_position(v)
        if commonlib.in_range(px, 14, 31) and commonlib.in_range(py, 111, 123) then
            in_range = true
        end
    end
    if not in_range then
        self.user_data.state = HEAD_STATE.FLY
    end
end
local function yama_head_imp(self)
    self.user_data.animation_info = ANIMATION_INFO.HEAD_SPIT
    -- End state at the end of the animation
    if self.user_data.animation_frame == self.user_data.animation_info.finish and self.user_data.animation_timer == self.user_data.animation_info.speed-1 then
        self.user_data.state = HEAD_STATE.IDLE
    end
end
local function yama_head_update(self)
    -- Brick the base entity's AI. We're going full LUA for this!
    self.state = 18
    self.move_state = 0
    self.lock_input_timer = 5
    -- STATEMACHINE
    local d = self.user_data
    if d.state == HEAD_STATE.IDLE then
        yama_idle(self)
    elseif d.state == HEAD_STATE.RETURN then
        if not self.user_data.phase2 then
            yama_return(self, HEAD_STATE.IDLE)
        else
            yama_return(self, 200)
        end
    elseif d.state == HEAD_STATE.IMP then
        yama_head_imp(self)
    elseif d.state == HEAD_STATE.RAGE then
        yama_head_rage(self)
    elseif d.state == HEAD_STATE.FLY_CHASE then
        yama_head_chase(self)
    elseif d.state == HEAD_STATE.FLY then
        yama_head_fly(self)
    elseif d.state == HEAD_STATE.CEILING_SLAM then
        yama_head_slam(self)
    elseif d.state == HEAD_STATE.ATTACK then

    elseif d.state == HEAD_STATE.EGGPLANT then
    end
    -- We need gravity to be able to throw this entity
    if not self.user_data.phase2 then
        if self.overlay ~= nil then
            self.flags = clr_flag(self.flags, ENT_FLAG.NO_GRAVITY)
        else
            self.velocityy = 0
            self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
        end
    end
    -- Update hurt timer
    if self.user_data.hurt_timer > 0 then
        self.user_data.hurt_timer = self.user_data.hurt_timer - 1
    end
    -- Check for phase2
    -- Less than 21 health
    if self.health <= 20 then
        self.user_data.phase2 = true
    end
    -- If both hands are dead phase2 starts no matter what
    local lefthand = false
    local righthand = false
    if self.user_data.left_hand ~= nil then
        if type(self.user_data.left_hand.user_data) == "table" then
            if self.user_data.left_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                lefthand = true
            end
        end
    end
    if self.user_data.right_hand ~= nil then
        if type(self.user_data.right_hand.user_data) == "table" then
            if self.user_data.right_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                righthand = true 
            end
        end
    end
    if not lefthand and not righthand then
        self.user_data.phase2 = true
    end
    -- Fireball effect in phase 2
    if self.user_data.phase2_flames then
        self.user_data.fireeffect_timer = self.user_data.fireeffect_timer - 1
        if self.user_data.fireeffect_timer == 0 then
            self.user_data.fireeffect_timer = 3
            create_yama_flame(self.x, self.y, self.layer)
        end
    end
    -- Custom animation
    animate_entity(self)
end
local function yama_head_set(self)
    self.type = yama_piece
    -- Userdata
    self.user_data = {
        ent_type = HD_ENT_TYPE.MONS_YAMA_HEAD;

        -- ANIMATION
        animation_timer = 1;
        animation_frame = 0;
        animation_info = ANIMATION_INFO.HEAD_IDLE; -- Info about animation speed, start frame, stop frame
        custom_animation = true; -- When false we let the game handle animations

        -- AI
        state = HEAD_STATE.IDLE;
        cutscene_timer = 600; -- Cutscene for Yama is automatically played whenever he's spawned in.
        attack_timer = 0;
        fireeffect_timer = 3; -- When 0 creates fx fireballs
        fireball_timer = 80; -- When 0 Yama will shoot fireballs
        imp_timer = 260; -- When 0 Yama will spit an imp out of his mouth
        dir = 1; -- Direction yama's head will fly in when idling
        hurt_timer = 0; -- Pauses animation and does a minor shake
        intro_yell = true; -- Start phase1 instead of phase2 during the rage state

        target = nil; -- Points to the entity yama will chase in phase 2

        phase2 = false; -- Used to check if Yama is in phase 2
        phase2_flames = false; -- spawn the phase 2 flames?
        missing_hand = false; -- If a hand dies this will be set to true

        blackbars = nil; -- Blackbar entity used in the cutscene

        home_x = self.x;
        home_y = self.y;

        target_x = self.x;
        target_y = self.y;

        left_hand = module.create_yama_hand(self.x-2.73, self.y -1.2, self.layer);
        right_hand = module.create_yama_hand(self.x+2.73, self.y -1.2, self.layer);

    };
    -- Set health
    self.health = 40
    -- Custom texture
    self:set_texture(yama_texture_id)
    self.width = 2
    self.height = 3
    -- Since these bosses are so mechanically similar we're just copying Tiamat's hitboxes
    self.hitboxx = get_type(ENT_TYPE.MONS_TIAMAT).hitboxx
    self.hitboxy = get_type(ENT_TYPE.MONS_TIAMAT).hitboxy
    -- Flags
    self.flags = clr_flag(self.flags, ENT_FLAG.CAN_BE_STOMPED)
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    self.flags = set_flag(self.flags, ENT_FLAG.PICKUPABLE)
    self.flags = set_flag(self.flags, ENT_FLAG.THROWABLE_OR_KNOCKBACKABLE)
    self.flags = clr_flag(self.flags, ENT_FLAG.USABLE_ITEM)
    -- This stops Yama's head from being pushed by shields
    self.more_flags = set_flag(self.more_flags, 4)
    -- Make hands face the appropriate direction
    self.user_data.left_hand.flags = clr_flag(self.user_data.left_hand.flags, ENT_FLAG.FACING_LEFT)
    self.user_data.right_hand.flags = set_flag(self.user_data.right_hand.flags, ENT_FLAG.FACING_LEFT)
    -- Set self as the "yama" for these hands
    self.user_data.left_hand.user_data.yama = self
    self.user_data.right_hand.user_data.yama = self
    self.user_data.left_hand.user_data.other_hand = self.user_data.right_hand
    self.user_data.right_hand.user_data.other_hand = self.user_data.left_hand
    self.user_data.left_hand.user_data.left_hand = true
    -- Statemachine
    self:set_post_update_state_machine(yama_head_update)
    -- Animation frame gets overriden on damage
    self:set_post_damage(animate_entity)
    -- Sound effects when getting hurt (sometimes)
    self:set_post_damage(function()
        if math.random(4) == 1 and self ~= nil then
            if self.user_data.fireball_timer > 0 then
                self.user_data.hurt_timer = 20
            end
            --needs more variation, like atelast 6 different sounds
            local roll = math.random(5)
            local chosen_hurt = hurt
            if roll == 1 then
                chosen_hurt = hurt2
            elseif roll == 2 then
                chosen_hurt = hurt3
            elseif roll == 3 then
                chosen_hurt = hurt4
            elseif roll == 4 then
                chosen_hurt = hurt5
            elseif roll == 5 then
                chosen_hurt = hurt6
            end
            -- Sound effect
            local audio = chosen_hurt:play()
            local x, y, _ = get_position(self.uid)
            local sx, sy = screen_position(x, y)
            local d = screen_distance(distance(self.uid, self.uid))
            if players[1] ~= nil then
                d = screen_distance(distance(self.uid, players[1].uid))
            end
            audio:set_parameter(VANILLA_SOUND_PARAM.POS_SCREEN_X, sx)
            audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_X, math.abs(sx)*1.5)
            audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_Y, math.abs(sy)*1.5)
            audio:set_parameter(VANILLA_SOUND_PARAM.DIST_Z, 0.0)
            audio:set_parameter(VANILLA_SOUND_PARAM.DIST_PLAYER, d)
            audio:set_parameter(VANILLA_SOUND_PARAM.VALUE, sfx_volume)
            audio:set_volume(sfx_volume*0.4)
            audio:set_pause(false)
        end
    end)
    -- Death sound
    self:set_pre_kill(function()
        -- Cursed particle effect bc it looks cool
        generate_world_particles(PARTICLEEMITTER.ALTAR_SKULL, self.uid)
        -- Sound effect
        local audio = defeat:play()
        local x, y, _ = get_position(self.uid)
        local sx, sy = screen_position(x, y)
        local d = screen_distance(distance(self.uid, self.uid))
        if players[1] ~= nil then
            d = screen_distance(distance(self.uid, players[1].uid))
        end
        audio:set_parameter(VANILLA_SOUND_PARAM.POS_SCREEN_X, sx)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_X, math.abs(sx)*1.5)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_Y, math.abs(sy)*1.5)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_Z, 0.0)
        audio:set_parameter(VANILLA_SOUND_PARAM.DIST_PLAYER, d)
        audio:set_parameter(VANILLA_SOUND_PARAM.VALUE, sfx_volume)
        audio:set_volume(sfx_volume)
        audio:set_pause(false)   
        -- "Deactivate" hands (if they exist)
        if self.user_data.left_hand ~= nil then
            if type(self.user_data.left_hand.user_data) == "table" then
                if self.user_data.left_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                    self.user_data.left_hand.user_data.state = HAND_STATE.DEACTIVATE
                    self.user_data.left_hand.user_data.attack_timer = 240
                end
            end
        end
        if self.user_data.right_hand ~= nil then
            if type(self.user_data.right_hand.user_data) == "table" then
                if self.user_data.right_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                    self.user_data.right_hand.user_data.state = HAND_STATE.DEACTIVATE
                    self.user_data.right_hand.user_data.attack_timer = 240
                end
            end
        end 
        -- After this whole effect (about 4.5 seconds) play the cue for the door opening (for speedrun sake the door is already unlocked, but plays no sfx)
        set_timeout(function()
            if state.screen == SCREEN.LEVEL then
                local ps = nil
                for _, v in ipairs(get_entities_by(0, MASK.PLAYER, self.layer)) do
                    local player = get_entity(v)
                    if player ~= nil then
                        ps = player
                        break
                    end
                end
                --[[
                if ps ~= nil then
                    commonlib.play_sound_at_entity(VANILLA_SOUND.UI_SECRET, ps.uid, 1)
                end
                ]]
            end
        end, 180)
    end)
    -- Trick character statemachines into thinking the entity can be picked up (entities with no gravity flagged cant be picked up)
    set_timeout(function()
        for _ , v in ipairs(get_entities_by({}, MASK.PLAYER, LAYER.BOTH)) do
            local char = get_entity(v)
            local real_standing_uid = -1
            char:set_pre_update_state_machine(function()
                real_standing_uid = self.standing_on_uid
                self.standing_on_uid = char.standing_on_uid
                -- We also need to move his head upwards to match the pickup hitbox
                if test_flag(self.flags, ENT_FLAG.NO_GRAVITY) then
                    self.y = self.y+1 
                end
            end)
            char:set_post_update_state_machine(function()
                self.standing_on_uid = real_standing_uid
                if test_flag(self.flags, ENT_FLAG.NO_GRAVITY) then
                    self.y = self.y-1 
                end
            end)
        end
    end, 1)
end
------------------------------------
--------- YAMA'S HANDS -------------
local function hand_slam(self)
    -- Update animation
    self.user_data.animation_info = ANIMATION_INFO.HAND_IDLE
    -- Slam
    local in_range = false
    local closest_player_distance = 999
    local cpx, cpy = 0, 0
    for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
        local char = get_entity(v)
        local _, y, _ = get_position(self.uid)
        local px, py, _ = get_position(char.uid)
        -- calculate closest player distance
        local dist = distance(self.uid, char.uid)
        if dist < closest_player_distance then
            closest_player_distance = dist
            cpx = px
            cpy = py
        end
        if py > y-5 then
            in_range = true
        end
    end
    -- This way if he's started an attack he will complete it instead of just stopping
    if (in_range or self.user_data.attack_timer <= 200) then
       self.user_data.attack_timer = self.user_data.attack_timer - 1
    end
    -- Sequence
    if self.overlay == nil and not self.user_data.wait then
        -- Decide a special attack if the player is near
        if self.user_data.attack_timer == 200 and closest_player_distance < 4 then
            local roll = math.random(4)
            if roll == 1 then
                -- MAGMAR SPAWNING HAND STATE
                -- Since I programmed this in the complete wrong way, we will hijack here and switch states and clear some timers
                self.user_data.state = HAND_STATE.MAGMARS
                self.user_data.attack_timer = 0
                -- Update animation info
                self.user_data.animation_info = ANIMATION_INFO.HAND_OPEN
                self.user_data.animation_frame = self.user_data.animation_info.start
                -- Force the other hand to wait if we pick this attack
                if self.user_data.other_hand ~= nil then
                    if type(self.user_data.other_hand.user_data) == "table" then
                        if self.user_data.other_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                            self.user_data.other_hand.user_data.wait = true
                            self.user_data.other_hand.user_data.attack_timer = self.user_data.attack_timer
                        end
                    end
                end
                return
            end
            if roll == 2 then
                -- Cancel this if the other hand is already swinging
                local c = false
                if self.user_data.other_hand ~= nil then
                    if type(self.user_data.other_hand.user_data) == "table" then
                        if self.user_data.other_hand.user_data.state == HAND_STATE.SWING then
                            c = true
                        end
                    end
                end
                if not c then
                    -- SWING STATE
                    self.user_data.state = HAND_STATE.SWING
                    self.user_data.attack_timer = 0
                    -- Update animation info
                    self.user_data.animation_info = ANIMATION_INFO.HAND_IDLE
                    self.user_data.animation_frame = self.user_data.animation_info.start
                    -- Let it go through walls
                    self.flags = clr_flag(self.flags, ENT_FLAG.COLLIDES_WALLS)
                    self.flags = clr_flag(self.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
                    -- Sfx
                    local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.TRAPS_BOULDER_WARN_LOOP, self.uid, 1)
                    set_global_timeout(function()
                        audio:stop()
                    end, 55)
                    -- Let the other hand do whatever it wants, we'll sync with it later
                    if self.user_data.other_hand ~= nil then
                        if type(self.user_data.other_hand.user_data) == "table" then
                            if self.user_data.other_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                                self.user_data.other_hand.user_data.wait = false
                            end
                        end
                    end
                end
                return
            end
        end
        if commonlib.in_range(self.user_data.attack_timer, 100, 200) then
            self.y = self.y + 0.013
        end
        -- At 100 frames, slam down
        if self.user_data.attack_timer < 100 then
            self.y = self.y - 0.14
            -- Once we hit some kind of floor, go back up to 280 for a short cooldown
            if self:can_jump() then
                self.user_data.attack_timer = 280
                self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
                -- Slam SFX
                slam(self)
                -- Skulls
                if true then
                    -- Find players
                    for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
                        local char = get_entity(v)
                        local px, py, _ = get_position(v)
                        for i=-1, 1 do 
                            local skull = get_entity(spawn(ENT_TYPE.ITEM_SKULL, px+i, 122.5, self.layer, 0, 0))
                            skull.angle = math.random(0, 51)/5
                        end
                    end
                end
                -- Clear the opposite hands wait + sync
                if self.user_data.other_hand ~= nil then
                    if type(self.user_data.other_hand.user_data) == "table" then
                        if self.user_data.other_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                            self.user_data.other_hand.user_data.wait = false
                            self.user_data.other_hand.user_data.attack_timer = self.user_data.attack_timer
                        end
                    end
                end
            end
            -- Make the hands able to damage the player
            if not self:can_jump() and self.user_data.attack_timer > 70 then
                self.flags = clr_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
            end
        end
    end
end
local function hand_swing(self)
    self.user_data.attack_timer = self.user_data.attack_timer + 1
    -- He'll get stuck if we cant move through walls
    self.flags = clr_flag(self.flags, ENT_FLAG.COLLIDES_WALLS)
    -- Make the hands dangerous
    self.flags = clr_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    -- Short warning shake before the swing
    if self.user_data.attack_timer < 55 then
        self.x = self.x + math.cos(self.idle_counter)/50
        self.y = self.y + math.cos(self.idle_counter)/50
    end
    -- Since we have such a long windup we can calculate the target position later
    if self.user_data.attack_timer == 53 then
        local closest_player_distance = 9999
        local cpx, cpy = 0, 0
        for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
            local char = get_entity(v)
            local _, y, _ = get_position(self.uid)
            local px, py, _ = get_position(char.uid)
            -- calculate closest player distance
            local dist = distance(self.uid, char.uid)
            if dist < closest_player_distance then
                closest_player_distance = dist
                cpx = px
                cpy = py
            end
        end
        self.user_data.target_x = cpx
        self.user_data.target_y = cpy
    end
    -- Sound effects!
    if self.user_data.attack_timer == 55 then
        commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_TOSS, self.uid, 1)
    end
    -- Go towards the target position (set before this state)
    if self.user_data.attack_timer >= 55 then
        local sx, sy, _ = get_position(self.uid)
        local abs_x = (sx - self.user_data.target_x)
        local abs_y = (sy - self.user_data.target_y)
        local dist = math.sqrt((abs_x^2)+(abs_y^2))
        local move_rate = 0.22
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
        if math.abs(abs_x) < 0.25 then
            movex = 0
        end
        if math.abs(abs_y) < 0.25 then
            movey = 0
        end
        if movex == 0 and movey == 0 then
            self.flags = set_flag(self.flags, ENT_FLAG.COLLIDES_WALLS)
            -- Close enough!
            self.x = self.user_data.target_x
            self.y = self.user_data.target_y
            -- Let the return state handle the rest of this
            self.user_data.state = HAND_STATE.RETURN
            self.user_data.wait = true
            self.user_data.attack_timer = 280
        end
        move_entity(self.uid, sx-movex, sy-movey, 0, 0)
    end
end
local function hand_magmars(self)
    self.user_data.attack_timer = self.user_data.attack_timer + 1
    -- Lock animation when within the "attack range"
    self.user_data.custom_animation = true
    if self.user_data.attack_timer > 21 and self.user_data.attack_timer < 110 then
        self.user_data.custom_animation = false
        self.user_data.animation_frame = 18
        self.animation_frame = 18
        -- Whenever the counter is divisible by 25, spawn a magmaman
        if math.fmod(self.user_data.attack_timer, 25) == 1 then
            local m = get_entity(spawn(ENT_TYPE.MONS_MAGMAMAN, self.x, self.y+0.1, self.layer, math.random(-35, 35)/100, 0.235))
            local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.SHARED_FIRE_IGNITE, self.uid, 1)
        end
    end
    -- When the animation ends go to the "closed hand" animation
    if self.user_data.animation_frame == self.user_data.animation_info.finish and self.user_data.animation_timer == self.user_data.animation_info.speed - 1 then
        self.user_data.animation_info = ANIMATION_INFO.HAND_IDLE
        self.user_data.animation_frame = self.user_data.animation_info.start
        self.animation_frame = self.user_data.animation_info.start
    end
    -- Slooowly rise
    if self.user_data.attack_timer < 110 and self.user_data.attack_timer > 21 then
        self.y = self.y + 0.008
    end
    -- Go back down
    if self.user_data.attack_timer > 110 then
        self.y = self.y - 0.07
    end
    -- End state when touching ground
    if self:can_jump() then
        self.user_data.attack_timer = 280
        self.user_data.state = HAND_STATE.SLAM
        -- Clear the opposite hands wait + sync
        if self.user_data.other_hand ~= nil then
            if type(self.user_data.other_hand.user_data) == "table" then
                if self.user_data.other_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                    self.user_data.other_hand.user_data.wait = false
                    self.user_data.other_hand.user_data.attack_timer = self.user_data.attack_timer
                end
            end
        end
    end
end
local function hand_slam_intro(self)
    -- Update animation
    self.user_data.animation_info = ANIMATION_INFO.HAND_IDLE
    -- Slam
    local in_range = false
    for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
        local char = get_entity(v)
        local _, y, _ = get_position(self.uid)
        local _, py, _ = get_position(char.uid)
        if py > y-3 then
            in_range = true
            break
        end
    end
    self.user_data.attack_timer = self.user_data.attack_timer - 1
    -- Sequence
    -- Have the hands rise up
    if commonlib.in_range(self.user_data.attack_timer, 100, 200) then
        self.y = self.y + 0.013
   end
   -- Trigger yama to yell (he stubbed his toe)
    if self.user_data.attack_timer == 195 then
        self.user_data.yama.user_data.animation_info = ANIMATION_INFO.HEAD_SPIT
        self.user_data.yama.user_data.animation_frame = self.user_data.yama.user_data.animation_info.start
        self.user_data.yama.animation_frame = self.user_data.yama.user_data.animation_info.start
        self.user_data.yama.user_data.state = HEAD_STATE.RAGE
        self.user_data.yama.user_data.attack_timer = 0
        self.user_data.yama.user_data.custom_animation = false
        -- Sfx
        local audio = commonlib.play_sound_at_entity(VANILLA_SOUND.TRAPS_BOULDER_WARN_LOOP, self.user_data.yama.uid, 1)
        set_global_timeout(function()
            audio:stop()
        end, 110)
   end
    -- At 100 frames, slam down
    if self.user_data.attack_timer < 100 then
        self.y = self.y - 0.14
        -- Once we hit some kind of floor, go back up to 280 for a short cooldown
        if self:can_jump() then
            self.user_data.attack_timer = 280
            -- Slam SFX
            slam(self)
            -- Skulls (intro skulls spawn offset)
            if true then
                -- Find players
                for _, v in ipairs(get_entities_by({0}, MASK.PLAYER, self.layer)) do
                    local char = get_entity(v)
                    local px, py, _ = get_position(v)
                    for i=-1, 1 do 
                        local skull = get_entity(spawn(ENT_TYPE.ITEM_SKULL, px-6+i, 122.5, self.layer, 0, 0))
                        skull.angle = math.random(0, 51)/5
                    end
                    for i=-1, 1 do 
                        local skull = get_entity(spawn(ENT_TYPE.ITEM_SKULL, px+6+i, 122.5, self.layer, 0, 0))
                        skull.angle = math.random(0, 51)/5
                    end
                end
            end
            -- After slamming enter the regular slam state
            self.user_data.state = HAND_STATE.SLAM
        end
   end
end
local function yama_hand_deactivate(self)
    self.animation_frame = ANIMATION_INFO.HAND_IDLE.start
    -- Make it so these hands have no interaction with the game world
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    self.flags = set_flag(self.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    self.flags = clr_flag(self.flags, ENT_FLAG.PICKUPABLE)
    self.flags = clr_flag(self.flags, ENT_FLAG.THROWABLE_OR_KNOCKBACKABLE)
    self.flags = clr_flag(self.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
    -- Timer for fading
    self.user_data.attack_timer = self.user_data.attack_timer - 1
    -- Fire as we fade away
    self.user_data.fireeffect_timer = self.user_data.fireeffect_timer - 1
    if self.user_data.fireeffect_timer == 0 and self.user_data.attack_timer > 110 then
        self.user_data.fireeffect_timer = 4
        create_yama_flame(self.x, self.y, self.layer)
    end
    -- Become transparent
    self.color:set_rgba(255, 255, 255, math.floor(255*self.user_data.attack_timer/240))
    -- Destroy when transparent
    if self.user_data.attack_timer <= 0 then
        self:destroy()
    end
end
local function yama_hand_update(self)
    -- Brick the base entity's AI. We're going full LUA for this!
    self.state = 18
    self.move_state = 0
    self.lock_input_timer = 5
    -- The hand isnt lethal unless otherwise set to
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    -- STATEMACHINE
    local d = self.user_data
    if d.state == HAND_STATE.SLAM then
        hand_slam(self)
    elseif d.state == HAND_STATE.RETURN then
        yama_return(self, HAND_STATE.SLAM)
        self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    elseif d.state == HAND_STATE.MAGMARS then
        hand_magmars(self)
    elseif d.state == HAND_STATE.SWING then
        hand_swing(self)
    elseif d.state == HAND_STATE.DEACTIVATE then
        yama_hand_deactivate(self)
    elseif d.state == HAND_STATE.INTRO_SLAM then
        hand_slam_intro(self)
    end
    -- We need gravity to be able to throw this entity
    if self.overlay ~= nil then
        self.flags = clr_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    else
        self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    end
    -- Override state if we're being held
    if self.overlay ~= nil then
        d.state = HAND_STATE.RETURN
    end
    -- Custom animation
    animate_entity(self)
end
local function yama_hand_set(self)
    self.type = yama_piece
    -- Userdata
    self.user_data = {
        ent_type = HD_ENT_TYPE.MONS_YAMA_HAND;

        -- ANIMATION
        animation_timer = 1;
        animation_frame = 0;
        animation_info = ANIMATION_INFO.HAND_IDLE; -- Info about animation speed, start frame, stop frame
        custom_animation = true; -- When false we let the game handle animations

        -- AI
        state = HAND_STATE.INTRO_SLAM;

        lethal = false; -- When true this will be the hand that summons skulls when smashing

        attack_timer = 365; -- Initially used for the cutscene at the start, so we add extra frames
        fireeffect_timer = 3; -- When 0 creates fx fireballs

        wait = false; -- When true Yama won't perform a slam attack. used to sync the hands together if they ever get moved

        home_x = self.x;
        home_y = self.y;

        left_hand = false;
        other_hand = nil;

        yama = nil;

    };
    -- Set health
    self.health = 10
    -- Custom texture
    self:set_texture(yama_texture_id)
    self.width = 1.8
    self.height = 2.7
    -- Since these bosses are so mechanically similar we're just copying Tiamat's hitboxes
    self.hitboxx = get_type(ENT_TYPE.MONS_TIAMAT).hitboxx*0.9
    self.hitboxy = get_type(ENT_TYPE.MONS_TIAMAT).hitboxy*0.9
    -- Flags
    self.flags = clr_flag(self.flags, ENT_FLAG.CAN_BE_STOMPED)
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    self.flags = set_flag(self.flags, ENT_FLAG.PICKUPABLE)
    self.flags = set_flag(self.flags, ENT_FLAG.THROWABLE_OR_KNOCKBACKABLE)
    self.flags = clr_flag(self.flags, ENT_FLAG.USABLE_ITEM)

    -- Statemachine
    self:set_post_update_state_machine(yama_hand_update)
    -- Animation frame gets overriden on damage
    self:set_post_damage(animate_entity)
    -- Update if one of yama's hands is missing
    self:set_pre_kill(function(self)
        if self.user_data.yama ~= nil then
            if type(self.user_data.yama.user_data) == "table" then
                if self.user_data.yama.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HEAD then
                    self.user_data.yama.user_data.missing_hand = true
                    if self.user_data.left_hand then
                        self.user_data.yama.user_data.left_hand = nil
                    else
                        self.user_data.yama.user_data.right_hand = nil
                    end
                end
            end
        end
        -- We need to make sure the other hand isnt stuck waiting for a now dead hand
        if self.user_data.other_hand ~= nil then
            if type(self.user_data.other_hand.user_data) == "table" then
                if self.user_data.other_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                    self.user_data.other_hand.user_data.wait = false
                end
            end
        end        
    end)
    -- Trick character statemachines into thinking the entity can be picked up (entities with no gravity flagged cant be picked up)
    set_timeout(function()
        for _ , v in ipairs(get_entities_by({}, MASK.PLAYER, LAYER.BOTH)) do
            local char = get_entity(v)
            local real_standing_uid = -1
            char:set_pre_update_state_machine(function()
                real_standing_uid = self.standing_on_uid
                self.standing_on_uid = char.standing_on_uid
            end)
            char:set_post_update_state_machine(function()
                self.standing_on_uid = real_standing_uid
            end)
        end
    end, 1)
end
-- Stop Magmamen from doing the onfire effect
set_post_entity_spawn(function(ent)
    set_pre_collision2(ent.uid, function(col, col2)
        if type(col2.user_data) == "table" then
            if col2.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HEAD or col2.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                return true
            end
        end
    end)
end, SPAWN_TYPE.ANY, 0, {ENT_TYPE.MONS_MAGMAMAN})
------------------------------------
--------- MODULE SETUP -------------
function module.create_yama_head(x, y, l)
    local yama = get_entity(spawn(ENT_TYPE.MONS_AMMIT, x, y, l, 0, 0))
    yama_head_set(yama)
    return yama
end
optionslib.register_entity_spawner("Spawn Yama Head", module.create_yama_head, false)
function module.create_yama_hand(x, y, l)
    local yama = get_entity(spawn(ENT_TYPE.MONS_AMMIT, x, y, l, 0, 0))
    yama_hand_set(yama)
    return yama
end
optionslib.register_entity_spawner("Spawn Yama Hand", module.create_yama_hand, false)

return module

--TODO add a little bob when hes chasing in phase2