local module = {}

module.music_debug_print = false
module.HD_LEVEL_MUSICS = {}

-- Bool, whether the adventure track has played, only plays on the first run or after going back to the menu
local adventure_played = false

-- Stores the track we selected a/b/c
local track_selection = 0

-- Selects which track we will play a/b/c
local function new_track_selection()
    track_selection = prng:random(3)
    if module.music_debug_print then
        print("[HD Music Debug] track_selection = " .. tostring(track_selection))
    end
end

-- Rolls for an egg track (1/100 chance)
local function roll_for_egg_track()
    if prng:random(100) == 1 then
        new_track_selection()
        return true
    else
        return false
    end
end

local TUTORIAL_LOOP_SOUND = create_sound("res/music/hd/Tutorial.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TUTORIAL_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "Tutorial",
        sounds = {
            { id = "Tutorial", next_sound_id = "Tutorial", sound = TUTORIAL_LOOP_SOUND, length = 58189 }
        }
    },
    should_play = function()
        return (state.screen == SCREEN.LEVEL and worldlib.HD_WORLDSTATE_STATE == worldlib.HD_WORLDSTATE_STATUS.TUTORIAL)
    end
})

local MINES_DARK_LOOP_SOUND = create_sound("res/music/hd/A01_dark.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = MINES_DARK_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A01_dark",
        sounds = {
            { id = "A01_dark", next_sound_id = "A01_dark", sound = MINES_DARK_LOOP_SOUND, length = 64000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and test_flag(get_level_flags(), 18)
    end
})

local MINES_EGG_LOOP_SOUND = create_sound("res/music/hd/A01_egg.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = MINES_EGG_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A01_egg",
        sounds = {
            { id = "A01_egg", next_sound_id = "A01_egg", sound = MINES_EGG_LOOP_SOUND, length = 51922 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and roll_for_egg_track()
    end
})

local ADVENTURE_LOOP_SOUND = create_sound("res/music/hd/adventure.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = ADVENTURE_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "adventure",
        sounds = {
            { id = "adventure", next_sound_id = "adventure", sound = ADVENTURE_LOOP_SOUND, length = 56644 }
        }
    },
    should_play = function()
        if (state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and not adventure_played) then
            adventure_played = true
            return true
        else
            return false
        end
    end
})

local MINES_A_LOOP_SOUND = create_sound("res/music/hd/A01_A.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = MINES_A_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A01_A",
        sounds = {
            { id = "A01_A", next_sound_id = "A01_A", sound = MINES_A_LOOP_SOUND, length = 59456 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and track_selection == 1
    end
})

local MINES_B_LOOP_SOUND = create_sound("res/music/hd/A01_B.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = MINES_B_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A01_B",
        sounds = {
            { id = "A01_B", next_sound_id = "A01_B", sound = MINES_B_LOOP_SOUND, length = 59977 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and track_selection == 2
    end
})

local MINES_C_LOOP_SOUND = create_sound("res/music/hd/A01_C.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = MINES_C_LOOP_SOUND and {
        base_volume = 0.5,

        start_sound_id = "A01_C",
        sounds = {
            { id = "A01_C", next_sound_id = "A01_C", sound = MINES_C_LOOP_SOUND, length = 67494 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and track_selection == 3
    end
})

local BLACK_MARKET_LOOP_SOUND = create_sound("res/music/hd/A02_market.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = BLACK_MARKET_LOOP_SOUND and {
        base_volume = 0.5,
        play_over_shop_music = true,
        start_sound_id = "A02_market",
        sounds = {
            { id = "A02_market", next_sound_id = "A02_market", sound = BLACK_MARKET_LOOP_SOUND, length = 47996 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.BLACKMARKET)
    end
})

local JUNGLE_HAUNTED_LOOP_SOUND = create_sound("res/music/hd/A02_haunted.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_HAUNTED_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_haunted",
        sounds = {
            { id = "A02_haunted", next_sound_id = "A02_haunted", sound = JUNGLE_HAUNTED_LOOP_SOUND, length = 61586 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.HAUNTEDCASTLE)
    end
})

local JUNGLE_CEMETARY_LOOP_SOUND = create_sound("res/music/hd/A02_cemetary.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_CEMETARY_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_cemetary",
        sounds = {
            { id = "A02_cemetary", next_sound_id = "A02_cemetary", sound = JUNGLE_CEMETARY_LOOP_SOUND, length = 48000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.RESTLESS)
    end
})

local JUNGLE_DARK_LOOP_SOUND = create_sound("res/music/hd/A02_dark.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_DARK_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_dark",
        sounds = {
            { id = "A02_dark", next_sound_id = "A02_dark", sound = JUNGLE_DARK_LOOP_SOUND, length = 56000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.JUNGLE and test_flag(get_level_flags(), 18)
    end
})

local JUNGLE_EGG_LOOP_SOUND = create_sound("res/music/hd/A02_egg.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_EGG_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_egg",
        sounds = {
            { id = "A02_egg", next_sound_id = "A02_egg", sound = JUNGLE_EGG_LOOP_SOUND, length = 43204 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.JUNGLE and roll_for_egg_track()
    end
})

local JUNGLE_A_LOOP_SOUND = create_sound("res/music/hd/A02_A.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_A_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_A",
        sounds = {
            { id = "A02_A", next_sound_id = "A02_A", sound = JUNGLE_A_LOOP_SOUND, length = 44849 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.JUNGLE and track_selection == 1
    end
})

local JUNGLE_B_LOOP_SOUND = create_sound("res/music/hd/A02_B.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_B_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_B",
        sounds = {
            { id = "A02_B", next_sound_id = "A02_B", sound = JUNGLE_B_LOOP_SOUND, length = 52688 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.JUNGLE and track_selection == 2
    end
})

local JUNGLE_C_LOOP_SOUND = create_sound("res/music/hd/A02_C.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = JUNGLE_C_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_C",
        sounds = {
            { id = "A02_C", next_sound_id = "A02_C", sound = JUNGLE_C_LOOP_SOUND, length = 48233 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.JUNGLE and track_selection == 3
    end
})

local WORM_LOOP_SOUND = create_sound("res/music/hd/A02_worm.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = WORM_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A02_worm",
        sounds = {
            { id = "A02_worm", next_sound_id = "A02_worm", sound = WORM_LOOP_SOUND, length = 50378 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.EGGPLANT_WORLD
    end
})

local YETI_KINGDOM_LOOP_SOUND = create_sound("res/music/hd/A03_yeti.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = YETI_KINGDOM_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A03_yeti",
        sounds = {
            { id = "A03_yeti", next_sound_id = "A03_yeti", sound = YETI_KINGDOM_LOOP_SOUND, length = 49987 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.YETIKINGDOM)
    end
})

local ICE_CAVES_EGG_LOOP_SOUND = create_sound("res/music/hd/A03_egg.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = ICE_CAVES_EGG_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A03_egg",
        sounds = {
            { id = "A03_egg", next_sound_id = "A03_egg", sound = ICE_CAVES_EGG_LOOP_SOUND, length = 30403 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.ICE_CAVES and roll_for_egg_track()
    end
})

local MOTHERSHIP_LOOP_SOUND = create_sound("res/music/hd/A03_mother.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = MOTHERSHIP_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A03_mother",
        sounds = {
            { id = "A03_mother", next_sound_id = "A03_mother", sound = MOTHERSHIP_LOOP_SOUND, length = 48000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.NEO_BABYLON
    end
})

local ICE_CAVES_A_LOOP_SOUND = create_sound("res/music/hd/A03_A.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = ICE_CAVES_A_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A03_A",
        sounds = {
            { id = "A03_A", next_sound_id = "A03_A", sound = ICE_CAVES_A_LOOP_SOUND, length = 40416 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.ICE_CAVES and track_selection == 1
    end
})

local ICE_CAVES_B_LOOP_SOUND = create_sound("res/music/hd/A03_B.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = ICE_CAVES_B_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A03_B",
        sounds = {
            { id = "A03_B", next_sound_id = "A03_B", sound = ICE_CAVES_B_LOOP_SOUND, length = 42656 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL  and state.theme == THEME.ICE_CAVES and track_selection == 2
    end
})

local ICE_CAVES_C_LOOP_SOUND = create_sound("res/music/hd/A03_C.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = ICE_CAVES_C_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A03_C",
        sounds = {
            { id = "A03_C", next_sound_id = "A03_C", sound = ICE_CAVES_C_LOOP_SOUND, length = 41088 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.ICE_CAVES and track_selection == 3
    end
})

local TEMPLE_DARK_LOOP_SOUND = create_sound("res/music/hd/A04_dark.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TEMPLE_DARK_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A04_dark",
        sounds = {
            { id = "A04_dark", next_sound_id = "A04_dark", sound = TEMPLE_DARK_LOOP_SOUND, length = 39989 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.TEMPLE and test_flag(get_level_flags(), 18)
    end
})

local TEMPLE_EGG_LOOP_SOUND = create_sound("res/music/hd/A04_egg.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TEMPLE_EGG_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A04_egg",
        sounds = {
            { id = "A04_egg", next_sound_id = "A04_egg", sound = TEMPLE_EGG_LOOP_SOUND, length = 54407 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.TEMPLE and roll_for_egg_track()
    end
})

local CITY_OF_GOLD_LOOP_SOUND = create_sound("res/music/hd/A04_gold.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = CITY_OF_GOLD_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A04_gold",
        sounds = {
            { id = "A04_gold", next_sound_id = "A04_gold", sound = CITY_OF_GOLD_LOOP_SOUND, length = 48000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.CITY_OF_GOLD
    end
})

local TEMPLE_A_LOOP_SOUND = create_sound("res/music/hd/A04_A.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TEMPLE_A_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A04_A",
        sounds = {
            { id = "A04_A", next_sound_id = "A04_A", sound = TEMPLE_A_LOOP_SOUND, length = 38400 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.TEMPLE and track_selection == 1
    end
})

local TEMPLE_B_LOOP_SOUND = create_sound("res/music/hd/A04_B.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TEMPLE_B_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A04_B",
        sounds = {
            { id = "A04_B", next_sound_id = "A04_B", sound = TEMPLE_B_LOOP_SOUND, length = 54848 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.TEMPLE and track_selection == 2
    end
})

local TEMPLE_C_LOOP_SOUND = create_sound("res/music/hd/A04_C.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TEMPLE_C_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A04_C",
        sounds = {
            { id = "A04_C", next_sound_id = "A04_C", sound = TEMPLE_C_LOOP_SOUND, length = 47996 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.TEMPLE and track_selection == 3
    end
})

local HELL_LOOP_SOUND = create_sound("res/music/hd/A05_A.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = HELL_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "A05_A",
        sounds = {
            { id = "A05_A", next_sound_id = "A05_A", sound = HELL_LOOP_SOUND, length = 44673 }
        }
    },
    should_play = function()
        return (state.screen == SCREEN.LEVEL and state.theme == THEME.VOLCANA and not feelingslib.feeling_check(feelingslib.FEELING_ID.YAMA))
    end
})

local OLMEC_INTRO_LOOP_SOUND = create_sound("res/music/hd/olmec_intro.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = OLMEC_INTRO_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "olmec_intro",
        sounds = {
            { id = "olmec_intro", next_sound_id = "olmec_intro", sound = OLMEC_INTRO_LOOP_SOUND, length = 2990 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.OLMEC
    end
})

local YAMA_AMB_LOOP_SOUND = create_sound("res/music/hd/yamaamb.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = YAMA_AMB_LOOP_SOUND and {
        base_volume = 0.5,
        start_sound_id = "yamaamb",
        sounds = {
            { id = "yamaamb", next_sound_id = "yamaamb", sound = YAMA_AMB_LOOP_SOUND, length = 4590 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.YAMA)
    end
})

-- Hack to keep music muted during level transitions
local TRANSITION_LOOP_SOUND = create_sound("res/music/hd/level_transition_silent.ogg")
table.insert(module.HD_LEVEL_MUSICS, {
    settings = TRANSITION_LOOP_SOUND and {
        base_volume = 0.0,
        start_sound_id = "level_transition_silent",
        sounds = {
            { id = "level_transition_silent", next_sound_id = "level_transition_silent", sound = TRANSITION_LOOP_SOUND, length = 30000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.TRANSITION
    end
})

local EGGPLANT_LOOP_SOUND = create_sound("res/music/hd/ultraegg.ogg")
module.EGGPLANT_CUSTOM_MUSIC = EGGPLANT_LOOP_SOUND and {
    base_volume = 0.5,
    start_sound_id = "ultraegg",
    sounds = {
        { id = "ultraegg", next_sound_id = "ultraegg", sound = EGGPLANT_LOOP_SOUND, length = 14401 }
    }
}

local OLMEC_BOSS_LOOP_SOUND = create_sound("res/music/hd/A04_boss.ogg")
module.OLMEC_BOSS_CUSTOM_MUSIC = OLMEC_BOSS_LOOP_SOUND and {
    base_volume = 0.5,
    start_sound_id = "A04_boss",
    sounds = {
        { id = "A04_boss", next_sound_id = "A04_boss", sound = OLMEC_BOSS_LOOP_SOUND, length = 59273 }
    }
}

local YAMA_HD_BOSS_LOOP_SOUND = create_sound("res/music/hd/A05_boss.ogg")
module.YAMA_HD_BOSS_CUSTOM_MUSIC = YAMA_HD_BOSS_LOOP_SOUND and {
    base_volume = 0.5,
    start_sound_id = "A05_boss",
    sounds = {
        { id = "A05_boss", next_sound_id = "A05_boss", sound = YAMA_HD_BOSS_LOOP_SOUND, length = 49200 }
    }
}

-- TODO, currently unused until support for credits music replacement is added
module.HD_CREDITS_CUSTOM_MUSIC = {
    base_volume = 0.5,
    start_sound_id = "credits",
    sounds = {
        {
            id = "credits",
            sound = create_sound("res/music/hd/Credits.ogg"),
            length = 81014,
            next_sound_id = function(ctx)
                if state.win_state == WIN_STATE.HUNDUN_WIN then
                    if module.music_debug_print then
                        print("[HD Music Debug] Hard win, playing credits_2")
                    end

                    return "credits_2"
                end

                if module.music_debug_print then
                    print("[HD Music Debug] Normal win, playing credits_2b")
                end

                return "credits_2b"
            end
        },
        {
            id = "credits_2",
            sound = create_sound("res/music/hd/Credits_2.ogg"),
            length = 31957,
            next_sound_id = "credits_2"
        },
        {
            id = "credits_2b",
            sound = create_sound("res/music/hd/Credits_2b.ogg"),
            length = 32000,
            next_sound_id = "credits_2b"
        }
    }
}

set_callback(function()
    new_track_selection()
end, ON.RESET)

set_callback(function()
    if adventure_played then
        if module.music_debug_print then
            print("[HD Music Debug] adventure_played = false")
        end
        adventure_played = false
    end
end, ON.MENU)

return module
