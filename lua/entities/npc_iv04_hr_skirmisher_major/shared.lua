AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_skirmisher_ai"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 80
ENT.Models = {"models/halo_reach/characters/covenant/skirmisher_major.mdl"}

ENT.CovRank = 2
ENT.ShieldUp = false

ENT.PossibleWeapons = {
	"astw2_haloreach_plasma_pistol",
	"astw2_haloreach_needler",
	"astw2_haloreach_needler_rifle"
}

list.Set( "NPC", "npc_iv04_hr_skirmisher_major", {
	Name = "Skirmisher Major",
	Class = "npc_iv04_hr_skirmisher_major",
	Category = "Halo Reach"
} )