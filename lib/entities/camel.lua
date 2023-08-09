local animationlib = require('lib.entities.animation')
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

local CAMEL_STATE <const> = {
    PRE_MINIGAME = 0,
    TRANSITION_TO_MINIGAME = 1,
    MINIGAME = 2
}
local CANNON_ANIMATIONS <const> = {
  STARTUP = {0, loop = false, frames = 1, frame_time = 60},
  IDLE = {1, loop = true, frames = 1, frame_time = 4}
}

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
]]

local function set_dimensions(ent)
    ent.offsety = -0.435
    ent.width, ent.height = 2, 2
    ent.hitboxx, ent.hitboxy = 0.65, 0.585
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_update(ent)
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

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_update_credits(ent)
    camel_update(ent)
    -- Force facing one direction
    set_entity_flags(ent.uid, set_flag(get_entity_flags(ent.uid), ENT_FLAG.FACING_LEFT))

    local cannon = get_entity(ent.user_data.cannon_uid)

    if ent.rider_uid ~= -1 then
        -- force rider to face left
        set_entity_flags(ent.rider_uid, set_flag(get_entity_flags(ent.rider_uid), ENT_FLAG.FACING_LEFT))
        local rider = get_entity(ent.rider_uid)
        rider.x = math.abs(rider.x)


        -- upon any input from the rider, set to transition to minigame
        local input = read_input(rider.uid)
        if ent.user_data.state == CAMEL_STATE.PRE_MINIGAME then
            if (
                test_flag(input, INPUT_FLAG.WHIP)
                -- or test_flag(input, INPUT_FLAG.JUMP)
                -- or test_flag(input, INPUT_FLAG.BOMB)
                -- or test_flag(input, INPUT_FLAG.ROPE)
                -- or test_flag(input, INPUT_FLAG.LEFT)
                -- or test_flag(input, INPUT_FLAG.RIGHT)
                -- or test_flag(input, INPUT_FLAG.UP)
                -- or test_flag(input, INPUT_FLAG.DOWN)
            ) then
                cannon.flags = clr_flag(cannon.flags, ENT_FLAG.INVISIBLE)
                ent.user_data.state = CAMEL_STATE.TRANSITION_TO_MINIGAME
                animationlib.set_animation(ent.user_data, CANNON_ANIMATIONS.STARTUP)
            end
        elseif ent.user_data.state == CAMEL_STATE.TRANSITION_TO_MINIGAME
            and ent.user_data.animation_timer == 0
        then
            ent.user_data.state = CAMEL_STATE.MINIGAME
            animationlib.set_animation(ent.user_data, CANNON_ANIMATIONS.IDLE)
        elseif ent.user_data.state == CAMEL_STATE.MINIGAME
        then
            -- # TODO: Cannon firing and angling
        end

        cannon.animation_frame = animationlib.get_animation_frame(ent.user_data)
        animationlib.update_timer(ent.user_data)
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
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_set(ent, cannon_uid)
    local cannon_uid = cannon_uid or -1
    ent:set_texture(camel_texture_id)
    set_dimensions(ent)
    ent:tame(true)
    -- animationlib.set_animation(ent.user_data, ANIMATIONS.IDLE)
    if cannon_uid ~= -1 then
        set_entity_flags(ent.uid, set_flag(get_entity_flags(ent.uid), ENT_FLAG.FACING_LEFT))
        ent.user_data = {
            state = CAMEL_STATE.PRE_MINIGAME,
            cannon_uid = cannon_uid,
            animation_state = CANNON_ANIMATIONS.IDLE,
            animation_timer = 0,
        }
        animationlib.set_animation(ent.user_data, CANNON_ANIMATIONS.IDLE)
    end
    set_post_statemachine(ent.uid, cannon_uid ~= -1 and camel_update_credits or camel_update)
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
end

optionslib.register_entity_spawner("Camel Intro", module.create_camel)
optionslib.register_entity_spawner("Camel Credits", module.create_camel_credits)

return module