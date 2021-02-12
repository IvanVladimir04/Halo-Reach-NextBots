AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Army Trooper"

ENT.Models = {"models/halo_reach/characters/unsc/marine_shared.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.PossibleWeapons = {
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_dmr",
	"astw2_haloreach_dmr",
	"astw2_haloreach_shotgun",
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

ENT.Skins = {
	[1] = 0,
	[2] = 0,
	[3] = 3,
	[4] = 3,
	[5] = 3,
	[6] = 4,
	[7] = 1
}

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	local head = math.random(0,5)
	self:SetBodygroup(2,head)
	local helm
	helm = helm or math.random(0,5)
	if head == 2 and helm == 3 then helm = 1 end
	self:SetBodygroup(3,helm)
	self:SetBodygroup(4,math.random(-4,3))
	self:SetBodygroup(5,math.random(0,1))
	local attch
	if helm == 3 then self.IsSergeant = true attch = 0 end
	attch = attch or math.random(-2,2)
	self:SetBodygroup(6,attch)
	self:SetBodygroup(7,math.random(0,2))
	self:SetBodygroup(8,math.random(0,2))
	local ra9 = math.random(0,2)
	if ra9 == 2 then ra9 = 3 end
	self:SetBodygroup(10,ra9)
	self:SetBodygroup(11,math.random(0,3))
	self:SetBodygroup(12,math.random(0,3))
	self:SetBodygroup(13,math.random(0,1))
	self:SetBodygroup(14,math.random(0,1))
end

list.Set( "NPC", "npc_iv04_hr_human_trooper", {
	Name = "Army Trooper",
	Class = "npc_iv04_hr_human_trooper",
	Category = "Halo Reach"
} )