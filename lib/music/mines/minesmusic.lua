local module = {}

module.music_debug_print = false

local has_seen_cobra_this_cycle = false
local has_seen_mystery_this_cycle = false
local cobra_count = 0
local mystery_count = 0

local num_fills = 0
local fill_cap = false
local stem_after_fill

local function pick_random(table)
    return table[prng:random(#table)]
end

--[[
    Selects a random stem from a given pool of stems based on the stems weight
    -- A two dimensional array containing one or more stems and their associated weight
    {
      {
        -- The stems weight. This value must be positive.
        weight = number,
        -- The stems ID
        id = string
      },
      ...
    },
    -- Total weight of all stems in table. This value must be positive.
    total_weight = number
]]
local function pick_weighted_random(table, total_weight)
    -- Select a number between 1 and total_weight
    local selection = prng:random(1, total_weight)

    for i = 1, #table do
        -- Subtract weight from selection
        selection = selection - table[i][1]

        -- If selection is 0 or below, return the value associated with the weight
        if (selection <= 0) then
            return table[i][2]
        end
    end
end

local function is_cobra_stem(stem_id)
    if stem_id == "cobra_a" or stem_id == "cobra_a1" then
        return true
    else
        return false
    end
end

local function is_mystery_stem(stem_id)
    if stem_id == "mystery_a" or stem_id == "mystery_a1" then
        return true
    else
        return false
    end
end

--[[
    The type of Fill we will use
    - One Fill
    - One Cap
    - One Fill then one Cap
    - Two Fills
]]
local fill_type = {
    [1] = function() num_fills = 1 end,
    [2] = function() fill_cap = true end,
    [3] = function() num_fills = 1 fill_cap = true end,
    [4] = function() num_fills = 2 end
}

--[[
    Note for dark level music:
    I have not confirmed this, but strongly suspect that the game uses VANILLA_SOUND_PARAM.TORCH_PROXIMITY to
    check whether it should play one of the in-the-dark variants of certain stems. Some quick tests indicate
    that the player must be less than 8.0 tiles away from any ITEM_TORCHFLAME, ITEM_WALLTORCHFLAME,
    or FX_SMALLFLAME

    In theory this means that you can fake the in-the-dark stem variations that play with something along the lines of
    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.TORCH_PROXIMITY) < 8.0 then
       -- Play in-the-dark stem variants here
    end
]]
module.MINES_DARK_CUSTOM_MUSIC = {
    settings = {
        base_volume = 0.5,
        start_sound_id = "dim_intro",
        sounds = {
            {
                id = "dim_intro",
                sound = create_sound("res/music/BGM_Mines_dim_Intro.ogg"),
                length = 19024,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_ambush_a",
                sound = create_sound("res/music/BGM_Mines_dim_Ambush_A.ogg"),
                length = 15365,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a", "dim_chill_b",
                                         "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_ambush_b",
                sound = create_sound("res/music/BGM_Mines_dim_Ambush_B.ogg"),
                length = 15365,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_nude", "dim_call", "dim_chill_a", "dim_chill_b",
                                         "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_ambush_nude",
                sound = create_sound("res/music/BGM_Mines_dim_Ambush_nude.ogg"),
                length = 15365,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_call", "dim_chill_a", "dim_chill_b",
                                         "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_call",
                sound = create_sound("res/music/BGM_Mines_dim_Call.ogg"),
                length = 11707,
                next_sound_id = function(ctx)
                    return pick_weighted_random({ {1, "dim_ambush_a"}, {1, "dim_ambush_b"}, {1, "dim_ambush_nude"}, {1, "dim_chill_a"},
                                                  {1, "dim_chill_b"}, {1, "dim_echo"}, {1, "dim_pit"}, {10, "dim_response"},
                                                  {1, "dim_shadow"}, {1, "dim_shiver"}, {1, "dim_whisper"} }, 20)
                end
            },
            {
                id = "dim_chill_a",
                sound = create_sound("res/music/BGM_Mines_dim_Chill_A.ogg"),
                length = 14634,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_b",
                                         "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_chill_b",
                sound = create_sound("res/music/BGM_Mines_dim_Chill_B.ogg"),
                length = 14634,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_echo",
                sound = create_sound("res/music/BGM_Mines_dim_Echo.ogg"),
                length = 14634,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_pit",
                sound = create_sound("res/music/BGM_Mines_dim_Pit.ogg"),
                length = 24146,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_echo", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_response",
                sound = create_sound("res/music/BGM_Mines_dim_Response.ogg"),
                length = 9512,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_echo", "dim_pit", "dim_shadow", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_shadow",
                sound = create_sound("res/music/BGM_Mines_dim_Shadow.ogg"),
                length = 16097,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_echo", "dim_pit", "dim_shiver", "dim_whisper" })
                end
            },
            {
                id = "dim_shiver",
                sound = create_sound("res/music/BGM_Mines_dim_Shiver.ogg"),
                length = 20487,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_echo", "dim_pit", "dim_shadow", "dim_whisper" })
                end
            },
            {
                id = "dim_whisper",
                sound = create_sound("res/music/BGM_Mines_dim_Whisper.ogg"),
                length = 16097,
                next_sound_id = function(ctx)
                    return pick_random({ "dim_ambush_a", "dim_ambush_b", "dim_ambush_nude", "dim_call", "dim_chill_a",
                                         "dim_chill_b", "dim_echo", "dim_pit", "dim_shadow", "dim_shiver" })
                end
            }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING and test_flag(get_level_flags(), 18)
    end
}

module.MINES_CUSTOM_MUSIC = {
    settings = {
        base_volume = 0.5,
        start_sound_id = function(ctx)
                if state.screen == SCREEN.LEVEL then
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.FIRST_RUN) == 1 then
                        if module.music_debug_print then
                            print("[Mines Music Debug] FIRST_RUN = 1; playing adventure")
                        end

                        return "adventure"
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] FIRST_RUN = 0; playing normal intro")
                        end

                        return pick_random({ "intro_a", "intro_b" })
                    end
                -- Assume we are on a level transition, pick a random stem instead of adventure or intro stems
                else
                    if module.music_debug_print then
                        print("[Mines Music Debug] state.screen ~= SCREEN.LEVEL; starting with random stem")
                    end

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "cobra_a", "cobra_a1", "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
                end
            end,
        sounds = {
            {
                id = "adventure",
                sound = create_sound("res/music/BGM_Mines_Adventure_intro.ogg"),
                length = 10250,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "intro_a", "intro_b" })
                end
            },
            {
                id = "intro_a",
                sound = create_sound("res/music/BGM_Mines_Intro_A.ogg"),
                length = 10000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return "explore_a"
                end
            },
            {
                id = "intro_b",
                sound = create_sound("res/music/BGM_Mines_Intro_B.ogg"),
                length = 10000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return "explore_a"
                end
            },
            {
                id = "explore_a",
                sound = create_sound("res/music/BGM_Mines_Explore_A.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if has_seen_cobra_this_cycle ~= false or has_seen_mystery_this_cycle ~= false or cobra_count ~= 0 or mystery_count ~= 0 then
                        has_seen_cobra_this_cycle = false
                        has_seen_mystery_this_cycle = false
                        cobra_count = 0
                        mystery_count = 0
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "explore_b", "mattock_a" })
                end
            },
            {
                id = "explore_b",
                sound = create_sound("res/music/BGM_Mines_Explore_B.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return "mattock_a"
                end
            },
            {
                id = "mattock_a",
                sound = create_sound("res/music/BGM_Mines_Mattock_A.ogg"),
                length = 24000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_weighted_random({ {8, "mattock_b1"}, {2, "mattock_b2"} }, 10)
                end
            },
            {
                id = "mattock_b1",
                sound = create_sound("res/music/BGM_Mines_Mattock_B1.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    -- Keep track of what stem will play after the Fill
                    stem_after_fill = pick_random({ "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })

                    -- Pick a random Fill type
                    fill_type[prng:random(4)]()

                    -- Check if we have any Fills to play, otherwise select a random Cap
                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "mattock_b2",
                sound = create_sound("res/music/BGM_Mines_Mattock_B2.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    stem_after_fill = pick_random({ "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "cobra_a",
                sound = create_sound("res/music/BGM_Mines_Cobra_A.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if not has_seen_cobra_this_cycle then
                        has_seen_cobra_this_cycle = true

                        if module.music_debug_print then
                            print("[Mines Music Debug] has_seen_cobra_this_cycle = true")
                        end
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        cobra_count = 0
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        cobra_count = 0
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    local next_stem

                    if cobra_count < 1 then
                        if has_seen_mystery_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a1" })
                        else
                            next_stem = pick_random({ "mystery_a", "mystery_a1", "cobra_a1" })
                        end

                        -- Fills/Caps should only play when moving between stem groups
                        -- If we play from the same stem group, we shouldn't play any Fills/Caps
                        if is_cobra_stem(next_stem) then
                            cobra_count = cobra_count + 1
                            return next_stem
                        end
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] cobra_count = 1; exiting block")
                        end

                        cobra_count = 0
                        if has_seen_mystery_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            next_stem = pick_random({ "mystery_a", "mystery_a1" })
                        end
                    end

                    stem_after_fill = next_stem
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "cobra_a1",
                sound = create_sound("res/music/BGM_Mines_Cobra_A1.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if not has_seen_cobra_this_cycle then
                        has_seen_cobra_this_cycle = true

                        if module.music_debug_print then
                            print("[Mines Music Debug] has_seen_cobra_this_cycle = true")
                        end
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        cobra_count = 0
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        cobra_count = 0
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    local next_stem

                    if cobra_count < 1 then
                        if has_seen_mystery_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a" })
                        else
                            next_stem = pick_random({ "mystery_a", "mystery_a1", "cobra_a" })
                        end

                        if is_cobra_stem(next_stem) then
                            cobra_count = cobra_count + 1
                            return next_stem
                        end
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] cobra_count = 1; exiting block")
                        end

                        cobra_count = 0
                        if has_seen_mystery_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            next_stem = pick_random({ "mystery_a", "mystery_a1" })
                        end
                    end

                    stem_after_fill = next_stem
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "mystery_a",
                sound = create_sound("res/music/BGM_Mines_Mystery_A.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if not has_seen_mystery_this_cycle then
                        has_seen_mystery_this_cycle = true

                        if module.music_debug_print then
                            print("[Mines Music Debug] has_seen_mystery_this_cycle = true")
                        end
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        mystery_count = 0
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        mystery_count = 0
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    local next_stem

                    if mystery_count < 1 then
                        if has_seen_cobra_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a1" })
                        else
                            next_stem = pick_random({ "cobra_a", "cobra_a1", "mystery_a1" })
                        end

                        if is_mystery_stem(next_stem) then
                            mystery_count = mystery_count + 1
                            return next_stem
                        end
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] mystery_count = 1; exiting block")
                        end

                        mystery_count = 0
                        if has_seen_cobra_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            return pick_random({ "cobra_a", "cobra_a1" })
                        end
                    end

                    stem_after_fill = next_stem
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "mystery_a1",
                sound = create_sound("res/music/BGM_Mines_Mystery_A1.ogg"),
                length = 16000,
                next_sound_id = function(ctx)
                    if not has_seen_mystery_this_cycle then
                        has_seen_mystery_this_cycle = true

                        if module.music_debug_print then
                            print("[Mines Music Debug] has_seen_mystery_this_cycle = true")
                        end
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        mystery_count = 0
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        mystery_count = 0
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    local next_stem

                    if mystery_count < 1 then
                        if has_seen_cobra_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a" })
                        else
                            next_stem = pick_random({ "cobra_a", "cobra_a1", "mystery_a" })
                        end

                        if is_mystery_stem(next_stem) then
                            mystery_count = mystery_count + 1
                            return next_stem
                        end
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] mystery_count = 1; exiting block")
                        end

                        mystery_count = 0
                        if has_seen_cobra_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            next_stem = pick_random({ "cobra_a", "cobra_a1" })
                        end
                    end

                    stem_after_fill = next_stem
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "cobweb_a",
                sound = create_sound("res/music/BGM_Mines_Cobweb_A.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "cobweb_b1", "cobweb_b2" })
                end
            },
            {
                id = "cobweb_a_nude",
                sound = create_sound("res/music/BGM_Mines_Cobweb_A_nude.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "cobweb_b1", "cobweb_b2" })
                end
            },
            {
                id = "cobweb_b1",
                sound = create_sound("res/music/BGM_Mines_Cobweb_B1.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "cobweb_c", "cobweb_c_nude" })
                end
            },
            {
                id = "cobweb_b2",
                sound = create_sound("res/music/BGM_Mines_Cobweb_B2.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "cobweb_c", "cobweb_c_nude" })
                end
            },
            {
                id = "cobweb_c",
                sound = create_sound("res/music/BGM_Mines_Cobweb_C.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "cobweb_d1", "cobweb_d2" })
                end
            },
            {
                id = "cobweb_c_nude",
                sound = create_sound("res/music/BGM_Mines_Cobweb_C.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "cobweb_d1", "cobweb_d2" })
                end
            },
            {
                id = "cobweb_d1",
                sound = create_sound("res/music/BGM_Mines_Cobweb_D1.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    stem_after_fill = pick_random({ "explore_a", "mattock_a", "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "cobweb_d2",
                sound = create_sound("res/music/BGM_Mines_Cobweb_D2.ogg"),
                length = 4000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    stem_after_fill = pick_random({ "explore_a", "mattock_a", "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
                    fill_type[prng:random(4)]()

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4", "fill_a5" })
                    else
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end
                end
            },
            {
                id = "fill_a1",
                sound = create_sound("res/music/BGM_Mines_Fill_A1.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if num_fills > 0 then
                        num_fills = num_fills - 1
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a4", "fill_a5" })
                    end
                    if fill_cap then
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "fill_a2",
                sound = create_sound("res/music/BGM_Mines_Fill_A2.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if num_fills > 0 then
                        num_fills = num_fills - 1
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a4", "fill_a5" })
                    end
                    if fill_cap then
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "fill_a3",
                sound = create_sound("res/music/BGM_Mines_Fill_A3.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if num_fills > 0 then
                        num_fills = num_fills - 1
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a4", "fill_a5" })
                    end
                    if fill_cap then
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "fill_a4",
                sound = create_sound("res/music/BGM_Mines_Fill_A4.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if num_fills > 0 then
                        num_fills = num_fills - 1
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a5" })
                    end
                    if fill_cap then
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "fill_a5",
                sound = create_sound("res/music/BGM_Mines_Fill_A5.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if num_fills > 0 then
                        num_fills = num_fills - 1
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        num_fills = 0
                        fill_cap = false
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    if num_fills > 0 then
                        return pick_random({ "fill_a1", "fill_a2", "fill_a3", "fill_a4" })
                    end
                    if fill_cap then
                        return pick_random({ "cap_a1", "cap_a2", "cap_a3", "cap_a4", "cap_a5", "cap_a6" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "cap_a1",
                sound = create_sound("res/music/BGM_Mines_Cap_A1.ogg"),
                length = 2000,
                next_sound_id = function(ctx)
                    fill_cap = false

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "cap_a2",
                sound = create_sound("res/music/BGM_Mines_Cap_A2.ogg"),
                length = 2000,
                next_sound_id = function(ctx)
                    fill_cap = false

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "cap_a3",
                sound = create_sound("res/music/BGM_Mines_Cap_A3.ogg"),
                length = 1000,
                next_sound_id = function(ctx)
                    fill_cap = false

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "cap_a4",
                sound = create_sound("res/music/BGM_Mines_Cap_A4.ogg"),
                length = 2000,
                next_sound_id = function(ctx)
                    fill_cap = false

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "cap_a5",
                sound = create_sound("res/music/BGM_Mines_Cap_A5.ogg"),
                length = 2000,
                next_sound_id = function(ctx)
                    fill_cap = false

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "cap_a6",
                sound = create_sound("res/music/BGM_Mines_Cap_A6.ogg"),
                length = 2000,
                next_sound_id = function(ctx)
                    fill_cap = false

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return stem_after_fill
                end
            },
            {
                id = "idle_a",
                sound = create_sound("res/music/BGM_Mines_Idle_A.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_b", "idle_c" })
                    end

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "cobra_a", "cobra_a1",
                                         "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
                end
            },
            {
                id = "idle_b",
                sound = create_sound("res/music/BGM_Mines_Idle_B.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_c" })
                    end

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "cobra_a", "cobra_a1",
                                         "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
                end
            },
            {
                id = "idle_c",
                sound = create_sound("res/music/BGM_Mines_Idle_C.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return pick_random({ "lowhp_1", "lowhp_2" })
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b" })
                    end

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "cobra_a", "cobra_a1",
                                         "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
                end
            },
            {
                id = "lowhp_1",
                sound = create_sound("res/music/BGM_Mines_LOWHP_1.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return "lowhp_2"
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "cobra_a", "cobra_a1",
                                         "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
                end
            },
            {
                id = "lowhp_2",
                sound = create_sound("res/music/BGM_Mines_LOWHP_2.ogg"),
                length = 8000,
                next_sound_id = function(ctx)
                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_LIFE) == 1 then
                        return "lowhp_1"
                    end

                    if ctx.bgm_master:get_parameter(VANILLA_SOUND_PARAM.PLAYER_ACTIVITY) == 0 then
                        return pick_random({ "idle_a", "idle_b", "idle_c" })
                    end

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "cobra_a", "cobra_a1",
                                         "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
                end
            }
        }
    },
    should_play = function()
        return state.screen == SCREEN.LEVEL and state.theme == THEME.DWELLING
            or state.screen == SCREEN.TRANSITION and state.theme == THEME.DWELLING and state.theme_next == THEME.DWELLING
    end
}

return module
