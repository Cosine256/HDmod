local module = {}
local decorlib = require('lib.gen.decor')

local texture_id
local hard_texture_id
do
    local texture_def = TextureDefinition.new()
    texture_def.width = 1024
    texture_def.height = 512
    texture_def.tile_width = 1024
    texture_def.tile_height = 512
    texture_def.texture_path = "res/cloudday.png"
    texture_id = define_texture(texture_def)

    local hard_texture_def = TextureDefinition.new()
    hard_texture_def.width = 1024
    hard_texture_def.height = 512
    hard_texture_def.tile_width = 1024
    hard_texture_def.tile_height = 512
    hard_texture_def.texture_path = "res/cloudnight.png"
    hard_texture_id = define_texture(hard_texture_def)
end

local CLOUD1_X_INIT = decorlib.SURFACE_BG_WIDTH
local CLOUD2_X_INIT = 0
local cloud1_x
local cloud2_x
local sun_uid

local function init()
    cloud1_x = CLOUD1_X_INIT
    cloud2_x = CLOUD2_X_INIT
    sun_uid = -1
    for _, uid in pairs(get_entities_by_type(ENT_TYPE.BG_SURFACE_NEBULA)) do
        sun_uid = uid
    end
end

set_callback(function ()
    if state.screen == SCREEN.INTRO
    or state.screen == SCREEN.SCORES
    or state.screen == SCREEN.CREDITS
    then
        init()
    end
end, ON.POST_LEVEL_GENERATION)

local function render_cloud(render_ctx, x)
    local src = Quad:new()
    src.top_left_x = 0
    src.top_left_y = 0.01
    src.top_right_x = 4
    src.top_right_y = 0.01
    src.bottom_left_x = 0
    src.bottom_left_y = 1
    src.bottom_right_x = 4
    src.bottom_right_y = 1
    local w = (4)*16
    local h = (4)/0.5625
    local dest = Quad:new()
    dest.top_left_x = -w/2
    dest.top_left_y = h/2
    dest.top_right_x = w/2
    dest.top_right_y = h/2
    dest.bottom_left_x = -w/2
    dest.bottom_left_y = -h/2
    dest.bottom_right_x = w/2
    dest.bottom_right_y = -h/2
    -- local x, y = screen_position(decorlib.SURFACE_BG_CENTER, state.screen == SCREEN.CREDITS and 113.6 or 103.6)
    if x >= 63 then
        x = x - 119.97
    else
        x = x + 0.0025
    end
    local x_off = 0
    if sun_uid ~= -1 then
        x_off, _, _ = get_position(sun_uid)
    end
    dest:offset(x+x_off, state.screen == SCREEN.CREDITS and 113.6 or 103.6)
    render_ctx:draw_world_texture(state.win_state == WIN_STATE.HUNDUN_WIN and hard_texture_id or texture_id, src, dest, Color:white(), WORLD_SHADER.TEXTURE_COLOR)
    return x
end

set_callback(function(render_ctx, draw_depth)
    if state.screen == SCREEN.INTRO
    or state.screen == SCREEN.SCORES
    or state.screen == SCREEN.CREDITS
    then
        if draw_depth == decorlib.SURFACE_BG_DEPTH.CLOUDS
        then
            cloud1_x = render_cloud(render_ctx, cloud1_x)
            cloud2_x = render_cloud(render_ctx, cloud2_x)
        end
    end
end, ON.RENDER_PRE_DRAW_DEPTH)

return module