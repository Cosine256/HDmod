meta.name = "Spelunky HD 2"
meta.version = "1"
meta.description = "Spelunky HD's campaign inside of Spelunky 2"
meta.author = "Super Ninja Fat"

-- uncomment to allow loading unlocks.txt
-- meta.unsafe = true

-- register_option_float("hd_ui_botd_a_w", "UI: botd width", 0.08, 0.0, 99.0)
-- register_option_float("hd_ui_botd_b_h", "UI: botd height", 0.12, 0.0, 99.0)
-- register_option_float("hd_ui_botd_c_x", "UI: botd x", 0.2, -999.0, 999.0)
-- register_option_float("hd_ui_botd_d_y", "UI: botd y", 0.93, -999.0, 999.0)
-- register_option_float("hd_ui_botd_e_squash", "UI: botd uvx shifting rate", 0.25, -5.0, 5.0)

register_option_bool("hd_debug_info_boss", "Debug: Bossfight debug info", false)
register_option_bool("hd_debug_info_boulder", "Debug: Boulder debug info", false)
register_option_bool("hd_debug_info_feelings", "Debug: Level feelings debug info", false)
register_option_bool("hd_debug_info_path", "Debug: Path debug info", true)
register_option_bool("hd_debug_info_tongue", "Debug: Wormtongue debug info", false)
register_option_bool("hd_debug_invis", "Debug: Enable visibility of bts entities (invis ents for custom enemies, etc)", false)
register_option_bool("hd_og_ankhprice", "OG: Set the Ankh price to a constant $50,000 like it was in HD", false)
register_option_bool("hd_og_boulder_agro", "OG: Boulder - Enrage shopkeepers as they did in HD", true)
register_option_bool("hd_og_ghost_nosplit", "OG: Ghost - Prevent the ghost from splitting", false)
register_option_bool("hd_og_ghost_slow", "OG: Ghost - Revert the ghost to its HD speed", false)
register_option_bool("hd_og_ghost_time", "OG: Ghost - Change spawntime from 3:00->2:30 and 2:30->2:00 when cursed.", true)
register_option_bool("hd_og_nocursepot", "OG: Remove all Curse Pots", true)
register_option_bool("hd_test_give_botd", "Testing: Start with the Book of the Dead", true)
register_option_bool("hd_test_unlockbossexits", "Testing: Unlock boss exits", false)
register_option_bool("hd_z_antitrapcuck", "Prevent spawning traps that can cuck you", true)
register_option_bool("hd_z_toastfeeling", "Allow script-enduced feeling messages", true)

-- TODO:
register_option_bool("hd_og_boulder_phys", "OG: Boulder - Adjust to have the same physics as HD", false)

bool_to_number={ [true]=1, [false]=0 }

DANGER_GHOST_UIDS = {}
GHOST_TIME = 10800
GHOST_VELOCITY = 0.7
IDOLTRAP_TRIGGER = false
WHEEL_SPINNING = false
WHEEL_SPINTIME = 700 -- TODO: HD's was 10-11 seconds, convert to this.
ACID_POISONTIME = 270 -- TODO: Make sure it matches with HD, which was 3-4 seconds
TONGUE_ACCEPTTIME = 200
IDOLTRAP_JUNGLE_ACTIVATETIME = 15
wheel_items = {}
global_dangers = {}
global_feelings = {}
global_levelassembly = {}
danger_tracker = {}
LEVEL_PATH = {}
IDOL_X = nil
IDOL_Y = nil
IDOL_UID = nil
BOULDER_UID = nil
BOULDER_SX = nil
BOULDER_SY = nil
BOULDER_SX2 = nil
BOULDER_SY2 = nil
BOULDER_CRUSHPREVENTION_EDGE = 0.15
BOULDER_CRUSHPREVENTION_HEIGHT = 0.3
BOULDER_CRUSHPREVENTION_VELOCITY = 0.16
BOULDER_CRUSHPREVENTION_MULTIPLIER = 2.5
BOULDER_CRUSHPREVENTION_EDGE_CUR = BOULDER_CRUSHPREVENTION_EDGE
BOULDER_CRUSHPREVENTION_HEIGHT_CUR = BOULDER_CRUSHPREVENTION_HEIGHT
TONGUE_UID = nil
TONGUE_BG_UID = nil
HAUNTEDCASTLE_ENTRANCE_UID = nil
BLACKMARKET_ENTRANCE_UID = nil
wheel_speed = 0
wheel_tick = WHEEL_SPINTIME
acid_tick = ACID_POISONTIME
tongue_tick = TONGUE_ACCEPTTIME
idoltrap_timeout = 0
idoltrap_blocks = {}
OLMEC_ID = nil
TONGUE_SEQUENCE = { ["READY"] = 1, ["RUMBLE"] = 2, ["EMERGE"] = 3, ["SWALLOW"] = 4 , ["GONE"] = 5 }
TONGUE_STATE = nil
TONGUE_STATECOMPLETE = false
BOSS_SEQUENCE = { ["CUTSCENE"] = 1, ["FIGHT"] = 2, ["DEAD"] = 3 }
BOSS_STATE = nil
OLMEC_SEQUENCE = { ["STILL"] = 1, ["FALL"] = 2 }
OLMEC_STATE = 0
BOULDER_DEBUG_PLAYERTOUCH = false
HELL_X = 0
BOOKOFDEAD_TIC_LIMIT = 5
BOOKOFDEAD_RANGE = 14
bookofdead_tick = 0
-- bookofdead_tick_min = BOOKOFDEAD_TIC_LIMIT
bookofdead_frames = 4
bookofdead_frames_index = 1
bookofdead_squash = (1/bookofdead_frames) --options.hd_ui_botd_e_squash
PREFIRSTLEVEL_NUM = 40

OBTAINED_BOOKOFDEAD = false

UI_BOTD_IMG_ID, UI_BOTD_IMG_W, UI_BOTD_IMG_H = create_image('bookofdead.png')
UI_BOTD_PLACEMENT_W = 0.08
UI_BOTD_PLACEMENT_H = 0.12
UI_BOTD_PLACEMENT_X = 0.2
UI_BOTD_PLACEMENT_Y = 0.93

RUN_UNLOCK_AREA_CHANCE = 1
RUN_UNLOCK_AREA = {
	DWELLING = false,
	JUNGLE = false,
	ICE_CAVES = false,
	TEMPLE = false
}
RUN_UNLOCK = nil

HD_UNLOCKS = {}
HD_UNLOCKS.STARTER1 = { unlock_id = 19, unlocked = false }			--ENT_TYPE.CHAR_GUY_SPELUNKY
HD_UNLOCKS.STARTER2 = { unlock_id = 03, unlocked = false }			--ENT_TYPE.CHAR_COLIN_NORTHWARD
HD_UNLOCKS.STARTER3 = { unlock_id = 05, unlocked = false }			--ENT_TYPE.CHAR_BANDA
HD_UNLOCKS.STARTER4 = { unlock_id = 06, unlocked = false }			--ENT_TYPE.CHAR_GREEN_GIRL
HD_UNLOCKS.AREA_RAND1 = { unlock_id = 12, unlocked = false }		--ENT_TYPE.CHAR_TINA_FLAN
HD_UNLOCKS.AREA_RAND2 = { unlock_id = 01, unlocked = false }		--ENT_TYPE.CHAR_ANA_SPELUNKY
HD_UNLOCKS.AREA_RAND3 = { unlock_id = 02, unlocked = false }		--ENT_TYPE.CHAR_MARGARET_TUNNEL
HD_UNLOCKS.AREA_RAND4 = { unlock_id = 09, unlocked = false }		--ENT_TYPE.CHAR_COCO_VON_DIAMONDS
HD_UNLOCKS.OLMEC_WIN = {
	win = 1,
	unlock_id = 07,													--ENT_TYPE.CHAR_AMAZON
	unlocked = false
}
HD_UNLOCKS.WORM = {
	unlock_theme = THEME.EGGPLANT_WORLD,
	unlock_id = 16,													--ENT_TYPE.CHAR_PILOT
	unlocked = false
}				
HD_UNLOCKS.SPIDERLAIR = {
	feeling = "SPIDERLAIR",
	unlock_id = 13, unlocked = false }								--ENT_TYPE.CHAR_VALERIE_CRUMP
HD_UNLOCKS.YETIKINGDOM = {
	feeling = "YETIKINGDOM",
	unlock_id = 15, unlocked = false }								--ENT_TYPE.CHAR_DEMI_VON_DIAMONDS
HD_UNLOCKS.HAUNTEDCASTLE = {
	feeling = "HAUNTEDCASTLE",
	unlock_id = 17, unlocked = false }								--ENT_TYPE.CHAR_PRINCESS_AIRYN
HD_UNLOCKS.YAMA = {
	win = 2,
	unlock_id = 20,													--ENT_TYPE.CHAR_CLASSIC_GUY
	unlocked = false
}				
HD_UNLOCKS.OLMEC_CHAMBER = {
	unlock_theme = THEME.OLMEC,
	unlock_id = 18, unlocked = false }								--ENT_TYPE.CHAR_DIRK_YAMAOKA
HD_UNLOCKS.TIKIVILLAGE = { -- RESIDENT TIK-EVIL: VILLAGE
	feeling = "TIKIVILLAGE",
	unlock_id = 11, unlocked = false }								--ENT_TYPE.CHAR_OTAKU
HD_UNLOCKS.BLACKMARKET = {
	feeling = "BLACKMARKET",
	unlock_id = 04, unlocked = false }								--ENT_TYPE.CHAR_ROFFY_D_SLOTH
HD_UNLOCKS.FLOODED = {
	feeling = "FLOODED",
	unlock_id = 10, unlocked = false }								--ENT_TYPE.CHAR_MANFRED_TUNNEL
HD_UNLOCKS.MOTHERSHIP = {
	unlock_theme = THEME.NEO_BABYLON,
	unlock_id = 08, unlocked = false }								--ENT_TYPE.CHAR_LISE_SYSTEM
HD_UNLOCKS.COG = {
	unlock_theme = THEME.CITY_OF_GOLD,
	unlock_id = 14, unlocked = false }								--ENT_TYPE.CHAR_AU


MESSAGE_FEELING = nil

HD_FEELING = {
	["SPIDERLAIR"] = {
		chance = 0,
		themes = { THEME.DWELLING },
		message = "My skin is crawling..."
	},
	["SNAKEPIT"] = {
		chance = 0,
		themes = { THEME.DWELLING },
		message = "I hear snakes... I hate snakes!"
	},
	["RESTLESS"] = {
		chance = 1,
		themes = { THEME.JUNGLE },
		message = "The dead are restless!"
	},
	["TIKIVILLAGE"] = {
		chance = 0,
		themes = { THEME.JUNGLE }
	},
	["FLOODED"] = {
		chance = 1,
		themes = { THEME.JUNGLE },
		message = "I hear rushing water!"
	},
	["BLACKMARKET_ENTRANCE"] = {
		themes = { THEME.JUNGLE }
	},
	["BLACKMARKET"] = {
		themes = { THEME.JUNGLE },
		message = "Welcome to the Black Market!"
	},
	["HAUNTEDCASTLE"] = {
		themes = { THEME.JUNGLE },
		message = "A wolf howls in the distance..."
	},
	["YETIKINGDOM"] = {
		chance = 1,
		themes = { THEME.ICE_CAVES },
		message = "It smells like wet fur in here."
	},
	["UFO"] = {
		chance = 1,
		themes = { THEME.ICE_CAVES },
		message = "I sense a psychic presence here!"
	},
	["MOAI"] = {
		themes = { THEME.ICE_CAVES }
	},
	["MOTHERSHIPENTRANCE"] = {
		themes = { THEME.ICE_CAVES },
		message = "It feels like the fourth of July..."
	},
	["SACRIFICIALPIT"] = {
		chance = 1,
		themes = { THEME.TEMPLE },
		message = "You hear prayers to Kali!"
	},
	["HELL"] = {
		themes = { THEME.VOLCANA },
		load = 1,
		message = "A horrible feeling of nausea comes over you!"
	},
}

-- TODO: issues with current hardcodedgeneration-dependent features:
	-- Vaults
		-- May interfere with the process of altering the level_path
	-- Idol traps
		-- Currently messes up mines level generation since S2 assumes that it's part of path
	-- Udjat eye placement
		-- mines level generation isn't as accurate
			-- slightly incorrect side rooms
			-- can't spawn on 1-4
	-- My own system for spawning the wormtongue
		-- Has to be hardcoded in order to work for both jungle and ice caves
		-- Has to be hardcoded in order to work for both jungle and ice caves

	-- if you need the variation that's facing left, use roomcodes[2].
	-- dimensions are assumed to be 10x8, but you can define them with dimensions = { w = 10, h = 8 }
HD_ROOMOBJECT = {}
HD_ROOMOBJECT.GENERIC = {
	shop = {
		{ -- prize wheel
			subchunk_id = "1001",
			pathalign = true,
			roomcodes = {
				"11111111111111..1111....22...1.Kl00002.....000W0.0.0%00000k0.$%00S0000bbbbbbbbbb",
				"11111111111111..11111...22......20000lK.0.W0000...0k00000%0.0000S00%$.bbbbbbbbbb"
			}
		},
		{ -- Damzel
			subchunk_id = "1002",
			pathalign = true,
			roomcodes = {
				"11111111111111..111111..22...111.l0002.....000W0.0...00000k0..K00S0000bbbbbbbbbb",
				"11111111111111..11111...22..11..2000l.110.W0000...0k00000...0000S00K..bbbbbbbbbb"
			}
		},
		{ -- Hiredhands(?)
			subchunk_id = "1003",
			pathalign = true,
			roomcodes = {
				"11111111111111..111111..22...111.l0002.....000W0.0...00000k0..K0SSS000bbbbbbbbbb",
				"11111111111111..11111...22..11..2000l.110.W0000...0k00000...000SSS0K..bbbbbbbbbb"
			}
		},
		{ -- Hiredhands(?)
			subchunk_id = "1004",
			pathalign = true,
			roomcodes = {
				"11111111111111..111111..22...111.l0002.....000W0.0...00000k0..K0S0S000bbbbbbbbbb",
				"11111111111111..11111...22..11..2000l.110.W0000...0k00000...000S0S0K..bbbbbbbbbb"
			}
		},
		{ -- ?
			subchunk_id = "1005",
			pathalign = true,
			roomcodes = {
				"11111111111111..111111..22...111.l0002.....000W0.0...00000k0..KS000000bbbbbbbbbb",
				"11111111111111..11111...22..11..2000l.110.W0000...0k00000...000S000K..bbbbbbbbbb"
			}
		}
	},
	vault = {
		{
			subchunk_id = "1010",
			roomcodes = {
				"11111111111111111111111|00011111100001111110EE0111111000011111111111111111111111"
			}
		}
	},
	alter = {
		{
			subchunk_id = "1011",
			roomcodes = {
				"220000002200000000000000000000000000000000000000000000x0000002211112201111111111"
			}
		}
	}
}
HD_ROOMOBJECT.FEELINGS = {
	SPIDERLAIR = {
		
		
		-- coffin_unlockable = {
			
		-- },
		-- coffin_unlockable_vertical = {
		
		-- },
	},
	SNAKEPIT = {
		-- Notes:
			-- spawn steps:
				-- 106
					-- levelw, levelh = get_levelsize()
					-- structx = math.random(1, levelw)
					-- spawn 106 at structx, 1
				-- 107
					-- _, levelh = get_levelsize()
					-- struct_midheight = math.random(1, levelh-2)
					-- for i = 1, struct_midheight, 1 do
						-- spawn 107 at structx, i
					-- end
				-- 108
					-- spawn 108 at structx, struct_midheight+1
		{
			subchunk_id = "106",
			-- grabs 5 and upwards from path_drop
			roomcodes = {
			"00000000000000000000600006000000000000000000000000000000000002200002201112002111",
			"00000000000000220000000000000000200002000112002110011100111012000000211111001111",
			"00000000000060000000000000000000000000000000000000002022020000100001001111001111",
			"11111111112222222222000000000000000000000000000000000000000000000000001120000211",
			"11111111112222111111000002211200000002100000000000200000000000000000211120000211",
			"11111111111111112222211220000001200000000000000000000000000012000000001120000211",
			"11111111112111111112021111112000211112000002112000000022000002200002201111001111"
			}
		},
		{
			subchunk_id = "107",
			roomcodes = {"111000011111n0000n11111200211111n0000n11111200211111n0000n11111200211111n0000n11"}
		},
		{
			subchunk_id = "108",
			roomcodes = {"111000011111n0000n1111100001111100N0001111N0110N11111NRRN1111111M111111111111111"}
		}
	},
	SACRIFICIALPIT = {
		-- Notes:
			-- start from top
			-- seems to always be top to bottom
		-- Spawn steps:
			-- 116
				-- levelw, levelh = get_levelsize()
				-- structx = math.random(1, levelw)
				-- spawn 116 at structx, 1
			-- 117
				-- _, levelh = get_levelsize()
				-- struct_midheight = levelh-2
				-- for i = 1, struct_midheight, 1 do
					-- spawn 117 at structx, i
				-- end
			-- 118
				-- spawn 118 at structx, struct_midheight+1
		{
			subchunk_id = "116",
			-- grabs 5 and upwards from path_drop
			roomcodes = {
			"0000000000000000000000000000000000000000000100100000110011000111;01110111BBBB111"
			}
		},
		{
			subchunk_id = "117",
			roomcodes = {"11200002111120000211112000021111200002111120000211112000021111200002111120000211"}
		},
		{
			subchunk_id = "118",
			roomcodes = {"112000021111200002111120000211113wwww311113wwww311113wwww31111yyyyyy111111111111"}
		}
	},
}
HD_ROOMOBJECT.WORLDS = {
	DWELLING = { -- Depending on how we access HD_ROOMOBJECT, rename this to MINES
		coffin_unlockable = {
			{
				subchunk_id = "74",
				pathalign = true,
				roomcodes = {
					"vvvvvvvvvvv++++++++vvL00000g0vvPvvvvvvvv0L000000000L0:000:0011111111111111111111",
					"vvvvvvvvvvv++++++++vvg000000LvvvvvvvvvPv00000000L000:000:0L011111111111111111111" -- facing left
				}
			},
		},
	},
	JUNGLE = {
	},
	ICE_CAVES = {
	},
	TEMPLE = {
	},
	OLMEC = {
		coffin_unlockable = {
			-- Spawn steps:
				-- levelw, _ = get_levelsize()
				-- structx = 1
				-- chance = math.random()
				-- if chance >= 0.5 then structx = levelw end
				-- spawn 143 at structx, 1
			{
				subchunk_id = "143",
				roomcodes = {
					"00000100000E110111E001100001100E100001E00110g00110001111110000000000000000000000",
					"00001000000E111011E001100001100E100001E00110g00110001111110000000000000000000000"
				}
			}
		}
	}
}

-- path:	DRESSER
-- drop:	SIDETABLE
-- notop:	SHORTCUTSTATIONBANNER
HD_SUBCHUNKID_TERM = {
	["path"] = {
		entity_type = ENT_TYPE.BG_BASECAMP_DRESSER,
		kill = true
	},
	["drop"] = {
		entity_type = ENT_TYPE.BG_BASECAMP_SIDETABLE,
		kill = true
	},
	["notop"] = {
		entity_type = ENT_TYPE.BG_BASECAMP_SHORTCUTSTATIONBANNER,
		kill = true
	},
	["entrance"] = { entity_type = ENT_TYPE.FLOOR_DOOR_ENTRANCE },
	["exit"] = { entity_type = ENT_TYPE.FLOOR_DOOR_EXIT },
}
-- TODO: Player Coffins
-- Subchunkid terminology
	-- 00 -- side				-- Empty/unassigned
	-- 01 -- path_normal		-- Standard room (horizontal exit)
	-- 02 -- path_drop			-- Path to exit (vertical exit)
	-- 03 -- path_notop			-- Path to exit (horizontal exit)
	-- 04 -- path_drop_notop	-- Path to exit (vertical exit)
	-- 05 -- entrance			-- Player start (horizontal exit)
	-- 06 -- entrance_drop		-- Player start (vertical exit)
	-- 07 -- exit				-- Exit door (horizontal entrance)
	-- 08 -- exit_notop			-- Exit door (vertical entrance)

-- TODO: Choose a unique ENT_TYPE for (at least the first 4) SUBCHUNKIDs
HD_SUBCHUNKID = {
	["0"] = {
		{ entity_type = 0 }
	},
	["1"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["path"].entity_type }
	},
	["2"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["path"].entity_type },
		{ entity_type = HD_SUBCHUNKID_TERM["drop"].entity_type }
	},
	["3"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["path"].entity_type },
		{ entity_type = HD_SUBCHUNKID_TERM["notop"].entity_type }
	},
	["4"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["path"].entity_type },
		{ entity_type = HD_SUBCHUNKID_TERM["drop"].entity_type },
		{ entity_type = HD_SUBCHUNKID_TERM["notop"].entity_type }
	},
	["5"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["entrance"].entity_type }
	},
	["6"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["entrance"].entity_type },
		{ entity_type = HD_SUBCHUNKID_TERM["drop"].entity_type }
	},
	["7"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["exit"].entity_type }
	},
	["8"] = {
		{ entity_type = HD_SUBCHUNKID_TERM["exit"].entity_type },
		{ entity_type = HD_SUBCHUNKID_TERM["notop"].entity_type }
	},
	-- ["6" = , -- Upper part of snake pit
	-- ["7" = , -- Middle part of snake pit
	-- ["8" = , -- Bottom part of snake pit
	-- ["9" = , -- Rushing Water islands/lake surface
	-- ["10" = , -- Rushing Water lake
	-- ["11" = , -- Rushing Water lake with Ol' Bitey
	-- ["12" = , -- Left part of psychic presence
	-- ["13" = , -- Middle part of psychic presence
	-- ["14" = , -- Right part of psychic presence
	-- ["15" = , -- Moai
	-- ["16" = , -- Kalipit top
	-- ["17" = , -- Kalipit middle
	-- ["18" = , -- Kalipit bottom
	-- ["19" = , -- Vlad's Tower top
	-- ["20" = , -- Vlad's Tower middle
	-- ["21" = , -- Vlad's Tower bottom
	-- ["22" = , -- Beehive with left/right exits
	-- ["24" = , -- Beehive with left/down exits
	-- ["25" = , -- Beehive with left/up exits
	-- ["26" = , -- Book of the Dead room left
	-- ["27" = , -- Book of the Dead room right
	-- ["28" = , -- Top part of mothership entrance
	-- ["29" = , -- Bottom part of mothership entrance
	-- ["30" = , -- Castle top layer middle-left
	-- ["31" = , -- Castle top layer middle-right
	-- ["32" = , -- Castle middle layers left with exits left/right and sometimes up
	-- ["33" = , -- Castle middle layers left with exits left/right/down
	-- ["34" = , -- Castle exit
	-- ["35" = , -- Castle altar
	-- ["36" = , -- Castle right wall
	-- ["37" = , -- Castle right wall with exits left/down
	-- ["38" = , -- Castle right wall bottom layer
	-- ["39" = , -- Castle right wall bottom layer with exit up
	-- ["40" = , -- Castle bottom right moat
	-- ["41" = , -- Crysknife pit left
	-- ["42" = , -- Crysknife pit right
	-- ["43" = , -- Castle coffin
	-- ["46" = , -- Alien queen
	-- ["47" = , -- DaR Castle Entrance
	-- ["48" = , -- DaR Crystal Idol
}

-- retains HD tilenames
HD_TILENAME = {
	-- ["1"] = {
		-- entity_types = ENT_TYPE.FLOOR_GENERIC,
		-- description = "Terrain",
	-- },
	-- ["2"] = ENT_TYPE.FLOOR_GENERIC,
	-- ["+"] = ENT_TYPE.FLOORSTYLED_STONE,
	-- ["4"] = ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK,
	-- ["G"] = ENT_TYPE.FLOOR_TOMB,
	-- ["I"] = ENT_TYPE.ITEM_IDOL,
	-- ["i"] = ENT_TYPE.FLOOR_ICE,
	-- ["j"] = ENT_TYPE.FLOOR_ICE,
	["0"] = {
		description = "Empty",
	},
    ["#"] = {
		entity_types = {ENT_TYPE.ACTIVEFLOOR_POWDERKEG},
		description = "TNT Box",
	},
    ["$"] = {
		description = "Roulette Item",
	},
    ["%"] = {
		description = "Roulette Door",
	},
    ["&"] = { -- 50% chance to spawn
		entity_types = {ENT_TYPE.LOGICAL_WATER_DRAIN, 0},
		alternate_types = {
			[THEME.TEMPLE] = {ENT_TYPE.LOGICAL_LAVA_DRAIN, 0},
			[THEME.VOLCANA] = {ENT_TYPE.LOGICAL_LAVA_DRAIN, 0},
		},
		offset = { 0, -2 },
		alternate_offset = {
			[THEME.TEMPLE] = { 0, 0 },
			[THEME.VOLCANA] = { 0, 0 },
		},
		description = "Waterfall",
	},
    ["*"] = {
		-- hd_type = HD_ENT.TRAP_SPIKEBALL
		description = "Spikeball",
	},
    ["+"] = {
		description = "Wooden Background",
	},
    [","] = {
		entity_types = {
			ENT_TYPE.FLOOR_GENERIC,
			ENT_TYPE.FLOORSTYLED_MINEWOOD
		},
		description = "Terrain/Wood",
	},
    ["-"] = {
		entity_types = {ENT_TYPE.ACTIVEFLOOR_THINICE},
		description = "Cracking Ice",
	},
    ["."] = {
		entity_types = {ENT_TYPE.FLOOR_GENERIC},
		description = "Unmodified Terrain",
	},
    ["1"] = {
		entity_types = {ENT_TYPE.FLOOR_GENERIC},
		description = "Terrain",
	},
    ["2"] = {
		entity_types = {
			ENT_TYPE.FLOOR_GENERIC,
			0
		},
		alternate_types = {
			[THEME.EGGPLANT_WORLD] = {
				ENT_TYPE.FLOORSTYLED_GUTS,
				ENT_TYPE.ACTIVEFLOOR_REGENERATINGBLOCK,
				0
			},
		},
		description = "Terrain/Empty",
	},
    ["3"] = {
		entity_types = {
			ENT_TYPE.FLOOR_GENERIC,
			ENT_TYPE.LIQUID_WATER
		},
		alternate_types = {
			[THEME.TEMPLE] = {
				ENT_TYPE.FLOOR_GENERIC,
				ENT_TYPE.LIQUID_WATER
			},
			[THEME.VOLCANA] = {
				ENT_TYPE.FLOOR_GENERIC,
				ENT_TYPE.LIQUID_WATER
			},
		},
		description = "Terrain/Water",
	},
    ["4"] = {
		entity_types = {ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK},
		description = "Pushblock",
	},
    ["5"] = {
		-- TODO: subchunk parameters
		description = "Ground Obstacle Block",
	},
    ["6"] = {
		-- TODO: subchunk parameters
		description = "Floating Obstacle Block",
	},
    ["7"] = {
		entity_types = {
			ENT_TYPE.FLOOR_SPIKES,
			0
		},
		description = "Spikes/Empty",
	},
    ["8"] = {
		-- TODO: subchunk parameters
		description = "Door with Terrain Block",
	},
    ["9"] = {
		-- TODO: subchunk parameters
		description = "Door without Platform",
	},
    [":"] = {
		entity_types = {ENT_TYPE.MONS_SCORPION},
		alternate_types = {
			[THEME.JUNGLE] = {ENT_TYPE.MONS_TIKIMAN}
		},
		description = "Tikiman or Scorpion from Mines Coffin",--"Scorpion from Mines Coffin",
	},
    [";"] = {
		-- TODO: two across parameter
		description = "Damsel and Idol from Kalipit",
	},
    ["="] = {
		description = "Wood with Background",
	},
    ["A"] = {
		-- TODO: two across parameter
		entity_types = {ENT_TYPE.FLOOR_IDOL_BLOCK},
		description = "Mines Idol Platform",
	},
    ["B"] = {
		-- TODO: Find a good reskin replacement
		entity_types = {ENT_TYPE.FLOORSTYLED_STONE},
		description = "Jungle/Temple Idol Platform",
	},
    ["C"] = {
		-- TODO: Ceiling Idol Trap
		entity_types = {ENT_TYPE.FLOORSTYLED_STONE},
		description = "Nonmovable Pushblock",
	},
    ["E"] = {
		-- TODO: subchunk parameters
		entity_types = {
			ENT_TYPE.FLOOR_GENERIC,
			ENT_TYPE.ITEM_CRATE,
			ENT_TYPE.ITEM_CHEST,
			0
		},
		description = "Terrain/Empty/Crate/Chest",
	},
    ["F"] = {
		-- TODO: subchunk parameters
		description = "Falling Platform Obstacle Block",
	},
    ["G"] = {
		entity_types = {ENT_TYPE.FLOOR_LADDER},
		description = "Ladder",
	},
    ["H"] = {
		entity_types = {ENT_TYPE.FLOOR_LADDER_PLATFORM},
		description = "Ladder Platform",
	},
    ["I"] = {
		offset = { 0.5, 0 },
		description = "Idol",
	},
    ["J"] = {
		entity_types = {ENT_TYPE.MONS_GIANTFISH},
		description = "Ol' Bitey",
	},
    ["K"] = {
		description = "Shopkeeper",
	},
    ["L"] = {
		entity_types = {ENT_TYPE.FLOOR_LADDER},
		alternate_types = {
			[THEME.JUNGLE] = {ENT_TYPE.FLOOR_VINE},
			[THEME.EGGPLANT_WORLD] = {ENT_TYPE.FLOOR_VINE},
			[THEME.VOLCANA] = {ENT_TYPE.FLOOR_CHAINANDBLOCKS_CHAIN},
		},
		description = "Ladder",
	},
    ["M"] = {
		description = "Crust Mattock from Snake Pit",
	},
    ["N"] = {
		entity_types = {ENT_TYPE.MONS_SNAKE},
		description = "Snake from Snake Pit",
	},
    ["O"] = {
		description = "Moai Head",
	},
    ["P"] = {
		entity_types = {ENT_TYPE.FLOOR_LADDER_PLATFORM},
		description = "Ladder Platform",
	},
    ["Q"] = {
		entity_types = {ENT_TYPE.FLOOR_LADDER},
		alternate_types = {
			[THEME.JUNGLE] = {ENT_TYPE.FLOOR_VINE},
			[THEME.EGGPLANT_WORLD] = {ENT_TYPE.FLOOR_VINE},
			[THEME.VOLCANA] = {ENT_TYPE.FLOOR_CHAINANDBLOCKS_CHAIN},
		},
		-- TODO: Generate ladder to just above floor.
		description = "Variable-Length Ladder",
	},
    ["R"] = {
		description = "Ruby from Snakepit",
	},
    ["S"] = {
		description = "Shop Items",
	},
    ["T"] = {
		-- TODO: Tree spawn method
		description = "Tree",
	},
    ["U"] = {
		entity_types = {ENT_TYPE.MONS_VLAD},
		description = "Vlad",
	},
    ["V"] = {
		-- TODO: subchunk parameters
		description = "Vines Obstacle Block",
	},
    ["W"] = {
		description = "Unknown: Something Shop-Related",
	},
    ["X"] = {
		entity_types = {ENT_TYPE.MONS_GIANTSPIDER},
		-- alternate_hd_types = {
		-- -- Hell: Horse Head & Ox Face
		-- },
		-- offset = { 0.5, 0 },
		description = "Giant Spider",
	},
    ["Y"] = {
		entity_types = {ENT_TYPE.MONS_YETIKING},
		alternate_types = {
			[THEME.TEMPLE] = {ENT_TYPE.MONS_MUMMY},
		},
		description = "Yeti King",
	},
    ["Z"] = {
		entity_types = {ENT_TYPE.FLOORSTYLED_BEEHIVE},
		description = "Beehive Tile with Background",
	},
    ["a"] = {
		entity_types = {ENT_TYPE.ITEM_PICKUP_ANKH},
		description = "Ankh",
	},
	-- TODO:
		-- Add alternative shop floor of FLOOR_GENERIC
		-- Modify all HD shop roomcodes to accommodate this.
    ["b"] = {
		entity_types = {ENT_TYPE.FLOOR_MINEWOOD},
		flags = {
			[24] = true
		},
		description = "Shop Floor",
	},
    ["c"] = {
		spawnfunction = function(params)
			set_timeout(create_idol_crystalskull, 10)
		end,
		offset = { 0.5, 0 },
		description = "Crystal Skull",
	},
    ["d"] = {
		entity_types = {ENT_TYPE.FLOOR_JUNGLE},
		alternate_types = {
			[THEME.EGGPLANT_WORLD] = {ENT_TYPE.ACTIVEFLOOR_REGENERATINGBLOCK},
		},
		description = "Jungle Terrain",
	},
    ["e"] = {
		entity_types = {ENT_TYPE.FLOORSTYLED_BEEHIVE},
		description = "Beehive Tile",
	},
    ["f"] = {
		entity_types = {ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM},
		description = "Falling Platform",
	},
    ["g"] = {
		spawnfunction = function(params)
			create_unlockcoffin(params[1], params[2], params[3])
		end,
		entity_types = {ENT_TYPE.ITEM_COFFIN},
		description = "Coffin",
	},
    ["h"] = {
		entity_types = {ENT_TYPE.FLOORSTYLED_VLAD},
		description = "Hell Terrain",
	},
    ["i"] = {
		entity_types = {ENT_TYPE.FLOOR_ICE},
		description = "Ice Block",
	},
    ["j"] = {
		-- TODO: Investigate in HD. Pretty sure this is "Ice Block/Empty".
		description = "Ice Block with Caveman",
	},
    ["k"] = {
		entity_types = {ENT_TYPE.DECORATION_SHOPSIGN},
		offset = { 0, 4 },
		description = "Shop Entrance Sign",
	},
    ["l"] = {
		entity_types = {ENT_TYPE.ITEM_LAMP},
		description = "Shop Lantern",
	},
    ["m"] = {
		entity_types = {ENT_TYPE.FLOOR_GENERIC},
		flags = {
			[2] = true
		},
		description = "Unbreakable Terrain",
	},
    ["n"] = {
		entity_types = {
			ENT_TYPE.FLOOR_GENERIC,
			ENT_TYPE.MONS_SNAKE,
			0,
		},
		description = "Terrain/Empty/Snake",
	},
    ["o"] = {
		entity_types = {ENT_TYPE.ITEM_ROCK},
		description = "Rock",
	},
    ["p"] = {
		-- Not sure about this one. It's only used in the corners of the crystal skull jungle roomcode.
		-- TODO: Investigate in HD
		entity_types = {ENT_TYPE.ITEM_GOLDBAR},
		description = "Treasure/Damsel",
	},
    ["q"] = {
		-- TODO: Trap Prevention.
		entity_types = {ENT_TYPE.LIQUID_WATER},
		description = "Obstacle-Resistant Terrain",
	},
    ["r"] = {
		-- TODO: subchunk parameters
		description = "Mines Terrain/Temple Terrain/Pushblock",
	},
    ["s"] = {
		entity_types = {ENT_TYPE.FLOOR_SPIKES},
		description = "Spikes",
	},
    ["t"] = {
		-- entity_types = {
			-- ENT_TYPE.FLOORSTYLED_TEMPLE,
			-- ENT_TYPE.FLOOR_JUNGLE
		-- },
		-- TODO: ????? Investigate in HD.
		description = "Temple/Castle Terrain",
	},
    ["u"] = {
		entity_types = {ENT_TYPE.MONS_VAMPIRE},
		description = "Vampire from Vlad's Tower",
	},
    ["v"] = {
		entity_types = {ENT_TYPE.FLOORSTYLED_MINEWOOD},
		alternate_types = {
			[THEME.EGGPLANT_WORLD] = {ENT_TYPE.FLOORSTYLED_GUTS, ENT_TYPE.LIQUID_WATER},
		},
		description = "Wood",
	},
    ["w"] = {
		entity_types = {ENT_TYPE.LIQUID_WATER},
		alternate_types = {
			[THEME.TEMPLE] = {ENT_TYPE.LIQUID_LAVA},
			[THEME.VOLCANA] = {ENT_TYPE.LIQUID_LAVA},
		},
		description = "Water",
	},
    ["x"] = {
		description = "Kali Altar",
	},
    ["y"] = {
		description = "Crust Ruby in Terrain",
	},
    ["z"] = {
		entity_types = {
			ENT_TYPE.FLOORSTYLED_BEEHIVE,
			0
		},
		alternate_types = {
			[THEME.DWELLING] = {ENT_TYPE.ITEM_GOLDBAR},
		},
		-- TODO: Temple has bg pillar as an alternative
		description = "Beehive Tile/Empty",
	},
    ["|"] = {
		description = "Vault",
	},
    ["~"] = {
		entity_types = {ENT_TYPE.FLOOR_SPRING_TRAP},
		description = "Bounce Trap",
	},
	
		-- description = "Unknown",
}


TILEFRAMES_FLOOR = {
	-- 1x1
	{
		frames = {0},
		dim = {1, 1}
	},
	{
		frames = {1},
		dim = {1, 1}
	},
	{
		frames = {12},
		dim = {1, 1}
	},
	{
		frames = {13},
		dim = {1, 1}
	},
	-- 1x2
	{
		frames = {2, 14},
		dim = {1, 2}
	},
	{
		frames = {3, 15},
		dim = {1, 2}
	},
	-- 2x1
	{
		frames = {24, 25},
		dim = {2, 1}
	},
	{
		frames = {26, 27},
		dim = {2, 1}
	},
	-- 2x2
	{
		frames = {36, 37, 48, 49},
		-- frames = {48, 49, 36, 37},
		dim = {2, 2}
	},
	{
		frames = {38, 39, 50, 51},
		-- frames = {50, 51, 38, 39},
		dim = {2, 2}
	},
	{
		frames = {60, 61, 72, 73},
		-- frames = {72, 73, 60, 61},
		dim = {2, 2}
	},
	{
		frames = {62, 63, 74, 75},
		-- frames = {74, 75, 62, 63},
		dim = {2, 2}
	},
}

HD_COLLISIONTYPE = {
	AIR_TILE_1 = 1,
	AIR_TILE_2 = 2,
	FLOORTRAP = 3,
	FLOORTRAP_TALL = 4,
	GIANT_FROG = 5,
	GIANT_SPIDER = 6,
	-- GIANT_FISH = 7 -- not needed since it's always manually spawned
}

HD_DANGERTYPE = {
	CRITTER = 1,
	ENEMY = 2,
	FLOORTRAP = 3,
	FLOORTRAP_TALL = 4
}
HD_LIQUIDSPAWN = {
	PIRANHA = 1,
	MAGMAMAN = 2
}
HD_REMOVEINVENTORY = {
	SNAIL = {
		inventory_ownertype = ENT_TYPE.MONS_HERMITCRAB,
		inventory_entities = {
			ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK,
			ENT_TYPE.ACTIVEFLOOR_POWDERKEG,
			ENT_TYPE.ITEM_CRATE,
			ENT_TYPE.ITEM_CHEST
		}
	},
	SCORPIONFLY = {
		inventory_ownertype = ENT_TYPE.MONS_IMP,
		inventory_entities = {
			ENT_TYPE.ITEM_LAVAPOT
		}
	}
}
HD_REPLACE = {
	EGGSAC = 1
}
HD_KILL_ON = {
	STANDING = 1,
	STANDING_OUTOFWATER = 2
}

-- TODO: Revise into HD_ABILITIES:
	-- HD_ABILITY_STATE = {
		-- IDLE = 1,
		-- AGRO = 2,
	-- }
	-- skin = nil,
	-- ability_uids = {
		-- master = nil,
		-- idle = nil,
		-- agro = nil
	-- },
	-- ability_state = 1
HD_BEHAVIOR = {
	-- IDEAS:
		-- Disable monster attacks.
			-- monster = get_entity():as_chasingmonster
			-- monster.chased_target_uid = 0
	OLMEC_SHOT = {
		velocityx = nil,
		velocityy = nil,
		velocity_settimer = 25
	},
	-- CRITTER_FROG = {
		-- jump_timeout = 70
		-- ai_timeout = 40
	-- },
	SCORPIONFLY = {
		-- abilities = {
			-- TODO: replace with Imp
				-- Avoid using for agro distance since imps without lavapots immediately agro on the player regardless of distance
				-- TODO: set_timeout() to remove all lavapots from imps in onlevel_remove_mounts()
			-- TODO: if killed immediately, bat_uid still exists.
			-- TODO: abilities can still be killed by the camera flash
			bat_uid = nil,--agro = { bat_uid = nil },
			-- idle = { mosquito_uid = nil }
		-- },
		agro = false -- upon agro, enable bat ability
		-- once taken damage, remove abilities
	}
	-- HAWKMAN = {
		-- caveman_uid = nil, -- Not sure if we want caveman or shopkeeperclone for this
		-- agro = false -- upon agro, enable 
	-- },
	-- GREENKNIGHT = {
		-- master = {uid = nil(caveman)},
		-- idle = {uid = nil(olmitebodyarmor), }, -- tospawn = olmitebodyarmor
			-- reskin olmitebodyarmor as greenknight
			-- Initialize caveman as invisible, olmite as visible.
			-- Once taken damage, remove abilities. If all abilities are removed, make caveman visible
			-- TODO: Determine if there's better alternatives for whipping and stopping(without spike shoes) immunity
				-- pangxie
		-- uncheck 15 and uncheck 31.
	-- },
	-- BLACKKNIGHT = {
		-- shopkeeperclone_uid = nil,
		-- agro = true -- upon dropping shield, disable shopkeeperclone ability
	-- },
	-- MAMMOTH = {
		-- cobra_uid = nil
			-- dim: {2, 2} -- set the dimensions to the same as the giantfly or else movement and collision will look weird
			-- hitbox: {0.550, 0.705} -- based off pangxie
	-- },
	-- GIANTFROG = {
		-- frog_uid = nil
			-- dim: {2, 2} -- set the dimensions to the same as the giantfly or else movement and collision will look weird
			-- hitbox: { ?, ? }
	-- },
	-- ALIEN_LORD = {
		-- cobra_uid = nil
	-- }
}
-- Currently supported db modifications:
	-- onlevel_dangers_modifications()
		-- Supported Variables:
			-- dim = { w, h }
				-- sets height and width
				-- TODO: Split into two variables: One that gets set in onlevel_dangers_replace(), and one in onlevel_dangers_modifications.
					-- IDEA: dim_db and dim
			-- acceleration
			-- max_speed
			-- sprint_factor
			-- jump
			-- damage
			-- health
				-- sets EntityDB's life
			-- friction
			-- weight
			-- elasticity
		-- TODO:
			-- blood_content
			-- draw_depth
	-- onlevel_dangers_replace
		-- Supported Variables:
			-- tospawn
				-- if set, determines the ENT_TYPE to spawn.
			-- toreplace
				-- if set, determines the ENT_TYPE to replace inside onlevel_dangers_replace.
			-- entitydb
				-- If set, determines the ENT_TYPE to apply EntityDB modifications to
	-- danger_applydb
		-- Supported Variables:
			-- dim = { w, h }
				-- sets height and width
				-- TODO: Split into two variables: One that gets set in onlevel_dangers_replace(), and one in onlevel_dangers_modifications.
					-- IDEA: dim_db and dim
			-- color = { r, g, b }
				-- TODO: Add alpha channel support
			-- hitbox = { w, h }
				-- `w` for hitboxx, `y` for hitboxy.
			-- flag_stunnable
			-- flag_collideswalls
			-- flag_nogravity
			-- flag_passes_through_objects
				-- sets flag if true, clears if false
	-- create_danger
		-- Supported Variables:
			-- dangertype
				-- Determines multiple factors required for certain dangers, such as spawn_entity_over().
			-- collisiontype
				-- Determines collision detection on creation of an HD_ENT. collision detection.
	-- onframe_manage_dangers
		-- Supported Variables:
			-- kill_on_standing = 
				-- HD_KILL_ON.STANDING
					-- Once standing on a surface, kill it.
				-- HD_KILL_ON.STANDING_OUTOFWATER
					-- Once standing on a surface and not submerged, kill it.
			-- itemdrop = { item = {HD_ENT, etc...}, chance = 0.0 }
				-- on it not existing in the world, have a chance to spawn a random item where it previously existed.
			-- treasuredrop = { item = {HD_ENT, etc...}, chance = 0.0 }
				-- on it not existing in the world, have a chance to spawn a random item where it previously existed.
HD_ENT = {}
HD_ENT.ITEM_IDOL = {
	tospawn = ENT_TYPE.ITEM_IDOL
}
HD_ENT.ITEM_CRYSTALSKULL = {
	tospawn = ENT_TYPE.ITEM_MADAMETUSK_IDOL
}
ITEM_PICKUP_SPRINGSHOES = {
	tospawn = ENT_TYPE.ITEM_PICKUP_SPRINGSHOES
}
HD_ENT.ITEM_FREEZERAY = {
	tospawn = ENT_TYPE.ITEM_FREEZERAY
}
HD_ENT.ITEM_SAPPHIRE = {
	tospawn = ENT_TYPE.ITEM_SAPPHIRE
}
HD_ENT.FROG = {
	tospawn = ENT_TYPE.MONS_FROG,
	toreplace = ENT_TYPE.MONS_WITCHDOCTOR,--MOSQUITO,
	dangertype = HD_DANGERTYPE.ENEMY
}
HD_ENT.FIREFROG = {
	tospawn = ENT_TYPE.MONS_FIREFROG,
	-- toreplace = ENT_TYPE.MONS_MOSQUITO,
	dangertype = HD_DANGERTYPE.ENEMY
}
HD_ENT.SNAIL = {
	tospawn = ENT_TYPE.MONS_HERMITCRAB,
	toreplace = ENT_TYPE.MONS_MOSQUITO,--WITCHDOCTOR,
	entitydb = ENT_TYPE.MONS_HERMITCRAB,
	dangertype = HD_DANGERTYPE.ENEMY,
	health_db = 1,
	removecorpse = true,
	removeinventory = HD_REMOVEINVENTORY.SNAIL,
}
HD_ENT.PIRANHA = {
	tospawn = ENT_TYPE.MONS_TADPOLE,
	dangertype = HD_DANGERTYPE.ENEMY,
	liquidspawn = HD_LIQUIDSPAWN.PIRANHA,
	-- entitydb = ENT_TYPE.MONS_TADPOLE,
	-- sprint_factor = -1,
	-- max_speed = -1,
	-- acceleration = -1,
	kill_on_standing = HD_KILL_ON.STANDING_OUTOFWATER
}
HD_ENT.WORMBABY = {
	tospawn = ENT_TYPE.MONS_MOLE,
	entitydb = ENT_TYPE.MONS_MOLE,
	dangertype = HD_DANGERTYPE.ENEMY,
	health_db = 1,
	removecorpse = true
}
HD_ENT.EGGSAC = {
	tospawn = ENT_TYPE.ITEM_EGGSAC,
	toreplace = ENT_TYPE.MONS_JUMPDOG,
	dangertype = HD_DANGERTYPE.FLOORTRAP,
	collisiontype = HD_COLLISIONTYPE.FLOORTRAP,
	replaceoffspring = HD_REPLACE.EGGSAC
}
HD_ENT.TRAP_TIKI = {
	tospawn = ENT_TYPE.FLOOR_TOTEM_TRAP,
	toreplace = ENT_TYPE.ITEM_SNAP_TRAP,
	entitydb = ENT_TYPE.ITEM_TOTEM_SPEAR,
	dangertype = HD_DANGERTYPE.FLOORTRAP_TALL,
	collisiontype = HD_COLLISIONTYPE.FLOORTRAP_TALL,
	damage = 4
	-- TODO: Tikitrap flames on dark level. If they spawn, move each flame down 0.5.
}
HD_ENT.CRITTER_RAT = {
	dangertype = HD_DANGERTYPE.CRITTER,
	entitydb = ENT_TYPE.MONS_CRITTERDUNGBEETLE,
	max_speed = 0.05,
	acceleration = 0.05
}
HD_ENT.CRITTER_FROG = { -- TODO: behavior for jumping
	tospawn = ENT_TYPE.MONS_CRITTERCRAB,
	toreplace = ENT_TYPE.MONS_CRITTERBUTTERFLY,
	dangertype = HD_DANGERTYPE.CRITTER,
	entitydb = ENT_TYPE.MONS_CRITTERCRAB
	-- TODO: Make jumping script, adjust movement EntityDB properties
	-- behavior = HD_BEHAVIOR.CRITTER_FROG,
}
HD_ENT.SPIDER = {
	tospawn = ENT_TYPE.MONS_SPIDER,
	toreplace = ENT_TYPE.MONS_SPIDER,
	dangertype = HD_DANGERTYPE.ENEMY
}
HD_ENT.HANGSPIDER = {
	tospawn = ENT_TYPE.MONS_HANGSPIDER,
	-- toreplace = ENT_TYPE.MONS_SPIDER,
	dangertype = HD_DANGERTYPE.ENEMY
}
HD_ENT.GIANTSPIDER = {
	tospawn = ENT_TYPE.MONS_GIANTSPIDER,
	-- toreplace = ENT_TYPE.MONS_SPIDER,
	dangertype = HD_DANGERTYPE.ENEMY,
	collisiontype = HD_COLLISIONTYPE.GIANT_SPIDER,
	offset_spawn = {0.5, 0}
}
HD_ENT.BOULDER = {
	dangertype = HD_DANGERTYPE.ENEMY,--HD_DANGERTYPE.FLOORTRAP,
	entitydb = ENT_TYPE.ACTIVEFLOOR_BOULDER
}
HD_ENT.SCORPIONFLY = {
	tospawn = ENT_TYPE.MONS_SCORPION,
	toreplace = ENT_TYPE.MONS_CATMUMMY,--SPIDER,
	dangertype = HD_DANGERTYPE.ENEMY,
	behavior = HD_BEHAVIOR.SCORPIONFLY,
	color = { 0.902, 0.176, 0.176 },
	removeinventory = HD_REMOVEINVENTORY.SCORPIONFLY
}
-- Devil Behavior:
	-- when the octopi is in it's run state, use get_entities_overlapping() to detect the block {ENT_TYPE.FLOOR_GENERIC, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK} it runs into.
		-- then kill block, set octopi stuntimer.
-- DEVIL = {
	-- tospawn = ENT_TYPE.MONS_OCTOPUS,
	-- toreplace = ?,
	-- entitydb = ENT_TYPE.MONS_OCTOPUS,
	-- dangertype = HD_DANGERTYPE.ENEMY,
	-- sprint_factor = 7.0
	-- max_speed = 7.0
-- },
-- MAMMOTH = { -- TODO: Frozen Immunity
	-- tospawn = ENT_TYPE.MONS_GIANTFLY,
	-- toreplace = ?,
	-- dangertype = HD_DANGERTYPE.ENEMY,
	-- entitydb = ENT_TYPE.MONS_GIANTFLY,
	-- behavior = HD_BEHAVIOR.MAMMOTH,
	-- health_db = 8,
	-- itemdrop = {
		-- item = {HD_ENT.ITEM_FREEZERAY},
		-- chance = 1.0
	-- },
	-- treasuredrop = {
		-- item = {HD_ENT.ITEM_SAPPHIRE},
		-- chance = 1.0
	-- }
-- },
-- HAWKMAN = {
	-- tospawn = ENT_TYPE.MONS_SHOPKEEPERCLONE, -- Maybe.
	-- toreplace = ENT_TYPE.MONS_CAVEMAN,
	-- dangertype = HD_DANGERTYPE.ENEMY,
	-- entitydb = ENT_TYPE.MONS_SHOPKEEPERCLONE,
	-- behavior = HD_BEHAVIOR.HAWKMAN
-- },
-- GREENKNIGHT = {
	-- tospawn = ENT_TYPE.MONS_OLMITE_BODYARMORED,
	-- toreplace = ENT_TYPE.MONS_CAVEMAN,
	-- dangertype = HD_DANGERTYPE.ENEMY,
	-- entitydb = ENT_TYPE.MONS_OLMITE_BODYARMORED,
	-- behavior = HD_BEHAVIOR.GREENKNIGHT,
	-- stompdamage = false, -- TODO: Add this(?)
-- },
-- NOTE: Shopkeeperclones are immune to whip damage, while the black knight in HD wasn't.
	-- May be able to override this by syncing the stun of a duct-taped entity (ie, if caveman is stunned, shopkeeperclone.stun_timer = 10)
		-- Might as well use a caveman for the master, considering that in HD when the blackknight drops his shield, he behaves like a green knight (so, a caveman)
-- BLACKKNIGHT = {
	-- tospawn = ENT_TYPE.MONS_CAVEMAN,--ENT_TYPE.MONS_SHOPKEEPERCLONE,
	-- dangertype = HD_DANGERTYPE.ENEMY,
	-- entitydb = ENT_TYPE.MONS_CAVEMAN,--ENT_TYPE.MONS_SHOPKEEPERCLONE,
	-- behavior = HD_BEHAVIOR.BLACKKNIGHT,
	-- health = 3,
	-- giveitem = ENT_TYPE.ITEM_METAL_SHIELD
-- },
-- SUCCUBUS = {
	-- master: ENT_TYPE.MONS_MONKEY,
	-- Skin: {ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_HAMSTER}
	-- abilities.agro = `master uid`
-- }
-- TODO:
	-- Once at least 1 mask 0x1 is within a 2 block radius(? TOTEST: Investigate in HD.), change skin and set ability_state to agro.
	-- cycle through players and if the player has the agro ability in its inventory(?), track it and deal one damage once it leaves.
	-- Once :as_monkey() method is merged into the main branch, set jump_timer to 0 on every frame.
	-- Once :as_leprechaun() method is merged into the main branch, set jump_timer to 0 on every frame.
		-- Upside to using leprechaun is a good skin option
		-- downside is no jump_timer and preventing the gold stealing and teleporting abilities
	-- Once :as_pet() method is merged into the main branch, half its yell_counter field to 299 if it's higher than 300.
-- NOTES:
	--She disguises herself as a Damsel to lure the Spelunker, then ambushes them once they are in range.
	-- If she manages to pounce on the Spelunker, she will cling to them like a Monkey and take one hit point when she jumps off.
	-- The Succubus mimics the appearance of the currently selected damsel type, disguising herself as a female, male, dog or sloth. Regardless of the disguise, she always transforms into a demonic woman upon attacking - there are no male, canine or sloth Succubus models.
	-- The Succubus' attack is accompanied by a loud "scare chord" sound effect that persists until she is killed.  Her most dangerous ability is to stun and push the player when she jumps off (like a monkey), and she can continue attacking the player while they are unconscious.

-- For HD_ENTs that include references to other HD_ENTs:
HD_ENT.GIANTFROG = {
	tospawn = ENT_TYPE.MONS_OCTOPUS,
	-- toreplace = ENT_TYPE.MONS_OCTOPUS,
	entitydb = ENT_TYPE.MONS_OCTOPUS,
	dangertype = HD_DANGERTYPE.ENEMY,
	collisiontype = HD_COLLISIONTYPE.GIANT_FROG,
	-- GIANTSPIDER = 6, -- ?????????
	health_db = 8,
	sprint_factor = 0,
	max_speed = 0.01,
	jump = 0.2,
	dim = {2.5, 2.5},
	offset_spawn = {0.5, 0},
	removecorpse = true,
	hitbox = {
		0.64,
		0.8
	},
	flags = {
		{},
		{12}
	},
	itemdrop = {
		item = {HD_ENT.ITEM_PICKUP_SPRINGSHOES},--ENT_TYPE.ITEM_PICKUP_SPRINGSHOES},
		chance = 0.15 -- 15% (1/6.7)
	},
	treasuredrop = {
		item = {HD_ENT.ITEM_SAPPHIRE},
		chance = 0.50
	}
}
--TODO: Replace with regular frog
	-- Use a giant fly for tospawn
	-- Modify the behavior system to specify which ability uid is the visible one (make all other abilities invisible)
		-- Furthermore, modify it so you can allow scenarios like the greenknight happen;
			-- once taken damage, remove abilities. If all abilities are removed, make caveman visible

-- GIANTFROG = { -- PROBLEM: MONS_GIANTFLY eats frogs when near them. Determine potential alternative.
	-- tospawn = ENT_TYPE.MONS_GIANTFLY,
	-- toreplace = ENT_TYPE.MONS_GIANTFLY,
	-- dangertype = HD_DANGERTYPE.ENEMY,
	-- health = 8,
	-- entitydb = ENT_TYPE.MONS_GIANTFLY,
	-- behavior = HD_BEHAVIOR.GIANTFROG,
	-- dim = {2.5, 2.5},
	-- itemdrop = {
		-- item = {ENT_TYPE.ITEM_PICKUP_SPRINGSHOES},
		-- chance = 0.15 -- 15% (1/6.7)
	-- }
	-- treasuredrop = {
		-- item = {ENT_TYPE.ITEM_SAPPHIRE}, -- TODO: Determine which gems.
		-- chance = 1.0
	-- }
-- },
HD_ENT.OLDBITEY = {
	tospawn = ENT_TYPE.MONS_GIANTFISH,
	dangertype = HD_DANGERTYPE.ENEMY,
	entitydb = ENT_TYPE.MONS_GIANTFISH,
	collisiontype = HD_COLLISIONTYPE.GIANT_FISH,
	itemdrop = {
		item = {HD_ENT.ITEM_IDOL},--ENT_TYPE.ITEM_IDOL},
		chance = 1
	}
}
HD_ENT.OLMEC_SHOT = {
	tospawn = ENT_TYPE.ITEM_TIAMAT_SHOT,
	dangertype = HD_DANGERTYPE.ENEMY,
	kill_on_standing = HD_KILL_ON.STANDING,
	behavior = HD_BEHAVIOR.OLMEC_SHOT,
	itemdrop = {
		item = {
			HD_ENT.FROG,--ENT_TYPE.MONS_FROG,
			HD_ENT.FIREFROG,--ENT_TYPE.MONS_FIREFROG,
			-- HD_ENT.,--ENT_TYPE.MONS_MONKEY,
			-- HD_ENT.,--ENT_TYPE.MONS_SCORPION,
			-- HD_ENT.,--ENT_TYPE.MONS_SNAKE,
			-- HD_ENT.,--ENT_TYPE.MONS_BAT
		},
		chance = 1.0
	},
	-- Enable "collides walls", uncheck "No Gravity", uncheck "Passes through objects".
	flags = {
		{13},
		{4, 10}
	},
}

TRANSITION_CRITTERS = {
	[THEME.DWELLING] = {
		entity = HD_ENT.CRITTER_RAT
	},
	[THEME.JUNGLE] = {
		entity = HD_ENT.CRITTER_FROG
	},
	-- Confirm if this is in HD level transitions
	-- [THEME.EGGPLANT_WORLD] = {
		-- entity = HD_ENT.CRITTER_MAGGOT
	-- },
	-- [THEME.ICE_CAVES] = {
		-- entity = HD_ENT.CRITTER_PENGUIN
	-- },
	-- [THEME.TEMPLE] = {
		-- entity = HD_ENT.CRITTER_LOCUST
	-- },
}

			-- parameters:
				-- {{HD_ENT, true}, {HD_ENT, false}, {HD_ENT, true}...}
					-- HD Enemy type
					-- true for chance to spawn as rare variants, if exists
LEVEL_DANGERS = {
	-- [THEME.DWELLING] = {
		-- dangers = {
			-- {
				-- entity = HD_ENT.SCORPIONFLY--SPIDER,
				-- -- variation = {
					-- -- entities = {HD_ENT.SPIDER, HD_ENT.HANGSPIDER, HD_ENT.GIANTSPIDER},
					-- -- chances = {0.5, 0.85}
				-- -- }
			-- },
			-- -- {
				-- -- entity = HD_ENT.HANGSPIDER
			-- -- },
			-- -- {
				-- -- entity = HD_ENT.GIANTSPIDER
			-- -- },
			-- {
				-- entity = HD_ENT.CRITTER_RAT
			-- }
		-- }
	-- },
	[THEME.DWELLING] = {
		dangers = {
			{
				entity = HD_ENT.SPIDER,
				variation = {
					entities = {HD_ENT.HANGSPIDER, HD_ENT.GIANTSPIDER},
					chances = {0.5, 0.85}
				}
			},
			{
				entity = HD_ENT.HANGSPIDER
			},
			{
				entity = HD_ENT.GIANTSPIDER
			},
			{
				entity = HD_ENT.CRITTER_RAT
			}
		}
	},
	[THEME.JUNGLE] = {
		dangers = {
			{
				entity = HD_ENT.FROG,
				variation = {
					entities = {HD_ENT.FIREFROG, HD_ENT.GIANTFROG},
					chances = {0.75, 0.85}
				}
			},
			{
				entity = HD_ENT.FIREFROG
			},
			{
				entity = HD_ENT.GIANTFROG
			},
			{
				entity = HD_ENT.TRAP_TIKI
			},
			{
				entity = HD_ENT.SNAIL
			},
			{
				entity = HD_ENT.PIRANHA
			},
			{
				entity = HD_ENT.CRITTER_FROG
			}
		}
	},
	[THEME.EGGPLANT_WORLD] = {
		dangers = {
			{
				entity = HD_ENT.EGGSAC
			},
			{
				entity = HD_ENT.WORMBABY
			}
		}
	},
	[THEME.TEMPLE] = {
		dangers = {
			{
				entity = HD_ENT.SCORPIONFLY
			}
		}
	}
}
-- TIKITRAP_TEMPLE.toreplace = ENT_TYPE.MONS_CATMUMMY
-- TIKITRAP_TEMPLE.tospawn = ENT_TYPE.FLOOR_TOTEM_TRAP
-- ARROWTRAP - adapt code from trap randomizer
-- HAWKMAN_TEMPLE
-- LEVEL_DANGERS[THEME.TEMPLE] = {
	-- dangers = {
	-- }
-- }
-- TIKITRAP_COG.toreplace = ENT_TYPE.MONS_LEPRECHAUN
-- TIKITRAP_COG.tospawn = ENT_TYPE.FLOOR_LION_TRAP
-- ARROWTRAP - adapt code from trap randomizer
-- LEVEL_DANGERS[THEME.CITY_OF_GOLD] = {
	-- dangers = {
	-- }
-- }


function init()
	wheel_items = {}
	idoltrap_blocks = {}
	global_levelassembly = {}
	danger_tracker = {}
	idoltrap_timeout = IDOLTRAP_JUNGLE_ACTIVATETIME
	IDOL_X = nil
	IDOL_Y = nil
	IDOL_UID = nil
	BOULDER_UID = nil
	BOULDER_SX = nil
	BOULDER_SY = nil
	BOULDER_SX2 = nil
	BOULDER_SY2 = nil
	BOULDER_CRUSHPREVENTION_EDGE_CUR = BOULDER_CRUSHPREVENTION_EDGE
	BOULDER_CRUSHPREVENTION_HEIGHT_CUR = BOULDER_CRUSHPREVENTION_HEIGHT
	BOULDER_DEBUG_PLAYERTOUCH = false
	TONGUE_UID = nil
	TONGUE_BG_UID = nil
	HAUNTEDCASTLE_ENTRANCE_UID = nil
	BLACKMARKET_ENTRANCE_UID = nil
	DANGER_GHOST_UIDS = {}
	IDOLTRAP_TRIGGER = false
	
	
	OLMEC_ID = nil
	BOSS_STATE = nil
	TONGUE_STATE = nil
	TONGUE_STATECOMPLETE = false
	OLMEC_STATE = 0
	
	bookofdead_tick = 0
	wheel_speed = 0
	wheel_tick = WHEEL_SPINTIME
	acid_tick = ACID_POISONTIME
	tongue_tick = TONGUE_ACCEPTTIME
	-- bookofdead_tick_min = BOOKOFDEAD_TIC_LIMIT
	bookofdead_frames_index = 1
end

-- DANGER MODIFICATIONS - INITIALIZATION
-- TODO: Replace these with lists that get applied to specific entities within the level.
	-- For example: Detect on.frame for moles. If said mole's uid doesn't already exist in the removecorpse list, add it. Elseif it is dead, kill it, then then remove its uid from the list.
-- initialize per-level enemy databases
function onlevel_dangers_init()
	if LEVEL_DANGERS[state.theme] then
		global_dangers = map(LEVEL_DANGERS[state.theme].dangers, function(danger) return danger.entity end)
		if feeling_check("FLOODED") == true then
			oldbitey = TableCopy(HD_ENT.OLDBITEY)
			if feeling_check("RESTLESS") == true then
				oldbitey.itemdrop.item = {HD_ENT.ITEM_CRYSTALSKULL}
			end
			table.insert(global_dangers, oldbitey) 
		end
		
		if (options.hd_og_boulder_phys == true and
			state.theme == THEME.DWELLING and
			(
				state.level == 2 or
				state.level == 3 or
				state.level == 4
			)
		) then		
			boulder_modified = TableCopy(HD_ENT.BOULDER)
			-- boulder_modified.?
			table.insert(global_dangers, boulder_modified)
		else table.insert(global_dangers, HD_ENT.BOULDER) end
	end
end

function bubbles()
	local fx = get_entities_by_type(ENT_TYPE.FX_WATER_SURFACE)
	for i,v in ipairs(fx) do
		local x, y, l = get_position(v)
		if math.random() < 0.003 then
			spawn_entity(ENT_TYPE.ITEM_ACIDBUBBLE, x, y, l, 0, 0)
		end
	end
end

 -- Trix wrote this
function replace(ent1, ent2, x_mod, y_mod)
	affected = get_entities_by_type(ent1)
	for i,ent in ipairs(affected) do

		ex, ey, el = get_position(ent)
		e = get_entity(ent):as_movable()

		s = spawn(ent2, ex, ey, el, 0, 0)
		se = get_entity(s):as_movable()
		se.velocityx = e.velocityx*x_mod
		se.velocityy = e.velocityy*y_mod

		move_entity(ent, 0, 0, 0, 0)-- kill_entity(ent)
	end
end

-- TODO: Use this as a base for embedding items in generate_tile()
-- ha wrote this
function embed(enum, uid)
  local uid_x, uid_y, uid_l = get_position(uid)
  local ents = get_entities_at(0, 0, uid_x, uid_y, uid_l, 0.1)
  if (#ents > 1) then return end

  local entitydb = get_type(enum)
  local previousdraw, previousflags = entitydb.draw_depth, entitydb.default_flags
  entitydb.draw_depth = 9
  entitydb.default_flags = 3278409 -- don't really need some flags for other things that dont explode, example is for jetpack

  local entity = get_entity(spawn_entity_over(enum, uid, 0, 0))
  entitydb.draw_depth = previousdraw
  entitydb.default_flags = previousflags  
  
  message("Spawned " .. tostring(entity.uid))
  return 0;
end
-- Example:
-- register_option_button('button', "Attempt to embed a Jetpack", function()
  -- first_level_entity = get_entities()[1] -- probably a floor
  -- embed(ENT_TYPE.ITEM_JETPACK, first_level_entity)
-- end)

-- TODO: Use this as a base for distributing embedded treasure
-- Malacath wrote this
-- Randomly distributes treasure in minewood_floor
-- set_post_tile_code_callback(function(x, y, layer)
    -- local rand = math.random(100)
    -- if rand > 65 then
        -- local ents = get_entities_overlapping(ENT_TYPE.FLOORSTYLED_MINEWOOD, 0, x - 0.45, y - 0.45, x + 0.45, y + 0.45, layer);
        -- if #ents == 1 then -- if not 1 then something else was spawned here already
            -- if rand > 95 then
                -- spawn_entity_over(ENT_TYPE.ITEM_JETPACK, ents[1], 0, 0);
            -- elseif rand > 80 then
                -- spawn_entity_over(ENT_TYPE.EMBED_GOLD_BIG, ents[1], 0, 0);
            -- else
                -- spawn_entity_over(ENT_TYPE.EMBED_GOLD, ents[1], 0, 0);
            -- end
        -- end
    -- end
-- end, "minewood_floor")


function teleport_mount(ent, x, y)
    if ent.overlay ~= nil then
        move_entity(ent.overlay.uid, x, y, 0, 0)
    else
        move_entity(ent.uid, x, y, 0, 0)
    end
    -- ent.more_flags = clr_flag(ent.more_flags, 16)
    set_camera_position(x, y)
end

function rotate(cx, cy, x, y, degrees)
	radians = degrees * (math.pi/180)
	rx = math.cos(radians) * (x - cx) - math.sin(radians) * (y - cy) + cx
	ry = math.sin(radians) * (x - cx) + math.cos(radians) * (y - cy) + cy
	result = {rx, ry}
	return result
end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function CompactList(list, prev_size)
	local j=0
	for i=1,prev_size do
		if list[i]~=nil then
			j=j+1
			list[j]=list[i]
		end
	end
	for i=j+1,prev_size do
		list[i]=nil
	end
	return list
end

function TableLength(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function TableFirstKey(t)
  local count = 0
  for k,_ in pairs(t) do return k end
  return nil
end

function TableFirstValue(t)
  local count = 0
  for _,v in pairs(t) do return v end
  return nil
end

function TableRandomElement(tbl)
	local t = {}
	if #tbl == 0 then return nil end
	for _, v in ipairs(tbl) do
		t[#t+1] = v
	end
	return t[math.random(1, #t)]
end

function TableConcat(t1, t2)
	for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function map(tbl, f)
	local t = {}
	for k, v in ipairs(tbl) do
		t[k] = f(v)
	end
	return t
end

function TableCopy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[TableCopy(k, s)] = TableCopy(v, s) end
  return res
end

function setn(t,n)
	setmetatable(t,{__len=function() return n end})
end

function locate_cornerpos(roomx, roomy)
	xmin, ymin, _, _ = get_bounds()
	tc_x = (roomx-1)*10+(xmin+0.5)
	tc_y = (ymin-0.5) - ((roomy-1)*(8))
	return tc_x, tc_y
end

function locate_roompos(e_x, e_y)
	xmin, ymin, _, _ = get_bounds()
	-- my brain can't do math, please excuse this embarrassing algorithm
	roomx = math.ceil((e_x-(xmin+0.5))/10)
	roomy = math.ceil(((ymin-0.5)-e_y)/8)
	return roomx, roomy
end

function get_levelsize()
	xmin, ymin, xmax, ymax = get_bounds()
	levelw = math.ceil((xmax-xmin)/10)
	levelh = math.ceil((ymin-ymax)/8)
	return levelw, levelh
end

function get_unlock()
	-- TODO: Boss win unlocks.
		-- Either move the following uncommented code into a dedicated method, or move this method to a place that works for a post-win screen
	-- unlockconditions_win = {}
	-- for unlock_name, unlock_properties in pairs(HD_UNLOCKS) do
		-- if unlock_properties.win ~= nil then
			-- unlockconditions_win[unlock_name] = unlock_properties
		-- end
	-- end
	unlock = nil
	unlockconditions_feeling = {} -- TODO: Maybe move into HD_FEELING as `unlock = true`
	unlockconditions_theme = {}
	for unlock_name, unlock_properties in pairs(HD_UNLOCKS) do
		if unlock_properties.feeling ~= nil then
			unlockconditions_feeling[unlock_name] = unlock_properties
		elseif unlock_properties.unlock_theme ~= nil then
			unlockconditions_theme[unlock_name] = unlock_properties
		end
	end
	
	for unlock_name, unlock_properties in pairs(unlockconditions_theme) do
		if unlock_properties.unlock_theme == state.theme then
			unlock = unlock_name
		end
	end
	for unlock_name, unlock_properties in pairs(unlockconditions_feeling) do
		if feeling_check(unlock_properties.feeling) == true then
			-- Probably won't be overridden by theme
			unlock = unlock_name
		end
	end
	
	return unlock
end

function get_unlock_area()
	rand_pool = {"AREA_RAND1","AREA_RAND2","AREA_RAND3","AREA_RAND4"}
	coffin_rand_pool = {}
	rand_index = 1
	n = #rand_pool
	for rand_index = 1, #rand_pool, 1 do
		if HD_UNLOCKS[rand_pool[rand_index]].unlocked == true then
			rand_pool[rand_index] = nil
		end
	end
	rand_pool = CompactList(rand_pool, n)
	rand_index = math.random(1, #rand_pool)
	unlock = rand_pool[rand_index]
	return unlock
end


function create_unlockcoffin(x, y, l)
	coffin_uid = spawn_entity(ENT_TYPE.ITEM_COFFIN, x, y, l, 0, 0)
	-- 193 + unlock_num = ENT_TYPE.CHAR_*
	set_contents(coffin_uid, 193 + HD_UNLOCKS[unlock_name].unlock_id)
	return coffin_uid
end

-- test if gold/gems automatically get placed into scripted tile generation or not
function gen_embedtreasures(uids_toembedin)
	for _, uid_toembedin in ipairs(uids_toembedin) do
		create_embedded(uid_toembedin)
	end
end

function create_embedded(ent_toembedin, entity_type)
	if entity_type ~= ENT_TYPE.EMBED_GOLD and entity_type ~= ENT_TYPE.EMBED_GOLD_BIG then
		local entity_db = get_type(entity_type)
		local previous_draw, previous_flags = entity_db.draw_depth, entity_db.default_flags
		entity_db.draw_depth = 9
		entity_db.default_flags = set_flag(entity_db.default_flags, 1)
		entity_db.default_flags = set_flag(entity_db.default_flags, 4)
		entity_db.default_flags = set_flag(entity_db.default_flags, 10)
		entity_db.default_flags = clr_flag(entity_db.default_flags, 13)
		local entity = get_entity(spawn_entity_over(entity_type, ent_toembedin, 0, 0))
		entity_db.draw_depth = previous_draw
		entity_db.default_flags = previous_flags
	else
		spawn_entity_over(entity_type, ent_toembedin, 0, 0)
	end
end

function create_endingdoor(x, y, l)
	-- TODO: Remove exit door from the editor and spawn it manually here.
	-- Why? Currently the exit door spawns tidepool-specific critters and ambience sounds, which will probably go away once an exit door isn't there initially.
	-- ALTERNATIVE: kill ambient entities and critters. May allow compass to work.
	-- TODO: Test if the compass works for this
	exitdoor = spawn(ENT_TYPE.FLOOR_DOOR_EXIT, x, y, l, 0, 0)
	set_door_target(exitdoor, 4, 2, THEME.TIAMAT)
	if options.hd_test_unlockbossexits == false then
		lock_door_at(x, y)
	end
end

function create_entrance_hell()
	HELL_X = math.random(4,41)
	door_target = spawn(ENT_TYPE.FLOOR_DOOR_EGGPLANT_WORLD, HELL_X, 87, LAYER.FRONT, 0, 0)
	set_door_target(door_target, 5, PREFIRSTLEVEL_NUM, THEME.VOLCANA)
	
	if OBTAINED_BOOKOFDEAD == true then
		helldoor_e = get_entity(door_target):as_movable()
		helldoor_e.flags = set_flag(helldoor_e.flags, 20)
		helldoor_e.flags = clr_flag(helldoor_e.flags, 22)
		-- set_timeout(function()
			-- helldoors = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EGGPLANT_WORLD, 0, HELL_X, 87, LAYER.FRONT, 2)
			-- if #helldoors > 0 then
				-- helldoor_e = get_entity(helldoors[1]):as_movable()
				-- helldoor_e.flags = set_flag(helldoor_e.flags, 20)
				-- helldoor_e.flags = clr_flag(helldoor_e.flags, 22)
				-- -- toast("Aaalllright come on in!!! It's WARM WHER YOU'RE GOIN HAHAHAH")
			-- end
		-- end, 5)
	end
end

function create_entrance_mothership(x, y, l)
	spawn_door(x, y, l, 3, 3, THEME.NEO_BABYLON)
end

function create_entrance_blackmarket(x, y, l)
	BLACKMARKET_ENTRANCE_UID = spawn_door(x, y, l, state.world, state.level+1, state.theme)
	-- spawn_entity(ENT_TYPE.LOGICAL_BLACKMARKET_DOOR, x, y, l, 0, 0)
	set_interval(entrance_blackmarket, 1)
end

function create_entrance_hauntedcastle(x, y, l)
	HAUNTEDCASTLE_ENTRANCE_UID = spawn_door(x, y, l, state.world, state.level+1, state.theme)
	set_interval(entrance_hauntedcastle, 1)
end

function create_ghost()
	xmin, _, xmax, _ = get_bounds()
	-- toast("xmin: " .. xmin .. " ymin: " .. ymin .. " xmax: " .. xmax .. " ymax: " .. ymax)
	
	if #players > 0 then
		p_x, p_y, p_l = get_position(players[1].uid)
		bx_mid = (xmax - xmin)/2
		gx = 0
		gy = p_y
		if p_x > bx_mid then gx = xmax+5 else gx = xmin-5 end
		spawn(ENT_TYPE.MONS_GHOST, gx, gy, p_l, 0, 0)
		toast("A terrible chill runs up your spine!")
	-- else
		-- toast("A terrible chill r- ...wait, where are the players?!?")
	end
end

function create_idol()
	local idols = get_entities_by_type(ENT_TYPE.ITEM_IDOL)
	if (
		#idols > 0 and
		feeling_check("RESTLESS") == false -- Instead, set `IDOL_UID` for the crystal skull during the scripted roomcode generation process
	) then
		IDOL_UID = idols[1]
		IDOL_X, IDOL_Y, idol_l = get_position(IDOL_UID)
		
		-- Idol trap variants
		if state.theme == THEME.DWELLING then
			spawn(ENT_TYPE.BG_BOULDER_STATUE, IDOL_X, IDOL_Y+2.5, idol_l, 0, 0)
		elseif state.theme == THEME.JUNGLE then
			for j = 1, 6, 1 do
				local blocks = get_entities_at(0, MASK.FLOOR, (math.floor(IDOL_X)-3)+j, math.floor(IDOL_Y), LAYER.FRONT, 1)
				idoltrap_blocks[j] = blocks[1]
			end
		elseif state.theme == THEME.ICE_CAVES then
			boulderbackgrounds = get_entities_by_type(ENT_TYPE.BG_BOULDER_STATUE)
			if #boulderbackgrounds > 0 then
				kill_entity(boulderbackgrounds[1])
			end
		-- elseif state.theme == THEME.TEMPLE then
			-- -- ACTIVEFLOOR_CRUSHING_ELEVATOR flipped upsidedown for idol trap?? --Probably doesn't work
		end
	end
end

function create_idol_crystalskull()
	idols = get_entities_by_type(ENT_TYPE.ITEM_MADAMETUSK_IDOL)
	if #idols > 0 then
		IDOL_UID = idols[1]
		x, y, _ = get_position(idols[1])
		IDOL_X, IDOL_Y = x, y
	end
end

function create_wormtongue(x, y, l)
	set_interval(tongue_animate, 15)
	-- currently using level generation to place stickytraps
	stickytrap_uid = spawn_entity(ENT_TYPE.FLOOR_STICKYTRAP_CEILING, x, y, l, 0, 0)
	sticky = get_entity(stickytrap_uid)
	sticky.flags = set_flag(sticky.flags, 1)
	sticky.flags = clr_flag(sticky.flags, 3)
	move_entity(stickytrap_uid, x, y+1.15, 0, 0) -- avoids breaking surfaces by spawning trap on top of them
	balls = get_entities_by_type(ENT_TYPE.ITEM_STICKYTRAP_BALL) -- HAH balls
	if #balls > 0 then
		TONGUE_BG_UID = spawn_entity(ENT_TYPE.BG_LEVEL_DECO, x, y, l, 0, 0)
		worm_background = get_entity(TONGUE_BG_UID)
		worm_background.animation_frame = 8 -- jungle: 8 icecaves: probably 9
	
		-- sticky part creation
		TONGUE_UID = balls[1] -- HAHA tongue and balls
		ball = get_entity(TONGUE_UID):as_movable()
		ball.width = 1.35
		ball.height = 1.35
		ball.hitboxx = 0.3375
		ball.hitboxy = 0.3375
		
		ballstems = get_entities_by_type(ENT_TYPE.ITEM_STICKYTRAP_LASTPIECE)
		for _, ballstem_uid in ipairs(ballstems) do
			ballstem = get_entity(ballstem_uid)
			ballstem.flags = set_flag(ballstem.flags, 1)
			ballstem.flags = clr_flag(ballstem.flags, 9)
		end
		balltriggers = get_entities_by_type(ENT_TYPE.LOGICAL_SPIKEBALL_TRIGGER)
		for _, balltrigger in ipairs(balltriggers) do kill_entity(balltrigger) end
		
		worm_exit_uid = spawn_door(x, y, l, state.world, state.level+1, THEME.EGGPLANT_WORLD)
		worm_exit = get_entity(worm_exit_uid)
		worm_exit.flags = set_flag(worm_exit.flags, 28) -- pause ai to prevent magnetizing damsels
		lock_door_at(x, y)
		
		
		
		TONGUE_STATE = TONGUE_SEQUENCE.READY
		
		set_timeout(function()
			x, y, l = get_position(TONGUE_UID)
			door_platforms = get_entities_at(ENT_TYPE.FLOOR_DOOR_PLATFORM, 0, x, y, l, 1.5)
			if #door_platforms > 0 then
				door_platform = get_entity(door_platforms[1])
				door_platform.flags = set_flag(door_platform.flags, 1)
				door_platform.flags = clr_flag(door_platform.flags, 3)
				door_platform.flags = clr_flag(door_platform.flags, 8)
			else toast("No Worm Door platform found") end
			-- TODO: Platform seems not to spawn if vine is in the way
		end, 2)
	else
		toast("No STICKYTRAP_BALL found, no tongue generated.")
		kill_entity(stickytrap_uid)
		TONGUE_STATE = TONGUE_SEQUENCE.GONE
	end
end

function idol_disturbance()
	if IDOL_UID ~= nil then
		x, y, l = get_position(IDOL_UID)
		return (x ~= IDOL_X or y ~= IDOL_Y)
	end
end

function detect_same_levelstate(t_a, l_a, w_a)
	if state.theme == t_a and state.level == l_a and state.world == w_a then return true else return false end
end

function detect_s2market()
	if test_flag(state.quest_flags, 18) == true then
		market_doors = get_entities_by_type(ENT_TYPE.LOGICAL_BLACKMARKET_DOOR)
		if (#market_doors > 0) then -- or (state.theme == THEME.JUNGLE and levelsize[2] >= 4)
			return true
		end
	end
	return false
end


-- -- won't set if already set to the current level or a past level
-- function feeling_set_once_future(feeling, levels, use_chance)
	-- if ( -- don't set it if it's on the correct theme and the level is set and it's set to the current level or a past level
		-- detect_feeling_themes(feeling) == false or
		-- (
			-- global_feelings[feeling].load ~= nil and
			-- global_feelings[feeling].load <= state.level
		-- )
	-- ) then return false
	-- else
		-- return feeling_set(feeling, levels, use_chance)
	-- end
-- end
-- won't set if the current theme doesn't match and load has already been set
function feeling_set_once(feeling, levels)
	if (
		detect_feeling_themes(feeling) == false or
		global_feelings[feeling].load ~= nil
	) then return false
	else
		return feeling_set(feeling, levels)
	end
end

-- if multiple levels and false are passed in, a random level in the table is set
	-- NOTE: won't set to a past level
function feeling_set(feeling, levels)
	roll = math.random()
	chance = 1
	if global_feelings[feeling].chance ~= nil then
		chance = global_feelings[feeling].chance
	end
	if chance >= roll then
		levels_indexed = {}
		for _, level in ipairs(levels) do
			if level >= state.level then
				levels_indexed[#levels_indexed+1] = level
			end
		end
		global_feelings[feeling].load = levels_indexed[math.random(1, #levels_indexed)]
		return true
	else return false end
end

function detect_feeling_themes(feeling)
	for _, feeling_theme in ipairs(global_feelings[feeling].themes) do
		if state.theme == feeling_theme then
			return true
		end
	end
	return false
end

function feeling_check(feeling)
	if (
		detect_feeling_themes(feeling) == true and
		state.level == global_feelings[feeling].load
	) then return true end
	return false
end

-- detect offset
function detection_floor(x, y, l, offsetx, offsety, _radius)
	_radius = _radius or 0.1
	local blocks = get_entities_at(0, MASK.FLOOR, x+offsetx, y+offsety, l, _radius)
	if (#blocks > 0) then
		return blocks[1]
	end
	return -1
end

-- return status: 1 for conflict, 0 for right side, -1 for left.
function conflictdetection_giant(hdctype, x, y, l)
	conflict_rightside = false
	scan_width = 1 -- check 2 across
	scan_height = 2 -- check 3 up
	floor_level = 1 -- default to frog
	-- if hdctype == HD_COLLISIONTYPE.GIANT_FROG then
		
	-- end
	if hdctype == HD_COLLISIONTYPE.GIANT_SPIDER then
		floor_level = 2 -- check ceiling
	end
	x_leftside = x - 1
	y_scanbase = y - 1
	for sides_xi = x, x_leftside, -1 do
		for block_yi = y_scanbase, y_scanbase+scan_height, 1 do
			for block_xi = sides_xi, sides_xi+scan_width, 1 do
				avoidair = true
				if block_yi == y_scanbase + floor_level then
					avoidair = false
				end
				if (
					(avoidair == false and (detection_floor(block_xi, block_yi, l, 0, 0) ~= -1)) or
					(avoidair == true and (detection_floor(block_xi, block_yi, l, 0, 0) == -1))
				) then
					conflict_rightside = true
				end
			end
		end
		if conflict_rightside == false then
			if sides_xi == x_leftside then
				return -1
			else
				return 0
			end
		end
	end
	return 1
end

-- detect blocks above and to the sides
function conflictdetection_floortrap(hdctype, x, y, l)
	conflict = false
	scan_width = 1 -- check 1 across
	scan_height = 1 -- check the space above
	if hdctype == HD_COLLISIONTYPE.FLOORTRAP and options.hd_z_antitrapcuck == true then
		scan_width = 1 -- check 1 across (1 on each side)
		scan_height = 0 -- check the space above + 1 more
	elseif hdctype == HD_COLLISIONTYPE.FLOORTRAP_TALL and options.hd_z_antitrapcuck == true then
		scan_width = 3 -- check 3 across (1 on each side)
		scan_height = 2 -- check the space above + 1 more
	end
	ey_above = y
	for block_yi = ey_above, ey_above+scan_height, 1 do
		-- skip sides when y == 1
		if block_yi < ey_above+scan_height then
			block_xi_min, block_xi_max = x, x
		else
			block_xi_min = x - math.floor(scan_width/2)
			block_xi_max = x + math.floor(scan_width/2)
		end
		for block_xi = block_xi_min, block_xi_max, 1 do
			conflict = (detection_floor(block_xi, block_yi, l, 0, 0) ~= -1)
			--TODO: test `return conflict` here instead (I know it will work -_- but just to be safe, test it first)
			if conflict == true then
				break
			end
		end
		if conflict == true then break end
	end
	return conflict
end

-- returns: optimal offset for conflicts
function conflictdetection(hdctype, x, y, l)
	offset = { 0, 0 }
	-- avoid_types = {ENT_TYPE.FLOOR_BORDERTILE, ENT_TYPE.FLOOR_GENERIC, ENT_TYPE.FLOOR_JUNGLE, ENT_TYPE.FLOORSTYLED_MINEWOOD, ENT_TYPE.FLOORSTYLED_STONE}
	-- HD_COLLISIONTYPE = {
		-- AIR_TILE_1 = 1,
		-- AIR_TILE_2 = 2,
		-- FLOORTRAP = 3,
		-- FLOORTRAP_TALL = 4,
		-- GIANT_FROG = 5,
		-- GIANT_SPIDER = 6,
		-- -- GIANT_FISH = 7
	-- } and
	if (
		hd_type.collisiontype ~= nil and
		(
			hd_type.collisiontype >= HD_COLLISIONTYPE.AIR_TILE_1
			-- hd_type.collisiontype == HD_COLLISIONTYPE.FLOORTRAP or
			-- hd_type.collisiontype == HD_COLLISIONTYPE.FLOORTRAP_TALL
		)
	) then
		if (
			hdctype == HD_COLLISIONTYPE.FLOORTRAP or
			hdctype == HD_COLLISIONTYPE.FLOORTRAP_TALL
		) then
			conflict = conflictdetection_floortrap(hdctype, x, y, l)
			if conflict == true then
				offset = nil
			else
				offset = { 0, 0 }
			end
		elseif (
			hdctype == HD_COLLISIONTYPE.GIANT_FROG or
			hdctype == HD_COLLISIONTYPE.GIANT_SPIDER
		) then
			side = conflictdetection_giant(hdctype, x, y, l)
			if side > 0 then
				offset = nil
			else
				offset = { side, 0 }
			end
		end
	end
	return offset
end

function decorate_floor(e_uid, offsetx, offsety)--e_type, --e_theme, orientation(?))
	spawn_entity_over(ENT_TYPE.DECORATION_GENERIC, e_uid, offsetx, offsety)
end

function generate_tile(_tilechar, _x, _y, _l)--, replacetile)
	--replacetile = replacetile or nil
		-- Future room replacement methods may lead to have `replacetile` be:
			-- uid
				-- to replace a single tile; all other entities potentially occupying the space will be taken care of in other ways.
			-- bool
				-- Remove everything in the space. Use get_entities_overlapping().

	x = _x
	y = _y
	l = _l
	hd_tiletype, hd_tiletype_post = HD_TILENAME[_tilechar], HD_TILENAME[_tilechar]
	if hd_tiletype == nil then return nil end
	-- chance_half = (math.random() >= 0.5)
	
	-- TODO:
		-- HD_FEELING:
			-- RESTLESS:
				-- Tomb: ENT_TYPE_DECORATION_LARGETOMB
				-- Crown: ITEM_DIAMOND -> custom animation_frame of the gold crown
					-- (worth $5000 in HD, might as well leave it as diamond)

	-- HD_ENT and ENT_TYPE spawning
	if hd_tiletype.entity_types ~= nil then
		entity_type_pool = hd_tiletype.entity_types
		entity_type = 0
		if (
			hd_tiletype.alternate_types ~= nil and
			hd_tiletype.alternate_types[state.theme] ~= nil
		) then
			entity_type_pool = hd_tiletype.alternate_types[state.theme]
		end
		
		if #entity_type_pool == 1 then
			entity_type = entity_type_pool[1]
		elseif #entity_type_pool > 1 then
			entity_type = TableRandomElement(entity_type_pool)
		end
		
		if entity_type == 0 then
			return HD_TILENAME["0"]
		else
			-- TODO: Make specific checks for the result.
			if entity_type == ENT_TYPE.FLOOR_GENERIC then hd_tiletype_post = HD_TILENAME["1"]
			elseif (entity_type == ENT_TYPE.LIQUID_WATER or entity_type == ENT_TYPE.LIQUID_LAVA) then hd_tiletype_post = HD_TILENAME["w"]
			-- If it doesn't have a matching HD_TILENAME, return the original one.
			end
		end
		floor_uid = spawn(entity_type, x, y, l, 0, 0)
		
		-- Notes:
			-- It seems that floorstyled spawns with a specific animation_frame.
			-- TODO: Make a system to inspect `postgen_levelcode` and based on its orientation, alter animation_frame for each.
			-- Both floorstyled and floor need an animation frame changer that has the following parameters for each:
			-- floorstyled:
				-- tilepool:
					-- single blocks
						-- lower right bottom tileframe 1
						-- lower right bottom tileframe 2
			-- floor:
				-- tilepool:
					-- single blocks
						-- lower right bottom tileframe 1
						-- lower right bottom tileframe 2
		-- decorate
			-- TODO: Use for placing decorations on floor tiles once placed.
			-- use orientation parameter to adjust what side the decorations need to go on. Take open sides into consideration.
		-- for degrees = 0, 270.0, 90.0 do
			-- offsetcoord = rotate(x, y, x, y+1, degrees)
			-- conflict = (detection_floor(offsetcoord[1], offsetcoord[2], _l, 0, 0) ~= -1)
			-- if conflict == false then
				-- decorate_floor(floor_uid, offsetcoord[1], offsetcoord[2])
			-- end
		-- end
	elseif hd_tiletype_post.hd_type ~= nil then
		danger_spawn(hd_tiletype_post.hd_type, x, y, l, false)
	end
	params = {x, y, l}
	if hd_tiletype_post.spawnfunction ~= nil then hd_tiletype_post.spawnfunction(params) end
	
	return hd_tiletype_post
end

function generate_chunk(c_roomcode, c_dimw, c_dimh, x, y, layer, offsetx, offsety)
	x_ = x + offsetx
	y_ = y + offsety
	i = 1
	for r_yi = 0, c_dimh-1, 1  do
		for r_xi = 0, c_dimw-1, 1 do
			generate_tile(c_roomcode:sub(i, i), x_+r_xi, y_-r_yi, layer)
			i = i + 1
		end
	end
end

function remove_room(roomx, roomy, layer)
	tc_x, tc_y = locate_cornerpos(roomx, roomy)
	for yi = 0, 8-1, 1  do
		for xi = 0, 10-1, 1 do
			local blocks = get_entities_at(0, MASK.FLOOR, tc_x+xi, tc_y-yi, layer, 0.1)
			for _, block in ipairs(blocks) do
				kill_entity(block)
			end
		end
	end
	return tc_x, tc_y
end

function remove_borderfloor()
	for yi = 90, 88, -1 do
		for xi = 3, 42, 1 do
			local blocks = get_entities_at(ENT_TYPE.FLOOR_BORDERTILE, 0, xi, yi, LAYER.FRONT, 0.3)
			kill_entity(blocks[1])
		end
	end
end

function replace_room(c_roomcode, c_dimw, c_dimh, roomx, roomy, layer)
	moved_ghostpot, moved_damsel = nil, nil
	exits = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)
	if #exits > 0 then
		exit_x, exit_y, _ = get_position(exits[1])
		cx, cy = locate_cornerpos(roomx, roomy)
		checkradius = 0.5
		i = 1
		for yi = 0, c_dimh-1, 1  do
			for xi = 0, c_dimw-1, 1 do
				roomchar = c_roomcode:sub(i, i)
				damsels = get_entities_at(ENT_TYPE.MONS_PET_DOG, 0, cx+xi, cy-yi, layer, checkradius)
				damsels = TableConcat(damsels, get_entities_at(ENT_TYPE.MONS_PET_CAT, 0, cx+xi, cy-yi, layer, checkradius))
				damsels = TableConcat(damsels, get_entities_at(ENT_TYPE.MONS_PET_HAMSTER, 0, cx+xi, cy-yi, layer, checkradius))
				ghostpots = get_entities_at(ENT_TYPE.ITEM_CURSEDPOT, 0, cx+xi, cy-yi, layer, checkradius)
				
				if #damsels == 0 and #ghostpots == 0 then
					local blocks = get_entities_at(0, 0, cx+xi, cy-yi, layer, checkradius)
					for _, block in ipairs(blocks) do
						kill_entity(block)
					end
				else
					for _, damsel in ipairs(damsels) do
						-- Move the damsel to the exit?? I sure hope this method doesn't last for longer than a frame O_o
						move_entity(damsel, exit_x, exit_y, 0, 0)
						moved_damsel = damsel
					end
					for _, ghostpot in ipairs(ghostpots) do
						move_entity(ghostpot, exit_x, exit_y, 0, 0)
						moved_ghostpot = ghostpot
					end
				end
				if (
					ghostpot ~= nil and
					roomchar == "0" and
					i+c_dimw < string.len(c_roomcode) and
					c_roomcode:sub(i+c_dimw, i+c_dimw) ~= "0"
				) then
					move_entity(moved_ghostpot, xi, yi, 0, 0)
				elseif (
					moved_damsel ~= nil and
					roomchar == "0" and
					i+c_dimw < string.len(c_roomcode) and
					c_roomcode:sub(i+c_dimw, i+c_dimw) ~= "0"
				) then
					move_entity(moved_damsel, xi, yi, 0, 0)
				else
					generate_tile(roomchar, cx+xi, cy-yi, layer)
				end
				i = i + 1
			end
		end
	else
		toast("AAAAH there's no exit to store important stuff at so we can't replace that room :(")
	end
end

function decorate_tree(e_type, p_uid, side, y_offset, radius, right)
	if p_uid == 0 then return 0 end
	p_x, p_y, p_l = get_position(p_uid)
	branches = get_entities_at(e_type, 0, p_x+side, p_y, p_l, radius)
	branch_uid = 0
	if #branches == 0 then
		branch_uid = spawn_entity_over(e_type, p_uid, side, y_offset)
	else
		branch_uid = branches[1]
	end
	-- flip if you just created it and it's a 0x100 and it's on the left or if it's 0x200 and on the right.
	branch_e = get_entity(branch_uid)
	if branch_e ~= nil then
		-- flipped = test_flag(branch_e.flags, 17)
		if (#branches == 0 and branch_e.type.search_flags == 0x100 and side == -1) then
			flip_entity(branch_uid)
		elseif (branch_e.type.search_flags == 0x200 and right == true) then
			branch_e.flags = set_flag(branch_e.flags, 17)
		end
	end
	return branch_uid
end

function remove_entitytype_inventory(entity_type, inventory_entities)
	items = get_entities_by_type(inventory_entities)
	for r, inventoryitem in ipairs(items) do
		local mount = get_entity(inventoryitem):topmost()
		if mount ~= -1 and mount:as_container().type.id == entity_type then
			move_entity(inventoryitem, -r, 0, 0, 0)
			-- toast("Should be hermitcrab: ".. mount.uid)
		end
	end
end

-- removes all types of an entity from any player that has it.
function remove_player_item(powerup, player)
	powerup_uids = get_entities_by_type(powerup)
	for i = 1, #powerup_uids, 1 do
		for j = 1, #players, 1 do
			if entity_has_item_uid(players[j].uid, powerup_uids[i]) then
				entity_remove_item(players[j].uid, powerup_uids[i])
			end
		end
	end
end

function animate_bookofdead(tick_limit)
	if bookofdead_tick <= tick_limit then
		bookofdead_tick = bookofdead_tick + 1
	else
		if bookofdead_frames_index == bookofdead_frames then
			bookofdead_frames_index = 1
		else
			bookofdead_frames_index = bookofdead_frames_index + 1
		end
		bookofdead_tick = 0
	end
end

function changestate_onloading_targets(w_a, l_a, t_a, w_b, l_b, t_b)
	if detect_same_levelstate(t_a, l_a, w_a) == true then
		if test_flag(state.quest_flags, 1) == false then
			state.level_next = l_b
			state.world_next = w_b
			state.theme_next = t_b
		end
	end
end

-- Used to "fake" world/theme/level
function changestate_onlevel_fake(w_a, l_a, t_a, w_b, l_b, t_b)--w_b=0, l_b=0, t_b=0)
	if detect_same_levelstate(t_a, l_a, w_a) == true then --and (w_b ~= 0 or l_b ~= 0 or t_b ~= 0) then
		-- if test_flag(state.quest_flags, 1) == false then
			state.level = l_b
			state.world = w_b
			state.theme = t_b
		-- end
	end
end

-- "fake" world/theme/level to let you set quest flags that otherwise wouldn't apply to the first level of a world
function changestate_onlevel_fake_applyquestflags(w, l, t, flags_set, flags_clear)--w_a, l_a, t_a, w_b, l_b, t_b, flags_set, flags_clear)
	flags_set = flags_set or {}
	flags_clear = flags_clear or {}
	if detect_same_levelstate(t, PREFIRSTLEVEL_NUM, w) == true then--t_a, l_a, w_a) == true then
		applyflags_to_quest({flags_set, flags_clear})
		-- TODO: Consider the consequences of skipping over a level (such as shopkeeper forgiveness)
			-- IDEAS:
				-- if wantedlevel > 0 then wantedlevel = wantedlevel+1
		warp(w, l, t)
	end
end

function changestate_onloading_applyquestflags(w_a, l_a, t_a, flags_set, flags_clear)--w_b, l_b, t_b, flags_set, flags_clear)
	flags_set = flags_set or {}
	flags_clear = flags_clear or {}
	if detect_same_levelstate(t_a, l_a, w_a) == true then
		applyflags_to_quest({flags_set, flags_clear})
	end
end

function entrance_blackmarket()
	ex, ey, _ = get_position(BLACKMARKET_ENTRANCE_UID)
	for i = 1, #players, 1 do
		x, y, _ = get_position(players[i].uid)
		closetodoor = 0.5
		
		if (
			players[i].state == 19 and
			(y+closetodoor >= ey and y-closetodoor <= ey) and
			(x+closetodoor >= ex and x-closetodoor <= ex)
		) then
			feeling_set_once("BLACKMARKET", {state.level+1})
		end
	end
end

function entrance_hauntedcastle()
	ex, ey, _ = get_position(HAUNTEDCASTLE_ENTRANCE_UID)
	for i = 1, #players, 1 do
		x, y, _ = get_position(players[i].uid)
		closetodoor = 0.5
		
		if (
			players[i].state == 19 and
			(y+closetodoor >= ey and y-closetodoor <= ey) and
			(x+closetodoor >= ex and x-closetodoor <= ex)
		) then
			feeling_set_once("HAUNTEDCASTLE", {state.level+1})
		end
	end
end

function exit_olmec()
	for i = 1, #players, 1 do
		x, y, l = get_position(players[i].uid)
		
		if players[i].state == 19 and y > 95 then
			state.win_state = 1
			break
		else
			state.win_state = 0
		end
	end
end

function exit_yama() -- TODO: Merge these methods into one that takes parameters
	for i = 1, #players, 1 do
		x, y, l = get_position(players[i].uid)
		
		if players[i].state == 19 then-- and y > ??? then
			state.win_state = 2
			break
		else
			state.win_state = 0
		end
	end
end

function exit_winstate()
	if state.theme == THEME.OLMEC then
		set_interval(exit_olmec, 1)
	-- elseif state.theme == ??? then
		-- set_interval(exit_yama, 1)
	end
end

function exit_reverse()
	exits = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)
	entrances = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_ENTRANCE)
	x, y, l = get_position(exits[1])
	exit_mov = get_entity(exits[1]):as_movable()
	nextworld, nextlevel, nexttheme = get_door_target(exit_mov.uid)
	for i,player in ipairs(players) do
		teleport_mount(player, x, y)
	end
	for i,v in ipairs(exits) do
		x, y, l = get_position(v)
		move_entity(v, x+100, y, 0, 0)
		lock_door_at(x, y)
	end
	for i,v in ipairs(entrances) do
		x, y, l = get_position(v)
		door(x, y, l, nextworld, nextlevel, nexttheme)
		unlock_door_at(x, y)
	end
end

function test_tileapplier9000()
	_x, _y, l = 45, 90, LAYER.FRONT -- next to entrance
	testfloors = {}
	width = 3
	height = 4
	toassign = {}
	toassign = {
		uid_offsetpair = {
			-- {uid = testfloors[1], offset = {1, 1}},
		},
		dim = {width, height}
	}
	for yi = 0, -(height-1), -1 do -- 0 -> -3
		for xi = 0, (width-1), 1 do -- 0 -> 2
			-- testfloors[#testfloors+1] = spawn_entity(ENT_TYPE.FLOOR_GENERIC, _x+(xi-1), _y+(yi-1), l, 0, 0)
			table.insert(toassign.uid_offsetpair, {uid = spawn_entity(ENT_TYPE.FLOOR_GENERIC, _x+xi, _y-yi, l, 0, 0), offset = {xi, yi}})
		end
	end
	tileapplier9000(toassign)
	-- testfloor_e = get_entity(testfloors[1])
	-- testfloor_m = testfloor_e:as_movable()
	-- animation_frame = testfloor_m.animation_frame
	-- toast(tostring(_x) .. ", " .. tostring(_y) .. ": " .. tostring(animation_frame))

end

function test_bacterium()
	
	-- Bacterium Creation
		-- FLOOR_THORN_VINE:
			-- flags = clr_flag(flags, 2) -- indestructable (maybe need to clear this? Not sure yet)
			-- flags = clr_flag(flags, 3) -- solid wall
			-- visible
			-- allow hurting player
			-- disable collisions
			-- allow bombs to destroy them.
		-- ACTIVEFLOOR_BUSHBLOCK:
			-- invisible
			-- disable collisions
			-- allow taking damage (unless it's already enabled by default)
		-- ITEM_ROCK:
			-- disable physics
				-- re-enable once detached from surface
	-- Challenge: Let rock attatch to surface, move it on frame.

end

function test_levelsize()
	levelw, levelh = get_levelsize()
	toast("levelw: " .. tostring(levelw) .. ", levelh: " .. tostring(levelh))
end

define_tile_code("campfix")
define_tile_code("generation")

set_pre_tile_code_callback(function(x, y, layer)
	generate_chunk("222111", 3, 2, x, y, layer, 0, 0)
	return true
end, "generation")

set_pre_tile_code_callback(function(x, y, layer)
	tospawn = ENT_TYPE.FLOOR_DOOR_STARTING_EXIT
	if x == 21 then
		if y == 84 then
			tospawn = ENT_TYPE.FLOOR_GENERIC
		else return true end
	end
	spawn(tospawn, x, y, LAYER.FRONT, 0, 0)
	return true
end, "campfix")

-- set_pre_tile_code_callback(function(x, y, layer)
	-- if state.theme == THEME.JUNGLE then
		-- if detect_s2market() == true and layer == LAYER.FRONT and y < 88 then
			-- -- spawn(ENT_TYPE., x, y, layer, 0, 0)
			-- return true
		-- end
	-- end
	-- spawn(ENT_TYPE.FLOOR_GENERIC, x, y, layer, 0, 0)
	
	-- return true
-- end, "floor")

-- `set_pre_tile_code_callback` todos:
	-- “floor” -- if state.camp and shortcuts discovered, then
		-- if state.transition, if transition between worm and next level then
			-- replace floor with worm guts
		-- end
		-- if transition from jungle to ice caves then
			-- replace stone with floor_jungle end if transition from ice caves to temple then replace quicksand with stone
		-- end
		-- if state.level and detect_s2market()
			-- if (within the coordinates of where water should be)
				-- replace with water
			-- if (within the coordinates of where border should be)
				-- return false
			-- if (within the coordinates of where void should be)
				-- replace with nothing
			-- end
	-- “border(?)” see if you can change styles from here
		-- if detect_s2market() and `within the coordinates of where water should be` then
			-- replace with water
		-- end

	-- “treasure” if state.theme == THEME.OLMEC (or temple?) then use the hd tilecode chance for treasure when in temple/olmec
	-- “regenerating_wall50%” if state.theme == THEME.EGGPLANTWORLD then use the hd tilecode chance for floor50%(“2”) when in the worm

-- `set_post_tile_code_callback` todos:
	-- probably not needed since you don't use these tilecodes anymore
		-- “fountain_head”/“fountain_drain” if state.theme == THEME.VOLCANA then change the color of the fountain head (In the future, this should be replaced by changing which texture sheet it pulls from *adjusting when needed, for instance, COG)

-- ON.CAMP
set_callback(function()
	oncamp_movetunnelman()
	oncamp_shortcuts()
	
	
	-- signs_back = get_entities_by_type(ENT_TYPE.BG_TUTORIAL_SIGN_BACK)
	-- signs_front = get_entities_by_type(ENT_TYPE.BG_TUTORIAL_SIGN_FRONT)
	-- x, y, l = 49, 90, LAYER.FRONT -- next to entrance
	
	
end, ON.CAMP)

-- ON.START
set_callback(function()
	onstart_init_options()
	onstart_init_methods()
	unlocks_init()
	global_feelings = TableCopy(HD_FEELING)
	RUN_UNLOCK = nil
end, ON.START)

-- ON.LOADING
set_callback(function()
	onloading_levelrules()
	onloading_applyquestflags()
end, ON.LOADING)

set_callback(function()
--ONLEVEL_PRIORITY: 1 - Set level constants (ie, init(), level feelings, levelrules)
	init()
	unlocks_load()
	onlevel_levelrules()
	onlevel_detection_feeling()
	onlevel_setfeelingmessage()
--ONLEVEL_PRIORITY: 2 - Misc ON.LEVEL methods applied to the level in its unmodified form
	onlevel_reverse_exits()
--ONLEVEL_PRIORITY: 3 - Perform any script-generated chunk creation
	onlevel_generation_detection()
	onlevel_generation_modification()
	onlevel_generation_execution()
	generation_removeborderfloor() -- TODO: Once level generation for mothership and flooded is started, outdate
	
	-- onlevel_replace_powderkegs()
	-- onlevel_generation_pushblocks() -- PLACE AFTER onlevel_generation
--ONLEVEL_PRIORITY: 4 - Set up dangers (LEVEL_DANGERS)
	onlevel_dangers_init()
	onlevel_dangers_modifications()
	onlevel_dangers_setonce()
	set_timeout(onlevel_dangers_replace, 3)
--ONLEVEL_PRIORITY: 5 - Remaining ON.LEVEL methods (ie, IDOL_UID)
	onlevel_placement_lockedchest() -- TODO: Revise into onlevel_generation
	onlevel_nocursedpot() -- PLACE AFTER onlevel_placement_lockedchest()
	onlevel_prizewheel()
	onlevel_idoltrap()
	onlevel_remove_mounts()
	-- onlevel_decorate_cookfire()
	onlevel_decorate_trees()
	-- onlevel_blackmarket_ankh()
	onlevel_add_wormtongue()
	onlevel_crysknife()
	onlevel_hide_yama()
	onlevel_acidbubbles()
	onlevel_add_botd()
	onlevel_boss_init()
	onlevel_toastfeeling()
end, ON.LEVEL)

set_callback(function()
	onframe_manage_dangers()
	onframe_bacterium()
	onframe_ghosts()
	onframe_manage_inventory()
	onframe_prizewheel()
	onframe_idoltrap()
	onframe_tonguetimeout()
	onframe_acidpoison()
	onframe_boss()
end, ON.FRAME)

set_callback(function()
	onguiframe_ui_animate_botd()
	onguiframe_ui_info_boss()			-- debug
	onguiframe_ui_info_wormtongue() 	--
	onguiframe_ui_info_boulder()		--
	onguiframe_ui_info_feelings()		--
	onguiframe_ui_info_path()			--
	onguiframe_env_animate_prizewheel()
end, ON.GUIFRAME)



function onstart_init_options()	
	OBTAINED_BOOKOFDEAD = options.hd_test_give_botd
	if options.hd_og_ghost_time == true then GHOST_TIME = 9000 end

	-- UI_BOTD_PLACEMENT_W = options.hd_ui_botd_a_w
	-- UI_BOTD_PLACEMENT_H = options.hd_ui_botd_b_h
	-- UI_BOTD_PLACEMENT_X = options.hd_ui_botd_c_x
	-- UI_BOTD_PLACEMENT_Y = options.hd_ui_botd_d_y
end

function onstart_init_methods()
	set_ghost_spawn_times(GHOST_TIME, GHOST_TIME-1800)
	
	set_olmec_phase_y_level(0, 10.0)
	set_olmec_phase_y_level(1, 9.0)
	set_olmec_phase_y_level(2, 8.0)
end

-- LEVEL HANDLING
function onloading_levelrules()
	
	-- Base Camp -> Jungle 2-1
    -- changestate_onloading_targets(1,1,THEME.BASE_CAMP,2,2,THEME.JUNGLE) -- fake 2-1
	
	-- Dwelling 1-3 -> Dwelling 1-5(Fake 1-4)
    changestate_onloading_targets(1,3,THEME.DWELLING,1,5,THEME.DWELLING)
    -- Dwelling -> Jungle
    changestate_onloading_targets(1,4,THEME.DWELLING,2,1,THEME.JUNGLE)--PREFIRSTLEVEL_NUM,THEME.JUNGLE)
	-- -- Jungle 2-1 -> Jungle 2->2
    -- if state.nexttheme ~= EGGPLANT_WORLD then
		-- changestate_onloading_targets(2,1,THEME.JUNGLE,2,3,THEME.JUNGLE) -- fake 2-2
	-- end
	-- -- Jungle 2-2 -> Jungle 2->3
    -- changestate_onloading_targets(2,2,THEME.JUNGLE,2,4,THEME.JUNGLE) -- fake 2-3
	-- -- Jungle 2-3 -> Jungle 2->4
    -- changestate_onloading_targets(2,3,THEME.JUNGLE,2,5,THEME.JUNGLE) -- fake 2-4
	-- Jungle 2-1 -> Worm 2-2
		-- TODO(? may not need to handle this)
	-- Worm(Jungle) 2-2 -> Jungle 2-4
	changestate_onloading_targets(2,2,THEME.EGGPLANT_WORLD,2,4,THEME.JUNGLE)
    -- Jungle -> Ice Caves
    changestate_onloading_targets(2,4,THEME.JUNGLE,3,1,THEME.ICE_CAVES)--PREFIRSTLEVEL_NUM,THEME.ICE_CAVES)
    -- Ice Caves -> Ice Caves
		-- TODO: Test if there are differences for room generation chances for levels higher than 3-1 or 3-4.
    changestate_onloading_targets(3,1,THEME.ICE_CAVES,3,2,THEME.ICE_CAVES)
    changestate_onloading_targets(3,2,THEME.ICE_CAVES,3,3,THEME.ICE_CAVES)
    changestate_onloading_targets(3,3,THEME.ICE_CAVES,3,4,THEME.ICE_CAVES)
	-- Mothership -> Ice Caves
    changestate_onloading_targets(3,3,THEME.NEO_BABYLON,3,4,THEME.ICE_CAVES)
    -- Ice Caves -> Temple
    changestate_onloading_targets(3,4,THEME.ICE_CAVES,4,1,THEME.TEMPLE)--PREFIRSTLEVEL_NUM,THEME.TEMPLE)
	-- Ice Caves 3-1 -> Worm
		-- TODO(? may not need to handle this)
	-- Worm(Ice Caves) 3-2 -> Ice Caves 3-4
	changestate_onloading_targets(3,2,THEME.EGGPLANT_WORLD,3,4,THEME.ICE_CAVES)
    -- Temple -> Olmec
    changestate_onloading_targets(4,3,THEME.TEMPLE,4,4,THEME.OLMEC)
    -- COG(4-3) -> Olmec
    changestate_onloading_targets(4,3,THEME.CITY_OF_GOLD,4,4,THEME.OLMEC)
	
	-- Hell -> Yama
		-- TODO: Figure out a place to host Yama. Maybe a theme with different FLOOR_BORDERTILE textures?
		-- IDEA: Tiamat's chamber.
	-- changestate_onloading_targets(5,3,THEME.VOLCANA,5,4,???)
end

-- executed with the assumption that onloading_levelrules() has already been run, applying state.*_next
function onloading_applyquestflags()
	flags_failsafe = {
		10, -- Disable Waddler's
		25, 26, -- Disable Moon and Star challenges.
		19 -- Disable drill -- OR: disable drill until you get to level 4, then enable it if you want to use drill level for yama
	}
	for i = 1, #flags_failsafe, 1 do
		if test_flag(state.quest_flags, flags_failsafe[i]) == false then state.quest_flags = set_flag(state.quest_flags, flags_failsafe[i]) end
	end
	
	-- Jungle:
	-- 3->4: Clr 18 -- allow rushing water feeling
	changestate_onloading_applyquestflags(2, 3, THEME.JUNGLE, {}, {18})

end

-- Entities that spawn with methods that are only set once
function onlevel_dangers_setonce()
	-- loop through all dangers in global_dangers, setting enemy specifics
	if LEVEL_DANGERS[state.theme] and #global_dangers > 0 then
		for i = 1, #global_dangers, 1 do
			hd_type = global_dangers[i]
			if hd_type.removeinventory ~= nil then
				if hd_type.removeinventory == HD_REMOVEINVENTORY.SNAIL then
					set_timeout(function()
						hd_type = HD_ENT.SNAIL
						remove_entitytype_inventory(
							hd_type.removeinventory.inventory_ownertype,
							hd_type.removeinventory.inventory_entities
						)
					end, 5)
				elseif hd_type.removeinventory == HD_REMOVEINVENTORY.SCORPIONFLY then
					set_timeout(function()
						hd_type = HD_ENT.SCORPIONFLY
						remove_entitytype_inventory(
							hd_type.removeinventory.inventory_ownertype,
							hd_type.removeinventory.inventory_entities
						)
					end, 5)
				end
			end
			if hd_type.replaceoffspring ~= nil then
				if hd_type.replaceoffspring == HD_REPLACE.EGGSAC then
					set_interval(function() enttype_replace_danger({ ENT_TYPE.MONS_GRUB }, HD_ENT.WORMBABY, false, 0, 0) end, 1)
				end
			end
			if hd_type.liquidspawn ~= nil then
				if hd_type.liquidspawn == HD_LIQUIDSPAWN.PIRANHA then
					enttype_replace_danger(
						{
							ENT_TYPE.MONS_MOSQUITO,
							ENT_TYPE.MONS_WITCHDOCTOR,
							ENT_TYPE.MONS_CAVEMAN,
							ENT_TYPE.MONS_TIKIMAN,
							ENT_TYPE.MONS_MANTRAP,
							ENT_TYPE.MONS_MONKEY,
							ENT_TYPE.ITEM_SNAP_TRAP
						},
						HD_ENT.PIRANHA,
						true,
						0, 0
					)
				end
			end
		end
	end
end
-- DANGER DB MODIFICATIONS
-- Modifications that use methods that are only needed to be applied once.
-- This includes:
	-- EntityDB properties
function onlevel_dangers_modifications()
	-- loop through all dangers in global_dangers, setting enemy specific
	if LEVEL_DANGERS[state.theme] and #global_dangers > 0 then
		for i = 1, #global_dangers, 1 do
			if global_dangers[i].entitydb ~= nil and global_dangers[i].entitydb ~= 0 then
				s = spawn(global_dangers[i].entitydb, 0, 0, LAYER.FRONT, 0, 0)
				s_mov = get_entity(s):as_movable()
				
				if global_dangers[i].health_db ~= nil and global_dangers[i].health_db > 0 then
					s_mov.type.life = global_dangers[i].health_db
				end
				if global_dangers[i].sprint_factor ~= nil and global_dangers[i].sprint_factor >= 0 then
					s_mov.type.sprint_factor = global_dangers[i].sprint_factor
				end
				if global_dangers[i].max_speed ~= nil and global_dangers[i].max_speed >= 0 then
					s_mov.type.max_speed = global_dangers[i].max_speed
				end
				if global_dangers[i].jump ~= nil and global_dangers[i].jump >= 0 then
					s_mov.type.jump = global_dangers[i].jump
				end
				if global_dangers[i].dim_db ~= nil and #global_dangers[i].dim_db == 2 then
					s_mov.type.width = global_dangers[i].dim[1]
					s_mov.type.height = global_dangers[i].dim[2]
				end
				if global_dangers[i].damage ~= nil and global_dangers[i].damage >= 0 then
					s_mov.type.damage = global_dangers[i].damage
				end
				if global_dangers[i].acceleration ~= nil and global_dangers[i].acceleration >= 0 then
					s_mov.type.acceleration = global_dangers[i].acceleration
				end
				if global_dangers[i].friction ~= nil and global_dangers[i].friction >= 0 then
					s_mov.type.friction = global_dangers[i].friction
				end
				if global_dangers[i].weight ~= nil and global_dangers[i].weight >= 0 then
					s_mov.type.weight = global_dangers[i].weight
				end
				if global_dangers[i].elasticity ~= nil and global_dangers[i].elasticity >= 0 then
					s_mov.type.elasticity = global_dangers[i].elasticity
				end
				
				apply_entity_db(s)
			end
		end
	end
end

-- TODO: Replace with a manual enemy spawning system.
	-- Notes:
		-- kays:
			-- "I believe it's a 1/N chance that any possible place for that enemy to spawn, it spawns. so in your example, for level 2 about 1/20 of the possible tiles for that enemy to spawn will actually spawn it"
	
		-- Dr.BaconSlices:
			-- "Yup, all it does is roll that chance on any viable tile. There are a couple more quirks, or so I've heard, like enemies spawning with more air around them rather than in enclosed areas, whereas treasure is more likely to be in cramped places. And of course, it checks for viable tiles instead of any tile, so it won't place things inside of floors or other solids, within a liquid it isn't supposed to be in, etc. There's also stuff like bats generating along celiengs instead of the ground, but I don't think I need to explain that haha"
			-- "Oh yeah, I forgot to mention that. The priority is determined based on the list, which you can see here with 50 million bats but 0 spiders. I'm assuming both of their chances are set to 1,1,1,1 but you're still only seeing bats, and that's because they're generating in all of the places that spiders are able to."
	-- Spawn requirements:
		-- Traps
			-- Notes:
				-- replaces FLOOR_* and FLOORSTYLED_* (so platforms count as spaces)
				-- don't spawn in place of gold/rocks/pots
			-- Arrow Trap:
				-- Notes:
					-- are the only damaging entity to spawn in the entrance 
				-- viable tiles:
					-- if there are two blocks and two spaces, mark the inside block for replacement, unless the trigger hitbox would touch the entrance door
				-- while spawning:
					-- don't spawn if it would result in its back touching another arrow trap
				
			-- Tiki Traps:
				-- Notes:
					-- Spawn after arrow traps
					-- are the only damaging entity to spawn in the entrance 
				-- viable space to place:
					-- Require a block on both sides of the block it's standing on
					-- Require a 3x2 space above the spawn
				-- viable tile to replace:
					-- 
				-- while spawning:
					-- don't spawn if it would result in its sides touching another tiki trap 
						-- HD doesn't check for this

-- DANGER MODIFICATIONS - ON.LEVEL
-- Find everything in the level within the given parameters, apply enemy modifications within parameters.
function onlevel_dangers_replace()
	if LEVEL_DANGERS[state.theme] then
		hd_types_toreplace = TableCopy(global_dangers)
		
		n = #hd_types_toreplace
		for i, danger in ipairs(hd_types_toreplace) do
			if danger.toreplace == nil then hd_types_toreplace[i] = nil end
		end
		hd_types_toreplace = CompactList(hd_types_toreplace, n)
		affected = get_entities_by_type(map(hd_types_toreplace, function(hd_type) return hd_type.toreplace end))
		giant_enemy = false
		-- toast("#hd_types_toreplace: " .. tostring(#hd_types_toreplace))
		-- toast("#affected: " .. tostring(#affected))

		for _,ent_uid in ipairs(affected) do
			e_ent = get_entity(ent_uid)
			if e_ent ~= nil then
				-- ex, ey, el = get_position(ent_uid)
				e_type = e_ent.type.id--e_ent:as_container().type.id
				
				
				variation = nil
				for i = 1, #LEVEL_DANGERS[state.theme].dangers, 1 do
					if (
						LEVEL_DANGERS[state.theme].dangers[i].entity ~= nil and
						LEVEL_DANGERS[state.theme].dangers[i].entity.toreplace ~= nil and
						LEVEL_DANGERS[state.theme].dangers[i].entity.toreplace == e_type and
						(
							LEVEL_DANGERS[state.theme].dangers[i].variation ~= nil and
							LEVEL_DANGERS[state.theme].dangers[i].variation.entities ~= nil and
							LEVEL_DANGERS[state.theme].dangers[i].variation.chances ~= nil and
							#LEVEL_DANGERS[state.theme].dangers[i].variation.entities == 2 and
							#LEVEL_DANGERS[state.theme].dangers[i].variation.chances == 2
						)
					) then
						variation = LEVEL_DANGERS[state.theme].dangers[i].variation
					end
				end
				-- TODO: Replace dangers.variation with HD_ENT property, including chance.
					-- Frogs can replace mosquitos by having 100% chance. ie, if it was 99%, 1% chance not to spawn.
				-- TODO: Make a table consisting of: [ENT_TYPE] = {uid, uid, etc...}
					-- For each ENT_TYPE, split uids evenly amongst `replacements.danger`
					-- Then run each replacement's chance to spawn, replacing it if successful, removing it if unsuccessful.
				replacements = {}
				for _, danger in ipairs(hd_types_toreplace) do
					if danger.toreplace == e_type then replacements[#replacements+1] = danger end
				end
				-- map replacement and their chances here
				if #replacements > 0 then --for _, replacement in ipairs(replacements) do
					hd_ent_tolog = replacements[1]-- replacement
					if variation ~= nil then
						chance = math.random()
						if (chance >= variation.chances[2] and giant_enemy == false) then
							giant_enemy = true
							hd_ent_tolog = variation.entities[2]
						elseif (chance < variation.chances[2] and chance >= variation.chances[1]) then
							hd_ent_tolog = variation.entities[1]
						end
					end
					danger_replace(ent_uid, hd_ent_tolog, true, 0, 0)
				end
			end
		end
	end
end

function onlevel_generation_detection()
	level_init()
	global_levelassembly.detection = {
		path = TableCopy(LEVEL_PATH)
		-- levelcode = 
	}
	-- loop over each room, detecting each block and writing it into .levelcode
end

-- CHUNK GENERATION - ON.LEVEL
-- Script-based roomcode and chunk generation
function onlevel_generation_modification()
	set_run_unlock()
	-- global_levelassembly.modification = {
		-- path = path_setn(get_levelsize())
		-- levelcode = levelcode_setn(get_levelsize())
	-- }

end

function onlevel_generation_execution()
	global_levelassembly.execution = {
		path = TableCopy(global_levelassembly.detection.path)
	}
	-- overwrite .execution.path with .modification.path in the places that it's not nil
	
	LEVEL_PATH = global_levelassembly.execution.path
	
-- kinda outdated nonsense:
	-- roomobject ideas:
	-- to spawn a coffin in olmec:
	-- add_coffin
			-- pick a random number between 
		-- 1: create the room object
			-- add to:
				-- subchunkid (optional): determine what to replace
				-- levelcoords (optional): level coordinates it can possibly spawn in (top left and top right)
				-- roomcodes: roomcodes it can possibly spawn
		-- NOTE: Use these like you use HD_ENT; You don't modify, instead use it to place roomcodes into global_levelassembly.roomcodes
		-- 2: figure out if global_levelassembly.roomobjects interfere with the path, if so, clean up
		-- 3: fill in appropriate levelcoord in global_levelassembly.roomobjects
			-- rooomobjects[4][1] = "1132032323..."
	

	-- idols = get_entities_by_type(ENT_TYPE.ITEM_IDOL)
	-- if #idols > 0 and feeling_check("RESTLESS") == true then
		-- idolx, idoly, idoll = get_position(idols[1])
		-- roomx, roomy = locate_roompos(idolx, idoly)
		-- -- cx, cy = remove_room(roomx, roomy, idoll)
		-- tmp_object = {
			-- roomcodes = {
				-- "ttttttttttttttttttttttp0c00ptt0tt0000tt00400000040ttt0tt0tttttp0000ptt1111111111"
				-- --"++++++++++++++++++++++00I000++0++0++0++00400000040+++0++0+++++000000++11GGGGGG11"
			-- },
			-- -- "tttttttttt
			-- -- tttttttttt
			-- -- ttp0c00ptt
			-- -- 0tt0000tt0
			-- -- 0400000040
			-- -- ttt0tt0ttt
			-- -- ttp0000ptt
			-- -- 1111111111"
			
			-- dimensions = { w = 10, h = 8 }
		-- }
		
		-- roomcode = tmp_object.roomcodes[1]
		-- dimw = tmp_object.dimensions.w
		-- dimh = tmp_object.dimensions.h
		-- replace_room(roomcode, dimw, dimh, roomx, roomy, idoll)
	-- end
	
	
	
	-- -- For cases where S2 differs in chunk (aka subchunk) generation:
		-- -- use a unique tilecode in the level editor to signify chunk placement
		-- -- Challenge: Jungle vine chunk.
		
		-- -- JUNGLE - SUBCHUNK - VINE
	-- tmp_object = {
		-- roomcodes = {
			-- "L0L0LL0L0LL000LL0000",
			-- -- L0L0L
			-- -- L0L0L
			-- -- L000L
			-- -- L0000
			
			-- "L0L0LL0L0LL000L0000L",
			-- -- L0L0L
			-- -- L0L0L
			-- -- L000L
			-- -- 0000L
			
			-- "0L0L00L0L00L0L0000L0"
			-- -- 0L0L0
			-- -- 0L0L0
			-- -- 0L0L0
			-- -- 000L0
		-- },
		-- dimensions = { w = 5, h = 4 }
	-- }
	
	-- fill uids_toembedin using global_levelassembly.modification.levelcode
end

function detect_viable_unlock_area()
	-- Where can AREA unlocks spawn?
		-- When it's in one of the four areas.
			-- Any exceptions to this, such as special areas?
				-- I'm going to ignore special cases, such as WORM where you're in another world, or BLACKMARKET. At least for now.
	if (
		state.theme == THEME.DWELLING
		or
		state.theme == THEME.JUNGLE
		or
		state.theme == THEME.ICE_CAVES
		or
		state.theme == THEME.TEMPLE
	) then return true end
	return false
end

function path_setn(levelw, levelh)
	path = {}
	setn(path, levelw)
	
	for wi = 1, levelw, 1 do
		th = {}
		setn(th, levelh)
		path[wi] = th
	end
	return path
end

function levelcode_setn(levelw, levelh)
	levelcodew, levelcodeh = levelw*10, levelh*8 
	levelcode = {}
	setn(levelcode, levelcodew)
	
	for wi = 1, levelcodew, 1 do
		th = {}
		setn(th, levelcodeh)
		levelcode[wi] = th
	end
	return levelcode
end

function set_run_unlock()
	-- BronxTaco:
		-- "rando characters will replace the character inside the level feeling coffin"
		-- "you can see this happen in kinnis old AC wr"
	-- jjg27:
		-- "I don't think randos can appear in the coffins for special areas: Worm, Castle, Mothership, City of Gold, Olmec's Lair."
	if RUN_UNLOCK == nil then
		chance = math.random()
		if (
			detect_viable_unlock_area() == true and
			RUN_UNLOCK_AREA_CHANCE >= chance
		) then
			RUN_UNLOCK = get_unlock_area()
		else
			RUN_UNLOCK = get_unlock()
		end
		
		if RUN_UNLOCK ~= nil then
			message("RUN_UNLOCK: " .. RUN_UNLOCK)
		end
	end
end

-- LEVEL HANDLING
-- For cases where room generation is hardcoded to a theme's level
-- and as a result we need to fake the world/level number
function onlevel_levelrules()
	-- Dwelling 1-5 = 1-4 (Dwelling 1-3 -> Dwelling 1-4)
	changestate_onlevel_fake(1,5,THEME.DWELLING,1,4,THEME.DWELLING)
	
	-- TOTEST:
	-- Use S2 Black Market as Flooded Feeling
		-- HD and S2 differences:
			-- S2 black market spawns are 2-2..4
			-- HD spawns are 2-1..3
				-- Prevents the black market from being accessed upon exiting the worm
				-- Gives room for the next level to load as black market
		
		-- -- Jungle 2-4 = 2-1 (Dwelling 1-4 -> Jungle 2-1)
	
		-- changestate_onlevel_fake(2,2,THEME.JUNGLE,2,1,THEME.JUNGLE)
		-- changestate_onlevel_fake(2,3,THEME.JUNGLE,2,2,THEME.JUNGLE)
		-- changestate_onlevel_fake(2,4,THEME.JUNGLE,2,3,THEME.JUNGLE)
		-- -- Jungle 2-5 = 2-4 (Jungle 2-3 -> Jungle 2-4)
		-- changestate_onlevel_fake(2,5,THEME.JUNGLE,2,4,THEME.JUNGLE)

	-- Disable dark levels and vaults "before" you enter the world:
		-- Technically load into a total of 4 hell levels; 5-5 and 5-1..3
		-- on.load 5-5, set state.quest_flags 3 and 2, then warp the player to 5-1
		
		-- Jungle 2-0 = 2-1
		-- Disable Moon challenge.
		changestate_onlevel_fake_applyquestflags(2,1,THEME.JUNGLE, {25}, {})
		-- Ice Caves 3-0 = 3-1
		-- Disable Waddler's
		changestate_onlevel_fake_applyquestflags(3,1,THEME.ICE_CAVES, {10}, {})
		-- Temple 4-0 = 4-1
		-- Disable Star challenge.
		changestate_onlevel_fake_applyquestflags(4,1,THEME.TEMPLE, {26}, {})
		-- Volcana 5-5 = 5-1
		-- Disable Moon challenge and drill
			-- OR: disable drill until you get to level 4, then enable it if you want to use drill level for yama
		changestate_onlevel_fake_applyquestflags(5,1,THEME.VOLCANA, {19, 25}, {})
		
	-- -- Volcana 5-1 -> Volcana 5-2
	-- changestate_onlevel_fake(5,5,THEME.VOLCANA,5,2,THEME.VOLCANA)
	-- -- Volcana 5-2 -> Volcana 5-3
	-- changestate_onlevel_fake(5,6,THEME.VOLCANA,5,3,THEME.VOLCANA)
end

-- Reverse Level Handling
-- For cases where the entrance and exit need to be swapped
-- TODO: See if you can force-swap with `entrance` and `exit` tilecodes placed in door chunks
-- TOTEST: Try it with eggplant world, if that works, apply it to neo-babylon as well
function onlevel_reverse_exits()
	if state.theme == THEME.EGGPLANT_WORLD then
		set_timeout(exit_reverse, 15)
	end
end

function generation_removeborderfloor()
	-- if S2 black market
	-- TODO: Replace with if feeling_check("FLOODED") == true then
	if feeling_check("FLOODED") == true then
		remove_borderfloor()
	end
	-- if Mothership level
	if state.theme == THEME.NEO_BABYLON then
		remove_borderfloor()
	end
end

function onlevel_placement_lockedchest()
	-- Change udjat eye and black market detection to:
	if test_flag(state.quest_flags, 17) == true then -- Udjat eye spawned
		lockedchest_uids = get_entities_by_type(ENT_TYPE.ITEM_LOCKEDCHEST)
		-- udjat_level = (#lockedchest_uids > 0)
		if (
			state.theme == THEME.DWELLING and
			(
				state.level == 2 or
				state.level == 3
				-- or state.level == 4
			-- TODO: Extend availability of udjat chest to level 4.
			) and
			#lockedchest_uids > 0--udjat_level == true
		) then
			random_uid = -1
			random_index = math.random(1, #lockedchest_uids)
			for i, lockedchest_loop_uid in ipairs(lockedchest_uids) do
				if random_index == i then
					random_uid = lockedchest_loop_uid
				else
					kill_entity(lockedchest_loop_uid, 0, 0, 0, 0)
				end
			end
			if random_uid ~= -1 then
				lockedchest_uid = random_uid
				lockedchest_mov = get_entity(lockedchest_uid):as_movable()
				_, chest_y, _ = get_position(lockedchest_uid)
				-- use surface_x to center
				surface_x, surface_y, _ = get_position(lockedchest_mov.standing_on_uid)
				move_entity(lockedchest_uid, surface_x, chest_y, 0, 0)
				
				-- swap cursed pot and chest locations
				cursedpot_uids = get_entities_by_type(ENT_TYPE.ITEM_CURSEDPOT)
				if #cursedpot_uids > 0 then 
					cursedpot_uid = cursedpot_uids[1]
					
					pot_x, pot_y, pot_l = get_position(cursedpot_uid) -- initial pot coordinates
					
					-- use surface_x to center
					move_entity(cursedpot_uid, surface_x, chest_y, 0, 0)
					
					move_entity(lockedchest_uid, pot_x, pot_y, 0, 0) -- move chest to initial pot coordinates
				end
			else
				toast("onlevel_placement_lockedchest(): No Chest. (random_uid could not be set)")
			end
		-- else toast("Couldn't find locked chest.")
		end
	end
end

function onlevel_nocursedpot()
	cursedpot_uids = get_entities_by_type(ENT_TYPE.ITEM_CURSEDPOT)
	if #cursedpot_uids > 0 and options.hd_og_nocursepot == true then
		xmin, ymin, _, _ = get_bounds()
		void_x = xmin - 3.5
		void_y = ymin
		spawn_entity(ENT_TYPE.FLOOR_BORDERTILE, void_x, void_y, LAYER.FRONT, 0, 0)
		for _, cursedpot_uid in ipairs(cursedpot_uids) do
			move_entity(cursedpot_uid, void_x, void_y+1, 0, 0)
		end
	end
end

function onlevel_prizewheel()
	local atms = get_entities_by_type(ENT_TYPE.ITEM_DICE_BET)
	local diceposters = get_entities_by_type(ENT_TYPE.BG_SHOP_DICEPOSTER)
	if #atms > 0 and #diceposters > 0 then
		kill_entity(get_entities_by_type(ENT_TYPE.BG_SHOP_DICEPOSTER)[1])
		for i, atm in ipairs(atms) do
			local atm_mov = get_entity(atms[i]):as_movable()
			local atm_facing = test_flag(atm_mov.flags, 17)
			local atm_x, atm_y, atm_l = get_position(atm_mov.uid)
			local wheel_x_raw = atm_x
			local wheel_y_raw = atm_y+1.5
			
			local facing_dist = 1
			if atm_facing == false then facing_dist = -1 end
			wheel_x_raw = wheel_x_raw + 1 * facing_dist
			
			-- TODO: Replace the function of `wheel_content` to keep track of the location on the board
			-- Rotate DICEPOSTER for new wheel
			local wheel_content = {
									255,	-- present
									14,		-- money
									23,		-- skull
									15,		-- bigmoney
									23,		-- skull
									14,		-- money
									23,		-- skull
									14,		-- money
									23,		-- skull
									}
			for item_ind = 1, 9, 1 do
				local angle = ((360/9)*item_ind-(360/18))
				local item_coord = rotate(wheel_x_raw, wheel_y_raw, wheel_x_raw, wheel_y_raw+1, angle)
				wheel_items[item_ind] = spawn(ENT_TYPE.ITEM_ROCK, item_coord[1], item_coord[2], atm_l, 0, 0)
				local _item = get_entity(wheel_items[item_ind]):as_movable()
				_item.flags = set_flag(_item.flags, 28)
				_item.angle = -angle
				_item.animation_frame = wheel_content[item_ind]
				_item.width = 0.7
				_item.height = 0.7
			end
		end
		local dice = get_entities_by_type(ENT_TYPE.ITEM_DIE)
		for j, die in ipairs(dice) do
			local die_mov = get_entity(dice[j]):as_movable()
			die_mov.flags = clr_flag(die_mov.flags, 18)
			die_mov.flags = clr_flag(die_mov.flags, 7)
			die_mov.flags = set_flag(die_mov.flags, 1)
			local con = get_entity(dice[j]):as_container()
			con.inside = 3
		end
	end
		
	-- LOCATE DICE
	-- local die1 = get_entity(dice[1]):as_movable()
	-- local die2 = get_entity(dice[2]):as_movable()
	-- toast("uid1 = " .. die1.uid .. ", uid2 = " .. die2.uid)

	-- local con1 = get_entity(dice[1]):as_container()
	-- local con2 = get_entity(dice[2]):as_container()
	-- toast("con1 = " .. tostring(con1.inside) .. ", con2 = " .. tostring(con1.inside))
	-- local atm_mov = get_entity(atms[1]):as_movable()
	-- toast("atm uid: " .. atm_mov.uid)
end

function onlevel_idoltrap()
	create_idol()
end

function onlevel_remove_mounts()
	mounts = get_entities_by_type({
		ENT_TYPE.MOUNT_TURKEY
		-- ENT_TYPE.MOUNT_ROCKDOG,
		-- ENT_TYPE.MOUNT_AXOLOTL,
		-- ENT_TYPE.MOUNT_MECH
	})
	-- Avoid removing mounts players are riding or holding
	-- avoid = {}
	-- for i = 1, #players, 1 do
		-- holdingmount = get_entity(players[1].uid):as_movable().holding_uid
		-- mount = get_entity(players[1].uid):topmost()
		-- -- toast(tostring(mount.uid))
		-- if (
			-- mount ~= players[1].uid and
			-- (
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_TURKEY or
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_ROCKDOG or
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_AXOLOTL
			-- )
		-- ) then
			-- table.insert(avoid, mount)
		-- end
		-- if (
			-- holdingmount ~= -1 and
			-- (
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_TURKEY or
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_ROCKDOG or
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_AXOLOTL
			-- )
		-- ) then
			-- table.insert(avoid, holdingmount)
		-- end
	-- end
	if state.theme == THEME.DWELLING and (state.level == 2 or state.level == 3) then
		for t, mount in ipairs(mounts) do
			-- stop_remove = false
			-- for _, avoidmount in ipairs(avoid) do
				-- if mount == avoidmount then stop_remove = true end
			-- end
			mov = get_entity(mount):as_movable()
			if test_flag(mov.flags, 23) == false then --and stop_remove == false then
				move_entity(mount, 0, 0, 0, 0)
			end
		end
	end
end

-- TODO: Outdated. Merge into with Scripted Roomcode Generation
-- function onlevel_decorate_cookfire()
	-- if state.theme == THEME.JUNGLE or state.theme == THEME.TEMPLE then
		-- -- spawn lavapot at campfire
		-- campfires = get_entities_by_type(ENT_TYPE.ITEM_COOKFIRE)
		-- for _, campfire in ipairs(campfires) do
			-- px, py, pl = get_position(campfire)
			-- spawn(ENT_TYPE.ITEM_LAVAPOT, px, py, pl, 0, 0)
		-- end
	-- end
-- end

function onlevel_decorate_trees()
	if state.theme == THEME.JUNGLE or state.theme == THEME.TEMPLE then
		-- add branches to tops of trees, add leaf decorations
		treetops = get_entities_by_type(ENT_TYPE.FLOOR_TREE_TOP)
		for _, treetop in ipairs(treetops) do
			branch_uid_left = decorate_tree(ENT_TYPE.FLOOR_TREE_BRANCH, treetop, -1, 0, 0.1, false)
			branch_uid_right = decorate_tree(ENT_TYPE.FLOOR_TREE_BRANCH, treetop, 1, 0, 0.1, false)
			if feeling_check("RESTLESS") == false then
				decorate_tree(ENT_TYPE.DECORATION_TREE_VINE_TOP, branch_uid_left, 0.03, 0.47, 0.5, false)
				decorate_tree(ENT_TYPE.DECORATION_TREE_VINE_TOP, branch_uid_right, -0.03, 0.47, 0.5, true)
			-- else
				-- TODO: 50% chance of grabbing the FLOOR_TREE_TRUNK below `treetop` and applying a haunted face to it
			end
		end
	end
end

function onlevel_blackmarket_ankh()
	if detect_s2market() == true then
		
		-- find the hedjet
		hedjets = get_entities_by_type(ENT_TYPE.ITEM_PICKUP_HEDJET)
		if #hedjets ~= 0 then
			-- spawn an ankh at the location of the hedjet
			hedjet_uid = hedjets[1]
			hedjet_mov = get_entity(hedjet_uid):as_movable()
			x, y, l = get_position(hedjet_uid)
			ankh_uid = spawn(ENT_TYPE.ITEM_PICKUP_ANKH, x, y, l, 0, 0)
			-- IDEA: Replace Ankh with skeleton key, upon pickup in inventory, give player ankh powerup.
				-- Rename shop string for skeleton key as "Ankh", replace skeleton key with Ankh texture.
			-- TODO: Slightly unrelated, but make a method to remove/replace useless items. Depending on the context, replace it with another item in the pool of even chance.
				-- Skeleton key
				-- Metal Shield
			ankh_mov = get_entity(ankh_uid):as_movable()
			ankh_mov.flags = set_flag(ankh_mov.flags, 23)
			ankh_mov.flags = set_flag(ankh_mov.flags, 20)
			if options.hd_og_ankhprice == true then
				ankh_mov.price = 50000.0
			else
				ankh_mov.price = hedjet_mov.price
			end
			kill_entity(hedjet_uid)
			-- set flag 23 and 20
			-- detach/spawn_entity_over the purchase icons from the headjet, apply them to the ankh
			-- kill hedjet
			-- hedjet x: 37.500 y: 69.890
			-- FX_SALEICON y: 0.790-0.830?
			-- FX_SALEDIALOG_CONTAINER y: 0.46
			spawn_entity_over(ENT_TYPE.FX_SALEICON, ankh_uid, 0, 0)
			spawn_entity_over(ENT_TYPE.FX_SALEDIALOG_CONTAINER, ankh_uid, 0, 0)
		end
	end
end

function onlevel_add_wormtongue()
	-- Worm tongue generation
	-- Placement is currently done with stickytraps placed in the level editor (at least for jungle)
	-- TODO: For all path generation blocks (include side?) (with space of course), add a unique tile to detect inside on.level
	-- On loading the first jungle or ice cave level, find all of the unique entities spawned, select a random one, and spawn the worm tongue.
	-- Then kill all of said unique entities.
	-- ALTERNATIVE: Move into onlevel_generation; find all blocks that have 2 spaces above it free, pick a random one, then spawn the worm tongue.

	if state.theme == THEME.JUNGLE then -- or state.theme == THEME.ICE_CAVES then
		tonguepoints = get_entities_by_type(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH)
		if state.level == 1 then
			random_uid = -1
			random_index = math.random(1, #tonguepoints)
			for i, tonguepoint_uid in ipairs(tonguepoints) do
				if random_index == i then
					random_uid = tonguepoint_uid
					-- spawn worm
					create_wormtongue(get_position(random_uid))
				end
				move_entity(tonguepoint_uid, 0, 0, 0, 0)
			end
			if random_uid == -1 then
				toast("No worm for you. YEOW!! (random_uid could not be set)")
			end
		else
			for _, tonguepoint_uid in ipairs(tonguepoints) do move_entity(tonguepoint_uid, 0, 0, 0, 0) end
		end
	end
	set_timeout(function()
		tonguepoints = get_entities_by_type(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH)
		for _, tonguepoint_uid in ipairs(tonguepoints) do kill_entity(tonguepoint_uid, 0, 0, 0, 0) end
	end, 5)
end

function onlevel_acidbubbles()
	if state.theme == THEME.EGGPLANT_WORLD then
		set_interval(bubbles, 35) -- 15)
	end
end

function onlevel_crysknife()
	if state.theme == THEME.EGGPLANT_WORLD then
		x = 17
		y = 109
		if (math.random() >= 0.5) then
			x = x - 10
		end
		-- TODO: OVERHAUL.
			-- IDEAS:
				-- Replace with actual crysknife and upgrade player damage.
					-- put crysknife animations in the empty space in items.png (animation_frame = 120 - 126 for crysknife) and then animating it behind the player
					-- Can't make player whip invisible, apparently, so that might be hard to do.
				-- Use powerpack
					-- It's the spiritual successor to the crysknife, so its a fitting replacement
					-- I'm planning to make bacterium use FLOOR_THORN_VINE for damage, but now I can even make them break with the powerpack if I also use bush blocks
					-- In my experience in HD, a good way of dispatching bacterium was with bombs, but it was hard to time correctly. So the powerpack would make bombs even more effective
		spawn(ENT_TYPE.ITEM_POWERPACK, x, y, LAYER.FRONT, 0, 0)--ENT_TYPE.ITEM_EXCALIBUR, x, y, LAYER.FRONT, 0, 0)
	end
end

function onlevel_hide_yama()
	if state.theme == THEME.EGGPLANT_WORLD then
		-- TODO: Relocate MONS_YAMA to a better place. Can't move him to back layer, it triggers the slow music :(
		kill_entity(get_entities_by_type(ENT_TYPE.BG_YAMA_BODY)[1])
		for i, yama_floor in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_YAMA_PLATFORM)) do
			kill_entity(yama_floor)
		end
		local yama = get_entity(get_entities_by_type(ENT_TYPE.MONS_YAMA)[1]):as_movable()
		yama.flags = set_flag(yama.flags, 1)
		yama.flags = set_flag(yama.flags, 6)
		yama.flags = set_flag(yama.flags, 28)
		
		-- modified replace() method
		-- affected = get_entities_by_type(ENT_TYPE.MONS_JUMPDOG)
		 -- for i,ent in ipairs(affected) do

		  -- e = get_entity(ent):as_movable()
		  -- floor_uid = e.standing_on_uid
		  -- s = spawn_entity_over(ENT_TYPE.ITEM_EGGSAC, floor_uid, 0, 1)
		  -- se = get_entity(s):as_movable()

		  -- kill_entity(ent)
		 -- end 
	end
end

function onlevel_add_botd()
	-- TODO: Once COG generation is done, change to THEME.CITY_OF_GOLD and figure out coordinates to move it to
	if state.theme == THEME.OLMEC then
		if not options.hd_test_give_botd then
			bookofdead_pickup_id = spawn(ENT_TYPE.ITEM_PICKUP_TABLETOFDESTINY, 6, 99.05, LAYER.FRONT, 0, 0)
			book_ = get_entity(bookofdead_pickup_id):as_movable()
			book_.animation_frame = 205
		end
	end
end

function onlevel_boss_init()
	if state.theme == THEME.OLMEC then
		BOSS_STATE = BOSS_SEQUENCE.CUTSCENE
		cutscene_move_olmec_pre()
		cutscene_move_cavemen()
		create_endingdoor(41, 99, LAYER.FRONT)
		create_entrance_hell()
	end
	-- Olmec/Yama Win
	exit_winstate()
end

function cutscene_move_olmec_pre()
	olmecs = get_entities_by_type(ENT_TYPE.ACTIVEFLOOR_OLMEC)
	if #olmecs > 0 then
		OLMEC_ID = olmecs[1]
		move_entity(OLMEC_ID, 24.500, 100.500, 0, 0)
	end
end

function cutscene_move_olmec_post()
	move_entity(OLMEC_ID, 22.500, 99.500, 0, 0)--24.500, 100.500, 0, 0)
end

function cutscene_move_cavemen()
	-- TODO: Once custom hawkman AI is done:
	-- create a hawkman and disable his ai
	-- set_timeout() to reenable his ai and set his stuntimer.
	-- **does set_timeout() work during cutscenes?
		-- if not, use set_global_timeout
			-- set_timeout() accounts for pausing the game while set_global_timeout() does not
	-- **consider problems for skipping the cutscene
	cavemen = get_entities_by_type(ENT_TYPE.MONS_CAVEMAN)
	for i, caveman in ipairs(cavemen) do
		move_entity(caveman, 17.500+i, 99.05, 0, 0)
	end
end

-- function onlevel_replace_powderkegs()
	-- if state.theme == THEME.VOLCANA then
		-- TODO: Maybe, in order to save memory, merge this with onlevel_generation
		-- -- replace powderkegs with pushblocks, move_entity(powderkeg, 0, 0, 0, 0)
	-- end
-- end

-- function onlevel_generation_pushblocks()
	-- if state.theme == THEME.OLMEC then
		-- TODO: Pushblock generation. Have a random small chance to replace all FLOORSTYLED_STONE/FLOOR_GENERIC blocks with a ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK.
		-- Exceptions include not having a FLOORSTYLED_STONE/FLOOR_GENERIC block under it and being at the y coordinate of 98.
		-- get_entities_by_type({ENT_TYPE.FLOOR_GENERIC, ENT_TYPE.FLOORSTYLED_STONE})
		-- Probably best to pick a number between 5 and 20, and then choose that amount of random blocks out of the array.
		-- The problem is, there's going to be a lot of visible broken terrain as a result.
	-- end
-- end

function onlevel_detection_feeling()
	if state.theme == THEME.DWELLING then
		encounter = math.random(1,2)
		if encounter == 1 then
			feeling_set_once("SPIDERLAIR", {state.level})
			-- TODO: pots will not spawn on this level.
			-- Spiders, spinner spiders, and webs appear much more frequently.
			-- Spawn web nests (probably RED_LANTERN, remove  and reskin it)
			-- Move pots into the void
		elseif encounter == 2 then
			feeling_set_once("SNAKEPIT", {state.level})
		end
	end
	if state.theme == THEME.JUNGLE then
		if feeling_check("HAUNTEDCASTLE") == false then
			if detect_s2market() == true then
				encounter = 1
				if ( -- if tikivillage has already been assigned, roll for flooded. Otherwise roll both
					global_feelings["TIKIVILLAGE"].load ~= nil
				) then
					encounter = 2
				else
					encounter = math.random(1,2)
				end
				if encounter == 1 then
					feeling_set_once("TIKIVILLAGE", {state.level})
				elseif encounter == 2 then
					feeling_set_once("FLOODED", {state.level})
				end
			else
				feeling_set_once("TIKIVILLAGE", {state.level})
			end
			
			
			if feeling_check("TIKIVILLAGE") == false then
				feeling_set_once("RESTLESS", {state.level})
			end
		end
		-- TODO: Set BLACKMARKET_ENTRANCE and BLACKMARKET here
	end
	if state.theme == THEME.ICE_CAVES then
		
		-- TODO(?): Really weird and possibly unintentional exception:
			-- The Moai is found on either level 3-2 or 3-3, unless the player went to The Worm and The Mothership, in that case The Moai will appear in 3-4 (after The Mothership).
		if state.level == 2 then
			feeling_set_once("MOAI", {2, 3})
		end
		
		if state.level == 4 then
			if global_feelings["MOTHERSHIPENTRANCE"].load == nil then
				feeling_set_once("MOTHERSHIPENTRANCE", {state.level})
			else
				global_feelings["MOTHERSHIPENTRANCE"].load = nil
				feeling_set_once("YETIKINGDOM", {state.level})
			end
			-- This level feeling only, and always, occurs on level 3-4.
				-- The entrance to Mothership sends you to 3-3 with THEME.NEO_BABYLON.
				-- When you exit, you will return to the beginning of 3-4 and be forced to do the level again before entering the Temple.
				-- Only available once in a run
		end
		
		encounter = math.random(1,2)
		
		if encounter == 1 and
		(
			feeling_check("MOAI") == false and
			state.level ~= 4
		) then
			feeling_set_once("YETIKINGDOM", {1,2,3})
		elseif encounter == 2 then
			feeling_set_once("UFO", {state.level})
		end
	end
	if state.theme == THEME.TEMPLE then
		feeling_set_once("SACRIFICIALPIT", {1,2,3})
	end
	-- -- HELL
	-- if state.theme == THEME.VOLCANA and state.level == 1 then
		-- feeling_set("HELL", {state.level})
	-- end
	
	-- GAME ENDUCED RESTLESS
	-- TODO: Find a way to just remove and replace everything given this occurance
	if (
		state.theme == THEME.JUNGLE or
		state.theme == THEME.VOLCANA or
		state.theme == THEME.TEMPLE or
		state.theme == THEME.TIDEPOOL
	) then
		tombstones = get_entities_by_type(ENT_TYPE.DECORATION_TOMB)
		if #tombstones > 0 then
			feeling_set("RESTLESS", {state.level})
		end
	end
end

function onlevel_setfeelingmessage()
	-- theme message priorities are here (ie; rushingwater over restless)
	-- NOTES:
		-- Black Market, COG and Beehive are currently handled by the game
	
	loadchecks = TableCopy(global_feelings)
	
	n = #loadchecks
	for feelingname, loadcheck in pairs(loadchecks) do
		if (
			-- detect_feeling_themes(feelingname) == false or
			-- (
				-- detect_feeling_themes(feelingname) == true and
				-- (
					-- (loadcheck.load == nil or loadcheck.message == nil) or
					-- (feeling_check(feelingname))
				-- )
			-- )
			feeling_check(feelingname) == false
		) then loadchecks[feelingname] = nil end
	end
	loadchecks = CompactList(loadchecks, n)
	
	MESSAGE_FEELING = nil
	for feelingname, feeling in pairs(loadchecks) do
		-- Message Overrides may happen here:
		-- For example:
			-- if feelingname == "FLOODED" and feeling_check("RESTLESS") == true then break end
		MESSAGE_FEELING = feeling.message
	end
end

function onlevel_toastfeeling()
	if (
		MESSAGE_FEELING ~= nil and
		options.hd_z_toastfeeling == true
	) then
		toast(MESSAGE_FEELING)
	end
end


function oncamp_movetunnelman()
	marlas = get_entities_by_type(ENT_TYPE.MONS_MARLA_TUNNEL)
	for _, marla_uid in ipairs(marlas) do
		move_entity(marla_uid, 0, 0, 0, 0)
	end
	marla_uid = spawn_entity(ENT_TYPE.MONS_MARLA_TUNNEL, 15, 86, LAYER.FRONT, 0, 0)
	marla = get_entity(marla_uid)
	marla.flags = clr_flag(marla.flags, 17)
end

function oncamp_shortcuts()

	--loop once for door materials,
	--once done, concatonate LOGIC_DOOR and ITEM_CONSTRUCTION_SIGN lists, make sure construction signs are last.
	--loop to move logic_door and construction signs. If it's a logic_door, move its accessories as well.
	--shortcut doors (if construction sign,  here too): LOGIC_DOOR, FLOOR_DOOR_STARTING_EXIT, BG_DOOR(when moving this, +0.31 to y) ENT_TYPE.ITEM_CONSTRUCTION_SIGN, 
	--3: x=21.000,	y=90.000
	--2: 			y-3=(87.000)
	--1: 			y-6=(84.000)
	--shortcut signs: ENT_TYPE.ITEM_SHORTCUT_SIGN
	--(+2.0 to x)
	
	-- shortcut_signframes = {}
	shortcut_flagstocheck = {4, 7, 10}
	shortcut_worlds = {2, 3, 4}
	shortcut_levels = {PREFIRSTLEVEL_NUM, PREFIRSTLEVEL_NUM, PREFIRSTLEVEL_NUM}
	shortcut_themes = {THEME.JUNGLE, THEME.ICE_CAVES, THEME.TEMPLE}
	-- TODO: Once we are able to change which texture an entity is pulling from, assign bg textures here:
	-- shortcut_doortextures = {569, 409, 343}--{569, 343, 409}
	
	
	-- Placement of first shortcut door in HD: 16.0
	new_x = 19.0 -- adjusted for S2 camera
	for i, flagtocheck in ipairs(shortcut_flagstocheck) do
		-- door_or_constructionsign
		if savegame.shortcuts >= flagtocheck then
			spawn_door(new_x, 86, LAYER.FRONT, shortcut_worlds[i], shortcut_levels[i], shortcut_themes[i])
			-- spawn_entity(ENT_TYPE.FLOOR_DOOR_STARTING_EXIT, new_x, 86, 0, 0)
			door_bg = spawn_entity(ENT_TYPE.BG_DOOR, new_x, 86.31, LAYER.FRONT, 0, 0)
			-- get_entity(door_bg).texture = shortcut_doortextures[i]
			sign = spawn_entity(ENT_TYPE.ITEM_SHORTCUT_SIGN, new_x+1, 86, LAYER.FRONT, 0, 0)
			-- get_entity(sign).animation_frame = shortcut_signframes[i]
		else
			spawn_entity(ENT_TYPE.ITEM_CONSTRUCTION_SIGN, new_x, 86, LAYER.FRONT, 0, 0)
		end
		-- Space between shortcut doors in HD: 4.0
		new_x = new_x + 3 -- adjusted for S2 camera
	end	
end

function onframe_prizewheel()
	-- Prize Wheel
	-- Purchase Detection/Handling
	-- TODO: OVERHAUL. Keep the dice poster and rotating that. Use a rock for the needle and use in place of animation_frame = 193
	if #wheel_items > 0 then
	local atm = get_entities_by_type(ENT_TYPE.ITEM_DICE_BET)[1]
	local atm_mov = get_entity(atm):as_movable()
	local atm_facing = test_flag(atm_mov.flags, 17)
	local atm_prompt = test_flag(atm_mov.flags, 20)
	local atm_x, atm_y, atm_l = get_position(atm_mov.uid)
	local wheel_x_raw = atm_x
	local wheel_y_raw = atm_y+1.5
	local facing_dist = 1
	if atm_facing == false then facing_dist = -1 end
	wheel_x_raw = wheel_x_raw + 1 * facing_dist

	if atm_prompt == false then
		if WHEEL_SPINNING == false then
			WHEEL_SPINNING = true
			wheel_tick = 0
		end

		if wheel_tick < WHEEL_SPINTIME then
			for i, item in ipairs(wheel_items) do
				local item_x, item_y, item_l = get_position(wheel_items[i])
				local item_e = get_entity(wheel_items[i]):as_movable()
				wheel_speed = 50 * 1.3^(-0.025*wheel_tick)
				local item_coord = rotate(wheel_x_raw, wheel_y_raw, item_x, item_y, wheel_speed)
				move_entity(wheel_items[i], item_coord[1], item_coord[2], 0, 0)
				item_e.angle = -1 * wheel_speed
			end
			wheel_tick = wheel_tick + 1
			else
				atm_mov.flags = set_flag(atm_mov.flags, 20)
				wheel_tick = WHEEL_SPINTIME
				WHEEL_SPINNING = false
			end
		end
		-- TODO: Prize background: animation_frame = 59->deactivate, 60->activate
		-- TODO: Laser Floor: animation_frame = 51->deactivate, 54->activate
	end
end

function onframe_idoltrap()
	-- Idol trap activation
	if IDOLTRAP_TRIGGER == false and IDOL_UID ~= nil and idol_disturbance() then
		IDOLTRAP_TRIGGER = true
		if feeling_check("RESTLESS") == true then
			create_ghost()
		elseif state.theme == THEME.DWELLING and IDOL_X ~= nil and IDOL_Y ~= nil then
			spawn(ENT_TYPE.LOGICAL_BOULDERSPAWNER, IDOL_X, IDOL_Y, idol_l, 0, 0)
		elseif state.theme == THEME.JUNGLE then
			-- break the 6 blocks under it in a row, starting with the outside 2 going in
			if #idoltrap_blocks > 0 then
				kill_entity(idoltrap_blocks[1])
				kill_entity(idoltrap_blocks[6])
				set_timeout(function()
					kill_entity(idoltrap_blocks[2])
					kill_entity(idoltrap_blocks[5])
				end, idoltrap_timeout)
				set_timeout(function()
					kill_entity(idoltrap_blocks[3])
					kill_entity(idoltrap_blocks[4])
				end, idoltrap_timeout*2)
			end
		elseif state.theme == THEME.ICE_CAVES then
			set_timeout(function()
				boulder_spawners = get_entities_by_type(ENT_TYPE.LOGICAL_BOULDERSPAWNER)
				if #boulder_spawners > 0 then
					kill_entity(boulder_spawners[1])
				end
			end, 3)
		end
	elseif IDOLTRAP_TRIGGER == true and IDOL_UID ~= nil and state.theme == THEME.DWELLING then
		if BOULDER_UID == nil then
			boulders = get_entities_by_type(ENT_TYPE.ACTIVEFLOOR_BOULDER)
			if #boulders > 0 then
				BOULDER_UID = boulders[1]
				-- TODO: Obtain the last owner of the idol upon disturbing it. If no owner caused it, THEN select the first player alive.
				if options.hd_og_boulder_agro == true then
					boulder = get_entity(BOULDER_UID):as_movable()
					for i, player in ipairs(players) do
						boulder.last_owner_uid = player.uid
					end
				end
			end
		else
			boulder = get_entity(BOULDER_UID)
			if boulder ~= nil then
				boulder = get_entity(BOULDER_UID):as_movable()
				x, y, l = get_position(BOULDER_UID)
				BOULDER_CRUSHPREVENTION_EDGE_CUR = BOULDER_CRUSHPREVENTION_EDGE
				BOULDER_CRUSHPREVENTION_HEIGHT_CUR = BOULDER_CRUSHPREVENTION_HEIGHT
				if boulder.velocityx >= BOULDER_CRUSHPREVENTION_VELOCITY or boulder.velocityx <= -BOULDER_CRUSHPREVENTION_VELOCITY then
					BOULDER_CRUSHPREVENTION_EDGE_CUR = BOULDER_CRUSHPREVENTION_EDGE*BOULDER_CRUSHPREVENTION_MULTIPLIER
					BOULDER_CRUSHPREVENTION_HEIGHT_CUR = BOULDER_CRUSHPREVENTION_HEIGHT*BOULDER_CRUSHPREVENTION_MULTIPLIER
				else 
					BOULDER_CRUSHPREVENTION_EDGE_CUR = BOULDER_CRUSHPREVENTION_EDGE
					BOULDER_CRUSHPREVENTION_HEIGHT_CUR = BOULDER_CRUSHPREVENTION_HEIGHT
				end
				BOULDER_SX = ((x - boulder.hitboxx)-BOULDER_CRUSHPREVENTION_EDGE_CUR)
				BOULDER_SY = ((y + boulder.hitboxy)-BOULDER_CRUSHPREVENTION_EDGE_CUR)
				BOULDER_SX2 = ((x + boulder.hitboxx)+BOULDER_CRUSHPREVENTION_EDGE_CUR)
				BOULDER_SY2 = ((y + boulder.hitboxy)+BOULDER_CRUSHPREVENTION_HEIGHT_CUR)
				local blocks = get_entities_overlapping(
					ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK,
					0,
					BOULDER_SX,
					BOULDER_SY,
					BOULDER_SX2,
					BOULDER_SY2,
					LAYER.FRONT
				)
				blocks = TableConcat(
					blocks, get_entities_overlapping(
						ENT_TYPE.ACTIVEFLOOR_POWDERKEG,
						0,
						BOULDER_SX,
						BOULDER_SY,
						BOULDER_SX2,
						BOULDER_SY2,
						LAYER.FRONT
					)
				)
				for _, block in ipairs(blocks) do
					kill_entity(block)
				end
				if options.hd_debug_info_boulder == true then
					touching = get_entities_overlapping(
						0,
						0x1,
						BOULDER_SX,
						BOULDER_SY,
						BOULDER_SX2,
						BOULDER_SY2,
						LAYER.FRONT
					)
					if #touching > 0 then BOULDER_DEBUG_PLAYERTOUCH = true else BOULDER_DEBUG_PLAYERTOUCH = false end
				end
			else toast("Boulder crushed :(") end
		end
	end
end

function onframe_acidpoison()
	-- Worm LEVEL
	if state.theme == THEME.EGGPLANT_WORLD then
		-- Acid damage
		for i, player in ipairs(players) do
			-- local spelunker_mov = get_entity(player):as_movable()
			local spelunker_swimming = test_flag(player.more_flags, 11)
			local poisoned = player:is_poisoned()
			x, y, l = get_position(player.uid)
			if spelunker_swimming and player.health ~= 0 and not poisoned then
				if acid_tick <= 0 then
					spawn(ENT_TYPE.ITEM_ACIDSPIT, x, y, l, 0, 0)
					acid_tick = ACID_POISONTIME
				else
					acid_tick = acid_tick - 1
				end
			else
				acid_tick = ACID_POISONTIME
			end
		end
	end
end

function tongue_animate()
	if (
		state.theme == THEME.JUNGLE and -- or state.theme == THEME.ICE_CAVES) and
		TONGUE_UID ~= nil and
		(
			TONGUE_STATE == TONGUE_SEQUENCE.READY or
			TONGUE_STATE == TONGUE_SEQUENCE.RUMBLE
		)
	) then
		x, y, l = get_position(TONGUE_UID)
		for _ = 1, 3, 1 do
			if math.random() >= 0.5 then spawn_entity(ENT_TYPE.FX_WATER_DROP, x+((math.random()*1.5)-1), y+((math.random()*1.5)-1), l, 0, 0) end
		end
	end
end

function onframe_tonguetimeout()
	if state.theme == THEME.JUNGLE and TONGUE_UID ~= nil and TONGUE_STATE ~= TONGUE_SEQUENCE.GONE then --or state.theme == THEME.ICE_CAVES
		local tongue = get_entity(TONGUE_UID):as_movable()
		x, y, l = get_position(TONGUE_UID)
		checkradius = 1.5
		
		if tongue ~= nil and TONGUE_STATECOMPLETE == false then
			-- TONGUE_SEQUENCE = { ["READY"] = 1, ["RUMBLE"] = 2, ["EMERGE"] = 3, ["SWALLOW"] = 4 , ["GONE"] = 5 }
			if TONGUE_STATE == TONGUE_SEQUENCE.READY then
				damsels = get_entities_at(ENT_TYPE.MONS_PET_DOG, 0, x, y, l, checkradius)
				damsels = TableConcat(damsels, get_entities_at(ENT_TYPE.MONS_PET_CAT, 0, x, y, l, checkradius))
				damsels = TableConcat(damsels, get_entities_at(ENT_TYPE.MONS_PET_HAMSTER, 0, x, y, l, checkradius))
				if #damsels > 0 then
					damsel = get_entity(damsels[1]):as_movable()
					-- when alive damsel move_state == 9 for 4 seconds?
					-- toast("damsel.move_state: " .. tostring(damsel.state))
					stuck_in_web = test_flag(damsel.more_flags, 8)--9)
					-- local falling = (damsel.state == 9)
					dead = test_flag(damsel.flags, 29)
					if (
						(stuck_in_web == true)
						-- (dead == false and falling == true)
					) then
						if tongue_tick <= 0 then
							spawn_entity(ENT_TYPE.LOGICAL_BOULDERSPAWNER, x, y, l, 0, 0)
							TONGUE_STATE = TONGUE_SEQUENCE.RUMBLE
						else
							tongue_tick = tongue_tick - 1
						end
					else
						tongue_tick = TONGUE_ACCEPTTIME
					end
				end
			elseif TONGUE_STATE == TONGUE_SEQUENCE.RUMBLE then
				-- kill the boulder once you find one (or kill LOGICAL_BOULDERSPAWNER before it spawns one)
				set_timeout(function()
				
					if TONGUE_BG_UID ~= nil then
						worm_background = get_entity(TONGUE_BG_UID)
						worm_background.animation_frame = 4 -- 4 is the hole frame for Jungle, ice caves: probably 8
					else toast("TONGUE_BG_UID is nil :(") end
					
					-- TODO: Method to animate rubble better.
					for _ = 1, 3, 1 do
						spawn_entity(ENT_TYPE.ITEM_RUBBLE, x, y, l, ((math.random()*1.5)-1), ((math.random()*1.5)-1))
						spawn_entity(ENT_TYPE.ITEM_RUBBLE, x, y, l, ((math.random()*1.5)-1), ((math.random()*1.5)-1))
						spawn_entity(ENT_TYPE.ITEM_RUBBLE, x, y, l, ((math.random()*1.5)-1), ((math.random()*1.5)-1))
					end
					
					TONGUE_STATE = TONGUE_SEQUENCE.EMERGE
					TONGUE_STATECOMPLETE = false
				end, 65)
				TONGUE_STATECOMPLETE = true
			elseif TONGUE_STATE == TONGUE_SEQUENCE.EMERGE then
				set_timeout(function()
					-- level exit should activate here
					tongue_exit()
					TONGUE_STATE = TONGUE_SEQUENCE.SWALLOW
					TONGUE_STATECOMPLETE = false
				end, 40)
				TONGUE_STATECOMPLETE = true
			elseif TONGUE_STATE == TONGUE_SEQUENCE.SWALLOW then
				set_timeout(function()
					-- toast("boulder deletion at state.time_level: " .. tostring(state.time_level))
					boulder_spawners = get_entities_by_type(ENT_TYPE.LOGICAL_BOULDERSPAWNER)
					kill_entity(boulder_spawners[1])
					
					kill_entity(TONGUE_UID)
					TONGUE_UID = nil
					
					TONGUE_STATE = TONGUE_SEQUENCE.GONE
				end, 40)
				TONGUE_STATECOMPLETE = true
			end -- never reaches "TONGUE_SEQUENCE.GONE"
		end
	end
end

function tongue_exit()
	x, y, l = get_position(TONGUE_UID)
	checkradius = 1.5
	local damsels = get_entities_at(ENT_TYPE.MONS_PET_DOG, 0, x, y, l, checkradius)
	damsels = TableConcat(damsels, get_entities_at(ENT_TYPE.MONS_PET_CAT, 0, x, y, l, checkradius))
	damsels = TableConcat(damsels, get_entities_at(ENT_TYPE.MONS_PET_HAMSTER, 0, x, y, l, checkradius))
	local ensnaredplayers = get_entities_at(0, 0x1, x, y, l, checkradius)
	
	-- TESTING OVERRIDE
	-- if #ensnaredplayers > 0 then
		-- set_timeout(function()
			-- warp(state.world, state.level+1, THEME.EGGPLANT_WORLD)
		-- end, 20)
	-- end
	
	exits_doors = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)
	exits_worm = get_entities_at(ENT_TYPE.FLOOR_DOOR_EXIT, 0, x, y, l, 1)
	worm_exit_uid = exits_worm[1]
	exitdoor = nil
	for _, exits_door in ipairs(exits_doors) do
		if exits_door ~= worm_exit_uid then exitdoor = exits_door end
	end
	if exitdoor ~= nil then
		exit_x, exit_y, _ = get_position(exitdoor)
		for _, damsel_uid in ipairs(damsels) do
			damsel = get_entity(damsel_uid):as_movable()
			stuck_in_web = test_flag(damsel.more_flags, 9)
			-- local dead = test_flag(damsel.flags, 29)
			if (
				(stuck_in_web == true)
				-- TODO: Don't swallow damsel if dead(? did this happen if the damsel was dead in HD? Investigate.)
				-- (dead == false)
			) then
				damsel.stun_timer = 0
				if options.hd_debug_invis == false then
					damsel.flags = set_flag(damsel.flags, 1)
				end
				damsel.flags = clr_flag(damsel.flags, 21)-- disable interaction with webs
				-- damsel.flags = clr_flag(damsel.flags, 12)-- disable stunable
				damsel.flags = set_flag(damsel.flags, 4)--6)-- enable take no damage
				move_entity(damsel_uid, exit_x, exit_y+0.1, 0, 0)
			end
		end
	else
		toast("No Level Exitdoor found, can't force-rescue damsels.")
	end
	if worm_exit_uid ~= nil then
		worm_exit = get_entity(worm_exit_uid)
		worm_exit.flags = clr_flag(worm_exit.flags, 28) -- resume ai to magnetize damsels
		if #ensnaredplayers > 0 then
			-- unlock worm door, let players in
			unlock_door_at(x, y)
			local door_platforms = get_entities_at(ENT_TYPE.FLOOR_DOOR_PLATFORM, 0, x, y, l, 1.5)
			if #door_platforms > 0 then
				door_platform = get_entity(door_platforms[1])
				if options.hd_debug_invis == true then
					door_platform.flags = clr_flag(door_platform.flags, 1)
				end
				door_platform.flags = set_flag(door_platform.flags, 3)
				door_platform.flags = set_flag(door_platform.flags, 8)
			end
			
			for _, ensnaredplayer_uid in ipairs(ensnaredplayers) do
				ensnaredplayer = get_entity(ensnaredplayer_uid):as_movable()
				ensnaredplayer.stun_timer = 0
				-- ensnaredplayer.more_flags = set_flag(ensnaredplayer.more_flags, 16)-- disable input
				
				if options.hd_debug_invis == false then
					ensnaredplayer.flags = set_flag(ensnaredplayer.flags, 1)-- make each player invisible
				end
					-- disable interactions with anything else that may interfere with entering the door
				ensnaredplayer.flags = clr_flag(ensnaredplayer.flags, 21)-- disable interaction with webs
				ensnaredplayer.flags = set_flag(ensnaredplayer.flags, 4)-- disable interaction with objects
				
				-- teleport player to the newly created invisible door (platform is at y+0.05)
				move_entity(ensnaredplayer_uid, x, y+0.15, 0, 0)
			end
			
			
			-- after enough time passed to let the player touch the platform, force door enter button
			set_timeout(function()
				x, y, l = get_position(TONGUE_UID)
				checkradius = 1.5
				local ensnaredplayers = get_entities_at(0, 0x1, x, y, l, checkradius)
				for _, ensnaredplayer_uid in ipairs(ensnaredplayers) do
					steal_input(ensnaredplayer_uid)
					send_input(ensnaredplayer_uid, BUTTON.DOOR)
				end
			end, 15)
			
			-- lock worm door
			set_timeout(function()
				x, y, l = get_position(TONGUE_UID)
				local exits = get_entities_at(ENT_TYPE.FLOOR_DOOR_EXIT, 0, x, y, l, 1)
				local door_platforms = get_entities_at(ENT_TYPE.FLOOR_DOOR_PLATFORM, 0, x, y, l, 1.5)
				if #exits > 0 then
					if #door_platforms > 0 then
						door_platform = get_entity(door_platforms[1])
						if options.hd_debug_invis == true then
							door_platform.flags = set_flag(door_platform.flags, 1)
						end
						door_platform.flags = clr_flag(door_platform.flags, 3)
						door_platform.flags = clr_flag(door_platform.flags, 8)
					end
					worm_exit = get_entity(exits[1])
					worm_exit.flags = set_flag(worm_exit.flags, 28) -- pause ai to prevent magnetizing damsels
					lock_door_at(x, y)
				end
			end, 55)
		end
		
		-- hide worm tongue
		tongue = get_entity(TONGUE_UID)
		if options.hd_debug_invis == false then
			tongue.flags = set_flag(tongue.flags, 1)
		end
		tongue.flags = set_flag(tongue.flags, 4)-- disable interaction with objects
	else
		toast("No Worm Exitdoor found, can't force-exit players.")
	end
end

-- Specific to jungle; replace any jungle danger currently submerged in water with a tadpole.
-- Used to be part of onlevel_dangers_replace().
function enttype_replace_danger(enttypes, hd_type, check_submerged, _vx, _vy)
	check_submerged = check_submerged or false
	
	dangers_uids = get_entities_by_type(enttypes)
	for _, danger_uid in ipairs(dangers_uids) do
		
		d_mov = get_entity(danger_uid):as_movable()
		d_submerged = test_flag(d_mov.more_flags, 11)
		if (
			check_submerged == false or
			(check_submerged == true and d_submerged == true)
		) then
		
			
			-- d_mov = get_entity(danger_uid):as_movable()
			-- d_type = get_entity(uid):as_container().type.id
			-- uid_to_track = danger_uid
			
			-- if d_type ~= hd_type.toreplace
				-- x, y, l = get_position(danger_uid)
				-- vx = _vx or d_mov.velocityx
				-- vy = _vy or d_mov.velocityy
				-- uid_to_track = spawn(hd_type.tospawn, x, y, l, vx, vy)
				-- move_entity(danger_uid, 0, 0, 0, 0)
			-- end
			
			danger_replace(danger_uid, hd_type, false, _vx, _vy)
		end
	end
end

function onframe_manage_inventory()
	inventory_checkpickup_botd()
end

-- DANGER MODIFICATIONS - ON.FRAME
-- Massive enemy behavior handling method
function onframe_manage_dangers()
	n = #danger_tracker
	for i, danger in ipairs(danger_tracker) do
		danger_mov = get_entity(danger.uid)
		killbool = false
		if danger_mov == nil then
			killbool = true
		elseif danger_mov ~= nil then
			
			-- TODO: Move into HD_BEHAVIOR, use frog instead of octopi (Careful to avoid modifying enemydb properties)
			if danger_mov.move_state == 6 then
				-- On move_state jump, run a random chance to spit out a frog instead. velocityx = 0 and velocityy = 0.
				-- When it's within agro distance (find this value by drawing the recorded distance between you and the frog) and when d_mov.standing_on_uid ~= -1 and when not facing the player, flip_entity()
				if danger.hd_type == HD_ENT.GIANTFROG then
					behavior_giantfrog(danger.uid)
				end
			end
		
		
			danger_mov = get_entity(danger.uid):as_movable()
			danger.x, danger.y, danger.l = get_position(danger.uid)
			if danger.behavior ~= nil then
				-- TODO: Enemy Behavior Ideas
				-- for i, enemy in ipairs(get_entities_by_type({ENT_TYPE.MONS_TADPOLE})) do
				-- If enemy is tadpole
					-- if haunted level then
						-- - for each check what animation frame it's on and replace following frames:
						-- - 209-213 -> 227-231
						-- - 214 -> 215
						-- - 106-111 -> 91-96
						-- - 112 -> 127
					-- end
				-- elseif enemy is cloned_shopkeeper and theme == jungle (and haunted?) then
					-- change frames to black knight
					-- if weapon in inventory is shotgun(may use a set_timeout to let it spawn first)
						-- kill shotgun
						-- spawn shield
						-- give shield
					-- end
				-- elseif enemy is caveman and theme == jungle (and haunted?) then
					-- change frames to green_knight
					-- if dead and uid is still on a global array (TODO)
						-- spawn green gib effect
						-- remove uid from global array
					-- end
				-- end
				-- if danger.hd_type == HD_ENT.SCORPIONFLY then
					-- if danger.behavior.abilities ~= nil then
					
						-- "ability_uid" is an entity that's "duct-taped" to the main entity to allow it to adopt it's abilities.
						-- for _, ability_uid in ipairs(danger.behavior.abilities) do
							-- toast("#danger.behavior.abilities: " .. tostring(#danger.behavior.abilities))
							-- if danger.behavior.abilities.agro ~= nil then
								if danger.behavior.bat_uid ~= nil then--behavior.abilities.bat_uid ~= nil then
									if danger_mov.health == 1 then
										-- TODO: If SCORPIONFLY is killed, kill all abilities
										-- TODO: Move this into its own method
										-- kill all abilities
										-- for _, behavior_tokill in ipairs(danger.behavior.abilities) do
											-- if #behavior_tokill > 0 and behavior_tokill[1] ~= nil then
												move_entity(danger.behavior.bat_uid, 0, 0, 0, 0)--move_entity(behavior_tokill[1], 0, 0, 0, 0)
												danger.behavior.bat_uid = nil--behavior_tokill[1] = nil
											-- end
										-- end
									else
										-- permanent agro
										-- TODO: SCORPIONFLY -> Adopt S2's Monkey agro distance.
											-- change the if statement below so it's detecting if the BAT is agro'd, not the scorpion.
										-- TODO: Use chased_target instead.
											-- get_entity():as_chasingmonster chased_target_uid
										if danger_mov.move_state == 5 and danger.behavior.agro == false then danger.behavior.agro = true end
										-- if no idle ability, toggle between agro and default
										-- if danger.behavior.abilities.idle == nil then
											behavior_toggle(
												danger.behavior.bat_uid,--behavior.abilities.agro[1],
												danger.uid,
												TableConcat({danger.uid}, {danger.behavior.bat_uid}),--map(danger.behavior.abilities, function(ability) return ability[1] end)),--{ danger.behavior.abilities.agro[1], danger.behavior.abilities.idle[1], danger.uid },
												danger.behavior.agro
											)
										-- end
									end
								end
							-- end
							-- if it has an idle behavior and agro == false then set it as agro
							-- if danger.behavior.abilities.idle ~= nil then
								-- -- WARNING: Not taking into account if abilities.agro.bat_uid is nil.
								-- -- However, this shouldn't be an issue, as neither is going to be nil when the other is not.
								-- if danger.behavior.abilities.idle[1] ~= nil then
									-- behavior_toggle(
										-- danger.behavior.abilities.agro[1],
										-- danger.behavior.abilities.idle[1],
										-- TableConcat({danger.uid}, map(danger.behavior.abilities, function(ability) return ability[1] end)),--{ danger.behavior.abilities.agro[1], danger.behavior.abilities.idle[1], danger.uid },
										-- danger.behavior.agro
									-- )
								-- end	
							-- end
						-- end
						
					-- end
				-- end
				if danger.behavior.velocity_settimer ~= nil and danger.behavior.velocity_settimer > 0 then
					danger.behavior.velocity_settimer = danger.behavior.velocity_settimer - 1
				else
					if danger.behavior.velocityx ~= nil then
						danger_mov.velocityx = danger.behavior.velocityx
					end
					if danger.behavior.velocityy ~= nil then
						danger_mov.velocityx = danger.behavior.velocityx
					end
					-- toast("YEET: " .. tostring(danger_mov.velocityx))
					danger.behavior.velocity_settimer = nil
				end
			end

			if (
				(
					danger.hd_type.kill_on_standing ~= nil and
					(
						danger.hd_type.kill_on_standing == HD_KILL_ON.STANDING and
						danger_mov.standing_on_uid ~= -1
					) or
					(
						danger.hd_type.kill_on_standing == HD_KILL_ON.STANDING_OUTOFWATER and
						danger_mov.standing_on_uid ~= -1 and
						test_flag(danger_mov.more_flags, 11) == false
					)
				) or
				(
					danger.hd_type.removecorpse ~= nil and
					danger.hd_type.removecorpse == true and
					test_flag(danger_mov.flags, 29) == true
				)
			) then
				killbool = true
			end
		end
		if killbool == true then
			-- if there's no script-enduced death and we're left with a nil response to uid, track entity coordinates with HD_BEHAVIOR and upon a nil response set killbool in the danger_mov == nil statement. That should allow spawning the item here.
			-- This should also alow for removing all enemy behaviors.
			if danger.behavior ~= nil then
				if danger.behavior.bat_uid ~= nil then
					move_entity(danger.behavior.bat_uid, 0, 0, 0, 0)
				end
			end
			if danger.hd_type.itemdrop ~= nil then -- if dead and has possible item drops
				if danger.hd_type.itemdrop.item ~= nil and #danger.hd_type.itemdrop.item > 0 then
					if (
						danger.hd_type.itemdrop.chance == nil or
						(
							danger.hd_type.itemdrop.chance ~= nil and
							-- danger.itemdrop.chance > 0 and
							math.random() <= danger.hd_type.itemdrop.chance
						)
					) then
						itemdrop = danger.hd_type.itemdrop.item[math.random(1, #danger.hd_type.itemdrop.item)]
						if itemdrop == HD_ENT.ITEM_CRYSTALSKULL then
							create_ghost()
						end
						danger_spawn(itemdrop, danger.x, danger.y, danger.l, false, 0, 0)--spawn(itemdrop, etc)
					end
				end
			end
			if danger.hd_type.treasuredrop ~= nil then -- if dead and has possible item drops
				if danger.hd_type.treasuredrop.item ~= nil and #danger.hd_type.treasuredrop.item > 0 then
					if (
						danger.hd_type.treasuredrop.chance == nil or
						(
							danger.hd_type.treasuredrop.chance ~= nil and
							-- danger.treasuredrop.chance > 0 and
							math.random() <= danger.hd_type.treasuredrop.chance
						)
					) then
						itemdrop = danger.hd_type.treasuredrop.item[math.random(1, #danger.hd_type.treasuredrop.item)]
						danger_spawn(itemdrop, danger.x, danger.y, danger.l, false, 0, 0)
					end
				end
			end
			kill_entity(danger.uid)
			danger_tracker[i] = nil
		end
	end
	-- compact danger_tracker
	CompactList(danger_tracker, n)
	-- TODO: move to method
	-- local j=0
	-- for i=1,n do
		-- if danger_tracker[i]~=nil then
			-- j=j+1
			-- danger_tracker[j]=danger_tracker[i]
		-- end
	-- end
	-- for i=j+1,n do
		-- danger_tracker[i]=nil
	-- end
end

-- if enabled == true, enable target_uid and disable master
-- if enabled == false, enable master_uid and disable behavior
-- loop through and disable behavior_uids unless it happeneds to be the behavior or the master uid
function behavior_toggle(target_uid, master_uid, behavior_uids, enabled)
	master_mov = get_entity(master_uid)
	if master_mov ~= nil then
		behavior_e = get_entity(target_uid)
		if behavior_e ~= nil then
			if enabled == true then
				-- behavior_e.flags = clr_flag(behavior_e.flags, 28)-- enable ai/physics of behavior
				behavior_set_facing(target_uid, master_uid)
				-- bx, by, _ = get_position(target_uid)
				-- move_entity(master_uid, bx, by, 0, 0)
				behavior_set_position(target_uid, master_uid)
			else
				-- behavior_e.flags = set_flag(behavior_e.flags, 28)-- disable ai/physics of behavior
				-- x, y, _ = get_position(master_uid)
				-- move_entity(target_uid, x, y, 0, 0)
				behavior_set_position(master_uid, target_uid)
			end
			for _, other_uid in ipairs(behavior_uids) do
				if other_uid ~= master_uid and other_uid ~= target_uid then
					-- other_e = get_entity(other_uid)
					-- if other_e ~= nil then
						-- other_e.flags = set_flag(other_e.flags, 28)-- disable ai/physics of behavior
					-- end
					behavior_set_position(master_uid, other_uid)
				end
			end
		else
			toast("behavior_toggle(): behavior is nil")
		end
	else
		toast("behavior_toggle(): master is nil")
	end
end

function behavior_set_position(uid_toadopt, uid_toset)
	x, y, _ = get_position(uid_toadopt)
	move_entity(uid_toset, x, y, 0, 0)
end

function behavior_set_facing(behavior_uid, master_uid)
	behavior_flags = get_entity_flags(behavior_uid)
	master_mov = get_entity(master_uid)
	if master_mov ~= nil then
		if test_flag(behavior_flags, 17) then
			master_mov.flags = set_flag(master_mov.flags, 17)
		else
			master_mov.flags = clr_flag(master_mov.flags, 17)
		end
	else
		toast("behavior_set_facing(): master is nil")
	end
end

function behavior_giantfrog(target_uid)
	toast("SPEET!")
	ink = get_entities_by_type(ENT_TYPE.ITEM_INKSPIT)
	replaced = false
	for _, spit in ipairs(ink) do
		if replaced == false then
			spit_mov = get_entity(spit):as_movable()
			if spit_mov.last_owner_uid == target_uid then
				sx, sy, sl = get_position(spit)
				spawn(ENT_TYPE.MONS_FROG, sx, sy, sl, spit_mov.velocityx, spit_mov.velocityy)
				replaced = true
			end
		end
		kill_entity(spit)
	end
end

function onframe_ghosts()
	ghost_uids = get_entities_by_type({
		ENT_TYPE.MONS_GHOST
	})
	ghosttoset_uid = 0
	for _, found_ghost_uid in ipairs(ghost_uids) do
		accounted = 0
		for _, cur_ghost_uid in ipairs(DANGER_GHOST_UIDS) do
			if found_ghost_uid == cur_ghost_uid then accounted = cur_ghost_uid end
			
			ghost = get_entity(found_ghost_uid):as_ghost()
			-- toast("timer: " .. tostring(ghost.split_timer) .. ", v_mult: " .. tostring(ghost.velocity_multiplier))
			if (options.hd_og_ghost_nosplit == true) then ghost.split_timer = 0 end
		end
		if accounted == 0 then ghosttoset_uid = found_ghost_uid end
	end
	if ghosttoset_uid ~= 0 then
		ghost = get_entity(ghosttoset_uid):as_ghost()
		
		if (options.hd_og_ghost_slow == true) then ghost.velocity_multiplier = GHOST_VELOCITY end
		if (options.hd_og_ghost_nosplit == true) then ghost.split_timer = 0 end
		
		DANGER_GHOST_UIDS[#DANGER_GHOST_UIDS+1] = ghosttoset_uid
	end
end

function onframe_bacterium()
	if state.theme == THEME.EGGPLANT_WORLD then
		
		-- Bacterium Creation
			-- FLOOR_THORN_VINE:
				-- flags = clr_flag(flags, 2) -- indestructable (maybe need to clear this? Not sure yet)
				-- flags = clr_flag(flags, 3) -- solid wall
				-- visible
				-- allow hurting player
				-- allow bombs to destroy them.
			-- ACTIVEFLOOR_BUSHBLOCK:
				-- invisible
				-- flags = clr_flag(flags, 3) -- solid wall
				-- allow taking damage (unless it's already enabled by default)
			-- ITEM_ROCK:
				-- disable ai and physics
					-- re-enable once detached from surface
		
		-- Bacterium Movement Script
		-- TODO: Move to onframe_manage_dangers
		-- Class requirements:
		-- - Destination {float, float}
		-- - Angle int
		-- - Entity uid:
		-- - stun timeout (May be possible to track with the entity)
		-- TODO: Detect whether it is owned by a wall and if the wall exists, and if not, attempt to adopt a wall within all
		-- 4 sides of it. If that fails, enable physics if not already.
		-- If it is owned by a wall, detect 
		-- PROTOTYPING:
		-- if {x, y} == destination, then:
		--   if "block to immediate right", then:
		--     if "block to immediate front", then:
		--       rotate -90d;
		--     end
		--     own block to immediate right;
		--   else:
		--     rotate 90d;
		--   end
		--   destination = {x, y} of immediate front
		-- go towards the destination;
		-- end
		-- TODO: Get to the point where you can store a single bacterium in an array, get placed on a wall and toast the angle it's chosen to face.
	end
end

function onframe_olmec_cutscene() -- TODO: Move to set_interval() that you can close later
	c_logics = get_entities_by_type(ENT_TYPE.LOGICAL_CINEMATIC_ANCHOR)
	if #c_logics > 0 then
		c_logics_e = get_entity(c_logics[1]):as_movable()
		dead = test_flag(c_logics_e.flags, 29)
		if dead == true then
			-- If you skip the cutscene before olmec smashes the blocks, this will teleport him outside of the map and crash.
			-- kill the blocks olmec would normally smash.
			for b = 1, 4, 1 do
				local blocks = get_entities_at(ENT_TYPE.FLOORSTYLED_STONE, 0, 21+b, 98, LAYER.FRONT, 0.5)
				if #blocks > 0 then
					kill_entity(blocks[1])
				end
				b = b + 1
			end
			cutscene_move_olmec_post()
			BOSS_STATE = BOSS_SEQUENCE.FIGHT
		end
	end
end

function onframe_boss()
	if state.theme == THEME.OLMEC then
		if OLMEC_ID then
			if BOSS_STATE == BOSS_SEQUENCE.CUTSCENE then
				onframe_olmec_cutscene()
			elseif BOSS_STATE == BOSS_SEQUENCE.FIGHT then
				onframe_olmec_behavior()
				onframe_boss_wincheck()
			end
		end
	end
end

function onframe_olmec_behavior()
	olmec = get_entity(OLMEC_ID)
	if olmec ~= nil then
		olmec = get_entity(OLMEC_ID):as_olmec()
		-- Ground Pound behavior:
			-- TODO: Currently the spelunker can be crushed on the ceiling.
			-- This is due to HD's olmec having a much shorter jump and shorter hop curve and distance.
			-- Decide whether or not we restore this behavior or if we raise the ceiling generation.
		-- OLMEC_SEQUENCE = { ["STILL"] = 1, ["FALL"] = 2 }
		-- Enemy Spawning: Detect when olmec is about to smash down
		if olmec.velocityy > -0.400 and olmec.velocityx == 0 and OLMEC_STATE == OLMEC_SEQUENCE.FALL then
			OLMEC_STATE = OLMEC_SEQUENCE.STILL
			x, y, l = get_position(OLMEC_ID)
			-- random chance (maybe 20%?) each time olmec groundpounds, shoots 3 out in random directions upwards.
			-- if math.random() >= 0.5 then
				-- TODO: Currently runs twice. Find a fix.
				olmec_attack(x, y+2, l)
				-- olmec_attack(x, y+2.5, l)
				-- olmec_attack(x, y+2.5, l)
				
			-- end
		elseif olmec.velocityy < -0.400 then
			OLMEC_STATE = OLMEC_SEQUENCE.FALL
		end
	end
end

function olmec_attack(x, y, l)
	danger_spawn(HD_ENT.OLMEC_SHOT, x, y, l, false, 0, 150)
end

function danger_track(uid_to_track, x, y, l, hd_type)
	danger_object = {
		["uid"] = uid_to_track,
		["x"] = x, ["y"] = y, ["l"] = l,
		["hd_type"] = hd_type,
		["behavior"] = create_behavior(hd_type.behavior)
	}
	danger_tracker[#danger_tracker+1] = danger_object
end

function create_behavior(behavior)
	decorated_behavior = {}
	if behavior ~= nil then
		decorated_behavior = TableCopy(behavior)
		-- if behavior.abilities ~= nil then
			if behavior == HD_BEHAVIOR.SCORPIONFLY then
				-- TODO: Ask the discord if it's actually possible to check if a variable exists even if it's set to nil
				-- The solution is probably assigning ability parameters by setting the variable to -1
					-- (which I CAN do in this situation considering it's a uid field)
				-- ACTUALLYYYYYYYYYYYY The solution is probably using string indexes(I'm probably butchuring the terminology)
					-- For instance; "for string, value in pairs(decorated_behavior.abilities) do if string == "bat_uid" then toast("BAT!!") end end"
				
				-- if behavior.abilities.agro.bat_uid ~= nil then
					
					decorated_behavior.bat_uid = spawn(ENT_TYPE.MONS_IMP, x, y, l, 0, 0)--decorated_behavior.abilities.agro.bat_uid = spawn(ENT_TYPE.MONS_BAT, x, y, l, 0, 0)
					applyflags_to_uid(decorated_behavior.bat_uid, {{ 1, 6, 25 }})
				
				-- end
				-- if behavior.abilities.idle.mosquito_uid ~= nil then
					
					-- decorated_behavior.abilities.idle.mosquito_uid = spawn(ENT_TYPE.MONS_MOSQUITO, x, y, l, 0, 0)
					-- ability_e = get_entity(decorated_behavior.abilities.idle.mosquito_uid)
					-- if options.hd_debug_invis == false then
						-- ability_e.flags = set_flag(ability_e.flags, 1)
					-- end
					-- ability_e.flags = set_flag(ability_e.flags, 6)
					-- ability_e.flags = set_flag(ability_e.flags, 25)
					
				-- end
				
					-- toast("#decorated_behavior.abilities: " .. tostring(#decorated_behavior.abilities))
			end
			if behavior == HD_BEHAVIOR.OLMEC_SHOT then
				xvel = math.random(7, 30)/100
				yvel = math.random(5, 10)/100
				if math.random() >= 0.5 then xvel = -1*xvel end
				decorated_behavior.velocityx = xvel
				decorated_behavior.velocityy = yvel
			end
		-- end
	end
	return decorated_behavior
end

-- velocity defaults to 0
function create_danger(hd_type, x, y, l, _vx, _vy)
	vx = _vx or 0
	vy = _vy or 0
	uid = -1
	if (hd_type.collisiontype ~= nil and (hd_type.collisiontype == HD_COLLISIONTYPE.FLOORTRAP or hd_type.collisiontype == HD_COLLISIONTYPE.FLOORTRAP_TALL)) then
		floor_uid = detection_floor(x, y, l, 0, -1, 0.5)
		if floor_uid ~= -1 then
			uid = spawn_entity_over(hd_type.tospawn, floor_uid, 0, 1)
			if hd_type.collisiontype == HD_COLLISIONTYPE.FLOORTRAP_TALL then
				s_head = spawn_entity_over(hd_type.tospawn, uid, 0, 1)
			end
		end
		-- TODO: Modify to accommodate the following enemies:
			-- The Mines:
				-- Miniboss enemy: Giant spider
				-- If there's a wall to the right, don't spawn. (maybe 2 walls down, too?)
			-- The Jungle:
				-- Miniboss enemy: Giant frog
				-- If there's a wall to the right, don't spawn. (For the future when we don't replace mosquitos (or any enemy at all), try to spawn on 2-block surfaces.
		-- TODO: Move conflict detection into its own category.
		-- TODO: Add an HD_ENT property that takes an enum to set collision detection.
	else
		uid = spawn(hd_type.tospawn, x, y, l, vx, vy)
	end
	return uid
end

function danger_applydb(uid, hd_type)
	s_mov = get_entity(uid):as_movable()
	x, y, l = get_position(uid)
	
	if hd_type == HD_ENT.HANGSPIDER then
		spawn(ENT_TYPE.ITEM_WEB, x, y, l, 0, 0) -- move into HD_ENT properties
		spawn_entity_over(ENT_TYPE.ITEM_HANGSTRAND, uid, 0, 0) -- tikitraps can use this
	end
	if hd_type.color ~= nil and #hd_type.color == 3 then
		s_mov.color.r = hd_type.color[1]
		s_mov.color.g = hd_type.color[2]
		s_mov.color.b = hd_type.color[3]
	end
	if hd_type.health ~= nil and hd_type.health > 0 then
		s_mov.health = hd_type.health
	end
	if hd_type.dim ~= nil and #hd_type.dim == 2 then
		s_mov.width = hd_type.dim[1]
		s_mov.height = hd_type.dim[2]
	end
	if hd_type.hitbox ~= nil and #hd_type.hitbox == 2 then
		s_mov.hitboxx = hd_type.hitbox[1]
		s_mov.hitboxy = hd_type.hitbox[2]
	end
	-- TODO: Move flags into a table of pairs(flagnumber, bool)
	if hd_type.flags ~= nil then
		applyflags_to_uid(uid, hd_type.flags)
	end
	
	-- if hd_type.flag_stunnable ~= nil then
		-- if hd_type.flag_stunnable == true then
			-- s_mov.flags = set_flag(s_mov.flags, 12)
		-- else
			-- s_mov.flags = clr_flag(s_mov.flags, 12)
		-- end
	-- end
	
	-- if hd_type.flag_collideswalls ~= nil then
		-- if hd_type.flag_collideswalls == true then
			-- s_mov.flags = set_flag(s_mov.flags, 13)
		-- else
			-- s_mov.flags = clr_flag(s_mov.flags, 13)
		-- end
	-- end
	
	-- if hd_type.flag_nogravity ~= nil then
		-- if hd_type.flag_nogravity == true then
			-- s_mov.flags = set_flag(s_mov.flags, 4)
		-- else
			-- s_mov.flags = clr_flag(s_mov.flags, 4)
		-- end
	-- end
	
	-- if hd_type.flag_passes_through_objects ~= nil then
		-- if hd_type.flag_passes_through_objects == true then
			-- s_mov.flags = set_flag(s_mov.flags, 10)
		-- else
			-- s_mov.flags = clr_flag(s_mov.flags, 10)
		-- end
	-- end
end

-- velocity defaults to uid's
function danger_replace(uid, hd_type, collision_detection, _vx, _vy)
	uid_to_track = uid
	d_mov = get_entity(uid_to_track):as_movable()
	vx = _vx or d_mov.velocityx
	vy = _vy or d_mov.velocityx
	
	x, y, l = get_position(uid_to_track)
	
	d_type = get_entity(uid_to_track).type.id
	
	offset_collision = conflictdetection(hd_type.collisiontype, x, y, l)
	if collision_detection == true and offset_collision == nil then
		offset_collision = nil
		uid_to_track = -1
		move_entity(uid, 0, 0, 0, 0)
	elseif collision_detection == false then
		offset_collision = { 0, 0 }
	end
	if offset_collision ~= nil then
		if (hd_type.tospawn ~= nil and hd_type.tospawn ~= d_type) then
			offset_spawn_x, offset_spawn_y = 0, 0
			if hd_type.offset_spawn ~= nil then
				offset_spawn_x, offset_spawn_y = hd_type.offset_spawn[1], hd_type.offset_spawn[2]
			end
			uid_to_track = create_danger(hd_type, x+offset_spawn_x+offset_collision[1], y+offset_spawn_y+offset_collision[2], l, vx, vy)
			
			move_entity(uid, 0, 0, 0, 0)
		else -- don't replace, apply velocities to and track what you normally would replace
			d_mov.velocityx = vx
			d_mov.velocityy = vy
			uid_to_track = uid
		end
	end

	if uid_to_track ~= -1 then 
		danger_applydb(uid_to_track, hd_type)
		danger_track(uid_to_track, x, y, l, hd_type)
	end
end

-- velocity defaults to 0 (by extension of `create_danger()`)
function danger_spawn(hd_type, x, y, l, collision_detection, _vx, _vy)
	offset_collision = { 0, 0 }
	if collision_detection == true then
		offset_collision = conflictdetection(hd_type.collisiontype, x, y, l)
	end
	if offset_collision ~= nil then
		offset_spawn_x, offset_spawn_y = 0, 0
		if hd_type.offset_spawn ~= nil then
			offset_spawn_x, offset_spawn_y = hd_type.offset_spawn[1], hd_type.offset_spawn[2]
		end
		uid = create_danger(hd_type, x+offset_spawn_x+offset_collision[1], y+offset_spawn_y+offset_collision[2], l, _vx, _vy)
		if uid ~= -1 then
			danger_applydb(uid, hd_type)
			danger_track(uid, x, y, l, hd_type)
		end
	end
end

function applyflags_to_level(flags)
	if #flags > 0 then
		flags_set = flags[1]
		for _, flag in ipairs(flags_set) do
			state.level_flags = set_flag(state.level_flags, flag)
		end
		if #flags > 1 then
			flags_clear = flags[2]
			for _, flag in ipairs(flags_clear) do
				state.level_flags = clr_flag(state.level_flags, flag)
			end
		end
	else toast("No level flags") end
end

function applyflags_to_quest(flags)
	if #flags > 0 then
		flags_set = flags[1]
		for _, flag in ipairs(flags_set) do
			state.quest_flags = set_flag(state.quest_flags, flag)
		end
		if #flags > 1 then
			flags_clear = flags[2]
			for _, flag in ipairs(flags_clear) do
				state.quest_flags = clr_flag(state.quest_flags, flag)
			end
		end
	else toast("No quest flags") end
end

function applyflags_to_uid(uid_assignto, flags)
	if #flags > 0 then
		ability_e = get_entity(uid_assignto)
		flags_set = flags[1]
		for _, flag in ipairs(flags_set) do
			if (
				flag ~= 1 or
				(flag == 1 and options.hd_debug_invis == false)
			) then
				ability_e.flags = set_flag(ability_e.flags, flag)
			end
		end
		if #flags > 1 then
			flags_clear = flags[2]
			for _, flag in ipairs(flags_clear) do
				ability_e.flags = clr_flag(ability_e.flags, flag)
			end
		end
	else toast("No flags") end
end

function onframe_boss_wincheck()
	if BOSS_STATE == BOSS_SEQUENCE.FIGHT then
		olmec = get_entity(OLMEC_ID):as_olmec()
		if olmec ~= nil then
			if olmec.attack_phase == 3 then
				-- TODO: play cool win jingle
				BOSS_STATE = BOSS_SEQUENCE.DEAD
				unlock_door_at(41, 99)
			end
		end
	end
end

function onguiframe_ui_info_boss()
	if options.hd_debug_info_boss == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		if state.theme == THEME.OLMEC and OLMEC_ID ~= nil then
			olmec = get_entity(OLMEC_ID)
			text_x = -0.95
			text_y = -0.50
			white = rgba(255, 255, 255, 255)
			if olmec ~= nil then
				olmec = get_entity(OLMEC_ID):as_olmec()
				
				-- OLMEC_SEQUENCE = { ["STILL"] = 1, ["FALL"] = 2 }
				olmec_attack_state = "UNKNOWN"
				if OLMEC_STATE == OLMEC_SEQUENCE.STILL then olmec_attack_state = "STILL"
				elseif OLMEC_STATE == OLMEC_SEQUENCE.FALL then olmec_attack_state = "FALL" end
				
				-- BOSS_SEQUENCE = { ["CUTSCENE"] = 1, ["FIGHT"] = 2, ["DEAD"] = 3 }
				boss_attack_state = "UNKNOWN"
				if BOSS_STATE == BOSS_SEQUENCE.CUTSCENE then BOSS_attack_state = "CUTSCENE"
				elseif BOSS_STATE == BOSS_SEQUENCE.FIGHT then BOSS_attack_state = "FIGHT"
				elseif BOSS_STATE == BOSS_SEQUENCE.DEAD then BOSS_attack_state = "DEAD" end
				
				draw_text(text_x, text_y, 0, "OLMEC_STATE: " .. olmec_attack_state, white)
				text_y = text_y - 0.1
				draw_text(text_x, text_y, 0, "BOSS_STATE: " .. boss_attack_state, white)
			else draw_text(text_x, text_y, 0, "olmec is nil", white) end
		end
	end
end

function onguiframe_ui_info_wormtongue()
	if options.hd_debug_info_tongue == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		if state.level == 1 and (state.theme == THEME.JUNGLE or state.theme == THEME.ICE_CAVES) then
			text_x = -0.95
			text_y = -0.45
			white = rgba(255, 255, 255, 255)
			
			-- TONGUE_SEQUENCE = { ["READY"] = 1, ["RUMBLE"] = 2, ["EMERGE"] = 3, ["SWALLOW"] = 4 , ["GONE"] = 5 }
			tongue_debugtext_sequence = "UNKNOWN"
			if TONGUE_STATE == TONGUE_SEQUENCE.READY then tongue_debugtext_sequence = "READY"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.RUMBLE then tongue_debugtext_sequence = "RUMBLE"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.EMERGE then tongue_debugtext_sequence = "EMERGE"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.SWALLOW then tongue_debugtext_sequence = "SWALLOW"
			elseif TONGUE_STATE == TONGUE_SEQUENCE.GONE then tongue_debugtext_sequence = "GONE" end
			draw_text(text_x, text_y, 0, "Worm Tongue State: " .. tongue_debugtext_sequence, white)
			text_y = text_y-0.1
			
			tongue_debugtext_uid = tostring(TONGUE_UID)
			if TONGUE_UID == nil then tongue_debugtext_uid = "nil" end
			draw_text(text_x, text_y, 0, "Worm Tongue UID: " .. tongue_debugtext_uid, white)
			text_y = text_y-0.1
			
			tongue_debugtext_tick = tostring(tongue_tick)
			if tongue_tick == nil then tongue_debugtext_tick = "nil" end
			draw_text(text_x, text_y, 0, "Worm Tongue Acceptance tic: " .. tongue_debugtext_tick, white)
		end
	end
end

function onguiframe_ui_info_boulder()
	if options.hd_debug_info_boulder == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		if (
			state.theme == THEME.DWELLING and
			(state.level == 2 or state.level == 3 or state.level == 4)
		) then
			text_x = -0.95
			text_y = -0.45
			green_rim = rgba(102, 108, 82, 255)
			green_hitbox = rgba(153, 196, 19, 170)
			white = rgba(255, 255, 255, 255)
			if BOULDER_UID == nil then text_boulder_uid = "No Boulder Onscreen"
			else text_boulder_uid = tostring(BOULDER_UID) end
			
			sx = BOULDER_SX
			sy = BOULDER_SY
			sx2 = BOULDER_SX2
			sy2 = BOULDER_SY2
			
			draw_text(text_x, text_y, 0, "BOULDER_UID: " .. text_boulder_uid, white)
			
			if BOULDER_UID ~= nil and sx ~= nil and sy ~= nil and sx2 ~= nil and sy2 ~= nil then
				text_y = text_y-0.1
				sp_x, sp_y = screen_position(sx, sy)
				sp_x2, sp_y2 = screen_position(sx2, sy2)
				
				-- draw_rect(sp_x, sp_y, sp_x2, sp_y2, 4, 0, green_rim)
				draw_rect_filled(sp_x, sp_y, sp_x2, sp_y2, 0, green_hitbox)
				
				text_boulder_sx = tostring(sx)
				text_boulder_sy = tostring(sy)
				text_boulder_sx2 = tostring(sx2)
				text_boulder_sy2 = tostring(sy2)
				if BOULDER_DEBUG_PLAYERTOUCH == true then text_boulder_touching = "Touching!" else text_boulder_touching = "Not Touching." end
				
				draw_text(text_x, text_y, 0, "SX: " .. text_boulder_sx, white)
				text_y = text_y-0.1
				draw_text(text_x, text_y, 0, "SY: " .. text_boulder_sy, white)
				text_y = text_y-0.1
				draw_text(text_x, text_y, 0, "SX2: " .. text_boulder_sx2, white)
				text_y = text_y-0.1
				draw_text(text_x, text_y, 0, "SY2: " .. text_boulder_sy2, white)
				text_y = text_y-0.1
				
				draw_text(text_x, text_y, 0, "Player touching top of hitbox: " .. text_boulder_touching, white)
			end
		end
	end
end

function onguiframe_ui_info_feelings()
	if options.hd_debug_info_feelings == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		text_x = -0.95
		text_y = -0.35
		white = rgba(255, 255, 255, 255)
		green = rgba(55, 200, 75, 255)
		
		text_levelfeelings = "No Level Feelings"
		feelings = 0
		
		for feelingname, feeling in pairs(global_feelings) do
			if feeling_check(feelingname) == true then
				feelings = feelings + 1
			end
		end
		if feelings ~= 0 then text_levelfeelings = (tostring(feelings) .. " Level Feelings") end
		
		draw_text(text_x, text_y, 0, text_levelfeelings, white)
		text_y = text_y-0.035
		color = white
		if MESSAGE_FEELING ~= nil then color = green end
		text_message_feeling = ("MESSAGE_FEELING: " .. tostring(MESSAGE_FEELING))
		draw_text(text_x, text_y, 0, text_message_feeling, color)
		text_y = text_y-0.05
		for feelingname, feeling in pairs(global_feelings) do
			color = white
			message = ""
			
			feeling_bool = feeling_check(feelingname)
			if feeling.message ~= nil then message = (": \"" .. feeling.message .. "\"") end
			if feeling_bool == true then color = green end
			
			text_feeling = (feelingname) .. message
			
			draw_text(text_x, text_y, 0, text_feeling, color)
			text_y = text_y-0.035
		end

	end
end

function onguiframe_ui_info_path()
	if options.hd_debug_info_path == true and (state.pause == 0 and state.screen == 12 and #players > 0) then
		text_x = -0.95
		text_y = -0.35
		white = rgba(255, 255, 255, 255)
		
		levelw, levelh = #LEVEL_PATH, #LEVEL_PATH[1]--get_levelsize()
		text_y_space = text_y
		for hi = 1, levelh, 1 do -- hi :)
			text_x_space = text_x
			for wi = 1, levelw, 1 do
				text_subchunkid = tostring(LEVEL_PATH[wi][hi])
				if text_subchunkid == nil then text_subchunkid = "nil" end
				draw_text(text_x_space, text_y_space, 0, text_subchunkid, white)
				
				text_x_space = text_x_space+0.04
			end
			text_y_space = text_y_space-0.04
		end
	end
end

-- Prize Wheel
-- TODO: Once using diceposter texture, remove this.
function onguiframe_env_animate_prizewheel()
	if (state.pause == 0 and state.screen == 12 and #players > 0) then
		local atms = get_entities_by_type(ENT_TYPE.ITEM_DICE_BET)
		if #atms > 0 then
			for i, atm in ipairs(atms) do
				local atm_mov = get_entity(atms[i]):as_movable()
				local atm_facing = test_flag(atm_mov.flags, 17)
				local atm_x, atm_y, atm_l = get_position(atm_mov.uid)
				local wheel_x_raw = atm_x
				local wheel_y_raw = atm_y+1.5
				
				local facing_dist = 1
				if atm_facing == false then facing_dist = -1 end
				
				wheel_x_raw = wheel_x_raw + 1 * facing_dist
				
				local wheel_x, wheel_y = screen_position(wheel_x_raw, wheel_y_raw)
				-- draw_text(wheel_x, wheel_y, 0, tostring(wheel_speed), rgba(234, 234, 234, 255))
				draw_circle(wheel_x, wheel_y, screen_distance(1.3), 8, rgba(102, 108, 82, 255))
				draw_circle_filled(wheel_x, wheel_y, screen_distance(1.3), rgba(153, 196, 19, 70))
				draw_circle_filled(wheel_x, wheel_y, screen_distance(0.1), rgba(255, 59, 89, 255))
			end
		end
	end
end

-- Book of dead animating
function onguiframe_ui_animate_botd()
	if state.pause == 0 and state.screen == 12 and #players > 0 then
		if OBTAINED_BOOKOFDEAD == true then
			local w = UI_BOTD_PLACEMENT_W
			local h = UI_BOTD_PLACEMENT_H
			local x = UI_BOTD_PLACEMENT_X
			local y = UI_BOTD_PLACEMENT_Y
			local uvx1 = 0
			local uvy1 = 0
			local uvx2 = bookofdead_squash
			local uvy2 = 1
			
			if state.theme == THEME.OLMEC then
				local hellx_min = HELL_X - math.floor(BOOKOFDEAD_RANGE/2)
				local hellx_max = HELL_X + math.floor(BOOKOFDEAD_RANGE/2)
				p_x, p_y, p_l = get_position(players[1].uid)
				if (p_x >= hellx_min) and (p_x <= hellx_max) then
					animate_bookofdead(0.6*((p_x - HELL_X)^2) + BOOKOFDEAD_TIC_LIMIT)
				else
					bookofdead_tick = 0
					bookofdead_frames_index = 1
				end
			elseif state.theme == THEME.VOLCANA then
				if state.level == 1 then
					animate_bookofdead(12)
				elseif state.level == 2 then
					animate_bookofdead(8)
				elseif state.level == 3 then
					animate_bookofdead(4)
				else
					animate_bookofdead(2)
				end
			end
			
			uvx1 = -bookofdead_squash*(bookofdead_frames_index-1)
			uvx2 = bookofdead_squash - bookofdead_squash*(bookofdead_frames_index-1)
			
			-- draw_text(x-0.1, y, 0, tostring(bookofdead_tick), rgba(234, 234, 234, 255))
			-- draw_text(x-0.1, y-0.1, 0, tostring(bookofdead_frames_index), rgba(234, 234, 234, 255))
			draw_image(UI_BOTD_IMG_ID, x, y, x+w, y-h, uvx1, uvy1, uvx2, uvy2, 0xffffffff)
		end
	end
end


-- TODO: Turn into a custom inventory system that works for all players.
function inventory_checkpickup_botd()
	if OBTAINED_BOOKOFDEAD == false then
		for i = 1, #players, 1 do
			if entity_has_item_type(players[i].uid, ENT_TYPE.ITEM_POWERUP_TABLETOFDESTINY) then
				-- TODO: Move into the method that spawns Anubis II in COG
				toast("Death to the defiler!")
				OBTAINED_BOOKOFDEAD = true
				set_timeout(function() remove_player_item(ENT_TYPE.ITEM_POWERUP_TABLETOFDESTINY) end, 1)
			end
		end
	end
end

-- apply randomized frame offsets to uids of ENT_TYPE.FLOOR tiles
	-- pass in:
		-- a table of uids
		-- a table of dimensions
	-- assign each uid a random animation_frame
	-- This method has recursive potential. Would work for areas much larger than 2x2 but would need adjustment for that
	
function tileapplier9000(_tilegroup)
	uid_offsetpair = _tilegroup.uid_offsetpair
	dim = _tilegroup.dim
		-- width = 3
		-- height = 4
	for yi = 0, -(dim[2]-1), -1 do -- 0 -> -3
		for xi = 0, (dim[1]-1), 1 do -- 0 -> 2
			dim_viable = {(dim[1]-xi), (dim[2]+yi)} -- 3, 4 -> 1, 1
			for _, offsetpair in ipairs(uid_offsetpair) do
				-- Will have no uid if already applied.
				if offsetpair.uid == nil and offsetpair.offset ~= nil then
					dim_viable = tileapplier_get_viabledim(dim, xi, yi, offsetpair.offset)
				end
			end
			-- if floor available, apply random animation_frame to uids
			if dim_viable[1] > 0 and dim_viable[2] > 0 then
				-- find applicable uids with the given dimensions
				origin = { xi, yi }
				tileapplier_apply_randomframe(_tilegroup, origin, dim_viable)
			end
		end
	end
end

-- return uids (debug purposes)
function tileapplier_apply_randomframe(_tilegroup, origin, dim_viable)
	uids = {}
	setup_apply = tileapplier_get_randomwithin(dim_viable)
	dim = setup_apply.dim--_tilegroup.dim
	-- if origin[1] == 2 then
		-- toast(tostring(origin[1]) .. ", " .. tostring(origin[2]))-- .. ": " .. tostring(setup_apply.frames[1]))
	-- end
	uid_offsetpair = _tilegroup.uid_offsetpair
	frames_i = 1 -- ah yes, frames_i, the ugly older brother of iframes
	for yi = origin[2], dim[2]-1, 1 do -- start at origin[2], end at dim[2]
		for xi = origin[1], dim[1]-1, 1 do
			for _, offsetpair in ipairs(uid_offsetpair) do
				if offsetpair.uid ~= nil and offsetpair.offset ~= nil then
					if offsetpair.offset[1] == xi and offsetpair.offset[2] == yi then
						floor_e = get_entity(offsetpair.uid)
						floor_m = floor_e:as_movable()
						frame = setup_apply.frames[frames_i]
						-- toast(tostring(xi) .. ", " .. tostring(yi) .. ": " .. tostring(frame))
						floor_m.animation_frame = frame
						-- apply to uids, then assign offset in dim
						table.insert(uids, offsetpair.uid)
						offsetpair.uid = nil
					end
				end
			end
			frames_i = frames_i + 1
		end
	end
	return uids
end

function tileapplier_get_viabledim(dim, xi, yi, offset)
	dim_viable = {(dim[1]-xi), (dim[2]+yi)}--{1+(dim[1]-xi), 1+(dim[2]-yi)}
	x_larger = offset[1] > xi
	x_equals = offset[1] == xi
	y_larger = offset[2] > yi
	y_equals = offset[2] == yi
	both_equals = x_equals and y_equals
	both_larger = x_larger and y_larger
	if (x_equals or x_larger) and (y_equals or y_larger) then
		if x_larger and y_equals then -- subtract from viable dimension
			dim_viable[1] = dim_viable[1] - 1
		elseif both_equals then
			dim_viable[1] = dim_viable[1] - 2
		end
		if y_larger and x_equals then -- subtract from viable dimension
			dim_viable[2] = dim_viable[2] - 1
		elseif both_equals then
			dim_viable[2] = dim_viable[2] - 2
		end
	end
	return dim_viable
end

-- Compact tileframes_floor into a local table of matching dimensions
function tileapplier_get_randomwithin(_dim)
	tileframes_floor_matching = TableCopy(TILEFRAMES_FLOOR)
	n = #tileframes_floor_matching
	for i, setup in ipairs(tileframes_floor_matching) do
		if (
			(setup.dim ~= nil and #setup.dim == 2) and
			(setup.dim[1] > _dim[1] or setup.dim[2] > _dim[2])
		) then tileframes_floor_matching[i] = nil end
	end
	tileframes_floor_matching = CompactList(tileframes_floor_matching, n)
	-- toast("#tileframes_floor_matching: " .. tostring(#tileframes_floor_matching))
	-- toast("_dim[1]: " .. tostring(_dim[1]).. ", _dim[2]: " .. tostring(_dim[2]))
	return TableRandomElement(tileframes_floor_matching)
end

-- TODO: Move HD_UNLOCKS to its own module
	-- Remove loading from external file, keep as hard-coded
	-- Still within it's own module, move HD_UNLOCKS to its own dedicated lua file so it can be easily overriden with a future mod.
		-- character_colors.zip?
function unlocks_file()
	lines = lines_from('Mods/Packs/HDmod/unlocks.txt')
	for _, inputstr in ipairs(lines) do
		t = {}
		for str in string.gmatch(inputstr, "([^//]+)") do
			table.insert(t, str)
		end
		inputstr_stripped = {}
		for str in string.gmatch(t[1], "([^%s]+)") do
			table.insert(inputstr_stripped, str)
		end
		HD_UNLOCKS[inputstr_stripped[1]].unlock_id = tonumber(inputstr_stripped[2])
	end
end

-- if `meta.unsafe` is enabled, load character unlocks as defined in the character file
-- otherwise use a hardcoded table for character unlocks
function unlocks_init()
	if meta.unsafe == true then
		unlocks_file()
	else
		unlocks_load()
	end
end

function unlocks_load()
	for _unlockname, k in pairs(HD_UNLOCKS) do
		HD_UNLOCKS[_unlockname].unlocked = test_flag(savegame.characters, k.unlock_id)
	end
end

function level_init()
	level_loadpath()
end

function level_loadpath()
	levelw, levelh = get_levelsize()
	LEVEL_PATH = path_setn(levelw, levelh)
	for hi = 1, levelh, 1 do -- hi :)
		for wi = 1, levelw, 1 do
			x, y = locate_cornerpos(wi, hi)
			edge = 0--.5
			ROOM_SX = x+edge
			ROOM_SY = y-7+edge
			ROOM_SX2 = x+9-edge
			ROOM_SY2 = y-edge
			id = "0"
			terms = {}
			terms_toavoid = {}
			for term_name, term_properties in pairs(HD_SUBCHUNKID_TERM) do
				entity_type = term_properties.entity_type
				uids = get_entities_overlapping(
					entity_type,
					0,
					ROOM_SX,
					ROOM_SY,
					ROOM_SX2,
					ROOM_SY2,
					LAYER.FRONT
				)
				if #uids > 0 then
					terms[term_name] = entity_type
					if term_properties.kill ~= nil and options.hd_debug_invis == false then
						for _, uid in ipairs(uids) do
							kill_entity(uid)
						end
					end
				else
					terms_toavoid[term_name] = entity_type
				end
			end
			if TableLength(terms) > 0 then
				-- loop over terms to avoid. if it contains those, abort.
				
				subchunkids_tonarrow = TableCopy(HD_SUBCHUNKID)
				for subchunk_id, types in pairs(subchunkids_tonarrow) do
					
					contains_terms_all = false
					tnum = 0
					for term_name, entity_type in pairs(terms) do
						for i = 1, #types, 1 do
							if entity_type == types[i].entity_type then
								tnum = tnum + 1
							end
						end
					end
					if tnum == TableLength(terms) then contains_terms_all = true end
					
					contains_terms_toavoid = false
					for term_name, term_enttype in pairs(terms_toavoid) do
						for i = 1, #types, 1 do
							if term_enttype == types[i].entity_type then
								contains_terms_toavoid = true
							end
						end
					end
					
					if (
						subchunk_id == "0" or
						contains_terms_all == false or
						contains_terms_toavoid == true
					) then
						subchunkids_tonarrow[subchunk_id] = nil
					end
				end
				
				if TableLength(subchunkids_tonarrow) == 1 then id = TableFirstKey(subchunkids_tonarrow) end
			end
			
			LEVEL_PATH[wi][hi] = id
		end
	end
end

-- SHOPS
-- Hiredhand shops have 1-3 hiredhands
-- Damzel for sale: The price for a kiss will be $8000 in The Mines, and it will increase by $2000 every area, so the prices will be $8000, $10000, $12000 and $14000 for a Damsel kiss in the four areas shops can spawn in. The price for buying the Damsel will be an extra 50% over the kiss price, making the prices $12000, $15000, $18000 and $21000 for all zones.
-- If custom shop generation ever becomes possible:
	-- Determine item pool, allow enabling certain S2 specific items with register_option_bool()
	

-- Wheel Gambling Ideas:
-- Detect purchasing from the game when the player loses 5k and stands right next to a machine
-- You can set flag 20 to turn the machine back on. it just doesn't show a buy dialog but works
-- Hide the dice, without dice it just crashes. you can set its alpha/size to 0 and make it immovable, probably
-- The wheel visuals/spinning:
-- It's most likely doable using the empty item sprites
-- Just have a few immovable objects that rotate and are upscaled :0
-- You could just use a few empty subimages in the items.png file and assign anything else to that frame

-- JUNGLE
-- ENEMIES:
-- Giant Frog
-- - While moving left or right(?), make it "hop" using velocity.
--   - on jump, add velocity up and to the direction it's facing.
-- LEVEL:
-- Haunted level: Spawn tusk idol, make it add a ghost upon disturbing it
--  - (It adds a ghost if the ghost is already spawned. Not sure if 2:30 ghost spawns if skull idol is already tripped)
-- ENT_TYPE_DECORATION_VLAD above alter? Or other banner, idk
-- Black Knight: Cloned shopkeeper with a sheild+extra health.
-- Green Knight: Tikiman/Caveman with extra health.


-- WORM LEVEL
-- ENEMIES:
-- Egg Sack - Replace maggots with 1hp cave mole
-- Bacterium - Maze navigating algorithm run through an array tracking each.
-- If entered from jungle, spawn tikimen, cavemen, monkeys, frogs, firefrogs, bats, and snails.
-- If entered from icecaves, spawn UFOs, Yetis, and bats.

-- ICE_CAVES
-- ENEMIES:
-- Mammoth - Use an enemy that never agros and paces between ledges. Store a bool to fire icebeam on stopping its idle walking cycle.
--  - If runs into player while frozen, kill/damage player.
-- Snowball
	-- once it hits something (has a victim?), revert animation_frame and remove uid from danger_tracker.

-- TEMPLE
-- ENEMIES:
-- Hawk man: Shopkeeper clone without shotgun (Or non teleporting Croc Man???)

-- LEVEL:
-- Script in hell door spawning
-- The Book of the Dead on the player's HUD will writhe faster the closer the player is to the X-coordinate of the entrance (HELL_X)
-- 

-- SCRIPTED ROOMCODE GENERATION
	-- IDEAS:
		-- In a 2d list loop for each room to replace:
			-- 1: log a 2d table of the level path and rooms to replace
				-- 1: As you loop over each room:
					-- Log in separate 2d array `rooms_subchunkids`: Based on HD_SUBCHUNKID and whether the space contains a shopkeep, log subchunk ids as generated by the game.
						-- 0: Non-main path subchunk
						-- 1: Main path, goes L/R (also entrance/exit)
						-- 2: Main path, goes L/R and down (and up if it's below another 2)
						-- 3: Main path, goes L/R and up
						-- 1000: Shop (rename in the future?)
						-- 1001: Vault (rename in the future?)
						-- 1002: Kali (rename in the future?)
						-- 1003: Idol (rename in the future?)
				-- 2: Detect whether there's an exit. Without the exit, we can't move enemies. if there IS no exit, generate a new path with one or adjust the existing path to make one.
					-- UPDATE: May be possible to fix broken exit generation by preventing waddler's shop from spawning entirely.
					-- For instance, the ice caves can sometimes generate no exit on the 4th row.
					-- If no 1 subchunkid exists on the fourth row:
						-- if 2 on the third row exists:
							-- add subchunk id 1 to the bottom row just below it.
						-- elseif 3 on the third row exists:
							-- add subchunk id 1 to the bottom row just below it.
							-- replace 3 with 2, mark in `rooms_replaceids`
						-- elseif 1000 on the third row exists:
							-- add subchunk id 1 to the bottom row just below it.
							-- replace 3 with 2
								-- if vault, mark as 2 in `rooms_replaceids`
								-- elseif shop, mark as 3 in `rooms_replaceids`
				-- 3: Otherwise, here's where script-determined level paths would be managed
					-- For instance, given the chance to have a snake pit, adjust/replace the path with one that includes it.
				-- 4: Log in separate 2d array `rooms_replaceids`:
					-- if no roomcodes exist to replace the room:
						-- 0: Don't touch this room.
					-- if the room has in the path:
					-- 1: Replace this room.
					-- else:
						-- if it's vault, kali alter, or idol trap:
							-- 2: Maintain this room's structure and find a new place to move it to.
						-- if it's a shop:
							-- 3: Maintain this room's structure and find a new place to move it to. Maintain its orientation in relation to the path.
				-- 5: Log which rooms need to be flipped. loop over the path and log in separate 2d array `rooms_orientids`:
					-- if the subchunk id is not a 3:
						-- 0: Don't touch this room.
					-- if the replacement id is a 3:
						-- if the path id to the right of it is a 1, 2 or 3:
							-- 2: Facing right.
						-- if the path id to the left of it is a 1, 2 or 3:
							-- 3: Facing left.
			-- 2: Log uids of all overlapping enemies, move to exit
				-- Parameters
					-- optional table of ENT_TYPE
					-- Mask (default to any mask of 0x4)
				-- Method moves all found entities to the exit door and returns a table of their uids
				-- append each table into a 2d array based on the room they occupied
			-- 3: ???
			-- 4: Generate rooms, log generated rooms
				-- Parameters
					-- optional table of ENT_TYPE
					-- Path
				-- For rooms you replace, keep in mind:
					-- Checks to make sure killing/moving certain floors won't lead to problems, such as shops
						-- IDEA: TOTEST: If flag for shop floor is checked, uncheck it.
					-- Establish a system of methods/parameters for removing certain elements from rooms.
						-- Some scenarios:
							-- get_entities_overlapping() on LIQUID_WATER or LIQUID_LAVA to remove it, otherwise there'd be consequences.
						-- pushblocks/powderkegs, crates/goldbars, encrusted gems/items/goldbits/cavemen(?)
						-- Theme specific entities:
							-- falling platforms
						-- S2 Level feeling-specific entities:
							-- Restless:
								-- remove fog effect, music(? is that possible?)
								-- replace FLOOR_TOMB with normal
								-- remove restless-specific enemies
							-- Dark level: remove torches on rooms you replace
								-- Once all rooms to be replaced are replaced, place torches in those rooms.
				-- Determine roomcodes to use with global list constant (same way as LEVEL_DANGERS[state.theme]) and the current room
					-- global_feelings[*] overrides some or all rooms
				-- append each table into a 2d array based on the room they occupied
				-- for each room, process HD_TILENAME, spawn_entity()
					-- if (tilename == 2 or tilename == j) and math.random() >= 0.5
						-- spawn_entity()
						-- if tilename == 2
							-- mark as 1
						-- if tilename == j
							-- mark as i
					-- else
						-- mark as 0
				-- return into `postgen_roomcodes`
			-- 5: Once `rooms_roomcodes_postgen` is finished, gets baked into a full array of the characters
				-- `postgen_levelcode`
			-- 6: Move enemies from exit to designated rooms/custom spawning system
				-- Parameters
					-- `postgen_levelcode`
			-- 7: Final touchups. This MAY include level background details, ambient sounds.				
				-- If dark level, place torches in rooms you replaced earlier
					-- Once all rooms to be replaced are replaced, place torches in those rooms.
		-- Certain room constants may need to be recognized and marked for replacement. This includes:
			-- Tun rooms
				-- Constraints are ENT_TYPE.MONS_MERCHANT in the front layer
			-- Tun rooms
				-- Constraints are ENT_TYPE.MONS_THEIF in the front layer
			-- Shops and vaults in HELL
		-- Make the outline of a vault room tilecode `2` (50% chance to remove each outlining block)
		-- pass in tiles as nil to ignore.
			-- initialize an empty table t of size n: setn(t, n)
		-- Black Market & Flooded Revamp:
			-- Replace S2 style black market with HD
				-- HD and S2 differences:
					-- S2 black market spawns are 2-2, 2-3, and 2-4
					-- HD spawns are 2-1, 2-2, and 2-3
						-- Prevents the black market from being accessed upon exiting the worm
						-- Gives room for the next level to load as black market
				-- script spawning LOGICAL_BLACKMARKET_DOOR
					-- if feeling_check("BLACKMARKET_ENTRANCE") == true
				-- In the roomcode generation, establish methods and parameters to make shop spawning possible
					-- Will need at least:
						-- 
				-- if detect_s2market() == true 
			-- Use S2 black market for flooded level feeling
				-- Set FLOODED: Detect when S2 black market spawns
					-- function onloading_setfeeling_load_flooded: roll HD_FEELING_FLOODED_CHANCE 4 times (or 3 if you're not going to try to extend the levels to allow S2 black market to spawn)
					-- for each roll: if true, return true
					-- if it returned true, set LOAD_FLOODED to true
						-- if detect_s2market() == true and LOAD_FLOODED == true, set HD_FEELING_FLOODED
			
	-- Roomcodes:
		-- Level Feelings:
			-- TIKI VILLAGE
				-- Notes:
					-- Tiki Village roomcodes never replace top (or bottom?) path
					-- Has no sideroom codes
					-- Unlockable coffin is always a path drop(?)
					-- Might(?) always generate with a zig-zag like path
				-- Roomcodes:
					-- 
			-- SNAKE PIT
				-- Notes:
					-- Doesn't have to link with main path
					-- I've seen it generate starting at the top level, idk about bottom
					-- Appears to occupy three side rooms vertically
				-- Ideas:
					-- Spawning conditions:
					-- If in dwelling and three side rooms vertically exist, have a random chance to replace them with snake pit.
				-- Roomcodes:
					--

-- bitwise notes:
-- print(3 & 5)  -- bitwise and
-- print(3 | 5)  -- bitwise or
-- print(3 ~ 5)  -- bitwise xor
-- print(7 >> 1) -- bitwise right shift
-- print(7 << 1) -- bitwise left shift
-- print(~7)     -- bitwise not

-- For mammoth behavior: If set, run it as a function: within the function, run a check on an array you pass in defining the `animation_frame`s you replace and the enemy you are having override its idle state.


-- TODO: Implement system that reviews savedata to unlock coffins.
-- Some cases should be as simple as "If it's not unlocked yet, set this coffin to this character."
-- Other cases... well... involve filtering through multiple coffins in the same area,
-- giving a random character unlock, and level feeling specific unlocks.
-- Some may need to be enabled as unlocked from the beginning!

-- Character list: SUBJECT TO CHANGE.
-- - Decide whether original colors should be preserved, should we want to include reskins;
-- - (HD Little Jay = mint green; S2 Little Jay = Lime)
-- - Could just wing it and decide on case-by-case, ie, Roffy D Sloth -> PacoEspelanko
-- - But that may not make everyone happy; we want the mod to appeal to widest audience
-- - Heck, maybe we don't reskin any of them and leave it up to the users.
-- - But that's the problem, what coffins do we replace then...
-- - Maybe we make two versions: One to preserve HD's unlocks by color, and one for character equivalents

-- https://spelunky.fandom.com/wiki/Spelunkers
-- https://spelunky.fandom.com/wiki/Spelunky_2_Characters
-- ###HD EQUIVALENTS###
-- Spelunky Guy: 	Available from the beginning.
-- Replacement:		ENT_TYPE.CHAR_GUY_SPELUNKY
-- Solution:		Enable from the start via savedata.

-- Colin Northward:	Available from the beginning.
-- Replacement:		ENT_TYPE.CHAR_COLIN_NORTHWARD
-- Solution:		Already enabled(?)

-- Alto Singh:		Available from the beginning.
-- Replacement:		ENT_TYPE.CHAR_BANDA
-- Solution:		Enable from the start via savedata.

-- Liz Mutton:		Available from the beginning.
-- Replacement:		ENT_TYPE.CHAR_GREEN_GIRL
-- Solution:		Enable from the start via savedata.

-- Tina Flan:		Random Coffin in one of the four areas, only one character can be found per area.
-- Replacement:		ENT_TYPE.CHAR_TINA_FLAN
-- Solution:		No modifications necessary.

-- Lime:			Random Coffin in one of the four areas, only one character can be found per area.
-- Replacement:		ENT_TYPE.ROFFY_D_SLOTH
-- Solution:		RESKIN -> PacoEspelanko. https://spelunky.fyi/mods/m/pacoespelanko/

-- Margaret Tunnel:	Random Coffin in one of the four areas, only one character can be found per area.
-- Replacement:		ENT_TYPE.CHAR_MARGARET_TUNNEL
-- Solution:		IF NEEDED, lock from the start in savedata.

-- Cyan:			Random Coffin in one of the four areas, only one character can be found per area.
-- Replacement:		ENT_TYPE.
-- Solution:		NO IDEA. https://spelunky.fyi/mods/m/cyan-from-hd/

-- Van Horsing:		Coffin at the top of the Haunted Castle level.
-- Replacement:		ENT_TYPE.
-- Solution:		NO IDEA. https://spelunky.fyi/mods/m/van-horsing-sprite-sheet-all-animations/

-- Jungle Warrior:	Defeat Olmec and get to the exit.
-- Replacement:		ENT_TYPE.CHAR_AMAZON
-- Solution:		No modifications necessary.

-- Meat Boy:		Dark green pod near the end of the Worm.
-- Replacement:		ENT_TYPE.CHAR_PILOT
-- Solution:		RESKIN -> Meat Boy. https://spelunky.fyi/mods/m/meat-boy-with-bandage-rope/

-- Yang:			Defeat King Yama and get to the exit.
-- Replacement:		ENT_TYPE.CHAR_CLASSIC_GUY
-- Solution:		RESKIN(?)

-- The Inuk:		Found inside a coffin in a Yeti Kingdom level.
-- Replacement:		ENT_TYPE.
-- Solution:		NO IDEA.

-- The Round Girl:	Found inside a coffin in a Spider's Lair level.
-- Replacement:		ENT_TYPE.CHAR_VALERIE_CRUMP
-- Solution:		No modifications necessary.

-- Ninja:			Found inside a coffin in Olmec's Chamber.
-- Replacement:		ENT_TYPE.CHAR_DIRK_YAMAOKA
-- Solution:		No modifications necessary.

-- The Round Boy:	Found inside a coffin in a Tiki Village in the Jungle.
-- Replacement:		ENT_TYPE.OTAKU
-- Solution:		No modifications necessary.

-- Cyclops:			Can be bought from the Black Market for $10,000, or simply 'kidnapped'. May also be found in a coffin after seeing him in the Black Market.
-- Replacement:		ENT_TYPE.
-- Solution:		NO IDEA. S2 has a coffin in the black market.

-- Viking:			Found inside a coffin in a Flooded Cavern or "The Dead Are Restless" level.
-- Replacement:		ENT_TYPE.
-- Solution:		NO IDEA

-- Robot:			Found inside a capsule in the Mothership.
-- Replacement:		ENT_TYPE.CHAR_LISE_SYSTEM
-- Solution:		No modifications necessary.

-- Golden Monk:		Found inside a coffin in the City of Gold.
-- Replacement:		ENT_TYPE.CHAR_AU
-- Solution:		Literally no modifications necessary, maybe not even scripting anything.

-- ###UNDETERMINED###

-- Ana Spelunky:	ENT_TYPE.CHAR_ANA_SPELUNKY
-- Solution:		IF NEEDED, lock from the start in savedata.

-- Princess Airyn:	ENT_TYPE.CHAR_PRINCESS_AIRYN
-- Solution:		NO IDEA

-- Manfred Tunnel:	ENT_TYPE.CHAR_MANFRED_TUNNEL
-- Solution:		NO IDEA

-- Coco Von Diamonds:	ENT_TYPE.CHAR_COCO_VON_DIAMONDS
-- Solution:		NO IDEA

-- Demi Von Diamonds:	ENT_TYPE.CHAR_DEMI_VON_DIAMONDS
-- Solution:		

-- WORM UNLOCK
-- coffin_e = get_entity(create_unlockcoffin(x, y, l))
-- coffin_e.flags = set_flag(coffin_e.flags, 10)
-- coffin_m = coffin_e:as_movable()
-- -- coffin_m.animation_frame = 0
-- coffin_m.velocityx = 0
-- coffin_m.velocityy = 0

-- IDEA: Black Market unlock
-- if character hasn't been unlocked yet:
	-- if `blackmarket_char_witnessed` == false:
		--`blackmarket_char_witnessed` = true
		-- Have him up for sale in the black market
			-- if purchased or shopkeeprs agrod:
				-- unlock character
	-- if `blackmarket_char_witnessed` == true:
		-- found in coffin elsewhere (where?)