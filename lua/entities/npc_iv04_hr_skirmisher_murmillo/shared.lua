AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_skirmisher_ai"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 100
ENT.Models = {"models/halo_reach/characters/covenant/skirmisher_murmillo.mdl"}

ENT.CovRank = 4

ENT.PossibleWeapons = {
	"astw2_haloreach_plasma_pistol",
	"astw2_haloreach_needler",
	"astw2_haloreach_needler_rifle"
}

ENT.HasHelmet = true

ENT.HelmetModel = "models/halo_reach/characters/covenant/skirmisher_mask_murmillo_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_skirmisher_murmillo", {
	Name = "Skirmisher Murmillo",
	Class = "npc_iv04_hr_skirmisher_murmillo",
	Category = "Halo Reach"
} )