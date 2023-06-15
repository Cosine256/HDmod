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
        -- OLMEC
        {
            name = hdmod_string.journal.places.olmec.name;
            desc1 = hdmod_string.journal.places.olmec.desc1;
            desc2 = hdmod_string.journal.places.olmec.desc2;
            desc3 = hdmod_string.journal.places.olmec.desc3;
            desc4 = hdmod_string.journal.places.olmec.desc4;
            desc5 = hdmod_string.journal.places.olmec.desc5;
            column = 3;
            row = 0;
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
        -- YAMA
        {
            name = hdmod_string.journal.places.yama.name;
            desc1 = hdmod_string.journal.places.yama.desc1;
            desc2 = hdmod_string.journal.places.yama.desc2;
            desc3 = hdmod_string.journal.places.yama.desc3;
            desc4 = hdmod_string.journal.places.yama.desc4;
            desc5 = hdmod_string.journal.places.yama.desc5;
            column = 2;
            row = 3;
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
        -- SNAKE: 1
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
        -- COBRA: 2
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
            big = false;
        };
        -- SPIDER: 3
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
        -- HANG SPIDER: 4
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
        -- BAT: 5
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
        -- CAVEMAN: 6
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
        -- PETS: 7
        {
            name = hdmod_string.journal.bestiary.damsels.name;
            desc1 = hdmod_string.journal.bestiary.damsels.desc1;
            desc2 = hdmod_string.journal.bestiary.damsels.desc2;
            desc3 = hdmod_string.journal.bestiary.damsels.desc3;
            desc4 = hdmod_string.journal.bestiary.damsels.desc4;
            desc5 = hdmod_string.journal.bestiary.damsels.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 0;
            row = 2;
            bg_column = 0;
            bg_row = 0;
            big = true;
        };
        -- GIANT SPIDER: 8
        {
            name = hdmod_string.journal.bestiary.giant_spider.name;
            desc1 = hdmod_string.journal.bestiary.giant_spider.desc1;
            desc2 = hdmod_string.journal.bestiary.giant_spider.desc2;
            desc3 = hdmod_string.journal.bestiary.giant_spider.desc3;
            desc4 = hdmod_string.journal.bestiary.giant_spider.desc4;
            desc5 = hdmod_string.journal.bestiary.giant_spider.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 1;
            row = 2;
            bg_column = 0;
            bg_row = 0;
            big = true;
        };
        -- SCORPION: 9
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
        -- SKELETON: 10
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
        -- SCARAB: 11
        {
            name = hdmod_string.journal.bestiary.scarab.name;
            desc1 = hdmod_string.journal.bestiary.scarab.desc1;
            desc2 = hdmod_string.journal.bestiary.scarab.desc2;
            desc3 = hdmod_string.journal.bestiary.scarab.desc3;
            desc4 = hdmod_string.journal.bestiary.scarab.desc4;
            desc5 = hdmod_string.journal.bestiary.scarab.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 3;
            row = 3;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- TIKIMAN: 12
        {
            name = hdmod_string.journal.bestiary.tikiman.name;
            desc1 = hdmod_string.journal.bestiary.tikiman.desc1;
            desc2 = hdmod_string.journal.bestiary.tikiman.desc2;
            desc3 = hdmod_string.journal.bestiary.tikiman.desc3;
            desc4 = hdmod_string.journal.bestiary.tikiman.desc4;
            desc5 = hdmod_string.journal.bestiary.tikiman.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 9;
            row = 0;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- FROG: 13
        {
            name = hdmod_string.journal.bestiary.frog.name;
            desc1 = hdmod_string.journal.bestiary.frog.desc1;
            desc2 = hdmod_string.journal.bestiary.frog.desc2;
            desc3 = hdmod_string.journal.bestiary.frog.desc3;
            desc4 = hdmod_string.journal.bestiary.frog.desc4;
            desc5 = hdmod_string.journal.bestiary.frog.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 2;
            row = 4;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- FIRE FROG: 14
        {
            name = hdmod_string.journal.bestiary.fire_frog.name;
            desc1 = hdmod_string.journal.bestiary.fire_frog.desc1;
            desc2 = hdmod_string.journal.bestiary.fire_frog.desc2;
            desc3 = hdmod_string.journal.bestiary.fire_frog.desc3;
            desc4 = hdmod_string.journal.bestiary.fire_frog.desc4;
            desc5 = hdmod_string.journal.bestiary.fire_frog.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 3;
            row = 4;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- GIANT FROG: 15
        {
            name = hdmod_string.journal.bestiary.giant_frog.name;
            desc1 = hdmod_string.journal.bestiary.giant_frog.desc1;
            desc2 = hdmod_string.journal.bestiary.giant_frog.desc2;
            desc3 = hdmod_string.journal.bestiary.giant_frog.desc3;
            desc4 = hdmod_string.journal.bestiary.giant_frog.desc4;
            desc5 = hdmod_string.journal.bestiary.giant_frog.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 0;
            row = 0;
            bg_column = 1;
            bg_row = 0;
            big = true;
        };
        -- MANTRAP: 16
        {
            name = hdmod_string.journal.bestiary.mantrap.name;
            desc1 = hdmod_string.journal.bestiary.mantrap.desc1;
            desc2 = hdmod_string.journal.bestiary.mantrap.desc2;
            desc3 = hdmod_string.journal.bestiary.mantrap.desc3;
            desc4 = hdmod_string.journal.bestiary.mantrap.desc4;
            desc5 = hdmod_string.journal.bestiary.mantrap.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 8;
            row = 0;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- PIRANHA: 17
        {
            name = hdmod_string.journal.bestiary.piranha.name;
            desc1 = hdmod_string.journal.bestiary.piranha.desc1;
            desc2 = hdmod_string.journal.bestiary.piranha.desc2;
            desc3 = hdmod_string.journal.bestiary.piranha.desc3;
            desc4 = hdmod_string.journal.bestiary.piranha.desc4;
            desc5 = hdmod_string.journal.bestiary.piranha.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 4;
            row = 2;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- GREAT HUMPHEAD: 18
        {
            name = hdmod_string.journal.bestiary.great_humphead.name;
            desc1 = hdmod_string.journal.bestiary.great_humphead.desc1;
            desc2 = hdmod_string.journal.bestiary.great_humphead.desc2;
            desc3 = hdmod_string.journal.bestiary.great_humphead.desc3;
            desc4 = hdmod_string.journal.bestiary.great_humphead.desc4;
            desc5 = hdmod_string.journal.bestiary.great_humphead.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 2;
            row = 3;
            bg_column = 1;
            bg_row = 0;
            big = 2;
        };
        -- BEE: 19
        {
            name = hdmod_string.journal.bestiary.bee.name;
            desc1 = hdmod_string.journal.bestiary.bee.desc1;
            desc2 = hdmod_string.journal.bestiary.bee.desc2;
            desc3 = hdmod_string.journal.bestiary.bee.desc3;
            desc4 = hdmod_string.journal.bestiary.bee.desc4;
            desc5 = hdmod_string.journal.bestiary.bee.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 2;
            row = 3;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- QUEEN BEE: 20
        {
            name = hdmod_string.journal.bestiary.queen_bee.name;
            desc1 = hdmod_string.journal.bestiary.queen_bee.desc1;
            desc2 = hdmod_string.journal.bestiary.queen_bee.desc2;
            desc3 = hdmod_string.journal.bestiary.queen_bee.desc3;
            desc4 = hdmod_string.journal.bestiary.queen_bee.desc4;
            desc5 = hdmod_string.journal.bestiary.queen_bee.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 0;
            row = 1;
            bg_column = 1;
            bg_row = 0;
            big = true;
        };
        -- SNAIL: 21
        {
            name = hdmod_string.journal.bestiary.snail.name;
            desc1 = hdmod_string.journal.bestiary.snail.desc1;
            desc2 = hdmod_string.journal.bestiary.snail.desc2;
            desc3 = hdmod_string.journal.bestiary.snail.desc3;
            desc4 = hdmod_string.journal.bestiary.snail.desc4;
            desc5 = hdmod_string.journal.bestiary.snail.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 6;
            row = 2;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- MONKEY: 22
        {
            name = hdmod_string.journal.bestiary.monkey.name;
            desc1 = hdmod_string.journal.bestiary.monkey.desc1;
            desc2 = hdmod_string.journal.bestiary.monkey.desc2;
            desc3 = hdmod_string.journal.bestiary.monkey.desc3;
            desc4 = hdmod_string.journal.bestiary.monkey.desc4;
            desc5 = hdmod_string.journal.bestiary.monkey.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 2;
            row = 1;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- GOLDEN MONKEY: 23
        {
            name = hdmod_string.journal.bestiary.golden_monkey.name;
            desc1 = hdmod_string.journal.bestiary.golden_monkey.desc1;
            desc2 = hdmod_string.journal.bestiary.golden_monkey.desc2;
            desc3 = hdmod_string.journal.bestiary.golden_monkey.desc3;
            desc4 = hdmod_string.journal.bestiary.golden_monkey.desc4;
            desc5 = hdmod_string.journal.bestiary.golden_monkey.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 6;
            row = 3;
            bg_column = 1;
            bg_row = 0;
            big = false;
        };
        -- JIANGSHI: 24
        {
            name = hdmod_string.journal.bestiary.jiangshi.name;
            desc1 = hdmod_string.journal.bestiary.jiangshi.desc1;
            desc2 = hdmod_string.journal.bestiary.jiangshi.desc2;
            desc3 = hdmod_string.journal.bestiary.jiangshi.desc3;
            desc4 = hdmod_string.journal.bestiary.jiangshi.desc4;
            desc5 = hdmod_string.journal.bestiary.jiangshi.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 3;
            row = 2;
            bg_column = 3;
            bg_row = 0;
            big = false;
        };
        -- VAMPIRE: 25
        {
            name = hdmod_string.journal.bestiary.vampire.name;
            desc1 = hdmod_string.journal.bestiary.vampire.desc1;
            desc2 = hdmod_string.journal.bestiary.vampire.desc2;
            desc3 = hdmod_string.journal.bestiary.vampire.desc3;
            desc4 = hdmod_string.journal.bestiary.vampire.desc4;
            desc5 = hdmod_string.journal.bestiary.vampire.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 7;
            row = 1;
            bg_column = 3;
            bg_row = 0;
            big = false;
        };
        -- GREEN KNIGHT: 26
        {
            name = hdmod_string.journal.bestiary.green_knight.name;
            desc1 = hdmod_string.journal.bestiary.green_knight.desc1;
            desc2 = hdmod_string.journal.bestiary.green_knight.desc2;
            desc3 = hdmod_string.journal.bestiary.green_knight.desc3;
            desc4 = hdmod_string.journal.bestiary.green_knight.desc4;
            desc5 = hdmod_string.journal.bestiary.green_knight.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 7;
            row = 0;
            bg_column = 3;
            bg_row = 0;
            big = false;
        };
        -- BLACK KNIGHT: 27
        {
            name = hdmod_string.journal.bestiary.black_knight.name;
            desc1 = hdmod_string.journal.bestiary.black_knight.desc1;
            desc2 = hdmod_string.journal.bestiary.black_knight.desc2;
            desc3 = hdmod_string.journal.bestiary.black_knight.desc3;
            desc4 = hdmod_string.journal.bestiary.black_knight.desc4;
            desc5 = hdmod_string.journal.bestiary.black_knight.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 0;
            row = 1;
            bg_column = 3;
            bg_row = 0;
            big = false;
        };
        -- THE GHOST: 28
        {
            name = hdmod_string.journal.bestiary.ghost.name;
            desc1 = hdmod_string.journal.bestiary.ghost.desc1;
            desc2 = hdmod_string.journal.bestiary.ghost.desc2;
            desc3 = hdmod_string.journal.bestiary.ghost.desc3;
            desc4 = hdmod_string.journal.bestiary.ghost.desc4;
            desc5 = hdmod_string.journal.bestiary.ghost.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 1;
            row = 1;
            bg_column = 3;
            bg_row = 0;
            big = 2;
        };
        -- BACTERIUM: 29
        {
            name = hdmod_string.journal.bestiary.bacterium.name;
            desc1 = hdmod_string.journal.bestiary.bacterium.desc1;
            desc2 = hdmod_string.journal.bestiary.bacterium.desc2;
            desc3 = hdmod_string.journal.bestiary.bacterium.desc3;
            desc4 = hdmod_string.journal.bestiary.bacterium.desc4;
            desc5 = hdmod_string.journal.bestiary.bacterium.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 8;
            row = 3;
            bg_column = 3;
            bg_row = 3;
            big = false;
        };
        -- WORM EGG: 30
        {
            name = hdmod_string.journal.bestiary.worm_egg.name;
            desc1 = hdmod_string.journal.bestiary.worm_egg.desc1;
            desc2 = hdmod_string.journal.bestiary.worm_egg.desc2;
            desc3 = hdmod_string.journal.bestiary.worm_egg.desc3;
            desc4 = hdmod_string.journal.bestiary.worm_egg.desc4;
            desc5 = hdmod_string.journal.bestiary.worm_egg.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 1;
            row = 1;
            bg_column = 3;
            bg_row = 3;
            big = false;
        };
        -- WORM BABY: 31
        {
            name = hdmod_string.journal.bestiary.worm_baby.name;
            desc1 = hdmod_string.journal.bestiary.worm_baby.desc1;
            desc2 = hdmod_string.journal.bestiary.worm_baby.desc2;
            desc3 = hdmod_string.journal.bestiary.worm_baby.desc3;
            desc4 = hdmod_string.journal.bestiary.worm_baby.desc4;
            desc5 = hdmod_string.journal.bestiary.worm_baby.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 4;
            row = 1;
            bg_column = 3;
            bg_row = 3;
            big = false;
        };
        -- YETI: 32
        {
            name = hdmod_string.journal.bestiary.yeti.name;
            desc1 = hdmod_string.journal.bestiary.yeti.desc1;
            desc2 = hdmod_string.journal.bestiary.yeti.desc2;
            desc3 = hdmod_string.journal.bestiary.yeti.desc3;
            desc4 = hdmod_string.journal.bestiary.yeti.desc4;
            desc5 = hdmod_string.journal.bestiary.yeti.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 9;
            row = 2;
            bg_column = 2;
            bg_row = 1;
            big = false;
        };
        -- YETI KING: 33
        {
            name = hdmod_string.journal.bestiary.yeti_king.name;
            desc1 = hdmod_string.journal.bestiary.yeti_king.desc1;
            desc2 = hdmod_string.journal.bestiary.yeti_king.desc2;
            desc3 = hdmod_string.journal.bestiary.yeti_king.desc3;
            desc4 = hdmod_string.journal.bestiary.yeti_king.desc4;
            desc5 = hdmod_string.journal.bestiary.yeti_king.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 3;
            row = 1;
            bg_column = 2;
            bg_row = 1;
            big = true;
        };
        -- MAMMOTH: 34
        {
            name = hdmod_string.journal.bestiary.mammoth.name;
            desc1 = hdmod_string.journal.bestiary.mammoth.desc1;
            desc2 = hdmod_string.journal.bestiary.mammoth.desc2;
            desc3 = hdmod_string.journal.bestiary.mammoth.desc3;
            desc4 = hdmod_string.journal.bestiary.mammoth.desc4;
            desc5 = hdmod_string.journal.bestiary.mammoth.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 4;
            row = 0;
            bg_column = 2;
            bg_row = 1;
            big = true;
        };
        -- ALIEN: 35
        {
            name = hdmod_string.journal.bestiary.alien.name;
            desc1 = hdmod_string.journal.bestiary.alien.desc1;
            desc2 = hdmod_string.journal.bestiary.alien.desc2;
            desc3 = hdmod_string.journal.bestiary.alien.desc3;
            desc4 = hdmod_string.journal.bestiary.alien.desc4;
            desc5 = hdmod_string.journal.bestiary.alien.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 8;
            row = 2;
            bg_column = 3;
            bg_row = 1;
            big = false;
        };
        -- UFO: 36
        {
            name = hdmod_string.journal.bestiary.ufo.name;
            desc1 = hdmod_string.journal.bestiary.ufo.desc1;
            desc2 = hdmod_string.journal.bestiary.ufo.desc2;
            desc3 = hdmod_string.journal.bestiary.ufo.desc3;
            desc4 = hdmod_string.journal.bestiary.ufo.desc4;
            desc5 = hdmod_string.journal.bestiary.ufo.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 7;
            row = 2;
            bg_column = 3;
            bg_row = 1;
            big = false;
        };
        -- ALIENTANK: 37
        {
            name = hdmod_string.journal.bestiary.alientank.name;
            desc1 = hdmod_string.journal.bestiary.alientank.desc1;
            desc2 = hdmod_string.journal.bestiary.alientank.desc2;
            desc3 = hdmod_string.journal.bestiary.alientank.desc3;
            desc4 = hdmod_string.journal.bestiary.alientank.desc4;
            desc5 = hdmod_string.journal.bestiary.alientank.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 5;
            row = 2;
            bg_column = 3;
            bg_row = 1;
            big = false;
        };
        -- ALIENLORD: 38
        {
            name = hdmod_string.journal.bestiary.alienlord.name;
            desc1 = hdmod_string.journal.bestiary.alienlord.desc1;
            desc2 = hdmod_string.journal.bestiary.alienlord.desc2;
            desc3 = hdmod_string.journal.bestiary.alienlord.desc3;
            desc4 = hdmod_string.journal.bestiary.alienlord.desc4;
            desc5 = hdmod_string.journal.bestiary.alienlord.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 4;
            row = 1;
            bg_column = 3;
            bg_row = 1;
            big = true;
        };
        -- ALIENQUEEN: 39
        {
            name = hdmod_string.journal.bestiary.alienqueen.name;
            desc1 = hdmod_string.journal.bestiary.alienqueen.desc1;
            desc2 = hdmod_string.journal.bestiary.alienqueen.desc2;
            desc3 = hdmod_string.journal.bestiary.alienqueen.desc3;
            desc4 = hdmod_string.journal.bestiary.alienqueen.desc4;
            desc5 = hdmod_string.journal.bestiary.alienqueen.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 3;
            row = 3;
            bg_column = 3;
            bg_row = 1;
            big = true;
        };
        -- HAWKMAN: 40
        {
            name = hdmod_string.journal.bestiary.hawkman.name;
            desc1 = hdmod_string.journal.bestiary.hawkman.desc1;
            desc2 = hdmod_string.journal.bestiary.hawkman.desc2;
            desc3 = hdmod_string.journal.bestiary.hawkman.desc3;
            desc4 = hdmod_string.journal.bestiary.hawkman.desc4;
            desc5 = hdmod_string.journal.bestiary.hawkman.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 2;
            row = 2;
            bg_column = 1;
            bg_row = 1;
            big = false;
        };
        -- CROCMAN: 41
        {
            name = hdmod_string.journal.bestiary.crocman.name;
            desc1 = hdmod_string.journal.bestiary.crocman.desc1;
            desc2 = hdmod_string.journal.bestiary.crocman.desc2;
            desc3 = hdmod_string.journal.bestiary.crocman.desc3;
            desc4 = hdmod_string.journal.bestiary.crocman.desc4;
            desc5 = hdmod_string.journal.bestiary.crocman.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 9;
            row = 1;
            bg_column = 1;
            bg_row = 1;
            big = false;
        };
        -- MAGMAR: 42
        {
            name = hdmod_string.journal.bestiary.magmar.name;
            desc1 = hdmod_string.journal.bestiary.magmar.desc1;
            desc2 = hdmod_string.journal.bestiary.magmar.desc2;
            desc3 = hdmod_string.journal.bestiary.magmar.desc3;
            desc4 = hdmod_string.journal.bestiary.magmar.desc4;
            desc5 = hdmod_string.journal.bestiary.magmar.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 3;
            row = 1;
            bg_column = 1;
            bg_row = 1;
            big = false;
        };
        -- SCORPIONFLY: 43
        {
            name = hdmod_string.journal.bestiary.scorpionfly.name;
            desc1 = hdmod_string.journal.bestiary.scorpionfly.desc1;
            desc2 = hdmod_string.journal.bestiary.scorpionfly.desc2;
            desc3 = hdmod_string.journal.bestiary.scorpionfly.desc3;
            desc4 = hdmod_string.journal.bestiary.scorpionfly.desc4;
            desc5 = hdmod_string.journal.bestiary.scorpionfly.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 1;
            row = 2;
            bg_column = 1;
            bg_row = 1;
            big = false;
        };
        -- MUMMY: 44
        {
            name = hdmod_string.journal.bestiary.mummy.name;
            desc1 = hdmod_string.journal.bestiary.mummy.desc1;
            desc2 = hdmod_string.journal.bestiary.mummy.desc2;
            desc3 = hdmod_string.journal.bestiary.mummy.desc3;
            desc4 = hdmod_string.journal.bestiary.mummy.desc4;
            desc5 = hdmod_string.journal.bestiary.mummy.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 2;
            row = 0;
            bg_column = 1;
            bg_row = 1;
            big = true;
        };
        -- ANUBIS: 45
        {
            name = hdmod_string.journal.bestiary.anubis.name;
            desc1 = hdmod_string.journal.bestiary.anubis.desc1;
            desc2 = hdmod_string.journal.bestiary.anubis.desc2;
            desc3 = hdmod_string.journal.bestiary.anubis.desc3;
            desc4 = hdmod_string.journal.bestiary.anubis.desc4;
            desc5 = hdmod_string.journal.bestiary.anubis.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 3;
            row = 0;
            bg_column = 1;
            bg_row = 1;
            big = true;
        };
        -- ANUBIS II: 46
        {
            name = hdmod_string.journal.bestiary.anubis2.name;
            desc1 = hdmod_string.journal.bestiary.anubis2.desc1;
            desc2 = hdmod_string.journal.bestiary.anubis2.desc2;
            desc3 = hdmod_string.journal.bestiary.anubis2.desc3;
            desc4 = hdmod_string.journal.bestiary.anubis2.desc4;
            desc5 = hdmod_string.journal.bestiary.anubis2.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 0;
            row = 4;
            bg_column = 1;
            bg_row = 1;
            big = true;
        };
        -- OLMEC: 47
        {
            name = hdmod_string.journal.bestiary.olmec.name;
            desc1 = hdmod_string.journal.bestiary.olmec.desc1;
            desc2 = hdmod_string.journal.bestiary.olmec.desc2;
            desc3 = hdmod_string.journal.bestiary.olmec.desc3;
            desc4 = hdmod_string.journal.bestiary.olmec.desc4;
            desc5 = hdmod_string.journal.bestiary.olmec.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 1;
            row = 0;
            bg_column = 3;
            bg_row = 0;
            big = true;
        };
        -- VLAD: 48
        {
            name = hdmod_string.journal.bestiary.vlad.name;
            desc1 = hdmod_string.journal.bestiary.vlad.desc1;
            desc2 = hdmod_string.journal.bestiary.vlad.desc2;
            desc3 = hdmod_string.journal.bestiary.vlad.desc3;
            desc4 = hdmod_string.journal.bestiary.vlad.desc4;
            desc5 = hdmod_string.journal.bestiary.vlad.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 8;
            row = 1;
            bg_column = 2;
            bg_row = 0;
            big = false;
        };
        -- IMP: 49
        {
            name = hdmod_string.journal.bestiary.imp.name;
            desc1 = hdmod_string.journal.bestiary.imp.desc1;
            desc2 = hdmod_string.journal.bestiary.imp.desc2;
            desc3 = hdmod_string.journal.bestiary.imp.desc3;
            desc4 = hdmod_string.journal.bestiary.imp.desc4;
            desc5 = hdmod_string.journal.bestiary.imp.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 6;
            row = 1;
            bg_column = 2;
            bg_row = 0;
            big = false;
        };
        -- DEVIL: 50
        {
            name = hdmod_string.journal.bestiary.devil.name;
            desc1 = hdmod_string.journal.bestiary.devil.desc1;
            desc2 = hdmod_string.journal.bestiary.devil.desc2;
            desc3 = hdmod_string.journal.bestiary.devil.desc3;
            desc4 = hdmod_string.journal.bestiary.devil.desc4;
            desc5 = hdmod_string.journal.bestiary.devil.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 1;
            row = 3;
            bg_column = 2;
            bg_row = 0;
            big = false;
        };
        -- SUCCUBUS: 51
        {
            name = hdmod_string.journal.bestiary.succubus.name;
            desc1 = hdmod_string.journal.bestiary.succubus.desc1;
            desc2 = hdmod_string.journal.bestiary.succubus.desc2;
            desc3 = hdmod_string.journal.bestiary.succubus.desc3;
            desc4 = hdmod_string.journal.bestiary.succubus.desc4;
            desc5 = hdmod_string.journal.bestiary.succubus.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_0;
            column = 1;
            row = 4;
            bg_column = 2;
            bg_row = 0;
            big = false;
        };
        -- HORSEHEAD: 52
        {
            name = hdmod_string.journal.bestiary.horsehead.name;
            desc1 = hdmod_string.journal.bestiary.horsehead.desc1;
            desc2 = hdmod_string.journal.bestiary.horsehead.desc2;
            desc3 = hdmod_string.journal.bestiary.horsehead.desc3;
            desc4 = hdmod_string.journal.bestiary.horsehead.desc4;
            desc5 = hdmod_string.journal.bestiary.horsehead.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 2;
            row = 2;
            bg_column = 2;
            bg_row = 0;
            big = true;
        };
        -- OXFACE: 53
        {
            name = hdmod_string.journal.bestiary.oxface.name;
            desc1 = hdmod_string.journal.bestiary.oxface.desc1;
            desc2 = hdmod_string.journal.bestiary.oxface.desc2;
            desc3 = hdmod_string.journal.bestiary.oxface.desc3;
            desc4 = hdmod_string.journal.bestiary.oxface.desc4;
            desc5 = hdmod_string.journal.bestiary.oxface.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 3;
            row = 2;
            bg_column = 2;
            bg_row = 0;
            big = true;
        };
        -- KING YAMA: 54
        {
            name = hdmod_string.journal.bestiary.kingyama.name;
            desc1 = hdmod_string.journal.bestiary.kingyama.desc1;
            desc2 = hdmod_string.journal.bestiary.kingyama.desc2;
            desc3 = hdmod_string.journal.bestiary.kingyama.desc3;
            desc4 = hdmod_string.journal.bestiary.kingyama.desc4;
            desc5 = hdmod_string.journal.bestiary.kingyama.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_MONS_BIG_0;
            column = 4;
            row = 4;
            bg_column = 2;
            bg_row = 0;
            big = 2;
        };
    };
    items = {
        -- ROPE PILE: 1
        {
            name = hdmod_string.journal.items.rope_pile.name;
            desc1 = hdmod_string.journal.items.rope_pile.desc1;
            desc2 = hdmod_string.journal.items.rope_pile.desc2;
            desc3 = hdmod_string.journal.items.rope_pile.desc3;
            desc4 = hdmod_string.journal.items.rope_pile.desc4;
            desc5 = hdmod_string.journal.items.rope_pile.desc5;
            column = 0;
            row = 0;
        };
        -- BOMB BAG: 2
        {
            name = hdmod_string.journal.items.bomb_bag.name;
            desc1 = hdmod_string.journal.items.bomb_bag.desc1;
            desc2 = hdmod_string.journal.items.bomb_bag.desc2;
            desc3 = hdmod_string.journal.items.bomb_bag.desc3;
            desc4 = hdmod_string.journal.items.bomb_bag.desc4;
            desc5 = hdmod_string.journal.items.bomb_bag.desc5;
            column = 1;
            row = 0;
        };
        -- BOMB BOX: 3
        {
            name = hdmod_string.journal.items.bomb_box.name;
            desc1 = hdmod_string.journal.items.bomb_box.desc1;
            desc2 = hdmod_string.journal.items.bomb_box.desc2;
            desc3 = hdmod_string.journal.items.bomb_box.desc3;
            desc4 = hdmod_string.journal.items.bomb_box.desc4;
            desc5 = hdmod_string.journal.items.bomb_box.desc5;
            column = 2;
            row = 0;
        };
        -- SPECTACLES: 4
        {
            name = hdmod_string.journal.items.spectacles.name;
            desc1 = hdmod_string.journal.items.spectacles.desc1;
            desc2 = hdmod_string.journal.items.spectacles.desc2;
            desc3 = hdmod_string.journal.items.spectacles.desc3;
            desc4 = hdmod_string.journal.items.spectacles.desc4;
            desc5 = hdmod_string.journal.items.spectacles.desc5;
            column = 4;
            row = 0;
        };
        -- CLIMBING GLOVES: 5
        {
            name = hdmod_string.journal.items.climbing_gloves.name;
            desc1 = hdmod_string.journal.items.climbing_gloves.desc1;
            desc2 = hdmod_string.journal.items.climbing_gloves.desc2;
            desc3 = hdmod_string.journal.items.climbing_gloves.desc3;
            desc4 = hdmod_string.journal.items.climbing_gloves.desc4;
            desc5 = hdmod_string.journal.items.climbing_gloves.desc5;
            column = 5;
            row = 0;
        };
        -- PITCHERS MITT: 6
        {
            name = hdmod_string.journal.items.pitchers_mitt.name;
            desc1 = hdmod_string.journal.items.pitchers_mitt.desc1;
            desc2 = hdmod_string.journal.items.pitchers_mitt.desc2;
            desc3 = hdmod_string.journal.items.pitchers_mitt.desc3;
            desc4 = hdmod_string.journal.items.pitchers_mitt.desc4;
            desc5 = hdmod_string.journal.items.pitchers_mitt.desc5;
            column = 6;
            row = 0;
        };
        -- SPRING SHOES: 7
        {
            name = hdmod_string.journal.items.spring_shoes.name;
            desc1 = hdmod_string.journal.items.spring_shoes.desc1;
            desc2 = hdmod_string.journal.items.spring_shoes.desc2;
            desc3 = hdmod_string.journal.items.spring_shoes.desc3;
            desc4 = hdmod_string.journal.items.spring_shoes.desc4;
            desc5 = hdmod_string.journal.items.spring_shoes.desc5;
            column = 7;
            row = 0;
        };
        -- SPIKE SHOES: 8
        {
            name = hdmod_string.journal.items.spike_shoes.name;
            desc1 = hdmod_string.journal.items.spike_shoes.desc1;
            desc2 = hdmod_string.journal.items.spike_shoes.desc2;
            desc3 = hdmod_string.journal.items.spike_shoes.desc3;
            desc4 = hdmod_string.journal.items.spike_shoes.desc4;
            desc5 = hdmod_string.journal.items.spike_shoes.desc5;
            column = 8;
            row = 0;
        };
        -- PASTE: 9
        {
            name = hdmod_string.journal.items.paste.name;
            desc1 = hdmod_string.journal.items.paste.desc1;
            desc2 = hdmod_string.journal.items.paste.desc2;
            desc3 = hdmod_string.journal.items.paste.desc3;
            desc4 = hdmod_string.journal.items.paste.desc4;
            desc5 = hdmod_string.journal.items.paste.desc5;
            column = 3;
            row = 0;
        };
        -- COMPASS: 10
        {
            name = hdmod_string.journal.items.compass.name;
            desc1 = hdmod_string.journal.items.compass.desc1;
            desc2 = hdmod_string.journal.items.compass.desc2;
            desc3 = hdmod_string.journal.items.compass.desc3;
            desc4 = hdmod_string.journal.items.compass.desc4;
            desc5 = hdmod_string.journal.items.compass.desc5;
            column = 9;
            row = 0;
        };
        -- MATTOCK: 11
        {
            name = hdmod_string.journal.items.mattock.name;
            desc1 = hdmod_string.journal.items.mattock.desc1;
            desc2 = hdmod_string.journal.items.mattock.desc2;
            desc3 = hdmod_string.journal.items.mattock.desc3;
            desc4 = hdmod_string.journal.items.mattock.desc4;
            desc5 = hdmod_string.journal.items.mattock.desc5;
            column = 6;
            row = 2;
        };
        -- BOOMERANG: 12
        {
            name = hdmod_string.journal.items.boomerang.name;
            desc1 = hdmod_string.journal.items.boomerang.desc1;
            desc2 = hdmod_string.journal.items.boomerang.desc2;
            desc3 = hdmod_string.journal.items.boomerang.desc3;
            desc4 = hdmod_string.journal.items.boomerang.desc4;
            desc5 = hdmod_string.journal.items.boomerang.desc5;
            column = 7;
            row = 2;
        };
        -- MACHETE: 13
        {
            name = hdmod_string.journal.items.machete.name;
            desc1 = hdmod_string.journal.items.machete.desc1;
            desc2 = hdmod_string.journal.items.machete.desc2;
            desc3 = hdmod_string.journal.items.machete.desc3;
            desc4 = hdmod_string.journal.items.machete.desc4;
            desc5 = hdmod_string.journal.items.machete.desc5;
            column = 8;
            row = 2;
        };
        -- CRYSKNIFE: 14
        {
            name = hdmod_string.journal.items.crysknife.name;
            desc1 = hdmod_string.journal.items.crysknife.desc1;
            desc2 = hdmod_string.journal.items.crysknife.desc2;
            desc3 = hdmod_string.journal.items.crysknife.desc3;
            desc4 = hdmod_string.journal.items.crysknife.desc4;
            desc5 = hdmod_string.journal.items.crysknife.desc5;
            column = 9;
            row = 2;
        };
        -- WEB GUN: 15
        {
            name = hdmod_string.journal.items.web_gun.name;
            desc1 = hdmod_string.journal.items.web_gun.desc1;
            desc2 = hdmod_string.journal.items.web_gun.desc2;
            desc3 = hdmod_string.journal.items.web_gun.desc3;
            desc4 = hdmod_string.journal.items.web_gun.desc4;
            desc5 = hdmod_string.journal.items.web_gun.desc5;
            column = 0;
            row = 2;
        };
        -- SHOTGUN: 16
        {
            name = hdmod_string.journal.items.shotgun.name;
            desc1 = hdmod_string.journal.items.shotgun.desc1;
            desc2 = hdmod_string.journal.items.shotgun.desc2;
            desc3 = hdmod_string.journal.items.shotgun.desc3;
            desc4 = hdmod_string.journal.items.shotgun.desc4;
            desc5 = hdmod_string.journal.items.shotgun.desc5;
            column = 1;
            row = 2;
        };
        -- FREEZE RAY: 17
        {
            name = hdmod_string.journal.items.freeze_ray.name;
            desc1 = hdmod_string.journal.items.freeze_ray.desc1;
            desc2 = hdmod_string.journal.items.freeze_ray.desc2;
            desc3 = hdmod_string.journal.items.freeze_ray.desc3;
            desc4 = hdmod_string.journal.items.freeze_ray.desc4;
            desc5 = hdmod_string.journal.items.freeze_ray.desc5;
            column = 2;
            row = 2;
        };
        -- PLASMA CANNON: 18
        {
            name = hdmod_string.journal.items.plasma_cannon.name;
            desc1 = hdmod_string.journal.items.plasma_cannon.desc1;
            desc2 = hdmod_string.journal.items.plasma_cannon.desc2;
            desc3 = hdmod_string.journal.items.plasma_cannon.desc3;
            desc4 = hdmod_string.journal.items.plasma_cannon.desc4;
            desc5 = hdmod_string.journal.items.plasma_cannon.desc5;
            column = 0;
            row = 3;
        };
        -- CAMERA: 19
        {
            name = hdmod_string.journal.items.camera.name;
            desc1 = hdmod_string.journal.items.camera.desc1;
            desc2 = hdmod_string.journal.items.camera.desc2;
            desc3 = hdmod_string.journal.items.camera.desc3;
            desc4 = hdmod_string.journal.items.camera.desc4;
            desc5 = hdmod_string.journal.items.camera.desc5;
            column = 4;
            row = 2;
        };
        -- TELEPORTER: 20
        {
            name = hdmod_string.journal.items.teleporter.name;
            desc1 = hdmod_string.journal.items.teleporter.desc1;
            desc2 = hdmod_string.journal.items.teleporter.desc2;
            desc3 = hdmod_string.journal.items.teleporter.desc3;
            desc4 = hdmod_string.journal.items.teleporter.desc4;
            desc5 = hdmod_string.journal.items.teleporter.desc5;
            column = 5;
            row = 2;
        };
        -- PARACHUTE: 21
        {
            name = hdmod_string.journal.items.parachute.name;
            desc1 = hdmod_string.journal.items.parachute.desc1;
            desc2 = hdmod_string.journal.items.parachute.desc2;
            desc3 = hdmod_string.journal.items.parachute.desc3;
            desc4 = hdmod_string.journal.items.parachute.desc4;
            desc5 = hdmod_string.journal.items.parachute.desc5;
            column = 0;
            row = 1;
        };
        -- CAPE: 22
        {
            name = hdmod_string.journal.items.cape.name;
            desc1 = hdmod_string.journal.items.cape.desc1;
            desc2 = hdmod_string.journal.items.cape.desc2;
            desc3 = hdmod_string.journal.items.cape.desc3;
            desc4 = hdmod_string.journal.items.cape.desc4;
            desc5 = hdmod_string.journal.items.cape.desc5;
            column = 7;
            row = 1;
        };
        -- JETPACK: 23
        {
            name = hdmod_string.journal.items.jetpack.name;
            desc1 = hdmod_string.journal.items.jetpack.desc1;
            desc2 = hdmod_string.journal.items.jetpack.desc2;
            desc3 = hdmod_string.journal.items.jetpack.desc3;
            desc4 = hdmod_string.journal.items.jetpack.desc4;
            desc5 = hdmod_string.journal.items.jetpack.desc5;
            column = 8;
            row = 1;
        };
        -- SHIELD: 24
        {
            name = hdmod_string.journal.items.shield.name;
            desc1 = hdmod_string.journal.items.shield.desc1;
            desc2 = hdmod_string.journal.items.shield.desc2;
            desc3 = hdmod_string.journal.items.shield.desc3;
            desc4 = hdmod_string.journal.items.shield.desc4;
            desc5 = hdmod_string.journal.items.shield.desc5;
            column = 1;
            row = 4;
        };
        -- ROYAL JELLY: 25
        {
            name = hdmod_string.journal.items.royal_jelly.name;
            desc1 = hdmod_string.journal.items.royal_jelly.desc1;
            desc2 = hdmod_string.journal.items.royal_jelly.desc2;
            desc3 = hdmod_string.journal.items.royal_jelly.desc3;
            desc4 = hdmod_string.journal.items.royal_jelly.desc4;
            desc5 = hdmod_string.journal.items.royal_jelly.desc5;
            column = 6;
            row = 1;
        };
        -- IDOL: 26
        {
            name = hdmod_string.journal.items.idol.name;
            desc1 = hdmod_string.journal.items.idol.desc1;
            desc2 = hdmod_string.journal.items.idol.desc2;
            desc3 = hdmod_string.journal.items.idol.desc3;
            desc4 = hdmod_string.journal.items.idol.desc4;
            desc5 = hdmod_string.journal.items.idol.desc5;
            column = 2;
            row = 3;
        };
        -- CRYSTAL SKULL: 27
        {
            name = hdmod_string.journal.items.crystal_skull.name;
            desc1 = hdmod_string.journal.items.crystal_skull.desc1;
            desc2 = hdmod_string.journal.items.crystal_skull.desc2;
            desc3 = hdmod_string.journal.items.crystal_skull.desc3;
            desc4 = hdmod_string.journal.items.crystal_skull.desc4;
            desc5 = hdmod_string.journal.items.crystal_skull.desc5;
            column = 7;
            row = 4;
        };
        -- KAPALA: 28
        {
            name = hdmod_string.journal.items.kapala.name;
            desc1 = hdmod_string.journal.items.kapala.desc1;
            desc2 = hdmod_string.journal.items.kapala.desc2;
            desc3 = hdmod_string.journal.items.kapala.desc3;
            desc4 = hdmod_string.journal.items.kapala.desc4;
            desc5 = hdmod_string.journal.items.kapala.desc5;
            column = 2;
            row = 1;
        };
        -- UDJAT EYE: 29
        {
            name = hdmod_string.journal.items.udjat_eye.name;
            desc1 = hdmod_string.journal.items.udjat_eye.desc1;
            desc2 = hdmod_string.journal.items.udjat_eye.desc2;
            desc3 = hdmod_string.journal.items.udjat_eye.desc3;
            desc4 = hdmod_string.journal.items.udjat_eye.desc4;
            desc5 = hdmod_string.journal.items.udjat_eye.desc5;
            column = 1;
            row = 1;
        };
        -- ANKH: 30
        {
            name = hdmod_string.journal.items.ankh.name;
            desc1 = hdmod_string.journal.items.ankh.desc1;
            desc2 = hdmod_string.journal.items.ankh.desc2;
            desc3 = hdmod_string.journal.items.ankh.desc3;
            desc4 = hdmod_string.journal.items.ankh.desc4;
            desc5 = hdmod_string.journal.items.ankh.desc5;
            column = 5;
            row = 1;
        };
        -- HEDJET: 31
        {
            name = hdmod_string.journal.items.hedjet.name;
            desc1 = hdmod_string.journal.items.hedjet.desc1;
            desc2 = hdmod_string.journal.items.hedjet.desc2;
            desc3 = hdmod_string.journal.items.hedjet.desc3;
            desc4 = hdmod_string.journal.items.hedjet.desc4;
            desc5 = hdmod_string.journal.items.hedjet.desc5;
            column = 3;
            row = 1;
        };
        -- SCEPTER: 32
        {
            name = hdmod_string.journal.items.scepter.name;
            desc1 = hdmod_string.journal.items.scepter.desc1;
            desc2 = hdmod_string.journal.items.scepter.desc2;
            desc3 = hdmod_string.journal.items.scepter.desc3;
            desc4 = hdmod_string.journal.items.scepter.desc4;
            desc5 = hdmod_string.journal.items.scepter.desc5;
            column = 1;
            row = 3;
        };
        -- BOOK OF THE DEAD: 33
        {
            name = hdmod_string.journal.items.botd.name;
            desc1 = hdmod_string.journal.items.botd.desc1;
            desc2 = hdmod_string.journal.items.botd.desc2;
            desc3 = hdmod_string.journal.items.botd.desc3;
            desc4 = hdmod_string.journal.items.botd.desc4;
            desc5 = hdmod_string.journal.items.botd.desc5;
            column = 9;
            row = 3;
        };
        -- VLADS CAPE: 34
        {
            name = hdmod_string.journal.items.vlads_cape.name;
            desc1 = hdmod_string.journal.items.vlads_cape.desc1;
            desc2 = hdmod_string.journal.items.vlads_cape.desc2;
            desc3 = hdmod_string.journal.items.vlads_cape.desc3;
            desc4 = hdmod_string.journal.items.vlads_cape.desc4;
            desc5 = hdmod_string.journal.items.vlads_cape.desc5;
            column = 5;
            row = 4;
        };
        -- VLADS AMULET: 35
        {
            name = hdmod_string.journal.items.vlads_amulet.name;
            desc1 = hdmod_string.journal.items.vlads_amulet.desc1;
            desc2 = hdmod_string.journal.items.vlads_amulet.desc2;
            desc3 = hdmod_string.journal.items.vlads_amulet.desc3;
            desc4 = hdmod_string.journal.items.vlads_amulet.desc4;
            desc5 = hdmod_string.journal.items.vlads_amulet.desc5;
            column = 4;
            row = 4;
        };
        -- EGGPLANT: 36
        {
            name = hdmod_string.journal.items.eggplant.name;
            desc1 = hdmod_string.journal.items.eggplant.desc1;
            desc2 = hdmod_string.journal.items.eggplant.desc2;
            desc3 = hdmod_string.journal.items.eggplant.desc3;
            desc4 = hdmod_string.journal.items.eggplant.desc4;
            desc5 = hdmod_string.journal.items.eggplant.desc5;
            column = 4;
            row = 3;
        };
    };
    traps = {
        -- SPIKES: 1
        {
            name = hdmod_string.journal.traps.spikes.name;
            desc1 = hdmod_string.journal.traps.spikes.desc1;
            desc2 = hdmod_string.journal.traps.spikes.desc2;
            desc3 = hdmod_string.journal.traps.spikes.desc3;
            desc4 = hdmod_string.journal.traps.spikes.desc4;
            desc5 = hdmod_string.journal.traps.spikes.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 0;
            row = 1;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- ARROW TRAP: 2
        {
            name = hdmod_string.journal.traps.arrow_trap.name;
            desc1 = hdmod_string.journal.traps.arrow_trap.desc1;
            desc2 = hdmod_string.journal.traps.arrow_trap.desc2;
            desc3 = hdmod_string.journal.traps.arrow_trap.desc3;
            desc4 = hdmod_string.journal.traps.arrow_trap.desc4;
            desc5 = hdmod_string.journal.traps.arrow_trap.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 0;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- POWDER KEG: 3
        {
            name = hdmod_string.journal.traps.powder_keg.name;
            desc1 = hdmod_string.journal.traps.powder_keg.desc1;
            desc2 = hdmod_string.journal.traps.powder_keg.desc2;
            desc3 = hdmod_string.journal.traps.powder_keg.desc3;
            desc4 = hdmod_string.journal.traps.powder_keg.desc4;
            desc5 = hdmod_string.journal.traps.powder_keg.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 3;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = false;
        };
        -- BOULDER: 4
        {
            name = hdmod_string.journal.traps.boulder.name;
            desc1 = hdmod_string.journal.traps.boulder.desc1;
            desc2 = hdmod_string.journal.traps.boulder.desc2;
            desc3 = hdmod_string.journal.traps.boulder.desc3;
            desc4 = hdmod_string.journal.traps.boulder.desc4;
            desc5 = hdmod_string.journal.traps.boulder.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_2;
            column = 1;
            row = 0;
            bg_column = 0;
            bg_row = 0;
            big = 2;
        };
        -- TIKI TRAP: 5
        {
            name = hdmod_string.journal.traps.tiki_trap.name;
            desc1 = hdmod_string.journal.traps.tiki_trap.desc1;
            desc2 = hdmod_string.journal.traps.tiki_trap.desc2;
            desc3 = hdmod_string.journal.traps.tiki_trap.desc3;
            desc4 = hdmod_string.journal.traps.tiki_trap.desc4;
            desc5 = hdmod_string.journal.traps.tiki_trap.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_1;
            column = 0;
            row = 0;
            bg_column = 1;
            bg_row = 0;
            big = 1;
        };
        -- ACID: 6
        {
            name = hdmod_string.journal.traps.acid.name;
            desc1 = hdmod_string.journal.traps.acid.desc1;
            desc2 = hdmod_string.journal.traps.acid.desc2;
            desc3 = hdmod_string.journal.traps.acid.desc3;
            desc4 = hdmod_string.journal.traps.acid.desc4;
            desc5 = hdmod_string.journal.traps.acid.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 3;
            row = 1;
            bg_column = 0;
            bg_row = 2;
            big = false;
        };
        -- SPRING: 7
        {
            name = hdmod_string.journal.traps.spring.name;
            desc1 = hdmod_string.journal.traps.spring.desc1;
            desc2 = hdmod_string.journal.traps.spring.desc2;
            desc3 = hdmod_string.journal.traps.spring.desc3;
            desc4 = hdmod_string.journal.traps.spring.desc4;
            desc5 = hdmod_string.journal.traps.spring.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 8;
            row = 0;
            bg_column = 2;
            bg_row = 1;
            big = false;
        };
        -- MINE: 8
        {
            name = hdmod_string.journal.traps.mine.name;
            desc1 = hdmod_string.journal.traps.mine.desc1;
            desc2 = hdmod_string.journal.traps.mine.desc2;
            desc3 = hdmod_string.journal.traps.mine.desc3;
            desc4 = hdmod_string.journal.traps.mine.desc4;
            desc5 = hdmod_string.journal.traps.mine.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 9;
            row = 0;
            bg_column = 2;
            bg_row = 1;
            big = false;
        };
        -- TURRET: 9
        {
            name = hdmod_string.journal.traps.turret.name;
            desc1 = hdmod_string.journal.traps.turret.desc1;
            desc2 = hdmod_string.journal.traps.turret.desc2;
            desc3 = hdmod_string.journal.traps.turret.desc3;
            desc4 = hdmod_string.journal.traps.turret.desc4;
            desc5 = hdmod_string.journal.traps.turret.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 7;
            row = 0;
            bg_column = 3;
            bg_row = 1;
            big = false;
        };
        -- FORCEFIELD: 10
        {
            name = hdmod_string.journal.traps.forcefield.name;
            desc1 = hdmod_string.journal.traps.forcefield.desc1;
            desc2 = hdmod_string.journal.traps.forcefield.desc2;
            desc3 = hdmod_string.journal.traps.forcefield.desc3;
            desc4 = hdmod_string.journal.traps.forcefield.desc4;
            desc5 = hdmod_string.journal.traps.forcefield.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_1;
            column = 4;
            row = 0;
            bg_column = 3;
            bg_row = 1;
            big = true;
        };
        -- CRUSH TRAP: 11
        {
            name = hdmod_string.journal.traps.crush_trap.name;
            desc1 = hdmod_string.journal.traps.crush_trap.desc1;
            desc2 = hdmod_string.journal.traps.crush_trap.desc2;
            desc3 = hdmod_string.journal.traps.crush_trap.desc3;
            desc4 = hdmod_string.journal.traps.crush_trap.desc4;
            desc5 = hdmod_string.journal.traps.crush_trap.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 6;
            row = 0;
            bg_column = 1;
            bg_row = 1;
            big = false;
        };
        -- CEILING TRAP: 12
        {
            name = hdmod_string.journal.traps.ceiling_trap.name;
            desc1 = hdmod_string.journal.traps.ceiling_trap.desc1;
            desc2 = hdmod_string.journal.traps.ceiling_trap.desc2;
            desc3 = hdmod_string.journal.traps.ceiling_trap.desc3;
            desc4 = hdmod_string.journal.traps.ceiling_trap.desc4;
            desc5 = hdmod_string.journal.traps.ceiling_trap.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_0;
            column = 4;
            row = 0;
            bg_column = 1;
            bg_row = 1;
            big = false;
        };
        -- SPIKE BALL: 13
        {
            name = hdmod_string.journal.traps.spike_ball.name;
            desc1 = hdmod_string.journal.traps.spike_ball.desc1;
            desc2 = hdmod_string.journal.traps.spike_ball.desc2;
            desc3 = hdmod_string.journal.traps.spike_ball.desc3;
            desc4 = hdmod_string.journal.traps.spike_ball.desc4;
            desc5 = hdmod_string.journal.traps.spike_ball.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_1;
            column = 3;
            row = 0;
            bg_column = 2;
            bg_row = 0;
            big = 1;
        };
        -- URAEUS TRAP: 14
        {
            name = hdmod_string.journal.traps.uraeus_trap.name;
            desc1 = hdmod_string.journal.traps.uraeus_trap.desc1;
            desc2 = hdmod_string.journal.traps.uraeus_trap.desc2;
            desc3 = hdmod_string.journal.traps.uraeus_trap.desc3;
            desc4 = hdmod_string.journal.traps.uraeus_trap.desc4;
            desc5 = hdmod_string.journal.traps.uraeus_trap.desc5;
            texture = TEXTURE.DATA_TEXTURES_JOURNAL_ENTRY_TRAPS_1;
            column = 1;
            row = 0;
            bg_column = 2;
            bg_row = 2;
            big = 1;
        };
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
        false;
        false;
    };
    people = {
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
        false;
        false;
        false;
        false;
    };
    bestiary = {
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
        false;
        false;
        false;
        false;
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
        "N/A";
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
        "N/A";
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
        "N/A";
        0;
        0;
        0;
        "N/A";
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
        "N/A";
        "N/A";
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
        false;
        false;
        false;
        false;
        false;
        false;
    };
    traps = {
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
        false;
        false;
        false;
        false;
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