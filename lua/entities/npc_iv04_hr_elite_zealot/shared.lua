AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 350
ENT.Models = {"models/halo_reach/characters/covenant/elite_zealot.mdl"}

ENT.CovRank = 5

ENT.Shield = 140

ENT.MaxShield = 140

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_rifle",
	[2] = "astw2_haloreach_energysword",
	[3] = "astw2_haloreach_concussion_rifle",
	[4] = "astw2_haloreach_fuel_rod",
	[5] = "astw2_haloreach_concussion_rifle"
}

list.Set( "NPC", "npc_iv04_hr_elite_zealot", {
	Name = "Elite Zealot",
	Class = "npc_iv04_hr_elite_zealot",
	Category = "Halo Reach"
} )