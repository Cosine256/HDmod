local module = {}

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
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_update_credits(ent)
    camel_update(ent)
    -- Force facing one direction?
    set_entity_flags(ent.uid, set_flag(get_entity_flags(ent.uid), ENT_FLAG.FACING_LEFT))
end

---@param ent Rockdog | Mount | Entity | Movable | PowerupCapable
local function camel_set(ent, credits)
    local credits = credits or false
    -- ent:set_texture(texture_id)
    set_dimensions(ent)
    ent:tame(true)
    -- animationlib.set_animation(ent.user_data, ANIMATIONS.IDLE)
    if credits then
        set_entity_flags(ent.uid, set_flag(get_entity_flags(ent.uid), ENT_FLAG.FACING_LEFT))
    end
    set_post_statemachine(ent.uid, credits and camel_update_credits or camel_update)

end

function module.create_camel(x, y, layer)
    local uid = spawn_entity_snapped_to_floor(ENT_TYPE.MOUNT_ROCKDOG, x, y, layer)
    camel_set(get_entity(uid))
    return uid
end

function module.create_camel_credits(x, y, layer)
    local uid = spawn_entity_snapped_to_floor(ENT_TYPE.MOUNT_ROCKDOG, x, y, layer)
    camel_set(get_entity(uid), true)
end

optionslib.register_entity_spawner("Camel Intro", module.create_camel)
optionslib.register_entity_spawner("Camel Credits", module.create_camel_credits)

return module