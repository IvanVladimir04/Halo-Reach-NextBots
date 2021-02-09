AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 300
ENT.Models = {"models/halo_reach/characters/covenant/elite_general.mdl"}

ENT.CovRank = 3

ENT.Shield = 125

ENT.MaxShield = 125

ENT.StartWeapons = {
	[1] = "astw2_haloreach_energysword",
	[2] = "astw2_haloreach_concussion_rifle",
	[3] = "astw2_haloreach_plasma_repeater",
	[4] = "astw2_haloreach_fuel_rod",
	[5] = "astw2_haloreach_plasma_turret",
	[6] = "astw2_haloreach_plasma_launcher",
	[7] = "astw2_halo2a_plasmacannon"
}

list.Set( "NPC", "npc_iv04_hr_elite_general", {
	Name = "Elite General",
	Class = "npc_iv04_hr_elite_general",
	Category = "Halo Reach"
} )