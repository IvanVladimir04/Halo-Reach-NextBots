AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_skirmisher_ai"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 75
ENT.Models = {"models/halo_reach/characters/covenant/skirmisher_minor.mdl"}

ENT.CovRank = 1
ENT.ShieldUp = false
ENT.PossibleWeapons = {
	"astw2_haloreach_plasma_pistol",
	"astw2_haloreach_needler_rifle"
}

list.Set( "NPC", "npc_iv04_hr_skirmisher_minor", {
	Name = "Skirmisher Minor",
	Class = "npc_iv04_hr_skirmisher_minor",
	Category = "Halo Reach"
} )