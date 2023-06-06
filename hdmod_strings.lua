-- Big table that contains all strings for a given language
local module = {}

--ENGLISH
module.english = {
    journal = {
        undiscovered = {
            name = "UNDISCOVERED";
            desc1 = "";
            desc2 = "This journal entry is still";
            desc3 = "waiting to be discovered.";
            desc4 = "";
            desc5 = "";            
        };
        --PLACES
        places = {
            mines = {
                name = "THE MINES";
                desc1 = "";
                desc2 = "Never thought we'd visit this place";
                desc3 = "again after so long. What remains here";
                desc4 = "are centuries of failed expeditions from ";
                desc5 = "excavators forever doomed by the curse.";
            };
            jungle = {  
                name = "JUNGLE";
                desc1 = "";
                desc2 = "These ecosystems may play a massive";
                desc3 = "role in sustaining life for all the";
                desc4 = "ecology here in the caves.";
                desc5 = "";
            };
            black_market = {
                name = "BLACK MARKET";
                desc1 = "";
                desc2 = "A central plaza for all shady goods to";
                desc3 = "be distributed by the Shopkeeper";
                desc4 = "Association.";
                desc5 = "";
            };
            the_worm = {
                name = "THE WORM";
                desc1 = "";
                desc2 = "Creatures so gargantuan that entire";
                desc3 = "environments take place inside";
                desc4 = "their organs.";
                desc5 = "";
            };
            haunted_castle = { 
                name = "HAUNTED CASTLE";
                desc1 = "";
                desc2 = "Stories tell of a mighty kingdom";
                desc3 = "swallowed up whole by the hands of";
                desc4 = "of a stubborn knight who refused to";
                desc5 = "yield for a mighty warlock.";
            };
            ice_caves = {
                name = "ICE CAVES";
                desc1 = "";
                desc2 = "It is now theorized that comets of ice";
                desc3 = "that have since been buried are what";
                desc4 = "inhibit these cold environments filled";
                desc5 = "with extraterritorial invaders.";
            };
            mothership = {     
                name = "MOTHERSHIP";
                desc1 = "";
                desc2 = "The main base of operation for the";
                desc3 = "Alien faction, it remains much more ";
                desc4 = "active here than on the moon";
                desc5 = "";
            };
            temple = {
                name = "TEMPLE";
                desc1 = "";
                desc2 = "An ancient society long since lost and ";
                desc3 = "refound, the temple holds extreme";
                desc4 = " worship by the inhabitants who submit";
                desc5 = "their livelihood to the curse.";
            };
            city_of_gold = {       
                name = "THE CITY OF GOLD";
                desc1 = "";
                desc2 = "The land of El Dorado! It is always a";
                desc3 = "spectacle coming back here and seeing";
                desc4 = "the magnificent golden glaze imbue ";
                desc5 = "the architecture";
            };
            hell = {
                name = "HELL";
                desc1 = "";
                desc2 = "It's been 15 years since this place was ";
                desc3 = "left a cold cinder, only to suddenly";
                desc4 = "reignite as the once thought tamed ";
                desc5 = "Yama regained fury";
            };
        };
        --PEOPLE
        people = {
            tun = {
                name = "TUN";
                desc1 = "";
                desc2 = "She was the first to explore the";
                desc3 = "Darkside and wants to learn";
                desc4 = " more about it.";
                desc5 = "";
            };
            yin = {
                name = "YIN";
                desc1 = "";
                desc2 = "A deranged criminal and avid hunter";
                desc3 = "who fled to the moon after becoming ";
                desc4 = "wanted on all 7 continents,";
                desc5 = "including Antarctica, somehow.";
            };
            arms_dealer = {
                name = "ARMS DEALER";
                desc1 = "";
                desc2 = "He sells rare weapons as a side";
                desc3 = "hustle. Things wouldn't end well if";
                desc4 = "Madame Tusk ever found out.";
                desc5 = "";
            };
            bounty_hunter = {
                name = "THE BOUNTY HUNTER";
                desc1 = "";
                desc2 = "She made her fortune handling the";
                desc3 = "grudges of others. You've done";
                desc4 = "someone wrong to come across her.";
                desc5 = "";
            };
            beg = {
                name = "BEG";
                desc1 = "";
                desc2 = "";
                desc3 = "Hundun's favorite.";
                desc4 = "";
                desc5 = "";
            };
        };
        --BESTIARY
        bestiary = {
            quillback_wannabe = {
                name = "SCALEBACK";
                desc1 = "";
                desc2 = "A major cause of the Horned Lizard";
                desc3 = "extinction was Quillback's followers";
                desc4 = "attempting to copy his swagger.";
                desc5 = "";
            };
            machine_made = {
                name = "MACHINE MADE";
                desc1 = "";
                desc2 = "These robots were a failed";
                desc3 = "attempt at re-creating the";
                desc4 = "monsters that inhabit the moon.";
                desc5 = "";
            };
            quillback_honorbound = {
                name = "QUILLBACK";
                desc1 = "";
                desc2 = "He's learned some new tricks after";
                desc3 = "being made a fool of so many times";
                desc4 = "in the Dwelling.";
                desc5 = "";
            };
            gigaspider = {
                name = "GIGA SPIDER";
                desc1 = "";
                desc2 = "Unfortunately, you're the perfect";
                desc3 = "snacking-size for this terrifyingly";
                desc4 = "huge spider.";
                desc5 = "";
            }
        };
        --ITEMS
        items = {
            pit_key = {
                name = "DARKSIDE KEY";
                desc1 = "";
                desc2 = "This key is required to exit most";
                desc3 = "most levels. Typically held by a";
                desc4 = "monster, it has a strange aura.";
                desc5 = "";
            };
            ammo = {
                name = "AMMO";
                desc1 = "";
                desc2 = "How does the same ammo work";
                desc3 = "on so many different weapons?";
                desc4 = "Why is ammo even needed at all?";
                desc5 = "Best not to think about it.";
            };
            key_compass = {
                name = "HUNTER'S COMPASS";
                desc1 = "";
                desc2 = "This specialized tool will";
                desc3 = "point towards the Darkside";
                desc4 = "Key of the current level.";
                desc5 = "";
            };
            butterflyknife = {
                name = "BUTTERFLY KNIFE";
                desc1 = "";
                desc2 = "Stabbing monsters in the back";
                desc3 = "with this knife will kill them";
                desc4 = "instantly and reward bonus XP.";
                desc5 = "Surprise!";
            };
            butcherknife = {
                name = "BUTCHER'S KNIFE";
                desc1 = "";
                desc2 = "This oversized blade has the";
                desc3 = "strange ability to turn its";
                desc4 = "victims into health pickups!";
                desc5 = "";
            };
            cursegun = {
                name = "CURSE GUN";
                desc1 = "";
                desc2 = "A crude tool made using an old web";
                desc3 = "gun and a cursed pot. Cursed monsters";
                desc4 = "will drop significantly more XP than";
                desc5 = "regular monsters.";
            };
            maggotgun = {
                name = "MAGGOT GUN";
                desc1 = "";
                desc2 = "";
                desc3 = "The Queen of a parasitic insect";
                desc4 = "colony. Gross but powerful!";
                desc5 = "";
            };
            blade_of_chaos = {
                name = "BLADE OF CHAOS";
                desc1 = "";
                desc2 = "A highly unpredictable and weak";
                desc3 = "weapon. Only a fool would use this.";
                desc4 = "";
                desc5 = "";
            };
        };
        traps = {
            grinder = {
                name = "GRINDER";
                desc1 = "";
                desc2 = "It will indiscriminately turn";
                desc3 = "metal and people alike into mush.";
                desc4 = "Watch your step!";
                desc5 = "";
            };
            elevator = {
                name = "ELEVATOR";
                desc1 = "";
                desc2 = "";
                desc3 = "For robots, elevators are much";
                desc4 = "easier to navigate than stairs.";
                desc5 = "";
            };
            teleporter = {
                name = "TELEPORTER PAD";
                desc1 = "";
                desc2 = "";
                desc3 = "Whoever built this factory must";
                desc4 = "have refined teleporter tech!";
                desc5 = "";
            };
        };
        enemy_types = {
            explosive = {
                name = "EXPLOSIVE";
                desc1 = "";
                desc2 = "The forces of chaos have";
                desc3 = "a significant influence on";
                desc4 = "the monsters of the Darkside.";
                desc5 = "";
            };
            armored = {
                name = "ARMORED";
                desc1 = "";
                desc2 = "The shield disappears when";
                desc3 = "the monster is defeated. How";
                desc4 = "did they learn to use it?";
                desc5 = "";
            };
            ghostly = {
                name = "GHOSTLY";
                desc1 = "";
                desc2 = "Some kind of curse that allows";
                desc3 = "the sufferer to corporealize";
                desc4 = "at will. Perhaps a blessing?";
                desc5 = "";
            };
            gilded = {
                name = "GILDED";
                desc1 = "";
                desc2 = "A curse created by Anubis to";
                desc3 = "punish greedy explorers for";
                desc4 = "their violence.";
                desc5 = "";
            };
            infested = {
                name = "INFESTED";
                desc1 = "";
                desc2 = "A parasitic colony of flies";
                desc3 = "causes the garish green tint";
                desc4 = "and noxious gasses.";
                desc5 = "";
            };
            shadow = {
                name = "SHADOW";
                desc1 = "";
                desc2 = "They are unable to be stunned";
                desc3 = "and have twice the normal health.";
                desc4 = "Their existence is a mystery, even";
                desc5 = "to themselves.";
            };
        };
    };
    --DEATH MESSAGES
}

return module