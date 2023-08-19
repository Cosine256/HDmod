local module = {}

-- Force velocity of ufo to go to the right slowly

-- destroy the ufo once reaching a certain point of the stage

-- UFO beams during the credits should not destroy floor (Mark floor as indestructable)

function module.create_minigame_ufo(x, y, l)
    local entity = spawn_entity(ENT_TYPE.MONS_UFO, x, y, l, 0, 0)
    entity.velocityx = 0.04
    entity:set_post_update_state_machine(function (self)
        if self.x > 26 then
            self:destroy()
            clear_callback()
        end
    end)
end

-- Force velocity of the imp to go to the right slowly

-- destroy the imp and its item once reaching a certain point of the stage

-- Maybe the imp holds random stuff?

function module.create_minigame_ufo(x, y, l)
    local entity = spawn_entity(ENT_TYPE.MONS_IMP, x, y, l, 0, 0)
    entity.velocityx = 0.04
    entity:set_post_update_state_machine(function (self)
        if self.x > 26 then
            self:destroy()
            clear_callback()
        end
    end)
end


return module