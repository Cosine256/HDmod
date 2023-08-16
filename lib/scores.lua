local surfacelib = require('lib.surface')
local endingtreasurelib = require('lib.entities.endingtreasure')

set_callback(function ()
    surfacelib.decorate_existing_surface()

	state.camera.bounds_top = 109.6640
	-- state.camera.bounds_bottom = 
	-- state.camera.bounds_left = 
	-- state.camera.bounds_right = 

	state.camera.adjusted_focus_x = 17.00
	state.camera.adjusted_focus_y = 100.050
end, ON.SCORES)

set_post_entity_spawn(function (entity)
	if state.screen == SCREEN.SCORES then
        endingtreasurelib.set_ending_treasure(entity)
    end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN)
