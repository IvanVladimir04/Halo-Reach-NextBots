AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_drone_ai"
ENT.PrintName = "Drone"
ENT.StartHealth = 60
ENT.Models = {"models/halo_reach/characters/covenant/drone_major.mdl"}

ENT.CovRank = 1
ENT.Shield = 60

ENT.ShieldRegen = 0.6

ENT.MaxShield = 60

ENT.HasArmor = true

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_rifle",
	[2] = "astw2_haloreach_plasma_pistol",
	[3] = "astw2_haloreach_needler",
	[4] = "astw2_halo2a_plasmarifle_brute"
}

ENT.Gibs = {
	[1] = "models/halo_reach/characters/covenant/gibs/drone_abdomen_major.mdl",
	[2] = "models/halo_reach/characters/covenant/gibs/drone_arm_major.mdl",
	[3] = "models/halo_reach/characters/covenant/gibs/drone_leg_major.mdl",
	[4] = "models/halo_reach/characters/covenant/gibs/drone_thorax_major.mdl"
}

list.Set( "NPC", "npc_iv04_hr_drone_major", {
	Name = "Drone Major",
	Class = "npc_iv04_hr_drone_major",
	Category = "Halo Reach"
} )