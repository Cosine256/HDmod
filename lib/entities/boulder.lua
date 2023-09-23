local module = {}
local idollib = require('lib.entities.idol')

-- # TODO: Remove this option
optionslib.register_option_bool("hd_debug_boulder_info", "Boulder - Show info", nil, false, true)

set_post_entity_spawn(
---@param ent Boulder
function (ent, spawn_flags)
    set_timeout(function ()
        ent.last_owner_uid = idollib.IDOL_OWNER
        if options.hd_debug_boulder_info == true then
            message(string.format("APPLIED IDOL OWNER %s", ent.last_owner_uid))
        end
    end, 1)
    ent:set_pre_kill(function(self, destroy_corpse, responsible)
        if responsible and responsible.type.search_flags == MASK.ACTIVEFLOOR then
            kill_entity(responsible.uid, false)
            return true
        end
        return false
    end)
end, SPAWN_TYPE.ANY, MASK.ACTIVEFLOOR, ENT_TYPE.ACTIVEFLOOR_BOULDER)

return module