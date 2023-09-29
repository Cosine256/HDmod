local module = {}
local animationlib = require('lib.entities.animation')
local introanimationslib = require('lib.introanimations')

local GUY_ANIMATIONS <const> = {
    UNCROUCH_FROM_GROUND = {20, 19, 18, loop = false, frames = 3, frame_time = 4},
    PET_START = {225, 224, loop = false, frames = 2, frame_time = 4},
    PET = {229, 228, 227, 226, loop = true, frames = 4, frame_time = 4},
    PET_END = {231, 230, loop = false, frames = 2, frame_time = 4},
}

local TIMEOUT_GENERAL = 65
local guy_realoffx = -0.15
local guy_realoffy = 0.6
local guy_goaloffx = -0.45
local guy_goaloffy = 0.8

---@param guy Entity | Movable | Player
local function update_intro_guy(guy)
    if guy.user_data.state == introanimationslib.GUY_WALKS.SITTING_CROUCH_ENTER then
        if guy.user_data.animation_timer == 11 then
            guy_goaloffy = 0.5
        elseif guy.user_data.animation_timer == 5 then
            guy_goaloffy = 0.35
        end
        if guy.user_data.animation_timer == 0 then -- if animation finished
            guy.user_data.state = introanimationslib.GUY_WALKS.DISMOUNTED

            ---@type Rockdog | Mount | Entity | Movable | PowerupCapable
            local camel = get_entity(guy.user_data.camel_uid)
            camel:remove_rider()
            --teleport to the camels position + goaloffx and goalloffy
            local x, y, _ = get_position(guy.user_data.camel_uid)
            guy.x, guy.y = x+guy_goaloffx, y+guy_goaloffy
            guy.flags = clr_flag(guy.flags, ENT_FLAG.INVISIBLE)
            state.camera.focused_entity_uid = guy.uid -- set the camera from the anchor back to guy
        else
            guy.animation_frame = animationlib.get_animation_frame(guy.user_data)
            animationlib.update_timer(guy.user_data)
        end
        -- message(string.format("timer & frame: %s, %s", guy.user_data.animation_timer, guy.animation_frame))
    elseif guy.user_data.state == introanimationslib.GUY_WALKS.DISMOUNTED then
        if guy.standing_on_uid ~= -1 then
            guy.user_data.state = introanimationslib.GUY_WALKS.LAND_STANDING
            guy.user_data.timeout = TIMEOUT_GENERAL
            -- message("LANDED")
        end
    elseif guy.user_data.state == introanimationslib.GUY_WALKS.LAND_STANDING then
        if guy.user_data.timeout > 0 then
            guy.user_data.timeout = guy.user_data.timeout - 1
        else
            guy.user_data.state = introanimationslib.GUY_WALKS.WALKING_POST_LAND
            guy.user_data.timeout = TIMEOUT_GENERAL
        end
    elseif guy.user_data.state == introanimationslib.GUY_WALKS.WALKING_POST_LAND then
        --until position is less than a tile over from the camel, walk right
        local cx, _, _ = get_position(guy.user_data.camel_uid)
        if guy.x < cx+1.1 then
            guy.velocityx = 0.072
        else
            --turn, set petting state
            guy.user_data.state = introanimationslib.GUY_WALKS.PETTING
            guy.flags = set_flag(guy.flags, ENT_FLAG.FACING_LEFT)
            animationlib.set_animation(guy.user_data, GUY_ANIMATIONS.PET_START)
            guy.user_data.timeout = 100

            ---@type Rockdog | Mount | Entity | Movable | PowerupCapable
            local camel = get_entity(guy.user_data.camel_uid)
            introanimationslib.set_petting(camel)
        end
    elseif guy.user_data.state == introanimationslib.GUY_WALKS.PETTING then
        if guy.user_data.animation_state == GUY_ANIMATIONS.PET_START
        and guy.user_data.animation_timer == 0 then
            animationlib.set_animation(guy.user_data, GUY_ANIMATIONS.PET)
        end
        if guy.user_data.animation_state == GUY_ANIMATIONS.PET then
            --pet camel and timeout
            if guy.user_data.timeout > 0 then
                guy.user_data.timeout = guy.user_data.timeout - 1
            else
                animationlib.set_animation(guy.user_data, GUY_ANIMATIONS.PET_END)
            end
        end
        if guy.user_data.animation_state == GUY_ANIMATIONS.PET_END
        and guy.user_data.animation_timer == 0 then
            -- message("EXIT CUSTOM ANIMATION")
            -- set the state to something else
            guy.user_data.state = introanimationslib.GUY_WALKS.WALKING_POST_PET
                guy.flags = clr_flag(guy.flags, ENT_FLAG.FACING_LEFT)
            guy.user_data.timeout = TIMEOUT_GENERAL
        end
        if guy.user_data.state == introanimationslib.GUY_WALKS.PETTING then
            guy.animation_frame = animationlib.get_animation_frame(guy.user_data)
            animationlib.update_timer(guy.user_data)
        end
    elseif guy.user_data.state == introanimationslib.GUY_WALKS.WALKING_POST_PET then
        if guy.user_data.timeout > 0 then
            guy.user_data.timeout = guy.user_data.timeout - 1
        elseif guy.x < 54 then
            -- This appears to animate guy as well.
            guy.velocityx = 0.072--0.105 is ana's intro walking speed
        end
    end
end

function module.create_intro_guy(x, y, _camel_uid)
    local guy = get_entity(spawn_entity(ENT_TYPE.CHAR_GUY_SPELUNKY, x, y, LAYER.FRONT, 0, 0))

    -- Make a fake camera anchor so that the camera doesn't snap once we teleport guy to the offset we're faking
    local camera_anchor = get_entity(spawn_entity_over(ENT_TYPE.ITEM_ROCK, guy.uid, guy_goaloffx-guy_realoffx, guy_goaloffy-guy_realoffy))
    camera_anchor.flags = set_flag(camera_anchor.flags, ENT_FLAG.INVISIBLE)
    camera_anchor.flags = set_flag(camera_anchor.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    state.camera.focused_entity_uid = camera_anchor.uid

    guy.user_data = {
        animation_timer = 0,
        state = introanimationslib.GUY_WALKS.PRE_DISMOUNT,
        timeout = 0,
        camel_uid = _camel_uid,
    }
    set_post_statemachine(guy.uid, update_intro_guy)

    -- visually fix intro player offset from mount not working
    guy.flags = set_flag(guy.flags, ENT_FLAG.INVISIBLE)
    set_callback(function(render_ctx, draw_depth)
        if state.screen == SCREEN.INTRO then
            if not guy
            or not test_flag(guy.flags, ENT_FLAG.INVISIBLE) then return end
            if draw_depth == guy.type.draw_depth then
                -- reposition guy to look like he's sitting correctly
                local dest = guy.rendering_info.destination:offset(guy_goaloffx-guy_realoffx, guy_goaloffy-guy_realoffy)
                render_ctx:draw_world_texture(guy:get_texture(), guy.rendering_info.source, dest, Color:white())
            end
        else
            clear_callback()
        end
    end, ON.RENDER_PRE_DRAW_DEPTH)

    return guy.uid
end

return module