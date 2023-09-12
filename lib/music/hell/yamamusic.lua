local module = {}

module.music_debug_print = false

local function playerInRange(player)
    if player ~= nil then
        local px, py, layer = get_position(player)

        for _, v in ipairs(get_entities_by({ENT_TYPE.MONS_AMMIT}, MASK.MONSTER, LAYER.PLAYER)) do
            local mons = get_entity(v)
            if type(mons.user_data) == "table" then
                if mons.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HEAD then
                    --[[
                        Yama's hands decide if a player is in range by checking if the players y position is greater than
                        their own - 6. We're checking from the y position of Yama's head so subtract an additional 1.15.
                    ]]
                    if py > mons.y - 7.15 then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function isYamaPhaseTwo()
    for _, v in ipairs(get_entities_by({ENT_TYPE.MONS_AMMIT}, MASK.MONSTER, LAYER.PLAYER)) do
        local mons = get_entity(v)
        if type(mons.user_data) == "table" then
            if mons.user_data.ent_type == HD_ENT_TYPE.MONS_YAMA_HEAD then
                return mons.user_data.phase2
            end
        end
    end

    return false
end

module.YAMA_BOSS_CUSTOM_MUSIC = {
    base_volume = 0.5,
    start_sound_id = "yama_intro",
    sounds = {
        {
            id = "yama_intro",
            sound = create_sound("res/music/BGM_Yama_Intro.ogg"),
            length = 631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "1p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "1p2"
                end

                return "1p1"
            end
        },
        {
            id = "1p1",
            sound = create_sound("res/music/BGM_Yama_1P1.ogg"),
            length = 8210,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "2p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "2p2"
                end

                return "2p1"
            end
        },
        {
            id = "1p2",
            sound = create_sound("res/music/BGM_Yama_1P2.ogg"),
            length = 8210,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "2p3"
                end

                return "2p2"
            end
        },
        {
            id = "1p3",
            sound = create_sound("res/music/BGM_Yama_1P3.ogg"),
            length = 8210,
            next_sound_id = "2p3"
        },
        {
            id = "2p1",
            sound = create_sound("res/music/BGM_Yama_2P1.ogg"),
            length = 5052,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "2px_3p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "2p2_3p2"
                end

                return "2p1_3p1"
            end
        },
        {
            id = "2p2",
            sound = create_sound("res/music/BGM_Yama_2P2.ogg"),
            length = 5052,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "2px_3p3"
                end

                return "2p2_3p2"
            end
        },
        {
            id = "2p3",
            sound = create_sound("res/music/BGM_Yama_2P3.ogg"),
            length = 5052,
            next_sound_id = "2px_3p3"
        },
        {
            id = "3p1",
            sound = create_sound("res/music/BGM_Yama_3P1.ogg"),
            length = 5684,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "3p1_3p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "3p1_3p2"
                end

                return "3p1_4p1"
            end
        },
        {
            id = "3p2",
            sound = create_sound("res/music/BGM_Yama_3P2.ogg"),
            length = 5684,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "3p2_4p3"
                end

                return "3p2_4p2"
            end
        },
        {
            id = "3p3",
            sound = create_sound("res/music/BGM_Yama_3P3.ogg"),
            length = 5684,
            next_sound_id = "3p3_4p3"
        },
        {
            id = "4p1",
            sound = create_sound("res/music/BGM_Yama_4P1.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "5p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "5p2"
                end

                return "5p1"
            end
        },
        {
            id = "4p2",
            sound = create_sound("res/music/BGM_Yama_4P2.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "5p3"
                end

                return "5p2"
            end
        },
        {
            id = "4p3",
            sound = create_sound("res/music/BGM_Yama_4P3.ogg"),
            length = 6631,
            next_sound_id = "5p3"
        },
        {
            id = "5p1",
            sound = create_sound("res/music/BGM_Yama_5P1.ogg"),
            length = 6947,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "6p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "6p2"
                end

                return "6p1"
            end
        },
        {
            id = "5p2",
            sound = create_sound("res/music/BGM_Yama_5P2.ogg"),
            length = 6947,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "6p3"
                end

                return "6p2"
            end
        },
        {
            id = "5p3",
            sound = create_sound("res/music/BGM_Yama_5P3.ogg"),
            length = 6947,
            next_sound_id = "6p3"
        },
        {
            id = "6p1",
            sound = create_sound("res/music/BGM_Yama_6P1.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "1p3"
                end

                if playerInRange(players[1].uid) then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Player moved into Yama's attack range.")
                    end

                    return "1p2"
                end

                return "1p1"
            end
        },
        {
            id = "6p2",
            sound = create_sound("res/music/BGM_Yama_6P2.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "1p3"
                end

                return "1p2"
            end
        },
        {
            id = "6p3",
            sound = create_sound("res/music/BGM_Yama_6P3.ogg"),
            length = 6631,
            next_sound_id = "1p3"
        },
        {
            id = "2p1_3p1",
            sound = create_sound("res/music/BGM_Yama_Tran_2P1_3P1.ogg"),
            length = 1894,
            next_sound_id = "3p1"
        },
        {
            id = "2p2_3p2",
            sound = create_sound("res/music/BGM_Yama_Tran_2P2_3P2.ogg"),
            length = 1894,
            next_sound_id = "3p2"
        },
        {
            id = "2px_3p3",
            sound = create_sound("res/music/BGM_Yama_Tran_2PX_3P3.ogg"),
            length = 1894,
            next_sound_id = "3p3"
        },
        {
            id = "3p1_3p2",
            sound = create_sound("res/music/BGM_Yama_Tran_3P1_3P2.ogg"),
            length = 947,
            next_sound_id = "3p2"
        },
        {
            id = "3p1_3p3",
            sound = create_sound("res/music/BGM_Yama_Tran_3P1_3P3.ogg"),
            length = 947,
            next_sound_id = "3p3"
        },
        {
            id = "3p1_4p1",
            sound = create_sound("res/music/BGM_Yama_Tran_3P1_4P1.ogg"),
            length = 947,
            next_sound_id = "4p1"
        },
        {
            id = "3p2_4p2",
            sound = create_sound("res/music/BGM_Yama_Tran_3P2_4P2.ogg"),
            length = 947,
            next_sound_id = "4p2"
        },
        {
            id = "3p2_4p3",
            sound = create_sound("res/music/BGM_Yama_Tran_3P2_4P3.ogg"),
            length = 947,
            next_sound_id = "4p3"
        },
        {
            id = "3p3_4p3",
            sound = create_sound("res/music/BGM_Yama_Tran_3P3_4P3.ogg"),
            length = 947,
            next_sound_id = "4p3"
        }
    }
}

return module
