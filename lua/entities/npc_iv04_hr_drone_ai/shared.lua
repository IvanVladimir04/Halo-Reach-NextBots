AddCSLuaFile()
include("voices.lua")
ENT.Base 			= "npc_iv04_base"
ENT.MoveSpeed = 30
ENT.MoveSpeedMultiplier = 10
ENT.BehaviourType = 3
ENT.BulletNumber = 1
ENT.IdleSoundDelay = math.random(6,10)
ENT.SightType = 2

ENT.HasArmor = false

--ENT.FriendlyToPlayers = true

--ENT.WalkAnim = {ACT_RUN_PISTOL}
--ENT.WanderAnim = {ACT_RUN_PISTOL}
--ENT.RunAnim = {ACT_RUN_PISTOL}

ENT.DodgeChance = 40
--[[ENT.CrouchingChance = 25
ENT.StepChance = 20]]
ENT.AttractAlliesRange = 1024

ENT.MeleeRange = 100

ENT.MeleeDistance = 180

ENT.ShieldHealth = 100

-- Flinching

ENT.FlinchChance = 30

ENT.FlinchDamage = 1

ENT.FlinchHitgroups = {
	[1] = ACT_FLINCH_HEAD,
	[2] = ACT_FLINCH_CHEST,
	[4] = ACT_FLINCH_LEFTARM,
	[5] = ACT_FLINCH_RIGHTARM,
	[6] = ACT_FLINCH_LEFTLEG,
	[7] = ACT_FLINCH_RIGHTLEG,
	[3] = ACT_FLINCH_STOMACH
}

ENT.FlinchMove = {
	[1] = 50,
	[3] = 50,
	[4] = 50,
	[5] = 50,
	[6] = 0,
	[7] = 0
}

--ENT.Footsteps = { "doom_3/zombie_pistol/step1.ogg", "doom_3/zombie_pistol/step2.ogg", "doom_3/zombie_pistol/step3.ogg", "doom_3/zombie_pistol/step4.ogg" }

local dmgtypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true
}

ENT.MeleeDamage = 75

ENT.NPSound = 0

ENT.NISound = 0

ENT.CanUse = true

ENT.SearchJustAsSpawned = false

ENT.Faction = "FACTION_COVENANT"

ENT.CurMag = 100

local seqs = {
	[1] = "evade_left",
	[2] = "evade_right"
}

ENT.PistolHolds = {
	["pistol"] = true,
	["revolver"] = true
}

ENT.TotalHolds = {
	["pistol"] = true,
	["revolver"] = true,
	["rpg"] = true
}

ENT.FlinchHitgroups = {
	[7] = ACT_FLINCH_RIGHTLEG,
	[3] = ACT_FLINCH_CHEST,
	[4] = ACT_FLINCH_LEFTARM,
	[5] = ACT_FLINCH_RIGHTARM,
	[6] = ACT_FLINCH_LEFTLEG,
	[1] = ACT_FLINCH_HEAD
}

ENT.FlinchAnims = {
	[1] = "Flinch_Head",
	[3] = "Flinch_Front_Chest",
	[4] = "Flinch_Front_Left_Arm",
	[5] = "Flinch_Front_Right_Arm",
	[6] = "Flinch_Front_Left_Leg",
	[7] = "Flinch_Front_Right_Leg"
}

function ENT:FireAnimationEvent(pos,ang,event,name)
	--[[print(pos)
	print(ang)
	print(event)
	print(name)]]
	--[[if name == self.StepEvent then
		local snd = table.Random(self.Footsteps)
		self:EmitSound(snd,100)
	end]]
end

function ENT:Give(class)
	local wep = ents.Create(class)
	local attach = self:GetAttachment(1)
	local pos = attach.Pos
	wep:SetOwner(self)
	wep:SetPos(pos)
	wep:SetAngles(attach.Ang)
	wep:Spawn()
	wep:PhysicsInit(SOLID_NONE)	
	wep:SetSolid(SOLID_NONE)
	wep:SetParent(self,1)
	wep:Fire("setparentattachment", "anim_attachment_RH")
	wep:AddEffects(EF_BONEMERGE)
	self.Weapon = wep
	wep:SetClip1(wep:GetMaxClip1())
end

function ENT:OnInitialize()
	self.FlyGoal = self:WorldSpaceCenter()+self:GetUp()*math.random(160,240)
	self:DoInit()
	self:Give("astw2_haloreach_plasma_pistol")
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

function ENT:DoInit()
	--print(marinevariant)
	--self:SetCollisionBounds(Vector(-30,-30,0),Vector(30,30,80))
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
end

function ENT:SetupHoldtypes()
	local hold = self.Weapon.HoldType_Aim
	if self.PistolHolds[hold] then
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol_1")),self:GetSequenceActivity(self:LookupSequence("Move_Pistol_2")),self:GetSequenceActivity(self:LookupSequence("Move_Pistol_3")),self:GetSequenceActivity(self:LookupSequence("Move_Pistol_4"))}
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_1")),self:GetSequenceActivity(self:LookupSequence("Idle_2")),self:GetSequenceActivity(self:LookupSequence("Idle_3")),self:GetSequenceActivity(self:LookupSequence("Idle_4")),self:GetSequenceActivity(self:LookupSequence("Idle_5")),self:GetSequenceActivity(self:LookupSequence("Idle_6"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle"))}
		self.WarnAnim = "Warn"
		self.SurpriseAnim = "Surprised"
		self.FireAnim = "Attack_Plasma_Pistol"
		self.CalmTurnLeftAnim = "Pistol_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Pistol_Turn_Right_Idle"
		self.TurnLeftAnim = "Pistol_Turn_Left_Idle"
		self.TurnRightAnim = "Pistol_Turn_Right_Idle"
		if self.Weapon:GetClass() == "astw2_haloreach_needler" then
			self.Weapon.BurstLength = self.CovRank+2
		end
	elseif hold == "rpg" then
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Missile_1")),self:GetSequenceActivity(self:LookupSequence("Move_Missile_2"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle"))}
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle"))}
		self.WarnAnim = "Warn_Fuel_Rod"
		self.SurpriseAnim = "Surprised_Fuel_Rod"
		self.FireAnim = "Attack_Fuel_Rod"
		self.CalmTurnLeftAnim = "Missile_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Missile_Turn_Right_Idle"
		self.TurnLeftAnim = "Missile_Turn_Left_Idle"
		self.TurnRightAnim = "Missile_Turn_Right_Idle"
	end
end

function ENT:OnLeaveGround(ent)
	if self:Health() <= 0 then 
		self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne")))
	end
end

function ENT:OnLandOnGround(ent)
	if self.FlyingDead then
		self.HasLanded = true
	elseif self.OldSeq then
		self:ResetSequence(self.OldSeq)
	end
end

function ENT:Speak(voice)
	local character = self.Voices["Drone"]
	if character[voice] and istable(character[voice]) then
		local sound = table.Random(character[voice])
		self:EmitSound(sound,100)
	end
end

function ENT:BeforeThink()
end

function ENT:HandleStanding()
	if self.InFlight then return end
	local change = false
	for i = 1, #self.IdleAnim do
		if self:GetActivity() != self.IdleAnim[i] then
			change = true
		end
	end
	if change then
		self:StartActivity( self.IdleAnim[math.random(1,#self.IdleAnim)] )
	end
end

ENT.CheckT = 0

ENT.CheckDel = 0.3

function ENT:MoveToPos( pos )
	local goal = pos
	local dire = (goal-self:GetPos()):GetNormalized()
	local reached = false
	while (!reached) do
		if GetConVar("ai_disabled"):GetBool() then
			reached = true
		end
		if self.CheckT < CurTime() then
			self.CheckT = CurTime()+self.CheckDel
			dire = (goal-self:GetPos()):GetNormalized()
			if self:NearestPoint(goal):DistToSqr(goal) < self.PathGoalTolerance^2 then
				reached = true
			end
		end
		if IsValid(self.Enemy) then
			self.loco:FaceTowards( self.Enemy:GetPos() )
		end
		self.loco:SetVelocity( dire*(self.MoveSpeed*self.MoveSpeedMultiplier) )
		coroutine.wait(0.01)
	end
end

ENT.ACheck = 0

ENT.ACheckDel = 0.4

if SERVER then

	function ENT:Think()
		
		if self.InFlight and ( self:Health() > 0 ) then -- Stay in the air you fool
		
			if ( self.ACheck < CurTime() and ( self:GetSequence() != self:LookupSequence("Flight_Idle") or self:GetCycle() > 0.9 ) ) and !self.loco:IsOnGround() then
				self.ACheck = CurTime()+self.ACheckDel
				self:ResetSequence("Flight_Idle")
			end
		
			if !self.FlyGoal then 
				self.loco:SetVelocity(Vector(0,0,0))
			--[[else
				local dir = (self.FlyGoal-self:WorldSpaceCenter()):GetNormalized()
				if !self.ReachedGoal then
					self.loco:SetVelocity(dir*(self.MoveSpeed*self.MoveSpeedMultiplier))
				end
				if self.NextFlightT < CurTime() then
					self.NextFlightT = CurTime()+self.FlightThink
					local dist = self:GetRangeSquaredTo(self.FlyGoal)
					if dist < 40^2 then
						self.ReachedGoal = true
					end
				end]]
			end
			
		
		end
	
	end

end

function ENT:Use( activator )
	if !self.CanUse then return end
	if self:CheckRelationships(activator) == "friend" and activator:IsPlayer() then
		self.IsFollowingPlayer = !self.IsFollowingPlayer
		if !IsValid(self.FollowingPlayer) then
			self.FollowingPlayer = activator
		else
			self.FollowingPlayer = nil
		end
		self.CanUse = false
		timer.Simple( 1, function()
			if IsValid(self) then
				self.CanUse = true
			end
		end )
	end
end

local thingstoavoid = {
	["prop_physics"] = true,
	["prop_ragdoll"] = true
}

function ENT:OnContact( ent ) -- When we touch someBODY
	if ent == game.GetWorld() then return "no" end
	if (ent.IsVJBaseSNPC == true or ent.CPTBase_NPC == true or ent.IsSLVBaseNPC == true or ent:GetNWBool( "bZelusSNPC" ) == true) or (ent:IsNPC() && ent:GetClass() != "npc_bullseye" && ent:Health() > 0 ) or (ent:IsPlayer() and ent:Alive()) or ((ent:IsNextBot()) and ent != self ) then
		local d = ent:GetPos()-self:GetPos()
		ent:SetVelocity(d*5)
	end
	if (ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" ) then
		ent:Fire( "Open" )
	end
	if (thingstoavoid[ent:GetClass()]) then
		local p = ent:GetPhysicsObject()
		if IsValid(p) then
			p:Wake()
			local d = ent:GetPos()-self:GetPos()
			p:SetVelocity(d*5)
		end
	end
	local tbl = {
		HitPos = self:NearestPoint(ent:GetPos()),
		HitEntity = self,
		OurOldVelocity = ent:GetVelocity(),
		DeltaTime = 0,
		TheirOldVelocity = self.loco:GetVelocity(),
		HitNormal = self:NearestPoint(ent:GetPos()):GetNormalized(),
		Speed = ent:GetVelocity().x,
		HitObject = self:GetPhysicsObject(),
		PhysObject = self:GetPhysicsObject()
	}
	if isfunction(ent.DoDamageCode) then
		ent:DoDamageCode(tbl,self:GetPhysicsObject())
	elseif isfunction(ent.PhysicsCollide) then 
		ent:PhysicsCollide(tbl,self:GetPhysicsObject())
	end
end

function ENT:OnInjured(dmg)
	local rel = self:CheckRelationships(dmg:GetAttacker())
	local ht = self:Health()
	if rel == "friend" and self.BeenInjured then dmg:ScaleDamage(0) return end
	if (ht) - math.abs(dmg:GetDamage()) < 1 then return end
	if dmg:GetDamage() < 1 then return end
		--ParticleEffect( "blood_impact_grunt", dmg:GetDamagePosition(), Angle(0,0,0), self )
	if dmg:GetAttacker() == self.Enemy then
		self:Speak("OnDamagedFoe")
	end
	if !IsValid(self.Enemy) then
		if self:CheckRelationships(dmg:GetAttacker()) == "foe" then
			self:Speak("OnSurprise")
			self:SetEnemy(dmg:GetAttacker())
		end
	else
		if self.NPSound < CurTime() then
			if dmg:GetDamage() > 10 then
				self:Speak("OnHurt")
			else
				self:Speak("OnHurtLarge")
			end
			self.NPSound = CurTime()+math.random(2,5)
		end
		if self:CheckRelationships(dmg:GetAttacker()) == "friend" then
			timer.Simple( math.random(2,3), function()
				if IsValid(self) then
					--self:Speak("HurtFriend")
				end
			end )
		end
	end
end

function ENT:DoGestureSeq(seq)
	local an = seq
	if isstring(seq) then
		local a,le = self:LookupSequence(seq)
		an = a
	end
	local gest = self:AddGestureSequence(an)
	self:SetLayerPriority(gest,1)
	self:SetLayerPlaybackRate(gest,1)
	self:SetLayerCycle(gest,0)
end

function ENT:OnTraceAttack( info, dir, trace )
	if trace.HitGroup == 1 then
		info:ScaleDamage(3)
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	local hg = trace.HitGroup
	--[[if !self.IsInVehicle and self.FlinchAnims[hg] and !self.DoneFlinch and math.random(100) < self.FlinchChance and info:GetDamage() > self.FlinchDamage then
		self.DoneFlinch = true
		self.DoingFlinch = true
		timer.Simple( math.random(1,2), function()
			if IsValid(self) then
				self.DoneFlinch = false
			end
		end )
		local seq,len = self:LookupSequence(self.FlinchAnims[hg])
		timer.Simple( len, function()
			if IsValid(self) then
				self.DoingFlinch = false
			end
		end )
		local func = function()
			self:PlaySequenceAndMove(seq,1,self:GetForward()*-1,self.FlinchMove[hg],0.4)
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	end]]
end

function ENT:LocalAllies()
	local allies = {}
	for k, v in pairs(ents.FindInSphere(self:GetPos(),400)) do
		if v != self and self:CheckRelationships(v) == "friend" and v:IsNextBot() then
			allies[#allies+1] = v
		end
	end
	return allies
end

function ENT:HandleStanding()

end

function ENT:Wander()
	if self.IsControlled then return end
	if self.InFlight then
		self.InFlight = false
		self.loco:SetGravity(self.OldGravity)
		while (!self.loco:IsOnGround()) do
			coroutine.wait(0.01)
		end
		self:PlaySequenceAndWait("Fly_Land")
	end
		if self.Alerted then
			if self:GetSequence() != self:LookupSequence("Pistol_Idle") then
				self:ResetSequence("Pistol_Idle")
			end
			timer.Simple( 15, function()
				if IsValid(self) and !IsValid(self.Enemy) then
					self.SpokeSearch = false
				end
			end )
			if !self.SpokeSearch then
				self:Speak("OnInvestigate")
				for id, v in ipairs(self:LocalAllies()) do
					if !v.SpokeSearch then
						v.SpokeSearch = true
						v.NeedsToReport = true
					end
				end
			end
			coroutine.wait(1)
		else
			if self:GetSequence() != self:LookupSequence("Pistol_Idle") then
				self:ResetSequence("Pistol_Idle")
			end
			for i = 1, 3 do
				timer.Simple( 0.5*i, function()
					if IsValid(self) and !IsValid(self.Enemy) then
						self:SearchEnemy()
					end
				end )
				if !IsValid(self.Enemy) then
					coroutine.wait(0.5)
				end
			end
			if !self.SpokeIdle then
				self:Speak("OnIdle")
				self.SpokeIdle = true
				timer.Simple( math.random(7,10), function()
					if IsValid(self) then
						self.SpokeIdle = false
					end
				end )
			end
		end
	--self:WanderToPosition( (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.WanderDistance), self.WanderAnim[math.random(1,#self.WanderAnim)], self.MoveSpeed )
end

function ENT:NearbyReply( quote, dist, tim )
	tim = tim or math.random(2,4)
	dist = dist or 500
	for k, v in pairs(ents.FindInSphere(self:GetPos(),dist)) do
		if v != self and v.Speak and self:CheckRelationships(v) == "friend" then
			timer.Simple( tim, function()
				if IsValid(v) then
					v:Speak(quote)
				end
			end )
			break
		end
	end
end

function ENT:OnOtherKilled( victim, info )
	if victim == self then return end
	if self:Health() < 1 then return end
	local rel = self:CheckRelationships(victim)
	if rel == "foe" and victim == self.Enemy then
		if !victim.BeenNoticed then
			victim.BeenNoticed = true
			if victim:IsPlayer() then
				self:NearbyReply("OnKillPlayer")
			end
		end
		local found = false
		for ent, bool in pairs(self.RegisteredTargets) do
			if IsValid(ent)and ent != victim and ent:Health() > 0 then
				self:SetEnemy(ent)
				found = true
				break
			end
		end
		if !found then
			if math.random(1,3) == 1 then
				if math.random(1,2) == 1 then
					self:Speak("OnTaunt")
				else
					self:Speak("OnVictory")
				end
				local func = function()
					--self:PlaySequenceAndWait("Celebrate")
					self:WanderToPosition( self.LastSeenEnemyPos, self.RunAnim[math.random(#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
				end
				table.insert(self.StuffToRunInCoroutine,func)
			end
		end
	elseif rel == "friend" then
		--print(victim.IsElite,victim.IsLeader,victim.IsUltra)
		--print(victim.CovRank,self.CovRank)
			if info:GetAttacker():IsPlayer() then
				--self:Speak("FriendKilledByPlayer")
			else
				if ( info:GetAttacker():IsNPC() and info:GetAttacker().IsVJBaseSNPC and string.StartWith(info:GetAttacker():GetClass(), "npc_vj_flood") ) then	
					--self:Speak("FriendKilledByFlood")
				elseif info:GetAttacker().timeDeath then
					--self:Speak("FriendKilledBySentinel")
				else
					--self:Speak("FriendDied")
				end
			end
	end
end

function ENT:OnLostSeenEnemy(ent)
	if self.Enemy == ent then
		self.LastSeenEnemyPos = ent:GetPos()
	end
end

function ENT:TurnTo(dif,calm)
	calm = calm or false
	local seq
	local e
	if dif < 0 then
		e = 1
		if calm then
			seq = self.CalmTurnLeftAnim
		else
			seq = self.TurnLeftAnim
		end
	else
		e = -1
		if calm then
			seq = self.CalmTurnRightAnim
		else
			seq = self.TurnRightAnim
		end
	end
	local id, len = self:LookupSequence(seq)
	local t
	if math.abs(dif) > 140 then
		t = 1
	else
		t = math.abs(dif)/140
	end
	self:SetSequence(seq)
	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( 1 )
	local z = len*t
	for i = 1, 140*t do
		timer.Simple( (0.001*i)+z, function()
			if IsValid(self) then
				self:SetAngles(self:GetAngles()+Angle(0,e,0))
			end
		end )
	end
	coroutine.wait(z)
	self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
end

function ENT:CustomBehaviour(ent)
	if !IsValid(ent) then return end
	if !ent:IsOnGround() then return self:StartShooting(ent) end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	local dist = self:GetRangeSquaredTo(ent:GetPos())
	if los then
		if IsValid(ent) then
			self.LastSeenEnemyPos = ent:GetPos()
		end
		self:StartShooting(ent)
		self:MoveToPos(Vector(self:GetPos().x+(math.random(512,-512)*math.Rand(0,1)),self:GetPos().y+(math.random(512,-512)*math.Rand(0,1)),self.FlyGoal.z))
		self.FlyGoal = self:GetPos()
	elseif !los then
		if IsValid(obstr) then
			local ros = self:CheckRelationships(obstr)
			if ros == "foe" then
				self:SetEnemy(obstr)
			end
			--self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		end
	end
end

function ENT:StartShooting(ent)
	ent = ent or self.Enemy or self:GetEnemy()
	if !IsValid(ent) then return end
	self:ShootBullet(ent)
end

function ENT:RunToPosition( pos, anim, speed )
	if !util.IsInWorld( pos ) then return "Tried to move out of the world!" end
	self:StartActivity( anim )			-- Move animation
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self.loco:SetAcceleration( speed+speed )
	self:MoveToPos( pos )
end	

function ENT:ShootBullet(ent)
	ent = ent or self.Enemy
	if !IsValid(ent) then return end
	self:FireWep()
	--self:CustomBehaviour(ent)
end

function ENT:FireWep()
	for i = 1, self:GetCurrentWeaponProficiency()+2 do
		timer.Simple( math.random(0.2,0.4)*i, function()
			if IsValid(self) then
				self:DoGestureSeq(self.FireAnim)
				if IsValid(self.Weapon) then
					self.Weapon:AI_PrimaryAttack()
				end
			end
		end )
	end
end

function ENT:Dodge( name, speed )

	self.Dodged = true
	
	timer.Simple( math.random(3,5), function()
		if IsValid(self) then
			self.Dodged = false
		end
	end )

	self.loco:SetDesiredSpeed( self.MoveSpeed*self.MoveSpeedMultiplier )
	local len = self:SetSequence( name )
	self:StartActivity(self:GetSequenceActivity(self:LookupSequence(name)))
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local dir = -1
	
	if name == "evade_right" then dir = 1 end
	
	for i = 1, len*20 do
		timer.Simple( i*0.05, function()
			if IsValid(self) then
				self.loco:Approach(self:GetPos()+self:GetRight()*dir,1)
			end
		end )
	end

	coroutine.wait( len / speed )

end

function ENT:GetShootPos()
	--[[if IsValid(self:GetActiveWeapon()) then
		return self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment("muzzle")).Pos
	end]]
	return self:WorldSpaceCenter()
end

function ENT:CanSee(pos,ent)
	local tbl = {
		start = self:GetShootPos(),
		endpos = pos,
		filter = {self,ent}
	}
	local tr = util.TraceHull( tbl )
	return !tr.Hit
end

function ENT:HandleAnimEvent(event,eventTime,cycle,type,options)
	--[[print(event)
	print(eventTime)
	print(cycle)
	print(type)
	print(options)]]
	--[[if options == self.ShootEvent then
		self:ShootBullet(self.Enemy)
	end]]
end

local se = {
	[1] = "Step Right",
	[2] = "Step Left"
}

function ENT:DoMeleeDamage()
	local damage = self.MeleeDamage
	for	k,v in pairs(ents.FindInCone(self:GetPos()+self:OBBCenter(), self:GetForward(), self.MeleeRange,  math.cos( math.rad( self.MeleeConeAngle ) ))) do
		if v != self and self:CheckRelationships(v) != "friend" then
			v:TakeDamage( damage, self, self )
			--v:EmitSound( self.OnMeleeSoundTbl[math.random(1,#self.OnMeleeSoundTbl)] )
			if v:IsPlayer() then
				v:ViewPunch( self.ViewPunchPlayers )
			end
			if IsValid(v:GetPhysicsObject()) then
				v:GetPhysicsObject():ApplyForceCenter( v:GetPhysicsObject():GetPos() +((v:GetPhysicsObject():GetPos()-self:GetPos()):GetNormalized())*self.MeleeForce )
			end
		end
	end
end

function ENT:StartChasing( ent, anim, speed, los, kam )
	self:StartActivity( anim )
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,los,kam)
end

ENT.NextUpdateT = CurTime()

ENT.UpdateDelay = 0.5

function ENT:ChaseEnt(ent,los,kamikaze)
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( self.PathMinLookAheadDistance )
	path:SetGoalTolerance( self.PathGoalTolerance )
	if !IsValid(ent) then return end
	path:Compute( self, ent:GetPos() )
	if ( !path:IsValid() ) then return "Failed" end
	local saw = false
	while ( path:IsValid() and IsValid(ent) ) do
		if !self.DoingLose then
			self.DoingLose = true
			timer.Simple( 15, function()
				if !IsValid(self) then return end
				self.DoingLose = false
				if !IsValid(ent) then return end
				if !saw and !self:CanSee( ent:GetPos()+ent:OBBCenter(), ent ) then
					self:OnLoseEnemy()
					self:SetEnemy(nil)
					--print(self.State)
					return "LostLOS"
				end
			end)
		end
		if self.NextUpdateT < CurTime() then
			self.NextUpdateT = CurTime()+0.5
			local cansee = self:CanSee( ent:GetPos() + ent:OBBCenter(), ent )
			saw = cansee
			local dist = self:GetPos():DistToSqr(ent:GetPos())
			if kamikaze and dist < self.MeleeDistance^2 then
				return self:Melee()
			elseif !kamikaze and cansee and !los then
				return "GotLOS"
			elseif dist > self.LoseEnemyDistance^2 then
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				return "Lost enemy"
			elseif !kamikaze and dist < 400^2 and cansee and los then
				return "Got range"
			end
			if cansee then
				self.LastSeenEnemyPos = ent:GetPos()
			end
		end
		if path:GetAge() > self.RebuildPathTime then
			if self.OnRebuildPath == true then
				self:OnRebuiltPath()
			end	
			if IsValid(ent) then
				path:Compute( self, ent:GetPos() )
			end
		end
		path:Update( self )
		if self.loco:IsStuck() then
			if self.CustomOnStuck == true then self:CustomStuck() return "CustomOnStuck" end
			self:OnStuck()
			return "Stuck"
		end
		coroutine.yield()
	end
	return "ok"
end

function ENT:OnHaveEnemy(ent)
	if !self.InFlight then
		self.InFlight = true
		self.OldGravity = self.loco:GetGravity()
		self.loco:SetGravity(0)
		self.FlyGoal = self:WorldSpaceCenter()+self:GetUp()*math.random(160,240)
		local func = function()
			self:PlaySequenceAndWait("Flight_Takeoff")
			self:SetSequence("Flight_Idle")
			self.loco:Jump()
			self:MoveToPos(self.FlyGoal)
		end
		table.insert(self.StuffToRunInCoroutine,func)
	end
	local new = true
	if isvector(self.LastSeenEnemyPos) or self.LastTarget then
		new = false
	end
	if new then
		self:Speak("OnAlertMoreFoes")
	else
		if self.LastTarget == ent then
			self:Speak("OnAlert")
		end
	end
	self.LastSeenEnemyPos = ent:GetPos()
	self:AlertAllies(ent)
	self:ResetAI()
end

function ENT:AlertAllies(ent) -- We find allies in sphere and we alert them
	for k, v in pairs(ents.FindInSphere( self:GetPos(), self.AttractAlliesRange ) ) do
		if isfunction(v.SetEnemy) and self:CheckRelationships(v) == "friend" and v != self then
			local doset = false
			if !IsValid(v.Enemy) then
				doset = true
			end
			v:SetEnemy(ent)
			if doset then
				if v.OnHaveEnemy then
					v:OnHaveEnemy(ent)
				end
			else
				v.LastSeenEnemyPos = ent:GetPos()
			end
			--print("Alerted"..v:GetClass().."whose's index is"..v:EntIndex().."and its target is"..ent:GetClass().."")
		end
	end
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.KilledDmgInfo = dmginfo
	self.BehaveThread = nil
	self.DrownThread = coroutine.create( function() self:DoKilledAnim() end )
	coroutine.resume( self.DrownThread )
end

function ENT:DetermineDeathAnim( info )
	local origin = info:GetAttacker():GetPos()
	local damagepos = info:GetDamagePosition()
	local ang = (damagepos-origin):Angle()
	local y = ang.y - self:GetAngles().y
	if y < 0 then y = y + 360 end
	--print(y)
	local anim
	if self.DeathHitGroup then
		if self.DeathHitGroup == 1 then
			anim = "Die_Front_Head_"..math.random(1,2)..""
		else
			if y <= 135 and y > 45 then -- Right
				anim = "Die_Right_Gut"
			elseif y < 225 and y > 135 then -- Front
				anim = "Die_Front_Gut_"..math.random(1,3)..""
			elseif y >= 225 and y < 315 then -- Left
				anim = "Die_Left_Gut"
			elseif y <= 45 or y >= 315 then -- Back
				anim = "Die_Back_Gut"
			end
		end
	else
		return true
	end
	return anim
end

function ENT:DoKilledAnim()
	if self.OldGravity then
		self.loco:SetGravity(self.OldGravity)
	end
	if self.KilledDmgInfo:GetDamageType() != DMG_BLAST then
		--[[if self.KilledDmgInfo:GetDamage() <= 150 then
			self:Speak("OnDeath")
			local anim = self:DetermineDeathAnim(self.KilledDmgInfo)
			if anim == true then 
				local wep = ents.Create(self.Weapon:GetClass())
				wep:SetPos(self.Weapon:GetPos())
				wep:SetAngles(self.Weapon:GetAngles())
				wep:Spawn()
				self.Weapon:Remove()
				self:CreateRagdoll(DamageInfo())
				return
			end
			local seq, len = self:LookupSequence(anim)
			timer.Simple( len, function()
				if IsValid(self) then
					local wep = ents.Create(self.Weapon:GetClass())
					wep:SetPos(self.Weapon:GetPos())
					wep:SetAngles(self.Weapon:GetAngles())
					wep:Spawn()
					self.Weapon:Remove()
					if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
						timer.Simple( 60, function()
							if IsValid(wep) then
								wep:Remove()
							end
						end)
					end
					self:CreateRagdoll(DamageInfo())
				end
			end )
			self:PlaySequenceAndPWait(seq, 1, self:GetPos())
		else]]
			self:Speak("OnDeathPainful")
			local wep = ents.Create(self.Weapon:GetClass())
			wep:SetPos(self.Weapon:GetPos())
			wep:SetAngles(self.Weapon:GetAngles())
			wep:Spawn()
			self.Weapon:Remove()
			if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
				timer.Simple( 60, function()
					if IsValid(wep) then
						wep:Remove()
					end
				end)
			end
			rag = self:CreateRagdoll(DamageInfo())
		--end
	else
		self:Speak("OnDeathThrown")
		self.FlyingDead = true
		local dir = ((self:GetPos()-self.KilledDmgInfo:GetDamagePosition())):GetNormalized()
		dir = dir+self:GetUp()*2
		local force = self.KilledDmgInfo:GetDamage()*1.5
		self:SetAngles(Angle(0,dir:Angle().y,0))
		self.loco:Jump()
		self.loco:SetVelocity(dir*force)
		coroutine.wait(0.5)
		while (!self.HasLanded) do
			coroutine.wait(0.01)
		end
		self:PlaySequenceAndWait("Dead_Land")
		local wep = ents.Create(self.Weapon:GetClass())
		wep:SetPos(self.Weapon:GetPos())
		wep:SetAngles(self.Weapon:GetAngles())
		wep:Spawn()
		self.Weapon:Remove()
		if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
			timer.Simple( 60, function()
				if IsValid(wep) then
					wep:Remove()
				end
			end)
		end
		rag = self:CreateRagdoll(DamageInfo())
	end
end

-- Basic ASTW 2 compatibility

function ENT:IsSprinting()
	return self.Sprinting
end

function ENT:Crouching()
	return self.IsCrouching
end

function ENT:GetAmmoCount()
	return self.CurMag
end

function ENT:SetAmmo(ammo)
	self.CurMag = ammo
end

function ENT:DoAnimationEvent(a)
	-- I don't care
	if a == 1689 then
		local wep = self.Weapon
		if CLIENT then wep = self:GetNWEntity("wep") end
		local time = 2
		timer.Simple( time, function()
			if IsValid(self) and IsValid(wep) then
				self:SetAmmo(wep:GetMaxClip1())
				wep:SetClip1(wep:GetMaxClip1())
			end
		end )
		if !CLIENT then
			--local set = self.AnimSets[self.Weapon:GetClass()] or self.AnimSets["Rifle"]
			local a,len = self:LookupSequence("pistol_reload")
			local func = function()
				self:PlaySequenceAndWait(a)
			end
			table.insert(self.StuffToRunInCoroutine,func)
			self:ResetAI()
		end
	end
end

function ENT:SetViewPunchAngles(no)
	-- No
end

function ENT:GetCurrentWeaponProficiency()
	return self.Difficulty or 1
end

local moves = {
	[ACT_RUN_AGITATED] = true,
	[ACT_WALK_CROUCH_AIM] = true,
	[ACT_RUN] = true,
	[ACT_RUN_PISTOL] = true,
	[ACT_RUN_RIFLE] = true
}

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if moves[act] and self:Health() > 0 then
		self:BodyMoveXY()
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
	end
	self:SetPoseParameter("aim_yaw",-di)
	self:SetPoseParameter("aim_pitch",-dip)
	local goal = self:GetPos()+self.loco:GetVelocity()
	local y = (goal-self:GetPos()):Angle().y
	local di = math.AngleDifference(self:GetAngles().y,y)
	self:SetPoseParameter("move_yaw",di)
	self:FrameAdvance()
end