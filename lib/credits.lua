local endingtreasurelib = require('lib.entities.endingtreasure')
local creditsballoonlib = require('lib.entities.creditsballoon')
local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local minigamelib = require('lib.entities.minigame')

set_callback(function ()
    surfacelib.build_credits_surface()

    state.camera.adjusted_focus_x = 13.971
    state.camera.adjusted_focus_y = 115.460
    state.camera.bounds_top = 121.464
    state.camera.bounds_left = 1.8

    local x = 25
    local p_i = 1
    -- # TODO: Loop over participating players, spawn players, initialize minigame logic with spawned players.
    -- loop over player slots
    for s_i, slot in ipairs(state.player_inputs.player_slots) do
        -- if participating, spawn player.
        -- # TODO: if they were dead, spawn a ghost. Implement ghost minigame logic.
        if slot.is_participating then
            spawn_player(s_i, x, 111)

            local camel = get_entity(camellib.create_camel_credits(x, 111, LAYER.FRONT))
            spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)
            camellib.set_camel_walk_in(camel, x)

            local player = get_entity(players[p_i].uid)
            player.flags = set_flag(player.flags, ENT_FLAG.TAKE_NO_DAMAGE)
            player.flags = set_flag(player.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
            player.more_flags = set_flag(player.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
            carry(camel.uid, player.uid)

            x = x + 1.25
            p_i = p_i + 1
        end
    end



    local treasure_uid = endingtreasurelib.create_credits_treasure(30, 111, LAYER.FRONT)

    minigamelib.init(treasure_uid)

    local x, y = 26, 116.5
    local ENTER_TIMEOUT = 1500
    local SPACING_TIMEOUT = 1450
    local HEIGHT_OFFSET = 0.80
    if state.win_state == WIN_STATE.HUNDUN_WIN then
        for frame = 0, 5, 1 do
            local timeout = ENTER_TIMEOUT + frame*SPACING_TIMEOUT
            creditsballoonlib.create_creditsballoon(x, y+math.fmod(frame, 2)*HEIGHT_OFFSET, LAYER.FRONT, frame, timeout)
        end
    else
        for frame = 0, 3, 1 do
            local timeout = ENTER_TIMEOUT + frame*SPACING_TIMEOUT
            creditsballoonlib.create_creditsballoon(x, y+math.fmod(frame, 2)*HEIGHT_OFFSET, LAYER.FRONT, frame, timeout)
        end
        creditsballoonlib.create_creditsballoon(x, y+math.fmod(4, 2)*HEIGHT_OFFSET, LAYER.FRONT, 5, ENTER_TIMEOUT + 4*SPACING_TIMEOUT)
    end
    -- creditsballoonlib.create_creditsballoon(x, y, LAYER.FRONT, 0, 100)

end, ON.CREDITS)

set_callback(function()
    --[[
        prevent fading out of the credits screen (when pressing jump or credits end)
    ]]
    if state.screen == SCREEN.CREDITS
    and state.loading == 1
    then
        local normal_credits_end = true
        for _, player in pairs(players) do
            local input = read_input(player.uid)
            if test_flag(input, INPUT_FLAG.JUMP) then
                normal_credits_end = false
            end
        end
        if not normal_credits_end then
            -- stop loading next scene
            state.loading = 0
        end
    end

    if state.screen == SCREEN.SCORES
    and state.loading == 3
    then
        state.fadevalue = 1.0
        state.fadeout = 20--40
        state.fadein = 20--40
        state.loading_black_screen_timer = 0
    end
end, ON.LOADING)


set_callback(function(render_ctx)
    if state.screen == SCREEN.CREDITS then
        ---@type TextRenderingInfo
        local skip_text = TextRenderingInfo:new("Press     +     to skip", 0.001, 0.001, VANILLA_TEXT_ALIGNMENT.RIGHT, VANILLA_FONT_STYLE.ITALIC)
        skip_text.x, skip_text.y = 0.95, 0.86
        render_ctx:draw_text(skip_text, Color:black())
        skip_text:set_text("Press \u{8D}+\u{83} to skip", 0.001, 0.001, VANILLA_TEXT_ALIGNMENT.RIGHT, VANILLA_FONT_STYLE.ITALIC)
        skip_text.x, skip_text.y = skip_text.x-0.0035, skip_text.y+0.0035
        render_ctx:draw_text(skip_text, Color:yellow())
    end
end, ON.RENDER_PRE_HUD)

set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, layer, 0, 0) end
end, SPAWN_TYPE.ANY, 0,
    ENT_TYPE.ITEM_MINIGAME_SHIP,
    ENT_TYPE.ITEM_MINIGAME_UFO,
    ENT_TYPE.ITEM_MINIGAME_BROKEN_ASTEROID,
    ENT_TYPE.ITEM_MINIGAME_ASTEROID,
    ENT_TYPE.BG_SURFACE_MOVING_STAR,
    ENT_TYPE.ITEM_MINIGAME_ASTEROID_BG
)
