local module = {}
module.anubis2_killed = true -- Gets set to false when Anubis2 is spawned, back to true when he's killed.
local function create_cool_ass_red_portal_effect(x, y, l)
    local e = get_entity(spawn(ENT_TYPE.ITEM_ROCK, x, y, l, 0 , 0))
    e.color = Color:new(0.8, 0.1, 0.2, 1)
    e.flags = set_flag(e.flags, ENT_FLAG.NO_GRAVITY)
    e.flags = clr_flag(e.flags, ENT_FLAG.PICKUPABLE)
    e.flags = set_flag(e.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    e.flags = clr_flag(e.flags, ENT_FLAG.COLLIDES_WALLS)
    e.flags = clr_flag(e.flags, ENT_FLAG.INTERACT_WITH_SEMISOLIDS)
    e.flags = clr_flag(e.flags, ENT_FLAG.INTERACT_WITH_WEBS)
    e:set_texture(TEXTURE.DATA_TEXTURES_FX_BIG_0)
    e:set_draw_depth(12)
    e.width = e.width*0.25
    e.height = e.height*0.25
    e.user_data = {
        timer = 0;
        warp = generate_world_particles(PARTICLEEMITTER.PORTAL_WARP, e.uid);
        dust = generate_world_particles(PARTICLEEMITTER.PORTAL_DUST_SLOW, e.uid);
        ilum = create_illumination(Color:new(0.9, 0.1, 0.1, 1), 20, e.uid);
        portal = commonlib.play_vanilla_sound(VANILLA_SOUND.SHARED_PORTAL_LOOP, e.uid, 1, true);
    }
    e:set_post_update_state_machine(function()
        refresh_illumination(e.user_data.ilum)
        if e.user_data.ilum.brightness < 1.45 and e.user_data.timer < 130 then
            e.user_data.ilum.brightness = e.user_data.ilum.brightness + 0.01
        elseif e.user_data.ilum.brightness > 0 then
            e.user_data.ilum.brightness = e.user_data.ilum.brightness - 0.01
        end
        e.angle = e.angle + 0.066
        e.animation_frame = 10
        e.user_data.timer = e.user_data.timer + 1
        if e.user_data.timer > 120 then
            e.angle = e.angle - 0.02
            if e.user_data.timer > 130 then
                e.color.a = e.color.a - 0.015            
            end
            e.width = e.width - 0.01
            e.height = e.height - 0.01
            if e.color.a < 0.05 and e.user_data.timer > 150 then
                extinguish_particles(e.user_data.warp)
                extinguish_particles(e.user_data.dust)
                generate_world_particles(PARTICLEEMITTER.NECROMANCER_SUMMON, e.uid)
                generate_world_particles(PARTICLEEMITTER.BROKENORB_WARP_LARGE, e.uid)
                commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_ANUBIS_SPECIAL_SHOT, e.uid, 1, false)
                e.user_data.portal:stop()
                e:destroy()
            end
        else
            e.width = e.width + 0.033
            e.height = e.height + 0.033
        end
    end)

end
local function anubis2_redskeleton_attack(ent)
    if get_entity(ent.chased_target_uid) ~= nil then
        local tx, ty, tl = get_position(ent.chased_target_uid)
        tx = math.floor(tx)
        ty = math.floor(ty)
        local used_spawns = {} -- table that contains coordinates of spawns we've already used
        for i=1, 4 do
            local failsafe = 0 -- In the incredibly rare event the game can't find a place for a skeleton, we need to stop an infinite loop from occuring
            -- Choose a random tile within a random range
            local rx = math.random(-4, 4)
            local ry = math.random(-2, 2)
            -- Choose a random tile
            local tile = get_entity(get_grid_entity_at(tx+rx, ty+ry, tl))
            while tile ~= true do
                -- Re-roll until we find a tile that meets our requirements
                rx = math.random(-5, 5)
                ry = math.random(-4, 4)
                tile = get_entity(get_grid_entity_at(tx+rx, ty+ry, tl))
                -- Found a tile, now see if the space above it is free
                if tile ~= nil and test_flag(tile.flags, ENT_FLAG.SOLID) then
                    local floor_at = get_entity(get_grid_entity_at(tx+rx, ty+ry+1, tl))
                    if floor_at == nil or not test_flag(floor_at.flags, ENT_FLAG.SOLID) then
                        tile = true
                        -- Check if there's maybe an activefloor or something grid entity won't find
                        local pf = get_entities_at(0, MASK.FLOOR | MASK.ACTIVEFLOOR, tx+rx, ty+ry+1, tl, 0.5)[1]
                        if pf ~= nil then
                            local f = get_entity(pf)
                            if test_flag(f.flags, ENT_FLAG.SOLID) then
                                tile = nil
                            end
                        end
                        -- Check if we're trying to spawn entities on the roof of the level
                        _, ceiling, _, _ = get_bounds()
                        if ty+ry+1 >= ceiling then
                            tile = nil
                        end
                        -- Did we already use this spawn? if so, DON'T USE IT!!
                        local used = false
                        for _, cord in ipairs(used_spawns) do
                            if tx+rx == cord[1] and ty+ry+1 == cord[2] then
                                used = true
                                break
                            end
                        end
                        if used then 
                            tile = nil 
                        end
                        -- Add to the table of already used spawns
                        if tile ~= nil then
                            table.insert(used_spawns, {tx+rx, ty+ry+1})
                        end
                    end
                end
                failsafe = failsafe + 1
                if failsafe >= 300 then
                    tile = true
                end
            end
            if failsafe < 300 then
                -- Spawn a skelly right above the now located tile
                local source = get_entity(spawn(ENT_TYPE.FX_ANUBIS_SPECIAL_SHOT_RETICULE, tx+rx, ty+ry+1, tl, 0, 0))
                source:set_texture(TEXTURE.DATA_TEXTURES_FX_SMALL3_0)
                source.animation_frame = 32
                commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_NECROMANCER_SPAWN, source.uid, 1, false)
                set_timeout(function()
                    spawn(ENT_TYPE.MONS_REDSKELETON, tx+rx, ty+ry+1, tl, 0, 0)
                    commonlib.play_vanilla_sound(VANILLA_SOUND.ENEMIES_SORCERESS_ATK, source.uid, 1, false)
                    generate_world_particles(PARTICLEEMITTER.NECROMANCER_SUMMON, source.uid)
                end, 45)
            end
        end
    end
end
local ANIMATION_INFO = {
    IDLE = {
        start = 33;
        finish = 33;
        speed = 0;
    };
    ATTACK = {
        start = 56;
        finish = 63;
        speed = 5;
    };
}
---@param ent Monster
local function anubis2_update(ent)
    if ent.frozen_timer > 0 then
        ent.flags = set_flag(ent.flags, ENT_FLAG.COLLIDES_WALLS)
        return
    else
        ent.flags = clr_flag(ent.flags, ENT_FLAG.COLLIDES_WALLS)
    end
    --- ANIMATION
    -- Increase animation timer
    ent.user_data.animation_timer = ent.user_data.animation_timer + 1
    --- Animate the entity and reset the timer
    if ent.user_data.animation_timer >= ent.user_data.animation_info.speed then
        ent.user_data.animation_timer = 1
        -- Advance the animation
        ent.user_data.animation_frame = ent.user_data.animation_frame + 1
        -- Loop if the animation has reached the end
        if ent.user_data.animation_frame > ent.user_data.animation_info.finish then
            ent.user_data.animation_frame = ent.user_data.animation_info.start
        end
    end
    -- Change the actual animation frame
    ent.animation_frame = ent.user_data.animation_frame
    -- Stop anubis from attacking; we're gonna do a custom lua one
    ent.next_attack_timer = 160
    ent:set_behavior(3)
    if ent.user_data.fadein_timer < 60 then
        ent.x = ent.x-ent.velocityx    
        ent.y = ent.y-ent.velocityy
        ent.user_data.fadein_timer = ent.user_data.fadein_timer + 1
    end
    if ent.user_data.fadein_timer > 0 then
        ent.color.a = ent.user_data.fadein_timer/60
    end
    -- Contact damage after fully spawning in
    if ent.user_data.fadein_timer == 60 then
        ent.flags = clr_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
        ent.flags = clr_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    end
    -- State
    if ent.user_data.state == 0 then
        -- Count down to attack
        if get_entity(ent.chased_target_uid) ~= nil then
            if distance(ent.chased_target_uid, ent.uid) < 6 then
                ent.user_data.attack_timer = ent.user_data.attack_timer - 1
            else -- Give him a speed boost if the player is too far away
                ent.x = ent.x + ent.velocityx*1.5
                ent.y = ent.y + ent.velocityy*1.5
            end
        end
        -- Attack at 0
        if ent.user_data.attack_timer == 0 then
            ent.user_data.animation_info = ANIMATION_INFO.ATTACK
            ent.user_data.animation_frame = ent.user_data.animation_info.start
            ent.user_data.state = 1
        end
    elseif ent.user_data.state == 1 then
        -- Attack at end of animation
        if ent.user_data.animation_frame == ent.user_data.animation_info.finish and ent.user_data.animation_timer == ent.user_data.animation_info.speed-1 then
            ent.user_data.animation_info = ANIMATION_INFO.IDLE
            ent.user_data.animation_frame = ent.user_data.animation_info.start
            ent.user_data.attack_timer = ent.user_data.attack_timer_base
            ent.user_data.state = 0
            anubis2_redskeleton_attack(ent)
        end
    end
    local colliding_olmec = get_entity(
      get_entities_overlapping_hitbox(
        ENT_TYPE.ACTIVEFLOOR_OLMEC,
        MASK.ACTIVEFLOOR,
        get_hitbox(ent.uid),
        ent.layer
      )[1]
    )
    if colliding_olmec and ent.exit_invincibility_timer == 0 and (
        math.abs(colliding_olmec.velocityx) >= 0.175 or
        math.abs(colliding_olmec.velocityy) >= 0.175
    ) then
        ent:damage(colliding_olmec.uid, 1, 0, 0, 0, 10)
        ent.exit_invincibility_timer = 11
    end
end

local function anubis2_set(uid)
    ---@type Movable
    local ent = get_entity(uid)
    local x, y, l = get_position(ent.uid)
    -- Set health
    ent.health = 20
    -- user_data
    ent.user_data = {
        -- ANIMATION
        animation_timer = 1;
        animation_frame = 0;
        animation_info = ANIMATION_INFO.IDLE; -- Info about animation speed, start frame, stop frame

        -- ATTACK
        attack_timer = 180;
        attack_timer_base = 180; -- Not sure what the HD value is but we can just change it in the future

        state = 0; -- 0 is idle, count down to attack and let the vanilla entity handle movement, 1 is attack, stop at the end of animation and spawn skellys

        fadein_timer = -60;
    };
    ent.user_data.animation_frame = ent.user_data.animation_info.start
    ent:set_draw_depth(7)
    ent.flags = clr_flag(ent.flags, ENT_FLAG.COLLIDES_WALLS)
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_PLAYER)
    ent.flags = set_flag(ent.flags, ENT_FLAG.PASSES_THROUGH_EVERYTHING)
    ent:set_behavior(3)
    module.anubis2_killed = false
    ent:set_pre_kill(function()
        -- Stops Anubis2 from spawning at the start of every level if he's killed
        module.anubis2_killed = true
    end)
    ent:set_pre_damage(function (_, damage_dealer)
        if damage_dealer and damage_dealer.type.search_flags & MASK.LAVA ~= 0 then
            return false
        end
    end)
end

function module.create_anubis2(x, y, l)
    local anubis2 = get_entity(spawn(ENT_TYPE.MONS_ANUBIS2, x, y, l, 0, 0))
    create_cool_ass_red_portal_effect(x, y, l)
    anubis2.color.a = 0
    anubis2_set(anubis2.uid)
    set_post_statemachine(anubis2.uid, anubis2_update)
    return anubis2
end

-- If Anubis2 wasn't killed, make him follow between levels
set_callback(function()
    if state.level_count == 0 then
        -- Whenever a new run is started, clear this so anubis doesnt follow you between runs
        module.anubis2_killed = true
    end
    if module.anubis2_killed == false then
        -- Find the first alive player
        local alivep = nil
        for _, player in ipairs(players) do
            if not test_flag(player.flags, ENT_FLAG.DEAD) then
                alivep = player
                break
            end
        end
        if alivep ~= nil then
            local x, y, l = get_position(alivep.uid)
            set_timeout(function ()
                module.create_anubis2(x, y+2, l)
            end, 1)
        end
    end
end, ON.LEVEL)
-- No anubis2 jetpack :)
replace_drop(DROP.ANUBIS2_JETPACK, ENT_TYPE.FX_SHADOW)
optionslib.register_entity_spawner("Anubis II", module.create_anubis2)

return module