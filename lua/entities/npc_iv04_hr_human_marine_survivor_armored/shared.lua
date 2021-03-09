AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Marine"

ENT.Models = {"models/halo_reach/characters/unsc/marine_cea_armored.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.PossibleWeapons = {
	"astw2_halo_cea_assault_rifle",
	"astw2_halo_cea_assault_rifle",
	"astw2_halo_cea_assault_rifle",
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
	self:SetSkin(1)
	local hed = math.random(5,0)
	local s = 2
	self:SetBodygroup(2,hed)
	self:SetBodygroup(3,s)
	self:SetBodygroup(5,math.random(-4,1))
	self:SetBodygroup(7,3)
	self:SetBodygroup(8,3)
	self:SetBodygroup(9,6)
	self:SetBodygroup(10,4)
	self:SetBodygroup(11,4)
	self:SetBodygroup(12,4)
	self:SetBodygroup(13,1)
	self:SetBodygroup(14,1)
	if GetConVar("hce_dropship_targetting") then
		self.VoiceType = self.PossibleCEVoices[math.random(#self.PossibleCEVoices)]
	end
end

list.Set( "NPC", "npc_iv04_hr_human_marine_survivor_armored", {
	Name = "Marine (Armored)",
	Class = "npc_iv04_hr_human_marine_survivor_armored",
	Category = "Halo Reach Aftermath"
} )