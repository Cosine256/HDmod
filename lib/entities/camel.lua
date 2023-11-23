local animationlib = require('lib.entities.animation')
local minigamelib = require('lib.entities.minigame')
local decorlib = require('lib.gen.decor')
local introanimationslib = require('lib.introanimations')

local module = {}

local camel_texture_id
local cannon_texture_id
do
	local camel_texture_def = TextureDefinition.new()
    camel_texture_def.width = 2048
    camel_texture_def.height = 1024
    camel_texture_def.tile_width = 256
    camel_texture_def.tile_height = 256
	camel_texture_def.texture_path = "res/camel.png"
	camel_texture_id = define_texture(camel_texture_def)

	local cannon_texture_def = TextureDefinition.new()
    cannon_texture_def.width = 256
    cannon_texture_def.height = 128
    cannon_texture_def.tile_width = 128
    cannon_texture_def.tile_height = 128
	cannon_texture_def.texture_path = "res/camel_cannon.png"
	cannon_texture_id = define_texture(cannon_texture_def)
end

local cannon_sound_fire = create_sound('res/sounds/camel_cannon_shoot.wav')
local idle_sound = {
    create_sound('res/sounds/camel1.wav'),
    create_sound('res/sounds/camel2.wav'),
    create_sound('res/sounds/camel3.wav'),
    create_sound('res/sounds/camel4.wav'),
    create_sound('res/sounds/camel5.wav'),
    create_sound('res/sounds/camel6.wav'),
    create_sound('res/sounds/camel7.wav'),
    create_sound('res/sounds/camel8.wav')
}

local TIMEOUT_GENERAL = 65
local TIMEOUT_PRE_ENTRANCE = 120

local MINIGAME_STATE <const> = {
    WALK_IN = 0,
    PRE_MINIGAME = 1,
    TRANSITION_TO_MINIGAME = 2,
    MINIGAME = 3
}
local CAMEL_WALKING_STATE <const> = {
    NOT_FAKE_WALKING = 0,
    FAKE_WALKING = 1
}

local CAMEL_ANIMATIONS <const> = {
    CROUCH_ENTER = {19, 18, 17, loop = false, frames = 3, frame_time = 6},
    NOT_FAKE_WALKING = {0, loop = false, frames = 1, frame_time = 4},
    FAKE_WALKING = {8, 7, 6, 5, 4, 3, 2, 1, loop = true, frames = 8, frame_time = 6},
    PET = {30, loop = true, frames = 1, frame_time = 4},
    PET_END = {29, loop = false, frames = 1, frame_time = 4},
}
local CANNON_ANIMATIONS <const> = {
  STARTUP = {0, loop = false, frames = 1, frame_time = 60},
  IDLE = {1, loop = true, frames = 1, frame_time = 4}
}

local TURN_RATE = 0.05

--[[ # TODO: Credits mode:
    Auto walks in one direction until the player presses a button
    Upon pressing any button, a laser cannon pops out of the saddle, starting a minigame.
    During the minigame the camel acts like the camel in metal slug;
        - Always faces left, even when the player moves right.
        - Can jump
        - Inputting left/up/right/down alters the angle of the laser cannon
        - Inputting whip fires the laser cannon
        - Cannot use bombs or ropes
        - Cannot dismount
        -- Player offset needs to be:
        -- -0.45, 0.80
]]

local function set_dimensions(ent)
    local facing_left = test_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    ent.offsety = -0.335
    ent.offsetx = 0.1*(facing_left and 1 or -1)
    ent.width, ent.height = 2, 2
    ent.hitboxx, ent.hitboxy = 0.65, 0.585

    if ent.rider_uid ~= -1 then
        local rider = get_entity(ent.rider_uid)
        rider.y = 0.80
        rider.x = -0.45
        -- message(string.format("rider: %s, %s", rider.x, rider.y))
        if facing_left then
            rider.x = math.abs(rider.x)
        end
    end
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_post_update(ent)
    set_dimensions(ent)
    -- prevent vanilla behaviors
    ent.attack_cooldown = 10
    ent.can_doublejump = false

    if ent.animation_frame == 64 then
        ent.animation_frame = 0
    elseif ent.animation_frame == 65 then
        ent.animation_frame = 1
    elseif ent.animation_frame == 66 then
        ent.animation_frame = 2
    elseif ent.animation_frame == 67 then
        ent.animation_frame = 3
    elseif ent.animation_frame == 68 then
        ent.animation_frame = 4
    elseif ent.animation_frame == 69 then
        ent.animation_frame = 5
    elseif ent.animation_frame == 70 then
        ent.animation_frame = 6
    elseif ent.animation_frame == 71 then
        ent.animation_frame = 7
    elseif ent.animation_frame == 72 then
        ent.animation_frame = 8
    elseif ent.animation_frame == 118 then
        ent.animation_frame = 9
    elseif ent.animation_frame == 119 then
        ent.animation_frame = 10
    elseif ent.animation_frame == 120 then
        ent.animation_frame = 11
    elseif ent.animation_frame == 121 then
        ent.animation_frame = 12
    elseif ent.animation_frame == 122 then
        ent.animation_frame = 13
    elseif ent.animation_frame == 123 then
        ent.animation_frame = 14
    elseif ent.animation_frame == 124 then
        ent.animation_frame = 15
    elseif ent.animation_frame == 125 then
        ent.animation_frame = 16
    elseif ent.animation_frame == 80 then
        ent.animation_frame = 17
    elseif ent.animation_frame == 81 then
        ent.animation_frame = 18
    elseif ent.animation_frame == 82 then
        ent.animation_frame = 19
    elseif ent.animation_frame == 83 then
        ent.animation_frame = 20
    elseif ent.animation_frame == 84 then
        ent.animation_frame = 21
    elseif ent.animation_frame == 85 then
        ent.animation_frame = 22
    elseif ent.animation_frame == 86 then
        ent.animation_frame = 23
    elseif ent.animation_frame == 87 then
        ent.animation_frame = 24
    elseif ent.animation_frame == 88 then
        ent.animation_frame = 25
    elseif ent.animation_frame == 89 then
        ent.animation_frame = 26
    elseif ent.animation_frame == 90 then
        ent.animation_frame = 27
    elseif ent.animation_frame == 91 then
        ent.animation_frame = 28
    end
end

function module.set_camel_intro_walk_in(camel, _guy_uid)
    camel.user_data.state = introanimationslib.INTRO_STATE.WALKING
    camel.user_data.animation_timer = 0
    camel.user_data.timeout = TIMEOUT_PRE_ENTRANCE
    camel.user_data.guy_uid = _guy_uid
end

---@param camel Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_post_update_intro(camel)
    camel_post_update(camel)
    -- Traditional inputs and a few other things don't seem to be working in the intro,
    -- so we must work around it by custom animating both guy and the camel.
    if camel.user_data.state == introanimationslib.INTRO_STATE.WALKING then
        if camel.user_data.timeout > 0 then
            camel.user_data.timeout = camel.user_data.timeout - 1
        elseif camel.x < 25 then
            -- This appears to animate guy as well.
            camel.velocityx = 0.072--0.105 is ana's intro walking speed
        else
            camel.user_data.state = introanimationslib.INTRO_STATE.PRE_CROUCH
            camel.user_data.timeout = TIMEOUT_GENERAL
        end
    elseif camel.user_data.state == introanimationslib.INTRO_STATE.PRE_CROUCH then
        if camel.user_data.timeout > 0 then
            camel.user_data.timeout = camel.user_data.timeout - 1
        else
            camel.user_data.state = introanimationslib.INTRO_STATE.CROUCH_ENTER
            animationlib.set_animation(camel.user_data, CAMEL_ANIMATIONS.CROUCH_ENTER)
            -- message("SET CROUCH_ENTER")
            introanimationslib.set_crouching(get_entity(camel.user_data.guy_uid))
        end
    elseif camel.user_data.state == introanimationslib.INTRO_STATE.CROUCH_ENTER then
        if camel.user_data.animation_timer == 0 then -- if animation finished
            camel.user_data.state = introanimationslib.INTRO_STATE.CROUCHING
            animationlib.set_animation(camel.user_data, introanimationslib.CAMEL_ANIMATIONS.CROUCHING)
            -- message("SET CROUCHING")
        end
        camel.animation_frame = animationlib.get_animation_frame(camel.user_data)
        animationlib.update_timer(camel.user_data)
    elseif camel.user_data.state == introanimationslib.INTRO_STATE.CROUCHING then
        camel.animation_frame = animationlib.get_animation_frame(camel.user_data)
        animationlib.update_timer(camel.user_data)
    elseif camel.user_data.state == introanimationslib.INTRO_STATE.PETTING then
        if camel.user_data.animation_state == introanimationslib.CAMEL_ANIMATIONS.PET_START
        and camel.user_data.animation_timer == 0 then
            animationlib.set_animation(camel.user_data, CAMEL_ANIMATIONS.PET)
            commonlib.play_custom_sound(idle_sound[prng:random_index(#idle_sound, PRNG_CLASS.FX)], camel.uid, 0.65, false)
        end
        if camel.user_data.animation_state == CAMEL_ANIMATIONS.PET then
            --recieve pet and timeout
            if camel.user_data.timeout > 0 then
                camel.user_data.timeout = camel.user_data.timeout - 1
            else
                animationlib.set_animation(camel.user_data, CAMEL_ANIMATIONS.PET_END)
            end
        end
        if camel.user_data.animation_state == CAMEL_ANIMATIONS.PET_END
        and camel.user_data.animation_timer == 0 then
            camel.user_data.state = introanimationslib.INTRO_STATE.CROUCHING
            animationlib.set_animation(camel.user_data, introanimationslib.CAMEL_ANIMATIONS.CROUCHING)
        end
        camel.animation_frame = animationlib.get_animation_frame(camel.user_data)
        animationlib.update_timer(camel.user_data)
    elseif camel.user_data.state == introanimationslib.INTRO_STATE.IDLE then
        --SORRY NOTHING
        --This state is here for testing purposes;
        --Use this state outside of the cutscene or the minigame (places where we continuously animate it).
    elseif camel.user_data.state == introanimationslib.INTRO_STATE.CROUCH_NOISES then
        if camel.user_data.timeout > 0 then
            camel.user_data.timeout = camel.user_data.timeout - 1
        else
            commonlib.play_custom_sound(idle_sound[prng:random_index(#idle_sound, PRNG_CLASS.FX)], camel.uid, 0.65, false)
            camel.user_data.timeout = 400
        end
        camel.animation_frame = animationlib.get_animation_frame(camel.user_data)
        animationlib.update_timer(camel.user_data)
    end
    -- if camel.user_data.state ~= introanimationslib.INTRO_STATE.WALKING
    -- and camel.user_data.state ~= introanimationslib.INTRO_STATE.IDLE then
    --     message(string.format("timer & frame: %s, %s", camel.user_data.animation_timer, camel.animation_frame))
    -- end
end

-- create a bullet with velocity in relation to the angle of the cannon
local function shoot_gun(ent, rider_uid)
    --[[left
        angle: 0
        velx:-0.35
        curcos: -1
        cursin: 0
    ]]
    --[[left-up
        angle: -0.7853981633975
        curcos: -0.5
        cursin: 0.5
    ]]
    --[[up
        angle: -1.570796326795
        curcos: 0
        cursin: 1
    ]]
    --[[right
        angle: -3.14159265359
    ]]
    --[[down
        angle: 1.570796326795 or -4.712388980385
    ]]
    local gap = 0.5--1
    local vel_magnitude = 0.3

    local x, y, l = get_position(ent.uid)
    local x_i, y_i = -1*math.cos(ent.angle), -1*math.sin(ent.angle)
    -- message(string.format("cos: %s, sin: %s, ang: %s", x_i, y_i, ent.angle))
    local projectile = get_entity(spawn(ENT_TYPE.ITEM_LASERTRAP_SHOT, x+(gap*x_i), y+(gap*y_i), l, vel_magnitude*x_i, vel_magnitude*y_i))
    projectile.angle = ent.angle
    projectile.last_owner_uid = rider_uid
    commonlib.play_custom_sound(cannon_sound_fire, ent.uid, 1, false)
end

---camel
---@param camel Rockdog | Mount | Entity | Movable | PowerupCapable
function module.set_camel_credits_walk_in(camel, spawn_x)
    camel.user_data.state = MINIGAME_STATE.WALK_IN
    camel.user_data.bounds_min = 5
    camel.user_data.bounds_max = 23
    camel.user_data.spawn_x = spawn_x
end
---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_post_update_credits(ent)
    camel_post_update(ent)
    -- Force facing one direction
    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)

    local cannon = get_entity(ent.user_data.cannon_uid)

    if ent.rider_uid ~= -1 then
        -- force rider to face left
        local rider = get_entity(ent.rider_uid)
        rider.flags = set_flag(rider.flags, ENT_FLAG.FACING_LEFT)
        rider.x = math.abs(rider.x)

        local x, _, _ = get_position(ent.uid)
        if ent.user_data.state == MINIGAME_STATE.WALK_IN then
            if x < (ent.user_data.spawn_x - 10.5) then
                ent.user_data.state = MINIGAME_STATE.PRE_MINIGAME
                decorlib.CREDITS_SCROLLING = true
            else
                ent.velocityx = -0.072
            end
        elseif ent.user_data.state == MINIGAME_STATE.MINIGAME
        and ent.user_data.bounds_min
        and ent.user_data.bounds_max then
            -- Prevent moving beyond set bounds
            if x <= ent.user_data.bounds_min
            and ent.velocityx < 0 then
                ent.velocityx = 0
                ent.x = ent.user_data.bounds_min
            elseif x >= ent.user_data.bounds_max
            and ent.velocityx > 0 then
                ent.velocityx = 0
                ent.x = ent.user_data.bounds_max
            end
        end

        --when not moving, use custom animations to animate it fake walking.
        if ent.standing_on_uid ~= 0
        and ent.velocityx == 0
        then
            if ent.user_data.walking_state ~= CAMEL_WALKING_STATE.FAKE_WALKING then
                ent.user_data.walking_state = CAMEL_WALKING_STATE.FAKE_WALKING
                animationlib.set_animation(ent.user_data, CAMEL_ANIMATIONS.FAKE_WALKING)
            end
        else
            ent.user_data.walking_state = CAMEL_WALKING_STATE.NOT_FAKE_WALKING
        end

        if ent.user_data.walking_state ~= CAMEL_WALKING_STATE.NOT_FAKE_WALKING then
            ent.animation_frame = animationlib.get_animation_frame(ent.user_data)
            -- message(string.format("timer: %s", ent.user_data.animation_timer))
            if ent.user_data.animation_timer == 1 then
                -- message("CLOP")
                commonlib.play_vanilla_sound(VANILLA_SOUND.MOUNTS_WILDDOG_WALK, ent.uid, 1, false)
            end
            animationlib.update_timer(ent.user_data)
        end

        cannon.animation_frame = animationlib.get_animation_frame(cannon.user_data)
        animationlib.update_timer(cannon.user_data)
        -- message(string.format("animation_timer: %s", ent.user_data.animation_timer))
    end

    if ent.animation_frame == 17
    or ent.animation_frame == 21
    then
        cannon.y = 0.00
    elseif ent.animation_frame == 18
    or ent.animation_frame == 20
    then
        cannon.y = -0.1
    elseif ent.animation_frame == 19
    or (
        ent.animation_frame >= 22
        and ent.animation_frame <= 28
    )
    then
        cannon.y = -0.15
    else
        cannon.y = 0.05
    end
    --low: 17 or 21
    --lower: 18 or 20
    --lowest: 19 or 22..28
end

---@param ent Entity | Movable
local function cannon_set(ent)
    ent:set_texture(cannon_texture_id)
    ent:set_draw_depth(23)
    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    ent.flags = set_flag(ent.flags, ENT_FLAG.INVISIBLE)
    ent.flags = set_flag(ent.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    ent.user_data = {
        animation_state = CANNON_ANIMATIONS.IDLE,
        animation_timer = 0,
        cannon_timer = 0,
    }
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_set(ent, cannon_uid)
    local cannon_uid = cannon_uid or -1
    ent:set_texture(camel_texture_id)
    set_dimensions(ent)
    ent:tame(true)
    ent.flags = set_flag(ent.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    -- animationlib.set_animation(ent.user_data, ANIMATIONS.IDLE)
    if cannon_uid ~= -1 then
        ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
        ent.user_data = {
            state = MINIGAME_STATE.PRE_MINIGAME,
            walking_state = CAMEL_WALKING_STATE.NOT_FAKE_WALKING,
            cannon_uid = cannon_uid,
            -- animation_state = CAMEL_ANIMATIONS.NOT_FAKE_WALKING,
            animation_timer = 0,
            score = 0
        }
        animationlib.set_animation(get_entity(cannon_uid).user_data, CANNON_ANIMATIONS.IDLE)

        local cannon = get_entity(cannon_uid)
        local cb = set_callback(function ()
            if state.pause == 0
            and ent and ent.rider_uid ~= -1 then
                ---@type Player
                local player = get_entity(ent.rider_uid):as_player()

                -- grab input for the cannon prior to canceling inputs for the camel
                local input = player.input.buttons_gameplay
                -- Prevent crouching
                player.input.buttons_gameplay = clr_mask(player.input.buttons_gameplay, INPUTS.DOWN)
                -- Prevent dismounting
                -- if holding up, clear jump input
                if test_mask(player.input.buttons_gameplay, INPUTS.UP) then
                    player.input.buttons_gameplay = clr_mask(player.input.buttons_gameplay, INPUTS.JUMP)
                end

                if ent.user_data.state == MINIGAME_STATE.PRE_MINIGAME then
                    if (
                        test_flag(input, INPUT_FLAG.LEFT)
                        or test_flag(input, INPUT_FLAG.RIGHT)
                        or test_flag(input, INPUT_FLAG.UP)
                        or test_flag(input, INPUT_FLAG.DOWN)
                        or test_flag(input, INPUT_FLAG.JUMP)
                        or test_flag(input, INPUT_FLAG.WHIP)
                    ) then
                        cannon.flags = clr_flag(cannon.flags, ENT_FLAG.INVISIBLE)
                        ent.user_data.state = MINIGAME_STATE.TRANSITION_TO_MINIGAME
                        animationlib.set_animation(cannon.user_data, CANNON_ANIMATIONS.STARTUP)
                        minigamelib.start_minigame()
                    end
                elseif ent.user_data.state == MINIGAME_STATE.TRANSITION_TO_MINIGAME
                    and cannon.user_data.animation_timer == 0
                then
                    ent.user_data.state = MINIGAME_STATE.MINIGAME
                    animationlib.set_animation(cannon.user_data, CANNON_ANIMATIONS.IDLE)
                    player.more_flags = clr_flag(player.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
                elseif ent.user_data.state == MINIGAME_STATE.MINIGAME then
                    if cannon.user_data.cannon_timer > 0 then
                        cannon.user_data.cannon_timer = cannon.user_data.cannon_timer - 1
                    end

                    -- # TODO: Improve Cannon firing and angling.
                    -- Angles: (depending on the current angle of the turret, add or subtract degrees)
                    -- When input:
                    -- left, angle cannon until left
                    -- left and up, angle cannon until left up
                    -- up, angle cannon until up
                    -- right, angle cannon until right
                    -- right and down, angle cannon right
                    -- down, angle cannon down
                    -- down and left, angle cannon down left

                    if test_flag(input, INPUT_FLAG.RIGHT)
                    and cannon.angle > -math.pi
                    then
                        cannon.angle = cannon.angle - TURN_RATE
                    end
                    if test_flag(input, INPUT_FLAG.LEFT)
                    and cannon.angle < 0
                    then
                        cannon.angle = cannon.angle + TURN_RATE
                    end
                    --if input up
                    -- and angle ~= -1.570796326795 --(not up)
                        --if angle > -4.712388980385 --(larger than down)
                        -- and angle < -1.570796326795 --(less than up)
                            -- increment
                        --elseif angle < 1.570796326795 --(less than down)
                        -- and angle > -1.570796326795 --(larger than up)
                            -- decrement
                    if test_flag(input, INPUT_FLAG.UP)
                    and cannon.angle ~= -1.570796326795 --(not up)
                    then
                        if cannon.angle > -4.712388980385 --(larger than down)
                        and cannon.angle < -1.570796326795 --(less than up)
                        then
                            cannon.angle = cannon.angle + TURN_RATE
                        elseif cannon.angle < 1.570796326795 --(less than down)
                        and cannon.angle > -1.570796326795 --(larger than up)
                        then
                            cannon.angle = cannon.angle - TURN_RATE
                        end
                    end
                    if test_flag(input, INPUT_FLAG.DOWN)
                    and cannon.angle ~= 1.570796326795 --(not down)
                    then
                        if cannon.angle > -1.570796326795 --(larger than up)
                        and cannon.angle < 1.570796326795 --(less than down)
                        then
                            cannon.angle = cannon.angle + TURN_RATE
                        elseif cannon.angle < -1.570796326795 --(less than up)
                        and cannon.angle > -4.712388980385 --(larger than down)
                        then
                            cannon.angle = cannon.angle - TURN_RATE
                        end
                    end

                    -- When input whip, fire the cannon.
                    if test_flag(input, INPUT_FLAG.WHIP) and cannon.user_data.cannon_timer == 0 then
                        shoot_gun(cannon, ent.rider_uid)
                        cannon.user_data.cannon_timer = 10
                    end
                end
            end
        end, ON.PRE_UPDATE)
        ent:set_pre_destroy(function (self)
            clear_callback(cb)
        end)
        set_callback(function()
            clear_callback(cb)
            clear_callback()
        end, ON.POST_ROOM_GENERATION)
    else
        ent.user_data = {
            state = introanimationslib.INTRO_STATE.IDLE,
            animation_timer = 0,
            timeout = 0
        }
    end
    set_post_statemachine(ent.uid, cannon_uid ~= -1 and camel_post_update_credits or camel_post_update_intro)
end

function module.create_camel(x, y, layer)
    local uid = spawn_entity_snapped_to_floor(ENT_TYPE.MOUNT_ROCKDOG, x, y, layer)
    camel_set(get_entity(uid))
    return uid
end

function module.create_camel_credits(x, y, layer)
    local camel = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.MOUNT_ROCKDOG, x, y, layer))
    local cannon = get_entity(spawn_over(ENT_TYPE.ITEM_ROCK, camel.uid, 0.65, 0.05))
    cannon_set(cannon)
    camel_set(camel, cannon.uid)
    return camel.uid
end

optionslib.register_entity_spawner("Camel Intro", module.create_camel)
optionslib.register_entity_spawner("Camel Credits", module.create_camel_credits)

return module