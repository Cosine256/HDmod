local module = {}

local journal_data = require 'journal_data'
local journal_unlocks = require 'journal_unlocks'

-- Setup custom journal
string_ids = -- optimizations: hash_to_stringid only needs to be called once (probably doesn't matter that much)
{
    places_header = hash_to_stringid(0x4f7bcb96),
    people_header = hash_to_stringid(0xe1e4ca91),
    bestiary_header = hash_to_stringid(0x29b133af),
    items_header = hash_to_stringid(0x22712e240),
    traps_header = hash_to_stringid(0x2f3b54fb),
    feats_header = hash_to_stringid(0xff0b67b3),
    page_number = hash_to_stringid(0x00d28a8e),
    defeated = hash_to_stringid(0x039e2f38),
    killed_by = hash_to_stringid(0xa217f155),
    killed = hash_to_stringid(0xfc17292a),
    N_A = hash_to_stringid(0x9a293191),
    journal_get = hash_to_stringid(0xb7fb6d15),
    journal_entry_added = hash_to_stringid(0xbc429789),
}

--thank you mr. auto for this incredibly helpful function!
function setup_page(x, y, render_ctx, page_type, page_number)

    local side_multiply = 1
    local aligment = VANILLA_TEXT_ALIGNMENT.RIGHT
    
    if x > 0 then -- check page side
        side_multiply = -1
        aligment = VANILLA_TEXT_ALIGNMENT.LEFT
    end
    
    if page_number ~= nil then -- draw page number in the corner if needed
        -- format the "Entry {number}"
        -- Get the actual number using our weird fake page id system
        pn_offset = 100
        if page_type == JOURNAL_PAGE_TYPE.PEOPLE then 
            pn_offset = 180
        elseif page_type == JOURNAL_PAGE_TYPE.BESTIARY then
            pn_offset = 300
        elseif page_type == JOURNAL_PAGE_TYPE.ITEMS then
            pn_offset = 400
        elseif page_type == JOURNAL_PAGE_TYPE.TRAPS then
            pn_offset = 500
        end
        text = string.format(get_string(string_ids.page_number), page_number.page_number-pn_offset)
        -- it's a little bit off, but that's the best i could do by eye, not sure if the font is right anyway
        render_ctx:draw_text(text, x + 0.644 * side_multiply, 0.7137 + 0.005 * side_multiply, 0.00093, 0.0005, Color:new(), aligment, VANILLA_FONT_STYLE.ITALIC)
    end
    
    if (page_type >= JOURNAL_PAGE_TYPE.PLACES and page_type <= JOURNAL_PAGE_TYPE.TRAPS) or page_type == JOURNAL_PAGE_TYPE.STORY then
        -- draw the background for the elements on the page
        dest = AABB:new(-3.0, 0.888, 1.0, -0.888)
        if x > 0 then
            dest = AABB:new(-1.0, 0.888, 3.0, -0.888)
        end
        render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_TOP_ENTRY_0, 0, 0, dest, Color:white())
        -- you could potentially draw empty page with just the bow at the top, but that's requires the use of draw_screen_texture with `Quad& source` etc.
        
        header_text = ""
        if page_type == JOURNAL_PAGE_TYPE.BESTIARY then
        
            -- draw background for the Defeated/Killed By Numbers
            dest = Quad:new(AABB:new(-0.898, 0.558, -0.32, 0.053))
            text_x = -0.82
            if x > 0 then -- check page side
                dest = Quad:new(AABB:new(0.26, 0.558, 0.855, 0.053))
                text_x = 0.34
            end
            render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ELEMENTS_0, Quad:new(AABB:new(0.0, 0.35, 0.6, 1.0)), dest, Color:white())
            
            -- draw the "Defeated" and "Killed By" texts
            render_ctx:draw_text(get_string(string_ids.defeated), text_x, 0.4957, 0.0014, 0.0007, Color:new(), VANILLA_TEXT_ALIGNMENT.LEFT, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(get_string(string_ids.killed_by), text_x, 0.2748, 0.0014, 0.0007, Color:new(), VANILLA_TEXT_ALIGNMENT.LEFT, VANILLA_FONT_STYLE.ITALIC)
            
            header_text = get_string(string_ids.bestiary_header)

        -- TODO: add the background textures and other details for all the pages
        elseif page_type == JOURNAL_PAGE_TYPE.PLACES then
            header_text = get_string(string_ids.places_header)
        elseif page_type == JOURNAL_PAGE_TYPE.PEOPLE then
            -- should have almost identical stuff as BESTIARY, but i din't want to write extra logic for character pages etc.
            header_text = get_string(string_ids.people_header)
        elseif page_type == JOURNAL_PAGE_TYPE.ITEMS then
            header_text = get_string(string_ids.items_header)
        elseif page_type == JOURNAL_PAGE_TYPE.TRAPS then
            header_text = get_string(string_ids.traps_header)
        elseif page_type == JOURNAL_PAGE_TYPE.FEATS then
            header_text = get_string(string_ids.feats_header)
        elseif page_type == JOURNAL_PAGE_TYPE.STORY then
            header_text = "Story"
        end
        --Take data from custom_journal_data and display it if its been unlocked
        -- draw the header/title on the red bow
        render_ctx:draw_text(header_text, -1.0 * side_multiply, 0.74, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
        --DRAWING HDMOD CONTENT!!!!
        if page_type == JOURNAL_PAGE_TYPE.PLACES then
            local true_page_number = page_number.page_number-100
            local page_name = journal_data.info.places[true_page_number].name
            local desc1 = journal_data.info.places[true_page_number].desc1
            local desc2 = journal_data.info.places[true_page_number].desc2
            local desc3 = journal_data.info.places[true_page_number].desc3
            local desc4 = journal_data.info.places[true_page_number].desc4
            local desc5 = journal_data.info.places[true_page_number].desc5
            local row = journal_data.info.places[true_page_number].row
            local column = journal_data.info.places[true_page_number].column
            local entry_seen = journal_data.journal_data.places[true_page_number]
            if not entry_seen then
                page_name = hdmod_string.journal.undiscovered.name
                desc1 = hdmod_string.journal.undiscovered.desc1
                desc2 = hdmod_string.journal.undiscovered.desc2
                desc3 = hdmod_string.journal.undiscovered.desc3
                desc4 = hdmod_string.journal.undiscovered.desc4
                desc5 = hdmod_string.journal.undiscovered.desc5
            end
            --text
            render_ctx:draw_text(page_name, -0.25 * side_multiply, -0.12, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            render_ctx:draw_text(desc1, -0.25 * side_multiply, -0.28, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc2, -0.25 * side_multiply, -0.36, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc3, -0.25 * side_multiply, -0.44, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc4, -0.25 * side_multiply, -0.52, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc5, -0.25 * side_multiply, -0.60, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            --background
            if entry_seen then
                dest = AABB:new(-0.925, 0.625, 0.425, 0.025)
                if x > 0 then
                    dest = AABB:new(-0.425, 0.625, 0.925, 0.025)
                end
                render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_PLACE_0, row, column, dest, Color:white())
            end
        elseif page_type == JOURNAL_PAGE_TYPE.PEOPLE and page_number.page_number > 20 then
            local true_page_number = page_number.page_number-200
            local page_name = journal_data.info.people[true_page_number].name
            local desc1 = journal_data.info.people[true_page_number].desc1
            local desc2 = journal_data.info.people[true_page_number].desc2
            local desc3 = journal_data.info.people[true_page_number].desc3
            local desc4 = journal_data.info.people[true_page_number].desc4
            local desc5 = journal_data.info.people[true_page_number].desc5
            local row = journal_data.info.people[true_page_number].row
            local column = journal_data.info.people[true_page_number].column
            local entry_seen = journal_data.journal_data.people[true_page_number]
            if not entry_seen then
                page_name = hdmod_string.journal.undiscovered.name
                desc1 = hdmod_string.journal.undiscovered.desc1
                desc2 = hdmod_string.journal.undiscovered.desc2
                desc3 = hdmod_string.journal.undiscovered.desc3
                desc4 = hdmod_string.journal.undiscovered.desc4
                desc5 = hdmod_string.journal.undiscovered.desc5
            end
            --text
            render_ctx:draw_text(page_name, -0.25 * side_multiply, -0.12, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            render_ctx:draw_text(desc1, -0.25 * side_multiply, -0.28, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc2, -0.25 * side_multiply, -0.36, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc3, -0.25 * side_multiply, -0.44, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc4, -0.25 * side_multiply, -0.52, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc5, -0.25 * side_multiply, -0.60, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            --background
            dest = AABB:new(-0.61, 0.65, 0.14, -0.03)
            if x > 0 then
                dest = AABB:new(-0.14, 0.65, 0.61, -0.03)
            end
            render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_BG_0, 0, 0, dest, Color:white())  
            --character
            --aabb width of 0.3 and aabb height of 0.4 seemed to draw things 1:1 to vanilla journal
            dest = AABB:new(-0.38, 0.35, -0.08, 0.075)
            if x > 0 then
                dest = AABB:new(0.08, 0.35, 0.38, 0.075)
            end
            if entry_seen and not journal_data.info.people[true_page_number].big then
                render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_PEOPLE_0, row, column, dest, Color:white())
            elseif entry_seen then
                dest = AABB:new(-0.17, 0.46, 0.26, 0.075)
                if x > 0 then
                    dest = AABB:new(-0.26, 0.46, 0.17, 0.075)
                end
                render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_PEOPLE_1, row, column, dest, Color:white())
            end
        elseif page_type == JOURNAL_PAGE_TYPE.BESTIARY then
            local true_page_number = page_number.page_number-300
            local page_name = journal_data.info.bestiary[true_page_number].name
            local desc1 = journal_data.info.bestiary[true_page_number].desc1
            local desc2 = journal_data.info.bestiary[true_page_number].desc2
            local desc3 = journal_data.info.bestiary[true_page_number].desc3
            local desc4 = journal_data.info.bestiary[true_page_number].desc4
            local desc5 = journal_data.info.bestiary[true_page_number].desc5
            local row = journal_data.info.bestiary[true_page_number].row
            local column = journal_data.info.bestiary[true_page_number].column
            local bg_row = journal_data.info.bestiary[true_page_number].bg_row
            local bg_column = journal_data.info.bestiary[true_page_number].bg_column
            local texture = journal_data.info.bestiary[true_page_number].texture
            local big = journal_data.info.bestiary[true_page_number].big
            local killed = tostring(journal_data.journal_data.bestiary_killed[true_page_number])
            local killedby = tostring(journal_data.journal_data.bestiary_killed_by[true_page_number])
            local entry_seen = journal_data.journal_data.bestiary[true_page_number]
            if not entry_seen then
                page_name = hdmod_string.journal.undiscovered.name
                desc1 = hdmod_string.journal.undiscovered.desc1
                desc2 = hdmod_string.journal.undiscovered.desc2
                desc3 = hdmod_string.journal.undiscovered.desc3
                desc4 = hdmod_string.journal.undiscovered.desc4
                desc5 = hdmod_string.journal.undiscovered.desc5
            end
            --text
            render_ctx:draw_text(page_name, -0.25 * side_multiply, -0.12, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            render_ctx:draw_text(desc1, -0.25 * side_multiply, -0.28, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc2, -0.25 * side_multiply, -0.36, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc3, -0.25 * side_multiply, -0.44, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc4, -0.25 * side_multiply, -0.52, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc5, -0.25 * side_multiply, -0.60, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            --killed / killed by
            if entry_seen then
                render_ctx:draw_text(killedby, -0.59 * side_multiply, 0.185, 0.00253, 0.001265, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
                render_ctx:draw_text(killed, -0.59 * side_multiply, 0.41, 0.00253, 0.001265, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            end
            --draw background
            dest = AABB:new(-0.33, 0.65, 0.42, -0.03)
            if x > 0 then
                dest = AABB:new(-0.42, 0.65, 0.33, -0.03)
            end
            render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_BG_0, bg_row, bg_column, dest, Color:white())  
            --draw monster 
            if entry_seen then
                dest = AABB:new(-0.08, 0.35, 0.22, 0.075)
                if x > 0 then
                    dest = AABB:new(-0.22, 0.35, 0.08, 0.075)
                end
                if big then
                    dest = AABB:new(-0.17, 0.46, 0.26, 0.075)
                    if x > 0 then
                        dest = AABB:new(-0.26, 0.46, 0.17, 0.075)
                    end
                end
                render_ctx:draw_screen_texture(texture, row, column, dest, Color:white())  
            end
        elseif page_type == JOURNAL_PAGE_TYPE.ITEMS then
            local true_page_number = page_number.page_number-400
            local page_name = c.items[true_page_number].name
            local desc1 = c.items[true_page_number].desc1
            local desc2 = c.items[true_page_number].desc2
            local desc3 = c.items[true_page_number].desc3
            local desc4 = c.items[true_page_number].desc4
            local desc5 = c.items[true_page_number].desc5
            local row = c.items[true_page_number].row
            local column = c.items[true_page_number].column
            local entry_seen = save_data.journal.places[true_page_number]
            if not entry_seen then
                page_name = hdmod_string.journal.undiscovered.name
                desc1 = hdmod_string.journal.undiscovered.desc1
                desc2 = hdmod_string.journal.undiscovered.desc2
                desc3 = hdmod_string.journal.undiscovered.desc3
                desc4 = hdmod_string.journal.undiscovered.desc4
                desc5 = hdmod_string.journal.undiscovered.desc5
            end
            --text
            render_ctx:draw_text(page_name, -0.25 * side_multiply, -0.12, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            render_ctx:draw_text(desc1, -0.25 * side_multiply, -0.28, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc2, -0.25 * side_multiply, -0.36, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc3, -0.25 * side_multiply, -0.44, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc4, -0.25 * side_multiply, -0.52, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc5, -0.25 * side_multiply, -0.60, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            --background
            dest = AABB:new(-0.61, 0.65, 0.14, -0.03)
            if x > 0 then
                dest = AABB:new(-0.14, 0.65, 0.61, -0.03)
            end
            render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_BG_0, 0, 0, dest, Color:white())  
            --character
            --aabb width of 0.3 and aabb height of 0.4 seemed to draw things 1:1 to vanilla journal
            dest = AABB:new(-0.38, 0.35, -0.08, 0.075)
            if x > 0 then
                dest = AABB:new(0.08, 0.35, 0.38, 0.075)
            end
            if entry_seen then
                render_ctx:draw_screen_texture(999, row, column, dest, Color:white())
            end   
        elseif page_type == JOURNAL_PAGE_TYPE.TRAPS then
            local true_page_number = page_number.page_number-500
            local page_name = c.traps[true_page_number].name
            local desc1 = c.traps[true_page_number].desc1
            local desc2 = c.traps[true_page_number].desc2
            local desc3 = c.traps[true_page_number].desc3
            local desc4 = c.traps[true_page_number].desc4
            local desc5 = c.traps[true_page_number].desc5
            local row = c.traps[true_page_number].row
            local column = c.traps[true_page_number].column
            local entry_seen = save_data.journal.places[true_page_number]
            if not entry_seen then
                page_name = hdmod_string.journal.undiscovered.name
                desc1 = hdmod_string.journal.undiscovered.desc1
                desc2 = hdmod_string.journal.undiscovered.desc2
                desc3 = hdmod_string.journal.undiscovered.desc3
                desc4 = hdmod_string.journal.undiscovered.desc4
                desc5 = hdmod_string.journal.undiscovered.desc5
            end
            --text
            render_ctx:draw_text(page_name, -0.25 * side_multiply, -0.12, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            render_ctx:draw_text(desc1, -0.25 * side_multiply, -0.28, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc2, -0.25 * side_multiply, -0.36, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc3, -0.25 * side_multiply, -0.44, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc4, -0.25 * side_multiply, -0.52, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc5, -0.25 * side_multiply, -0.60, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            --background
            dest = AABB:new(-0.61, 0.65, 0.14, -0.03)
            if x > 0 then
                dest = AABB:new(-0.14, 0.65, 0.61, -0.03)
            end
            render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_BG_0, 0, 0, dest, Color:white())  
            --character
            --aabb width of 0.3 and aabb height of 0.4 seemed to draw things 1:1 to vanilla journal
            dest = AABB:new(-0.38, 0.35, -0.08, 0.075)
            if x > 0 then
                dest = AABB:new(0.08, 0.35, 0.38, 0.075)
            end
            if entry_seen then
                render_ctx:draw_screen_texture(999, row, column, dest, Color:white())
            end              
        elseif page_type == JOURNAL_PAGE_TYPE.STORY then
            local true_page_number = page_number.page_number-600
            local page_name = c.story[true_page_number].name
            local desc1 = c.story[true_page_number].desc1
            local desc2 = c.story[true_page_number].desc2
            local desc3 = c.story[true_page_number].desc3
            local desc4 = c.story[true_page_number].desc4
            local desc5 = c.story[true_page_number].desc5
            local row = c.story[true_page_number].row
            local column = c.story[true_page_number].column
            local entry_seen = save_data.journal.places[true_page_number]
            if not entry_seen then
                page_name = hdmod_string.journal.undiscovered.name
                desc1 = hdmod_string.journal.undiscovered.desc1
                desc2 = hdmod_string.journal.undiscovered.desc2
                desc3 = hdmod_string.journal.undiscovered.desc3
                desc4 = hdmod_string.journal.undiscovered.desc4
                desc5 = hdmod_string.journal.undiscovered.desc5
            end
            --text
            render_ctx:draw_text(page_name, -0.25 * side_multiply, -0.12, 0.0022, 0.0011, Color:white(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
            render_ctx:draw_text(desc1, -0.25 * side_multiply, -0.28, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc2, -0.25 * side_multiply, -0.36, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc3, -0.25 * side_multiply, -0.44, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc4, -0.25 * side_multiply, -0.52, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            render_ctx:draw_text(desc5, -0.25 * side_multiply, -0.60, 0.00176, 0.00088, Color:black(), VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.ITALIC)
            --background
            dest = AABB:new(-0.61, 0.65, 0.14, -0.03)
            if x > 0 then
                dest = AABB:new(-0.14, 0.65, 0.61, -0.03)
            end
            render_ctx:draw_screen_texture(TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_BG_0, 0, 0, dest, Color:white())  
            --character
            --aabb width of 0.3 and aabb height of 0.4 seemed to draw things 1:1 to vanilla journal
            dest = AABB:new(-0.38, 0.35, -0.08, 0.075)
            if x > 0 then
                dest = AABB:new(0.08, 0.35, 0.38, 0.075)
            end
            if entry_seen then
                render_ctx:draw_screen_texture(999, row, column, dest, Color:white())
            end               
        end
    end
end
--wipe the existing journal pages and create new pages in their place which we will use as a blank slate for our custom journal stuff
set_callback(function(chapter, pages)
    --i want to go ahead and formally apologize to mr. auto for bastardizing this custom journal code, but basically to get my own pages im
    --creating each group in an offset, arbitrarily giving myself 100 entries per chapter, i will then have to retroactively subtract this offset later on
    --when im indexing these values to get the proper entry
    if chapter == JOURNALUI_PAGE_SHOWN.PLACES then
        pages = {}
        for i=1, 10 do
            pages[i] = 100+i
        end
        return pages
    end
    if chapter == JOURNALUI_PAGE_SHOWN.PEOPLE then
        -- For player skin mod compatability, we are keeping the first 20 entries
        for i=1, 14 do
            pages[i+20] = 200+i
        end
        -- Remove the extra pages
        for i=35, 38 do
            pages[i] = nil
        end
        return pages
    end
    if chapter == JOURNALUI_PAGE_SHOWN.BESTIARY then
        pages = {}
        for i=1, 54 do
            pages[i] = 300+i
        end
        return pages
    end
    if chapter == JOURNALUI_PAGE_SHOWN.ITEMS then
        pages = {}
        for i=1, 2 do
            pages[i] = 400+i
        end
        return pages
    end
    if chapter == JOURNALUI_PAGE_SHOWN.TRAPS then
        pages = {}
        for i=1, 2 do
            pages[i] = 500+i
        end
        return pages
    end
    if chapter == JOURNALUI_PAGE_SHOWN.STORY then
        pages = {}
        for i=1, 2 do
            pages[i] = 600+i
        end
        return pages
    end
end, ON.POST_LOAD_JOURNAL_CHAPTER)
function show_journal_popup(chapter, entry)
    -- Change the string to always say "new journal entry added" instead of "you got the journal!"
    change_string(string_ids.journal_get, get_string(string_ids.journal_entry_added))
    game_manager.save_related.journal_popup_ui.timer = 500
    game_manager.save_related.journal_popup_ui.chapter_to_show = chapter
    game_manager.save_related.journal_popup_ui.entry_to_show = entry
    -- Change it back
    set_timeout(function()
        change_string(string_ids.journal_get, get_string(string_ids.journal_get))
    end, 2)
end
set_callback(function(render_ctx, page_type, page)
    --remove the % completion from the journal
    if page_type == JOURNAL_PAGE_TYPE.JOURNAL_MENU then
        local mpage = page:as_journal_page_journalmenu()
        mpage.completion_badge.x = -10
    end
    x = page.background.x
    y = page.background.y
    if page.page_number > 100 and page.page_number < 200 then
        setup_page(x, y, render_ctx, JOURNAL_PAGE_TYPE.PLACES, page)
    elseif page.page_number > 200 and page.page_number < 300 then
        setup_page(x, y, render_ctx, JOURNAL_PAGE_TYPE.PEOPLE, page)
    elseif page.page_number > 300 and page.page_number < 400  then
        setup_page(x, y, render_ctx, JOURNAL_PAGE_TYPE.BESTIARY, page)
    elseif page.page_number > 400 and page.page_number < 500 then
        setup_page(x, y, render_ctx, JOURNAL_PAGE_TYPE.ITEMS, page)
    elseif page.page_number > 500 and page.page_number < 600  then
        setup_page(x, y, render_ctx, JOURNAL_PAGE_TYPE.TRAPS, page)
    elseif page.page_number > 600 and page.page_number < 700  then
        setup_page(x, y, render_ctx, JOURNAL_PAGE_TYPE.STORY, page)
    end
end, ON.RENDER_POST_JOURNAL_PAGE)
-- Run checks for journal unlocks
journal_unlocks.check_for_journal_unlocks(journal_data)

return module