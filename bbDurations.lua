local addon, ns = ...
local BigBuffsCooldowns = {}
ns.BigBuffsCooldowns = BigBuffsCooldowns

-- If you wish to disable an ability tracker, put '--' in front of the ID.

BigBuffsCooldowns.cooldown = {
	--Misc
	[107079] = 120,				-- Quaking Palm
	[28730] = 120,				-- Arcane Torrent
	[50613] = 120,				-- Arcane Torrent
	[80483] = 120,				-- Arcane Torrent
	[25046] = 120,				-- Arcane Torrent
	[69179] = 120,				-- Arcane Torrent
	[20572] = 120,				-- Blood Fury
	[33702] = 120,				-- Blood Fury
	[33697] = 120,				-- Blood Fury
	[59543] = 180,				-- Gift of the Naaru
	[69070] = 120,				-- Rocket Jump
	[26297] = 180,				-- Berserking
	[20594] = 120,				-- Stoneform
	[58984] = 120,				-- Shadowmeld
	[20589] = 90,				-- Escape Artist
	[59752] = 120,				-- Every Man for Himself
	[7744] = 120,				-- Will of the Forsaken
	[68992] = 120,				-- Darkflight
	[50613] = 120,				-- Arcane Torrent
	[20549] = 120,				-- War Stomp
	[69041] = 120,				-- Rocket Barrage
	[42292] = 120,				-- PvP Trinket
	
	--Pets(Death Knight)-----
	--[91797] = 60,				-- Monstrous Blow
	--[91837] = 45,				-- Putrid Bulwark
	--[91802] = 30,				-- Shambling Rush
	--[47482] = 30,				-- Leap
	--[91809] = 30,				-- Leap
	--[91800] = 60,				-- Gnaw
	--[47481] = 60,				-- Gnaw
	--Pets(Hunter)
	--[90339] = 60,				-- Harden Carapace
	[61685] = 25,				-- Charge
	[50519] = 120,				-- Sonic Blast
	--[35290] = 10,				-- Gore
	[50245] = 40,				-- Pin
	[50433] = 10,				-- Ankle Crack
	[26090] = 30,				-- Pummel
	--[93434] = 90,				-- Horn Toss
	--[57386] = 15,				-- Stampede
	[50541] = 60, 				-- Clench
	--[26064] = 60, 				-- Shell Shield
	--[35346] = 15, 				-- Time Warp
	--[93433] = 14,				-- Burrow Attack
	[91644] = 60,				-- Snatch
	--[54644] = 10,				-- Frost Breath
	--[34889] = 30,				-- Fire Breath
	--[50479] = 40,				-- Nether Shock
	--[50518] = 15,				-- Ravage
	[54706] = 40,				-- Vemom Web Spray
	[4167] = 40,				-- Web
	[50274] = 8,				-- Spore Cloud
	--[24844] = 30, 				-- Lightning Breath
	[90355] = 360,				-- Ancient Hysteria
	--[54680] = 8,				-- Monstrous Bite
	[90314] = 10,				-- Tailspin
	[50318] = 60,				-- Serenity Dust
	--[50498] = 6, 				-- Tear Armor
	[90361] = 30,				-- Spirit Mend
	[50285] = 25, 				-- Dust Cloud
	--[56626] = 90,				-- Sting
	--[24604] = 45,				-- Furious Howl
	--[90309] = 45,				-- Terrifying Roar
	--[24423] = 8,				-- Demoralizing Screech
	--[93435] = 45,				-- Roar of Courage
	--[58604] = 8,				-- Lava Breath
	[90327] = 40,				-- Lock Jaw
	[90337] = 120,				-- Bad Manner
	--[53490] = 180,				-- Bullheaded
	--[23145] = 32,				-- Dive
	[55709] = 480,				-- Heart of the Phoenix
	--[53401] = 90, 				-- Rabid
	[53476] = 30,				-- Intervene
	[53480] = 60,				-- Roar of Sacrifice
	[53478] = 360,				-- Last Stand
	[53517] = 180,				-- Roar of Recovery
	--Pets(Warlock)
	[124539] = 60,				-- Voidwalker: Disarm
	[19647] = 24,				-- Spell Lock
	[7812] = 60,				-- Sacrifice
	[89766] = 30,				-- Axe Toss"
	[89751] = 45,				-- Felstorm
	--Pets(Mage)
	[33395] = 25,				-- Freeze --No way to tell which WE cast this still usefull to some degree.
	
	--Death Knight----------
	[108200] = 60,				-- Remorseless Winter
	[108194] = 30,				-- Asphyxiate
	[108201] = 120,				-- Desecrated Ground
	[108199] = 60,				-- Gorefiend's Grasp
	[115989] = 90,				-- Unholy Blight
	[49039] = 120,				-- Lichborne
	[47476] = 60,				-- Strangulate
	[48707] = 45,				-- Anti-Magic Shell
	--[49576] = 25,				-- Death Grip	
	--[47528] = 15,				-- Mind Freeze
	[49222] = 60,				-- Bone Shield
	[51271] = 60,				-- Pillar of Frost
	--[51052] = 120,				-- Anti-Magic Zone
	--[49028] = 90, 				-- Dancing Rune Weapon
	[49206] = 180,				-- Summon Gargoyle
	--[43265] = 30,				-- Death and Decay
	[48792] = 180,				-- Icebound Fortitude
	[48743] = 120,				-- Death Pact
	--[42650] = 600,				-- Army of the Dead
	
	--Druid----------------
	--[33786] = 20,				-- Feral Cyclone
	[124974] = 90,				-- Nature's Vigil
	[102359] = 30,				-- Mass Entanglement
	[99] = 30,					-- Disorienting Roar
	[102280] = 30,				-- Displacer Beast
	[5211] = 50,				-- Mighty Bash
	[22812] = 60,				-- Barkskin
	[132158] = 60,				-- Nature's Swiftness
	--[33891] = 180,				-- Tree of Life
	[16979] = 15,				-- Wild Charge - Bear
	[49376] = 15,				-- Wild Charge - Cat
	[61336] = 180,				-- Survival Instincts
	[50334] = 180,				-- Berserk
	[132469] = 30,				-- Typhoon
	--[33831] = 60,				-- Force of Nature
	--[22570] = 10,				-- Maim
	--[18562] = 15,				-- Swiftmend
	[48505] = 90,				-- Starfall
	[78675] = 60,				-- Solar Beam
	[5211] = 50,				-- Bash
	--[22842] = 2,				-- Frenzied Regeneration
	--[16689] = 60, 				-- Nature's Grasp
	--[740] = 480,				-- Tranquility
	[80964] = 15,				-- Skull Bash
	[80965] = 15,				-- Skull Bash
	--[78674] = 15,				-- Starsurge
	[29166] = 180,				-- Innervate
	
	--Hunter--------------
	[120697] = 90,				-- Lynx Rush
	[120679] = 30,				-- Dire Beast
	[109248] = 45,				-- Binding Shot
	[1499] = 30,				-- Freezing Trap
	--[82726] = 30,				-- Fervor
	[19386] = 45,				-- Wyvern Sting
	[3045] = 180,				-- Rapid Fire
	[53351] = 10,				-- Kill Shot
	[53271] = 45, 				-- Master's Call
	--[51753] = 60,				-- Camouflage
	[19263] = 120,				-- Deterrence
	[19503] = 30,				-- Scatter Shot
	--[23989] = 300,				-- Readiness Removed as of 5.4
	[34490] = 24,				-- Silencing Shot
	[147362] = 24,				-- Counter Shot
	[19574] = 60,				-- Bestial Wrath      
	
	--Mage----------------
	[108839] = 45,				-- Ice Floes
	[110959] = 90,				-- Greater Invisibility
	[102051] = 20,				-- Frostjaw
	[2139] = 24,				-- Counterspell
	[44572] = 30,				-- Deep Freeze
	[11958] = 180,				-- Cold Snap
	[45438] = 300,				-- Ice Block		
	[12042] = 90,				-- Arcane Power		
	--[12051] = 120,				-- Evocation 
	[122] = 25,				-- Frost Nova	
	[11426] = 25,				-- Ice Barrier 
	[12472] = 180,				-- Icy Veins
	--[55342] = 180,				-- Mirror Image 
	[66] = 300,					-- Invisibility
	[113724] = 45,				-- Ring of Frost
	[80353] = 300, 				-- Time Warp
	--[11113] = 15, 				-- Blast Wave
	[12043] = 90,				-- Presence of Mind
	[11129] = 45,				-- Combustion
	[31661] = 20,				-- Dragon's Breath
	
	--Paladin--------------
	[115750] = 120,				-- Blinding Light
	[85499] = 45,				-- Speed of Light
	[105593] = 30,				-- Fist of Justice
	[1044] = 25,				-- Hand of Freedom
	[31884] = 180,				-- Avenging Wrath
	[853] = 60,					-- Hammer of Justice
	[31935] = 15,				-- Avenger's Shield
	[96231] = 15,				-- Rebuke
	[633] = 600,				-- Lay on Hands
	[1022] = 300,				-- Hand of Protection
	--[498] = 60,				-- Divine Protection
	--[54428] = 120,				-- Divine Plea
	[642] = 300,				-- Divine Shield
	[6940] = 120,				-- Hand of Sacrifice
	--[86669] = 180,				-- Guardian of Ancient Kings(Holy)
	--[31842] = 180,				-- Divine Favor
	[31821] = 180,				-- Devotion Aura
	[20066] = 15,				-- Repentance
	--[31850] = 180,				-- Ardent Defender
	
	--Priest----------------
	--[605] = 30,					-- Dominate Mind
	[108921] = 45,				-- Psyfiend
	--[123040] = 60,				-- Mindbender
	[108920] = 30,				-- Void Tendrils
	[89485] = 45,				-- Inner Focus
	[64044] = 45,				-- Psychic Horror
	[8122] = 30,				-- Psychic Scream
	[15487] = 45,				-- Silence
	[47585] = 120,				-- Dispersion
	[33206] = 180,				-- Pain Suppression
	[10060] = 120,				-- Power Infusion
	[88625] = 30,				-- Holy Word: Chastise
	--[586] = 30,				-- Fade
	--[112833] = 30,			-- Spectral Guise
	--[32379] = 8,				-- Shadow Word: Death
	--[6346] = 180,				-- Fear Ward
	--[64901] = 360,				-- Hymn of Hope
	--[64843] = 180,				-- Divine Hymn
	[73325] = 90,				-- Leap of Faith
	--[19236] = 120,				-- Desperate Prayer
	--[724] = 180,				-- Lightwell
	--[62618] = 180,				-- Power Word: Barrier
	
	--Rogue-----------------
	[121471] = 180,				-- Shadow Blades
	--[1776] = 10,				-- Gouge
	--[2094] = 120,				-- Blind
	--[1766] = 15,				-- Kick
	--[2983] = 60,				-- Sprint
	[14185] = 300,				-- Preparation
	[31224] = 60,				-- Cloak of Shadows
	[1856] = 120,				-- Vanish
	--[36554] = 20,				-- Shadowstep
	--[5277] = 120,				-- Evasion
	--[408] = 20,				-- Kidney Shot
	--[51722] = 60,				-- Dismantle
	[76577] = 180,				-- Smoke Bomb
	[51690] = 120,				-- Killing Spree
	[51713] = 60, 				-- Shadow Dance
	[79140] = 120,				-- Vendetta
	
	--Shaman----------------
	--[5394] = 30,				-- Healing Stream Totem
	[108269] = 45,				-- Capacitor Totem
	[108270] = 60,				-- Stone Bulwark Totem
	[108280] = 180,				-- Healing Tide Totem
	[98008] = 180,				-- Spirit Link Totem
	[8177] = 25,				-- Grounding Totem
	[57994] = 12,				-- Wind Shear
	[32182] = 300,				-- Heroism
	[2825] = 300,				-- Bloodlust
	[51533] = 120,				-- Feral Spirit
	[16190] = 180,				-- Mana Tide Totem
	[30823] = 60,				-- Shamanistic Rage
	[51490] = 45,				-- Thunderstorm
	[2484] = 30,				-- Earthbind Totem
	[8143] = 60,				-- Tremor Totem
	[51514] = 45,				-- Hex
	[79206] = 120,				-- Spiritwalker's Grace
	[16166] = 90,				-- Elemental Mastery
	--[16188] = 90,				-- Ancestral Swiftness
	
	--Warlock----------------
	[111397] = 30,				-- Blood Horror
	[110913] = 180,				-- Dark Bargain
	[108482] = 60,				-- Unbound Will
	[108359] = 120,				-- Dark Regeneration
	[108416] = 60,				-- Sacrificial Pact
	--[111397] = 10,				-- Blood Fear Removed as of 5.3
	[30283] = 30,				-- Shadowfury
	[6789] = 45,				-- Mortal Coil
	--[6229] = 30,				-- Shadow Ward
	[5484] = 40,				-- Howl of Terror
	--[54785] = 45,				-- Demon Leap
	[48020] = 30,				-- Demonic Circle: Teleport
	--[91711] = 30,				-- Nether Ward
	
	--Warrior----------------
	[107574] = 180,				-- Avatar
	[12292] = 60, 				-- Bloodbath
	--[86346] = 20,				-- Colossus Smash
	--[85730] = 60,				-- Deadly Calm Removed as of 5.2
	[100] = 20,					-- Charge
	[6552] = 15,				-- Pummel
	[102060] = 40,				-- Disrupting Shot
	[23920] = 25,				-- Spell Reflection
	[676] = 60,					-- Disarm
	[5246] = 90,				-- Intimidating Shout
	[871] = 180,				-- Shield Wall	
	[118038] = 120,				-- Die by the Sword
	[1719] = 180,				-- Recklessness
	[3411] = 30,				-- Intervene
	[64382] = 300,				-- Shattering Throw
	[6544] = 30,				-- Heroic Leap All Warriors use glyph de Death from above anyway
	[12975] = 180,				-- Last Stand
	[46924] = 60,				-- Bladestorm
	[46968] = 40,				-- Shockwave
	
	--Monk-----------------
	[123904] = 180,				-- Invoke Xuen, the White Tiger
	--[116847] = 6,				-- Rushing Jade Wind
	[101643] = 45,				-- Transcendence
	[119996] = 25,				-- Transcendence: Transfer
	[115176] = 180,				-- Zen Meditation
	[115310] = 180,				-- Revival
	[122278] = 90, 				-- Dampen Harm
	[122783] = 90,				-- Diffuse Magic
	[117368] = 60,				-- Grapple Weapon
	[119381] = 45,				-- Leg Sweep
	[116844] = 45,				-- Ring of Peace
	[116849] = 120,				-- Life Cocoon
	[115078] = 15,				-- Paralysis
	[116705] = 15,				-- Spear Hand Strike
	[137562] = 120,				-- Nimble Brew
	[122470] = 90,				-- Touch of Karma
	--[115450] = 8,				-- Detox
	[101545] = 25,				-- Flying Serpent Kick
	[116841] = 30,				-- Tiger's Lust
	[113656] = 25,				-- Fists of Fury
	[122057] = 35,				-- Clash
	[116705] = 15,				-- Spear Hand Strike	
}

BigBuffsCooldowns.duration = {
	--Misc------------------
	[20572] = 15,				-- Blood Fury
	[33702] = 15,				-- Blood Fury
	[33697] = 15,				-- Blood Fury
	--[59543] = 15,				-- Gift of the Naaru
	[26297] = 10,				-- Berserking
	--[20594] = ,				-- Stoneform
	--[68992] = 10,				-- Darkflight
	
	--Death Knight----------
	--[49222] = 300,				-- Bone Shield
	[51271] = 20,				-- Pillar of Frost
	--[49028] = 12, 				-- Dancing Rune Weapon
	--[49206] = 30,				-- Gargoyle
	[49016] = 30,				-- Unholy Frenzy
	[55233] = 10,				-- Vampiric Blood
	[108200] = 8,				-- Remorseless Winter
	--[108201] = 10,				-- Desecrated Ground
	--[96268] = 6,				-- Death's Advance
	--[49039] = 10,				-- Lichborne
	--[115989] = 10,			-- Unholy Blight
	[48792] = 12,				-- Icebound Fortitude
	[48707] = 5,				-- Anti-Magic Shell
	--[43265] = 10,				-- Death and Decay
	--[51052] = 3,				-- Anti-Magic Zone
	
	--Druid----------------
	--[1850] = 15,				-- Dash
	[22812] = 12,				-- Barkskin
	--[16689] = 45,				-- Nature's Grasp
	--[29166] = 10,				-- Innervate
	[106922] = 20,				-- Might of Ursoc
	--[740] = 8,				-- Tranquility
	--[102280] = 4,				-- Displacer Beast
	--[102351] = 30,				-- Cenarion Ward
	[124974] = 12,				-- Nature's Vigil
	[108288] = 45,				-- Heart of the Wild
	[112071] = 15,				-- Celestial Alignment
	[132158] = 999,				-- Nature's Swiftness
	[48505] = 10,				-- Starfall
	[106952] = 15,				-- Berserk
	[61336] = 12,				-- Survival Instincts
	[5217] = 6,					-- Tiger's Fury"
	[5229] = 10,				-- Enrage
	[102342] = 12,				-- Ironbark
	[33891] = 30,				-- Tree of Life
		
	--Hunter----------------
	[3045] = 15,				-- Rapid Fire
	[19263] = 5,				-- Deterrence
	[121818] = 20,				-- Stampede
	[90355] = 40,				-- Ancient Hysteria
	
	--Warrior---------------
	
	--Shaman----------------
	[2825] = 40,				-- Bloodlust
	
	--Paladin---------------
	
	--Warlock---------------
	
	--Mage------------------
	[80353] = 40,				-- Time Warp
	
	
	--Priest----------------
	
	--Rogue-----------------
	
	--Monk------------------
	
}
