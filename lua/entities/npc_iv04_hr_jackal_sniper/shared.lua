AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_jackal_ai"
ENT.PrintName = "Jackal"
ENT.StartHealth = 40
ENT.Models = {"models/halo_reach/characters/covenant/jackal_sniper.mdl"}

ENT.CovRank = 1


ENT.IsSniper = true

ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_focus_rifle",
	[2] = "astw2_haloreach_needler_rifle",
	[3] = "astw2_halo2a_carbine",
	[4] = "astw2_halo2a_beamrifle"
}

ENT.HasHelmet = true

ENT.HelmetModel = "models/halo_reach/characters/covenant/jackal_sniper_mask_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_jackal_sniper", {
	Name = "Jackal Sniper",
	Class = "npc_iv04_hr_jackal_sniper",
	Category = "Halo Reach"
} )