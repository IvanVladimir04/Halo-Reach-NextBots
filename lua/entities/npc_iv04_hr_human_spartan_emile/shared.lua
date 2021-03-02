AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_spartan"

ENT.PrintName = "Emile"

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
	self.ColR = 182--math.random(255)
	self.ColG = 182--math.random(255)
	self.ColB = 182--math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	net.Start( "HRNBsSpartanSpawned" )
	net.WriteEntity( self )
	net.WriteVector( self:GetPlayerColor() )
	net.Broadcast()
	self.PossibleWeapons = {
		"astw2_haloreach_shotgun"
	}
	--self:SetNWVector("SPColor",self:GetPlayerColor())
	 self.Models = {
	"models/halo_reach/players/spartan_male_14.mdl"
	}
	self.Unkillable = GetConVar("halo_reach_nextbots_ai_heroes"):GetBool()
	--self:SetNWBool("HasSPColor",true)
end

function ENT:DoInit()
	--print(self:GetModel())
	local wep = table.Random(self.PossibleWeapons)
	--self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	self:SetBodygroup(4,7)
	self:SetBodygroup(8,2)
	self:SetBodygroup(9,4)
	self:SetBodygroup(10,4)
	self:SetBodygroup(11,9)
	self:SetBodygroup(12,7)
	--for i = 0, #self:GetBodyGroups() do
	--	self:SetBodygroup(i,math.random(0,self:GetBodygroupCount( i )-1))
	--end
end

list.Set( "NPC", "npc_iv04_hr_human_spartan_emile", {
	Name = "Emile",
	Class = "npc_iv04_hr_human_spartan_emile",
	Category = "Halo Reach"
} )