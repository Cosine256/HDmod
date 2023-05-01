local module = {}

-- Setup texture sheet
local test_texture_id
do
    local test_texture_def = TextureDefinition.new()
    test_texture_def.width = 1024
    test_texture_def.height = 256
    test_texture_def.tile_width = 128
    test_texture_def.tile_height = 128
    test_texture_def.texture_path = ''
    test_texture_id = define_texture(test_texture_def)
end
-- Sound effect path
local sfx = create_sound('')
local sfx_volume = 0.15

-- Animations
local ANIMATION_INFO = {
    IDLE = {
        start = 0;
        finish = 0;
        speed = 0;
    };
}

-- State enum
local STATE = {
    IDLE = 1; -- We display the fake pet entity and make the actual succubus invisible
}
local function animate_entity(self)
    if self.user_data.custom_animation then
        -- Increase animation timer
        self.user_data.animation_timer = self.user_data.animation_timer + 1
        --- Animate the entity and reset the timer
        if self.user_data.animation_timer >= self.user_data.animation_info.speed then
            self.user_data.animation_timer = 1
            -- Advance the animation
            self.user_data.animation_frame = self.user_data.animation_frame + 1
            -- Loop if the animation has reached the end
            if self.user_data.animation_frame > self.user_data.animation_info.finish then
                self.user_data.animation_frame = self.user_data.animation_info.start
            end
        end
        -- Change the actual animation frame
        self.animation_frame = self.user_data.animation_frame
    end
end
local function entity_update(self)
    -- STATEMACHINE
    local d = self.user_data
    if d.state == STATE.IDLE then
    end
    -- Custom animation
    animate_entity(self)
end
local function entity_set(self)
    -- Userdata
    self.user_data = {
        ent_type = 0;

        -- ANIMATION
        animation_timer = 1;
        animation_frame = 0;
        animation_info = ANIMATION_INFO.IDLE; -- Info about animation speed, start frame, stop frame
        custom_animation = true; -- When false we let the game handle animations

    };

    self:set_post_update_state_machine(entity_update)
end

function module.create_entity(x, y, l)
    local entity = get_entity(spawn(ENT_TYPE.MONS_SNAKE, x, y, l, 0, 0))
    entity_set(entity)
end
optionslib.register_entity_spawner("template", module.create_entity, false)

return module