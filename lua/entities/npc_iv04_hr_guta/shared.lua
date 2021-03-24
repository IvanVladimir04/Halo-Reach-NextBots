AddCSLuaFile()

include("voices.lua")

ENT.Base 			= "npc_iv04_base"
ENT.PrintName = "Gúta"
ENT.StartHealth = 600
ENT.MoveSpeed = 50
ENT.MoveSpeedMultiplier = 7
ENT.BehaviourType = 3
ENT.BulletNumber = 1
ENT.IdleSoundDelay = math.random(6,10)
ENT.Models = {"models/halo_reach/characters/wildlife/guta.mdl"}
ENT.SightType = 2
ENT.OnMeleeImpactSoundTbl = { "halo_reach/characters/hunter/hunter_hit_damage/hunter_hit_damage1.ogg", "halo_reach/characters/hunter/hunter_hit_damage/hunter_hit_damage2.ogg", "halo_reach/characters/hunter/hunter_hit_damage/hunter_hit_damage3.ogg", "halo_reach/characters/hunter/hunter_hit_damage/hunter_hit_damage4.ogg",
								"halo_reach/characters/hunter/hunter_hit_damage/hunter_hit_damage5.ogg", "halo_reach/characters/hunter/hunter_hit_damage/hunter_hit_damage6.ogg", "halo_reach/characters/hunter/hunter_melee_hits/hunter_melee_hit1.ogg", "halo_reach/characters/hunter/hunter_melee_hits/hunter_melee_hit2.ogg",
								"halo_reach/characters/hunter/hunter_melee_hits/hunter_melee_hit3.ogg", "halo_reach/characters/hunter/hunter_melee_hits/hunter_melee_hit4.ogg", "halo_reach/characters/hunter/hunter_melee_hits/hunter_melee_hit5.ogg", "halo_reach/characters/hunter/hunter_melee_hits/hunter_melee_hit6.ogg" }
ENT.OnMeleeSoundTbl = { "halo_reach/characters/hunter/melee_var1/melee_var1_1.ogg", "halo_reach/characters/hunter/melee_var1/melee_var1_2.ogg", "halo_reach/characters/hunter/melee_var1/melee_var1_3.ogg", "halo_reach/characters/hunter/melee_var2/melee_var2_1.ogg"  }
ENT.OnMeleeBackSoundTbl = { "halo_reach/characters/hunter/melee_back/melee_back_1.ogg", "halo_reach/characters/hunter/melee_back/melee_back_2.ogg", "halo_reach/characters/hunter/melee_back/melee_back_3.ogg" }
ENT.OnMeleeLeftSoundTbl = { "halo_reach/characters/hunter/smash_left/smash_left_1.ogg", "halo_reach/characters/hunter/smash_left/smash_right_2.ogg", "halo_reach/characters/hunter/smash_left/smash_right_3.ogg" }
ENT.OnMeleeRightSoundTbl = { "halo_reach/characters/hunter/smash_right/smash_right_1.ogg", "halo_reach/characters/hunter/smash_right/smash_right_2.ogg", "halo_reach/characters/hunter/smash_right/smash_right_3.ogg" }

ENT.HasArmor = false

--ENT.FriendlyToPlayers = true

ENT.DodgeChance = 20
--[[ENT.CrouchingChance = 25
ENT.StepChance = 20]]
ENT.AttractAlliesRange = 600

ENT.MeleeRange = 200

ENT.MeleeConeAngle = 80

ENT.MeleeDistance = 180

ENT.ChaseRange = 400

-- Flinching

ENT.FlinchChance = 30

ENT.FlinchDamage = 10

ENT.FlinchHitgroups = {
	[1] = ACT_FLINCH_HEAD,
	[20] = ACT_FLINCH_CHEST,
	[3] = ACT_FLINCH_LEFTARM,
	[4] = ACT_FLINCH_RIGHTARM,
	[5] = ACT_FLINCH_LEFTLEG,
	[6] = ACT_FLINCH_RIGHTLEG,
	[1] = ACT_FLINCH_STOMACH
}

--ENT.Footsteps = { "doom_3/zombie_pistol/step1.ogg", "doom_3/zombie_pistol/step2.ogg", "doom_3/zombie_pistol/step3.ogg", "doom_3/zombie_pistol/step4.ogg" }

ENT.MeleeDamage = 120

ENT.NPSound = 0

ENT.NISound = 0

ENT.CanUse = true

ENT.SearchJustAsSpawned = false

ENT.Faction = "FACTION_WILDLIFE"

ENT.MeleeEvent = "event_halo_reach_guta_melee"

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

function ENT:OnInitialize()
	self.Difficulty = GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()
	self.MeleeDamage = (self.MeleeDamage*(self.Difficulty)*0.5)
	self:DoInit()
	self.VoiceType = "Gúta"
	self:SetCollisionBounds(Vector(-100,-100,20),Vector(100,100,200))
end

function ENT:DoInit()
	--print(marinevariant)
	--self:SetCollisionBounds(Vector(-30,-30,0),Vector(30,30,80))
	self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Run"))}
	
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
	self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Walk"))}
end

function ENT:OnLeaveGround(ent)
	if self:Health() <= 0 then 
		self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne")))
	else
		self.LastTimeOnGround = CurTime()
	end
end

function ENT:OnLandOnGround(ent)
	if self.FlyingDead then
		self.HasLanded = true
	elseif self.LastTimeOnGround then
		local t = CurTime()-self.LastTimeOnGround
		local seq
		if t < 3 then
			seq = "Land_Soft"
		else
			seq = "Land_Hard"
		end
		local func = function()
			self:PlaySequenceAndWait(seq)
			self:StartActivity(self.IdleAnim[1])
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	end
end

function ENT:Speak(voice)
	local character = self.Voices["Gúta"]
	--if self.CurrentSound then self.CurrentSound:Stop() end
	if character[voice] and istable(character[voice]) then
		local sound = table.Random(character[voice])
		self:EmitSound(sound,100)
	end
end

function ENT:BeforeThink()
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
	if ent == game.GetWorld() then if self.FlyingDead then self.AlternateLanded = true end return "no" end
	if (ent.IsVJBaseSNPC == true or ent.CPTBase_NPC == true or ent.IsSLVBaseNPC == true or ent:GetNWBool( "bZelusSNPC" ) == true) or (ent:IsNPC() && ent:GetClass() != "npc_bullseye" && ent:Health() > 0 ) or (ent:IsPlayer() and ent:Alive()) or ((ent:IsNextBot()) and ent != self ) then
		local d = (ent:WorldSpaceCenter()-self:GetPos())
		ent:SetVelocity(d*1)
	end
	if (ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" ) then
		ent:Fire( "Open" )
	end
	if (thingstoavoid[ent:GetClass()]) then
		local p = ent:GetPhysicsObject()
		if IsValid(p) then
			p:Wake()
			local d = ent:GetPos()-self:GetPos()
			p:SetVelocity(d*1)
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

ENT.Gibs = {
	[1] = "models/halo_reach/characters/covenant/hunter_armor_prop.mdl",
	[2] = "models/halo_reach/characters/covenant/hunter_armor_spike_large_prop.mdl",
	[3] = "models/halo_reach/characters/covenant/hunter_armor_spike_small_prop.mdl"
}

function ENT:OnInjured(dmg)
	local rel = self:CheckRelationships(dmg:GetAttacker())
	local ht = self:Health()
	if rel == "friend" and self.BeenInjured then dmg:ScaleDamage(0) return end
	if (ht) - math.abs(dmg:GetDamage()) < 1 then return end
	if dmg:GetDamage() > 0 then
		ParticleEffect( "halo_reach_blood_impact_human", dmg:GetDamagePosition(), Angle(0,0,0), self )
	end
	if !IsValid(self.Enemy) then
		if self:CheckRelationships(dmg:GetAttacker()) == "foe" then
			--self:Speak("Surprise")
			self:SetEnemy(dmg:GetAttacker())
		end
	else
		if self.NPSound < CurTime() then
			if dmg:GetDamage() > 10 then
				self:Speak("OnHurtLarge")
			else
				self:Speak("OnHurt")
			end
			self.NPSound = CurTime()+math.random(2,5)
		end
	end
end

ENT.Variations = {
	[ACT_FLINCH_CHEST] = {["Back"] = "Flinch_Back_Chest", ["Front"] = "Flinch_Front_Chest"},
	[ACT_FLINCH_STOMACH] = {["Back"] = "Flinch_Back_Gut", ["Front"] = "Flinch_Front_Gut"}
}

local normalgroups = {
	[3] = true,
	[4] = true
}

function ENT:OnTraceAttack( info, dir, trace )
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	--print(trace.HitGroup)
	if !self.DoingFlinch and info:GetDamage() > 15 and math.random(1,2) == 1 then
		if normalgroups[trace.HitGroup] then
			local act
			--act = self.FlinchHitgroups[trace.HitBox]
			local ang = dir:Angle().y-self:GetAngles().y
			if ang < 1 then ang = ang + 360 end
			if trace.HitGroup == 4 then
				act = "Flinch_Front_Left_Arm"
			else
				if ( ang < 90 or ang > 270 ) then
					act = "Flinch_Back_Chest"
				else
					act = "Flinch_Front_Chest"
				end
			end
			if act then
				self.DoingFlinch = true
				local id, dur = self:LookupSequence(act)
				timer.Simple(dur, function()
					if IsValid(self) then
						self.DoingFlinch = false
					end
				end )
				local func = function()
					self:PlaySequenceAndWait(id)
					--self:StartActivity(self.IdleAnim[1])
				end
				table.insert(self.StuffToRunInCoroutine,func)
				self:ResetAI()
			end
		end
	end
end

function ENT:LocalAllies()
	local allies = {}
	for k, v in pairs(ents.FindInSphere(self:GetPos(),200)) do
		if v:IsNextBot() and self:CheckRelationships(v) == "friend" then
			allies[#allies+1] = v
		end
	end
	return allies
end

function ENT:Wander()
	if self.IsControlled then return end
	if self.IsFollowingPlayer and IsValid(self.FollowingPlayer) then
		local dist = self:GetRangeSquaredTo(self.FollowingPlayer)
		if dist > 300^2 then
			local goal = self.FollowingPlayer:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300
			local navs = navmesh.Find(goal,256,100,20)
			local nav = navs[math.random(#navs)]
			local pos = goal
			if nav then pos = nav:GetRandomPoint() end
			self:WanderToPosition( (pos), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		else
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
		end
	else
		if math.random(1,3) == 1 then
			self:WanderToPosition( ((self:GetPos()) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200), self.WalkAnim[math.random(1,#self.WalkAnim)], self.MoveSpeed )
			coroutine.wait(1)
		else
			if self:GetActivity() != ACT_IDLE then
				self:StartActivity(ACT_IDLE)
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
		end
	end
	--self:WanderToPosition( (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.WanderDistance), self.WanderAnim[math.random(1,#self.WanderAnim)], self.MoveSpeed )
end

function ENT:OnOtherKilled( victim, info )
	if victim == self then return end
	local rel = self:CheckRelationships(victim)
	if rel == "foe" and victim == self.Enemy then
		local found = false
		if !istable(self.temptbl) then self.temptbl = {} end
		for i=1, #self.temptbl do
			local v = self.temptbl[i]
			if istable(v) then
				local ent = v.ent
				if IsValid(ent) then
					if ent:Health() < 1 then
						self.temptbl[v] = nil
					end
					if IsValid(ent) and ent != self.Enemy then
						found = true
						self:SetEnemy(ent)
						break
					end
				else
					self.temptbl[i] = nil
				end
			end
		end
		if !found then
			self:Speak("OnVictory")
		end
	elseif rel == "friend" and victim:GetClass() == self:GetClass() then
		self.Berserk = true
		self.RageBonus = 0.83
		self:Speak("OnBerserk")
	end
end

function ENT:OnLostSeenEnemy(ent)
	if ent == self.Enemy then
		if !self.OnLostContactSpoke then
			self.OnLostContactSpoke = true
			timer.Simple( math.random(5,10) ,function()
				if IsValid(self) then
					self.OnLostContactSpoke = false
				end
			end )
			self:Speak("OnLostContact")
		end
	end
end

function ENT:RoarPush()
	for i = 1, 3 do
		timer.Simple( (i*0.3)+0.5, function()
			if IsValid(self) and self:Health() > 0 then
				util.ScreenShake( self:WorldSpaceCenter(), 5, 5, 0.5, 500 )
				for	k,v in pairs(ents.FindInCone(self:GetPos(), self.MeleeDir or self:GetForward(), 300,  math.cos( math.rad( self.MeleeConeAngle ) ))) do
					if v != self and self:CheckRelationships(v) != "friend" then
						v:SetVelocity( ( ( self.MeleeDir or self:GetForward() ) * self.MeleeDamage ) + self:GetUp()*150 )
						if IsValid(v:GetPhysicsObject()) then
							v:GetPhysicsObject():ApplyForceCenter( v:GetPhysicsObject():GetPos() +((v:GetPhysicsObject():GetPos()-self:GetPos()):GetNormalized())*self.MeleeForce )
						end
					end
				end
			end
		end )
	end
end

function ENT:CustomBehaviour(ent)
	if !IsValid(ent) then return end
	--if !ent:IsOnGround() then return self:StartShooting(ent) end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	local dist = self:GetRangeSquaredTo(ent:GetPos())
	if los then
		if IsValid(ent) then
			self.LastSeenEnemyPos = ent:GetPos()
		end
		local result = self:StartChasing(ent,self.RunAnim[math.random(1,#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true)
		if result == "Failed" then
			if dist < 400^2 then
				self:Speak("OnRoar")
				self:RoarPush()
				self:PlaySequenceAndWait("Taunt_Roar_Push")
			else
				self:Speak("OnRoarShort")
				self:PlaySequenceAndWait("Taunt_Roar_"..math.random(1,3).."")
			end
		end
	elseif !los then
		self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier, false )
	end
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
	self:DoGestureSeq("Fuel_Rod_Fire")
	self:FireWep()
	--self:CustomBehaviour(ent)
end

function ENT:FireWep()
	local ent = ents.Create("astw2_haloreach_fuelrod_projectile")
	ent:SetPos(self:GetShootPos())
	ent:SetAngles(self:GetAngles())
	ent:SetOwner(self)
	ent:Spawn()
	self:Speak("SFXOnBeamFire")
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		local off = math.Rand((1/self.Difficulty)*0.5,0)
		phys:ApplyForceCenter(((self:GetAimVector()*2)+((self:GetUp()*(off))))*2000)
	end
end

function ENT:GetShootPos()
	--[[if IsValid(self:GetActiveWeapon()) then
		return self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment("muzzle")).Pos
	end]]
	return self:WorldSpaceCenter()+self:GetUp()*80
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
	if options == self.MeleeEvent then
		self:DoMeleeDamage()
	end
end

function ENT:DoMeleeDamage()
	local damage = self.MeleeDamage
	util.ScreenShake( self:WorldSpaceCenter(), 5, 5, 0.5, 500 )
	for	k,v in pairs(ents.FindInCone(self:GetPos()+self:GetUp()*80, self.MeleeDir or self:GetForward(), self.MeleeRange,  math.cos( math.rad( self.MeleeConeAngle ) ))) do
		if v != self and self:CheckRelationships(v) != "friend" then
			local d = DamageInfo()
			d:SetDamage( damage )
			d:SetAttacker( self )
			d:SetInflictor( self )
			d:SetDamageType( DMG_SLASH )
			d:SetDamagePosition( v:NearestPoint( self:WorldSpaceCenter() ) )
			v:TakeDamageInfo(d)
			if v:IsPlayer() then
				v:ViewPunch( self.ViewPunchPlayers )
			end
			if v:IsPlayer() or v:IsNextBot() or v:IsNPC() then
				v:EmitSound( self.OnMeleeImpactSoundTbl[math.random(1,#self.OnMeleeImpactSoundTbl)] )
			end
			v:SetVelocity( ( ( self.MeleeDir or self:GetForward() ) * self.MeleeDamage ) + self:GetUp()*100 )
			if IsValid(v:GetPhysicsObject()) then
				v:GetPhysicsObject():ApplyForceCenter( v:GetPhysicsObject():GetPos() +((v:GetPhysicsObject():GetPos()-self:GetPos()):GetNormalized())*self.MeleeForce )
			end
		end
	end
end

function ENT:Melee()
	self:RemoveAllGestures()
	self:Speak("OnMelee")
	local ang = self:GetAimVector():Angle()
	local name = "Melee_"..math.random(1,3)..""
	local move = false
	local angl = true
	local yd = 0
	local dir = 1
	local dir2 = 0
	self.DoingMelee = true
	if IsValid(self.Enemy) then
		local ydif = math.AngleDifference(self:GetAngles().y,ang.y)
		if ydif < 0 then ydif = ydif+360 end
		--print(ydif)
		if ydif >= 315 or ydif < 45 then
			self:SetAngles(Angle(self:GetAngles().p,ang.y,self:GetAngles().r))
			self:EmitSound( self.OnMeleeSoundTbl[math.random(1,#self.OnMeleeSoundTbl)] )
			move = true
			angl = false
			self.MeleeDir = self:GetForward()
		elseif ydif >= 225 and ydif < 315 then -- Left
			name = "Melee_Left"
			self:EmitSound( self.OnMeleeLeftSoundTbl[math.random(1,#self.OnMeleeLeftSoundTbl)] )
			yd = 0
			dir = 0
			dir2 = -1
			move = true
			self.MeleeDir = -self:GetRight()
		elseif ydif < 225 and ydif >= 135 then -- Back
			dir = -1
			name = "Melee_Back"
			self:EmitSound( self.OnMeleeBackSoundTbl[math.random(1,#self.OnMeleeBackSoundTbl)] )
			yd = -180
			move = true
			self.MeleeDir = -self:GetForward()
		elseif ydif >= 45 and ydif < 135 then -- Right
			dir = 0
			dir2 = 1
			name = "Melee_Right"
			self:EmitSound( self.OnMeleeRightSoundTbl[math.random(1,#self.OnMeleeRightSoundTbl)] )
			yd = 0
			move = true
			self.MeleeDir = self:GetRight()
		end
	end	
	local len = self:SetSequence( name )
	--self:StartActivity(self:GetSequenceActivity(self:LookupSequence(name)))
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )
	
	timer.Simple( len, function()
		if IsValid(self) then
			self.DoingMelee = false
		end
	end )
	
	if move then

		local t = (len/speed)+CurTime()
		local p = self:GetPos()
		local a = self:GetAngles()
		while (t > CurTime()) do
			local yes, mov, ang = self:GetSequenceMovement( self:LookupSequence(name), 0, self:GetCycle() )
			mov:Rotate(Angle(0,ang.y+a.y,0))
			if util.IsInWorld(p+mov) then
				self:SetPos(p+mov)
			end
			self:SetAngles(a+ang)
			coroutine.yield()
		end
	else
		coroutine.wait( len/speed )
	end 
	self:SetAngles(self:GetAngles()+Angle(0,yd,0))
end

function ENT:StartChasing( ent, anim, speed, los )
	if los then
		self:Speak("OnCharge")
	else
		self:Speak("OnInvestigate")
	end
	self:StartActivity( anim )
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	return self:ChaseEnt(ent,los)
end

ENT.NextUpdateT = CurTime()

ENT.UpdateDelay = 0.5

function ENT:ChaseEnt(ent,los)
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
			if dist < self.MeleeDistance^2 then
				return self:Melee()
			elseif cansee and !los then
				return "GotLOS"
			elseif dist > self.LoseEnemyDistance^2 then
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				return "Lost enemy"
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
	local new = true
	if isvector(self.LastSeenEnemyPos) then
		new = false
	end
	if new then
		self:Speak("OnAlert")
		self.NewSP = true
	else
		self:Speak("OnWarnIncoming")
	end
	self.LastSeenEnemyPos = ent:GetPos()
	self:AlertAllies(ent)
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

function ENT:DoKilledAnim()
	if self.KilledDmgInfo:GetDamageType() != DMG_BLAST then
		if self.KilledDmgInfo:GetDamage() <= 150 then
			self:Speak("OnDeath")
			local anim = self:DetermineDeathAnim(self.KilledDmgInfo)
			if anim == true then 
				local rag = self:CreateRagdoll(self.KilledDmgInfo)
				return
			end
			local seq, len = self:LookupSequence(anim)
			timer.Simple( len, function()
				if IsValid(self) then
					local rag
					if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
						timer.Simple( 60, function()
							if IsValid(rag) then
								rag:Remove()
							end
						end)
					end
					rag = self:CreateRagdoll(DamageInfo())
				end
			end )
			self:ResetSequence(anim)
			local t = (len/speed)+CurTime()
			local p = self:GetPos()
			local a = self:GetAngles()
			while (t > CurTime()) do
				local yes, mov, ang = self:GetSequenceMovement( self:LookupSequence(anim), 0, self:GetCycle() )
				mov:Rotate(Angle(0,ang.y+a.y,0))
				if util.IsInWorld(p+mov) then
					self:SetPos(p+mov)
				end
				self:SetAngles(a+ang)
				coroutine.yield()
			end
		else
			self:Speak("OnDeathPainful")
			local rag
			if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
				timer.Simple( 60, function()
					if IsValid(rag) then
						rag:Remove()
					end
				end)
			end
			rag = self:CreateRagdoll(self.KilledDmgInfo)
		end
	else
		self:Speak("OnDeathThrown")
		local rag
		if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
			timer.Simple( 60, function()
				if IsValid(rag) then
					rag:Remove()
				end
			end)
		end
		rag = self:CreateRagdoll(self.KilledDmgInfo)
	end
end

function ENT:DetermineDeathAnim( info )
	local origin = info:GetAttacker():GetPos()
	local damagepos = info:GetDamagePosition()
	local ang = (damagepos-origin):Angle()
	local y = ang.y - self:GetAngles().y
	if y < 1 then y = y + 360 end
	--print(y)
	local anim
	if self.DeathHitGroup == 1 then
		anim = "Die_Head"
	else
		if ( y <= 90 or y >= 270 ) then
			anim = "Die_Back_Gut"
		else
			anim = "Die_Front_Gut"
		end
	end
	return anim
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:RemoveAllGestures()
	self.KilledDmgInfo = dmginfo
	self.BehaveThread = nil
	self.DrownThread = coroutine.create( function() self:DoKilledAnim() end )
	coroutine.resume( self.DrownThread )
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

local moves = {
	[ACT_RUN_AGITATED] = true,
	[ACT_WALK_CROUCH_AIM] = true
	--[ACT_RUN] = true
}

function ENT:FoleySound()
	local character = self.Voices[self.VoiceType]
	if character["OnMoveFoley"] and istable(character["OnMoveFoley"]) then
		local sound = table.Random(character["OnMoveFoley"])
		self:EmitSound(sound,75)
	end
end

function ENT:FootstepSound()
	local character = self.Voices[self.VoiceType]
	if character["OnStep"] and istable(character["OnStep"]) then
		local sound = table.Random(character["OnStep"])
		self:EmitSound(sound,100)
	end
end


function ENT:BodyUpdate()
	local act = self:GetActivity()
	if moves[act] and !self.DoingMelee and self:Health() > 0 then
		self:BodyMoveXY()
	end
	if !self.loco:GetVelocity():IsZero() and self.loco:IsOnGround() then
		if !self.LMove then
			self.LMove = CurTime()+0.75
		else
			if self.LMove < CurTime() then
				self:FoleySound()
				self:FootstepSound()
				self.LMove = CurTime()+0.75
				util.ScreenShake(self:GetPos(),512,100,0.6,2048)
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
	local goal = self:GetPos()+self.loco:GetVelocity()
	local y = (goal-self:GetPos()):Angle().y
	local di = math.AngleDifference(self:GetAngles().y,y)
	self:SetPoseParameter("move_yaw",di)
	self:FrameAdvance()
end

list.Set( "NPC", "npc_iv04_hr_guta", {
	Name = "Gúta",
	Class = "npc_iv04_hr_guta",
	Category = "Halo Reach"
} )