local module = {}

local camel_texture_id
local cannon_texture_id
do
	local camel_texture_def = TextureDefinition.new()
    camel_texture_def.width = 2048
    camel_texture_def.height = 768
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

--[[ # TODO: Credits mode:
    Auto walks in one direction until the player presses a button
    Upon pressing any button, a laser gun pops out of the saddle, starting a minigame.
    During the minigame the camel acts like the camel in metal slug;
        - Always faces left, even when the player moves right.
        - Can jump
        - Moving to the left/right alters the angle of the laser gun
        - Cannot dismount
        - Cannot crouch
]]

local function set_dimensions(ent)
    ent.offsety = -0.335
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
    end
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_update_credits(ent)
    camel_update(ent)
    -- Force facing one direction
    set_entity_flags(ent.uid, set_flag(get_entity_flags(ent.uid), ENT_FLAG.FACING_LEFT))
    if ent.rider_uid ~= -1 then
        set_entity_flags(ent.rider_uid, set_flag(get_entity_flags(ent.rider_uid), ENT_FLAG.FACING_LEFT))
        local rider = get_entity(ent.rider_uid)
        rider.x = math.abs(rider.x)

        -- upon any input from the rider, set to transition to minigame
    end


    local cannon = get_entity(ent.user_data.cannon_uid)

    cannon.animation_frame = 1

    -- if ent.user_data.state ~= CAMEL_STATE.PRE_MINIGAME and test_flag(cannon.flags, ENT_FLAG.INVISIBLE) then
    --     cannon.flags = clr_flag(cannon.flags, ENT_FLAG.INVISIBLE)
    -- end
end

---@param ent Entity | Movable
local function cannon_set(ent)
    ent:set_texture(cannon_texture_id)
    ent:set_draw_depth(23)
    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    -- ent.flags = set_flag(ent.flags, ENT_FLAG.INVISIBLE)
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
            cannon_uid = cannon_uid
        }
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