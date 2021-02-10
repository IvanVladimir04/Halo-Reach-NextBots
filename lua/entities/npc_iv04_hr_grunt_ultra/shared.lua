AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_grunt_ai"
ENT.PrintName = "Grunt"
ENT.StartHealth = 140
ENT.Models = {"models/halo_reach/characters/covenant/grunt_ultra.mdl"}

ENT.PossibleWeapons = {
	[1] = "astw2_haloreach_plasma_pistol",
	[2] = "astw2_haloreach_needler",
	[3] = "astw2_haloreach_plasma_rifle",
	[4] = "astw2_haloreach_plasma_pistol",
}

ENT.IsUltra = true

ENT.CovRank = 4

ENT.IsLeader = true

ENT.HasHelmet = true

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

ENT.HelmetModel = "models/halo_reach/characters/covenant/grunt_head_helmet_prop.mdl"

ENT.BackpackModel = "models/halo_reach/characters/covenant/grunt_backpack_ultra_prop.mdl"

list.Set( "NPC", "npc_iv04_hr_grunt_ultra", {
	Name = "Grunt Ultra",
	Class = "npc_iv04_hr_grunt_ultra",
	Category = "Halo Reach"
} )