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
            olmec = {
                name = "OLMEC'S LAIR";
                desc1 = "";
                desc2 = "After all these years, he's still";
                desc3 = "here! Don't let nostalgia blind you:";
                desc4 = "Olmec is still the boss.";
                desc5 = "";
            };
            hell = {
                name = "HELL";
                desc1 = "";
                desc2 = "It's been 15 years since this place was ";
                desc3 = "left a cold cinder, only to suddenly";
                desc4 = "reignite as the once thought tamed ";
                desc5 = "Yama regained fury";
            };
            yama = {
                name = "YAMA'S THRONE";
                desc1 = "";
                desc2 = "The king of Hell waits on this";
                desc3 = "throne, ready to judge any who";
                desc4 = "cross his path. He's probably not";
                desc5 = "happy with you.";
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
                desc3 = "Allegedly, drinking from the Kapala";
                desc4 = "regularly is how he maintains such";
                desc5 = "a youthful appearance.";
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
                desc3 = "Oversized, jumping spiders that are";
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
            damsels = {
                name = "THE PETS";
                desc1 = "";
                desc2 = "It may not be the wisest decision";
                desc3 = "to bring our pets along, but their";
                desc4 = "emotional support is heavily";
                desc5 = "appreciated!";                
            };
            giant_spider = {
                name = "GIANT SPIDER";
                desc1 = "";
                desc2 = "Oddly enough, they're more common ";
                desc3 = "on The Moon than on Earth. In spite";
                desc4 = "of their utility, it's hard to make";
                desc5 = "peace with those lips.";
            };
            scorpion = {
                name = "SCORPION";
                desc1 = "";
                desc2 = "";
                desc3 = "It takes great comfort exposing";
                desc4 = "itself more often in these districts.";
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
            scarab = {
                name = "SCARAB";
                desc1 = "";
                desc2 = "A symbol of worship made out of ";
                desc3 = "pure gold! Well, mostly gold, about";
                desc4 = "80% or so, give or take.";
                desc5 = "";
            };
            tikiman = {
                name = "TIKI MAN";
                desc1 = "";
                desc2 = "Any rumors surrounding their proposed";
                desc3 = "cannibalism have been greatly";
                desc4 = "exaggerated. However, that doesn't";
                desc5 = "make them any kinder to strangers.";
            };
            frog = {
                name = "FROG";
                desc1 = "";
                desc2 = "A fine specimen veiled in cobalt";
                desc3 = "blue skin. They are quite popular";
                desc4 = "on social media.";
                desc5 = "";
            };
            fire_frog = {
                name = "FIRE FROG";
                desc1 = "";
                desc2 = "The feistier cousin of the frog";
                desc3 = "with an explosive defense";
                desc4 = "mechanism.";
                desc5 = "";
            };
            giant_frog = {
                name = "GIANT FROG";
                desc1 = "";
                desc2 = "An amphibious colossus of the";
                desc3 = "jungle that wanders the dense ";
                desc4 = "foliage, fufilling its purpose";
                desc5 = "of spreading its offspring.";
            };
            mantrap = {
                name = "MANTRAP";
                desc1 = "";
                desc2 = "I wouldn't touch these plants";
                desc3 = "with a 10 foot pole. Sporting";
                desc4 = "deadly reflexes, they're known";
                desc5 = "to devour explorers in one bite.";
            };
            piranha = {
                name = "PIRANHA";
                desc1 = "At least that's what they're";
                desc2 = "called. They look much more unusual";
                desc3 = "compared to the ones I'm familiar";
                desc4 = "with. But nonetheless, they still";
                desc5 = "have a craving for flesh.";
            };
            great_humphead = {
                name = "GREAT HUMPHEAD";
                desc1 = "A great flooding followed by a ";
                desc2 = "biotic invasion within The Cursed";
                desc3 = "Caves caused Old Bitey to be";
                desc4 = "overthrown by The Emporer of";
                desc5 = "the sea.";
            };
            bee = {
                name = "BEE";
                desc1 = "";
                desc2 = "Devoted to protecting the colony,";
                desc3 = "it's no surprise their erratic";
                desc4 = "attack patterns bring so much";
                desc5 = "trouble.";
            };
            queen_bee = {
                name = "QUEEN BEE";
                desc1 = "";
                desc2 = "The royal highness of The Jungle.";
                desc3 = "She keeps a vast amount of royal";
                desc4 = "jelly on her abdomen to feed and";
                desc5 = "care for her colony.";
            };
            snail = {
                name = "SNAIL";
                desc1 = "";
                desc2 = "Stinky mollusks that can create";
                desc3 = "highly poisonous bubbles as a ";
                desc4 = "defense mechanism.";
                desc5 = "";
            };
            monkey = {
                name = "MONKEY";
                desc1 = "";
                desc2 = "You will never tire of these";
                desc3 = "pesky little vermin! Fortunately,";
                desc4 = "a rope usually does the trick.";
                desc5 = "";
            };
            golden_monkey = {
                name = "GOLDEN MONKEY";
                desc1 = "";
                desc2 = "This poor fella just can't ";
                desc3 = "catch a break from its curse. It";
                desc4 = "will always put itself in danger!";
                desc5 = "";
            };
            jiangshi = {
                name = "JIANG SHI";
                desc1 = "Invading from The Tide Pool";
                desc2 = "district, these hopping ghouls";
                desc3 = "take refuge in the burial grounds";
                desc4 = "of The Jungle to seek for lingering";
                desc5 = "life essence.";
            };
            vampire = {
                name = "VAMPIRE";
                desc1 = "";
                desc2 = "The versatility of man with the";
                desc3 = "persistency of a bat. Truly a";
                desc4 = "formidable combination!";
                desc5 = "";
            };
            green_knight = {
                name = "GREEN KNIGHT";
                desc1 = "";
                desc2 = "Although rumors of immortal";
                desc3 = "knights have been disproven,";
                desc4 = "their dedication to playing the";
                desc5 = "part always gets my respect.";
            };
            black_knight = {
                name = "BLACK KNIGHT";
                desc1 = "";
                desc2 = "A true lunatic of The Haunted";
                desc3 = "Castle, The Black Knight haunts";
                desc4 = "the halls with the souls of his";
                desc5 = "crushed victims.";
            };
            ghost = {
                name = "THE GHOST";
                desc1 = "";
                desc2 = "The vengeful soul of the empress,";
                desc3 = "now completely soulbound and ";
                desc4 = "dedicated to eliminating all";
                desc5 = "tresspassers.";
            };
            bacterium = {
                name = "BACTERIUM";
                desc1 = "";
                desc2 = "Organisms that feed off of";
                desc3 = "foreign invaders and provide";
                desc4 = "sustenance for the babies";
                desc5 = "developing inside. Gross!";
            };
            worm_egg = {
                name = "WORM EGG";
                desc1 = "";
                desc2 = "Initially, I wasn't one to";
                desc3 = "consider the strangeness of The";
                desc4 = "Worm's reproductive methods.";
                desc5 = "";
            };
            worm_baby = {
                name = "WORM BABY";
                desc1 = "";
                desc2 = "They spend most of their youth";
                desc3 = "developing inside of The Worm";
                desc4 = "before dispersing and becoming";
                desc5 = "equally as gigantic as their mother.";
            };
            yeti = {
                name = "YETI";
                desc1 = "They know what gum is, and they're";
                desc2 = "all out. They've dropped their";
                desc3 = "kind and misunderstood demeanor";
                desc4 = "to proceed their conquest for";
                desc5 = "more chew.";
            };
            yeti_king = {
                name = "YETI KING";
                desc1 = "";
                desc2 = "The yetis on Earth have no";
                desc3 = "matriarchy, and are ruled by a";
                desc4 = "single male.";
                desc5 = "";
            };
            mammoth = {
                name = "MAMMOTH";
                desc1 = "";
                desc2 = "Through shady and unspoken";
                desc3 = "conversation projects, these";
                desc4 = "ornery behemoths roam The Ice";
                desc5 = "Caves once more.";
            };
            alien = {
                name = "ALIEN";
                desc1 = "";
                desc2 = "A not-as-inquisitive but ever";
                desc3 = "illusive race of war hungry ";
                desc4 = "invaders bent on destruction";
                desc5 = "despite their endeearing looks.";
            };
            ufo = {
                name = "UFO";
                desc1 = "";
                desc2 = "";
                desc3 = "Such volatile power contained";
                desc4 = "in a witty-bitty space! ";
                desc5 = "";
            };
            alientank = {
                name = "ALIEN TANK";
                desc1 = "";
                desc2 = "Frankly, it's a miracle that these";
                desc3 = "defenses are still deemed";
                desc4 = "suitable by The Queen.";
                desc5 = "";
            };
            alienlord = {
                name = "ALIEN LORD";
                desc1 = "";
                desc2 = "A misnomer within their title,";
                desc3 = "they primarily serve as future";
                desc4 = "heirs to the throne of their";
                desc5 = "Mighty Queen.";
            };
            alienqueen = {
                name = "ALIEN QUEEN";
                desc1 = "";
                desc2 = "A clone of the cosmic warlord,";
                desc3 = "back to her old habits of setting";
                desc4 = "up refuge to plot her nefarious";
                desc5 = "schemes.";
            };
            hawkman = {
                name = "HAWK MAN";
                desc1 = "";
                desc2 = "Half hawk, half man. Completely";
                desc3 = "devoted to stopping unworthy";
                desc4 = "tresspassers.";
                desc5 = "";
            };
            crocman = {
                name = "CROCMAN";
                desc1 = "";
                desc2 = "Despicably agitated mutants ";
                desc3 = "infamous for their magic and";
                desc4 = "sheer brutality.";
                desc5 = "";
            };
            magmar = {
                name = "MAGMAR";
                desc1 = "";
                desc2 = "Sometimes, a pile of bones won't";
                desc3 = "be enough, and the soul of an";
                desc4 = "explorer will go as far as to take";
                desc5 = "the form of sentient magma.";
            };
            scorpionfly = {
                name = "SCORPION FLY";
                desc1 = "";
                desc2 = "The scorpion's cousin with some";
                desc3 = "weird investment decisions. It is";
                desc4 = "not a graceful flyer.";
                desc5 = "";
            };
            mummy = {
                name = "MUMMY";
                desc1 = "";
                desc2 = "Tomb lords of The Temple that";
                desc3 = "exhale vile purges of rancid";
                desc4 = "flies and bodily fluids. Not";
                desc5 = "for the faint of heart.";
            };
            anubis = {
                name = "ANUBIS";
                desc1 = "";
                desc2 = "";
                desc3 = "Our most consistent rival who";
                desc4 = "needs no introduction.";
                desc5 = "";
            };
            anubis2 = {
                name = "ANUBIS II";
                desc1 = "";
                desc2 = "Can't say how many second";
                desc3 = "chances this ruler gets, but";
                desc4 = "his determination is admirable";
                desc5 = "to say the least.";
            };
            olmec = {
                name = "OLMEC";
                desc1 = "";
                desc2 = "Though not the cause of the";
                desc3 = "curse, somehow Olmec is a part";
                desc4 = "of it. A truly formidable foe";
                desc5 = "that plays by its own rules.";
            };
            vlad = {
                name = "VLAD";
                desc1 = "";
                desc2 = "Overjoyed with the news of his";
                desc3 = "returning master, Vlad exhumes";
                desc4 = "out of retirement to return as";
                desc5 = "Overseer of Hell's entry gates.";
            };
            imp = {
                name = "IMP";
                desc1 = "";
                desc2 = "Returning from Volcana back";
                desc3 = "to their old boss, they're";
                desc4 = "happy to be getting paid more";
                desc5 = "than last time around.";
            };
            devil = {
                name = "DEVIL";
                desc1 = "";
                desc2 = "Belligerant and way, Devils patrol";
                desc3 = "the inferno seeking for souls to ";
                desc4 = "send to their ruler.";
                desc5 = "";
            };
            succubus = {
                name = "SUCCUBUS";
                desc1 = "";
                desc2 = "She uses shapeshifting magic to";
                desc3 = "trick and subdue her victims.";
                desc4 = "Vlad's mistress.";
                desc5 = "";
            };
            horsehead = {
                name = "HORSEHEAD";
                desc1 = "";
                desc2 = "";
                desc3 = "Bears the face of a horse. Yama's";
                desc4 = "loyal right-hand man.";
                desc5 = "";
            };
            oxface = {
                name = "OXFACE";
                desc1 = "";
                desc2 = "";
                desc3 = "Don's the face of an ox. Yama's";
                desc4 = "loyal left-hand man.";
                desc5 = "";
            };
            kingyama = {
                name = "KING YAMA";
                desc1 = "";
                desc2 = "King Yama's back and livid once";
                desc3 = "more! He has unfinished business";
                desc4 = "with these pesky spelunkers.";
                desc5 = "";
            };
        };
        --ITEMS
        items = {
            rope_pile = {
                name = "ROPE PILE";
                desc1 = "";
                desc2 = "";
                desc3 = "Contains 3 bundles of ropes.";
                desc4 = "";
                desc5 = "";
            };
            bomb_bag = {
                name = "BOMB BAG";
                desc1 = "";
                desc2 = "";
                desc3 = "The bag of relative delight.";
                desc4 = "contains 3 bombs.";
                desc5 = "";
            };
            spectacles = {
                name = "SPECTACLES";
                desc1 = "";
                desc2 = "For improved vision in the dark"; 
                desc3 = "and to find treasures hidden";
                desc4 = "within!";
                desc5 = "";
            };
            climbing_gloves = {
                name = "CLIBMING GLOVES";
                desc1 = "";
                desc2 = "I remember how much stickier the"; 
                desc3 = "older models were. Hopefully these";
                desc4 = "new ones will make climbing walls";
                desc5 = "a bit less of a hassle!";
            };
            pitchers_mitt = {
                name = "PITCHER'S MITT";
                desc1 = "";
                desc2 = "Something about these gloves just"; 
                desc3 = "gives the wielder better confidence";
                desc4 = "to punt objects with great velocity.";
                desc5 = "";
            };
            spring_shoes = {
                name = "SPRING SHOES";
                desc1 = "Enhanced with alien technology, "; 
                desc2 = "these shoes are making it big out";
                desc3 = "in the surface world, and it's no";
                desc4 = "surprise-- what with how fun they";
                desc5 = "are to hop around with!";
            };
            spike_shoes = {
                name = "SPIKE SHOES";
                desc1 = ""; 
                desc2 = "A mountain climber's best friend.";
                desc3 = "Provides extreme traction and";
                desc4 = "heavy stomping power.";
                desc5 = "";
            };
            paste = {
                name = "PASTE";
                desc1 = ""; 
                desc2 = "Even just a tiny amount of this";
                desc3 = "stuff will let your bombs stick";
                desc4 = "to virtually anything!";
                desc5 = "";
            };
            comapss = {
                name = "COMPASS";
                desc1 = ""; 
                desc2 = "The strange magnetism of the";
                desc3 = "caves gives compasses an eerie";
                desc4 = "sense of direction towards";
                desc5 = "treasure.";
            };
            mattock = {
                name = "MATTOCK";
                desc1 = ""; 
                desc2 = "The're almost never found in";
                desc3 = "good quality down here, so make";
                desc4 = "every swing count!";
                desc5 = "";
            };
            boomerang = {
                name = "BOOMERANG";
                desc1 = "Most of the boomerangs found "; 
                desc2 = "here are carved by the sturdy";
                desc3 = "wood of the jungle that's";
                desc4 = "lightweight and deadly. The";
                desc5 = "trademark weapon of the Tikimen.";
            };
            machete = {
                name = "MACHETE";
                desc1 = "";
                desc2 = "It's a bit dull, but still";
                desc3 = "sharp enough to hack and slice";
                desc4 = "through adversaries";
                desc5 = "";
            };
            crysknife = {
                name = "CRYSKNIFE";
                desc1 = "";
                desc2 = "Unfathomably sharp, this worm";
                desc3 = "tooth can cut through just about";
                desc4 = "anything with ease.";
                desc5 = "";
            };
            web_gun = {
                name = "WEB GUN";
                desc1 = "";
                desc2 = "To be fair, web shooting IS";
                desc3 = "quite a niche market. But if";
                desc4 = "you're creative enough, you may";
                desc5 = "find some use for this thing.";
            };
            shotgun = {
                name = "SHOTGUN";
                desc1 = "An old man's best friend;";
                desc2 = "Blessed with infinite ammunition,";
                desc3 = "it can be your best friend, too.";
                desc4 = "Just be careful your pellets";
                desc5 = "don't get reflected!";
            };
            freeze_ray = {
                name = "FREEZE RAY";
                desc1 = "";
                desc2 = "Originally designed to mimic the";
                desc3 = "freezing blasts of the mammoth, I";
                desc4 = "can now confirm that a mammoth's is";
                desc5 = "much colder!";
            };
            plasma_cannon = {
                name = "PLASMA CANNON";
                desc1 = "";
                desc2 = "A mighty firearm that proves too";
                desc3 = "powerful for its own creators. It";
                desc4 = "takes major resposnbility to wield";
                desc5 = "this kind of tech.";
            };
            camera = {
                name = "CAMERA";
                desc1 = "";
                desc2 = "I remember being able to flash ";
                desc3 = "myself with these by accident!";
                desc4 = "They're very dangerous to undead";
                desc5 = "creatures.";
            };
            teleporter = {
                name = "TELEPORTER";
                desc1 = "";
                desc2 = "In theory, this kind of tool";
                desc3 = "should make exploring The Caves a";
                desc4 = "breeze! In practice? Well...";
                desc5 = "";
            };
            parachute = {
                name = "PARACHUTE";
                desc1 = "";
                desc2 = "These can be real life savers if";
                desc3 = "you ever miss a jump or trip off";
                desc4 = "a ledge.";
                desc5 = "";
            };
            cape = {
                name = "CAPE";
                desc1 = "";
                desc2 = "They're made out the fine strands";
                desc3 = "of a mystical feather. Unforunately,";
                desc4 = "it does not allow for flight.";
                desc5 = "";
            };
            jetpack = {
                name = "JETPACK";
                desc1 = "";
                desc2 = "Many explorers consider the jetpack";
                desc3 = "a necessity for spelunking. Just";
                desc4 = "make sure to watch the fuel levels!";
                desc5 = "";
            };
            shield = {
                name = "SHIELD";
                desc1 = "";
                desc2 = "It is forged from an incredibly";
                desc3 = "durable metal. Wielded by the ";
                desc4 = "unruly Black Knight.";
                desc5 = "";
            };
            royal_jelly = {
                name = "ROYAL JELLY";
                desc1 = "";
                desc2 = "Delicious nectar created by the";
                desc3 = "the queen of a beehive. It has ";
                desc4 = "profound medicinal properties.";
                desc5 = "";
            };
            idol = {
                name = "IDOL";
                desc1 = "";
                desc2 = "A figurine which acts as a";
                desc3 = "vessel of gods. Of course, to";
                desc4 = "explorers, it may as well just";
                desc5 = "be a big bag of cash.";
            };
            crystal_skull = {
                name = "CRYSTAL SKULL";
                desc1 = "";
                desc2 = "If an idol made of solid gold";
                desc3 = "excites you, just wait until";
                desc4 = "you find one of these! It's";
                desc5 = "surprisingly heavy.";
            };
            kapala = {
                name = "KAPALA";
                desc1 = "";
                desc2 = "Kali's gift to her most devout";
                desc3 = "followers. Drinking from the";
                desc4 = "Kapala is known to provide";
                desc5 = "significant strength and vigor.";
            };
            udjat_eye = {
                name = "UDJAT EYE";
                desc1 = "";
                desc2 = "A mystic eye that seeks its ruler";
                desc3 = "and will do everything in its ";
                desc4 = "power to guide its current wielder";
                desc5 = "to them.";
            };
            ankh = {
                name = "ANKH";
                desc1 = "";
                desc2 = "A priceless relic that is";
                desc3 = "able to grant the holder a";
                desc4 = "second chance at life. Anubis";
                desc5 = "is known to wear one.";
            };
            hedjet = {
                name = "HEDJET";
                desc1 = "";
                desc2 = "The symbol of Egyptian power,";
                desc3 = "glistening with a brilliant";
                desc4 = "glow.";
                desc5 = "";
            };
            scepter = {
                name = "SCEPTER";
                desc1 = "";
                desc2 = "The infamous tool of Anubis.";
                desc3 = "misuse can easily bring the";
                desc4 = "demise of its wielder.";
                desc5 = "";
            };
            botd = {
                name = "BOOK OF THE DEAD";
                desc1 = "";
                desc2 = "An ancient scroll that contains";
                desc3 = "necromatic wisdom. It provides the";
                desc4 = "location of intense soul energy.";
                desc5 = "";
            };
            vlads_cape = {
                name = "VLAD'S CAPE";
                desc1 = "";
                desc2 = "A silky smooth cape worn by Vlad.";
                desc3 = "Along with increased bloodlust, it";
                desc4 = "provides vampire-like mobility.";
                desc5 = ""
            };
            vlads_amulet = {
                name = "VLAD'S AMULET";
                desc1 = "";
                desc2 = "A powerful jewel that makes the";
                desc3 = "user impervious to lava. It was";
                desc4 = "a gift to Vlad from Yama.";
                desc5 = ""
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