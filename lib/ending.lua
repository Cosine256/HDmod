local ladderlib = require('lib.entities.ladder')
local endingplatformlib = require('lib.entities.endingplatform')

local chest

set_callback(function ()
    chest = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN, 42.500, 105.4, LAYER.FRONT))
    for _, uid in pairs(get_entities_by_type(ENT_TYPE.MIDBG)) do
        get_entity(uid):destroy()
    end
    -- spawn bg ouroboro
    local ouroboro = get_entity(spawn_entity(ENT_TYPE.BG_OUROBORO, 37.5, 107, LAYER.FRONT, 0, 0))
    if state.win_state == WIN_STATE.HUNDUN_WIN then
        ouroboro.color.r = 1
        ouroboro.color.g = 0.31
        ouroboro.color.b = 0.31
    end

    -- backwalls
    local backwalls = get_entities_by(ENT_TYPE.BG_LEVEL_BACKWALL, 0, LAYER.FRONT)
    if #backwalls > 0 then
        get_entity(backwalls[1]):set_texture(state.win_state == WIN_STATE.HUNDUN_WIN and TEXTURE.DATA_TEXTURES_BG_VOLCANO_0 or TEXTURE.DATA_TEXTURES_BG_CAVE_0)
    end
    if state.win_state == WIN_STATE.HUNDUN_WIN then
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
    local hook = get_entity(spawn_entity(ENT_TYPE.ITEM_EGGSHIP_HOOK, 42.5, 117, LAYER.FRONT, 0, 0))--spawn in hook at the location, force behavior to 5

    --This isn't working. Maybe spawning temporary treasure with the hook would trigger the end?

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
    create_ending_treasure(42.500, 105.75, LAYER.FRONT, -0.115, 0.175, state.win_state == WIN_STATE.HUNDUN_WIN)
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
