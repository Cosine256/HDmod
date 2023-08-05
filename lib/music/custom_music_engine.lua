--[[
Custom Music Engine v1.2.1

This module provides functions to replace vanilla music with custom music for levels, transitions, and the title screen.

Custom music consists of a collection of sounds with instructions on the order and timings in which to play them. The order can be hard-coded or determined at runtime by callback functions. The custom music keeps track of when the current sound was started and starts the next sound when the correct amount of time has passed. The previous sound is not cut off when the next sound starts, so they can be designed to blend into each other.

Custom music for levels and transitions will imitate the following vanilla music behaviors:
    Mutes itself to allow back layer music, shop music, and vendor anger music to play.
    Stops playing when vanilla music would stop playing, such as during the death screen or when changing worlds.
    Lowers in volume when paused or in a level transition.
    Lowers in pitch when the ghost is present.

Custom music limitations:
    Doesn't smoothly adjust volume and pitch like vanilla music.
    Can't apply a muffling effect, and instead imitates this effect by just lowering its volume.
    Sound timing precision is tied to the user's graphical frame rate. Timing may sound a bit wrong at low frame rates.

There is no built-in support for some dynamic behaviors of vanilla music, such as music changing in response to player health or level feelings, but these behaviors can be emulated by using sound ID callbacks and checking the game state to determine the next sound to play.

This module should be loaded as early as possible because it needs to capture the creation of the BGM master vanilla sound. There is no way to find a BGM master that already exists, so this module will not be functional until a new one is created.
]]

-- Naming convention: Variables named "sound" are CustomSound objects, and variables named "psound" are PlayingSound objects.

local module = {}

module.CUSTOM_MUSIC_MODE = {
    -- Replace the vanilla music played during levels and transitions.
    REPLACE_LEVEL = 1,
    -- Replace the vanilla music played on the title screen.
    REPLACE_TITLE = 2
}

module.debug_print = false

local custom_musics = {}
local bgm_master_psound

local Custom_Music = {}
Custom_Music.__index = Custom_Music

-- Creates a new custom music object. It will immediately register callbacks, and depending on its settings, it may immediately mute vanilla sounds and start playing custom sounds.
function Custom_Music:new(mode, settings)
    local o = {
        settings = {
            mode = mode,
            base_volume = settings.base_volume or 1,
            play_over_shop_music = settings.play_over_shop_music == true,
            start_sound_id = settings.start_sound_id,
            sounds = {}
        },
        playing = false,
        psounds = {} -- A few checks are simplified by never letting this be nil.
    }
    setmetatable(o, self)

    if settings.sounds then
        for _, sound in ipairs(settings.sounds) do
            o.settings.sounds[sound.id] = {
                id = sound.id,
                next_sound_id = sound.next_sound_id,
                sound = sound.sound,
                length = sound.length
            }
        end
    end

    -- This function needs to run as often as possible, and this was the most reliable callback I could find for it. Game frame and global interval callbacks don't run under some circumstances, which causes noticeable delays in the custom music behavior.
    o.frame_callback_id = set_callback(function() o:on_frame() end, ON.GUIFRAME)

    if o.settings.mode == module.CUSTOM_MUSIC_MODE.REPLACE_TITLE then
        o.title_loading_callback_id = set_callback(function() o:on_title_loading() end, ON.LOADING)
        if state.screen == SCREEN.TITLE and game_manager.screen_title.music then
            game_manager.screen_title.music.playing = false
            o:start()
        end
    end

    return o
end

-- Stops all custom playing sounds, clears callbacks, and restores the vanilla music that was being replaced by this custom music. This custom music object should be discarded after calling this method.
function Custom_Music:destroy()
    self:stop()
    clear_callback(self.frame_callback_id)
    if self.settings.mode == module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL then
        self:set_mute_bgm_master_psound(false)
    elseif self.settings.mode == module.CUSTOM_MUSIC_MODE.REPLACE_TITLE then
        clear_callback(self.title_loading_callback_id)
        if state.screen == SCREEN.TITLE and game_manager.screen_title.music then
            game_manager.screen_title.music.playing = true
        end
    end
end

-- Starts the custom music. This function just initializes variables and enables sound creation, after which the frame callback is responsible for creating sounds.
function Custom_Music:start()
    if module.debug_print then
        print("Starting custom music.")
    end
    self.playing = true
    self.play_start_sound = true
    self.next_sound_start_time = nil
    self.psounds_last_clean_time = get_ms()
    self.mute = false
    self.volume = 1.0
    self.pitch = 1.0
end

-- Stops the custom music, stopping all existing sounds and disabling sound creation in the frame callback.
function Custom_Music:stop()
    if module.debug_print then
        print("Stopping custom music.")
    end
    self.playing = false
    for _, psound in pairs(self.psounds) do
        psound:stop()
    end
    self.psounds = {}
end

-- Configures and starts playing a custom sound.
function Custom_Music:play_sound(sound, uid)
    local psound = sound:play(true, SOUND_TYPE.MUSIC)
    self.psounds[uid] = psound
    psound:set_looping(SOUND_LOOP_MODE.OFF)
    psound:set_mute(self.mute)
    psound:set_volume(self.settings.base_volume * self.volume)
    psound:set_pitch(self.pitch)
    psound:set_pause(false)
end

-- Gets whether vanilla shop music would be currently playing. This does not check for vendor anger music, which takes priority over shop music.
local function is_shop_music_playing()
    return state.screen == SCREEN.LEVEL
        -- Dark levels do not play shop music.
        and not test_flag(get_level_flags(), 18)
        -- This shop check isn't totally accurate. The vanilla shop check is based on the position of the leader player, not the camera focus. If the last living player dies, then the check is still based on the position of their body. It only falls back to using the camera focus if their body is destroyed. The camera focus is typically the leader, but mods could change it to be something else. I'm using this slightly inaccurate check instead because I haven't found a reliable way to determine who is the leader.
        and is_inside_active_shop_room(state.camera.focus_x, state.camera.focus_y, state.camera_layer)
        and is_inside_shop_zone(state.camera.focus_x, state.camera.focus_y, state.camera_layer)
end

-- Mutes or unmutes all playing custom music sounds.
function Custom_Music:set_mute_psounds(mute)
    if self.mute == mute then
        return
    end
    for _, psound in pairs(self.psounds) do
        psound:set_mute(mute)
    end
    self.mute = mute
end

-- Sets the volume of all playing custom music sounds.
function Custom_Music:set_volume_psounds(volume)
    if self.volume == volume then
        return
    end
    for _, psound in pairs(self.psounds) do
        psound:set_volume(self.settings.base_volume * volume)
    end
    self.volume = volume
end

-- Sets the pitch of all playing custom music sounds.
function Custom_Music:set_pitch_psounds(pitch)
    if self.pitch == pitch then
        return
    end
    for _, psound in pairs(self.psounds) do
        psound:set_pitch(pitch)
    end
    -- Changing the pitch changes the lengths of the sounds. Adjust the start time for the next sound. This shouldn't accumulate noticeable floating point errors unless an excessive number of pitch changes occur during a single sound.
    local current_time = get_ms()
    local ms_until_next_start_time = self.next_sound_start_time - current_time
    self.next_sound_start_time = current_time + (ms_until_next_start_time * self.pitch / pitch)
    self.pitch = pitch
end

-- Discards handles for custom music sounds that have finished playing.
function Custom_Music:clean_psounds()
    for index, psound in pairs(self.psounds) do
        if not psound:is_playing() then
            if module.debug_print then
                print("Discarding stopped PlayingSound handle: "..index)
            end
            self.psounds[index] = nil
        end
    end
end

-- Checks the current game state and modifies all playing custom music sounds as needed. Does nothing if mode is not set to REPLACE_LEVEL. This should only be called if custom music is playing.
function Custom_Music:modify_psounds()
    if self.settings.mode ~= module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL then
        return
    end

    -- Check whether the custom music needs be muted.
    local mute = false
    if state.camera_layer ~= LAYER.FRONT then
        -- Mute while not in the front layer.
        mute = true
    elseif self.bgm_master_psound and self.bgm_master_psound:get_parameter(VANILLA_SOUND_PARAM.ANGER_STATE) == 1 then
        -- Mute during vendor anger music.
        mute = true
    elseif not self.settings.play_over_shop_music and is_shop_music_playing() then
        -- Mute during shop music.
        mute = true
    end
    self:set_mute_psounds(mute)

    -- Check whether the custom music needs its volume changed.
    local volume = 1.0
    if state.screen == SCREEN.TRANSITION and state.theme ~= THEME.COSMIC_OCEAN then
        -- Reduce volume while in a non-CO level transition. There is a muffling effect for vanilla music, but this change sounds reasonably close.
        volume = 0.25
    elseif state.pause & PAUSE.MENU > 0 then
        -- Reduce volume while paused. There is a muffling effect for vanilla music, but this change sounds reasonably close.
        volume = 0.4
    end
    self:set_volume_psounds(volume)

    -- Check whether the custom music needs its pitch changed.
    local pitch = 1.0
    if self.bgm_master_psound and self.bgm_master_psound:get_parameter(VANILLA_SOUND_PARAM.GHOST) > 0 then
        -- Lower pitch while the ghost is present. I'm not sure if this is the exact effect applied to the vanilla music, but it sounds reasonably close. This number was obtained by recording ghost music from the game and comparing it with the raw music files. I don't know why it seems so arbitrary.
        pitch = 0.90101
    end
    self:set_pitch_psounds(pitch)
end

-- Sets the BGM master playing sound for this custom music to replace. The caller is responsible for updating the BGM master when the game creates a new one. Setting this has no effect if mode is not set to REPLACE_LEVEL.
function Custom_Music:set_bgm_master_psound(psound)
    self.bgm_master_psound = psound
    self.bgm_master_prev_current_theme = nil
    self.bgm_master_prev_current_shop_type = nil
    -- Immediately mute the new BGM master. The frame callback will eventually mute it anyways, but muting it here avoids a stutter that can happen while it's briefly unmuted.
    self:set_mute_bgm_master_psound(true)
end

local BGM_MASTER_SILENT_CURRENT_THEME = 17
local BGM_MASTER_SILENT_CURRENT_SHOP_TYPE = 11
-- Mutes or unmutes the BGM master. Does nothing if there is no BGM master, or if mode is not set to REPLACE_LEVEL. PlayingSound:set_mute() irreversibly mutes the BGM master, and PlayingSound:set_volume() does not seem to have any effect. This function instead "mutes" the BGM master by changing its parameters to play tracks that don't exist, and "unmutes" it by restoring the original parameters. The chosen silent tracks are assumed to never be used by the game engine.
function Custom_Music:set_mute_bgm_master_psound(mute)
    -- Don't check whether the BGM master is actually playing. A newly created BGM master may not be playing yet when this is first called, but muting it like this still prevents it from making any sound when it does start playing.
    if self.settings.mode ~= module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL or not self.bgm_master_psound then
        return
    end

    local current_theme = self.bgm_master_psound:get_parameter(VANILLA_SOUND_PARAM.CURRENT_THEME)
    local current_shop_type = self.bgm_master_psound:get_parameter(VANILLA_SOUND_PARAM.CURRENT_SHOP_TYPE)
    if mute then
        if current_theme ~= BGM_MASTER_SILENT_CURRENT_THEME then
            self.bgm_master_prev_current_theme = current_theme
            self.bgm_master_psound:set_parameter(VANILLA_SOUND_PARAM.CURRENT_THEME, BGM_MASTER_SILENT_CURRENT_THEME)
        end
        if current_shop_type ~= BGM_MASTER_SILENT_CURRENT_SHOP_TYPE and self.settings.play_over_shop_music then
            self.bgm_master_prev_current_shop_type = current_shop_type
            self.bgm_master_psound:set_parameter(VANILLA_SOUND_PARAM.CURRENT_SHOP_TYPE, BGM_MASTER_SILENT_CURRENT_SHOP_TYPE)
        end
    else
        if self.bgm_master_prev_current_theme and self.bgm_master_prev_current_theme ~= current_theme then
            self.bgm_master_psound:set_parameter(VANILLA_SOUND_PARAM.CURRENT_THEME, self.bgm_master_prev_current_theme)
            self.bgm_master_prev_current_theme = nil
        end
        if self.bgm_master_prev_current_shop_type and self.bgm_master_prev_current_shop_type ~= current_shop_type then
            self.bgm_master_psound:set_parameter(VANILLA_SOUND_PARAM.CURRENT_SHOP_TYPE, self.bgm_master_prev_current_shop_type)
            self.bgm_master_prev_current_shop_type = nil
        end
    end
end

-- Updates the current sound to the one with the given sound ID. If the sound ID parameter is a function, then the function is executed and its return value is used as the sound ID. Sets the current sound to nil if no sound has this ID.
function Custom_Music:update_current_sound(sound_id)
    if type(sound_id) == "function" then
        local ctx = {}
        if self.settings.mode == module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL then
            ctx.bgm_master = self.bgm_master_psound
        end
        -- Execute the sound ID callback.
        local success, result = pcall(function() sound_id = sound_id(ctx) end)
        if not success then
            -- Treat the error as an invalid sound ID and set the current sound to nil before rethrowing the error.
            if module.debug_print then
                print("Caught error in sound ID callback: "..result)
                print("Custom music reached end of sound sequence due to sound ID callback error.")
            end
            self.current_sound = nil
            error(result)
        end
    end
    self.current_sound = self.settings.sounds[sound_id]
end

-- Performs custom music checks and modifications that need to occur on every frame.
function Custom_Music:on_frame()
    if self.settings.mode == module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL then
        -- Custom music that replaces the BGM master will start and stop itself depending on the state of the BGM master.
        if self.playing then
            -- Custom music is playing. Check whether it needs to be stopped.
            if not self.bgm_master_psound or not self.bgm_master_psound:is_playing() then
                -- Custom music should only play when vanilla music would be playing.
                self:stop()
            end
        else
            -- Custom music is not playing. Check whether it can be started now.
            if self.bgm_master_psound and self.bgm_master_psound:is_playing() then
                self:start()
            end
        end
        -- The BGM master will occasionally unmute itself when the game engine changes its parameters. Make sure it stays muted.
        self:set_mute_bgm_master_psound(true)
    end

    if not self.playing then
        return
    end

    local now = get_ms()

    -- Clean up finished PlayingSound objects every 10 seconds.
    if now >= self.psounds_last_clean_time + 10000 then
        self:clean_psounds()
        self.psounds_last_clean_time = now
    end

    -- Check whether it's time for the next sound to play.
    if self.play_start_sound or (self.current_sound and now >= self.next_sound_start_time) then
        -- Determine the next sound to play.
        if self.play_start_sound then
            self.play_start_sound = false
            self.next_sound_start_time = now
            self:update_current_sound(self.settings.start_sound_id)
        else
            self:update_current_sound(self.current_sound.next_sound_id)
        end
        if self.current_sound then
            if module.debug_print then
                print("Playing custom sound: "..self.current_sound.id)
            end
            if self.current_sound.sound then
                -- Play the sound. The start time is used here as a unique ID and doesn't affect how it plays.
                self:play_sound(self.current_sound.sound, self.next_sound_start_time)
            end
            -- Calculate when the next sound should play.
            self.next_sound_start_time = self.next_sound_start_time + (self.current_sound.length / self.pitch)
        else
            -- The custom music reached the end of its sound sequence. It will continue to replace vanilla music, but will not play any more sounds.
            if module.debug_print then
                print("Custom music reached end of sound sequence.")
            end
        end
    end

    -- Apply modifications to the custom music based on the current game state. Do this even if there is no current sound, since previous sounds might still be playing.
    self:modify_psounds()
end

function Custom_Music:on_title_loading()
    if state.screen == SCREEN.TITLE then
        if state.loading == 3 and game_manager.screen_title.music then
            game_manager.screen_title.music.playing = false
            self:start()
        end
        if state.loading == 1 and state.screen_next ~= SCREEN.TITLE then
            self:stop()
        end
    end
end

-- Creates a callback to keep track of the creation of BGM master vanilla sounds. The BGM master is responsible for all of the music in standard levels and transitions. Some events can create multiple BGM masters, but the latest one created is always the one kept by the game engine. The callbacks for stopping and destroying vanilla sounds are unreliable because they seem to provide object pointers that were never provided by the creation callback. Instead, the PlayingSound:is_playing() function can be used to determine whether a BGM master is active.
local function create_bgm_master_callback()
    set_vanilla_sound_callback(VANILLA_SOUND.BGM_BGM_MASTER, VANILLA_SOUND_CALLBACK_TYPE.CREATED, function(psound)
        -- Caution: This callback executes on a separate thread. Accessing global state or printing anything on this thread is unsafe and likely to cause a crash. Only modify the local Lua state.
        bgm_master_psound = psound
        if custom_musics[module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL] then
            custom_musics[module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL]:set_bgm_master_psound(bgm_master_psound)
        end
    end)
end

-- Creates a callback to clear all custom music when the script is disabled.
local function create_disable_callback()
    set_callback(function()
        for _, custom_music in pairs(custom_musics) do
            custom_music:destroy()
        end
        custom_musics = {}
    end, ON.SCRIPT_DISABLE)
end

--[[
Sets custom music to play instead of vanilla music. If custom music already exists for the given mode, then it will be stopped and replaced with the new settings.
mode:
    A value from the CUSTOM_MUSIC_MODE enum specifying the behavior of the custom music.
settings:
    A table describing the custom music to play. Nil will clear the custom music and restore the vanilla music. An empty table will just mute the vanilla music. The settings are not validated and bad values can cause problems later, so be sure to follow these specifications.
    {
        -- Base volume for the custom music. Should be between 0 and 1, inclusive. Defaults to 1.
        base_volume = number,
        -- Whether to keep playing custom music in a shop instead of muting it and allowing vanilla shop music to play. Defaults to false.
        play_over_shop_music = boolean,
        -- ID of first sound to play when the custom music starts. If a function, then it is called when the custom music starts to determine the first sound ID. See below for more information about the sound ID callback.
        start_sound_id = string/function,
        -- Array of zero or more sounds that can be played by the custom music. Defaults to empty array.
        sounds = {
            {
                -- Unique ID for this sound. This value is required.
                id = string,
                -- ID of the next sound to play when this sound's time has elapsed. If a function, then it is called at the end of this sound to determine the next sound ID. See below for more information about the sound ID callback.
                next_sound_id = string/function,
                -- CustomSound object to play. If nil, then no sound will play, but the next sound will still be started when the time elapses.
                sound = CustomSound,
                -- Milliseconds to wait after starting this sound before starting the next one. This sound does not stop playing when this time elapses. This value is required and must be a positive number.
                length = number
            },
            ...
        }
    }
    Sound ID callback:
        A sound ID callback can be used to dynamically choose the next sound for the custom music to play. It can perform any logic it needs to, such as randomly choosing a sound or checking the game state. Upvalues can be used if data needs to be shared across multiple sound ID callbacks.
        Signature: string function(ctx)
        ctx: Context object containing information about the custom music.
            bgm_master: If the custom music is replacing level music, then this is the BGM master PlayingSound being replaced. Otherwise, this is nil.
        Return: ID of the sound to play. If nil or invalid, then the custom music will stop playing sounds.
]]
function module.set_custom_music(mode, settings)
    if custom_musics[mode] then
        custom_musics[mode]:destroy()
        custom_musics[mode] = nil
    end
    if settings then
        custom_musics[mode] = Custom_Music:new(mode, settings)
        if mode == module.CUSTOM_MUSIC_MODE.REPLACE_LEVEL then
            custom_musics[mode]:set_bgm_master_psound(bgm_master_psound)
        end
    end
end

-- Clears the custom music and restores the vanilla music for the specified mode.
function module.clear_custom_music(mode)
    module.set_custom_music(mode, nil)
end

create_bgm_master_callback()
create_disable_callback()

return module
