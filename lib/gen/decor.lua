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
    SUN = 53,
    SKY = 53,
}

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