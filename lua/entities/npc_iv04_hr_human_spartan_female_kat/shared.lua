AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_spartan"

ENT.PrintName = "Kat"

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.VoiceType = "FemaleSpartan"

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
	self.ColR = 135--math.random(255)
	self.ColG = 225--math.random(255)
	self.ColB = 255--math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	net.Start( "HRNBsSpartanSpawned" )
	net.WriteEntity( self )
	net.WriteVector( self:GetPlayerColor() )
	net.Broadcast()
	self.PossibleWeapons = {
		"astw2_haloreach_magnum"
	}
	--self:SetNWVector("SPColor",self:GetPlayerColor())
	 self.Models = {
	"models/halo_reach/players/spartan_female_8.mdl"
	}
	self.Unkillable = GetConVar("halo_reach_nextbots_ai_heroes"):GetBool()
	--self:SetNWBool("HasSPColor",true)
end

function ENT:DoInit()
	--print(self:GetModel())
	local wep = table.Random(self.PossibleWeapons)
	--self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	--for i = 0, #self:GetBodyGroups() do
	--	self:SetBodygroup(i,math.random(0,self:GetBodygroupCount( i )-1))
	--end
	self:SetBodygroup(3,1)
	self:SetBodygroup(8,1)
	self:SetBodygroup(9,4)
	self:SetBodygroup(10,4)
	self:SetBodygroup(11,1)
	self:SetBodygroup(12,1)
end

list.Set( "NPC", "npc_iv04_hr_human_spartan_female_kat", {
	Name = "Kat",
	Class = "npc_iv04_hr_human_spartan_female_kat",
	Category = "Halo Reach"
} )