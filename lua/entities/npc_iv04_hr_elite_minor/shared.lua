AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 50
ENT.Models = {"models/halo_reach/characters/covenant/elite_minor.mdl"}

ENT.CovRank = 1

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_rifle",
	[2] = "astw2_haloreach_plasma_repeater",
	[3] = "astw2_haloreach_needler",
	[4] = "astw2_halo2a_carbine"
}

list.Set( "NPC", "npc_iv04_hr_elite_minor", {
	Name = "Elite Minor",
	Class = "npc_iv04_hr_elite_minor",
	Category = "Halo Reach"
} )