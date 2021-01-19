AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_drone_ai"
ENT.PrintName = "Drone"
ENT.StartHealth = 60
ENT.Models = {"models/halo_reach/characters/covenant/drone.mdl"}

ENT.CovRank = 1

list.Set( "NPC", "npc_iv04_hr_drone_minor", {
	Name = "Drone Minor",
	Class = "npc_iv04_hr_drone_minor",
	Category = "Halo Reach"
} )