AddCSLuaFile()

ENT.Base 			= "npc_iv04_base"
ENT.PrintName = "Hunter"
ENT.StartHealth = 200
ENT.MoveSpeed = 50
ENT.MoveSpeedMultiplier = 4
ENT.BehaviourType = 3
ENT.BulletNumber = 1
ENT.IdleSoundDelay = math.random(6,10)
ENT.Models = {"models/halo_reach/characters/covenant/hunter.mdl"}
ENT.SightType = 2

ENT.HasArmor = false

--ENT.FriendlyToPlayers = true

ENT.DodgeChance = 20
--[[ENT.CrouchingChance = 25
ENT.StepChance = 20]]
ENT.AttractAlliesRange = 600

ENT.MeleeRange = 100

ENT.MeleeDistance = 180

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

ENT.MeleeDamage = 75

ENT.NPSound = 0

ENT.NISound = 0

ENT.CanUse = true

ENT.SearchJustAsSpawned = false

ENT.Shield = 50

ENT.Faction = "FACTION_COVENANT"

--ENT.StepEvent = "D3HumanNextbot.Step"

local seqs = {
	[1] = "dive_left",
	[2] = "dive_right"
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

function ENT:OnInitialize()
	self:DoInit()
end

function ENT:DoInit()
	--print(marinevariant)
	--self:SetCollisionBounds(Vector(-30,-30,0),Vector(30,30,80))
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
	self.CrouchWalkAnim = ACT_WALK_CROUCH_AIM
end

function ENT:OnLeaveGround(ent)
	if self.loco:GetVelocity():IsZero() then
		self.OldSeq = self:GetSequence()
	else
		self.OldSeq = self:SelectWeightedSequence(self.RunAnim[1])
	end
	self.LastTimeOnGround = CurTime()
	self:StartActivity(self.IdleAnim[1])
end

function ENT:OnLandOnGround(ent)
	if self.LastTimeOnGround then
		local t = CurTime()-self.LastTimeOnGround
		local seq
		if t < 3 then
			seq = "land_soft"
		else
			seq = "land_hard"
		end
		local func = function()
			self:PlaySequenceAndWait(seq)
			self:StartActivity(self.IdleAnim[1])
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	elseif self.OldSeq then
		self:ResetSequence(self.OldSeq)
	end
end

function ENT:Speak(voice)
	local character = self.Voices["Hunter"]
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
		ParticleEffect( "blood_impact_hunter", dmg:GetDamagePosition(), Angle(0,0,0), self )
	if !IsValid(self.Enemy) then
		if self:CheckRelationships(dmg:GetAttacker()) == "foe" then
			--self:Speak("Surprise")
			self:SetEnemy(dmg:GetAttacker())
		end
	else
		if self.NPSound < CurTime() then
			if dmg:GetDamage() > 10 then
				self:Speak("PainMajor")
			else
				self:Speak("PainMinor")
			end
			self.NPSound = CurTime()+math.random(2,5)
		end
	end
end

ENT.Variations = {
	[ACT_FLINCH_CHEST] = {["Back"] = "flinch_back_chest", ["Front"] = "flinch_front_chest"},
	[ACT_FLINCH_STOMACH] = {["Back"] = "flinch_back_gut", ["Front"] = "flinch_front_gut"}
}

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

local normalgroups = {
	[1] = true,
	[3] = true
}

function ENT:OnTraceAttack( info, dir, trace )
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	--print(trace.HitGroup)
	if !normalgroups[trace.HitGroup] then
		info:ScaleDamage( 0.25 )
	end
	if !self.DoingFlinch  then
		if self.FlinchHitgroups[trace.HitGroup] then
			local act
			if self.Variations[self.FlinchHitgroups[trace.HitGroup]] then
				--act = self.FlinchHitgroups[trace.HitBox]
				local ang = dir:Angle().y-self:GetAngles().y
				local tbl = self.Variations[self.FlinchHitgroups[trace.HitGroup]]
				if ang < 1 then ang = ang + 360 end
				if ( ang < 90 or ang > 270 ) then
					act = tbl["Back"]
				else
					act = tbl["Front"]
				end
			else
				act = self:SelectWeightedSequence(self.FlinchHitgroups[trace.HitGroup])
			end
			self.DoingFlinch = true
			local id, dur = self:LookupSequence(act)
			timer.Simple(dur, function()
				if IsValid(self) then
					self.DoingFlinch = false
				end
			end )
			local func = function()
				self:DoGestureSeq(id)
				--self:StartActivity(self.IdleAnim[1])
			end
			table.insert(self.StuffToRunInCoroutine,func)
			self:ResetAI()
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
			self:WanderToPosition( (pos), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed )
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
		if self.Alerted then
			self:WanderToPosition( ((self.LastSeenEnemyPos or self:GetPos()) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
			coroutine.wait(1)
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
	end
	--self:WanderToPosition( (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.WanderDistance), self.WanderAnim[math.random(1,#self.WanderAnim)], self.MoveSpeed )
end

function ENT:OnOtherKilled( victim, info )
	if victim == self then return end
	local rel = self:CheckRelationships(victim)
	if rel == "foe" and victim == self.Enemy then
		if !victim.BeenNoticed then
			victim.BeenNoticed = true
			self:Speak("KilledEnemy")
		end
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
			if math.random(1,3) == 1 then
				local func = function()
					self:WanderToPosition( self.LastSeenEnemyPos, self.RunAnim[1], self.MoveSpeed*self.MoveSpeedMultiplier )
					self.IdleAnim = {ACT_IDLE}
				end
				table.insert(self.StuffToRunInCoroutine,func)
			end
		end
	end
end

function ENT:RunAround()	
	local r = math.random(1,2)
	if r == 2 then r = -1 end
	local t = CurTime()+math.random(2,3)
	local eff = EffectData()
	eff:SetOrigin(self.Latcher:GetPos())
	util.Effect("BloodImpact",eff)
	local dir = self:GetForward()+self:GetRight()*r
	local goal = self:GetPos()+(dir*900)
	self.loco:SetDesiredSpeed(self.MoveSpeed)
	while (self:Health() > 0 ) do
		if self:GetSequence() != self:LookupSequence("stunned_run") then
			self:SetSequence("stunned_run")
		end
		if t < CurTime() then
			local tim = math.random(2,4)
			t = CurTime()+tim
			r = math.random(1,2)
			if r == 2 then r = -1 end
			local eff = EffectData()
			eff:SetOrigin(self.Latcher:GetPos())
			util.Effect("BloodImpact",eff)
			dir = self:GetForward()+self:GetRight()*r
			goal = self:GetPos()+(dir*900)
			self:TakeDamage(20,self,self)
			timer.Simple( tim/2, function()
				if IsValid(self) then
					local eff = EffectData()
					eff:SetOrigin(self.Latcher:GetPos())
					util.Effect("BloodImpact",eff)
				end
			end )
		end
		self.loco:Approach(goal,1)
		self.loco:FaceTowards(goal)
		coroutine.wait(0.01)
	end
end



function ENT:CustomBehaviour(ent)
	if !IsValid(ent) then return end
	if !ent:IsOnGround() then return self:StartShooting(ent) end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	local dist = self:GetRangeSquaredTo(ent:GetPos())
	if !self.IsSniper and ent.GetEnemy and ent:GetEnemy() == self and los then
		if math.random(1,100) <= self.DodgeChance and !self.Dodged then
			local anim = seqs[math.random(1,2)]
			self:Speak("Dive")
			self:Dodge(anim)
		end
	end
	if los then
		if IsValid(ent) then
			self.LastSeenEnemyPos = ent:GetPos()
		end
		if dist < 300^2 then
			self:StartChasing(ent,self.RunAnim[math.random(1,#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true)
		else
			self:StartShooting(ent)
		end
	elseif !los then
		self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier, false )
	end
end

function ENT:GetNear(ent)
	local t = math.random(3,6)
	local stop = false
	local shoot = false
	timer.Simple( t, function()
		if IsValid(self) then
			stop = true
		end
	end )
	timer.Simple( t/2, function()
		if IsValid(self) then
			shoot = true
		end
	end )
	self:StartMovingAnimations(self.CrouchWalkAnim,self.MoveSpeed)
	local r = math.random(1,3)
	local dir
	if r == 1 then
		dir = self:GetForward()*1
	elseif r == 2 then
		dir = self:GetRight()*1
	elseif r == 3 then
		dir = self:GetRight()*-1
	end
	while (!stop) do
		if shoot then
			shoot = false
			self:ShootBullet(ent)
		end
		if IsValid(ent) then
			self.loco:FaceTowards(ent:GetPos())
		end
		self.loco:Approach(self:GetPos()+dir,1)
		coroutine.wait(0.01)
	end
end

function ENT:StartShooting(ent)
	ent = ent or self.Enemy or self:GetEnemy()
	if !IsValid(ent) then return end
	local crouch = math.random(1,2)
	if crouch == 1 then
		self:StartActivity( ACT_COWER )
		timer.Simple( 2, function()
			if IsValid(self) then
				self:ShootBullet(ent)
			end
		end )
		for i = 1, 30 do
			timer.Simple( 0.1*i, function()
				if IsValid(self) and IsValid(ent) then
					self.loco:FaceTowards(ent:GetPos())
				end
			end )
		end
		coroutine.wait(3)
	else
		self:GetNear(ent)
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
	self:DoGestureSeq("fuel_rod_fire")
	self:FireWep()
	--self:CustomBehaviour(ent)
end

function ENT:FireWep()
	local ent = ents.Create("astw2_halo_ce_fuel_rod_launched")
	ent:SetPos(self:GetShootPos())
	ent:SetAngles(self:GetAngles())
	ent:SetOwner(self)
	ent:Spawn()
	self:EmitSound("halo/combat_evolved/weapons/fuelrodcannon_fire.ogg",100)
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(((self:GetAimVector()*2)+((self:GetUp()*(math.Rand(0.3,0))+self:GetRight()*(math.Rand(0.4,-0.4)))))*1000)
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
	
	if name == "dive_right" then dir = 1 end
	
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
	return self:GetAttachment(self:LookupAttachment("muzzle")).Pos
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
			local d = DamageInfo()
			d:SetDamage( damage )
			d:SetAttacker( self )
			d:SetInflictor( self )
			d:SetDamageType( DMG_SLASH )
			d:SetDamagePosition( v:NearestPoint( self:WorldSpaceCenter() ) )
			v:TakeDamageInfo(d)
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

function ENT:Melee()
	self:Speak("Melee")
	timer.Simple( 0.85, function()
		if IsValid(self) then
			self:DoMeleeDamage()
		end
	end )
	local ang = self:GetAimVector():Angle()
	self:SetAngles(Angle(self:GetAngles().p,ang.y,self:GetAngles().r))
	local name = "melee"
	self.loco:SetDesiredSpeed( self.MoveSpeed*(self.MoveSpeedMultiplier/2) )
	local len = self:SetSequence( name )
	self:StartActivity(self:GetSequenceActivity(self:LookupSequence(name)))
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local dir = 1
	
	for i = 1, len*15 do
		timer.Simple( (i*0.05), function()
			if IsValid(self) then
				self.loco:Approach(self:GetPos()+self:GetForward()*dir,1)
			end
		end )
	end

	coroutine.wait( len / speed )
end

function ENT:StartChasing( ent, anim, speed, los )
	self:StartActivity( anim )
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,los)
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
			elseif dist > 400^2 and cansee and los then
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
	local new = true
	if isvector(self.LastSeenEnemyPos) then
		new = false
	end
	if new then
		self.IdleAnim = {ACT_COWER}
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

function ENT:DoKilled( info )
	if self.loco:IsOnGround() then
		if info:GetDamageType() == DMG_BLAST then
			self:Speak("DeathViolent")
		else
			self:Speak("DeathQuiet")
		end
	else
		self:Speak("DeathFalling")
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
	if ( y <= 45 or y >= 315 ) then
		anim = "die_back_gut"
	elseif ( y > 45 and y <= 135 ) then -- left
		anim = "die_left_gut"
	elseif ( y < 225 and y > 135 ) then -- front
		anim = "die_front_gut"
	elseif y >= 225 then -- right
		anim = "die_right_gut"
	end
	if info:GetDamageType() == DMG_BLAST then
		anim = "dead_airborne"
	end
	return anim
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	local anim = self:DetermineDeathAnim( dmginfo )
	self:DoKilled(dmginfo)
	local corpse = ents.Create("prop_dynamic")
	corpse:SetPos(self:GetPos())
	corpse:SetModel(self:GetModel())
	corpse:SetAngles(self:GetAngles())
	corpse:Spawn()
	corpse:Activate()
	corpse:ResetSequenceInfo()
	
	for i = 1, #self:GetBodyGroups() do
		local tbl = self:GetBodyGroups()[i]
		local set = self:GetBodygroup(tbl.id)
		corpse:SetBodygroup(tbl.id,set)
	end
	local id, len = corpse:LookupSequence(anim)
	corpse:SetSequence(id)
	if anim == "dead_airborne" then
		local name = "RestInPeace"..corpse:EntIndex()..""
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		prop:SetPos(corpse:GetPos()+corpse:GetUp()*40)
		prop:SetNoDraw(true)
		prop:Spawn()
		prop:Activate()
		corpse:SetParent(prop)
		local phys = prop:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			local di = (corpse:GetPos()-dmginfo:GetDamagePosition()):GetNormalized()
			corpse:SetAngles(Angle(corpse:GetAngles().p,di:Angle().y,corpse:GetAngles().r))
			local dir = di+corpse:GetUp()*2
			phys:ApplyForceCenter( dir*(dmginfo:GetDamage()*50) )
		end
		local stop = false
		local eng
		prop:AddCallback( "PhysicsCollide", function( ent, data )
			eng = data.HitNormal:Angle()
			local tr = util.TraceLine( {
				start = ent:GetPos(),
				endpos = ent:GetPos()+Vector(0,0,-40),
				filter = {ent,corpse}
			} )
			stop = tr.Hit
		end )
		timer.Create( name, 0.2, 0, function()
			if IsValid(corpse) then
				if stop then
					local body = ents.Create("prop_dynamic")
					--body:SetPos(corpse:GetPos())
					body:SetModel(corpse:GetModel())
					body:SetAngles(Angle(eng.p-90,eng.y,eng.r))
					body:Spawn()
					body:Activate()
					body:ResetSequenceInfo()
					local i, le = body:LookupSequence("dead_land")
				--	local tr = util.TraceLine( {
				--		start = corpse:GetPos(),
				--		endpos = corpse:GetPos()+Vector(0,0-100),
				--		filter = {prop,corpse,body}
				--	} )
				--	if tr.Hit then
					body:SetPos(prop:NearestPoint(prop:GetPos()+Vector(0,0,-100)))
				--	end
					body:ResetSequence(i)
					if IsValid(prop) then prop:Remove() end
					timer.Simple( le-0.1, function()
						if IsValid(body) then
							body:SetPlaybackRate(0)
						end
					end )
					undo.ReplaceEntity( corpse, body )
					corpse:Remove()
					if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
						timer.Simple( 30, function()
							if IsValid(body) then
								body:Remove()
							end
						end)
					end
					timer.Remove(name)
				else
					if corpse:GetCycle() > 0.9  then
						corpse:ResetSequence("dead_airborne")
					end
				end
			else
				timer.Remove(name)
			end
		end )
	else
		timer.Simple( len-0.1, function()
			if IsValid(corpse) then
				corpse:SetPlaybackRate(0)
			end
		end )
		if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
			timer.Simple( 30, function()
				if IsValid(corpse) then
					corpse:Remove()
				end
			end)
		end
	end
	--corpse:SetCycle(1)
	corpse:SetPlaybackRate(1)
	corpse.Faction = self.Faction
	if !corpse:IsOnGround() then
		local tr = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos()+self:GetUp()*-999999,
			filter = {self,corpse}
		} )
		if tr.Hit then
			corpse:SetPos(tr.HitPos)
		end
	end
	undo.ReplaceEntity( self, corpse )
	self:Remove()
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
	[ACT_WALK_CROUCH_AIM] = true,
	[ACT_RUN] = true
}

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if moves[act] then
		self:BodyMoveXY()
	end
	local goal = self:GetPos()+self.loco:GetVelocity()
	local y = (goal-self:GetPos()):Angle().y
	local di = math.AngleDifference(self:GetAngles().y,y)
	self:SetPoseParameter("move_yaw",di)
	self:FrameAdvance()
end

list.Set( "NPC", "npc_iv04_hr_hunter", {
	Name = "Hunter",
	Class = "npc_iv04_hr_hunter",
	Category = "Halo Reach"
} )