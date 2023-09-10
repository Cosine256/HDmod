local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local ladderlib = require('lib.entities.ladder')
local endingplatformlib = require('lib.entities.endingplatform')
local endingtreasurelib = require('lib.entities.endingtreasure')

local chest
---@type Rockdog | Mount | Entity | Movable | PowerupCapable
local camel

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

end, ON.WIN)

set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
    -- message("ENDINGSHIP!")
    -- message(string.format("ship at: %s %s", x, y))
    --lock the ship at 
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, layer, 0, 0) end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_PARENTSSHIP, ENT_TYPE.ITEM_OLMECSHIP)


local function end_winscene()
    -- message("ENDING WINSCENE!")
    ---@type TreasureHook | Entity | Movable
    local hook = get_entity(spawn_entity(ENT_TYPE.ITEM_EGGSHIP_HOOK, 42.5, 117, LAYER.FRONT, 0, 0))
    spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN, 42.5, 117, LAYER.FRONT)
end

-- burst open treasure chest
local function eject_ending_treasure()
    -- set the ending treasure chest to the open texture
    chest.animation_frame = 8
    -- particle effects
    -- create_ending_treasure
    endingtreasurelib.create_ending_treasure(42.5, 105.75, LAYER.FRONT, -0.0735, 0.2, state.win_state == WIN_STATE.HUNDUN_WIN)
    -- if hard ending, spawn coins as well
end

local function raise_platform()
    -- move and spawn lava in a convincing way to have it 'push' the platform up
    -- move the ending platforms up
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
            ent:set_post_update_state_machine(
                ---@param self Movable | Entity | Player
                function (self)
                    local x, _, _ = get_position(ent.uid)
                    -- continue walking until you get to the center of the platform
                    if x > 34.5 and x < 37.4 then
                        -- don't trip
                        if self.velocityy >= 0.090 then
                            self.velocityy = 0
                        end
                        -- This appears to animate guy as well.
                        ent.velocityx = 0.072--0.105 is ana's intro walking speed
                    elseif x >= 37.4 and not reached_center then
                        reached_center = true
                        eject_ending_treasure()
                    end
                end
            )
        elseif ent.y > 90 then
            --otherwise this is the ship character.
            --spawns typically around 32.4, 111
            -- message(string.format("ship character %s at: %s %s", ent.uid, ent.x, ent.y))

            --trigger ending the scene (otherwise ending it sooner crashes the scores screen)
            local triggered_end_winscene = false
            local timeout_win = 100

            --lock the ship character where it spawns
            local x, y = ent.x, ent.y
            ent.flags = set_flag(ent.flags, ENT_FLAG.INVISIBLE)
            ent:set_post_update_state_machine(
                ---@param self Movable | Entity | Player
                function (self)
                    self.x = x
                    self.y = y
                    
                    if timeout_win > 0 then
                        timeout_win = timeout_win - 1
                    elseif not triggered_end_winscene then
                        triggered_end_winscene = true
                        end_winscene()
                    end
                end
            )
        end
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)



set_callback(function ()
    surfacelib.decorate_surface()
    
	state.camera.bounds_top = 109.6640
	-- state.camera.bounds_bottom = 
	-- state.camera.bounds_left = 
	-- state.camera.bounds_right = 

	state.camera.adjusted_focus_x = 17.00
	state.camera.adjusted_focus_y = 100.050
end, ON.SCORES)



set_callback(function ()
    surfacelib.build_credits_surface()
    spawn_player(1, 23, 111)

    camel = get_entity(camellib.create_camel_credits(23, 111, LAYER.FRONT))
    spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)

    local player = get_entity(players[1].uid)
    carry(camel.uid, player.uid)
end, ON.CREDITS)

set_callback(function()
    -- prevent fading out of the credits screen (when pressing jump or credits end)
    if state.screen == SCREEN.CREDITS
    and state.loading == 1
    then
        local normal_credits_end = true
        for _, player in pairs(players) do
            local input = read_input(player.uid)
            if test_flag(input, INPUT_FLAG.JUMP) then
                normal_credits_end = false
            end
        end
        if not normal_credits_end then
            -- stop loading next scene
            state.loading = 0
        end
    end
end, ON.LOADING)

set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, layer, 0, 0) end
end, SPAWN_TYPE.ANY, 0,
    ENT_TYPE.ITEM_MINIGAME_SHIP,
    ENT_TYPE.ITEM_MINIGAME_UFO,
    ENT_TYPE.ITEM_MINIGAME_BROKEN_ASTEROID,
    ENT_TYPE.ITEM_MINIGAME_ASTEROID,
    ENT_TYPE.BG_SURFACE_MOVING_STAR,
    ENT_TYPE.ITEM_MINIGAME_ASTEROID_BG
)

set_post_entity_spawn(function (entity)
	if state.screen == SCREEN.SCORES then
        endingtreasurelib.set_ending_treasure_texture(entity, state.win_state == WIN_STATE.HUNDUN_WIN)
    end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN)


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
