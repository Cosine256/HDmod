local palmtreelib = require('lib.entities.palmtree')
local module = {}

---@type Entity | Movable | Player
local guy

set_callback(function()
    guy = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.CHAR_GUY_SPELUNKY, 9, 100, LAYER.FRONT))--x = 16
    spawn_entity_over(ENT_TYPE.FX_SHADOW, guy.uid, 0, 0)
    state.camera.focused_entity_uid = guy.uid
    -- Traditional inputs don't seem to be working in the intro
    set_post_statemachine(guy.uid, function (ent)
        if ent.x < 54 then
            -- This appears to animate guy as well.
            ent.velocityx = 0.072--0.105 is ana's intro walking speed
        end
    end)

    local TO_REMOVE = {ENT_TYPE.ITEM_EGGSHIP, ENT_TYPE.FX_EGGSHIP_DOOR, ENT_TYPE.FX_EGGSHIP_SHELL, ENT_TYPE.BG_SURFACE_STAR}
    local TO_MOVE = {ENT_TYPE.BG_LEVEL_BACKWALL, ENT_TYPE.BG_SURFACE_BACKGROUNDSEAM}
    local TO_DECORATE = {ENT_TYPE.BG_SURFACE_ENTITY}

    for _, uid in pairs(get_entities_by_type(TO_REMOVE)) do
        get_entity(uid):destroy()
    end

    for _, uid in pairs(get_entities_by_type(TO_MOVE)) do
        local x, _, _ = get_position(uid)
        local deco = get_entity(uid)
        if x < 40 then
            deco:destroy()
        else
            deco.x = deco.x - 7
        end
    end

    local sun = get_entity(get_entities_by_type(ENT_TYPE.BG_SURFACE_NEBULA)[1])
    sun.width = 9
    sun.height = 4.5

    spawn_grid_entity(ENT_TYPE.FLOOR_GENERIC, 53, 99, LAYER.FRONT)

    palmtreelib.create_palmtree_day(18, 103, 2, palmtreelib.SURFACE_BG_DEPTH.BACKGROUND)
    palmtreelib.create_palmtree_day(23, 103, 0, palmtreelib.SURFACE_BG_DEPTH.BACKGROUND)
    palmtreelib.create_palmtree_day(32, 103, 1, palmtreelib.SURFACE_BG_DEPTH.BACKGROUND, true)
    palmtreelib.create_palmtree_day_layered(30, 100, 1, palmtreelib.SURFACE_BG_DEPTH.FOREGROUND)

    for _, uid in pairs(get_entities_by_type(TO_DECORATE)) do
        ---@type BGSurfaceLayer
        local bg = get_entity(uid)
        local texture_id = bg:get_texture()
        if texture_id == TEXTURE.DATA_TEXTURES_BASE_SURFACE_1 then
            --foreground
            --drawdepth 5
        elseif texture_id == TEXTURE.DATA_TEXTURES_BASE_SURFACE_0 then
            if bg.animation_frame == 3 then
                --front-background
            elseif bg.animation_frame == 2 then
                --mid-background
            elseif bg.animation_frame == 1 then
                --back-background
            end
        end
    end

end, ON.INTRO)

return module