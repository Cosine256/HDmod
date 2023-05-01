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
-- Sound effect path
local sfx = create_sound('')
local sfx_volume = 0.25

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
        speed = 6;
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
    IDLE = 1;
    FLY = 2;
    ATTACK = 3;
    EGGPLANT = 4;
}
local HAND_STATE = {
    SLAM = 1;
    SWING = 2;
    OPEN = 3;
    INTRO_SLAM = 4;
}
local function animate_entity(self)
    if self.user_data.custom_animation then
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
end
-- Remove the vanilla yama head and replace it with our own
set_post_entity_spawn(function(self)
    module.create_yama_head(self.x, self.y, self.layer)
    self:destroy()
end, SPAWN_TYPE.ANY, 0, {ENT_TYPE.MONS_YAMA})
------------------------------------
--------- YAMA'S HEAD --------------
local function yama_idle(self)
    -- Update animation
    self.user_data.animation_info = ANIMATION_INFO.HEAD_IDLE
    -- Cutscene --
    if self.user_data.cutscene_timer ~= 0 then
        self.user_data.cutscene_timer = self.user_data.cutscene_timer - 1
        -- Black bars, invincible players
        if self.user_data.cutscene_timer == 799 then
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
        if self.user_data.cutscene_timer < 799 then
            if state.camera.focus_offset_y < 24 then
                state.camera.focus_offset_y = state.camera.focus_offset_y + 0.2 
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
                char.invincibility_frames_timer = 180
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
end
local function yama_head_update(self)
    -- Brick the base entity's AI. We're going full LUA for this!
    self.state = 30
    self.move_state = 30
    self.lock_input_timer = 5
    -- STATEMACHINE
    local d = self.user_data
    if d.state == HEAD_STATE.IDLE then
        yama_idle(self)
    elseif d.state == HEAD_STATE.FLY then
        
    elseif d.state == HEAD_STATE.ATTACK then

    elseif d.state == HEAD_STATE.EGGPLANT then
    end
    -- Custom animation
    animate_entity(self)
end
local function yama_head_set(self)
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
        cutscene_timer = 800; -- Cutscene for Yama is automatically played whenever he's spawned in.
        fireball_timer = 360; -- When 0 Yama will shoot fireballs

        target = nil; -- Points to the entity yama will chase in phase 2

        blackbars = nil; -- Blackbar entity used in the cutscene

        home_x = self.x;
        home_y = self.y;

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
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    self.flags = clr_flag(self.flags, ENT_FLAG.CAN_BE_STOMPED)
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    -- This stops Yama's head from being pushed by shields
    self.more_flags = set_flag(self.more_flags, 4)
    -- Make hands face the appropriate direction
    self.user_data.left_hand.flags = clr_flag(self.user_data.left_hand.flags, ENT_FLAG.FACING_LEFT)
    self.user_data.right_hand.flags = set_flag(self.user_data.right_hand.flags, ENT_FLAG.FACING_LEFT)
    -- Make right hand "lethal" by default
    self.user_data.right_hand.user_data.lethal = true
    -- Because of this, make left hand lethal if right hand dies
    self.user_data.right_hand:set_pre_kill(function()
        if self.user_data.left_hand ~= nil then
            -- Make sure the left hand is still a hand
            if self.user_data.left_hand.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HAND then
                self.user_data.left_hand.user_data.lethal = true
            end
        end
    end)
    -- Set self as the "yama" for these hands
    self.user_data.left_hand.user_data.yama = self
    self.user_data.right_hand.user_data.yama = self
    -- Statemachine
    self:set_post_update_state_machine(yama_head_update)
end
------------------------------------
--------- YAMA'S HANDS -------------
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
local function hand_slam(self)
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
    -- This way if he's started an attack he will complete it instead of just stopping
    if (in_range or self.user_data.attack_timer <= 200) then
       self.user_data.attack_timer = self.user_data.attack_timer - 1
    end
    -- Sequence
    -- Have the hands rise up
    if commonlib.in_range(self.user_data.attack_timer, 100, 200) then
        self.y = self.y + 0.013
   end
    -- At 100 frames, slam down
    if self.user_data.attack_timer < 100 then
        self.y = self.y - 0.14
        -- Once we hit some kind of floor, go back up to 280 for a short cooldown
        if self:can_jump() then
            self.user_data.attack_timer = 280
            -- Slam SFX
            slam(self)
            -- Skulls
            if self.user_data.lethal then
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
    -- At 100 frames, slam down
    if self.user_data.attack_timer < 100 then
        self.y = self.y - 0.14
        -- Once we hit some kind of floor, go back up to 280 for a short cooldown
        if self:can_jump() then
            self.user_data.attack_timer = 280
            -- Slam SFX
            slam(self)
            -- Skulls (intro skulls spawn offset)
            if self.user_data.lethal then
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
local function yama_hand_update(self)
    -- Brick the base entity's AI. We're going full LUA for this!
    self.state = 30
    self.move_state = 30
    self.lock_input_timer = 5
    -- Because of how Yama's hands are on the texture sheet we need to shift them up a bit
    self.rendering_info.y = self.rendering_info.y-0.5
    -- STATEMACHINE
    local d = self.user_data
    if d.state == HAND_STATE.SLAM then
        hand_slam(self)
    elseif d.state == HAND_STATE.SWING then
    elseif d.state == HAND_STATE.OPEN then
    elseif d.state == HAND_STATE.INTRO_SLAM then
        hand_slam_intro(self)
    end
    -- Custom animation
    animate_entity(self)
end
local function yama_hand_set(self)
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
        home_x = 0;
        home_y = 0;

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
    self.flags = set_flag(self.flags, ENT_FLAG.NO_GRAVITY)
    self.flags = clr_flag(self.flags, ENT_FLAG.CAN_BE_STOMPED)
    self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    self:set_post_update_state_machine(yama_hand_update)
end
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
optionslib.register_entity_spawner("Spawn Yama Head", module.create_yama_hand, false)

return module