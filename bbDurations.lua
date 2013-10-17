local addon, ns = ...
local BigBuffsCooldowns = {}
ns.BigBuffsCooldowns = BigBuffsCooldowns

-- If you wish to disable an ability tracker, put '--' in front of the ID.

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
	--[108200] = 8,				-- Remorseless Winter
	--[108201] = 10,				-- Desecrated Ground
	--[96268] = 6,				-- Death's Advance
	--[49039] = 10,				-- Lichborne
	--[115989] = 10,			-- Unholy Blight
	[48792] = 12,				-- Icebound Fortitude
	[48707] = 5,				-- Anti-Magic Shell
	--[43265] = 10,				-- Death and Decay
	--[51052] = 3,				-- Anti-Magic Zone
	
	--Druid----------------
	[1850] = 15,				-- Dash
	[22812] = 12,				-- Barkskin
	[16689] = 45,				-- Nature's Grasp
	[29166] = 10,				-- Innervate
	[106922] = 20,				-- Might of Ursoc
	--[740] = 8,				-- Tranquility
	--[102280] = 4,				-- Displacer Beast
	[102351] = 30,				-- Cenarion Ward
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
		
}

