AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_spartan"

ENT.PrintName = "Jorge"

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
	self.ColR = 206--math.random(255)
	self.ColG = 130--math.random(255)
	self.ColB = 0--math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	net.Start( "HRNBsSpartanSpawned" )
	net.WriteEntity( self )
	net.WriteVector( self:GetPlayerColor() )
	net.Broadcast()
	self.PossibleWeapons = {
		"astw2_haloreach_machinegun_turret_jorge"
	}
	--self:SetNWVector("SPColor",self:GetPlayerColor())
	 self.Models = {
	"models/halo_reach/players/spartan_male_7.mdl"
	}
	self.Unkillable = GetConVar("halo_reach_nextbots_ai_heroes"):GetBool()
	--self:SetNWBool("HasSPColor",true)
end

function ENT:DoInit()
	--print(self:GetModel())
	local wep = table.Random(self.PossibleWeapons)
	--self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	self:SetBodygroup(4,4)
	self:SetBodygroup(7,2)
	self:SetBodygroup(9,4)
	self:SetBodygroup(10,4)
	self:SetBodygroup(11,9)
	self:SetBodygroup(12,3)
	self:SetModelScale(1.1)
	--self.Weapon.BurstLength = 10
end

list.Set( "NPC", "npc_iv04_hr_human_spartan_jorge", {
	Name = "Jorge",
	Class = "npc_iv04_hr_human_spartan_jorge",
	Category = "Halo Reach"
} )