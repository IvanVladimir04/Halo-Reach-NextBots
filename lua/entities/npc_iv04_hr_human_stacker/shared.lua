AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Sgt. Stacker"

ENT.Models = {"models/halo_reach/characters/unsc/marine_cea_armored.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.VoiceType = "Sergeant1"

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
	local hed = math.random(1,4)
	local s = 0
	self:SetBodygroup(2,6)
	self:SetBodygroup(3,10)
	self:SetBodygroup(4,math.random(-4,1))
	self:SetBodygroup(6,math.random(-4,4))
	self:SetBodygroup(7,math.random(-4,4))
end

list.Set( "NPC", "npc_iv04_hr_human_stacker", {
	Name = "Stacker",
	Class = "npc_iv04_hr_human_stacker",
	Category = "Halo Reach Aftermath"
} )