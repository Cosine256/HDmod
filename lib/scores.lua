local surfacelib = require('lib.surface')
local endingtreasurelib = require('lib.entities.endingtreasure')

local volcano_texture_id
local volcano_hard_texture_id
local sky_hard_texture_id
do
    local volcano_texture_def = TextureDefinition.new()
    volcano_texture_def.width = 1024
    volcano_texture_def.height = 1024
    volcano_texture_def.tile_width = 1024
    volcano_texture_def.tile_height = 512
    volcano_texture_def.texture_path = "res/volcano.png"
    volcano_texture_id = define_texture(volcano_texture_def)

    local volcano_hard_texture_def = TextureDefinition.new()
    volcano_hard_texture_def.width = 1024
    volcano_hard_texture_def.height = 1024
    volcano_hard_texture_def.tile_width = 1024
    volcano_hard_texture_def.tile_height = 512
    volcano_hard_texture_def.sub_image_width = 1024
    volcano_hard_texture_def.sub_image_height = 512
    volcano_hard_texture_def.sub_image_offset_x = 0
    volcano_hard_texture_def.sub_image_offset_y = 512
    volcano_hard_texture_def.texture_path = "res/volcano.png"
    volcano_hard_texture_id = define_texture(volcano_hard_texture_def)

    local sky_hard_texture_def = TextureDefinition.new()
    sky_hard_texture_def.width = 512
    sky_hard_texture_def.height = 512
    sky_hard_texture_def.tile_width = 512
    sky_hard_texture_def.tile_height = 512
    sky_hard_texture_def.texture_path = "res/base_sky_hardending.png"
    sky_hard_texture_id = define_texture(sky_hard_texture_def)
end

local VOLCANO_DISAPEAR_TIME = 7
local VOLCANO_DISAPEAR = false

local black = Color:black()

local character_fall_timer = -500
-- local idol_fall_timer = 0
-- local yang_fall_timer = 0

local falling_player_texture_id

set_post_render_screen(SCREEN.SCORES, function (screen, ctx)
    if not VOLCANO_DISAPEAR then
        local hard = state.win_state == WIN_STATE.HUNDUN_WIN

        ---@type ScreenScores
        local screen_ent = screen:as_screen_scores()

        ctx:draw_screen_texture(hard and sky_hard_texture_id or TEXTURE.DATA_TEXTURES_BASE_SKYNIGHT_0, 0, 0, AABB:new(-1, 1, 1, -1), Color:white())
        ctx:draw_screen_texture(hard and volcano_hard_texture_id or volcano_texture_id, 0, 0, AABB:new(-0.65, 0.65, 1, -1), Color:white())
            
        if character_fall_timer > 0 then
            local x = character_fall_timer/100
            local y = (-0.3*(x+1)^2) + 1
            ctx:draw_screen_texture(falling_player_texture_id, 0, 0, AABB:new(-1, 1, 1, -1), Color:white())
        end

        character_fall_timer = character_fall_timer + 1
        -- idol_fall_timer = idol_fall_timer + 1
        -- yang_fall_timer = yang_fall_timer + 1

        if screen_ent.render_timer >= VOLCANO_DISAPEAR_TIME then
            VOLCANO_DISAPEAR = true
        end
    end
end)

set_callback(function ()
    surfacelib.decorate_existing_surface()

	state.camera.bounds_top = 109.6640
	state.camera.adjusted_focus_x = 17.00
	state.camera.adjusted_focus_y = 100.050

    -- hold characters in the air until the volcano screen ends
    local holding_floor = get_entity(spawn_grid_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, 17, 119, LAYER.FRONT))
    holding_floor.flags = set_flag(holding_floor.flags, ENT_FLAG.NO_GRAVITY)
    holding_floor.more_flags = set_flag(holding_floor.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
    holding_floor:set_post_update_state_machine(
    ---@param self Floor
    function (self)
        if VOLCANO_DISAPEAR then
            -- self.flags = clr_flag(self.flags, ENT_FLAG.SOLID)
            self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
            clear_callback()
        end
    end)

    -- prevent pets from making noise during the volcano cutscene
    for _, pet_uid in ipairs(get_entities_by_type({ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_HAMSTER})) do
        ---@type Pet
        local pet = get_entity(pet_uid)
        local original_counter = pet.yell_counter
        pet:set_post_update_state_machine(
        ---@param self Pet
        function (self)
            if not VOLCANO_DISAPEAR then
                self.yell_counter = 10
            else
                self.yell_counter = original_counter
                clear_callback()
            end
        end)
    end

    -- create a cropped player texture for the volcano scene
    local falling_player_texture_def = get_texture_definition(players[1]:get_texture())
    falling_player_texture_def.sub_image_height = 128
    falling_player_texture_def.sub_image_width = 128
    falling_player_texture_def.sub_image_offset_x = 512
    falling_player_texture_def.sub_image_offset_y = 1408
    falling_player_texture_id = define_texture(falling_player_texture_def)
end, ON.SCORES)


set_post_entity_spawn(function (entity)
	if state.screen == SCREEN.SCORES then
        endingtreasurelib.set_ending_treasure(entity)
    end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN)
