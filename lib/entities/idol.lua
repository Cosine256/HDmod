local module = {}

local IDOLTRAP_TRIGGER = false
local IDOL_X = nil
local IDOL_Y = nil
local IDOL_UID = nil
module.IDOL_OWNER = nil

local IDOLTRAP_JUNGLE_ACTIVATETIME = 10
local idoltrap_timeout = 0
local idoltrap_blocks = {}
local sliding_wall_ceilings = {}

local skull_texture_id
local floor_texture_id
local ceiling_spikes_texture_id
local ceiling_stone_texture_id
local ceiling_spikes_stone_texture_id

do
    local ceiling_stone_texture_def = TextureDefinition.new()
    ceiling_stone_texture_def.width = 128
    ceiling_stone_texture_def.height = 128
    ceiling_stone_texture_def.tile_width = 128
    ceiling_stone_texture_def.tile_height = 128
    ceiling_stone_texture_def.texture_path = "res/pushblock_temple_stone.png"
    ceiling_stone_texture_id = define_texture(ceiling_stone_texture_def)

    local floor_texture_def = TextureDefinition.new()
    floor_texture_def.width = 128
    floor_texture_def.height = 128
    floor_texture_def.tile_width = 128
    floor_texture_def.tile_height = 128
    floor_texture_def.texture_path = "res/idoltrap_floor.png"
    floor_texture_id = define_texture(floor_texture_def)

    local ceiling_spikes_texture_def = TextureDefinition.new()
    ceiling_spikes_texture_def.width = 128
    ceiling_spikes_texture_def.height = 128
    ceiling_spikes_texture_def.tile_width = 128
    ceiling_spikes_texture_def.tile_height = 128
    ceiling_spikes_texture_def.texture_path = "res/idoltrap_ceiling_spikes.png"
    ceiling_spikes_texture_id = define_texture(ceiling_spikes_texture_def)

    local ceiling_spikes_stone_texture_def = TextureDefinition.new()
    ceiling_spikes_stone_texture_def.width = 128
    ceiling_spikes_stone_texture_def.height = 128
    ceiling_spikes_stone_texture_def.tile_width = 128
    ceiling_spikes_stone_texture_def.tile_height = 128
    ceiling_spikes_stone_texture_def.texture_path = "res/idoltrap_ceiling_spikes_stone.png"
    ceiling_spikes_stone_texture_id = define_texture(ceiling_spikes_stone_texture_def)

    local skull_texture_def = TextureDefinition.new()
    skull_texture_def.width = 128
    skull_texture_def.height = 128
    skull_texture_def.tile_width = 128
    skull_texture_def.tile_height = 128
    skull_texture_def.texture_path = "res/crystal_skull.png"
    skull_texture_id = define_texture(skull_texture_def)
end

function module.init()
	IDOLTRAP_TRIGGER = false
	IDOL_X = nil
	IDOL_Y = nil
	IDOL_UID = -1
    module.IDOL_OWNER = -1

	idoltrap_timeout = IDOLTRAP_JUNGLE_ACTIVATETIME
	idoltrap_blocks = {}
    sliding_wall_ceilings = {}
end

function module.create_idol(x, y, l)
	IDOL_X, IDOL_Y = x, y
	IDOL_UID = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_IDOL, IDOL_X, IDOL_Y, l)
	if state.theme == THEME.ICE_CAVES then
		-- .trap_triggered: "if you set it to true for the ice caves or volcano idol, the trap won't trigger"
		get_entity(IDOL_UID).trap_triggered = true
	end
end

function module.create_crystalskull(x, y, l)
	IDOL_X, IDOL_Y = x, y
	IDOL_UID = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_MADAMETUSK_IDOL, IDOL_X, IDOL_Y, l)
    get_entity(IDOL_UID):set_texture(skull_texture_id)
end

local function idol_disturbance()
	if IDOL_UID ~= -1 then
		local x, y, _ = get_position(IDOL_UID)
        ---@type Idol
		local _entity = get_entity(IDOL_UID)
        if not _entity then return true end
		return (x ~= _entity.spawn_x or y ~= _entity.spawn_y)
	end
end

function module.create_idoltrap_floor(x, y, l)
    local block_uid = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, l, 0, 0)
    local block = get_entity(block_uid)
    block.flags = set_flag(block.flags, ENT_FLAG.NO_GRAVITY)
    block.more_flags = set_flag(block.more_flags, 17)

    get_entity(block_uid):set_texture(floor_texture_id)

    idoltrap_blocks[#idoltrap_blocks+1] = block_uid
end

function module.create_idoltrap_ceiling(x, y, l)
    local block_uid = spawn_grid_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, l)
    local block = get_entity(block_uid)
    if options.hd_og_floorstyle_temple then block:set_texture(ceiling_stone_texture_id) end
    block.flags = set_flag(block.flags, ENT_FLAG.NO_GRAVITY)
    block.more_flags = set_flag(block.more_flags, 17)
    idoltrap_blocks[#idoltrap_blocks+1] = block_uid
end

function module.add_sliding_wall_ceiling(uid)
    sliding_wall_ceilings[#sliding_wall_ceilings+1] = uid
end

local function create_ghost_at_border()
	local xmin, _, xmax, _ = get_bounds()
	-- message("xmin: " .. xmin .. " ymin: " .. ymin .. " xmax: " .. xmax .. " ymax: " .. ymax)
	
	if #players > 0 then
		local p_x, p_y, p_l = get_position(players[1].uid)
		local bx_mid = (xmax - xmin)/2
		local gx = 0
		local gy = p_y
		if p_x > bx_mid then gx = xmax+5 else gx = xmin-5 end
		spawn(ENT_TYPE.MONS_GHOST, gx, gy, p_l, 0, 0)
        if get_setting(GAME_SETTING.GHOST_TEXT) == 1 then
            toast_override("A terrible chill runs up your spine!")
        end
	-- else
		-- toast("A terrible chill r- ...wait, where are the players?!?")
	end
end

---@param block_id integer
local function break_idoltrap_floor(block_id)
    ---@type Movable
    local entity = get_entity(idoltrap_blocks[block_id])
    if entity then
        local x, y, l = get_position(entity.uid)
        kill_entity(entity.uid)
        for _ = 1, 5, 1 do
            local rubble = get_entity(spawn_entity(ENT_TYPE.ITEM_RUBBLE,
                x+prng:random_int(-15, 15, PRNG_CLASS.PARTICLES)/10, (y-0.2)+prng:random_int(-7, 7, PRNG_CLASS.PARTICLES)/10, l,
                prng:random_int(-10, 10, PRNG_CLASS.PARTICLES)/100, 0.11+prng:random_int(0, 3, PRNG_CLASS.PARTICLES)/10))
            rubble.animation_frame = 3
        end
        commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE, entity.uid, 0.55, false)
    end
end

--- Code provided by Dregu
---@param block_id integer
local function activate_idoltrap_ceiling(block_id)
    local floor = get_entity(idoltrap_blocks[block_id])
    if floor then
        commonlib.play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE, floor.uid, 0.35, false)

        local x, y, l = get_position(floor.uid)
        kill_entity(floor.uid)
        for _ = 1, 5, 1 do
            local rubble = get_entity(spawn_entity(ENT_TYPE.ITEM_RUBBLE,
                x+prng:random_int(-15, 15, PRNG_CLASS.PARTICLES)/10, (y-0.2)+prng:random_int(-7, 7, PRNG_CLASS.PARTICLES)/10, l,
                prng:random_int(-10, 10, PRNG_CLASS.PARTICLES)/100, 0.11+prng:random_int(0, 3, PRNG_CLASS.PARTICLES)/10))
            rubble.animation_frame = options.hd_og_floorstyle_temple and 3 or 32
        end
        local block = get_entity(spawn_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, l, 0, 0))
        block.flags = set_flag(block.flags, ENT_FLAG.NO_GRAVITY)
        block.more_flags = set_flag(block.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
        block.velocityy = -0.035

        block:set_texture(options.hd_og_floorstyle_temple and ceiling_spikes_stone_texture_id or ceiling_spikes_texture_id)
    end
end

-- Idol trap activation
set_callback(function()
    if IDOLTRAP_TRIGGER == false and IDOL_UID ~= -1 and idol_disturbance() then
        IDOLTRAP_TRIGGER = true
        if feelingslib.feeling_check(feelingslib.FEELING_ID.RESTLESS) == true then
            create_ghost_at_border()
        elseif state.theme == THEME.DWELLING and IDOL_X ~= nil and IDOL_Y ~= nil then
            spawn(ENT_TYPE.LOGICAL_BOULDERSPAWNER, IDOL_X, IDOL_Y, LAYER.FRONT, 0, 0)
        elseif state.theme == THEME.JUNGLE then
            -- Break the 6 blocks under it in a row, starting with the outside 2 going in
            if #idoltrap_blocks > 0 then
                commonlib.shake_camera(20, 60, 2, 2, 3, false)
                break_idoltrap_floor(1)
                break_idoltrap_floor(6)
                set_timeout(function()
                    break_idoltrap_floor(2)
                    break_idoltrap_floor(5)
                end, idoltrap_timeout)
                set_timeout(function()
                    break_idoltrap_floor(3)
                    break_idoltrap_floor(4)
                end, idoltrap_timeout*2)
            end
        elseif state.theme == THEME.TEMPLE then
            if feelingslib.feeling_check(feelingslib.FEELING_ID.SACRIFICIALPIT) == true then -- Kali pit temple trap
                -- Break all 4 blocks under it at once
                for i = 1, #idoltrap_blocks, 1 do
                    kill_entity(idoltrap_blocks[i])
                end
            else -- Normal temple trap
                -- sliding doors
                for _, sliding_wall_ceiling in ipairs(sliding_wall_ceilings) do
                    local ent = get_entity(sliding_wall_ceiling)
                    if (ent) then ent.state = 0 end
                end

                set_timeout(function()
                    commonlib.shake_camera(20, 200, 2, 2, 3, false)
                    for i = 1, #idoltrap_blocks, 1 do
                        activate_idoltrap_ceiling(i)
                    end
                end, 30)
            end
        end
    elseif IDOLTRAP_TRIGGER == true and IDOL_UID ~= -1 and module.IDOL_OWNER == -1 and state.theme == THEME.DWELLING then
        module.IDOL_OWNER = get_entity(IDOL_UID).last_owner_uid
        if options.hd_debug_boulder_info == true then
            message(string.format("SET IDOL OWNER %s", module.IDOL_OWNER))
        end
    end
end, ON.FRAME)

return module