AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 325
ENT.Models = {"models/halo_reach/characters/covenant/elite_ultra.mdl"}

ENT.CovRank = 3

ENT.Shield = 110

ENT.MaxShield = 110

ENT.StartWeapons = {
	[1] = "astw2_haloreach_concussion_rifle",
	[2] = "astw2_haloreach_plasma_repeater",
	[3] = "astw2_haloreach_needler_rifle",
	[4] = "astw2_halo2a_carbine"
}

list.Set( "NPC", "npc_iv04_hr_elite_ultra", {
	Name = "Elite Ultra",
	Class = "npc_iv04_hr_elite_ultra",
	Category = "Halo Reach"
} )