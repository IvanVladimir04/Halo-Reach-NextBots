AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_jackal_ai"
ENT.PrintName = "Jackal"
ENT.StartHealth = 40
ENT.Models = {"models/halo_reach/characters/covenant/jackal_minor.mdl"}

ENT.CovRank = 1
ENT.IsSniper = false
ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_plasma_pistol"
}

list.Set( "NPC", "npc_iv04_hr_jackal_minor", {
	Name = "Jackal Minor",
	Class = "npc_iv04_hr_jackal_minor",
	Category = "Halo Reach"
} )