AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_grunt_ai"
ENT.PrintName = "Grunt"
ENT.StartHealth = 130
ENT.Models = {"models/halo_reach/characters/covenant/grunt_major.mdl"}

ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_plasma_pistol",
	[2] = "astw2_haloreach_needler",
	[3] = "astw2_haloreach_plasma_pistol"
}

ENT.IsMajor = true

ENT.IsLeader = true

ENT.CovRank = 2

function ENT:OnInitialize()
	self:DoInit()
	self:Give(self.PossibleWeapons[math.random(#self.PossibleWeapons)])
	self:SetCollisionBounds(Vector(20,20,50),Vector(-20,-20,0))
	if !self.Weapon.NextPrimaryFire then self.Weapon.NextPrimaryFire = CurTime() end
	local relo = self.Weapon.AI_Reload
	self:SetNWEntity("wep",self.Weapon)
	self.Weapon.AI_Reload = function()
		relo(self.Weapon)
		self:DoAnimationEvent(1689)
	end
	self:SetupHoldtypes()
end

ENT.BackpackModel = "models/halo_reach/characters/covenant/grunt_backpack_major_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_grunt_major", {
	Name = "Grunt Major",
	Class = "npc_iv04_hr_grunt_major",
	Category = "Halo Reach"
} )