local module = {}
local cog_door_stone_texture_id
do
	local cog_door_stone_texture_def = TextureDefinition.new() --[[@as TextureDefinition]]
	cog_door_stone_texture_def.width = 384
	cog_door_stone_texture_def.height = 640
	cog_door_stone_texture_def.tile_width = 384
	cog_door_stone_texture_def.tile_height = 320

	cog_door_stone_texture_def.texture_path = "res/cog_entrance_doors_stone.png"
	cog_door_stone_texture_id = define_texture(cog_door_stone_texture_def)
end


function module.create_cog_door(x, y, layer)
	local door_target_uid = spawn_grid_entity(ENT_TYPE.FLOOR_DOOR_COG, x, y, layer)
	spawn_entity(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y-1, layer, 0, 0)
	local _w, _l, _t = state.world, 3, THEME.CITY_OF_GOLD
	set_door_target(door_target_uid, _w, _l, _t)
	if options.hd_og_floorstyle_temple then
		local bg_door = get_entity(door_target_uid + 3)
		bg_door:set_texture(cog_door_stone_texture_id)
	end
end

return module
