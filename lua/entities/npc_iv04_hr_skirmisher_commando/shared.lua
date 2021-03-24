AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_skirmisher_ai"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 100
ENT.Models = {"models/halo_reach/characters/covenant/skirmisher_commando.mdl"}

ENT.CovRank = 3
ENT.ShieldUp = false

ENT.PossibleWeapons = {
	"astw2_haloreach_plasma_pistol",
	"astw2_haloreach_needler",
	"astw2_haloreach_needler_rifle"
}

ENT.HasHelmet = true

ENT.HelmetModel = "models/halo_reach/characters/covenant/skirmisher_mask_commando_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_skirmisher_commando", {
	Name = "Skirmisher Commando",
	Class = "npc_iv04_hr_skirmisher_commando",
	Category = "Halo Reach"
} )