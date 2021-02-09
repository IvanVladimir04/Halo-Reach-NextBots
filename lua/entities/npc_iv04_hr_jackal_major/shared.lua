AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_jackal_ai"
ENT.PrintName = "Jackal"
ENT.StartHealth = 50
ENT.Models = {"models/halo_reach/characters/covenant/jackal_major.mdl"}

ENT.CovRank = 2
ENT.IsSniper = false
ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_plasma_pistol",
	[2] = "astw2_haloreach_needler",
	[3] = "astw2_haloreach_plasma_rifle"
}

list.Set( "NPC", "npc_iv04_hr_jackal_major", {
	Name = "Jackal Major",
	Class = "npc_iv04_hr_jackal_major",
	Category = "Halo Reach"
} )