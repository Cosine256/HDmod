-- I needed somewhere to dump all the checks for journal unlocks, so this is that.
-- I tried to order things based on when they appear in the journal but no promises
-- ctrl+f will be needed :)
local module = {}
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
        -- OLMEC
        if state.theme == THEME.OLMEC then
            if not journal_data.journal_data.places[11] then
                journal_data.journal_data.places[11] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 9)
            end
        end
        -- HELL
        if state.theme == THEME.VOLCANA then
            if not journal_data.journal_data.places[11] then
                journal_data.journal_data.places[11] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 10)
            end
        end
        -- YAMA
        if state.theme == THEME.VOLCANA and state.level == 4 then
            if not journal_data.journal_data.places[12] then
                journal_data.journal_data.places[12] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PLACES, 11)
            end
        end
    end, ON.LEVEL)
    -- PEOPLE --
    set_callback(function(speaking_ent)
        -- SHOPKEEPER
        -- Unlock the journal entry when you first hear a shoppie speak
        if speaking_ent.type.id == ENT_TYPE.MONS_SHOPKEEPER then
            if not journal_data.journal_data.people[1] then
                journal_data.journal_data.people[1] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PEOPLE, 21)
            end            
        end
        -- Mamma Tunnel
        if speaking_ent.type.id == ENT_TYPE.MONS_MARLA_TUNNEL then
            if not journal_data.journal_data.people[4] then
                journal_data.journal_data.people[4] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.PEOPLE, 23)
            end            
        end
    end, ON.SPEECH_BUBBLE)
    -- HIRED HAND
    set_post_entity_spawn(function(self)
        if not journal_data.journal_data.people[3] and not test_flag(self.flags, ENT_FLAG.SHOP_ITEM) then
            journal_data.journal_data.people[3] = true
            show_journal_popup(JOURNAL_CHAPTER_TYPE.PEOPLE, 22)
        end         
    end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.CHAR_HIREDHAND)
    -- GUSTAF
    set_post_entity_spawn(function(self)
        set_timeout(function()
            if type(self.user_data) == "table" then
                self:set_post_update_state_machine(function()
                    if self.user_data.ent_type == HD_ENT_TYPE.MONS_CRITTERRAT then
                        for _, player in ipairs(players) do
                            if distance(self.uid, player.uid) < 3 then
                                if self.user_data.gustaf then
                                    if not journal_data.journal_data.people[5] then
                                        journal_data.journal_data.people[5] = true
                                        show_journal_popup(JOURNAL_CHAPTER_TYPE.PEOPLE, 24)
                                    end 
                                end                               
                            end
                        end
                    end                
                end)
            end        
        end, 1)
    end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.MONS_CRITTERCRAB)
    -- BESTIARY
    set_post_entity_spawn(function(self) -- Kill count
        set_timeout(function()
            self:set_post_kill(function(self, destroy_corpse, responsible)
                if responsible == nil then return end
                local player_responsible = false
                for _, player in ipairs(players) do
                    if player.uid == responsible.uid or player.uid == responsible.last_owner_uid then
                        player_responsible = true
                    end
                end
                if player_responsible then
                    -- VANILLA MONSTERS
                    if type(self.user_data) == "nil" then
                        -- SNAKE: 1
                        if self.type.id == ENT_TYPE.MONS_SNAKE then
                            if not journal_data.journal_data.bestiary[1] then
                                journal_data.journal_data.bestiary[1] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 0)
                            end  
                            journal_data.journal_data.bestiary_killed[1] = journal_data.journal_data.bestiary_killed[1] + 1
                        end          
                        -- COBRA: 2
                        if self.type.id == ENT_TYPE.MONS_COBRA then
                            if not journal_data.journal_data.bestiary[2] then
                                journal_data.journal_data.bestiary[2] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 1)
                            end  
                            journal_data.journal_data.bestiary_killed[2] = journal_data.journal_data.bestiary_killed[2] + 1
                        end   
                        -- SPIDER: 3
                        if self.type.id == ENT_TYPE.MONS_SPIDER then
                            if not journal_data.journal_data.bestiary[3] then
                                journal_data.journal_data.bestiary[3] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 2)
                            end  
                            journal_data.journal_data.bestiary_killed[3] = journal_data.journal_data.bestiary_killed[3] + 1
                        end   
                        -- HANG SPIDER: 4
                        if self.type.id == ENT_TYPE.MONS_HANGSPIDER then
                            if not journal_data.journal_data.bestiary[4] then
                                journal_data.journal_data.bestiary[4] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 3)
                            end  
                            journal_data.journal_data.bestiary_killed[4] = journal_data.journal_data.bestiary_killed[4] + 1
                        end   
                        -- BAT: 5
                        if self.type.id == ENT_TYPE.MONS_BAT then
                            if not journal_data.journal_data.bestiary[5] then
                                journal_data.journal_data.bestiary[5] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 4)
                            end  
                            journal_data.journal_data.bestiary_killed[5] = journal_data.journal_data.bestiary_killed[5] + 1
                        end  
                        -- CAVEMAN: 6
                        if self.type.id == ENT_TYPE.MONS_CAVEMAN then
                            if not journal_data.journal_data.bestiary[6] then
                                journal_data.journal_data.bestiary[6] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 5)
                            end  
                            journal_data.journal_data.bestiary_killed[6] = journal_data.journal_data.bestiary_killed[6] + 1
                        end   
                        -- PETS: 7
                        if self.type.id == ENT_TYPE.MONS_PET_DOG or self.type.id == ENT_TYPE.MONS_PET_CAT or self.type.id == ENT_TYPE.MONS_PET_HAMSTER then
                            if not journal_data.journal_data.bestiary[7] then
                                journal_data.journal_data.bestiary[7] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 6)
                            end  
                            journal_data.journal_data.bestiary_killed[7] = journal_data.journal_data.bestiary_killed[7] + 1
                        end   
                        -- GIANT SPIDER: 8
                        if self.type.id == ENT_TYPE.MONS_GIANTSPIDER then
                            if not journal_data.journal_data.bestiary[8] then
                                journal_data.journal_data.bestiary[8] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 7)
                            end  
                            journal_data.journal_data.bestiary_killed[8] = journal_data.journal_data.bestiary_killed[8] + 1
                        end  
                        -- SCORPION: 9
                        if self.type.id == ENT_TYPE.MONS_SCORPION then
                            if not journal_data.journal_data.bestiary[9] then
                                journal_data.journal_data.bestiary[9] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 8)
                            end  
                            journal_data.journal_data.bestiary_killed[9] = journal_data.journal_data.bestiary_killed[9] + 1
                        end  
                        -- SKELETON: 10
                        if self.type.id == ENT_TYPE.MONS_SKELETON then
                            if not journal_data.journal_data.bestiary[10] then
                                journal_data.journal_data.bestiary[10] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 9)
                            end  
                            journal_data.journal_data.bestiary_killed[10] = journal_data.journal_data.bestiary_killed[10] + 1
                        end   
                        -- SCARAB: 11
                        if self.type.id == ENT_TYPE.MONS_SCARAB then
                            if not journal_data.journal_data.bestiary[11] then
                                journal_data.journal_data.bestiary[11] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 10)
                            end  
                            journal_data.journal_data.bestiary_killed[11] = journal_data.journal_data.bestiary_killed[11] + 1
                        end    
                        -- TIKIMAN: 12
                        if self.type.id == ENT_TYPE.MONS_TIKIMAN then
                            if not journal_data.journal_data.bestiary[12] then
                                journal_data.journal_data.bestiary[12] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 11)
                            end  
                            journal_data.journal_data.bestiary_killed[12] = journal_data.journal_data.bestiary_killed[12] + 1
                        end   
                        -- FROG: 13
                        if self.type.id == ENT_TYPE.MONS_FROG then
                            if not journal_data.journal_data.bestiary[13] then
                                journal_data.journal_data.bestiary[13] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 12)
                            end  
                            journal_data.journal_data.bestiary_killed[13] = journal_data.journal_data.bestiary_killed[13] + 1
                        end   
                        -- FIRE FROG: 14
                        if self.type.id == ENT_TYPE.MONS_FIREFROG then
                            if not journal_data.journal_data.bestiary[14] then
                                journal_data.journal_data.bestiary[14] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 13)
                            end  
                            journal_data.journal_data.bestiary_killed[14] = journal_data.journal_data.bestiary_killed[14] + 1
                        end  
                        -- MANTRAP: 16
                        if self.type.id == ENT_TYPE.MONS_MANTRAP then
                            if not journal_data.journal_data.bestiary[16] then
                                journal_data.journal_data.bestiary[16] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 15)
                            end  
                            journal_data.journal_data.bestiary_killed[16] = journal_data.journal_data.bestiary_killed[16] + 1
                        end
                        -- GREAT HUMPHEAD: 18
                        if self.type.id == ENT_TYPE.MONS_GIANTFISH then
                            if not journal_data.journal_data.bestiary[18] then
                                journal_data.journal_data.bestiary[18] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 17)
                            end  
                            journal_data.journal_data.bestiary_killed[18] = journal_data.journal_data.bestiary_killed[18] + 1
                        end 
                        -- BEE: 19
                        if self.type.id == ENT_TYPE.MONS_BEE then
                            if not journal_data.journal_data.bestiary[19] then
                                journal_data.journal_data.bestiary[19] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 18)
                            end  
                            journal_data.journal_data.bestiary_killed[19] = journal_data.journal_data.bestiary_killed[19] + 1
                        end   
                        -- QUEEN BEE: 20
                        if self.type.id == ENT_TYPE.MONS_QUEENBEE then
                            if not journal_data.journal_data.bestiary[20] then
                                journal_data.journal_data.bestiary[20] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 19)
                            end  
                            journal_data.journal_data.bestiary_killed[20] = journal_data.journal_data.bestiary_killed[20] + 1
                        end  
                        -- SNAIL: 21
                        if self.type.id == ENT_TYPE.MONS_HERMITCRAB then
                            if not journal_data.journal_data.bestiary[21] then
                                journal_data.journal_data.bestiary[21] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 20)
                            end  
                            journal_data.journal_data.bestiary_killed[21] = journal_data.journal_data.bestiary_killed[21] + 1
                        end    
                        -- MONKEY: 22
                        if self.type.id == ENT_TYPE.MONS_MONKEY then
                            if not journal_data.journal_data.bestiary[22] then
                                journal_data.journal_data.bestiary[22] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 21)
                            end  
                            journal_data.journal_data.bestiary_killed[22] = journal_data.journal_data.bestiary_killed[22] + 1
                        end   
                        -- GOLDEN MONKEY: 23
                        if self.type.id == ENT_TYPE.MONS_GOLDMONKEY then
                            if not journal_data.journal_data.bestiary[23] then
                                journal_data.journal_data.bestiary[23] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 22)
                            end  
                            journal_data.journal_data.bestiary_killed[23] = journal_data.journal_data.bestiary_killed[23] + 1
                        end   
                        -- JIANGSHI: 24
                        if self.type.id == ENT_TYPE.MONS_JIANGSHI then
                            if not journal_data.journal_data.bestiary[24] then
                                journal_data.journal_data.bestiary[24] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 23)
                            end  
                            journal_data.journal_data.bestiary_killed[24] = journal_data.journal_data.bestiary_killed[24] + 1
                        end 
                        -- VAMPIRE: 25
                        if self.type.id == ENT_TYPE.MONS_VAMPIRE then
                            if not journal_data.journal_data.bestiary[25] then
                                journal_data.journal_data.bestiary[25] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 24)
                            end  
                            journal_data.journal_data.bestiary_killed[25] = journal_data.journal_data.bestiary_killed[25] + 1
                        end
                        -- YETI: 32
                        if self.type.id == ENT_TYPE.MONS_YETI then
                            if not journal_data.journal_data.bestiary[32] then
                                journal_data.journal_data.bestiary[32] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 31)
                            end  
                            journal_data.journal_data.bestiary_killed[32] = journal_data.journal_data.bestiary_killed[32] + 1
                        end
                        -- YETI KING: 33
                        if self.type.id == ENT_TYPE.MONS_YETIKING then
                            if not journal_data.journal_data.bestiary[33] then
                                journal_data.journal_data.bestiary[33] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 32)
                            end  
                            journal_data.journal_data.bestiary_killed[33] = journal_data.journal_data.bestiary_killed[33] + 1
                        end
                        -- ALIEN: 35
                        if self.type.id == ENT_TYPE.MONS_ALIEN then
                            if not journal_data.journal_data.bestiary[35] then
                                journal_data.journal_data.bestiary[35] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 34)
                            end  
                            journal_data.journal_data.bestiary_killed[35] = journal_data.journal_data.bestiary_killed[35] + 1
                        end
                        -- UFO: 36
                        -- ALIENQUEEN: 39
                        if self.type.id == ENT_TYPE.MONS_ALIENQUEEN then
                            if not journal_data.journal_data.bestiary[39] then
                                journal_data.journal_data.bestiary[39] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 38)
                            end  
                            journal_data.journal_data.bestiary_killed[39] = journal_data.journal_data.bestiary_killed[39] + 1
                        end
                        -- HAWKMAN: 40
                        -- CROCMAN: 41
                        if self.type.id == ENT_TYPE.MONS_CROCMAN then
                            if not journal_data.journal_data.bestiary[41] then
                                journal_data.journal_data.bestiary[41] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 40)
                            end  
                            journal_data.journal_data.bestiary_killed[41] = journal_data.journal_data.bestiary_killed[41] + 1
                        end
                        -- MUMMY: 44
                        if self.type.id == ENT_TYPE.MONS_MUMMY then
                            if not journal_data.journal_data.bestiary[44] then
                                journal_data.journal_data.bestiary[44] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 43)
                            end  
                            journal_data.journal_data.bestiary_killed[44] = journal_data.journal_data.bestiary_killed[44] + 1
                        end
                        -- ANUBIS: 45
                        if self.type.id == ENT_TYPE.MONS_ANUBIS then
                            if not journal_data.journal_data.bestiary[45] then
                                journal_data.journal_data.bestiary[45] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 44)
                            end  
                            journal_data.journal_data.bestiary_killed[45] = journal_data.journal_data.bestiary_killed[45] + 1
                        end
                        -- ANUBIS2: 46
                        if self.type.id == ENT_TYPE.MONS_ANUBIS2 then
                            if not journal_data.journal_data.bestiary[46] then
                                journal_data.journal_data.bestiary[46] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 45)
                            end  
                            journal_data.journal_data.bestiary_killed[46] = journal_data.journal_data.bestiary_killed[46] + 1
                        end
                        -- VLAD: 48
                        if self.type.id == ENT_TYPE.MONS_VLAD then
                            if not journal_data.journal_data.bestiary[48] then
                                journal_data.journal_data.bestiary[48] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 47)
                            end  
                            journal_data.journal_data.bestiary_killed[48] = journal_data.journal_data.bestiary_killed[48] + 1
                        end
                        -- IMP: 49
                        if self.type.id == ENT_TYPE.MONS_IMP then
                            if not journal_data.journal_data.bestiary[49] then
                                journal_data.journal_data.bestiary[49] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 48)
                            end  
                            journal_data.journal_data.bestiary_killed[49] = journal_data.journal_data.bestiary_killed[49] + 1
                        end
                    elseif type(self.user_data) == "table" then -- CUSTOM MONSTERS
                        -- GIANT FROG: 15
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_GIANT_FROG then
                            if not journal_data.journal_data.bestiary[15] then
                                journal_data.journal_data.bestiary[15] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 14)
                            end  
                            journal_data.journal_data.bestiary_killed[15] = journal_data.journal_data.bestiary_killed[15] + 1
                        end
                        -- PIRANHA: 17
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_PIRANHA then
                            if not journal_data.journal_data.bestiary[17] then
                                journal_data.journal_data.bestiary[17] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 16)
                            end  
                            journal_data.journal_data.bestiary_killed[17] = journal_data.journal_data.bestiary_killed[17] + 1
                        end  
                        -- GREEN KNIGHT: 26
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_GREEN_KNIGHT then
                            if not journal_data.journal_data.bestiary[26] then
                                journal_data.journal_data.bestiary[26] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 25)
                            end  
                            journal_data.journal_data.bestiary_killed[26] = journal_data.journal_data.bestiary_killed[26] + 1
                        end
                        -- BLACK KNIGHT: 27
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_BLACK_KNIGHT then
                            if not journal_data.journal_data.bestiary[27] then
                                journal_data.journal_data.bestiary[27] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 26)
                            end  
                            journal_data.journal_data.bestiary_killed[27] = journal_data.journal_data.bestiary_killed[27] + 1
                        end
                        -- BACTERIUM: 29
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_BACTERIUM then
                            if not journal_data.journal_data.bestiary[29] then
                                journal_data.journal_data.bestiary[29] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 28)
                            end  
                            journal_data.journal_data.bestiary_killed[29] = journal_data.journal_data.bestiary_killed[29] + 1
                        end
                        -- WORM EGG: 30
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_WORM_EGG then
                            if not journal_data.journal_data.bestiary[30] then
                                journal_data.journal_data.bestiary[30] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 29)
                            end  
                            journal_data.journal_data.bestiary_killed[30] = journal_data.journal_data.bestiary_killed[30] + 1
                        end
                        -- WORM BABY: 31
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_BABY_WORM then
                            if not journal_data.journal_data.bestiary[31] then
                                journal_data.journal_data.bestiary[31] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 30)
                            end  
                            journal_data.journal_data.bestiary_killed[31] = journal_data.journal_data.bestiary_killed[31] + 1
                        end
                        -- MAMMOTH: 34
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_MAMMOTH then
                            if not journal_data.journal_data.bestiary[34] then
                                journal_data.journal_data.bestiary[34] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 33)
                            end  
                            journal_data.journal_data.bestiary_killed[34] = journal_data.journal_data.bestiary_killed[34] + 1
                        end
                        -- ALIENTANK: 37
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_ALIENTANK then
                            if not journal_data.journal_data.bestiary[37] then
                                journal_data.journal_data.bestiary[37] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 36)
                            end  
                            journal_data.journal_data.bestiary_killed[37] = journal_data.journal_data.bestiary_killed[37] + 1
                        end
                        -- ALIENLORD: 38
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_ALIENLORD then
                            if not journal_data.journal_data.bestiary[38] then
                                journal_data.journal_data.bestiary[38] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 37)
                            end  
                            journal_data.journal_data.bestiary_killed[38] = journal_data.journal_data.bestiary_killed[38] + 1
                        end
                        -- HAWKMAN: 40
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_HAWKMAN then
                            if not journal_data.journal_data.bestiary[40] then
                                journal_data.journal_data.bestiary[40] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 39)
                            end  
                            journal_data.journal_data.bestiary_killed[40] = journal_data.journal_data.bestiary_killed[40] + 1
                        end
                        -- SCORPIONFLY: 43
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_SCORPIONFLY then
                            if not journal_data.journal_data.bestiary[43] then
                                journal_data.journal_data.bestiary[43] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 42)
                            end  
                            journal_data.journal_data.bestiary_killed[43] = journal_data.journal_data.bestiary_killed[43] + 1
                        end
                        -- DEVIL: 50
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_DEVIL then
                            if not journal_data.journal_data.bestiary[50] then
                                journal_data.journal_data.bestiary[50] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 49)
                            end  
                            journal_data.journal_data.bestiary_killed[50] = journal_data.journal_data.bestiary_killed[50] + 1
                        end
                        -- SUCCUBUS: 51
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_SUCCUBUS then
                            if not journal_data.journal_data.bestiary[51] then
                                journal_data.journal_data.bestiary[51] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 50)
                            end  
                            journal_data.journal_data.bestiary_killed[51] = journal_data.journal_data.bestiary_killed[51] + 1
                        end
                        -- HORSEHEAD / OXFACE: 52, 53
                        if self.user_data.ent_type == HD_ENT_TYPE.MONS_HELL_MINIBOSS then
                            if self.user_data.is_horsehead then
                                if not journal_data.journal_data.bestiary[52] then
                                    journal_data.journal_data.bestiary[52] = true
                                    show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 51)
                                end  
                                journal_data.journal_data.bestiary_killed[52] = journal_data.journal_data.bestiary_killed[52] + 1
                            else
                                if not journal_data.journal_data.bestiary[53] then
                                    journal_data.journal_data.bestiary[53] = true
                                    show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 52)
                                end  
                                journal_data.journal_data.bestiary_killed[53] = journal_data.journal_data.bestiary_killed[53] + 1
                            end
                        end
                        -- YAMA: 54
                    end
                end
            end)
        end, 1)
    end, SPAWN_TYPE.ANY, MASK.MONSTER)
    set_callback(function()
        for _, player in ipairs(players) do
            player:set_pre_kill(function(self, destroy_corpse, responsible)
                if responsible == nil then return end
                -- VANILLA MONSTERS
                if type(responsible.user_data) == "nil" then
                    -- SNAKE: 1
                    if responsible.type.id == ENT_TYPE.MONS_SNAKE then
                        if not journal_data.journal_data.bestiary[1] then
                            journal_data.journal_data.bestiary[1] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 0)
                        end  
                        journal_data.journal_data.bestiary_killed_by[1] = journal_data.journal_data.bestiary_killed_by[1] + 1
                    end          
                    -- COBRA: 2
                    if responsible.type.id == ENT_TYPE.MONS_COBRA then
                        if not journal_data.journal_data.bestiary[2] then
                            journal_data.journal_data.bestiary[2] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 1)
                        end  
                        journal_data.journal_data.bestiary_killed_by[2] = journal_data.journal_data.bestiary_killed_by[2] + 1
                    end   
                    -- SPIDER: 3
                    if responsible.type.id == ENT_TYPE.MONS_SPIDER then
                        if not journal_data.journal_data.bestiary[3] then
                            journal_data.journal_data.bestiary[3] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 2)
                        end  
                        journal_data.journal_data.bestiary_killed_by[3] = journal_data.journal_data.bestiary_killed_by[3] + 1
                    end   
                    -- HANG SPIDER: 4
                    if responsible.type.id == ENT_TYPE.MONS_HANGSPIDER then
                        if not journal_data.journal_data.bestiary[4] then
                            journal_data.journal_data.bestiary[4] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 3)
                        end  
                        journal_data.journal_data.bestiary_killed_by[4] = journal_data.journal_data.bestiary_killed_by[4] + 1
                    end   
                    -- BAT: 5
                    if responsible.type.id == ENT_TYPE.MONS_BAT then
                        if not journal_data.journal_data.bestiary[5] then
                            journal_data.journal_data.bestiary[5] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 4)
                        end  
                        journal_data.journal_data.bestiary_killed_by[5] = journal_data.journal_data.bestiary_killed_by[5] + 1
                    end  
                    -- CAVEMAN: 6
                    if responsible.type.id == ENT_TYPE.MONS_CAVEMAN then
                        if not journal_data.journal_data.bestiary[6] then
                            journal_data.journal_data.bestiary[6] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 5)
                        end  
                        journal_data.journal_data.bestiary_killed_by[6] = journal_data.journal_data.bestiary_killed_by[6] + 1
                    end   
                    -- GIANT SPIDER: 8
                    if responsible.type.id == ENT_TYPE.MONS_GIANTSPIDER then
                        if not journal_data.journal_data.bestiary[8] then
                            journal_data.journal_data.bestiary[8] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 7)
                        end  
                        journal_data.journal_data.bestiary_killed_by[8] = journal_data.journal_data.bestiary_killed_by[8] + 1
                    end  
                    -- SCORPION: 9
                    if responsible.type.id == ENT_TYPE.MONS_SCORPION then
                        if not journal_data.journal_data.bestiary[9] then
                            journal_data.journal_data.bestiary[9] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 8)
                        end  
                        journal_data.journal_data.bestiary_killed_by[9] = journal_data.journal_data.bestiary_killed_by[9] + 1
                    end  
                    -- SKELETON: 10
                    if responsible.type.id == ENT_TYPE.MONS_SKELETON then
                        if not journal_data.journal_data.bestiary[10] then
                            journal_data.journal_data.bestiary[10] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 9)
                        end  
                        journal_data.journal_data.bestiary_killed_by[10] = journal_data.journal_data.bestiary_killed_by[10] + 1
                    end   
                    -- SCARAB: 11
                    if responsible.type.id == ENT_TYPE.MONS_SCARAB then
                        if not journal_data.journal_data.bestiary[11] then
                            journal_data.journal_data.bestiary[11] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 10)
                        end  
                        journal_data.journal_data.bestiary_killed_by[11] = journal_data.journal_data.bestiary_killed_by[11] + 1
                    end    
                    -- TIKIMAN: 12
                    if responsible.type.id == ENT_TYPE.MONS_TIKIMAN then
                        if not journal_data.journal_data.bestiary[12] then
                            journal_data.journal_data.bestiary[12] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 11)
                        end  
                        journal_data.journal_data.bestiary_killed_by[12] = journal_data.journal_data.bestiary_killed_by[12] + 1
                    end   
                    -- FROG: 13
                    if responsible.type.id == ENT_TYPE.MONS_FROG then
                        if not journal_data.journal_data.bestiary[13] then
                            journal_data.journal_data.bestiary[13] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 12)
                        end  
                        journal_data.journal_data.bestiary_killed_by[13] = journal_data.journal_data.bestiary_killed_by[13] + 1
                    end   
                    -- FIRE FROG: 14
                    if responsible.type.id == ENT_TYPE.MONS_FIREFROG then
                        if not journal_data.journal_data.bestiary[14] then
                            journal_data.journal_data.bestiary[14] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 13)
                        end  
                        journal_data.journal_data.bestiary_killed_by[14] = journal_data.journal_data.bestiary_killed_by[14] + 1
                    end  
                    -- MANTRAP: 16
                    if responsible.type.id == ENT_TYPE.MONS_MANTRAP then
                        if not journal_data.journal_data.bestiary[16] then
                            journal_data.journal_data.bestiary[16] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 15)
                        end  
                        journal_data.journal_data.bestiary_killed_by[16] = journal_data.journal_data.bestiary_killed_by[16] + 1
                    end
                    -- GREAT HUMPHEAD: 18
                    if responsible.type.id == ENT_TYPE.MONS_GIANTFISH then
                        if not journal_data.journal_data.bestiary[18] then
                            journal_data.journal_data.bestiary[18] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 17)
                        end  
                        journal_data.journal_data.bestiary_killed_by[18] = journal_data.journal_data.bestiary_killed_by[18] + 1
                    end 
                    -- BEE: 19
                    if responsible.type.id == ENT_TYPE.MONS_BEE then
                        if not journal_data.journal_data.bestiary[19] then
                            journal_data.journal_data.bestiary[19] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 18)
                        end  
                        journal_data.journal_data.bestiary_killed_by[19] = journal_data.journal_data.bestiary_killed_by[19] + 1
                    end   
                    -- QUEEN BEE: 20
                    if responsible.type.id == ENT_TYPE.MONS_QUEENBEE then
                        if not journal_data.journal_data.bestiary[20] then
                            journal_data.journal_data.bestiary[20] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 19)
                        end  
                        journal_data.journal_data.bestiary_killed_by[20] = journal_data.journal_data.bestiary_killed_by[20] + 1
                    end  
                    -- SNAIL: 21
                    if responsible.type.id == ENT_TYPE.MONS_HERMITCRAB then
                        if not journal_data.journal_data.bestiary[21] then
                            journal_data.journal_data.bestiary[21] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 20)
                        end  
                        journal_data.journal_data.bestiary_killed_by[21] = journal_data.journal_data.bestiary_killed_by[21] + 1
                    end    
                    -- MONKEY: 22
                    if responsible.type.id == ENT_TYPE.MONS_MONKEY then
                        if not journal_data.journal_data.bestiary[22] then
                            journal_data.journal_data.bestiary[22] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 21)
                        end  
                        journal_data.journal_data.bestiary_killed_by[22] = journal_data.journal_data.bestiary_killed_by[22] + 1
                    end   
                    -- GOLDEN MONKEY: 23
                    -- JIANGSHI: 24
                    if responsible.type.id == ENT_TYPE.MONS_JIANGSHI then
                        if not journal_data.journal_data.bestiary[24] then
                            journal_data.journal_data.bestiary[24] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 23)
                        end  
                        journal_data.journal_data.bestiary_killed_by[24] = journal_data.journal_data.bestiary_killed_by[24] + 1
                    end 
                    -- VAMPIRE: 25
                    if responsible.type.id == ENT_TYPE.MONS_VAMPIRE then
                        if not journal_data.journal_data.bestiary[25] then
                            journal_data.journal_data.bestiary[25] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 24)
                        end  
                        journal_data.journal_data.bestiary_killed_by[25] = journal_data.journal_data.bestiary_killed_by[25] + 1
                    end
                    -- YETI: 32
                    if responsible.type.id == ENT_TYPE.MONS_YETI then
                        if not journal_data.journal_data.bestiary[32] then
                            journal_data.journal_data.bestiary[32] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 31)
                        end  
                        journal_data.journal_data.bestiary_killed_by[32] = journal_data.journal_data.bestiary_killed_by[32] + 1
                    end
                    -- YETI KING: 33
                    if responsible.type.id == ENT_TYPE.MONS_YETIKING then
                        if not journal_data.journal_data.bestiary[33] then
                            journal_data.journal_data.bestiary[33] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 32)
                        end  
                        journal_data.journal_data.bestiary_killed_by[33] = journal_data.journal_data.bestiary_killed_by[33] + 1
                    end
                    -- ALIEN: 35
                    if responsible.type.id == ENT_TYPE.MONS_ALIEN then
                        if not journal_data.journal_data.bestiary[35] then
                            journal_data.journal_data.bestiary[35] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 34)
                        end  
                        journal_data.journal_data.bestiary_killed_by[35] = journal_data.journal_data.bestiary_killed_by[35] + 1
                    end
                    -- UFO: 36
                    if responsible.type.id == ENT_TYPE.MONS_UFO then
                        if not journal_data.journal_data.bestiary[36] then
                            journal_data.journal_data.bestiary[36] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 35)
                        end  
                        journal_data.journal_data.bestiary_killed_by[36] = journal_data.journal_data.bestiary_killed_by[36] + 1
                    end
                    -- ALIENQUEEN: 39
                    if responsible.type.id == ENT_TYPE.MONS_ALIENQUEEN then
                        if not journal_data.journal_data.bestiary[39] then
                            journal_data.journal_data.bestiary[39] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 38)
                        end  
                        journal_data.journal_data.bestiary_killed_by[39] = journal_data.journal_data.bestiary_killed_by[39] + 1
                    end
                    -- HAWKMAN: 40
                    -- CROCMAN: 41
                    if responsible.type.id == ENT_TYPE.MONS_CROCMAN then
                        if not journal_data.journal_data.bestiary[41] then
                            journal_data.journal_data.bestiary[41] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 40)
                        end  
                        journal_data.journal_data.bestiary_killed_by[41] = journal_data.journal_data.bestiary_killed_by[41] + 1
                    end
                    -- MAGMAR: 42
                    if responsible.type.id == ENT_TYPE.MONS_MAGMAMAN then
                        if not journal_data.journal_data.bestiary[42] then
                            journal_data.journal_data.bestiary[42] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 41)
                        end  
                        journal_data.journal_data.bestiary_killed_by[42] = journal_data.journal_data.bestiary_killed_by[42] + 1
                    end
                    -- MUMMY: 44
                    if responsible.type.id == ENT_TYPE.MONS_MUMMY then
                        if not journal_data.journal_data.bestiary[44] then
                            journal_data.journal_data.bestiary[44] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 43)
                        end  
                        journal_data.journal_data.bestiary_killed_by[44] = journal_data.journal_data.bestiary_killed_by[44] + 1
                    end
                    -- ANUBIS: 45
                    if responsible.type.id == ENT_TYPE.MONS_ANUBIS then
                        if not journal_data.journal_data.bestiary[45] then
                            journal_data.journal_data.bestiary[45] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 44)
                        end  
                        journal_data.journal_data.bestiary_killed_by[45] = journal_data.journal_data.bestiary_killed_by[45] + 1
                    end
                    -- ANUBIS2: 46
                    if responsible.type.id == ENT_TYPE.MONS_ANUBIS2 then
                        if not journal_data.journal_data.bestiary[46] then
                            journal_data.journal_data.bestiary[46] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 45)
                        end  
                        journal_data.journal_data.bestiary_killed_by[46] = journal_data.journal_data.bestiary_killed_by[46] + 1
                    end
                    -- VLAD: 48
                    if responsible.type.id == ENT_TYPE.MONS_VLAD then
                        if not journal_data.journal_data.bestiary[48] then
                            journal_data.journal_data.bestiary[48] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 47)
                        end  
                        journal_data.journal_data.bestiary_killed_by[48] = journal_data.journal_data.bestiary_killed_by[48] + 1
                    end
                    -- IMP: 49
                    if responsible.type.id == ENT_TYPE.MONS_IMP then
                        if not journal_data.journal_data.bestiary[49] then
                            journal_data.journal_data.bestiary[49] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 48)
                        end  
                        journal_data.journal_data.bestiary_killed_by[49] = journal_data.journal_data.bestiary_killed_by[49] + 1
                    end
                elseif type(responsible.user_data) == "table" then -- CUSTOM MONSTERS
                    -- GIANT FROG: 15
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_GIANT_FROG then
                        if not journal_data.journal_data.bestiary[15] then
                            journal_data.journal_data.bestiary[15] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 14)
                        end  
                        journal_data.journal_data.bestiary_killed_by[15] = journal_data.journal_data.bestiary_killed_by[15] + 1
                    end
                    -- PIRANHA: 17
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_PIRANHA then
                        if not journal_data.journal_data.bestiary[17] then
                            journal_data.journal_data.bestiary[17] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 16)
                        end  
                        journal_data.journal_data.bestiary_killed_by[17] = journal_data.journal_data.bestiary_killed_by[17] + 1
                    end  
                    -- GREEN KNIGHT: 26
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_GREEN_KNIGHT then
                        if not journal_data.journal_data.bestiary[26] then
                            journal_data.journal_data.bestiary[26] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 25)
                        end  
                        journal_data.journal_data.bestiary_killed_by[26] = journal_data.journal_data.bestiary_killed_by[26] + 1
                    end
                    -- BLACK KNIGHT: 27
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_BLACK_KNIGHT then
                        if not journal_data.journal_data.bestiary[27] then
                            journal_data.journal_data.bestiary[27] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 26)
                        end  
                        journal_data.journal_data.bestiary_killed_by[27] = journal_data.journal_data.bestiary_killed_by[27] + 1
                    end
                    -- BACTERIUM: 29
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_BACTERIUM then
                        if not journal_data.journal_data.bestiary[29] then
                            journal_data.journal_data.bestiary[29] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 28)
                        end  
                        journal_data.journal_data.bestiary_killed_by[29] = journal_data.journal_data.bestiary_killed_by[29] + 1
                    end
                    -- WORM EGG: 30
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_WORM_EGG then
                        if not journal_data.journal_data.bestiary[30] then
                            journal_data.journal_data.bestiary[30] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 29)
                        end  
                        journal_data.journal_data.bestiary_killed_by[30] = journal_data.journal_data.bestiary_killed_by[30] + 1
                    end
                    -- WORM BABY: 31
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_BABY_WORM then
                        if not journal_data.journal_data.bestiary[31] then
                            journal_data.journal_data.bestiary[31] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 30)
                        end  
                        journal_data.journal_data.bestiary_killed_by[31] = journal_data.journal_data.bestiary_killed_by[31] + 1
                    end
                    -- MAMMOTH: 34
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_MAMMOTH then
                        if not journal_data.journal_data.bestiary[34] then
                            journal_data.journal_data.bestiary[34] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 33)
                        end  
                        journal_data.journal_data.bestiary_killed_by[34] = journal_data.journal_data.bestiary_killed_by[34] + 1
                    end
                    -- ALIENTANK: 37
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_ALIENTANK then
                        if not journal_data.journal_data.bestiary[37] then
                            journal_data.journal_data.bestiary[37] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 36)
                        end  
                        journal_data.journal_data.bestiary_killed_by[37] = journal_data.journal_data.bestiary_killed_by[37] + 1
                    end
                    -- ALIENLORD: 38
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_ALIENLORD then
                        if not journal_data.journal_data.bestiary[38] then
                            journal_data.journal_data.bestiary[38] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 37)
                        end  
                        journal_data.journal_data.bestiary_killed[38] = journal_data.journal_data.bestiary_killed[38] + 1
                    end
                    -- DEVIL: 50
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_DEVIL then
                        if not journal_data.journal_data.bestiary[50] then
                            journal_data.journal_data.bestiary[50] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 49)
                        end  
                        journal_data.journal_data.bestiary_killed_by[50] = journal_data.journal_data.bestiary_killed_by[50] + 1
                    end
                    -- SUCCUBUS: 51
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_SUCCUBUS then
                        if not journal_data.journal_data.bestiary[51] then
                            journal_data.journal_data.bestiary[51] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 50)
                        end  
                        journal_data.journal_data.bestiary_killed_by[51] = journal_data.journal_data.bestiary_killed_by[51] + 1
                    end
                    -- HORSEHEAD / OXFACE: 52, 53
                    if responsible.user_data.ent_type == HD_ENT_TYPE.MONS_HELL_MINIBOSS then
                        if responsible.user_data.is_horsehead then
                            if not journal_data.journal_data.bestiary[52] then
                                journal_data.journal_data.bestiary[52] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 51)
                            end  
                            journal_data.journal_data.bestiary_killed_by[52] = journal_data.journal_data.bestiary_killed_by[52] + 1
                        else
                            if not journal_data.journal_data.bestiary[53] then
                                journal_data.journal_data.bestiary[53] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 52)
                            end  
                            journal_data.journal_data.bestiary_killed_by[53] = journal_data.journal_data.bestiary_killed_by[53] + 1
                        end
                    end
                end
            end)
        end
    end, ON.LEVEL)
    -- Check for ghost kills by seeing if we got the HAUNTED death message
    set_callback(function(string_id)
        local haunted = hash_to_stringid(0x4437f3f7)
        if string_id == haunted then
            if not journal_data.journal_data.bestiary[28] then
                journal_data.journal_data.bestiary[28] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 27)
            end  
            journal_data.journal_data.bestiary_killed_by[28] = journal_data.journal_data.bestiary_killed_by[28] + 1     
        end
    end, ON.DEATH_MESSAGE)
    -- Check for UFO unlock / kill count
    -- UFO: 36
    set_post_entity_spawn(function(self)
        self:set_pre_destroy(function(self)
            if self.last_owner_uid ~= -1 then
                if self.type.id == ENT_TYPE.MONS_UFO then
                    if not journal_data.journal_data.bestiary[36] then
                        journal_data.journal_data.bestiary[36] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 35)
                    end  
                    journal_data.journal_data.bestiary_killed[36] = journal_data.journal_data.bestiary_killed[36] + 1
                end
                if self.type.id == ENT_TYPE.ITEM_EGGSAC then
                    if not journal_data.journal_data.bestiary[30] then
                        journal_data.journal_data.bestiary[30] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 29)
                    end  
                    journal_data.journal_data.bestiary_killed[30] = journal_data.journal_data.bestiary_killed[30] + 1
                end
            end
        end)
    end, SPAWN_TYPE.ANY, MASK.MONSTER, ENT_TYPE.MONS_UFO, ENT_TYPE.ITEM_EGGSAC)
    -- Entries that we want to check with just proximity rather than killing
    set_callback(function()
        for _, player in ipairs(players) do
            player:set_post_update_state_machine(function(self)
                for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_GHOST, ENT_TYPE.MONS_SCARAB, ENT_TYPE.MONS_GOLDMONKEY, ENT_TYPE.MONS_MANTRAP, ENT_TYPE.ITEM_EGGSAC, ENT_TYPE.MONS_MAGMAMAN, ENT_TYPE.ACTIVEFLOOR_OLMEC)) do
                    local ent = get_entity(v)
                    local user_data = nil
                    if type(ent.user_data) == "table" then
                        user_data = ent.user_data
                    end
                    if distance(v, player.uid) < 8 then
                        if ent.type.id == ENT_TYPE.MONS_GHOST then
                            if not journal_data.journal_data.bestiary[28] then
                                journal_data.journal_data.bestiary[28] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 27)
                            end
                        end  
                        if ent.type.id == ENT_TYPE.ACTIVEFLOOR_OLMEC then
                            if not journal_data.journal_data.bestiary[47] then
                                journal_data.journal_data.bestiary[47] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 46)
                            end
                        end    
                        if ent.type.id == ENT_TYPE.MONS_SCARAB then
                            if not journal_data.journal_data.bestiary[11] then
                                journal_data.journal_data.bestiary[11] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 10)
                            end
                        end        
                        if ent.type.id == ENT_TYPE.MONS_GOLDMONKEY then
                            if not journal_data.journal_data.bestiary[23] then
                                journal_data.journal_data.bestiary[23] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 22)
                            end
                        end
                    end
                    if distance(v, player.uid) < 4 then
                        if ent.type.id == ENT_TYPE.ITEM_EGGSAC then
                            if not journal_data.journal_data.bestiary[30] then
                                journal_data.journal_data.bestiary[30] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 29)
                            end
                        end
                        if ent.type.id == ENT_TYPE.MONS_MAGMAMAN then
                            if not journal_data.journal_data.bestiary[42] then
                                journal_data.journal_data.bestiary[42] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 41)
                            end
                        end
                        if user_data ~= nil then
                            if user_data.ent_type == HD_ENT_TYPE.MONS_BACTERIUM then
                                if not journal_data.journal_data.bestiary[29] then
                                    journal_data.journal_data.bestiary[29] = true
                                    show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 28)
                                end                                  
                            end
                        end  
                    end
                end
                -- Check for pet entries if we have one picked up
                if get_entity(player.holding_uid) ~= nil then
                    local held_ent = get_entity(player.holding_uid)
                    if held_ent.type.id == ENT_TYPE.MONS_PET_DOG or held_ent.type.id == ENT_TYPE.MONS_PET_CAT or held_ent.type.id == ENT_TYPE.MONS_PET_HAMSTER then
                        if not journal_data.journal_data.bestiary[7] then
                            journal_data.journal_data.bestiary[7] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.BESTIARY, 6)
                        end                              
                    end
                end
            end)
        end
    end, ON.LEVEL)
    -- ITEMS --

    -- Set a pre-destroy callback for pickups that unlocks based on ENT_TYPE or HD_ENT_TYPE if a player is overlapping with it
    set_post_entity_spawn(function(self)
        self:set_pre_destroy(function(self)
            for _, player in ipairs(players) do
                if player:overlaps_with(self) then
                    -- ROPEPILE: 1
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_ROPEPILE then
                        if not journal_data.journal_data.items[1] then
                            journal_data.journal_data.items[1] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 0)
                        end                             
                    end
                    -- BOMB BAG: 2
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_BOMBBAG then
                        if not journal_data.journal_data.items[2] then
                            journal_data.journal_data.items[2] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 1)
                        end                             
                    end
                    -- BOMB BOX: 3
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_BOMBBOX then
                        if not journal_data.journal_data.items[3] then
                            journal_data.journal_data.items[3] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 2)
                        end                             
                    end
                    -- SPECTACLES: 4
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_SPECTACLES then
                        if not journal_data.journal_data.items[4] then
                            journal_data.journal_data.items[4] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 3)
                        end                             
                    end
                    -- CLIMBING GLOVES: 5
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES then
                        if not journal_data.journal_data.items[5] then
                            journal_data.journal_data.items[5] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 4)
                        end                             
                    end
                    -- PITCHERS MITT: 6
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_PITCHERSMITT then
                        if not journal_data.journal_data.items[6] then
                            journal_data.journal_data.items[6] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 5)
                        end                             
                    end
                    -- SPRING SHOES: 7
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_SPRINGSHOES then
                        if not journal_data.journal_data.items[7] then
                            journal_data.journal_data.items[7] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 6)
                        end                             
                    end
                    -- SPIKE SHOES: 8
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_SPIKESHOES then
                        if not journal_data.journal_data.items[8] then
                            journal_data.journal_data.items[8] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 7)
                        end                             
                    end
                    -- PASTE: 9
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_PASTE then
                        if not journal_data.journal_data.items[9] then
                            journal_data.journal_data.items[9] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 8)
                        end                             
                    end
                    -- COMPASS: 10
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_COMPASS and type(self.user_data) ~= "table" then
                        if not journal_data.journal_data.items[10] then
                            journal_data.journal_data.items[10] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 9)
                        end                             
                    end
                    -- CRYSKNIFE: 14
                    if type(self.user_data) == "table" then
                        if self.user_data.ent_type == HD_ENT_TYPE.ITEM_PICKUP_CRYSKNIFE then
                            if not journal_data.journal_data.items[14] then
                                journal_data.journal_data.items[14] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 13)
                            end                                
                        end
                    end
                    -- PARACHUTE: 21
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_PARACHUTE then
                        if not journal_data.journal_data.items[21] then
                            journal_data.journal_data.items[21] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 20)
                        end                          
                    end
                    -- ROYAL JELLY: 25
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_ROYALJELLY then
                        if not journal_data.journal_data.items[25] then
                            journal_data.journal_data.items[25] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 24)
                        end                             
                    end
                    -- KAPALA: 29
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_KAPALA then
                        if not journal_data.journal_data.items[28] then
                            journal_data.journal_data.items[28] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 27)
                        end                             
                    end
                    -- UDJAT EYE: 29
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_UDJATEYE then
                        if not journal_data.journal_data.items[29] then
                            journal_data.journal_data.items[29] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 28)
                        end                             
                    end
                    -- ANKH: 30
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_ANKH then
                        if not journal_data.journal_data.items[30] then
                            journal_data.journal_data.items[30] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 29)
                        end                             
                    end
                    -- HEDJET: 31
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_HEDJET then
                        if not journal_data.journal_data.items[31] then
                            journal_data.journal_data.items[31] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 30)
                        end                             
                    end
                    -- BOTD: 33
                    if self.type.id == ENT_TYPE.ITEM_PICKUP_TABLETOFDESTINY then
                        if not journal_data.journal_data.items[33] then
                            journal_data.journal_data.items[33] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 32)
                        end                             
                    end
                end
            end
        end)
    end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.ITEM_PICKUP_ROPEPILE, ENT_TYPE.ITEM_PICKUP_BOMBBAG, ENT_TYPE.ITEM_PICKUP_BOMBBOX, ENT_TYPE.ITEM_PICKUP_SPECTACLES, ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES, ENT_TYPE.ITEM_PICKUP_PITCHERSMITT, ENT_TYPE.ITEM_PICKUP_SPRINGSHOES, ENT_TYPE.ITEM_PICKUP_SPIKESHOES, ENT_TYPE.ITEM_PICKUP_PASTE, ENT_TYPE.ITEM_PICKUP_COMPASS, ENT_TYPE.ITEM_PICKUP_ROYALJELLY, ENT_TYPE.ITEM_PICKUP_ANKH, ENT_TYPE.ITEM_PICKUP_HEDJET, ENT_TYPE.ITEM_PICKUP_UDJATEYE, ENT_TYPE.ITEM_PICKUP_KAPALA, ENT_TYPE.ITEM_PICKUP_PARACHUTE, ENT_TYPE.ITEM_PICKUP_TABLETOFDESTINY)
    -- Check what players are holding for journal unlocks
    set_callback(function()
        for _, player in ipairs(players) do
            player:set_post_update_state_machine(function()
                if get_entity(player.holding_uid) ~= nil then
                    local held_item = get_entity(player.holding_uid)
                    -- MATTOCK: 11
                    if held_item.type.id == ENT_TYPE.ITEM_MATTOCK then
                        if not journal_data.journal_data.items[11] then
                            journal_data.journal_data.items[11] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 10)
                        end                          
                    end
                    -- BOOMERANG: 12
                    if held_item.type.id == ENT_TYPE.ITEM_BOOMERANG then
                        if not journal_data.journal_data.items[12] then
                            journal_data.journal_data.items[12] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 11)
                        end                          
                    end
                    -- MACHETE: 13
                    if held_item.type.id == ENT_TYPE.ITEM_MACHETE then
                        if not journal_data.journal_data.items[13] then
                            journal_data.journal_data.items[13] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 12)
                        end                          
                    end
                    -- WEB GUN: 15
                    if held_item.type.id == ENT_TYPE.ITEM_WEBGUN then
                        if not journal_data.journal_data.items[15] then
                            journal_data.journal_data.items[15] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 14)
                        end                          
                    end
                    -- SHOTGUN: 16
                    if held_item.type.id == ENT_TYPE.ITEM_SHOTGUN then
                        if not journal_data.journal_data.items[16] then
                            journal_data.journal_data.items[16] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 15)
                        end                          
                    end
                    -- FREEZE RAY: 17
                    if held_item.type.id == ENT_TYPE.ITEM_FREEZERAY then
                        if not journal_data.journal_data.items[17] then
                            journal_data.journal_data.items[17] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 16)
                        end                          
                    end
                    -- PLASMA CANNON: 18
                    if held_item.type.id == ENT_TYPE.ITEM_PLASMACANNON then
                        if not journal_data.journal_data.items[18] then
                            journal_data.journal_data.items[18] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 17)
                        end                          
                    end
                    -- CAMERA: 19
                    if held_item.type.id == ENT_TYPE.ITEM_CAMERA then
                        if not journal_data.journal_data.items[19] then
                            journal_data.journal_data.items[19] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 18)
                        end                          
                    end
                    -- TELEPORTER: 20
                    if held_item.type.id == ENT_TYPE.ITEM_TELEPORTER then
                        if not journal_data.journal_data.items[20] then
                            journal_data.journal_data.items[20] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 19)
                        end                          
                    end
                    -- SHIELD: 24
                    if held_item.type.id == ENT_TYPE.ITEM_METAL_SHIELD then
                        if not journal_data.journal_data.items[24] then
                            journal_data.journal_data.items[24] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 23)
                        end                          
                    end
                    -- IDOL: 26
                    if held_item.type.id == ENT_TYPE.ITEM_IDOL then
                        if not journal_data.journal_data.items[26] then
                            journal_data.journal_data.items[26] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 25)
                        end                          
                    end
                    -- CRYSTAL SKULL: 27
                    if held_item.type.id == ENT_TYPE.ITEM_MADAMETUSK_IDOL then
                        if not journal_data.journal_data.items[27] then
                            journal_data.journal_data.items[27] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 26)
                        end                          
                    end
                    -- SCEPTER: 32
                    if held_item.type.id == ENT_TYPE.ITEM_SCEPTER then
                        if not journal_data.journal_data.items[32] then
                            journal_data.journal_data.items[32] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 31)
                        end                          
                    end
                    -- EGGPLANT: 36
                    if held_item.type.id == ENT_TYPE.ITEM_EGGPLANT then
                        if not journal_data.journal_data.items[36] then
                            journal_data.journal_data.items[36] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 35)
                        end                          
                    end
                end
                -- Back items
                if get_entity(player:worn_backitem()) ~= nil then
                    local backitem = get_entity(player:worn_backitem())
                    -- CAPE: 22
                    if backitem.type.id == ENT_TYPE.ITEM_CAPE then
                        if not journal_data.journal_data.items[22] then
                            journal_data.journal_data.items[22] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 21)
                        end                          
                    end
                    -- JETPACK: 23
                    if backitem.type.id == ENT_TYPE.ITEM_JETPACK then
                        if not journal_data.journal_data.items[23] then
                            journal_data.journal_data.items[23] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 22)
                        end                          
                    end
                    -- VLADS CAPE: 34
                    if backitem.type.id == ENT_TYPE.ITEM_VLADS_CAPE then
                        if not journal_data.journal_data.items[34] then
                            journal_data.journal_data.items[34] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.ITEMS, 33)
                        end                          
                    end
                end
            end)
        end
    end, ON.LEVEL)
    -- TRAPS --

    -- Proximity based trap unlocks
    set_global_interval(function()
        for _, player in ipairs(players) do
            for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_SPIKES, ENT_TYPE.FLOOR_TOTEM_TRAP, ENT_TYPE.FLOOR_SPRING_TRAP, ENT_TYPE.ITEM_LANDMINE, ENT_TYPE.ITEM_ROCK, ENT_TYPE.LIQUID_WATER, ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, ENT_TYPE.ITEM_LASERBEAM, ENT_TYPE.FLOOR_LION_TRAP, ENT_TYPE.ACTIVEFLOOR_CHAINEDPUSHBLOCK)) do
                local e = get_entity(v)
                -- SPIKES: 1
                if distance(player.uid, v) < 2 and e.type.id == ENT_TYPE.FLOOR_SPIKES then
                    if not journal_data.journal_data.traps[1] then
                        journal_data.journal_data.traps[1] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 0)
                    end    
                end
                -- TIKI TRAP: 5
                if distance(player.uid, v) < 3 and (e.type.id == ENT_TYPE.FLOOR_TOTEM_TRAP) then
                    if not journal_data.journal_data.traps[5] then
                        journal_data.journal_data.traps[5] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 4)
                    end    
                end
                -- ACID: 6
                if distance(player.uid, v) < 1.5 and (e.type.id == ENT_TYPE.LIQUID_WATER) and state.theme == THEME.EGGPLANT_WORLD then
                    if not journal_data.journal_data.traps[6] then
                        journal_data.journal_data.traps[6] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 5)
                    end    
                end                
                -- SPRING: 7
                if distance(player.uid, v) < 1 and (e.type.id == ENT_TYPE.FLOOR_SPRING_TRAP) then
                    if not journal_data.journal_data.traps[7] then
                        journal_data.journal_data.traps[7] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 6)
                    end    
                end
                -- MINE: 8
                if distance(player.uid, v) < 6 and (e.type.id == ENT_TYPE.ITEM_LANDMINE) then
                    if e.timer >= 1 then
                        if not journal_data.journal_data.traps[8] then
                            journal_data.journal_data.traps[8] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 7)
                        end   
                    end 
                end
                -- TURRET: 9
                if distance(player.uid, v) < 3 and (e.type.id == ENT_TYPE.ITEM_ROCK) then
                    if type(e.user_data) == "table" then
                        if e.user_data.ent_type == HD_ENT_TYPE.ITEM_LASER_TURRET then
                            if not journal_data.journal_data.traps[9] then
                                journal_data.journal_data.traps[9] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 8)
                            end                             
                        end
                    end  
                end
                -- FORCEFIELD: 10
                if distance(player.uid, v) < 6 and (e.type.id == ENT_TYPE.ITEM_LASERBEAM) then
                    if not journal_data.journal_data.traps[10] then
                        journal_data.journal_data.traps[10] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 9)
                    end                             
                end
                -- CRUSH TRAP: 11
                if distance(player.uid, v) < 4 and (e.type.id == ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP) then
                    if not journal_data.journal_data.traps[11] then
                        journal_data.journal_data.traps[11] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 10)
                    end                             
                end
                if distance(player.uid, v) < 9 and (e.type.id == ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK or e.type.id == ENT_TYPE.ACTIVEFLOOR_CHAINEDPUSHBLOCK) then
                    if type(e.user_data) == "table" then
                        -- CEILING TRAP: 12
                        if e.user_data.ent_type == HD_ENT_TYPE.ACTIVEFLOOR_CRUSHING_CEILING then
                            if not journal_data.journal_data.traps[12] then
                                journal_data.journal_data.traps[12] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 11)
                            end                             
                        end
                        -- SPIKEBALL TRAP: 13
                        if e.user_data.ent_type == HD_ENT_TYPE.ACTIVEFLOOR_SPIKEBALL_TRAP_BLOCK then
                            if not journal_data.journal_data.traps[13] then
                                journal_data.journal_data.traps[13] = true
                                show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 12)
                            end                             
                        end
                    end  
                end
                -- URAEUS TRAP: 14
                if distance(player.uid, v) < 2 and (e.type.id == ENT_TYPE.FLOOR_LION_TRAP) then
                    if not journal_data.journal_data.traps[14] then
                        journal_data.journal_data.traps[14] = true
                        show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 13)
                    end
                end
            end 
        end    
    end, 10)
    -- Activation based trap unlocks
    set_global_interval(function()
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_ARROW_TRAP)) do
            local a = get_entity(v)
            if a.arrow_shot then
                -- ARROW TRAP: 2
                if not journal_data.journal_data.traps[2] then
                    journal_data.journal_data.traps[2] = true
                    show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 1)
                end
                -- AMMIT TRAP:
                if type(a.user_data) == "table" then
                    if a.user_data.gilded then
                        --[[
                        if not journal_data.journal_data.traps[14] then
                            journal_data.journal_data.traps[14] = true
                            show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 13)
                        end
                        ]]
                    end
                end
            end                   
        end
    end, 10)
    -- POWDER KEG: 3
    set_post_entity_spawn(function(self)
        self:set_post_destroy(function()
            if not journal_data.journal_data.traps[3] then
                journal_data.journal_data.traps[3] = true
                show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 2)
            end              
        end)
    end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.ACTIVEFLOOR_POWDERKEG)
    -- BOULDER: 4
    set_post_entity_spawn(function(self)
        if not journal_data.journal_data.traps[4] then
            journal_data.journal_data.traps[4] = true
            show_journal_popup(JOURNAL_CHAPTER_TYPE.TRAPS, 3)
        end              
    end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.ACTIVEFLOOR_BOULDER)
end

return module