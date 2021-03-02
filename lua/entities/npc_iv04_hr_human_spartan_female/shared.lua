AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_spartan"

ENT.PrintName = "Spartan"

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.VoiceType = "FemaleSpartan"

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

function ENT:PreInit()
	self.ColR = math.random(255)
	self.ColG = math.random(255)
	self.ColB = math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	net.Start( "HRNBsSpartanSpawned" )
	net.WriteEntity( self )
	net.WriteVector( self:GetPlayerColor() )
	net.Broadcast()
	--self:SetNWVector("SPColor",self:GetPlayerColor())
	 self.Models = {
	"models/halo_reach/players/spartan_female_1.mdl",
	"models/halo_reach/players/spartan_female_2.mdl",
	"models/halo_reach/players/spartan_female_3.mdl",
	"models/halo_reach/players/spartan_female_4.mdl",
	"models/halo_reach/players/spartan_female_5.mdl",
	"models/halo_reach/players/spartan_female_6.mdl",
	"models/halo_reach/players/spartan_female_7.mdl",
	"models/halo_reach/players/spartan_female_8.mdl",
	"models/halo_reach/players/spartan_female_9.mdl",
	"models/halo_reach/players/spartan_female_10.mdl",
	"models/halo_reach/players/spartan_female_11.mdl",
	"models/halo_reach/players/spartan_female_12.mdl",
	"models/halo_reach/players/spartan_female_13.mdl",
	"models/halo_reach/players/spartan_female_14.mdl",
	"models/halo_reach/players/spartan_female_15.mdl",
	"models/halo_reach/players/spartan_female_16.mdl",
	"models/halo_reach/players/spartan_female_17.mdl",
	"models/halo_reach/players/spartan_female_18.mdl",
	"models/halo_reach/players/spartan_female_19.mdl",
	"models/halo_reach/players/spartan_female_20.mdl",
	"models/halo_reach/players/spartan_female_21.mdl",
	"models/halo_reach/players/spartan_female_22.mdl"
	}
	--self:SetNWBool("HasSPColor",true)
end

function ENT:DoInit()
	--print(self:GetModel())
	local wep = table.Random(self.PossibleWeapons)
	self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	for i = 0, #self:GetBodyGroups() do
		self:SetBodygroup(i,math.random(0,self:GetBodygroupCount( i )-1))
	end
end

list.Set( "NPC", "npc_iv04_hr_human_spartan_female", {
	Name = "Spartan (Female)",
	Class = "npc_iv04_hr_human_spartan_female",
	Category = "Halo Reach"
} )