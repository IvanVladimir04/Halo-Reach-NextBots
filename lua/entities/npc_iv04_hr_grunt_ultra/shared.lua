AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_grunt_ai"
ENT.PrintName = "Grunt"
ENT.StartHealth = 140
ENT.Models = {"models/halo_reach/characters/covenant/grunt_ultra.mdl"}

ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_plasma_pistol",
	[2] = "astw2_haloreach_needler",
	[3] = "astw2_haloreach_needler",
	[4] = "astw2_haloreach_plasma_pistol",
}

ENT.IsUltra = true

ENT.CovRank = 4

ENT.IsLeader = true

function ENT:OnInitialize()
	self:DoInit()
	self:Give(self.PossibleWeapons[math.random(#self.PossibleWeapons)])
	self:SetCollisionBounds(Vector(20,20,50),Vector(-20,-20,0))
	if !self.Weapon.NextPrimaryFire then self.Weapon.NextPrimaryFire = CurTime() end
	local relo = self.Weapon.AI_Reload
	self:SetNWEntity("wep",self.Weapon)
	self:SetBodygroup(0,math.random(0,1))
	self.Weapon.AI_Reload = function()
		relo(self.Weapon)
		self:DoAnimationEvent(1689)
	end
	self:SetupHoldtypes()
end

list.Set( "NPC", "npc_iv04_hr_grunt_ultra", {
	Name = "Grunt Ultra",
	Class = "npc_iv04_hr_grunt_ultra",
	Category = "Halo Reach"
} )