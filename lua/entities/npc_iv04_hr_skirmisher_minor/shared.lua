AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_skirmisher_ai"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 75
ENT.Models = {"models/halo_reach/characters/covenant/skirmisher_minor.mdl"}

ENT.CovRank = 1

list.Set( "NPC", "npc_iv04_hr_skirmisher_minor", {
	Name = "Skirmisher Minor",
	Class = "npc_iv04_hr_skirmisher_minor",
	Category = "Halo Reach"
} )