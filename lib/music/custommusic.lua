-- TODO: Custom music can only play if the necessary sound files have been extracted locally.

local custom_music_engine = require "lib.music.custom_music_engine"
local hellmusic = require "lib.music.hell.hellmusic"
local hdmusic = require "lib.music.hdmusic"

local module = {}

optionslib.register_option_bool("hd_og_level_music_enable", "OG: Replace level music with music from Spelunky HD", nil, false)

optionslib.register_option_bool("hd_debug_custom_level_music_disable", "Custom music - Disable for special levels", nil, false, true)
optionslib.register_option_bool("hd_debug_custom_title_music_disable", "Custom music - Disable for title screen", nil, false, true)

local CUSTOM_LEVEL_MUSICS = {
    hellmusic.HELL_CUSTOM_MUSIC
}

local WORM_LOOP_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Frog_Belly.ogg")
table.insert(CUSTOM_LEVEL_MUSICS, {
    settings = WORM_LOOP_SOUND and {
        base_volume = 0.6,
        start_sound_id = "loop",
        sounds = {
            { id = "loop", next_sound_id = "loop", sound = WORM_LOOP_SOUND, length = 22722 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.EGGPLANT_WORLD
    end
})

local BLACK_MARKET_INTRO_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Black_Market_Transition.ogg")
local BLACK_MARKET_LOOP_1_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Black_Market_Part_A.ogg")
local BLACK_MARKET_LOOP_2_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Black_Market_Part_B.ogg")
table.insert(CUSTOM_LEVEL_MUSICS, {
    settings = BLACK_MARKET_INTRO_SOUND and BLACK_MARKET_LOOP_1_SOUND and BLACK_MARKET_LOOP_2_SOUND and {
        base_volume = 0.6,
        play_over_shop_music = true,
        start_sound_id = "intro",
        sounds = {
            { id = "intro", next_sound_id = "loop_1", sound = BLACK_MARKET_INTRO_SOUND, length = 1807 },
            { id = "loop_1", next_sound_id = "loop_2", sound = BLACK_MARKET_LOOP_1_SOUND, length = 28916 },
            { id = "loop_2", next_sound_id = "loop_1", sound = BLACK_MARKET_LOOP_2_SOUND, length = 21687 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.BLACKMARKET)
    end
})

local YETI_KINGDOM_INTRO_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Yeti_Caves_Transition.ogg")
local YETI_KINGDOM_LOOP_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Yeti_Caves_Main.ogg")
table.insert(CUSTOM_LEVEL_MUSICS, {
    settings = YETI_KINGDOM_INTRO_SOUND and YETI_KINGDOM_LOOP_SOUND and {
        base_volume = 0.6,
        start_sound_id = "intro",
        sounds = {
            { id = "intro", next_sound_id = "loop", sound = YETI_KINGDOM_INTRO_SOUND, length = 1538 },
            { id = "loop", next_sound_id = "loop", sound = YETI_KINGDOM_LOOP_SOUND, length = 49231 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and feelingslib.feeling_check(feelingslib.FEELING_ID.YETIKINGDOM)
    end
})

local MOTHERSHIP_INTRO_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Mothership_Transition.ogg")
local MOTHERSHIP_LOOP_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Mothership_main.ogg")
table.insert(CUSTOM_LEVEL_MUSICS, {
    settings = MOTHERSHIP_INTRO_SOUND and MOTHERSHIP_LOOP_SOUND and {
        base_volume = 0.6,
        start_sound_id = "intro",
        sounds = {
            { id = "intro", next_sound_id = "loop", sound = MOTHERSHIP_INTRO_SOUND, length = 10500 },
            { id = "loop", next_sound_id = "loop", sound = MOTHERSHIP_LOOP_SOUND, length = 36000 }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.NEO_BABYLON
    end
})

local TITLE_LOOP_SOUND = create_sound("res/music/title_medley.wav")
local TITLE_CUSTOM_MUSIC = TITLE_LOOP_SOUND and {
    base_volume = 0.45,
    start_sound_id = "loop",
    sounds = {
        { id = "loop", next_sound_id = "loop", sound = TITLE_LOOP_SOUND, length = 131500 }
    }
}

local current_custom_level_music
local hd_og_music_enabled
local custom_title_music_enabled
local CUSTOM_MUSIC_TABLE

local function update_custom_level_music()
    -- Check if we have HD level music enabled and update the music table reference accordingly
    if hd_og_music_enabled ~= options.hd_og_level_music_enable then
        hd_og_music_enabled = options.hd_og_level_music_enable
        if hd_og_music_enabled then
            CUSTOM_MUSIC_TABLE = hdmusic.HD_LEVEL_MUSICS
        else
            CUSTOM_MUSIC_TABLE = CUSTOM_LEVEL_MUSICS
        end
    end

    -- Check whether any custom level music should be playing right now.
    local new_custom_level_music = nil
    if not options.hd_debug_custom_level_music_disable then
        for _, custom_level_music in ipairs(CUSTOM_MUSIC_TABLE) do
            if custom_level_music.should_play() then
                new_custom_level_music = custom_level_music
                break
            end
        end
    end
    -- Only update the custom level music if a different one was selected to avoid restarting it when it didn't change.
    if current_custom_level_music ~= new_custom_level_music then
        current_custom_level_music = new_custom_level_music
        if current_custom_level_music then
            custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, current_custom_level_music.settings)
        else
            custom_music_engine.clear_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL)
        end
    end
end

local function update_custom_title_music()
    if custom_title_music_enabled ~= not options.hd_debug_custom_title_music_disable then
        custom_title_music_enabled = not options.hd_debug_custom_title_music_disable
        if custom_title_music_enabled then
            custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_TITLE, TITLE_CUSTOM_MUSIC)
        else
            custom_music_engine.clear_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_TITLE)
        end
    end
end

function module.play_boss_music()
    if not options.hd_debug_custom_level_music_disable then
        if hd_og_music_enabled then
            if state.theme == THEME.OLMEC then
                custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, hdmusic.OLMEC_BOSS_CUSTOM_MUSIC)
                current_custom_level_music = hdmusic.OLMEC_BOSS_CUSTOM_MUSIC
            elseif state.theme == THEME.VOLCANA and feelingslib.feeling_check(feelingslib.FEELING_ID.YAMA) then
                custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, hdmusic.YAMA_BOSS_CUSTOM_MUSIC)
                current_custom_level_music = hdmusic.YAMA_BOSS_CUSTOM_MUSIC
            end
        end
    end
end

set_callback(function()
    -- Check whether custom level music needs to be updated right after any screen change that isn't to/from the options screen.
    if state.loading == 3 and state.screen ~= SCREEN.OPTIONS and state.screen_last ~= SCREEN.OPTIONS then
        update_custom_level_music()
    end
    -- Check whether custom title music has been enabled/disabled in the options right before loading the title screen.
    -- Two loading events are checked because the script API sometimes misses one of them the first time the title screen loads.
    if (state.loading == 1 or state.loading == 2) and state.screen_next == SCREEN.TITLE then
        update_custom_title_music()
    end
end, ON.LOADING)

return module
