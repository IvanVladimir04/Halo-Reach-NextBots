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
	self.ColR = 109--math.random(255)
	self.ColG = 109--math.random(255)
	self.ColB = 109--math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	net.Start( "HRNBsSpartanSpawned" )
	net.WriteEntity( self )
	net.WriteVector( self:GetPlayerColor() )
	net.Broadcast()
	self.PossibleWeapons = {
		"astw2_haloreach_assault_rifle"
	}
	self.Models = {
		"models/halo_reach/players/spartan_male_1.mdl"
	}
	self.Unkillable = GetConVar("halo_reach_nextbots_ai_heroes"):GetBool()
end

function ENT:DoInit()
	--print(self:GetModel())
	local wep = table.Random(self.PossibleWeapons)
	--self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	--for i = 0, #self:GetBodyGroups() do
	--	self:SetBodygroup(i,math.random(0,self:GetBodygroupCount( i )-1))
	--end
	--self:SetBodygroup(3,1)
end

list.Set( "NPC", "npc_iv04_hr_human_spartan_six", {
	Name = "Noble Six",
	Class = "npc_iv04_hr_human_spartan_six",
	Category = "Halo Reach"
} )