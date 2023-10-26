---@diagnostic disable: lowercase-global
commonlib = require 'lib.common'
savelib = require 'lib.save'
optionslib = require 'lib.options'
demolib = require 'lib.demo'
worldlib = require 'lib.worldstate'
camplib = require 'lib.camp'
testlib = require 'lib.test'
touchupslib = require 'lib.gen.touchups'
backwalllib = require 'lib.gen.backwall'
require 'lib.gen.lut'
s2roomctxlib = require 'lib.gen.s2roomctx'
roomdeflib = require 'lib.gen.roomdef'
roomgenlib = require 'lib.gen.roomgen'
tiledeflib = require 'lib.gen.tiledef'
feelingslib = require 'lib.feelings'
unlockslib = require 'lib.unlocks'
cooplib = require 'lib.coop'
locatelib = require 'lib.locate'
custommusiclib = require 'lib.music.custommusic'
require 'lib.ending'
require 'lib.credits'
require 'lib.intro'
require 'lib.scores'

validlib = require 'lib.spawning.valid'
spawndeflib = require 'lib.spawning.spawndef'
createlib = require 'lib.spawning.create'
removelib = require 'lib.spawning.remove'
embedlib = require 'lib.spawning.embed'
hdtypelib = require 'lib.entities.hdtype'
botdlib = require 'lib.entities.botd'
wormtonguelib = require 'lib.entities.wormtongue'
ghostlib = require 'lib.entities.ghost'
olmeclib = require 'lib.entities.olmec'
boulderlib = require 'lib.entities.boulder'
idollib = require 'lib.entities.idol'
liquidlib = require 'lib.entities.liquid'
treelib = require 'lib.entities.tree'
moailib = require 'lib.entities.moai'
doorslib = require 'lib.entities.doors'
tombstonelib = require 'lib.entities.tombstone'
flagslib = require 'lib.flags'
decorlib = require 'lib.gen.decor'
snowballlib = require 'lib.entities.snowball'
crystalmonkeylib = require 'lib.entities.crystal_monkey'
shopslib = require 'lib.entities.shops'
require "lib.entities.mammoth"
require "lib.entities.hdentnew"
require "lib.entities.custom_death_messages"

meta.name = "HDmod - Demo"
meta.version = "1.05"
meta.description = "Spelunky HD's campaign in Spelunky 2"
meta.author = "Super Ninja Fat"

optionslib.register_option_bool("hd_debug_info_boss", "Boss - Show info", nil, false, true)
optionslib.register_option_bool("hd_debug_scripted_enemies_show", "Enable visibility of entities used in custom entity behavior", nil, false, true)
optionslib.register_option_bool("hd_debug_scripted_levelgen_disable", "Level gen - Disable scripted level generation", nil, false, true)

set_callback(function()
	game_manager.screen_title.ana_right_eyeball_torch_reflection.x, game_manager.screen_title.ana_right_eyeball_torch_reflection.y = -0.7025, 0.165
	game_manager.screen_title.ana_left_eyeball_torch_reflection.x, game_manager.screen_title.ana_left_eyeball_torch_reflection.y = -0.62, 0.1725
end, ON.TITLE)

set_callback(function(room_gen_ctx)
	embedlib.script_embedded_item_uids = {}
	if state.screen == SCREEN.LEVEL then
		-- state.level_flags = set_flag(state.level_flags, 18) --force dark level
		-- message(F'ON.POST_ROOM_GENERATION - ON.LEVEL: {state.time_level}')

		if options.hd_debug_scripted_levelgen_disable == false then

			roomgenlib.assign_s2_level_height()

			cooplib.detect_coop_coffin(room_gen_ctx)

			s2roomctxlib.unmark_setrooms(room_gen_ctx)

			-- Perform script-generated chunk creation
			roomgenlib.onlevel_generation_modification()

			shopslib.set_blackmarket_shoprooms(room_gen_ctx)

			s2roomctxlib.assign_s2_room_templates(room_gen_ctx)

			roomgenlib.onlevel_generation_execution_phase_one()
			roomgenlib.onlevel_generation_execution_phase_two()

			spawndeflib.set_chances(room_gen_ctx)
		else
			s2roomctxlib.assign_s2_room_templates(room_gen_ctx)
		end

	end
end, ON.POST_ROOM_GENERATION)

--On post_spawn_traps because it's after borders spawned, maybe could work anyway if checking for out of bounds
for _, theme in pairs(THEME) do
	if not commonlib.has({THEME.ARENA, THEME.BASE_CAMP}, theme) then
		state.level_gen.themes[theme]:set_post_spawn_traps(spawndeflib.handle_trap_spawns)
	end
end

set_callback(function()
	if state.screen == SCREEN.LEVEL then

		roomgenlib.onlevel_generation_execution_phase_three()

		--[[
			Procedural Spawn post_level_generation stuff
		--]]
		if options.hd_debug_scripted_levelgen_disable == false then
			if (
				worldlib.HD_WORLDSTATE_STATE == worldlib.HD_WORLDSTATE_STATUS.NORMAL
			) then
				tombstonelib.set_ash_tombstone()

				touchupslib.replace_s2_crust_items()

				backwalllib.set_backwall_bg()

				decorlib.change_decorations()

				treelib.postlevelgen_decorate_trees()

				touchupslib.postlevelgen_remove_items()

				touchupslib.postlevelgen_spawn_dar_fog()

				touchupslib.postlevelgen_fix_door_ambient_sound()

				touchupslib.postlevelgen_replace_wooden_shields()

				touchupslib.postlevelgen_spawn_walltorches()

				shopslib.postlevelgen_fix_customshop_sign()
			end
		end
	end
end, ON.POST_LEVEL_GENERATION)

set_callback(function()
	-- message(F'ON.LEVEL: {state.time_level}')
	touchupslib.onlevel_touchups()

	olmeclib.onlevel_olmec_init()

	feelingslib.onlevel_toastfeeling()

	liquidlib.spawn_liquid_illumination()
end, ON.LEVEL)