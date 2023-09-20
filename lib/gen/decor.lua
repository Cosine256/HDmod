snowlib = require 'lib.entities.snow'
treelib = require 'lib.entities.tree'
gargoylelib = require 'lib.entities.gargoyle'
touchupslib = require 'lib.gen.touchups'
shopslib = require 'lib.entities.shops'

local module = {}

module.SURFACE_BG_DEPTH = {
    FOREGROUND = 5,
    BACKWALL = 49,
    BACKGROUND = 50,
    -- FRONT_BACKGROUND = 50,
    MID_BACKGROUND = 51,
    BACK_BACKGROUND = 52,
    CLOUDS = 52,
    SUN = 53,
    SKY = 53,
}

module.CREDITS_VOLCANO_DEPTH = {
    FLUNG_ENTS = 1,
    PARTICLES = 1,
    VOLCANO = 1,--4,
    SKY = 1,--4,
}

module.SURFACE_BG_WIDTH = 60
module.SURFACE_BG_CENTER = 25

module.CREDITS_SCROLLING = false

local SURFACE_BG_SPEED = {}
SURFACE_BG_SPEED[module.SURFACE_BG_DEPTH.FOREGROUND] = 0.02
SURFACE_BG_SPEED[module.SURFACE_BG_DEPTH.BACKGROUND] = 0.02
SURFACE_BG_SPEED[module.SURFACE_BG_DEPTH.MID_BACKGROUND] = 0.015
SURFACE_BG_SPEED[module.SURFACE_BG_DEPTH.BACK_BACKGROUND] = 0.01

function module.get_surface_bg_speed(depth)
    return SURFACE_BG_SPEED[depth] and SURFACE_BG_SPEED[depth] or 0
end

local function add_decorations()
    snowlib.add_snow_to_floor()
    treelib.onlevel_decorate_haunted()
    gargoylelib.add_gargoyles_to_hc()
    shopslib.add_shop_decorations()
end

local function remove_decorations()
	touchupslib.remove_boulderstatue()
	touchupslib.remove_neobab_decorations()
end

function module.change_decorations()
    add_decorations()
    remove_decorations()
end


return module