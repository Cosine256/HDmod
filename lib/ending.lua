local ladderlib = require('lib.entities.ladder')
local endingplatformlib = require('lib.entities.endingplatform')

local chest

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

-- Can't prevent the ship from spawning because it crashes after 5 seconds (I believe this is because the ship character teleports into lava)
set_pre_entity_spawn(function (entity_type, x, y, layer, overlay_entity, spawn_flags)
    message("ENDINGSHIP!")
	if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then return spawn_entity(ENT_TYPE.FX_SHADOW, x, y, layer, 0, 0) end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_PARENTSSHIP, ENT_TYPE.ITEM_OLMECSHIP)


local function end_winscene()
    ---@type TreasureHook | Entity | Movable
    local hook = get_entity(spawn_entity(ENT_TYPE.ITEM_EGGSHIP_HOOK, 42.5, 117, LAYER.FRONT, 0, 0))
    spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN, 42.5, 117, LAYER.FRONT)

    -- set_post_statemachine(hook.uid, function (self)
    --     if self:get_behavior() ~= 5 then
    --         self:set_behavior(5)
    --     end
    -- end)
end

---@param hard boolean
local function create_ending_treasure(x, y, l, vx, vy, hard)
    local ent = get_entity(spawn_entity(ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, x, y, l, vx, vy))
    return ent.uid
end

-- burst open treasure chest
local function eject_ending_treasure()
    -- set the ending treasure chest to the open texture
    chest.animation_frame = 8
    -- particle effects
    -- create_ending_treasure
    create_ending_treasure(42.5, 105.75, LAYER.FRONT, -0.115, 0.175, state.win_state == WIN_STATE.HUNDUN_WIN)
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
        -- TODO: This currently affects the ending ship character. Filter this character out.
        message("YOU WINNED")
        ent.flags = clr_flag(ent.flags, ENT_FLAG.STUNNABLE)
        local reached_center = false
        ent:set_post_update_state_machine(
            ---@param self Movable | Entity | Player
            function (self)
                local x, _, _ = get_position(ent.uid)
                -- continue walking until you get to the center of the platform
                if x > 34.5 and x < 37.5 then
                    -- don't trip
                    if self.velocityy >= 0.090 then
                        self.velocityy = 0
                    end
                    -- This appears to animate guy as well.
                    ent.velocityx = 0.072--0.105 is ana's intro walking speed
                elseif x >= 37.5 and not reached_center then
                    reached_center = true
                    eject_ending_treasure()
                    end_winscene()
                end
            end
        )
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)

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

set_callback(function()
    if state.loading == 2 and state.screen_next == SCREEN.WIN then
        if state.win_state == WIN_STATE.TIAMAT_WIN then
            -- The game will crash if it tries to generate the win level with the Olmec theme. Force the temple theme instead.
            state:force_current_theme(THEME.TEMPLE)
        elseif state.win_state == WIN_STATE.HUNDUN_WIN then
            -- TODO: The win level contains styled floors, but the volcana theme does not have a styled floor. Volcana's styled floors generate as totem traps and the win level becomes completely broken. Force the Hundun theme as a workaround until the volcana generation is fixed.
            state:force_current_theme(THEME.HUNDUN)
        end
    end
end, ON.LOADING)