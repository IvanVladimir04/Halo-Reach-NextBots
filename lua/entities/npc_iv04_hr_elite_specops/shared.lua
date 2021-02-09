AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 150
ENT.Models = {"models/halo_reach/characters/covenant/elite_specops.mdl"}

ENT.CovRank = 3

ENT.Shield = 125

ENT.MaxShield = 125

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_rifle",
	[2] = "astw2_haloreach_energysword",
	[3] = "astw2_haloreach_needler_rifle",
	[4] = "astw2_halo2a_carbine",
	[5] = "astw2_halo2a_beamrifle"
}

list.Set( "NPC", "npc_iv04_hr_elite_specops", {
	Name = "Elite Spec-Ops",
	Class = "npc_iv04_hr_elite_specops",
	Category = "Halo Reach"
} )