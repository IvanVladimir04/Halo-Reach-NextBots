AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_spartan"

ENT.PrintName = "Noble Six"

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

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
	self.ColR = 132--math.random(255)
	self.ColG = 145--math.random(255)
	self.ColB = 102--math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	net.Start( "HRNBsSpartanSpawned" )
	net.WriteEntity( self )
	net.WriteVector( self:GetPlayerColor() )
	net.Broadcast()
	self.PossibleWeapons = {
		"astw2_haloreach_sniper_rifle"
	}
	--self:SetNWVector("SPColor",self:GetPlayerColor())
	 self.Models = {
	"models/halo_reach/players/spartan_male_13.mdl"
	}
	self.Unkillable = GetConVar("halo_reach_nextbots_ai_heroes"):GetBool()
	--self:SetNWBool("HasSPColor",true)
end

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:Give(wep)
	self:SetBodygroup(4,5)
	self:SetBodygroup(6,1)
	self:SetBodygroup(7,5)
	self:SetBodygroup(8,2)
	self:SetBodygroup(9,4)
	self:SetBodygroup(10,4)
	self:SetBodygroup(11,8)
	self:SetBodygroup(12,10)
end

list.Set( "NPC", "npc_iv04_hr_human_spartan_jun", {
	Name = "Jun",
	Class = "npc_iv04_hr_human_spartan_jun",
	Category = "Halo Reach"
} )