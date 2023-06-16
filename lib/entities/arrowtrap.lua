local module = {}

local gold_texture_id
local temple_texture_id
do
    local temple_texture_def = get_texture_definition(TEXTURE.DATA_TEXTURES_FLOORMISC_0)
	temple_texture_def.width = 128
	temple_texture_def.height = 128
	temple_texture_def.tile_width = 128
	temple_texture_def.tile_height = 128
    temple_texture_def.texture_path = "res/arrowtrap_temple.png"
    temple_texture_id = define_texture(temple_texture_def)

    local gold_texture_def = get_texture_definition(TEXTURE.DATA_TEXTURES_FLOORMISC_0)
	gold_texture_def.width = 128
	gold_texture_def.height = 128
	gold_texture_def.tile_width = 128
	gold_texture_def.tile_height = 128
    gold_texture_def.texture_path = "res/arrowtrap_gold.png"
    gold_texture_id = define_texture(gold_texture_def)
end

function module.create_arrowtrap(x, y, l)
	removelib.remove_floor_and_embedded_at(x, y, l)
    local entity = get_entity(spawn_grid_entity(ENT_TYPE.FLOOR_ARROW_TRAP, x, y, l))
    local left = validlib.is_solid_grid_entity(x-1, y, l)
    local right = validlib.is_solid_grid_entity(x+1, y, l)
	local flip = false
	if not left and not right then
		if prng:random_chance(2, PRNG_CLASS.LEVEL_GEN) then
			flip = true
		end
	elseif not left then
		flip = true
	end
	if flip == true then
		flip_entity(entity.uid)
	end
	if test_flag(state.level_flags, 18) == true then
		spawn_entity_over(ENT_TYPE.FX_SMALLFLAME, entity.uid, 0, 0.35)
	end

	if state.theme == THEME.TEMPLE and not options.hd_og_floorstyle_temple then
		entity:set_texture(temple_texture_id)
	elseif state.theme == THEME.CITY_OF_GOLD then
		get_entity(uid):set_texture(gold_texture_id)
		get_entity(uid).user_data = {
			gilded = true;
		}
		entity:set_post_destroy(function (entity)
			spawn(ENT_TYPE.ITEM_NUGGET, x, y, l, prng:random_float(PRNG_CLASS.AI)*0.2-0.1, prng:random_float(PRNG_CLASS.AI)*0.1+0.1)
		end)
	end
end

return module