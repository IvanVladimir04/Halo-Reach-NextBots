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

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:Give(wep)
	self:SetSkin(1)
	local hed = math.random(1,4)
	local s = 0
	if hed == 1 then
		s = math.random(6,0)
		if s == 6 then s = 7 end
		hed = math.random(6,1)
		if s == 3 and hed == 2 then hed = hed+math.random(1,2) end
		if s == 3 then self.IsSergeant = true end
	else
		hed = 6
		s = 6
	end
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
end

list.Set( "NPC", "npc_iv04_hr_human_marine_survivor_armored", {
	Name = "Marine (Armored)",
	Class = "npc_iv04_hr_human_marine_survivor_armored",
	Category = "Halo Reach Aftermath"
} )