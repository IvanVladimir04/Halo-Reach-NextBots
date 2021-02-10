AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_grunt_ai"
ENT.PrintName = "Grunt"
ENT.StartHealth = 130
ENT.Models = {"models/halo_reach/characters/covenant/grunt_heavy.mdl"}

ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_fuel_rod"
}

ENT.CovRank = 2

ENT.IsLeader = true

function ENT:OnInitialize()
	self:DoInit()
	self:Give(self.PossibleWeapons[math.random(#self.PossibleWeapons)])
	self:SetCollisionBounds(Vector(20,20,50),Vector(-20,-20,0))
	self.VoiceType = "Grunt"
	if !self.Weapon.NextPrimaryFire then self.Weapon.NextPrimaryFire = CurTime() end
	local relo = self.Weapon.AI_Reload
	self:SetNWEntity("wep",self.Weapon)
	self.Weapon.AI_Reload = function()
		relo(self.Weapon)
		self:DoAnimationEvent(1689)
	end
	self:SetupHoldtypes()
end

ENT.BackpackModel = "models/halo_reach/characters/covenant/grunt_backpack_heavy_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_grunt_heavy", {
	Name = "Grunt Heavy",
	Class = "npc_iv04_hr_grunt_heavy",
	Category = "Halo Reach"
} )