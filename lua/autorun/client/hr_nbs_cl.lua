local tbl1 = {
	c = "Options", -- Category
	name = "Ivan04",
	sc = "Halo Reach NextBots", -- Subcategory
	id = "Halo_Reach_NextBots", -- Creative name
	dv = "Offensive", -- Default value (unticked value)
	d = "Defines how the AI Behaves",
	cv = "halo_reach_nextbots_ai_type",
	t = "combobox",
	n = "AI Mode",
	options = {
		[1] = "Offensive",
		[2] = "Defensive",
		[3] = "Static"
	},
	ic = {
		[1] = "vgui/modes/offensive.png",
		[2] = "vgui/modes/defensive.png",
		[3] = "vgui/modes/static.png"
	}
}
	
local tbl = {
	c = "Options", -- Category	
	name = "Ivan04",
	sc = "Halo Reach NextBots", -- Subcategory
	id = "Halo_Reach_NextBots", -- Creative name
	dv = "Heroic", -- Default value (unticked value)
	d = "Defines AI difficulty (Affects AI processing too), goes from 1 to 4, easy = 1, normal = 2, heroic = 3 and legendary = 4",
	cv = "halo_reach_nextbots_ai_difficulty",
	t = "combobox",
	n = "AI Difficulty",
	options = {
		[1] = "Easy",
		[2] = "Normal",
		[3] = "Heroic",
		[4] = "Legendary"
	},
	data = {
		[1] = 1,
		[2] = 2,
		[3] = 3,
		[4] = 4
	},
	selec = false,
	ic = {
		[1] = "vgui/difficulties/1_easy.png",
		[2] = "vgui/difficulties/2_normal.png",
		[3] = "vgui/difficulties/3_heroic.png",
		[4] = "vgui/difficulties/4_legendary.png"
	}
}

HRShieldMaterial = Material("models/halo_reach/characters/covenant/elite/minor/energy_shield")

local tbl2 = {
    c = "Options",
    name = "Ivan04",
    sc = "Halo Reach NextBots",
    id = "Halo_Reach_NextBots",
    dv = 1,
    d = "Should the hero characters be invincible?",
    cv = "halo_reach_nextbots_ai_heroes"
}

local tbl3 = {
    c = "Options",
    name = "Ivan04",
    sc = "Halo Reach NextBots",
    id = "Halo_Reach_NextBots",
    dv = 1,
    d = "Should the infection forms be able to climb?",
    cv = "halo_reach_nextbots_ai_flood_infection_climb"
}

IV04AddMenuOption( tbl )
IV04AddMenuOption( tbl1 )
IV04AddMenuOption( tbl2 )
IV04AddMenuOption( tbl3 )