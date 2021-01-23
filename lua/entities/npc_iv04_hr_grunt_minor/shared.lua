AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_grunt_ai"
ENT.PrintName = "Grunt"
ENT.StartHealth = 120
ENT.Models = {"models/halo_reach/characters/covenant/grunt_minor.mdl"}

ENT.CovRank = 1

ENT.BackpackModel = "models/halo_reach/characters/covenant/grunt_backpack_default_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_grunt_minor", {
	Name = "Grunt Minor",
	Class = "npc_iv04_hr_grunt_minor",
	Category = "Halo Reach"
} )