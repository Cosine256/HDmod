--text and icon drawing info for the custom journal, the bool for having an entry unlocked is in save.dat / save.lua, as well as killed / killed by
local module = {}
module.info = { -- This table is just info for drawing the text and textures for the journal entries
    --since we wanna index through this data using numbers (page number) we cant name it. not sure if its a lua quirk if im just an idiot BUT WERE GOING WITH IT!
    places = {
        -- THE MINES
        {
            name = hdmod_string.journal.places.mines.name;
            desc1 = hdmod_string.journal.places.mines.desc1;
            desc2 = hdmod_string.journal.places.mines.desc2;
            desc3 = hdmod_string.journal.places.mines.desc3;
            desc4 = hdmod_string.journal.places.mines.desc4;
            desc5 = hdmod_string.journal.places.mines.desc5;
            column = 0;
            row = 0;
        };
        -- JUNGLE
        {
            name = hdmod_string.journal.places.jungle.name;
            desc1 = hdmod_string.journal.places.jungle.desc1;
            desc2 = hdmod_string.journal.places.jungle.desc2;
            desc3 = hdmod_string.journal.places.jungle.desc3;
            desc4 = hdmod_string.journal.places.jungle.desc4;
            desc5 = hdmod_string.journal.places.jungle.desc5;
            column = 1;
            row = 0;
        };
        -- BLACK MARKET
        {
            name = hdmod_string.journal.places.black_market.name;
            desc1 = hdmod_string.journal.places.black_market.desc1;
            desc2 = hdmod_string.journal.places.black_market.desc2;
            desc3 = hdmod_string.journal.places.black_market.desc3;
            desc4 = hdmod_string.journal.places.black_market.desc4;
            desc5 = hdmod_string.journal.places.black_market.desc5;
            column = 1;
            row = 0;
        };
        -- WORM
        {
            name = hdmod_string.journal.places.the_worm.name;
            desc1 = hdmod_string.journal.places.the_worm.desc1;
            desc2 = hdmod_string.journal.places.the_worm.desc2;
            desc3 = hdmod_string.journal.places.the_worm.desc3;
            desc4 = hdmod_string.journal.places.the_worm.desc4;
            desc5 = hdmod_string.journal.places.the_worm.desc5;
            column = 0;
            row = 2;
        };
        -- HAUNTED CASTLE
        {
            name = hdmod_string.journal.places.haunted_castle.name;
            desc1 = hdmod_string.journal.places.haunted_castle.desc1;
            desc2 = hdmod_string.journal.places.haunted_castle.desc2;
            desc3 = hdmod_string.journal.places.haunted_castle.desc3;
            desc4 = hdmod_string.journal.places.haunted_castle.desc4;
            desc5 = hdmod_string.journal.places.haunted_castle.desc5;
            column = 3;
            row = 2;
        };
        -- ICE CAVES
        {
            name = hdmod_string.journal.places.ice_caves.name;
            desc1 = hdmod_string.journal.places.ice_caves.desc1;
            desc2 = hdmod_string.journal.places.ice_caves.desc2;
            desc3 = hdmod_string.journal.places.ice_caves.desc3;
            desc4 = hdmod_string.journal.places.ice_caves.desc4;
            desc5 = hdmod_string.journal.places.ice_caves.desc5;
            column = 2;
            row = 1;
        };
        -- MOTHERSHIP
        {
            name = hdmod_string.journal.places.mothership.name;
            desc1 = hdmod_string.journal.places.mothership.desc1;
            desc2 = hdmod_string.journal.places.mothership.desc2;
            desc3 = hdmod_string.journal.places.mothership.desc3;
            desc4 = hdmod_string.journal.places.mothership.desc4;
            desc5 = hdmod_string.journal.places.mothership.desc5;
            column = 3;
            row = 1;
        };
        -- TEMPLE
        {
            name = hdmod_string.journal.places.temple.name;
            desc1 = hdmod_string.journal.places.temple.desc1;
            desc2 = hdmod_string.journal.places.temple.desc2;
            desc3 = hdmod_string.journal.places.temple.desc3;
            desc4 = hdmod_string.journal.places.temple.desc4;
            desc5 = hdmod_string.journal.places.temple.desc5;
            column = 1;
            row = 1;
        };
        -- CITY OF GOLD
        {
            name = hdmod_string.journal.places.city_of_gold.name;
            desc1 = hdmod_string.journal.places.city_of_gold.desc1;
            desc2 = hdmod_string.journal.places.city_of_gold.desc2;
            desc3 = hdmod_string.journal.places.city_of_gold.desc3;
            desc4 = hdmod_string.journal.places.city_of_gold.desc4;
            desc5 = hdmod_string.journal.places.city_of_gold.desc5;
            column = 2;
            row = 2;
        };
        -- HELL
        {
            name = hdmod_string.journal.places.hell.name;
            desc1 = hdmod_string.journal.places.hell.desc1;
            desc2 = hdmod_string.journal.places.hell.desc2;
            desc3 = hdmod_string.journal.places.hell.desc3;
            desc4 = hdmod_string.journal.places.hell.desc4;
            desc5 = hdmod_string.journal.places.hell.desc5;
            column = 2;
            row = 0;
        };        
    };
    people = {
    };
    items = {
    };
    traps = {
    };
    story = {
    };
}
module.journal_data = nil
local default_journal_data = {
    places = {
        false;
        false;
        false;
        false;
        false;
        false;
        false;
        false;
        false;
        false;
    };
    people = {
    };
    bestiary = {
    };
    bestiary_killed = {
    };
    bestiary_killed_by = {
    };
    items = {
    };
    traps = {
    };
    story = {
    };
}
savelib.register_save_callback(function(save_data)
    -- Store the journal save data
    save_data.journal = module.journal_data
end)
savelib.register_load_callback(function(load_data)
    -- Grab the journal save data table if it exists
    if load_data.journal then
        module.journal_data = load_data.journal
    else
        module.journal_data = default_journal_data
    end
end)
return module