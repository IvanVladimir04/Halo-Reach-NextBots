AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Elite"
ENT.StartHealth = 175
ENT.Models = {"models/halo_reach/characters/covenant/elite_ranger.mdl"}

ENT.CovRank = 2

ENT.Shield = 90

ENT.MaxShield = 90

ENT.StartWeapons = {
	[1] = "astw2_haloreach_concussion_rifle",
	[2] = "astw2_haloreach_plasma_repeater",
	[3] = "astw2_haloreach_needler_rifle"
}

function ENT:PreInit()
	if math.random(1,100) == 1 then self.Models = {"models/halo_reach/characters/covenant/elite_ranger_bob.mdl"} end
end

list.Set( "NPC", "npc_iv04_hr_elite_ranger", {
	Name = "Elite Ranger",
	Class = "npc_iv04_hr_elite_ranger",
	Category = "Halo Reach"
} )