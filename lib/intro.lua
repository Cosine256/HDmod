local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local introguylib = require('lib.entities.introguy')
local module = {}

---@type Entity | Movable | Player
local guy

set_callback(function()
    surfacelib.decorate_existing_surface()

    ---@type Rockdog | Mount | Entity | Movable | PowerupCapable
    local camel = get_entity(camellib.create_camel(7, 100, LAYER.FRONT))
    spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)

    guy = get_entity(introguylib.create_intro_guy(7, 100, camel.uid))--x = 16
    spawn_entity_over(ENT_TYPE.FX_SHADOW, guy.uid, 0, 0)

    carry(camel.uid, guy.uid)
    camellib.set_camel_intro_walk_in(camel, guy.uid)

    state.camera.focused_entity_uid = guy.uid

    -- visually fix intro player offset from mount not working
    guy.flags = set_flag(guy.flags, ENT_FLAG.INVISIBLE)
    set_callback(function(render_ctx, draw_depth)
        if state.screen == SCREEN.INTRO then
            if not guy
            or not test_flag(guy.flags, ENT_FLAG.INVISIBLE) then return end
            if draw_depth == guy.type.draw_depth then
                -- reposition guy to look like he's sitting correctly
                local guy_realoffx = -0.15
                local guy_realoffy = 0.6
                local guy_goaloffx = -0.45
                local guy_goaloffy = 0.8
                local dest = guy.rendering_info.destination:offset(guy_goaloffx-guy_realoffx, guy_goaloffy-guy_realoffy)
                render_ctx:draw_world_texture(guy:get_texture(), guy.rendering_info.source, dest, Color:white())
            end
        else
            clear_callback()
        end
    end, ON.RENDER_PRE_DRAW_DEPTH)
end, ON.INTRO)

return module