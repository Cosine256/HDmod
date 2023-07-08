local module = {}

---@type Entity | Movable | Player
local guy

set_callback(function()
    guy = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.CHAR_GUY_SPELUNKY, 9, 100, LAYER.FRONT))
    spawn_entity_over(ENT_TYPE.FX_SHADOW, guy.uid, 0, 0)
    state.camera.focused_entity_uid = guy.uid
    steal_input(guy.uid)
    set_post_statemachine(guy.uid, function (ent)
        message("GO RIGHT, GUY!")
        send_input(ent.uid, INPUTS.RIGHT)
    end)

    local TO_REMOVE = {ENT_TYPE.ITEM_EGGSHIP, ENT_TYPE.FX_EGGSHIP_DOOR, ENT_TYPE.FX_EGGSHIP_SHELL, ENT_TYPE.BG_SURFACE_STAR}
    local TO_MOVE = {ENT_TYPE.BG_LEVEL_BACKWALL, ENT_TYPE.BG_SURFACE_BACKGROUNDSEAM}

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
end, ON.INTRO)

-- set_callback(function ()
--     if state.screen == SCREEN.INTRO and guy then
--         -- guy.input.buttons_gameplay = set_mask(guy.input.buttons_gameplay, INPUTS.RIGHT)
--         message("GO RIGHT, GUY!")
--         send_input(guy.uid, INPUTS.RIGHT)
--     end
-- end, ON.PRE_UPDATE)

return module