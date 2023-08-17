local module = {}

module.music_debug_print = false

local has_seen_cobra_this_cycle = false
local has_seen_mystery_this_cycle = false
local cobra_count = 0
local mystery_count = 0

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

module.MINES_CUSTOM_MUSIC = {
    settings = {
        base_volume = 0.5,
        start_sound_id = function(ctx)
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

                    return pick_random({ "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
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

                    return pick_random({ "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
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

                    if cobra_count < 1 then
                        local next_stem

                        if has_seen_mystery_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a1" })
                        else
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a", "mystery_a1", "cobra_a1" })
                        end

                        if is_cobra_stem(next_stem) then
                            cobra_count = cobra_count + 1
                        end

                        return next_stem
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] cobra_count = 1; exiting block")
                        end

                        cobra_count = 0
                        if has_seen_mystery_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a", "mystery_a1" })
                        end
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

                    if cobra_count < 1 then
                        local next_stem

                        if has_seen_mystery_this_cycle then
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a" })
                        else
                            next_stem = pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a", "mystery_a1", "cobra_a" })
                        end

                        if is_cobra_stem(next_stem) then
                            cobra_count = cobra_count + 1
                        end

                        return next_stem
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] cobra_count = 1; exiting block")
                        end

                        cobra_count = 0
                        if has_seen_mystery_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a", "mystery_a1" })
                        end
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

                    if mystery_count < 1 then
                        local next_stem

                        if has_seen_cobra_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a1" })
                        else
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a", "cobra_a1", "mystery_a1" })
                        end

                        if is_mystery_stem(next_stem) then
                            mystery_count = mystery_count + 1
                        end

                        return next_stem
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] mystery_count = 1; exiting block")
                        end

                        mystery_count = 0
                        if has_seen_cobra_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a", "cobra_a1" })
                        end
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

                    if mystery_count < 1 then
                        local next_stem
                        
                        if has_seen_cobra_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "mystery_a" })
                        else
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a", "cobra_a1", "mystery_a" })
                        end

                        if is_mystery_stem(next_stem) then
                            mystery_count = mystery_count + 1
                        end

                        return next_stem
                    else
                        if module.music_debug_print then
                            print("[Mines Music Debug] mystery_count = 1; exiting block")
                        end

                        mystery_count = 0
                        if has_seen_cobra_this_cycle then
                            return pick_random({ "cobweb_a", "cobweb_a_nude" })
                        else
                            return pick_random({ "cobweb_a", "cobweb_a_nude", "cobra_a", "cobra_a1" })
                        end
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

                    return pick_random({ "cobweb_c", "cobweb_c_nude", "explore_a", "mattock_a", "cobra_a",
                                         "cobra_a1", "mystery_a", "mystery_a1" })
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

                    return pick_random({ "cobweb_c", "cobweb_c_nude", "explore_a", "mattock_a", "cobra_a",
                                         "cobra_a1", "mystery_a", "mystery_a1" })
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

                    return pick_random({ "explore_a", "mattock_a", "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
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

                    return pick_random({ "explore_a", "mattock_a", "cobra_a", "cobra_a1", "mystery_a", "mystery_a1" })
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

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "mattock_b1", "mattock_b2",
                                         "cobra_a", "cobra_a1", "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
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

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "mattock_b1", "mattock_b2",
                                         "cobra_a", "cobra_a1", "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
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

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "mattock_b1", "mattock_b2",
                                         "cobra_a", "cobra_a1", "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
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

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "mattock_b1", "mattock_b2",
                                         "cobra_a", "cobra_a1", "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
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

                    return pick_random({ "explore_a", "explore_b", "mattock_a", "mattock_b1", "mattock_b2",
                                         "cobra_a", "cobra_a1", "mystery_a", "mystery_a1", "cobweb_a", "cobweb_a_nude" })
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
