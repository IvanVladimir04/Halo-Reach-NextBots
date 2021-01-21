AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 350
ENT.Models = {"models/halo_reach/characters/covenant/elite_field_marshall.mdl"}

ENT.CovRank = 4

ENT.Shield = 125

ENT.MaxShield = 125

ENT.StartWeapons = {
	[1] = "astw2_haloreach_energysword",
	[2] = "astw2_haloreach_concussion_rifle",
	[3] = "astw2_haloreach_plasma_repeater",
	[4] = "astw2_haloreach_fuel_rod",
	[5] = "astw2_haloreach_plasma_turret",
	[6] = "astw2_haloreach_plasma_launcher"
}

list.Set( "NPC", "npc_iv04_hr_elite_field_marshall", {
	Name = "Elite Field Marshall",
	Class = "npc_iv04_hr_elite_field_marshall",
	Category = "Halo Reach"
} )