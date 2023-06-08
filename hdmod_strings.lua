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
            shopkeeper = {
                name = "SHOPKEEPER";
                desc1 = "";
                desc2 = "A card-carrying member of the";
                desc3 = "Shopkeeper's Association. He HATES";
                desc4 = "shoplifting above all else!";
                desc5 = "";
            };
            yang = {
                name = "YANG";
                desc1 = "";
                desc2 = "The first to explore the original";
                desc3 = "caves. Something compelled him to ";
                desc4 = "come back.";
                desc5 = "";
            };
            hired_hand = {
                name = "HIRED HAND";
                desc1 = "";
                desc2 = "He was trapped in The Caves for a";
                desc3 = "very long time and is eager to be";
                desc4 = "free once again.";
                desc5 = "";
            };
            terra_tunnel = {
                name = "TERRA TUNNEL";
                desc1 = "";
                desc2 = "She met Manfred many years ago, ";
                desc3 = "when she rescued him from a cave-in.";
                desc4 = "Together they've built a thriving";
                desc5 = "shortcut building business!";
            };
            viking = {
                name = "HAGRID";
                desc1 = "";
                desc2 = "His time as a viking well prepared";
                desc3 = "him for the challenges of The Caves.";
                desc4 = "He was on board as soon as he heard";
                desc5 = "there would be treausre.";
            };
            meat_boy = {
                name = "MEAT MAN";
                desc1 = "";
                desc2 = "He was found growing inside of the";
                desc3 = "Worm. Whether or not he is indeed";
                desc4 = "human is unknown.";
                desc5 = "";
            };
            inuk = {
                name = "TONRAQ";
                desc1 = "";
                desc2 = "He's lived in the Ice Caves for ";
                desc3 = "many years and is intimately familiar";
                desc4 = "with its dangers.";
                desc5 = "";
            };
            aztec = {
                name = "YAOTL";
                desc1 = "";
                desc2 = "One of Kali's most devout followers.";
                desc3 = "Allegedly, he maintains a youthful";
                desc4 = "appearance by drinking from the Kapala.";
                desc5 = "";
            }; 
            mariachi = {
                name = "ENRIQUE";
                desc1 = "";
                desc2 = "After becoming fed up with his job";
                desc3 = "as a mailman, he set out to the caves";
                desc4 = "in hopes of striking it rich.";
                desc5 = "";
            }; 
            black = {
                name = "VAN HORSING";
                desc1 = "";
                desc2 = "A seasoned adventurer who took Yang's";
                desc3 = "initiative to re-explore The Caves as";
                desc4 = "an opportunity to continue his hunt ";
                desc5 = "for Vlad.";
            }; 
            carl = {
                name = "CARL";
                desc1 = "";
                desc2 = "A monster native to The Caves. He";
                desc3 = "doesn't quite understand why The";
                desc4 = "Spelunkers care so much for treasure.";
                desc5 = "";
            }; 
            robot = {
                name = "ROBOT";
                desc1 = "";
                desc2 = "An advanced automaton built by";
                desc3 = "Tiamat's firstborn. It's learning";
                desc4 = "algorithm has fixated on a particular";
                desc5 = "species of nightshade...";
            }; 
            gustaf = {
                name = "GUSTAF";
                desc1 = "";
                desc2 = "";
                desc3 = "gustaf.";
                desc4 = "";
                desc5 = "";
            }; 
            bearguy = {
                name = "ANDY";
                desc1 = "";
                desc2 = "With his warm and friendly exterior,";
                desc3 = "you wouldn't think he'd be such a";
                desc4 = "skilled Spelunker! It's almost as if he";
                desc5 = "designed The Caves himself...";
            }; 
        };
        --BESTIARY
        bestiary = {
            snake = {
                name = "SNAKE";
                desc1 = "";
                desc2 = "";
                desc3 = "Lean, green, slitherin' machines.";
                desc4 = "Simplstic and ever hissing.";
                desc5 = "";
            };
            cobra = {
                name = "COBRA";
                desc1 = "";
                desc2 = "";
                desc3 = "Adaptation has caused their spit";
                desc4 = "to become even more potent and rude!";
                desc5 = "";
            };
            spider = {
                name = "SPIDER";
                desc1 = "";
                desc2 = "";
                desc3 = "Oversized jumping siders that are";
                desc4 = "known for their ambush tactics.";
                desc5 = "";
            };
            hang_spider = {
                name = "HANG SPIDER";
                desc1 = "";
                desc2 = "To live to bungee, to die to bungee.";
                desc3 = "These spiders have life all figured";
                desc4 = "out, for without the hang, they're";
                desc5 = "just spiders.";
            };
            bat = {
                name = "BAT";
                desc1 = "";
                desc2 = "";
                desc3 = "These persistent little pests never";
                desc4 = "fail to get on anyone's nerves.";
                desc5 = "";
            };
            caveman = {
                name = "CAVEMAN";
                desc1 = "";
                desc2 = "Perhaps to know less is the secret";
                desc3 = "as to how these hominids thrive and";
                desc4 = "establish cultures in the ever-";
                desc5 = "changing Caves.";
            };
            scorpion = {
                name = "SCORPION";
                desc1 = "";
                desc2 = "It takes great comfort exposing";
                desc3 = "itself more often in these";
                desc4 = "districts.";
                desc5 = "";
            };
            skeleton = {
                name = "SKELETON";
                desc1 = "";
                desc2 = "Restless bones that never stop to ";
                desc3 = "ruin the expeditions of others, for";
                desc4 = "they themselves failed some point.";
                desc5 = "";
            };
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
        };
    };
    --DEATH MESSAGES
}

return module