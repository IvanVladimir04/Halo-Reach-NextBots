AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Brute"
ENT.StartHealth = 250
ENT.Models = {"models/halo_reach/characters/covenant/brute_minor.mdl"}

ENT.MeleeDamage = 55

ENT.CovRank = 1

ENT.AllowGrenade = false

ENT.IsBrute = true

ENT.HasArmor = false

ENT.ActionTime = 4.5

ENT.IsElite = false

ENT.BloodEffect = "halo_reach_blood_impact_brute"

ENT.DriveThese = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = false,
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = false,
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = false
}

ENT.StartWeapons = {
	[1] = "astw2_haloreach_spiker",
	[2] = "astw2_haloreach_plasma_repeater",
	[3] = "astw2_halo2a_carbine"
}

ENT.RifleHolds = {
	["pistol"] = true,
	["revolver"] = true,
	["crossbow"] = true,
	["ar2"] = true,
	["shotgun"] = true,
	["smg"] = true,
	["physgun"] = true,
	["rpg"] = true
}

function ENT:DoInit()
	--print(marinevariant)
	self:SetCollisionBounds(Vector(-20,-20,0),Vector(20,20,80))
	if !IsValid(self.Weapon) then
		--self:Give(self.PossibleWeapons[math.random(1,#self.PossibleWeapons)])
	end
	local r = math.random(1,2)
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
end

ENT.RandDeath = {
	[1] = 2,
	[2] = 3,
	[3] = 5
}

ENT.AirDeathAnim = "Dead_Airborne"

ENT.DeathHitGroups = {
	[1] = "Head",
	[7] = "Guts"
}

ENT.HasHelmet = true

ENT.HelmetModel = "models/halo_reach/characters/covenant/brute_helmet_minor_prop.mdl"

ENT.HelmetBodygroup = 4

ENT.HeadHitGroup = 1

ENT.CanTrade = false

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
	if dm == DMG_BLAST then
		anim = "Dead Airborne"
	end
	return anim
end

list.Set( "NPC", "npc_iv04_hr_brute_minor", {
	Name = "Brute Minor",
	Class = "npc_iv04_hr_brute_minor",
	Category = "Halo Reach"
} )