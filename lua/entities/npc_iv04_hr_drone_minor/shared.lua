AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_drone_ai"
ENT.PrintName = "Drone"
ENT.StartHealth = 60
ENT.Models = {"models/halo_reach/characters/covenant/drone.mdl"}

ENT.CovRank = 1

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_pistol"
}

ENT.Gibs = {
	[1] = "models/halo_reach/characters/covenant/gibs/drone_abdomen.mdl",
	[2] = "models/halo_reach/characters/covenant/gibs/drone_arm.mdl",
	[3] = "models/halo_reach/characters/covenant/gibs/drone_leg.mdl",
	[4] = "models/halo_reach/characters/covenant/gibs/drone_thorax.mdl"
}

list.Set( "NPC", "npc_iv04_hr_drone_minor", {
	Name = "Drone Minor",
	Class = "npc_iv04_hr_drone_minor",
	Category = "Halo Reach"
} )