local module = {}

module.music_debug_print = false

local stem_after_tran

local function isHellMinibossDead()
    for _, v in ipairs(get_entities_by({ENT_TYPE.MONS_CAVEMAN_BOSS}, MASK.MONSTER, LAYER.PLAYER)) do
        local mons = get_entity(v)
        if type(mons.user_data) == "table" then
            if mons.user_data.ent_type == HD_ENT_TYPE.MONS_HELL_MINIBOSS then
                return false
            end
        end
    end

    return true
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
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        return "1_p3"
                    end

                    return "1_p2"
                end

                return "1_p1"
            end
        },
        {
            id = "1_p1",
            sound = create_sound("res/music/BGM_Yama_1_P1.ogg"),
            length = 8210,
            next_sound_id = function(ctx)
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        return "2_p3"
                    end

                    return "2_p2"
                end

                return "2_p1"
            end
        },
        {
            id = "p1_tran",
            sound = create_sound("res/music/BGM_Yama_P1_Tran.ogg"),
            length = 947,
            next_sound_id = function(ctx)
                return stem_after_tran
            end
        },
        {
            id = "1_p2",
            sound = create_sound("res/music/BGM_Yama_1_P2.ogg"),
            length = 8210,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "2_p3"
                end

                return "2_p2"
            end
        },
        {
            id = "1_p3",
            sound = create_sound("res/music/BGM_Yama_1_P3.ogg"),
            length = 8210,
            next_sound_id = "2_p3"
        },
        {
            id = "2_p1",
            sound = create_sound("res/music/BGM_Yama_2_P1.ogg"),
            length = 5684,
            next_sound_id = function(ctx)
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        stem_after_tran = "3_p3"
                        return "p1_tran"
                    end

                    stem_after_tran = "3_p2"
                    return "p1_tran"
                end

                return "2_p1_tran_def"
            end
        },
        {
            id = "2_p1_tran_def",
            sound = create_sound("res/music/BGM_Yama_2_P1_Tran_def.ogg"),
            length = 947,
            next_sound_id = "3_p1"
        },
        {
            id = "2_p2",
            sound = create_sound("res/music/BGM_Yama_2_P2.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "3_p3"
                end

                return "3_p2"
            end
        },
        {
            id = "2_p3",
            sound = create_sound("res/music/BGM_Yama_2_P3.ogg"),
            length = 6631,
            next_sound_id = "3_p3"
        },
        {
            id = "3_p1",
            sound = create_sound("res/music/BGM_Yama_3_P1.ogg"),
            length = 5684,
            next_sound_id = function(ctx)
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        stem_after_tran = "4_p3"
                        return "p1_tran"
                    end

                    stem_after_tran = "4_p2"
                    return "p1_tran"
                end

                return "3_p1_tran_def"
            end
        },
        {
            id = "3_p1_tran_def",
            sound = create_sound("res/music/BGM_Yama_3_P1_Tran_def.ogg"),
            length = 947,
            next_sound_id = "4_p1"
        },
        {
            id = "3_p2",
            sound = create_sound("res/music/BGM_Yama_3_P2.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "4_p3"
                end

                return "4_p2"
            end
        },
        {
            id = "3_p3",
            sound = create_sound("res/music/BGM_Yama_3_P3.ogg"),
            length = 6631,
            next_sound_id = "4_p3"
        },
        {
            id = "4_p1",
            sound = create_sound("res/music/BGM_Yama_4_P1.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        return "5_p3"
                    end

                    return "5_p2"
                end

                return "5_p1"
            end
        },
        {
            id = "4_p2",
            sound = create_sound("res/music/BGM_Yama_4_P2.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "5_p3"
                end

                return "5_p2"
            end
        },
        {
            id = "4_p3",
            sound = create_sound("res/music/BGM_Yama_4_P3.ogg"),
            length = 6631,
            next_sound_id = "5_p3"
        },
        {
            id = "5_p1",
            sound = create_sound("res/music/BGM_Yama_5_P1.ogg"),
            length = 6947,
            next_sound_id = function(ctx)
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        return "6_p3"
                    end

                    return "6_p2"
                end

                return "6_p1"
            end
        },
        {
            id = "5_p2",
            sound = create_sound("res/music/BGM_Yama_5_P2.ogg"),
            length = 6947,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "6_p3"
                end

                return "6_p2"
            end
        },
        {
            id = "5_p3",
            sound = create_sound("res/music/BGM_Yama_5_P3.ogg"),
            length = 6947,
            next_sound_id = "6_p3"
        },
        {
            id = "6_p1",
            sound = create_sound("res/music/BGM_Yama_6_P1.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isHellMinibossDead() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Hell miniboss is dead.")
                    end

                    if isYamaPhaseTwo() then
                        if module.music_debug_print then
                            print("[Yama Music Debug] Yama phase2 = true.")
                        end

                        return "1_p3"
                    end

                    return "1_p2"
                end

                return "1_p1"
            end
        },
        {
            id = "6_p2",
            sound = create_sound("res/music/BGM_Yama_6_P2.ogg"),
            length = 6631,
            next_sound_id = function(ctx)
                if isYamaPhaseTwo() then
                    if module.music_debug_print then
                        print("[Yama Music Debug] Yama phase2 = true.")
                    end

                    return "1_p3"
                end

                return "1_p2"
            end
        },
        {
            id = "6_p3",
            sound = create_sound("res/music/BGM_Yama_6_P3.ogg"),
            length = 6631,
            next_sound_id = "1_p3"
        }
    }
}

return module
