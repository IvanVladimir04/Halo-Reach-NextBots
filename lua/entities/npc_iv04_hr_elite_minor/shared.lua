AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 50
ENT.Models = {"models/halo_reach/characters/covenant/elite_minor.mdl"}

ENT.CovRank = 1

list.Set( "NPC", "npc_iv04_hr_elite_minor", {
	Name = "Elite Minor",
	Class = "npc_iv04_hr_elite_minor",
	Category = "Halo Reach"
} )