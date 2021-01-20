AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_drone_ai"
ENT.PrintName = "Drone"
ENT.StartHealth = 60
ENT.Models = {"models/halo_reach/characters/covenant/drone_captain.mdl"}

ENT.CovRank = 1

ENT.StartWeapons = {
	[1] = "astw2_haloreach_needler",
	[2] = "astw2_haloreach_plasma_pistol",
	[3] = "astw2_haloreach_plasma_rifle"
}

ENT.Gibs = {
	[1] = "models/halo_reach/characters/covenant/gibs/drone_abdomen_captain.mdl",
	[2] = "models/halo_reach/characters/covenant/gibs/drone_arm_captain.mdl",
	[3] = "models/halo_reach/characters/covenant/gibs/drone_leg_captain.mdl",
	[4] = "models/halo_reach/characters/covenant/gibs/drone_thorax_captain.mdl"
}

list.Set( "NPC", "npc_iv04_hr_drone_captain", {
	Name = "Drone Captain",
	Class = "npc_iv04_hr_drone_captain",
	Category = "Halo Reach"
} )