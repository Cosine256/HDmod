local module = {}
local decorlib = require('lib.gen.decor')
local minigamelib = require('lib.entities.minigame')

local idol_texture_id
local idol_normal_texture_id
do
    local idol_texture_def = TextureDefinition.new()
    idol_texture_def.width = 512
    idol_texture_def.height = 512
    idol_texture_def.tile_width = 512
    idol_texture_def.tile_height = 512
    idol_texture_def.texture_path = "res/ending_giantidol.png"
    idol_texture_id = define_texture(idol_texture_def)

    local idol_normal_texture_def = TextureDefinition.new()
    idol_normal_texture_def.width = 512
    idol_normal_texture_def.height = 512
    idol_normal_texture_def.tile_width = 512
    idol_normal_texture_def.tile_height = 512
    idol_normal_texture_def.texture_path = "res/ending_giantidol_normal.png"
    idol_normal_texture_id = define_texture(idol_normal_texture_def)
end

local MINIGAME_INTRO_STATE <const> = {
    PRE_MINIGAME = 0,
    RUNNING_TO_CENTER = 1,
    PROTECT_INDICATOR = 2,
    FINISHED_MINIGAME_INTRO = 3,
}

---treasure
---@param ent Treasure | HundunChest
function module.set_ending_treasure(ent)
    ent:set_texture(
        -- state.win_state == WIN_STATE.HUNDUN_WIN and yama_treasure_id or
        idol_texture_id)
    ent.rendering_info:set_normal_map_texture(
        -- state.win_state == WIN_STATE.HUNDUN_WIN and yama_treasure_normal_id or
    idol_normal_texture_id)
    ent.rendering_info.shader = 30

    ent.hitboxx = 1.150
    if state.screen == SCREEN.CREDITS then
        ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    end
    if state.screen == SCREEN.SCORES then
        ent:set_post_update_state_machine(
        ---@param self HundunChest | Treasure    
        function (self)
            self.move_state = 0
        end)
    end
end

function module.create_ending_treasure(x, y, l, vx, vy)
    local ent = get_entity(spawn_entity(ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, x, y, l, vx, vy))
    module.set_ending_treasure(ent)
    return ent.uid
end

local function update_treasure(self)
    if not decorlib.CREDITS_SCROLLING then
        -- move the entity to the left until decorlib.CREDITS_SCROLL is true
        self.velocityx = -0.095
    end
    if self.user_data.state == MINIGAME_INTRO_STATE.PRE_MINIGAME then
        if minigamelib.started_minigame() then
            self.user_data.state = MINIGAME_INTRO_STATE.RUNNING_TO_CENTER
            message("RUNNING_TO_CENTER")
        end
    elseif self.user_data.state == MINIGAME_INTRO_STATE.RUNNING_TO_CENTER then
        local x, _, _ = get_position(self.uid)
        if x > 14.5 then
            self.velocityx = -0.095
        else
            self.user_data.state = MINIGAME_INTRO_STATE.PROTECT_INDICATOR
            self.user_data.timeout = 300
            message("PROTECT_INDICATOR")
        end
    elseif self.user_data.state == MINIGAME_INTRO_STATE.PROTECT_INDICATOR then
        if self.user_data.timeout > 0 then
            self.user_data.timeout = self.user_data.timeout - 1
        else
            self.user_data.state = MINIGAME_INTRO_STATE.FINISHED_MINIGAME_INTRO
            message("FINISHED_MINIGAME_INTRO")
        end
    elseif self.user_data.state == MINIGAME_INTRO_STATE.FINISHED_MINIGAME_INTRO then
        -- SORRY NOTHING
    end
end

function module.create_credits_treasure(x, y, l)
    -- use a no-gravity rock as a base
    local base = get_entity(spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_ROCK, x, y, l))
    local _, _y, _ = get_position(base.uid)

    -- base.flags = set_flag(base.flags, ENT_FLAG.NO_GRAVITY)
    base.flags = set_flag(base.flags, ENT_FLAG.INVISIBLE)
    base.flags = set_flag(base.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
    -- base.flags = set_flag(base.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)

    -- spawn the cavemen and treasure offset from rock base
    local treasure = get_entity(module.create_ending_treasure(x, _y+2.65, l, 0, 0))
    attach_entity(base.uid, treasure.uid)
    -- # TODO: move treasure in a sine-wave **use yama's phase 2 as an example
    -- probably will do this via states inside treasure.user_data

    base.user_data = {
        state = MINIGAME_INTRO_STATE.PRE_MINIGAME,
        timeout = 0
    }
    set_post_statemachine(base.uid, update_treasure)
    
    --[[
        # TODO: Create a state-animated indicator using PRE_RENDER_DEPTH
        - Toggle drawing it using states and timers
        - if the screen changes
        - or it doesn't and reaches a specific state
            - clear the callback
    ]]
    set_callback(function(render_ctx, draw_depth)
        if state.screen ~= SCREEN.INTRO
        or state.screen == SCREEN.INTRO
        and base.user_data.state == MINIGAME_INTRO_STATE.FINISHED_MINIGAME_INTRO then
            clear_callback()
        else
            if draw_depth == 44 -- die/transporter indicator entitie's draw depth
            -- Render both text and indicator based on timeout
            -- sine(timeout*0.25) > 0
            then
                -- Draw indicator at the same dimensions as the FX entity
                -- TEXTURE.DATA_TEXTURES_HUD_0
                -- Draw text offset
            end
        end
    end, ON.RENDER_PRE_DRAW_DEPTH)

    return base.uid
end

return module