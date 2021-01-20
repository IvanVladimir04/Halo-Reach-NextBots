AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_drone_ai"
ENT.PrintName = "Drone"
ENT.StartHealth = 60
ENT.Models = {"models/halo_reach/characters/covenant/drone_ultra.mdl"}

ENT.CovRank = 1

ENT.StartWeapons = {
	[1] = "astw2_haloreach_needler",
	[2] = "astw2_haloreach_plasma_pistol"
}

ENT.Gibs = {
	[1] = "models/halo_reach/characters/covenant/gibs/drone_abdomen_ultra.mdl",
	[2] = "models/halo_reach/characters/covenant/gibs/drone_arm_ultra.mdl",
	[3] = "models/halo_reach/characters/covenant/gibs/drone_leg_ultra.mdl",
	[4] = "models/halo_reach/characters/covenant/gibs/drone_thorax_ultra.mdl"
}

list.Set( "NPC", "npc_iv04_hr_drone_ultra", {
	Name = "Drone Ultra",
	Class = "npc_iv04_hr_drone_ultra",
	Category = "Halo Reach"
} )