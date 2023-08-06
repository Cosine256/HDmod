local module = {}

module.SPAWNED_20 = false
module.SPAWNED_40 = false
module.SPAWNED_60 = false
module.SPAWNED_80 = false

function module.init()
    module.SPAWNED_20 = false
    module.SPAWNED_40 = false
    module.SPAWNED_60 = false
    module.SPAWNED_80 = false
end

set_callback(function ()
	module.init()
end, ON.START)

return module