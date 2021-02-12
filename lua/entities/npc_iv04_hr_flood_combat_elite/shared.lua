AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_flood_combat_ai"
ENT.PrintName = "Flood Elite Combat Form"
ENT.StartHealth = 120
ENT.Models = {"models/halo_reach/characters/other/flood_elite_combat_form.mdl"}

ENT.PossibleWeapons = {
	"astw2_haloreach_magnum",
	"astw2_haloreach_dmr"
}

ENT.VoiceType = "Flood_Elite"

list.Set( "NPC", "npc_iv04_hr_flood_combat_elite", {
	Name = "Flood Elite Combat Form",
	Class = "npc_iv04_hr_flood_combat_elite",
	Category = "Halo Reach Aftermath"
} )