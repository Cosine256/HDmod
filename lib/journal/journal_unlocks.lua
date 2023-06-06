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
    -- PLACES
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
end

return module