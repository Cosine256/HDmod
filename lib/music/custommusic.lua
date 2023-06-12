-- TODO: Custom music can only play if the necessary sound files have been extracted locally.

local custom_music_engine = require "lib.music.custom_music_engine"

local module = {}

optionslib.register_option_bool("hd_debug_custom_level_music_disable", "Custom music - Disable for special levels", nil, false, true)
optionslib.register_option_bool("hd_debug_custom_title_music_disable", "Custom music - Disable for title screen", nil, false, true)

local WORM_LOOP_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Frog_Belly.ogg")
local WORM_CUSTOM_MUSIC = WORM_LOOP_SOUND and {
    base_volume = 0.6,
    start_sound_id = "loop",
    sounds = {
        { id = "loop", next_sound_id = "loop", sound = WORM_LOOP_SOUND, length = 22722 }
    }
}

local BLACK_MARKET_INTRO_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Black_Market_Transition.ogg")
local BLACK_MARKET_LOOP_1_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Black_Market_Part_A.ogg")
local BLACK_MARKET_LOOP_2_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Black_Market_Part_B.ogg")
local BLACK_MARKET_CUSTOM_MUSIC = BLACK_MARKET_INTRO_SOUND and BLACK_MARKET_LOOP_1_SOUND and BLACK_MARKET_LOOP_2_SOUND and {
    base_volume = 0.6,
    play_over_shop_music = true,
    start_sound_id = "intro",
    sounds = {
        { id = "intro", next_sound_id = "loop_1", sound = BLACK_MARKET_INTRO_SOUND, length = 1807 },
        { id = "loop_1", next_sound_id = "loop_2", sound = BLACK_MARKET_LOOP_1_SOUND, length = 28916 },
        { id = "loop_2", next_sound_id = "loop_1", sound = BLACK_MARKET_LOOP_2_SOUND, length = 21687 }
    }
}

local YETI_KINGDOM_INTRO_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Yeti_Caves_Transition.ogg")
local YETI_KINGDOM_LOOP_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Yeti_Caves_Main.ogg")
local YETI_KINGDOM_CUSTOM_MUSIC = YETI_KINGDOM_INTRO_SOUND and YETI_KINGDOM_LOOP_SOUND and {
    base_volume = 0.6,
    start_sound_id = "intro",
    sounds = {
        { id = "intro", next_sound_id = "loop", sound = YETI_KINGDOM_INTRO_SOUND, length = 1538 },
        { id = "loop", next_sound_id = "loop", sound = YETI_KINGDOM_LOOP_SOUND, length = 49231 }
    }
}

local MOTHERSHIP_INTRO_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Mothership_Transition.ogg")
local MOTHERSHIP_LOOP_SOUND = create_sound("../../Extracted/soundbank/ogg/BGM_Mothership_main.ogg")
local MOTHERSHIP_CUSTOM_MUSIC = MOTHERSHIP_INTRO_SOUND and MOTHERSHIP_LOOP_SOUND and {
    base_volume = 0.6,
    start_sound_id = "intro",
    sounds = {
        { id = "intro", next_sound_id = "loop", sound = MOTHERSHIP_INTRO_SOUND, length = 10500 },
        { id = "loop", next_sound_id = "loop", sound = MOTHERSHIP_LOOP_SOUND, length = 36000 }
    }
}

local TITLE_LOOP_SOUND = create_sound("res/music/title_medley.wav")
local TITLE_CUSTOM_MUSIC = TITLE_LOOP_SOUND and {
    base_volume = 0.45,
    start_sound_id = "loop",
    sounds = {
        { id = "loop", next_sound_id = "loop", sound = TITLE_LOOP_SOUND, length = 131500 }
    }
}

function module.on_start_level()
    if options.hd_debug_custom_level_music_disable then
        return
    elseif state.theme == THEME.EGGPLANT_WORLD then
        custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, WORM_CUSTOM_MUSIC)
    elseif feelingslib.feeling_check(feelingslib.FEELING_ID.BLACKMARKET) then
        custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, BLACK_MARKET_CUSTOM_MUSIC)
    elseif feelingslib.feeling_check(feelingslib.FEELING_ID.YETIKINGDOM) then
        custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, YETI_KINGDOM_CUSTOM_MUSIC)
    elseif state.theme == THEME.NEO_BABYLON then
        custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL, MOTHERSHIP_CUSTOM_MUSIC)
    end
end

function module.on_end_level()
    -- This does nothing if there is already no custom music playing.
    custom_music_engine.clear_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_LEVEL)
end

local custom_title_music_enabled
function module.update_custom_title_music_enabled()
    if custom_title_music_enabled ~= not options.hd_debug_custom_title_music_disable then
        custom_title_music_enabled = not options.hd_debug_custom_title_music_disable
        if custom_title_music_enabled then
            custom_music_engine.set_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_TITLE, TITLE_CUSTOM_MUSIC)
        else
            custom_music_engine.clear_custom_music(custom_music_engine.CUSTOM_MUSIC_MODE.REPLACE_TITLE)
        end
    end
end

return module
