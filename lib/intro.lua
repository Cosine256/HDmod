local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local module = {}

local TIMEOUT_GENERAL = 65
local TIMEOUT_PRE_ENTRANCE = 120

local GUY_WALKING_STATE
local GUY_WALKING <const> = {
    PRE_LAND = 0,
    LAND_STANDING = 1,
    WALKING_POST_LAND = 2,
    PETTING = 3,
    WALKING_POST_PET = 4
}

---@type Entity | Movable | Player
local guy
---@type Rockdog | Mount | Entity | Movable | PowerupCapable
local camel

set_callback(function()
    surfacelib.decorate_existing_surface()

    camel = get_entity(camellib.create_camel(7, 100, LAYER.FRONT))
    spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)

    guy = get_entity(spawn_entity(ENT_TYPE.CHAR_GUY_SPELUNKY, 7, 100, LAYER.FRONT, 0, 0))--x = 16
    spawn_entity_over(ENT_TYPE.FX_SHADOW, guy.uid, 0, 0)
    carry(camel.uid, guy.uid)

    state.camera.focused_entity_uid = guy.uid

    local pre_entrance_timeout = TIMEOUT_PRE_ENTRANCE
    local dismount_timeout = TIMEOUT_GENERAL
    -- Traditional inputs don't seem to be working in the intro
    set_post_statemachine(camel.uid, function (ent)
        if pre_entrance_timeout > 0 then
            pre_entrance_timeout = pre_entrance_timeout - 1
        elseif ent.x < 25 then
            -- This appears to animate guy as well.
            ent.velocityx = 0.072--0.105 is ana's intro walking speed
        elseif dismount_timeout > 0 then
            dismount_timeout = dismount_timeout - 1
            -- message(string.format('dismount_timeout: %s', dismount_timeout))
        else
            ent:remove_rider()
        end
    end)

    local post_dismount_timeout = TIMEOUT_GENERAL
    GUY_WALKING_STATE = GUY_WALKING.PRE_LAND
    set_post_statemachine(guy.uid, function (ent)
        if GUY_WALKING_STATE == GUY_WALKING.PRE_LAND
        and ent.standing_on_uid ~= -1 then
            GUY_WALKING_STATE = GUY_WALKING.LAND_STANDING
            post_dismount_timeout = TIMEOUT_GENERAL
        end
        if GUY_WALKING_STATE == GUY_WALKING.LAND_STANDING then
            if post_dismount_timeout > 0 then
                post_dismount_timeout = post_dismount_timeout - 1
                -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
            else
                GUY_WALKING_STATE = GUY_WALKING.WALKING_POST_LAND
                post_dismount_timeout = TIMEOUT_GENERAL
            end
        end
        if GUY_WALKING_STATE == GUY_WALKING.WALKING_POST_LAND then
            --until position is less than a tile over from the camel, walk right
            local cx, _, _ = get_position(camel.uid)
            if ent.x < cx+1.1 then
                ent.velocityx = 0.072
            else
                --turn, set petting state
                GUY_WALKING_STATE = GUY_WALKING.PETTING
                guy.flags = set_flag(guy.flags, ENT_FLAG.FACING_LEFT)
                -- ---@type Movable
                -- local guy
                guy:set_behavior(25)
                post_dismount_timeout = TIMEOUT_GENERAL
            end
        end
        if GUY_WALKING_STATE == GUY_WALKING.PETTING then
            --pet camel and timeout
            if post_dismount_timeout > 0 then
                post_dismount_timeout = post_dismount_timeout - 1
                -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
            else
                --pet camel, set petting state
                GUY_WALKING_STATE = GUY_WALKING.WALKING_POST_PET
                guy.flags = clr_flag(guy.flags, ENT_FLAG.FACING_LEFT)
                guy:set_behavior(1)
                post_dismount_timeout = TIMEOUT_GENERAL
            end
        end
        if GUY_WALKING_STATE == GUY_WALKING.WALKING_POST_PET then
            if post_dismount_timeout > 0 then
                post_dismount_timeout = post_dismount_timeout - 1
                -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
            elseif ent.x < 54 then
                -- This appears to animate guy as well.
                ent.velocityx = 0.072--0.105 is ana's intro walking speed
            end
        end
    end)
end, ON.INTRO)

return module