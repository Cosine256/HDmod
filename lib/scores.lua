local surfacelib = require('lib.surface')
local camellib = require('lib.entities.camel')
local endingtreasurelib = require('lib.entities.endingtreasure')
local decorlib = require('lib.gen.decor')
local animationlib = require('lib.entities.animation')
local introanimationslib = require('lib.introanimations')
local commonlib = require('lib.common')

local CHARACTER_ANIMATIONS = {
    FALL = {185, 184, 183, 182, 181, 180, loop = true, frames = 6, frame_time = 4}
}

local PARTICLE_ANIMATIONS = {
    FLAME1 = {51, 52, 53, loop = true, frames = 3, frame_time = 4}
}

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

local VOLCANO_DISAPPEAR_TIME = 7
local VOLCANO_DISAPPEAR

set_post_render_screen(SCREEN.SCORES, function (screen, ctx)
    if not VOLCANO_DISAPPEAR then
        ---@type ScreenScores
        local screen_ent = screen:as_screen_scores()
        if screen_ent.render_timer >= VOLCANO_DISAPPEAR_TIME then
            VOLCANO_DISAPPEAR = true
        end
    end
end)

set_callback(function (ctx, draw_depth)
    if state.screen == SCREEN.SCORES
    and not VOLCANO_DISAPPEAR then
        local hard = state.win_state == WIN_STATE.HUNDUN_WIN

        if draw_depth == decorlib.CREDITS_VOLCANO_DEPTH.SKY then
            ctx:draw_world_texture(hard and sky_hard_texture_id or TEXTURE.DATA_TEXTURES_BASE_SKYNIGHT_0, 0, 0, Quad:new(AABB:new(9.24, 110.09, 30.60, 98.08)), Color:white(), WORLD_SHADER.TEXTURE_COLOR)
        end
        if draw_depth == decorlib.CREDITS_VOLCANO_DEPTH.VOLCANO then
            ctx:draw_world_texture(hard and volcano_hard_texture_id or volcano_texture_id, 0, 0, Quad:new(AABB:new(10.24, 107.09, 31.60, 98.08)), Color:white(), WORLD_SHADER.TEXTURE_COLOR)
        end
    end
end, ON.RENDER_PRE_DRAW_DEPTH)

--smoke particles
-- rock, gradually move up, growing in size, rotating
-- TEXTURE.DATA_TEXTURES_SHADOWS_0
-- animation_frame = 3
-- width, height = 3.5, 3.5
local function create_smoke_particle(x, y, animation_frame, rotation)
    ---@type Movable | Entity
    local entity = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, x, y, LAYER.FRONT, 0.0265, 0.0125))
    entity.flags = set_flag(entity.flags, ENT_FLAG.NO_GRAVITY)
    entity.flags = set_flag(entity.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    entity:set_texture(TEXTURE.DATA_TEXTURES_SHADOWS_0)
    entity.animation_frame = animation_frame
    entity.width, entity.height = 3, 3
    entity:set_draw_depth(decorlib.CREDITS_VOLCANO_DEPTH.PARTICLES)
    entity.angle = rotation
    local alpha_timeout = 10
    entity:set_post_update_state_machine(function (self)
        self.width, self.height = self.width*1.005, self.height*1.005
        self.angle = self.angle + 0.015
        if alpha_timeout < 90 then
            self.color = Color:new(1, 1, 1, alpha_timeout/100)
            alpha_timeout = alpha_timeout + 1
        end
        if VOLCANO_DISAPPEAR
        or self.y > 120 then
            self:destroy()
        end
    end)
end

local function create_lava_particle(x, y, animation_frame, size, vx, vy, spin_rate, texture_id, animation)
    local entity = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, x, y, LAYER.FRONT, vx, vy))
    entity:set_draw_depth(decorlib.CREDITS_VOLCANO_DEPTH.PARTICLES)
    entity:set_texture(texture_id)
    entity.animation_frame = animation_frame
    if animation then
        entity.user_data = {
            animation_timer = 0,
        }
        animationlib.set_animation(entity.user_data, animation)
    end
    entity.flags = set_flag(entity.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    entity:set_gravity(0.5)
    entity.width, entity.height = entity.width*size, entity.height*size
    entity:set_post_update_state_machine(function (self)
        self.width, self.height = self.width*0.95, self.height*0.95
        self.angle = self.angle + spin_rate
        if animation then
            self.animation_frame = animationlib.get_animation_frame(self.user_data)
            animationlib.update_timer(self.user_data)
        end
        if VOLCANO_DISAPPEAR
        or self.height < 0.05 then
            self:destroy()
        end
    end)
end

local function create_volcano_effects()
    local entity = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, 25.02, 106.06, LAYER.FRONT, 0, 0))
    entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
    entity.flags = set_flag(entity.flags, ENT_FLAG.NO_GRAVITY)
    commonlib.shake_camera(180, 480, 0.5, 1.5, 1.5, false)

    ---@type CustomSound_play
    local rumble_sound = commonlib.play_vanilla_sound(VANILLA_SOUND.CUTSCENE_RUMBLE_LOOP, entity.uid, 0.25, true)
    local timeout = 160
    local lava_timeout = 0
    local smoke_timeout = 0

    local wind_sound = get_sound(VANILLA_SOUND.CUTSCENE_EGGSHIP_AMB_LOOP):play()

    set_callback(function()
        if wind_sound then
            wind_sound:stop()
        end
        clear_callback()
    end, ON.RECAP)

    entity:set_post_update_state_machine(function (self)
        if timeout == 0 then -- erupt
            commonlib.play_vanilla_sound(VANILLA_SOUND.SHARED_EXPLOSION, self.uid, 0.003, false)
            -- local lava_sound = commonlib.play_vanilla_sound(VANILLA_SOUND.LIQUIDS_LAVA_STREAM_LOOP, entity.uid, 0.4, true)
            state.camera.shake_amplitude = 3
            state.camera.shake_multiplier_x = 3
            state.camera.shake_multiplier_y = 3
        elseif timeout == -70 then
            state.camera.shake_amplitude = 2
            state.camera.shake_multiplier_x = 2
            state.camera.shake_multiplier_y = 2
        elseif VOLCANO_DISAPPEAR then
            -- make camera shake less when switching away from volcano scene
            -- this is actually very annoying, but still leaving it here uncommented.
            -- commonlib.shake_camera(230, 230, 1, 1, 1, false)
            if rumble_sound ~= nil then
                rumble_sound:stop()
            end
        end

        if not VOLCANO_DISAPPEAR then
            if lava_timeout <= 0 then
                local y = entity.y + prng:random_float(PRNG_CLASS.PARTICLES)*1.5
                local x = entity.x + prng:random_float(PRNG_CLASS.PARTICLES)*2.5
                create_lava_particle(x, y, 51,
                    prng:random_float(PRNG_CLASS.PARTICLES)*1.2,
                    prng:random_float(PRNG_CLASS.PARTICLES)*0.2-0.1,
                    prng:random_float(PRNG_CLASS.PARTICLES)*0.1+0.1,
                    0.01,
                    TEXTURE.DATA_TEXTURES_FX_SMALL3_0,
                    PARTICLE_ANIMATIONS.FLAME1
                )
                lava_timeout = prng:random_int(3, 7, PRNG_CLASS.PARTICLES)
            else
                lava_timeout = lava_timeout - 1
            end
            if smoke_timeout <= 0 then
                create_smoke_particle(entity.x, entity.y+1, 3, 0.05)
                smoke_timeout = prng:random_int(30, 40, PRNG_CLASS.PARTICLES)
            else
                smoke_timeout = smoke_timeout - 1
            end
        end

        timeout = timeout - 1
    end)
end

local function create_flung_entity(texture_id, animation_frame, timeout, size, animation)
    local entity = get_entity(spawn_entity(ENT_TYPE.ITEM_ROCK, 25.62, 106.35, LAYER.FRONT, 0, 0))
    entity:set_draw_depth(decorlib.CREDITS_VOLCANO_DEPTH.FLUNG_ENTS)
    entity:set_texture(texture_id)
    entity.animation_frame = animation_frame
    entity.flags = set_flag(entity.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
    entity.flags = set_flag(entity.flags, ENT_FLAG.NO_GRAVITY)
    entity.flags = set_flag(entity.flags, ENT_FLAG.FACING_LEFT)
    local gravity = 0.15
    entity:set_gravity(gravity)
    entity.width, entity.height = entity.width*size, entity.height*size
    if animation then
        entity.user_data = {
            animation_timer = 0,
        }
        animationlib.set_animation(entity.user_data, animation)
    end
    local flung = false
    entity:set_post_update_state_machine(function (self)
        if timeout > 0 then
            timeout = timeout - 1
        elseif not flung then
            self.flags = clr_flag(self.flags, ENT_FLAG.INVISIBLE)
            self.flags = clr_flag(self.flags, ENT_FLAG.NO_GRAVITY)
            self.velocityx = -0.033
            self.velocityy = 0.055
            flung = true
            
            for i = 1, 10 do
                local y = entity.y-- + prng:random_float(PRNG_CLASS.PARTICLES)*1.5
                local x = entity.x-- + prng:random_float(PRNG_CLASS.PARTICLES)*2.5
                create_lava_particle(x, y, 51,
                    prng:random_float(PRNG_CLASS.PARTICLES)*0.75,
                    prng:random_float(PRNG_CLASS.PARTICLES)*0.2-0.1,
                    prng:random_float(PRNG_CLASS.PARTICLES)*0.1+0.1,
                    0.01,
                    TEXTURE.DATA_TEXTURES_FX_SMALL3_0,
                    PARTICLE_ANIMATIONS.FLAME1
                )
            end
        else
            self.width, self.height = self.width*1.006, self.height*1.006
            self.angle = self.angle + 0.2
            gravity = gravity*1.006
            self:set_gravity(gravity)
        end
        if animation then
            self.animation_frame = animationlib.get_animation_frame(self.user_data)
            animationlib.update_timer(self.user_data)
        end
    end)
end

set_callback(function ()
    surfacelib.decorate_existing_surface()

	state.camera.bounds_top = 109.6640
	-- state.camera.adjusted_focus_x = 17.00
	-- state.camera.adjusted_focus_y = 100.050
    state.camera.adjusted_focus_x = 19.926
    state.camera.adjusted_focus_y = 104.091
    state.camera.focused_entity_uid = players[1].uid

    VOLCANO_DISAPPEAR = false

    -- hold characters in the air until the volcano screen ends
    local holding_floor = get_entity(spawn_grid_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, 17, 119, LAYER.FRONT))
    holding_floor.flags = set_flag(holding_floor.flags, ENT_FLAG.NO_GRAVITY)
    holding_floor.more_flags = set_flag(holding_floor.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)
    holding_floor:set_post_update_state_machine(
    ---@param self Floor
    function (self)
        if VOLCANO_DISAPPEAR then
            -- self.flags = clr_flag(self.flags, ENT_FLAG.SOLID)
            self.flags = set_flag(self.flags, ENT_FLAG.PASSES_THROUGH_OBJECTS)
            clear_callback()
        end
    end)

    local camel = get_entity(camellib.create_camel(25, 100, LAYER.FRONT))
    spawn_entity_over(ENT_TYPE.FX_EGGSHIP_SHADOW, camel.uid, 0, 0)
    flip_entity(camel.uid)
    camel.user_data.state = introanimationslib.INTRO_STATE.IDLE_CROUCH
    camel:set_post_update_state_machine(function (self)
        if VOLCANO_DISAPPEAR then
            self.user_data.state = introanimationslib.INTRO_STATE.IDLE_CROUCH_NOISES
            self.user_data.timeout = 100
            clear_callback()
        end
    end)

    create_flung_entity(players[1]:get_texture(), 0, 160, 0.15, CHARACTER_ANIMATIONS.FALL)
    create_flung_entity(TEXTURE.DATA_TEXTURES_ITEMS_0, 31, 180, 0.2)
    create_volcano_effects()
end, ON.SCORES)

-- remove pets and NPCs

set_post_entity_spawn(function(ent)
    if state.screen == SCREEN.SCORES then
        -- message(string.format("character: %s", ent.uid))
        -- if state.win_state == WIN_STATE.HUNDUN_WIN and ent.y > 110 then
        --     return false
        -- end
        ent:destroy()
    end
end, SPAWN_TYPE.SYSTEMIC, MASK.PLAYER)

set_post_entity_spawn(function(ent)
    if state.screen == SCREEN.SCORES then
        ent:destroy()
    end
end, SPAWN_TYPE.SYSTEMIC, MASK.MONSTER, ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_HAMSTER)


set_post_entity_spawn(function (entity)
	if state.screen == SCREEN.SCORES then
        endingtreasurelib.set_ending_treasure(entity)
    end
end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_ENDINGTREASURE_TIAMAT, ENT_TYPE.ITEM_ENDINGTREASURE_HUNDUN)
