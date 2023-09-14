local module = {}

local surfacelayerlib = require('lib.entities.surface_layer')
local palmtreelib = require('lib.entities.palmtree')
local decorlib = require('lib.gen.decor')

local sky_hard_texture_id
do
    local sky_hard_texture_def = TextureDefinition.new()
    sky_hard_texture_def.width = 512
    sky_hard_texture_def.height = 512
    sky_hard_texture_def.tile_width = 512
    sky_hard_texture_def.tile_height = 512
    sky_hard_texture_def.texture_path = "res/base_sky_hardending.png"
    sky_hard_texture_id = define_texture(sky_hard_texture_def)
end

function module.build_credits_surface()
    for x = -3, 45, 1 do
        spawn_grid_entity(ENT_TYPE.FLOOR_SURFACE_HIDDEN, x, 110, LAYER.FRONT)
    end

    local sky = get_entity(spawn_entity(ENT_TYPE.BG_SPACE, 27.5, 123.50, LAYER.FRONT, 0, 0))-- intro's is high enough to see the white part
    local sun = get_entity(spawn_entity(ENT_TYPE.BG_SURFACE_NEBULA, 14, 115, LAYER.FRONT, 0, 0))
    sun.width = 9
    sun.height = 4.5
    sun.relative_x, sun.relative_y = 0, 0
    sun:set_post_update_state_machine(
        ---@param self Movable | Entity | Player
        function (self)
            if self.relative_x ~= 0 or self.relative_y ~= 0 then
                self.relative_x, self.relative_y = 0, 0
            end
            -- # TOFIX: setting self.y or self.relative_y here for some reason doesn't work. Find a way to set to 117 in the future.
        end
    )

    local depth
    local bg

    --foreground
    depth = decorlib.SURFACE_BG_DEPTH.FOREGROUND
    bg = surfacelayerlib.create_surface_layer_looping(110.5, depth, false, 0)
    -- -26..26, -0.2..1.2
    surfacelayerlib.create_surface_layer_foreground_relative(-26, 0.2, 1, bg)
    palmtreelib.create_palmtree_relative(-22, -1.0, 1, depth, bg, true)
    surfacelayerlib.create_surface_layer_foreground_relative(-18, 0.5, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(-10, 0, 0, bg)
    palmtreelib.create_palmtree_relative(-8, 1.0, 2, depth, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(-5, -0.2, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(0, 1, 1, bg)
    palmtreelib.create_palmtree_relative(3, 0, 0, depth, bg, true)
    surfacelayerlib.create_surface_layer_foreground_relative(5, 0, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(10, 0.4, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(18, 1, 0, bg)
    palmtreelib.create_palmtree_relative(20, -1.3, 1, depth, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(26, 0, 1, bg)

    bg = surfacelayerlib.create_surface_layer_looping(110.5, depth, true, 0)
    surfacelayerlib.create_surface_layer_foreground_relative(-26, 0, 1, bg)
    palmtreelib.create_palmtree_relative(-20, 1.3, 2, depth, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(-18, 0, 0, bg)
    palmtreelib.create_palmtree_relative(-14, -0.4, 2, depth, bg, true)
    surfacelayerlib.create_surface_layer_foreground_relative(-10, 0.4, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(-5, 0, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(0, 1.2, 0, bg)
    palmtreelib.create_palmtree_relative(2, -0.4, 0, depth, bg, true)
    surfacelayerlib.create_surface_layer_foreground_relative(5, 0, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(10, -.2, 0, bg)
    palmtreelib.create_palmtree_relative(12, -0.4, 0, depth, bg)
    palmtreelib.create_palmtree_relative(14, 1.2, 1, depth, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(18, 1, 1, bg)
    surfacelayerlib.create_surface_layer_foreground_relative(26, 0.8, 1, bg)


    --background
    depth = decorlib.SURFACE_BG_DEPTH.BACKGROUND
    bg = surfacelayerlib.create_surface_layer_looping(111.15, depth, false)
    -- -26..26, 3..3.55
    palmtreelib.create_palmtree_relative(-20, 3, 2, depth, bg, true)
    palmtreelib.create_palmtree_relative(-12, 3.4, 0, depth, bg)
    palmtreelib.create_palmtree_relative(6, 3.4, 1, depth, bg, true)
    palmtreelib.create_palmtree_relative(10, 3, 2, depth, bg)
    palmtreelib.create_palmtree_relative(20, 3, 1, depth, bg, true)
    palmtreelib.create_palmtree_relative(24, 3.3, 1, depth, bg)

    bg = surfacelayerlib.create_surface_layer_looping(111.15, depth, true)


    --mid background
    depth = decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND
    bg = surfacelayerlib.create_surface_layer_looping(112.6, depth, false)
    -- -28..28, 0.5..1.6
    -- palmtreelib.create_palmtree_relative(-30, 3, 2, depth, bg)
    palmtreelib.create_palmtree_relative(-27, 0.8, 2, depth, bg, true)
    palmtreelib.create_palmtree_relative(-20, 1.6, 2, depth, bg)
    palmtreelib.create_palmtree_relative(-7, 1.6, 0, depth, bg)
    palmtreelib.create_palmtree_relative(-8, 1.6, 1, depth, bg)
    palmtreelib.create_palmtree_relative(-1, 0.6, 0, depth, bg)
    palmtreelib.create_palmtree_relative(3, 0.8, 0, depth, bg)
    palmtreelib.create_palmtree_relative(10, 0.8, 1, depth, bg, true)
    palmtreelib.create_palmtree_relative(17, 1.0, 0, depth, bg)
    palmtreelib.create_palmtree_relative(22, 0.8, 2, depth, bg, true)
    palmtreelib.create_palmtree_relative(28, 1.2, 0, depth, bg, true)
    -- palmtreelib.create_palmtree_relative(30, 3, 2, depth, bg)

    bg = surfacelayerlib.create_surface_layer_looping(112.6, depth, true)
    -- palmtreelib.create_palmtree_relative(-30, 3, 2, depth, bg)
    palmtreelib.create_palmtree_relative(-25, 0.6, 1, depth, bg, true)
    palmtreelib.create_palmtree_relative(-20, 1.0, 0, depth, bg)
    palmtreelib.create_palmtree_relative(-10, 1.0, 1, depth, bg, true)
    palmtreelib.create_palmtree_relative(2, 1.2, 2, depth, bg, true)
    palmtreelib.create_palmtree_relative(0, 1.2, 0, depth, bg)
    palmtreelib.create_palmtree_relative(13, 1.2, 1, depth, bg)
    palmtreelib.create_palmtree_relative(25, 1.2, 0, depth, bg)
    -- palmtreelib.create_palmtree_relative(30, 3, 2, depth, bg)


    --back background
    depth = decorlib.SURFACE_BG_DEPTH.BACK_BACKGROUND
    surfacelayerlib.create_surface_layer_looping(113.6, depth, false)
    surfacelayerlib.create_surface_layer_looping(113.6, depth, true)

    if state.win_state == WIN_STATE.HUNDUN_WIN then
        sun:set_texture(TEXTURE.DATA_TEXTURES_BG_DUAT2_0)
        sky:set_texture(sky_hard_texture_id)
    end

    decorlib.CREDITS_SCROLLING = false
end

function module.decorate_existing_surface()
    local TO_REMOVE = {ENT_TYPE.ITEM_EGGSHIP, ENT_TYPE.FX_EGGSHIP_DOOR, ENT_TYPE.FX_EGGSHIP_SHELL, ENT_TYPE.BG_SURFACE_STAR}
    local TO_MOVE = {ENT_TYPE.BG_LEVEL_BACKWALL, ENT_TYPE.BG_SURFACE_BACKGROUNDSEAM}
    local TO_DECORATE = {ENT_TYPE.BG_SURFACE_LAYER, ENT_TYPE.BG_SURFACE_ENTITY}

    for _, uid in pairs(get_entities_by_type(TO_REMOVE)) do
        get_entity(uid):destroy()
    end

    for _, uid in pairs(get_entities_by_type(TO_MOVE)) do
        local x, _, _ = get_position(uid)
        local deco = get_entity(uid)
        if deco.type.id == ENT_TYPE.BG_LEVEL_BACKWALL then
            deco:set_draw_depth(decorlib.SURFACE_BG_DEPTH.BACKWALL)
        end
        if x < 40 then
            deco:destroy()
        else
            deco.x = deco.x - 7
        end
    end

    local sky = get_entity(get_entities_by_type(ENT_TYPE.BG_SPACE)[1])
    sky:set_draw_depth(decorlib.SURFACE_BG_DEPTH.SKY)

    local sun = get_entity(get_entities_by_type(ENT_TYPE.BG_SURFACE_NEBULA)[1])
    sun.width = 9
    sun.height = 4.5
    sun:set_draw_depth(decorlib.SURFACE_BG_DEPTH.SUN)

    if state.win_state == WIN_STATE.HUNDUN_WIN then
        sun:set_texture(TEXTURE.DATA_TEXTURES_BG_DUAT2_0)
        local sky_uids = get_entities_by_type(ENT_TYPE.BG_SPACE)
        if #sky_uids > 0 then
            get_entity(sky_uids[1]):set_texture(sky_hard_texture_id)
        end
    end

    -- prevent teetering animation in intro
    spawn_grid_entity(ENT_TYPE.FLOOR_GENERIC, 53, 99, LAYER.FRONT)
    
    -- fix gap needed in camp for last two players on rope
    get_entity(spawn_grid_entity(ENT_TYPE.FLOOR_GENERIC, 50, 99, LAYER.FRONT)):fix_decorations(true,true)

    palmtreelib.create_palmtree(30, 100, 1, decorlib.SURFACE_BG_DEPTH.FOREGROUND)

    for _, uid in pairs(get_entities_by_type(TO_DECORATE)) do
        ---@type BGSurfaceLayer
        local bg = get_entity(uid)
        local texture_id = bg:get_texture()
        if texture_id == TEXTURE.DATA_TEXTURES_BASE_SURFACE_1 then
            surfacelayerlib.set(bg, decorlib.SURFACE_BG_DEPTH.FOREGROUND)
        elseif texture_id == TEXTURE.DATA_TEXTURES_BASE_SURFACE_0 then
            --default back-background, animation_frame == 1. We don't need to add palmtrees for it.
            local depth = decorlib.SURFACE_BG_DEPTH.BACK_BACKGROUND
            if bg.animation_frame == 3 then
                --front-background
                depth = decorlib.SURFACE_BG_DEPTH.BACKGROUND
                palmtreelib.create_palmtree(14, 103, 2, decorlib.SURFACE_BG_DEPTH.BACKGROUND)
                palmtreelib.create_palmtree(23, 103, 0, decorlib.SURFACE_BG_DEPTH.BACKGROUND)
                palmtreelib.create_palmtree(32, 103, 1, decorlib.SURFACE_BG_DEPTH.BACKGROUND, true)
            elseif bg.animation_frame == 2 then
                --mid-background
                depth = decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND
                palmtreelib.create_palmtree_relative(-8, 1.6, 1, decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND, bg)
                palmtreelib.create_palmtree_relative(-3, 1, 0, decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND, bg, true)
                palmtreelib.create_palmtree_relative(3.1, 0.8, 2, decorlib.SURFACE_BG_DEPTH.MID_BACKGROUND, bg, true)
            end
            surfacelayerlib.set(bg, depth)
        end

    end
end

return module