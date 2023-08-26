local ladderlib = require('lib.entities.ladder')
local endingplatformlib = require('lib.entities.endingplatform')
local endingtreasurelib = require('lib.entities.endingtreasure')
local unlockslib = require('lib.unlocks')

local chest
---@type Rockdog | Mount | Entity | Movable | PowerupCapable
local lavastream
local lavastream_sndsrc
local snd_fireloop
local snd_rumbleloop
local snd_fireloop_vol

local TIMEOUT_EJECT_TIME = 55
local TIMEOUT_SHAKE_TIME = 100
local TIMEOUT_FLOW_START = 165
local TIMEOUT_PLATFORM_BUFFER = 35
local TIMEOUT_END_TIME = 300

local TIMEOUT_WIN

local hell_transition_texture_id
do
    local hell_transition_texture_def = TextureDefinition.new()
    hell_transition_texture_def.width = 128
    hell_transition_texture_def.height = 128
    hell_transition_texture_def.tile_width = 128
    hell_transition_texture_def.tile_height = 128
    hell_transition_texture_def.texture_path = "res/hell_transition.png"
    hell_transition_texture_id = define_texture(hell_transition_texture_def)
end

set_callback(function ()
    local hard_win = state.win_state == WIN_STATE.HUNDUN_WIN

    -- spawn imposter lava
    lavastream = spawn_impostor_lake(
        AABB:new(34.5,98.5,40.5,85.5),
        LAYER.FRONT, ENT_TYPE.LIQUID_IMPOSTOR_LAVA, 1.0
    )
    lavastream_sndsrc = get_entity(spawn_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, 37.5, 98, LAYER.FRONT, 0, 0))
    lavastream_sndsrc.flags = set_flag(lavastream_sndsrc.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    lavastream_sndsrc.flags = set_flag(lavastream_sndsrc.flags, ENT_FLAG.INVISIBLE)
    lavastream_sndsrc.flags = set_flag(lavastream_sndsrc.flags, ENT_FLAG.NO_GRAVITY)
    --Move y of soundsrc from 100 -> 105
    lavastream_sndsrc:set_post_update_state_machine(function (self)
        if TIMEOUT_WIN >= TIMEOUT_FLOW_START then
            lavastream_sndsrc.y = lavastream_sndsrc.y + 0.1
        end
        if lavastream_sndsrc.y > 105 then
            clear_callback()
        end
    end)

    -- fire sound effects for the stream
    snd_fireloop = commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_FIREBUG_ATK_LOOP, lavastream_sndsrc.uid, 1, true)
    snd_rumbleloop = commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_WARN_LOOP, lavastream_sndsrc.uid, 1, true)
    lavastream_sndsrc:set_post_update_state_machine(function()
        if snd_fireloop then
            commonlib.update_sound_volume(snd_fireloop, lavastream_sndsrc.uid, snd_fireloop_vol)
        end
        if snd_rumbleloop then
            commonlib.update_sound_volume(snd_rumbleloop, lavastream_sndsrc.uid, snd_fireloop_vol)
        end
    end)
    set_callback(function()
        if snd_fireloop then
            snd_fireloop:stop()
        end
        if snd_rumbleloop then
            snd_rumbleloop:stop()
        end
    end, ON.SCORES)

    chest = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN, 42.5, 105.4, LAYER.FRONT))
    chest:set_draw_depth(31)
    for _, uid in pairs(get_entities_by_type(ENT_TYPE.MIDBG)) do
        get_entity(uid):destroy()
    end
    -- spawn bg ouroboro
    local ouroboro = get_entity(spawn_entity(ENT_TYPE.BG_OUROBORO, 37.5, 107, LAYER.FRONT, 0, 0))
    if hard_win then
        ouroboro.color.r = 1
        ouroboro.color.g = 0.31
        ouroboro.color.b = 0.31
    end

    -- backwalls
    local backwalls = get_entities_by_type(ENT_TYPE.BG_LEVEL_BACKWALL)
    if #backwalls > 0 then
        get_entity(backwalls[1]):set_texture(hard_win and TEXTURE.DATA_TEXTURES_BG_VOLCANO_0 or TEXTURE.DATA_TEXTURES_BG_CAVE_0)
    end
    local backwall = get_entity(spawn_entity(ENT_TYPE.BG_LEVEL_BACKWALL, 5.5, 102.5, LAYER.FRONT, 0, 0))
    backwall:set_texture(hard_win and TEXTURE.DATA_TEXTURES_BG_VLAD_0 or TEXTURE.DATA_TEXTURES_BG_STONE_0)
    backwall:set_draw_depth(49)
    backwall.width, backwall.height = 8, 8
    backwall.tile_width = hard_win and 1 or 2
    backwall.tile_height = hard_win and 1 or 2
    backwall.hitboxx, backwall.hitboxy = backwall.width/2, backwall.height/2
    for i = 0, 4, 1 do
        local trans_deco = get_entity(spawn_entity(ENT_TYPE.DECORATION_BG_TRANSITIONCOVER, 10, 105-i, LAYER.FRONT, 0, 0))
        flip_entity(trans_deco.uid)
        trans_deco:set_texture(hard_win and hell_transition_texture_id or TEXTURE.DATA_TEXTURES_FLOORSTYLED_STONE_1)
    end

    if hard_win then
        local chain_coords = {
            {x = 42, y = 110},
            {x = 43, y = 110},
            {x = 33, y = 109},
            {x = 42, y = 109},
            {x = 43, y = 109},
            {x = 31, y = 108},
            {x = 33, y = 108},
            {x = 43, y = 108},
            {x = 31, y = 107},
            {x = 33, y = 107},
            {x = 33, y = 106},
        }
        for _, coords in pairs(chain_coords) do
            ladderlib.create_ceiling_chain(coords.x, coords.y, LAYER.FRONT)
        end
    end

    endingplatformlib.init()

    for x = 34, 39, 1 do
        endingplatformlib.create_endingplatform(x, 103, LAYER.FRONT)
    end

    local character = 193 + unlockslib.HD_UNLOCKS[hard_win and unlockslib.HD_UNLOCK_ID.YAMA or unlockslib.HD_UNLOCK_ID.OLMEC_WIN].unlock_id
    set_ending_unlock(character)
    state.end_spaceship_character = character -- Setting this allows ending SCREEN.WIN early without a crash!
    if hard_win then
        local yang = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.CHAR_CLASSIC_GUY, 40, 104, LAYER.FRONT))
        flip_entity(yang.uid)
    end

end, ON.WIN)

set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
    -- message("ENDINGSHIP!")
    -- message(string.format("ship at: %s %s", x, y))
    --lock the ship at 
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, layer, 0, 0) end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_PARENTSSHIP, ENT_TYPE.ITEM_OLMECSHIP)


local function end_winscene()
    -- message("ENDING WINSCENE!")
    state.loading = 1
    state.fadevalue = 0
    state.fadeout = 20--40
    state.fadein = 20--40
    state.loading_black_screen_timer = 20--40
end

-- burst open treasure chest
local function eject_treasure()
    commonlib.play_vanilla_sound(VANILLA_SOUND.CUTSCENE_BIG_TREASURE_OPEN, chest.uid, 1, false)
    -- set the ending treasure chest to the open texture
    chest.animation_frame = 8
    -- particle effects
    for i = 1, 10 do
        local rubble = get_entity(spawn_entity(ENT_TYPE.ITEM_RUBBLE, 42+prng:random_float(PRNG_CLASS.PARTICLES)*2, 105.75+prng:random_float(PRNG_CLASS.PARTICLES)*3, LAYER.FRONT, 0.06-prng:random_float(PRNG_CLASS.PARTICLES)*0.12, 0.3+prng:random_float(PRNG_CLASS.PARTICLES)*.1))
        rubble.animation_frame = i >= 5 and 20 or 67
    end
    endingtreasurelib.create_ending_treasure(42.5, 105.75, LAYER.FRONT, -0.0735, 0.2)
    -- if hard ending, spawn coins with velocity as it bounces
end

local function vibrate_chest()
    chest.x = chest.x + math.cos(TIMEOUT_WIN)/50
    chest.y = chest.y + math.cos(TIMEOUT_WIN)/50
end

-- move lava in a convincing way to have it 'push' the platform up
local function flow_lava()
    if lavastream.y < 103.5 then
        lavastream.y = lavastream.y + 0.1045
    end
end

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
    if state.screen == SCREEN.WIN then
        ent.flags = set_flag(ent.flags, ENT_FLAG.TAKE_NO_DAMAGE)

        -- only grab ending characters created at the ending door
        if ent.x < 10 then
            -- message("YOU WINNED")
            ent.flags = clr_flag(ent.flags, ENT_FLAG.STUNNABLE)
            local reached_center = false
            TIMEOUT_WIN = 0
            ent:set_post_update_state_machine(
                ---@param self Movable | Entity | Player
                function (self)
                    local x, _, _ = get_position(ent.uid)
                    -- continue walking until you get to the center of the platform
                    if x > 34.5 and x < 37.4 then
                        -- don't trip (Don't even trip, dog)
                        if self.velocityy >= 0.090 then
                            self.velocityy = 0
                        end
                        -- This appears to animate guy as well.
                        ent.velocityx = 0.072--0.105 is ana's intro walking speed
                    elseif x >= 37.4 and not reached_center then
                        reached_center = true
                    end
                    if reached_center then
                        if TIMEOUT_WIN >= 0 then
                            TIMEOUT_WIN = TIMEOUT_WIN + 1
                        end
                        if TIMEOUT_WIN < TIMEOUT_EJECT_TIME then
                            vibrate_chest()
                        end
                        if TIMEOUT_WIN == TIMEOUT_EJECT_TIME then
                            eject_treasure()
                        end
                        if TIMEOUT_WIN == TIMEOUT_SHAKE_TIME then
                            commonlib.shake_camera(200, 480, 1, 1, 1, false)
                            -- message("SHAKE")
                        end
                        if TIMEOUT_WIN == TIMEOUT_FLOW_START then
                            commonlib.play_vanilla_sound(VANILLA_SOUND.SHARED_EXPLOSION, lavastream_sndsrc.uid, 0.5, false)
                            state.camera.shake_multiplier_x = 0.35
                            state.camera.shake_multiplier_y = 0.35
                            -- message("SHAKIER")
                            snd_fireloop_vol = 1
                        end
                        if TIMEOUT_WIN >= TIMEOUT_FLOW_START then
                            flow_lava()
                        end
                        if TIMEOUT_WIN == TIMEOUT_FLOW_START + TIMEOUT_PLATFORM_BUFFER then
                            endingplatformlib.raise_platform()
                        end
                        if TIMEOUT_WIN == TIMEOUT_END_TIME then
                            end_winscene()
                        end
                    end
                end
            )
        elseif ent.y > 105 then
            --otherwise this is the ship character.
            --spawns typically around 32.4, 111
            -- message(string.format("ship character %s at: %s %s", ent.uid, ent.x, ent.y))

            --lock the ship character where it spawns
            local x, y = ent.x, ent.y
            ent.flags = set_flag(ent.flags, ENT_FLAG.INVISIBLE)
            ent:set_post_update_state_machine(
                ---@param self Movable | Entity | Player
                function (self)
                    self.x = x
                    self.y = y
                end
            )
        end
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)

set_callback(function ()
    if state.loading == 2 then
        if state.screen == SCREEN.WIN then
            state.screen_next = SCREEN.SCORES
        end
        -- if state.screen == SCREEN.RECAP then
        --     state.screen_next = SCREEN.CREDITS
        -- end
        -- if state.screen == SCREEN.CREDITS then
        --     state.screen_next = SCREEN.CAMP
        -- end
    end
end, ON.PRE_UPDATE)

local theme_win = CustomTheme:new(100, THEME.OLMEC)
theme_win:override(THEME_OVERRIDE.SPAWN_EFFECTS, THEME.DWELLING)
theme_win:override(THEME_OVERRIDE.SPAWN_BACKGROUND, THEME.DWELLING)
theme_win:override(THEME_OVERRIDE.SPAWN_DECORATION, THEME.DWELLING)
theme_win.textures[DYNAMIC_TEXTURE.FLOOR] = TEXTURE.DATA_TEXTURES_FLOOR_CAVE_0
theme_win.textures[DYNAMIC_TEXTURE.BACKGROUND] = TEXTURE.DATA_TEXTURES_BG_CAVE_0

local theme_win_hard = CustomTheme:new(101, THEME.VOLCANA)
theme_win_hard:override(THEME_OVERRIDE.SPAWN_EFFECTS, THEME.VOLCANA)
theme_win_hard:override(THEME_OVERRIDE.SPAWN_BACKGROUND, THEME.VOLCANA)
theme_win_hard:override(THEME_OVERRIDE.SPAWN_DECORATION, THEME.VOLCANA)
theme_win_hard.textures[DYNAMIC_TEXTURE.FLOOR] = TEXTURE.DATA_TEXTURES_FLOOR_VOLCANO_0
theme_win_hard.textures[DYNAMIC_TEXTURE.BACKGROUND] = TEXTURE.DATA_TEXTURES_BG_VOLCANO_0
theme_win_hard:override(THEME_OVERRIDE.GRAVITY, THEME.VOLCANA)

set_callback(function(ctx)
    if state.screen == SCREEN.WIN then
        if state.win_state == WIN_STATE.TIAMAT_WIN then
            force_custom_theme(theme_win)
        elseif state.win_state == WIN_STATE.HUNDUN_WIN then
            force_custom_theme(theme_win_hard)
        end
    end
end, ON.PRE_LOAD_LEVEL_FILES)
