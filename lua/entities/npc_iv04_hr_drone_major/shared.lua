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
	[3] = "astw2_haloreach_needler"
}

list.Set( "NPC", "npc_iv04_hr_drone_major", {
	Name = "Drone Major",
	Class = "npc_iv04_hr_drone_major",
	Category = "Halo Reach"
} )