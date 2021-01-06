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

ENT.DeathHitGroups = {
	[7] = "Head",
	[1] = "Guts"
}

ENT.RandDeath = {
	[1] = 2,
	[2] = 3,
	[3] = 5
}

function ENT:DetermineDeathAnim( info )
	local origin = info:GetAttacker():GetPos()
	local damagepos = info:GetDamagePosition()
	local ang = (damagepos-origin):Angle()
	local y = ang.y - self:GetAngles().y
	if y < 1 then y = y + 360 end
	--print(y)
	local anim
	if self.DeathHitGroup and self.DeathHitGroups[self.DeathHitGroup] then
		local typ = self.DeathHitGroups[self.DeathHitGroup]
		if typ == "Head" then
			anim = "Death_Front_Gut_1"
		else
			if ( y <= 90 or y >= 270 ) then
				anim = "Death_Back_Gut_"..math.random(1,2)..""
			elseif ( y < 270 and y > 90 ) then -- front
				anim = "Death_Front_Gut_2"
			end
		end
	else
		anim = "Death_Front_Gut_"..math.random(1,2)..""
	end
	local dm = info:GetDamageType()
	if dm == DMG_BLAST or ( info:GetDamage() > 45 and dmgtypes[dm] ) then
		anim = "Dead_Airborne"
	end
	return anim
end

list.Set( "NPC", "npc_iv04_hr_brute_minor", {
	Name = "Brute Minor",
	Class = "npc_iv04_hr_brute_minor",
	Category = "Halo Reach"
} )