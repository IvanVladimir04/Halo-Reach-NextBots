AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 215
ENT.Models = {"models/halo_reach/characters/covenant/elite_major.mdl"}

ENT.CovRank = 2

ENT.Shield = 90

ENT.MaxShield = 90

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_rifle",
	[2] = "astw2_haloreach_needler",
	[3] = "astw2_halo2a_carbine",
	[4] = "astw2_haloreach_concussion_rifle"
}

list.Set( "NPC", "npc_iv04_hr_elite_major", {
	Name = "Elite Major",
	Class = "npc_iv04_hr_elite_major",
	Category = "Halo Reach"
} )