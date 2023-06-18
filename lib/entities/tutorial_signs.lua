local commonlib = require 'lib.common'
local arrowtraplib = require 'lib.entities.arrowtrap'

local module = {}

local SIGN_SIZE <const> = {
    SHORT = 1,
    LONG = 2
}

local long_texture_id
local short_texture_id
do
    local long_texture_def = TextureDefinition.new();
    long_texture_def.width = 1024;
    long_texture_def.height = 1024;
    long_texture_def.tile_width = 512;
    long_texture_def.tile_height = 256;
    long_texture_def.texture_path = 'res/deco_tutorial_hd.png';
    long_texture_id = define_texture(long_texture_def);

	---@type TextureDefinition
    local short_texture_def = TextureDefinition.new();
    short_texture_def.width = 1024;
    short_texture_def.height = 1024;
    short_texture_def.sub_image_height = 256;
    short_texture_def.sub_image_width = 1024;
	short_texture_def.sub_image_offset_x = 0;
	short_texture_def.sub_image_offset_y = 768;
    short_texture_def.tile_width = 256;
    short_texture_def.tile_height = 256;
    short_texture_def.texture_path = 'res/deco_tutorial_hd.png';
    short_texture_id = define_texture(short_texture_def);
end

--[[

    Seems like when you change your button settings, the game sees what animation frame the FX button has and changes that to the appropriate key.

    long signs:
        height: 5
        width: 2.5

    small signs:
        height: 2.4
        width: 2.4

    example:

    signs: [
        {
            length = SIGN_SIZE.SHORT,
            frame = 4
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 2,
            buttons: {
                {
                    offset_x = 0.4,
                    offset_y = 0.5,
                    default_movement_run = true, -- Show this button when the current user's controls are set to run
                    input = 
                },
                {
                    offset_x = -0.4,
                    offset_y = 0.5,
                    default_movement_walk = true, -- Show this button when the current user's controls are set to walk
                },
            }
        },
    ]
]]

local SIGNS = {
    {
        {
            length = SIGN_SIZE.LONG,
            frame = 0,
            buttons = {
                {
                    offset_x = -1.45,
                    offset_y = 0,
                    input = INPUTS.JUMP
                },
            }
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 4,
            buttons = { -- run button "+" jump button
                {
                    offset_x = 1.1,
                    offset_y = -0.05,
                    input = INPUTS.JUMP,
                    default_movement_run = true,
                },
                {
                    offset_x = 0.55,
                    offset_y = -0.05,
                    input = INPUTS.RUN,
                    default_movement_walk = true,
                },
                {
                    offset_x = 1.6,
                    offset_y = -0.05,
                    input = INPUTS.JUMP,
                    default_movement_walk = true,
                },
            }
        },
        {
            length = SIGN_SIZE.SHORT,
            frame = 0,
            buttons = {
                {
                    offset_x = 0.45,
                    offset_y = 0.475,
                    input = INPUTS.UP
                },
                {
                    offset_x = 0.45,
                    offset_y = -0.5,
                    input = INPUTS.DOWN
                },
            }
        },
    },
    {
        {
            length = SIGN_SIZE.LONG,
            frame = 1,
            buttons = {
                {
                    offset_x = 1.4,
                    offset_y = 0,
                    input = INPUTS.WHIP
                },
            }
        },
        {
            length = SIGN_SIZE.SHORT,
            frame = 1,
            buttons = {
                {
                    offset_x = -0.45,
                    offset_y = 0,
                    input = INPUTS.ROPE
                },
            }
        },
        {
            length = SIGN_SIZE.SHORT,
            frame = 2,
            buttons = { -- down button "+" bomb button
                {
                    offset_x = -0.5,
                    offset_y = 0.5,
                    input = INPUTS.DOWN
                },
                {
                    offset_x = 0.5,
                    offset_y = 0.5,
                    input = INPUTS.BOMB
                },
            }
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 2,
            buttons = { -- left button "+" run button
                {
                    offset_x = 1.1,
                    offset_y = 0.4,
                    input = INPUTS.LEFT,
                    default_movement_run = true,
                },
                {
                    offset_x = 0.5,
                    offset_y = 0.4,
                    input = INPUTS.LEFT,
                    default_movement_walk = true,
                },
                {
                    offset_x = 1.5,
                    offset_y = 0.4,
                    input = INPUTS.RUN,
                    default_movement_walk = true,
                },
            }
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 4,
            buttons = { -- run button "+" jump button
                {
                    offset_x = 1.1,
                    offset_y = -0.05,
                    input = INPUTS.JUMP,
                    default_movement_run = true,
                },
                {
                    offset_x = 0.55,
                    offset_y = -0.05,
                    input = INPUTS.RUN,
                    default_movement_walk = true,
                },
                {
                    offset_x = 1.6,
                    offset_y = -0.05,
                    input = INPUTS.JUMP,
                    default_movement_walk = true,
                },
            }
        },
    },
    {
        {
            length = SIGN_SIZE.LONG,
            frame = 3,
            buttons = { -- down button "+" whip button
                {
                    offset_x = -1.55,
                    offset_y = 0.4,
                    input = INPUTS.DOWN
                },
                {
                    offset_x = -0.35,
                    offset_y = 0.4,
                    input = INPUTS.WHIP
                },
            }
        },
        {
            arrowtrap = true
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 5
        },
    },
}

local sign_index

function module.init()
    sign_index = 1
end

local function create_button(sign, button_input, offset_x, offset_y)
    ---@type Entity | Button
    local button = get_entity(spawn_entity_over(ENT_TYPE.FX_BUTTON, sign.uid, offset_x, offset_y))
    button:set_draw_depth(44)
    local texture_id = button:get_texture()
    if (
        texture_id == TEXTURE.DATA_TEXTURES_HUD_CONTROLLER_BUTTONS_0
        or texture_id == TEXTURE.DATA_TEXTURES_HUD_CONTROLLER_BUTTONS_1--xbox
        or texture_id == TEXTURE.DATA_TEXTURES_HUD_CONTROLLER_BUTTONS_2--playstation
        or texture_id == TEXTURE.DATA_TEXTURES_HUD_CONTROLLER_BUTTONS_3--switch
    ) then
        if button_input == INPUTS.JUMP then
            button.animation_frame = 0
        elseif button_input == INPUTS.BOMB then
            button.animation_frame = 1
        elseif button_input == INPUTS.WHIP then
            button.animation_frame = 2
        elseif button_input == INPUTS.ROPE then
            button.animation_frame = 3
        elseif button_input == INPUTS.RUN then
            button.animation_frame = 7
        elseif button_input == INPUTS.UP then
            button.animation_frame = 11
        elseif button_input == INPUTS.DOWN then
            button.animation_frame = 12
        elseif button_input == INPUTS.LEFT then
            button.animation_frame = 13
        elseif button_input == INPUTS.RIGHT then
            button.animation_frame = 14
        end
    elseif texture_id == TEXTURE.DATA_TEXTURES_KEYBOARD_BUTTONS_0 then--keyboard
        if button_input == INPUTS.JUMP then
            button.animation_frame = 0
        elseif button_input == INPUTS.BOMB then
            button.animation_frame = 2
        elseif button_input == INPUTS.WHIP then
            button.animation_frame = 1
        elseif button_input == INPUTS.ROPE then
            button.animation_frame = 3
        elseif button_input == INPUTS.RUN then
            button.animation_frame = 4
        elseif button_input == INPUTS.UP then
            button.animation_frame = 10
        elseif button_input == INPUTS.DOWN then
            button.animation_frame = 11
        elseif button_input == INPUTS.LEFT then
            button.animation_frame = 8
        elseif button_input == INPUTS.RIGHT then
            button.animation_frame = 9
        end
    end
end

function module.create_tutorial_sign(x, y, l)
    local sign_data = SIGNS[state.level][sign_index]

    if sign_data.arrowtrap then
        set_timeout(function ()
            arrowtraplib.create_arrowtrap(x, y, l)
        end, 1)
    else
        local sign = get_entity(spawn_entity(ENT_TYPE.BG_TUTORIAL_SIGN_BACK, x, y, l, 0, 0))
        if sign_data.length == SIGN_SIZE.LONG then
            sign:set_texture(long_texture_id)
            sign.width = 5
            sign.height = 2.5
        elseif sign_data.length == SIGN_SIZE.SHORT then
            sign:set_texture(short_texture_id)
            sign.width = 2.4
            sign.height = 2.4
        end
        sign.animation_frame = sign_data.frame
        if sign_data.buttons then
            for _, button_data in pairs(sign_data.buttons) do
                if (
                    button_data.offset_x
                    and button_data.offset_y
                    and button_data.input
                ) then
                    local movement_context_sensitive = (
                        button_data.default_movement_run
                        or button_data.default_movement_walk
                    )
                    local default_set_to_run = state.player_inputs.player_settings[1].auto_run_enabled
                    if (
                        (
                            movement_context_sensitive
                            and (
                                (
                                    default_set_to_run and button_data.default_movement_run
                                )
                                or (
                                    not default_set_to_run and button_data.default_movement_walk
                                )
                            )
                        )
                        or not movement_context_sensitive
                    ) then
                        create_button(sign, button_data.input, button_data.offset_x, button_data.offset_y)
                    end
                end
            end
        end
    end

    sign_index = sign_index + 1
end

return module