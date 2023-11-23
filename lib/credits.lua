local endingtreasurelib = require('lib.entities.endingtreasure')
local creditscavemenlib = require('lib.entities.credits_cavemen')
local creditsballoonlib = require('lib.entities.creditsballoon')
local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local minigamelib = require('lib.entities.minigame')

local Y_TOP = 0.75
local TITLE_SPACING = 0.025
local TITLE_X = -0.1
local TITLE_SIZE = 0.0015
local TITLE_ALIGNMENT = VANILLA_TEXT_ALIGNMENT.LEFT
local TITLE_STYLE = VANILLA_FONT_STYLE.BOLD
local SUBTITLE_SPACING = 0.085
local SUBTITLE_X = -0.2
local SUBTITLE_SIZE = 0.00085
local SUBTITLE_ALIGNMENT = VANILLA_TEXT_ALIGNMENT.LEFT
local SUBTITLE_STYLE = VANILLA_FONT_STYLE.NORMAL
local SUBTITLE_X_2ND = 0.37
local SUBTITLE_X_CENTER = 0.24
local SUBTITLE_ALIGNMENT_CENTER = VANILLA_TEXT_ALIGNMENT.CENTER

local fade_timeout
local FADE_TIME = 100
local MODCREDITS_STATE <const> = {
    PRE_SHOW = 0,
    SHOW = 1,
    POST_SHOW = 2
}
local MODCREDITS_STATUS

local function init()
    fade_timeout = 0
    MODCREDITS_STATUS = MODCREDITS_STATE.PRE_SHOW
end

set_callback(function ()
    init()
    surfacelib.build_credits_surface()

    state.camera.adjusted_focus_x = 13.971
    state.camera.adjusted_focus_y = 115.460
    state.camera.bounds_top = 121.464
    state.camera.bounds_left = 1.8

    local x = 24.5
    local y = 111
    local p_i = 1
    local camels = {}
    -- # TODO: Loop over participating players, spawn players, initialize minigame logic with spawned players.
    -- loop over player slots
    for s_i, slot in ipairs(state.player_inputs.player_slots) do
        -- if participating, spawn player.
        -- # TODO: if they were dead, spawn a ghost. Implement ghost minigame logic.
        if slot.is_participating then
            spawn_player(s_i, x, y)

            local camel = get_entity(camellib.create_camel_credits(x, y, LAYER.FRONT))
            spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)
            camellib.set_camel_credits_walk_in(camel, x)
            camels[#camels+1] = camel.uid

            local player = get_entity(players[p_i].uid)
            player.flags = set_flag(player.flags, ENT_FLAG.TAKE_NO_DAMAGE)
            player.flags = set_flag(player.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
            player.more_flags = set_flag(player.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
            carry(camel.uid, player.uid)

            x = x + 1.25
            p_i = p_i + 1
        end
    end

    x = 31
    local treasure_uid = endingtreasurelib.create_credits_treasure(x, y, LAYER.FRONT)
    local caveman1 = creditscavemenlib.create_credits_caveman(treasure_uid, x-.5, y, LAYER.FRONT)
    local caveman2 = creditscavemenlib.create_credits_caveman(treasure_uid, x+.5, y, LAYER.FRONT)

    minigamelib.init(treasure_uid, camels, caveman1, caveman2)

    x, y = 26, 116.5
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
    --TEST BALLOON
    -- creditsballoonlib.create_creditsballoon(x, y, LAYER.FRONT, 0, 100)

end, ON.CREDITS)

set_callback(function()
    if state.screen == SCREEN.CREDITS then
        -- Suppress the menu input that exits the credits screen.
        game_manager.game_props.input_menu = game_manager.game_props.input_menu & ~MENU_INPUT.SELECT
    end
end, ON.POST_PROCESS_INPUT)

set_callback(function()
    if state.screen == SCREEN.SCORES
    and state.loading == 3
    then
        state.fadevalue = 1.0
        state.fadeout = 20--40
        state.fadein = 20--40
        state.loading_black_screen_timer = 0
    end
end, ON.LOADING)

local function render_skip_text(render_ctx)
    ---@type TextRenderingInfo
    local skip_text = TextRenderingInfo:new("Press \u{86} to skip", 0.001, 0.001, VANILLA_TEXT_ALIGNMENT.RIGHT, VANILLA_FONT_STYLE.ITALIC)
    skip_text.x, skip_text.y = 0.95, 0.86
    render_ctx:draw_text(skip_text, Color:black())
    skip_text:set_text("Press \u{86} to skip", 0.001, 0.001, VANILLA_TEXT_ALIGNMENT.RIGHT, VANILLA_FONT_STYLE.ITALIC)
    skip_text.x, skip_text.y = skip_text.x-0.0035, skip_text.y+0.0035
    render_ctx:draw_text(skip_text, Color:yellow())
end

local function fade_color(color)
    local alpha = fade_timeout/100
    color.a = alpha
    return color
end

local function render_credits_text(render_ctx, text, x, y, text_size, alignment, style)
    ---@type TextRenderingInfo
    local skip_text = TextRenderingInfo:new(text, text_size, text_size, alignment, style)
    skip_text.x, skip_text.y = x, y
    render_ctx:draw_text(skip_text, fade_color(Color:black()))
    skip_text:set_text(text, text_size, text_size, alignment, style)

    skip_text.x, skip_text.y = skip_text.x-0.0035, skip_text.y+0.0035

    render_ctx:draw_text(skip_text, fade_color(Color:yellow()))
    return y - SUBTITLE_SPACING
end


set_callback(function(render_ctx)
    if state.screen == SCREEN.CREDITS then
        if state.screen_credits.render_timer >= 1.7325
        and MODCREDITS_STATUS == MODCREDITS_STATE.PRE_SHOW then
            fade_timeout = 0
            MODCREDITS_STATUS = MODCREDITS_STATE.SHOW
        elseif MODCREDITS_STATUS == MODCREDITS_STATE.SHOW then
            if fade_timeout < FADE_TIME then
                fade_timeout = fade_timeout + 1
            elseif minigamelib.started_minigame() then
                MODCREDITS_STATUS = MODCREDITS_STATE.POST_SHOW
            end
            if state.screen_credits.render_timer >= 70 then
                MODCREDITS_STATUS = MODCREDITS_STATE.POST_SHOW
            end
        elseif MODCREDITS_STATUS == MODCREDITS_STATE.POST_SHOW then
            if fade_timeout > 0 then
                fade_timeout = fade_timeout - 1
            end
        end

        render_skip_text(render_ctx)

        local yb = Y_TOP
        local x = TITLE_X
        local text_size = TITLE_SIZE
        local alignment = TITLE_ALIGNMENT
        local style = TITLE_STYLE
        yb = render_credits_text(render_ctx, "HDmod Development Team:", x, yb, text_size, alignment, style)

        yb = yb - TITLE_SPACING
        x = SUBTITLE_X
        text_size = SUBTITLE_SIZE
        alignment = SUBTITLE_ALIGNMENT
        style = SUBTITLE_STYLE

        yb = render_credits_text(render_ctx, "Super Ninja Fat - Project Lead, Programming", SUBTITLE_X_CENTER, yb, text_size, SUBTITLE_ALIGNMENT_CENTER, style)
        local column_2_y = yb
        yb = render_credits_text(render_ctx, "Estebanfer - Programming", x, yb, text_size, alignment, style)
        yb = render_credits_text(render_ctx, "Cosine - Programming", x, yb, text_size, alignment, style)
        yb = render_credits_text(render_ctx, "Dr.BaconSlices - Public Relations", SUBTITLE_X_CENTER, yb, text_size, SUBTITLE_ALIGNMENT_CENTER, style)
        yb = render_credits_text(render_ctx, "The Greeni Porcini - Artwork", x, yb, text_size, alignment, style)
        yb = render_credits_text(render_ctx, "Leslie - Sound Effects", SUBTITLE_X_CENTER, yb, text_size, SUBTITLE_ALIGNMENT_CENTER, style)
        yb = render_credits_text(render_ctx, "Pattiemurr - Music", x, yb, text_size, alignment, style)

        --right column
        x = SUBTITLE_X_2ND
        yb = column_2_y
        yb = render_credits_text(render_ctx, "Erictran - Programming", x, yb, text_size, alignment, style)
        yb = render_credits_text(render_ctx, "Taffer - Programming", x, yb, text_size, alignment, style)
        yb = yb - SUBTITLE_SPACING
        yb = render_credits_text(render_ctx, "Omeletttte - Artwork", x, yb, text_size, alignment, style)
        yb = yb - SUBTITLE_SPACING
        yb = render_credits_text(render_ctx, "Logan Moore - Title Music", x, yb, text_size, alignment, style)
        
        yb = yb - TITLE_SPACING
        x = TITLE_X
        text_size = TITLE_SIZE
        alignment = TITLE_ALIGNMENT
        style = TITLE_STYLE
        yb = render_credits_text(render_ctx, "Special Thanks:", x, yb, text_size, alignment, style)

        yb = yb - TITLE_SPACING
        x = SUBTITLE_X
        text_size = SUBTITLE_SIZE
        alignment = SUBTITLE_ALIGNMENT
        style = SUBTITLE_STYLE

        yb = render_credits_text(render_ctx, "XanaGear    KYGaming     El Blargho", x, yb, text_size, alignment, style)
        yb = render_credits_text(render_ctx, "Spelunky 2 API Developers", x, yb, text_size, alignment, style)
        yb = render_credits_text(render_ctx, "hd-science    s2-science    Cheengo", x, yb, text_size, alignment, style)
        
        yb = yb - TITLE_SPACING*2
        x = SUBTITLE_X
        text_size = TITLE_SIZE
        alignment = SUBTITLE_ALIGNMENT
        style = TITLE_STYLE
        yb = render_credits_text(render_ctx, "More coming soon! :)", x, yb, text_size, alignment, style)
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
