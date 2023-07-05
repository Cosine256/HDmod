-- In the vanilla game, a win is triggered by the player's state machine when the player finishes entering a win door. Emulate this behavior in the Olmec and Yama levels.
set_post_entity_spawn(function(ent)
    if state.screen == SCREEN.LEVEL and (state.theme == THEME.OLMEC or feelingslib.feeling_check(feelingslib.FEELING_ID.YAMA)) then
        ent:set_post_virtual(ENTITY_OVERRIDE.UPDATE_STATE_MACHINE, function(ent)
            if ent.last_state == CHAR_STATE.ENTERING and ent.state == CHAR_STATE.LOADING then
                if state.theme == THEME.OLMEC then
                    if ent.abs_y > 95 then
                        -- The player exited via the upper Olmec door.
                        state.screen_next = SCREEN.WIN
                        state.win_state = WIN_STATE.TIAMAT_WIN
                    end
                else
                    -- The player exited via the Yama door.
                    state.screen_next = SCREEN.WIN
                    state.win_state = WIN_STATE.HUNDUN_WIN
                end
            end
        end)
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)

set_callback(function()
    if state.loading == 2 and state.screen_next == SCREEN.WIN then
        if state.win_state == WIN_STATE.TIAMAT_WIN then
            -- The game will crash if it tries to generate the win level with the Olmec theme. Force the temple theme instead.
            state:force_current_theme(THEME.TEMPLE)
        elseif state.win_state == WIN_STATE.HUNDUN_WIN then
            -- TODO: The win level contains styled floors, but the volcana theme does not have a styled floor. Volcana's styled floors generate as totem traps and the win level becomes completely broken. Force the Hundun theme as a workaround until the volcana generation is fixed.
            state:force_current_theme(THEME.HUNDUN)
        end
    end
end, ON.LOADING)
