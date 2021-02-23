AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Sgt. Johnson"

ENT.Models = {"models/halo_reach/characters/unsc/marine_cea_armored.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.IsSergeant = true

ENT.PossibleWeapons = {
	"astw2_halo_cea_assault_rifle",
	"astw2_halo_cea_assault_rifle",
	"astw2_halo_cea_assault_rifle",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_shotgun",
	"astw2_halo_cea_pistol",
	"astw2_halo_cea_pistol",
	"astw2_halo_cea_sniper_rifle"
	--[["astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"]]
}

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:Give(wep)
	local hed = math.random(1,4)
	local s = 0
	self:SetBodygroup(2,7)
	self:SetBodygroup(3,10)
	self:SetBodygroup(4,math.random(-4,1))
	self:SetBodygroup(6,math.random(-4,4))
	self:SetBodygroup(7,math.random(-4,4))
	self.Unkillable = GetConVar("halo_reach_nextbots_ai_heroes"):GetBool()
	if GetConVar("hce_dropship_targetting") then
		self.VoiceType = "Johnson"
	end
end

list.Set( "NPC", "npc_iv04_hr_human_johnson", {
	Name = "Johnson",
	Class = "npc_iv04_hr_human_johnson",
	Category = "Halo Reach Aftermath"
} )