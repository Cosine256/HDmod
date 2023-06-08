-- I needed somewhere to dump all the checks for journal unlocks, so this is that.
-- I tried to order things based on when they appear in the journal but no promises
-- ctrl+f will be needed :)
module = {}
local JOURNAL_CHAPTER_TYPE = {
    PLACES = 3;
    PEOPLE = 4;
    BESTIARY = 5;
    ITEMS = 6;
    TRAPS = 7;
    STORY = 8;
    FEATS = 9;
}
function module.check_for_journal_unlocks(journal_data)
    -- PLACES --
    set_callback(function()
        -- MINES
        if state.theme == THEME.DWELLING and state.level == 1 then
            if not journal_data.journal_data.places[1] then
                journal_data.journal_data.places[1] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 0)
            end
        end
        -- JUNGLE
        if state.theme == THEME.JUNGLE and state.level == 1 then
            if not journal_data.journal_data.places[2] then
                journal_data.journal_data.places[2] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 1)
            end
        end
        -- BLACK MARKET
        if feelingslib.feeling_check(feelingslib.FEELING_ID.BLACKMARKET) then
            if not journal_data.journal_data.places[3] then
                journal_data.journal_data.places[3] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 2)
            end            
        end
        -- WORM
        if state.theme == THEME.EGGPLANT_WORLD then
            if not journal_data.journal_data.places[4] then
                journal_data.journal_data.places[4] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 3)
            end            
        end
        -- HAUNTED CASTLE
        if feelingslib.feeling_check(feelingslib.FEELING_ID.HAUNTEDCASTLE) then
            if not journal_data.journal_data.places[5] then
                journal_data.journal_data.places[5] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 4)
            end            
        end
        -- ICE CAVES
        if state.theme == THEME.ICE_CAVES and state.level == 1 then
            if not journal_data.journal_data.places[6] then
                journal_data.journal_data.places[6] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 5)
            end
        end
        -- MOTHERSHIP
        if state.theme == THEME.NEO_BABYLON then
            if not journal_data.journal_data.places[7] then
                journal_data.journal_data.places[7] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 6)
            end
        end
        -- TEMPLE
        if state.theme == THEME.TEMPLE then
            if not journal_data.journal_data.places[8] then
                journal_data.journal_data.places[8] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 7)
            end
        end
        -- CITY OF GOLD
        if state.theme == THEME.CITY_OF_GOLD then
            if not journal_data.journal_data.places[9] then
                journal_data.journal_data.places[9] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 8)
            end
        end
        -- HELL
        if state.theme == THEME.VOLCANA then
            if not journal_data.journal_data.places[10] then
                journal_data.journal_data.places[10] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 9)
            end
        end
    end, ON.LEVEL)
    -- PEOPLE --
    -- SHOPKEEPER
    set_callback(function(speaking_ent)
        -- Unlock the journal entry when you first hear a shoppie speak
        if speaking_ent.type.id == ENT_TYPE.MONS_SHOPKEEPER then
            if not journal_data.journal_data.people[1] then
                journal_data.journal_data.people[1] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PEOPLE, 21)
            end            
        end
    end, ON.SPEECH_BUBBLE)
    -- GUSTAF
    set_post_entity_spawn(function(self)
        set_timeout(function()
            if type(self.user_data) == "table" then
                if self.user_data.ent_type == HD_ENT_TYPE.MONS_CRITTERRAT then
                    self:set_post_kill(function(self, destroy_corspe, responsible)
                        if responsible.type.search_flags == MASK.PLAYER then
                            if not journal_data.journal_data.people[13] then
                                journal_data.journal_data.people[13] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.PEOPLE, 33)
                            end 
                        end
                    end)
                end
            end        
        end, 1)
    end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.MONS_CRITTERCRAB)
    -- BESTIARY
    set_post_entity_spawn(function(self) -- Kill count
        set_timeout(function()
            self:set_post_kill(function(self, destroy_corpse, responsible)
                local player_responsible = false
                for _, player in ipairs(players) do
                    if player.uid == responsible.uid then
                        player_responsible = true
                    end
                end
                if player_responsible then
                    -- VANILLA MONSTERS
                    if type(self.user_data) ~= "table" then
                        -- SNAKE
                        if self.type.id == ENT_TYPE.MONS_SNAKE then
                            if not journal_data.journal_data.bestiary[1] then
                                journal_data.journal_data.bestiary[1] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 0)
                            end  
                            journal_data.journal_data.bestiary_killed[1] = journal_data.journal_data.bestiary_killed[1] + 1
                        end          
                        -- COBRA
                        if self.type.id == ENT_TYPE.MONS_COBRA then
                            if not journal_data.journal_data.bestiary[2] then
                                journal_data.journal_data.bestiary[2] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 1)
                            end  
                            journal_data.journal_data.bestiary_killed[2] = journal_data.journal_data.bestiary_killed[2] + 1
                        end   
                        -- SPIDER
                        if self.type.id == ENT_TYPE.MONS_SPIDER then
                            if not journal_data.journal_data.bestiary[3] then
                                journal_data.journal_data.bestiary[3] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 2)
                            end  
                            journal_data.journal_data.bestiary_killed[3] = journal_data.journal_data.bestiary_killed[3] + 1
                        end   
                        -- HANG SPIDER
                        if self.type.id == ENT_TYPE.MONS_HANGSPIDER then
                            if not journal_data.journal_data.bestiary[4] then
                                journal_data.journal_data.bestiary[4] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 3)
                            end  
                            journal_data.journal_data.bestiary_killed[4] = journal_data.journal_data.bestiary_killed[4] + 1
                        end   
                        -- BAT
                        if self.type.id == ENT_TYPE.MONS_BAT then
                            if not journal_data.journal_data.bestiary[5] then
                                journal_data.journal_data.bestiary[5] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 4)
                            end  
                            journal_data.journal_data.bestiary_killed[5] = journal_data.journal_data.bestiary_killed[5] + 1
                        end  
                        -- CAVEMAN
                        if self.type.id == ENT_TYPE.MONS_CAVEMAN then
                            if not journal_data.journal_data.bestiary[6] then
                                journal_data.journal_data.bestiary[6] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 5)
                            end  
                            journal_data.journal_data.bestiary_killed[6] = journal_data.journal_data.bestiary_killed[6] + 1
                        end   
                        -- SCORPION
                        if self.type.id == ENT_TYPE.MONS_SCORPION then
                            if not journal_data.journal_data.bestiary[7] then
                                journal_data.journal_data.bestiary[7] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 6)
                            end  
                            journal_data.journal_data.bestiary_killed[7] = journal_data.journal_data.bestiary_killed[7] + 1
                        end  
                        -- SKELETON
                        if self.type.id == ENT_TYPE.MONS_SKELETON then
                            if not journal_data.journal_data.bestiary[8] then
                                journal_data.journal_data.bestiary[8] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 7)
                            end  
                            journal_data.journal_data.bestiary_killed[8] = journal_data.journal_data.bestiary_killed[8] + 1
                        end                  
                    else -- CUSTOM MONSTERS

                    end
                end
            end)
        end, 1)
    end, SPAWN_TYPE.ANY, MASK.MONSTER)
end

return module