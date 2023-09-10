local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local introguylib = require('lib.entities.introguy')
local module = {}

set_callback(function()
    surfacelib.decorate_existing_surface()

    ---@type Rockdog | Mount | Entity | Movable | PowerupCapable
    local camel = get_entity(camellib.create_camel(7, 100, LAYER.FRONT))
    spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)

    ---@type Entity | Movable | Player
    local guy = get_entity(introguylib.create_intro_guy(7, 100, camel.uid))--x = 16
    spawn_entity_over(ENT_TYPE.FX_SHADOW, guy.uid, 0, 0)

    carry(camel.uid, guy.uid)
    camellib.set_camel_intro_walk_in(camel, guy.uid)
end, ON.INTRO)

return module