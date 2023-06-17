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
                    frame = 
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
            frame = 0
            -- jump button
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 4
            -- run button "+" jump button
        },
        {
            length = SIGN_SIZE.SHORT,
            frame = 0
            -- up button, down button
        },
    },
    {
        {
            length = SIGN_SIZE.LONG,
            frame = 1
            -- whip button
        },
        {
            length = SIGN_SIZE.SHORT,
            frame = 1
            -- rope button
        },
        {
            length = SIGN_SIZE.SHORT,
            frame = 2
            -- down button "+" bomb button
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 2
            -- left button "+" run button
        },
        {
            length = SIGN_SIZE.LONG,
            frame = 4
            -- run button "+" jump button
        },
    },
    {
        {
            length = SIGN_SIZE.LONG,
            frame = 3
            -- down button "+" whip button
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

function module.create_tutorial_sign(x, y, l)
    local sign_data = SIGNS[state.level][sign_index]
    prinspect(sign_index)

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
    end

    -- # TODO: Implement spawning buttons and switching buttons mid-game based on default movement status

    sign_index = sign_index + 1
end

return module