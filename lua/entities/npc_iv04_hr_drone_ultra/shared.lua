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

list.Set( "NPC", "npc_iv04_hr_drone_ultra", {
	Name = "Drone Ultra",
	Class = "npc_iv04_hr_drone_ultra",
	Category = "Halo Reach"
} )