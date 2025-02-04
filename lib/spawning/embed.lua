local module = {}

--- table to keep track of items embedded by script, to not replace them later
module.script_embedded_item_uids = {}
---@param embed_uid integer
---@param floor_uid integer
---@param visible boolean?
function module.embed_item(embed_uid, floor_uid, visible)
	attach_entity(floor_uid, embed_uid)
	local embed_ent = get_entity(embed_uid)
	embed_ent.special_offsetx = 0
	embed_ent.flags = set_flag(embed_ent.flags, ENT_FLAG.NO_GRAVITY)
	embed_ent.flags = clr_flag(embed_ent.flags, ENT_FLAG.COLLIDES_WALLS)
	embed_ent:set_draw_depth(9)
	if not visible then
		embed_ent.flags = set_flag(embed_ent.flags, ENT_FLAG.INVISIBLE)
	end
	module.script_embedded_item_uids[embed_uid] = true
	return 0;
end

function module.remove_and_embed_item(embed_type, floortype_to_spawn, x, y, l)
	local floor_uid = spawn_grid_entity(floortype_to_spawn, x, y, l)
	removelib.remove_embedded_at(x, y, l)
	return module.embed_item(spawn_entity(embed_type, x, y, l, 0, 0), floor_uid)
end

return module