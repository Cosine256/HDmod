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
        -- SHOPKEEPER
        {
            name = hdmod_string.journal.people.shopkeeper.name;
            desc1 = hdmod_string.journal.people.shopkeeper.desc1;
            desc2 = hdmod_string.journal.people.shopkeeper.desc2;
            desc3 = hdmod_string.journal.people.shopkeeper.desc3;
            desc4 = hdmod_string.journal.people.shopkeeper.desc4;
            desc5 = hdmod_string.journal.people.shopkeeper.desc5;
            column = 2;
            row = 2;
            big = false; -- If we should use TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_PEOPLE_1 instead
        };  
        -- YANG
        {
            name = hdmod_string.journal.people.yang.name;
            desc1 = hdmod_string.journal.people.yang.desc1;
            desc2 = hdmod_string.journal.people.yang.desc2;
            desc3 = hdmod_string.journal.people.yang.desc3;
            desc4 = hdmod_string.journal.people.yang.desc4;
            desc5 = hdmod_string.journal.people.yang.desc5;
            column = 4;
            row = 2;
            big = false;
        };   
        -- HIRED HAND
        {
            name = hdmod_string.journal.people.hired_hand.name;
            desc1 = hdmod_string.journal.people.hired_hand.desc1;
            desc2 = hdmod_string.journal.people.hired_hand.desc2;
            desc3 = hdmod_string.journal.people.hired_hand.desc3;
            desc4 = hdmod_string.journal.people.hired_hand.desc4;
            desc5 = hdmod_string.journal.people.hired_hand.desc5;
            column = 0;
            row = 2;
            big = false;
        };  
        -- TERRA TUNNEL
        {
            name = hdmod_string.journal.people.terra_tunnel.name;
            desc1 = hdmod_string.journal.people.terra_tunnel.desc1;
            desc2 = hdmod_string.journal.people.terra_tunnel.desc2;
            desc3 = hdmod_string.journal.people.terra_tunnel.desc3;
            desc4 = hdmod_string.journal.people.terra_tunnel.desc4;
            desc5 = hdmod_string.journal.people.terra_tunnel.desc5;
            column = 0;
            row = 4;
            big = false;
        };   
        -- VIKING
        {
            name = hdmod_string.journal.people.viking.name;
            desc1 = hdmod_string.journal.people.viking.desc1;
            desc2 = hdmod_string.journal.people.viking.desc2;
            desc3 = hdmod_string.journal.people.viking.desc3;
            desc4 = hdmod_string.journal.people.viking.desc4;
            desc5 = hdmod_string.journal.people.viking.desc5;
            column = 1;
            row = 3;
            big = false;
        };  
        -- MEAT MAN
        {
            name = hdmod_string.journal.people.meat_boy.name;
            desc1 = hdmod_string.journal.people.meat_boy.desc1;
            desc2 = hdmod_string.journal.people.meat_boy.desc2;
            desc3 = hdmod_string.journal.people.meat_boy.desc3;
            desc4 = hdmod_string.journal.people.meat_boy.desc4;
            desc5 = hdmod_string.journal.people.meat_boy.desc5;
            column = 2;
            row = 3;
            big = false;
        }; 
         -- INUK
         {
            name = hdmod_string.journal.people.inuk.name;
            desc1 = hdmod_string.journal.people.inuk.desc1;
            desc2 = hdmod_string.journal.people.inuk.desc2;
            desc3 = hdmod_string.journal.people.inuk.desc3;
            desc4 = hdmod_string.journal.people.inuk.desc4;
            desc5 = hdmod_string.journal.people.inuk.desc5;
            column = 6;
            row = 2;
            big = false;
        };   
         -- AZTEC
         {
            name = hdmod_string.journal.people.aztec.name;
            desc1 = hdmod_string.journal.people.aztec.desc1;
            desc2 = hdmod_string.journal.people.aztec.desc2;
            desc3 = hdmod_string.journal.people.aztec.desc3;
            desc4 = hdmod_string.journal.people.aztec.desc4;
            desc5 = hdmod_string.journal.people.aztec.desc5;
            column = 7;
            row = 2;
            big = false;
        };   
         -- MARIACHI
         {
            name = hdmod_string.journal.people.mariachi.name;
            desc1 = hdmod_string.journal.people.mariachi.desc1;
            desc2 = hdmod_string.journal.people.mariachi.desc2;
            desc3 = hdmod_string.journal.people.mariachi.desc3;
            desc4 = hdmod_string.journal.people.mariachi.desc4;
            desc5 = hdmod_string.journal.people.mariachi.desc5;
            column = 8;
            row = 2;
            big = false;
        };   
         -- BLACK
         {
            name = hdmod_string.journal.people.black.name;
            desc1 = hdmod_string.journal.people.black.desc1;
            desc2 = hdmod_string.journal.people.black.desc2;
            desc3 = hdmod_string.journal.people.black.desc3;
            desc4 = hdmod_string.journal.people.black.desc4;
            desc5 = hdmod_string.journal.people.black.desc5;
            column = 5;
            row = 2;
            big = false;
        };   
         -- CARL
         {
            name = hdmod_string.journal.people.carl.name;
            desc1 = hdmod_string.journal.people.carl.desc1;
            desc2 = hdmod_string.journal.people.carl.desc2;
            desc3 = hdmod_string.journal.people.carl.desc3;
            desc4 = hdmod_string.journal.people.carl.desc4;
            desc5 = hdmod_string.journal.people.carl.desc5;
            column = 3;
            row = 3;
            big = false;
        };   
         -- ROBOT
         {
            name = hdmod_string.journal.people.robot.name;
            desc1 = hdmod_string.journal.people.robot.desc1;
            desc2 = hdmod_string.journal.people.robot.desc2;
            desc3 = hdmod_string.journal.people.robot.desc3;
            desc4 = hdmod_string.journal.people.robot.desc4;
            desc5 = hdmod_string.journal.people.robot.desc5;
            column = 3;
            row = 4;
            big = false;
        }; 
         -- GUSTAF
         {
            name = hdmod_string.journal.people.gustaf.name;
            desc1 = hdmod_string.journal.people.gustaf.desc1;
            desc2 = hdmod_string.journal.people.gustaf.desc2;
            desc3 = hdmod_string.journal.people.gustaf.desc3;
            desc4 = hdmod_string.journal.people.gustaf.desc4;
            desc5 = hdmod_string.journal.people.gustaf.desc5;
            column = 2;
            row = 4;
            big = false;
        }; 
         -- BEARGUY
         {
            name = hdmod_string.journal.people.bearguy.name;
            desc1 = hdmod_string.journal.people.bearguy.desc1;
            desc2 = hdmod_string.journal.people.bearguy.desc2;
            desc3 = hdmod_string.journal.people.bearguy.desc3;
            desc4 = hdmod_string.journal.people.bearguy.desc4;
            desc5 = hdmod_string.journal.people.bearguy.desc5;
            column = 1;
            row = 4;
            big = false;
        };    
    };
    bestiary = {
        -- SNAKE
        {
            name = hdmod_string.journal.bestiary.snake.name;
            desc1 = hdmod_string.journal.bestiary.snake.desc1;
            desc2 = hdmod_string.journal.bestiary.snake.desc2;
            desc3 = hdmod_string.journal.bestiary.snake.desc3;
            desc4 = hdmod_string.journal.bestiary.snake.desc4;
            desc5 = hdmod_string.journal.bestiary.snake.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 0;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false; --draws texture at 2x size
        };
        -- COBRA
        {
            name = hdmod_string.journal.bestiary.cobra.name;
            desc1 = hdmod_string.journal.bestiary.cobra.desc1;
            desc2 = hdmod_string.journal.bestiary.cobra.desc2;
            desc3 = hdmod_string.journal.bestiary.cobra.desc3;
            desc4 = hdmod_string.journal.bestiary.cobra.desc4;
            desc5 = hdmod_string.journal.bestiary.cobra.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 0;
            row = 2;
            bg_column = 0;
            bg_row = 0;
            big = false; --draws texture at 2x size
        };
        -- SPIDER
        {
            name = hdmod_string.journal.bestiary.spider.name;
            desc1 = hdmod_string.journal.bestiary.spider.desc1;
            desc2 = hdmod_string.journal.bestiary.spider.desc2;
            desc3 = hdmod_string.journal.bestiary.spider.desc3;
            desc4 = hdmod_string.journal.bestiary.spider.desc4;
            desc5 = hdmod_string.journal.bestiary.spider.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 1;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- HANG SPIDER
        {
            name = hdmod_string.journal.bestiary.hang_spider.name;
            desc1 = hdmod_string.journal.bestiary.hang_spider.desc1;
            desc2 = hdmod_string.journal.bestiary.hang_spider.desc2;
            desc3 = hdmod_string.journal.bestiary.hang_spider.desc3;
            desc4 = hdmod_string.journal.bestiary.hang_spider.desc4;
            desc5 = hdmod_string.journal.bestiary.hang_spider.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 2;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- BAT
        {
            name = hdmod_string.journal.bestiary.bat.name;
            desc1 = hdmod_string.journal.bestiary.bat.desc1;
            desc2 = hdmod_string.journal.bestiary.bat.desc2;
            desc3 = hdmod_string.journal.bestiary.bat.desc3;
            desc4 = hdmod_string.journal.bestiary.bat.desc4;
            desc5 = hdmod_string.journal.bestiary.bat.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 3;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- CAVEMAN
        {
            name = hdmod_string.journal.bestiary.caveman.name;
            desc1 = hdmod_string.journal.bestiary.caveman.desc1;
            desc2 = hdmod_string.journal.bestiary.caveman.desc2;
            desc3 = hdmod_string.journal.bestiary.caveman.desc3;
            desc4 = hdmod_string.journal.bestiary.caveman.desc4;
            desc5 = hdmod_string.journal.bestiary.caveman.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 4;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- SCORPION
        {
            name = hdmod_string.journal.bestiary.scorpion.name;
            desc1 = hdmod_string.journal.bestiary.scorpion.desc1;
            desc2 = hdmod_string.journal.bestiary.scorpion.desc2;
            desc3 = hdmod_string.journal.bestiary.scorpion.desc3;
            desc4 = hdmod_string.journal.bestiary.scorpion.desc4;
            desc5 = hdmod_string.journal.bestiary.scorpion.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 6;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- SKELETON
        {
            name = hdmod_string.journal.bestiary.skeleton.name;
            desc1 = hdmod_string.journal.bestiary.skeleton.desc1;
            desc2 = hdmod_string.journal.bestiary.skeleton.desc2;
            desc3 = hdmod_string.journal.bestiary.skeleton.desc3;
            desc4 = hdmod_string.journal.bestiary.skeleton.desc4;
            desc5 = hdmod_string.journal.bestiary.skeleton.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 5;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
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
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
    };
    bestiary = {
        false;
        false;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
        true;
    };
    bestiary_killed = {
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
    };
    bestiary_killed_by = {
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
        0;
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