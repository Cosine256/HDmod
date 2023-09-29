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
    IDLE = 5,
    PETTING = 6,
    CROUCH_NOISES = 7,
}

module.CAMEL_ANIMATIONS = {
    PET_START = {29, loop = false, frames = 1, frame_time = 4},
    CROUCHING = {19, loop = true, frames = 1, frame_time = 6},
}
local GUY_ANIMATIONS = {
    MOUNTED_CROUCH_ENTER = {124, 123, 122, loop = false, frames = 3, frame_time = 6},
}

---@param camel Rockdog | Mount | Entity | Movable | PowerupCapable
function module.set_petting(camel)
    camel.user_data.state = module.INTRO_STATE.PETTING
    animationlib.set_animation(camel.user_data, module.CAMEL_ANIMATIONS.PET_START)
    camel.user_data.timeout = 116
end

---@param guy Entity | Movable | Player
function module.set_crouching(guy)
    guy.user_data.state = module.GUY_WALKS.SITTING_CROUCH_ENTER
    animationlib.set_animation(guy.user_data, GUY_ANIMATIONS.MOUNTED_CROUCH_ENTER)
end

return module