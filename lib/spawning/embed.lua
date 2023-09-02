local module = {}

function module.embed_item(type, floor_uid, frame)
	local x, y, l = get_position(floor_uid)
	removelib.remove_embedded_at(x, y, l)

	local embed_ent = get_entity(spawn_entity_over(type, floor_uid, 0, 0))

	-- attach_entity(floor_uid, embed_uid)
	embed_ent.special_offsetx = 0
	embed_ent.flags = set_flag(embed_ent.flags, ENT_FLAG.NO_GRAVITY)
	embed_ent.flags = clr_flag(embed_ent.flags, ENT_FLAG.COLLIDES_WALLS)
	embed_ent:set_draw_depth(9)
	-- if not gold then
		embed_ent.flags = set_flag(embed_ent.flags, ENT_FLAG.INVISIBLE)
	-- end
	return 0;
end

return module