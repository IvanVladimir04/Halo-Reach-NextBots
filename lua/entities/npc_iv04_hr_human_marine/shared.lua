AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Marine"

ENT.Models = {"models/halo_reach/characters/unsc/marine_shared.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.PossibleWeapons = {
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_shotgun",
	"astw2_haloreach_magnum"
	--[["astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"]]
}

ENT.WepOffsets = {
	["astw2_haloreach_assault_rifle"] = {ang = Angle(-10,0,0), pos = {x=8,y=3,z=-2}},
	["astw2_haloreach_rocket_launcher"] = {ang = Angle(260,160,120), pos = {x=5,y=2,z=-3}},
	["astw2_haloreach_spartan_laser"] = {ang = Angle(260,160,100), pos = {x=3,y=0,z=1}},
	["astw2_haloreach_dmr"] = {ang = Angle(-10,0,0), pos = {x=8,y=3,z=-2}},
	["astw2_haloreach_sniper_rifle"] = {ang = Angle(170,0,-100), pos = {x=4,y=2,z=-0.8}},
	["astw2_haloreach_shotgun"] = {ang = Angle(170,0,-100), pos = {x=4,y=2,z=-0.8}},
	["astw2_haloreach_magnum"] = {ang = Angle(280,210,70), pos = {x=4,y=-0,z=2}}
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

list.Set( "NPC", "npc_iv04_hr_human_marine", {
	Name = "Marine",
	Class = "npc_iv04_hr_human_marine",
	Category = "Halo Reach"
} )