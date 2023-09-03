local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local animationlib = require('lib.entities.animation')
local module = {}

local intro_timeout
local TIMEOUT_GENERAL = 65
local TIMEOUT_PRE_ENTRANCE = 120

local GUY_WALKS_STATE
local GUY_WALKS <const> = {--Haha. Guy Fawkes.
    PRE_DISMOUNT = 0,
    DISMOUNT = 1,
    LAND_STANDING = 2,
    WALKING_POST_LAND = 3,
    PETTING = 4,
    WALKING_POST_PET = 5
}

local GUY_ANIMATIONS = {
    -- PET = {90, 89, 88, 87, 86, 85, 84, 83, 82, 81, loop = true, frames = 10, frame_time = 4}
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
    intro_timeout = TIMEOUT_GENERAL
    -- Traditional inputs don't seem to be working in the intro
    set_post_statemachine(camel.uid, function (ent)
        if pre_entrance_timeout > 0 then
            pre_entrance_timeout = pre_entrance_timeout - 1
        elseif ent.x < 25 then
            -- This appears to animate guy as well.
            ent.velocityx = 0.072--0.105 is ana's intro walking speed
        elseif intro_timeout > 0 then
            intro_timeout = intro_timeout - 1
            -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
        elseif GUY_WALKS_STATE == GUY_WALKS.PRE_DISMOUNT then
            GUY_WALKS_STATE = GUY_WALKS.DISMOUNT
            intro_timeout = 65--TIMEOUT_GENERAL
            -- guy.last_state = guy.state
            -- guy.state = 5
            -- guy:set_behavior(5)
            ent.last_state = 1--ent.state
            ent.state = 5
            ent:set_behavior(5)
            message("DISMOUNT")
        end
    end)

    GUY_WALKS_STATE = GUY_WALKS.PRE_DISMOUNT
    set_post_statemachine(guy.uid, function (ent)
        if GUY_WALKS_STATE == GUY_WALKS.DISMOUNT then
            if intro_timeout > 0 then
                intro_timeout = intro_timeout - 1
                -- message(string.format('intro_timeout: %s', intro_timeout))
            end
            -- if intro_timeout == 20 then
            --     camel:remove_rider()
            --     message("REMOVE RIDER")
            -- end
            if intro_timeout <= 20 then
                -- ent.last_state = ent.state
                -- ent.state = 1
                -- ent:set_behavior(1)
                -- message("GUY CROUCHING")
            end

            if ent.standing_on_uid ~= -1 then
                -- This Works
                GUY_WALKS_STATE = GUY_WALKS.LAND_STANDING
                intro_timeout = TIMEOUT_GENERAL
                camel.last_state = camel.state
                camel.state = 1
                camel:set_behavior(1)
                message("LANDED")
            else
                -- ent.last_state = 2
                -- ent.state = 5
                -- ent:set_behavior(5)
                camel.last_state = 1
                camel.state = 5
                camel:set_behavior(5)
                message("CAMEL CROUCHING")
            end
            
        end
        if GUY_WALKS_STATE == GUY_WALKS.LAND_STANDING then
            if intro_timeout > 0 then
                intro_timeout = intro_timeout - 1
                -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
            else
                GUY_WALKS_STATE = GUY_WALKS.WALKING_POST_LAND
                intro_timeout = TIMEOUT_GENERAL
            end
        end
        if GUY_WALKS_STATE == GUY_WALKS.WALKING_POST_LAND then
            --until position is less than a tile over from the camel, walk right
            local cx, _, _ = get_position(camel.uid)
            if ent.x < cx+1.1 then
                ent.velocityx = 0.072
            else
                --turn, set petting state
                GUY_WALKS_STATE = GUY_WALKS.PETTING
                guy.flags = set_flag(guy.flags, ENT_FLAG.FACING_LEFT)
                -- ---@type Movable
                -- local guy
                intro_timeout = 100
            end
        end
        if GUY_WALKS_STATE == GUY_WALKS.PETTING then
            --pet camel and timeout
            if intro_timeout > 0 then
                intro_timeout = intro_timeout - 1
                -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
            else
                --pet camel, set petting state
                GUY_WALKS_STATE = GUY_WALKS.WALKING_POST_PET
                guy.flags = clr_flag(guy.flags, ENT_FLAG.FACING_LEFT)
                intro_timeout = TIMEOUT_GENERAL
            end
        end
        if GUY_WALKS_STATE == GUY_WALKS.WALKING_POST_PET then
            if intro_timeout > 0 then
                intro_timeout = intro_timeout - 1
                -- message(string.format('post_dismount_timeout: %s', post_dismount_timeout))
            elseif ent.x < 54 then
                -- This appears to animate guy as well.
                ent.velocityx = 0.072--0.105 is ana's intro walking speed
            end
        end
    end)
end, ON.INTRO)

return module