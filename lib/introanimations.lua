local module = {}
local animationlib = require('lib.entities.animation')

module.GUY_WALKS = {--Haha. Guy Fawkes.
    PRE_DISMOUNT = 0,
    SITTING_CROUCH_ENTER = 1,
    DISMOUNTED = 2,
    LAND_UNCROUCH = 3,
    LAND_STANDING = 4,
    WALKING_POST_LAND = 5,
    PETTING = 6,
    WALKING_POST_PET = 7
}

module.INTRO_STATE = {
    WALKING = 0,
    PRE_CROUCH = 1,
    CROUCH_ENTER = 2,
    CROUCHING = 3,
    CROUCH_LEAVE = 4,
    POST_CROUCH = 5,
}

local CAMEL_ANIMATIONS = {
    CROUCH_LEAVE = {21, 20, 19, loop = false, frames = 3, frame_time = 6},
}
local GUY_ANIMATIONS = {
    MOUNTED_CROUCH_ENTER = {124, 123, 122, loop = false, frames = 3, frame_time = 6},
}

---@param guy Entity | Movable | Player
function module.set_crouching(guy)
    guy.user_data.state = module.GUY_WALKS.SITTING_CROUCH_ENTER
    animationlib.set_animation(guy.user_data, GUY_ANIMATIONS.MOUNTED_CROUCH_ENTER)
end

---@param camel Rockdog | Mount | Entity | Movable | PowerupCapable
function module.set_uncrouching(camel)
    camel.user_data.state = module.INTRO_STATE.CROUCH_LEAVE
    animationlib.set_animation(camel.user_data, CAMEL_ANIMATIONS.CROUCH_LEAVE)
    -- message("SET CROUCH_LEAVE")
end

return module