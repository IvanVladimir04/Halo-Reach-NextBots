AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_skirmisher_ai"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 120
ENT.Models = {"models/halo_reach/characters/covenant/skirmisher_champion.mdl"}

ENT.CovRank = 4
ENT.ShieldUp = false

ENT.PossibleWeapons = {
	"astw2_haloreach_plasma_pistol",
	"astw2_haloreach_needler",
	"astw2_haloreach_needler_rifle"
}

ENT.HasHelmet = true

ENT.HelmetModel = "models/halo_reach/characters/covenant/skirmisher_mask_champion_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_skirmisher_champion", {
	Name = "Skirmisher Champion",
	Class = "npc_iv04_hr_skirmisher_champion",
	Category = "Halo Reach"
} )