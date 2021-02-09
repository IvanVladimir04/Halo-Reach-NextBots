AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_elite_ai"
ENT.PrintName = "Brute"
ENT.StartHealth = 350
ENT.Models = {"models/halo_reach/characters/covenant/brute_chieftain.mdl"}

ENT.MeleeDamage = 55

ENT.CovRank = 1

ENT.AllowGrenade = false

ENT.IsBrute = true

ENT.HasArmor = true

ENT.ActionTime = 3.5

ENT.IsElite = false

ENT.BloodEffect = "halo_reach_blood_impact_brute"

ENT.DriveThese = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = false,
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = false,
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = false
}

ENT.StartWeapons = {
	[1] = "astw2_haloreach_fuel_rod",
	[2] = "astw2_haloreach_plasma_launcher",
	[3] = "astw2_haloreach_gravityhammer",
	[4] = "astw2_halo2a_plasmacannon"
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

ENT.CanTrade = false

ENT.LeapChance = 50

ENT.Shield = 100

ENT.MaxShield = 100

function ENT:OnInitialize()
	self.AIType = GetConVar("halo_reach_nextbots_ai_type"):GetString() or self.AIType
	local wep = self.StartWeapons[math.random(#self.StartWeapons)]
	if wep != "astw2_haloreach_gravityhammer" then
		self:SetModel("models/halo_reach/characters/covenant/brute_chieftain_alt.mdl")
	end
	self:Give(wep)
	self.Difficulty = GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()
	self.Weapon.Primary.Damage = ((self.Weapon.Primary.Damage*self.Difficulty)*0.5)
	self:SetupHoldtypes()
	self:DoInit()
	self.VoiceType = "Brute"
end

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

ENT.HelmetBodygroup = 5

ENT.HelmetModel = "models/halo_reach/characters/covenant/brute_helmet_chieftain_prop.mdl"


ENT.HeadHitGroup = 1

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
		anim = "Dead_Airborne"
	end
	return anim
end

list.Set( "NPC", "npc_iv04_hr_brute_chieftain", {
	Name = "Brute Chieftain",
	Class = "npc_iv04_hr_brute_chieftain",
	Category = "Halo Reach"
} )

function ENT:FootstepSound()
	local character = self.Voices[self.VoiceType]
	if character["OnStep"] and istable(character["OnStep"]) then
		local sound = table.Random(character["OnStep"])
		self:EmitSound(sound,75)
	end
end

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if !self.loco:GetVelocity():IsZero() and self.loco:IsOnGround() then
		if !self.LMove then
			self.LMove = CurTime()+0.35
		else
			if self.LMove < CurTime() then
				self:FootstepSound()
				self.LMove = CurTime()+0.35
			end
		end
		local goal = self:GetPos()+self.loco:GetVelocity()
		local y = (goal-self:GetPos()):Angle().y
		local di = math.AngleDifference(self:GetAngles().y,y)
		self:SetPoseParameter("move_yaw",di)
		self:SetPoseParameter("walk_yaw",di)
	else
		self.LMove = nil
	end
	local look = false
	local goal
	local y
	local di = 0
	local p
	local dip = 0
	if IsValid(self.Enemy) then
		goal = self.Enemy:WorldSpaceCenter()
		local an = (goal-self:WorldSpaceCenter()):Angle()
		y = an.y
		di = math.AngleDifference(self:GetAngles().y,y)
		p = an.p
		dip = math.AngleDifference(self:GetAngles().p,p)
		if self.IsInVehicle then
			if !self.Transitioned and self.VehicleRole == "Gunner" then
				local vy = math.AngleDifference(self.Vehicle:GetAngles().y+self.LTPP,y)
				local vp = math.AngleDifference(self.Vehicle:GetAngles().p+self.LTP,p)
				self.Transitioned = true
				timer.Simple(0.01, function()
					if IsValid(self) then
						self.Transitioned = false
					end
				end )
				if math.abs(vy) > 5 then
					self.LTPP = self.Vehicle:GetPoseParameter("turret_yaw")
					local i
					if vy < 0 then
						i = 2
					else
						i = -2
					end
					self:SetAngles(Angle(self.Vehicle:GetAngles().p,self:GetAngles().y+i,self.Vehicle:GetAngles().r))
					self.Vehicle:SetPoseParameter("turret_yaw",self.LTPP+i)
					self.GunnerShoot = false
				else
					self.GunnerShoot = true
				end
				if math.abs(vp) > 2 then
					self.LTP = self.Vehicle:GetPoseParameter("spin_cannon")
					local i
					if (vp/2) <= self.LTP then
						i = -1
					else
						i = 1
					end
					self.Vehicle:SetPoseParameter("spin_cannon",self.LTP+i)
				end
			end
		end
	end
	self:SetPoseParameter("aim_yaw",-di)
	self:SetPoseParameter("aim_pitch",-dip)
	if !self.DoingFlinch and self:Health() > 0 and !self.DoingMelee and !self.Berserking and !self.Leaped and !self.DoingMelee and !self.Taunting then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
end