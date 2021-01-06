AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Brute"
ENT.StartHealth = 200
ENT.Models = {"models/halo_reach/characters/covenant/brute_minor.mdl"}

ENT.MeleeDamage = 55

ENT.CovRank = 1

ENT.AllowGrenade = false

ENT.IsBrute = true

ENT.HasArmor = false

ENT.ActionTime = 4.5

ENT.IsElite = false

ENT.StartWeapons = {
	[1] = "astw2_haloreach_spiker",
	[2] = "astw2_haloreach_plasma_repeater"
}

ENT.RifleHolds = {
	["pistol"] = true,
	["revolver"] = true,
	["crossbow"] = true,
	["ar2"] = true,
	["shotgun"] = true,
	["smg"] = true
}

function ENT:DoInit()
	--print(marinevariant)
	self:SetCollisionBounds(Vector(-15,-15,0),Vector(15,15,80))
	if !IsValid(self.Weapon) then
		--self:Give(self.PossibleWeapons[math.random(1,#self.PossibleWeapons)])
	end
	local r = math.random(1,2)
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
end

list.Set( "NPC", "npc_iv04_hr_brute_minor", {
	Name = "Brute Minor",
	Class = "npc_iv04_hr_brute_minor",
	Category = "Halo Reach"
} )