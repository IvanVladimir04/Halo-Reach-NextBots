AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Marine"

ENT.Models = {"models/halo_reach/characters/unsc/crewman_cea.mdl"}

ENT.StartHealth = 60

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.PossibleWeapons = {
	--"astw2_halo_cea_assault_rifle",
	--"astw2_halo_cea_assault_rifle",
	--"astw2_halo_cea_assault_rifle",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_shotgun",
	"astw2_halo_cea_pistol"
	--[["astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"]]
}

ENT.PossibleCEVoices = {
	[1] = "Mendoza",
	[2] = "Bisenti",
	[3] = "Fitzgerald",
	[4] = "Chipps Dubbo"
}

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:Give(wep)
	self:SetColor(Color(math.random(255),math.random(255),math.random(255),255))
	if GetConVar("hce_dropship_targetting") then
		self.VoiceType = self.PossibleCEVoices[math.random(#self.PossibleCEVoices)]
	end
end

list.Set( "NPC", "npc_iv04_hr_human_marine_crewman", {
	Name = "Crewman",
	Class = "npc_iv04_hr_human_marine_crewman",
	Category = "Halo Reach Aftermath"
} )