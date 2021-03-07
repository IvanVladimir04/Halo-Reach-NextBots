AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_flood_combat_ai"
ENT.PrintName = "Flood Human Combat Form"
ENT.StartHealth = 90
ENT.Models = {"models/halo_reach/characters/other/flood_human_combat_form.mdl"}

ENT.MoveSpeed = 30

ENT.MoveSpeedMultiplier = 5

ENT.PossibleWeapons = {
	"astw2_halo_cea_assault_rifle",
	"astw2_halo_cea_pistol"
}

ENT.VoiceType = "Flood_Human"

ENT.MeleeDamage = 35

list.Set( "NPC", "npc_iv04_hr_flood_combat_human", {
	Name = "Flood Human Combat Form",
	Class = "npc_iv04_hr_flood_combat_human",
	Category = "Halo Reach Aftermath"
} )