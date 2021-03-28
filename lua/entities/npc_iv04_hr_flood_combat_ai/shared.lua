AddCSLuaFile()
include("voices.lua")
ENT.Base 			= "npc_iv04_base"
ENT.MoveSpeed = 40
ENT.MoveSpeedMultiplier = 5
ENT.BehaviourType = 3
ENT.BulletNumber = 1
ENT.IdleSoundDelay = math.random(6,10)
ENT.SightType = 2
 
--ENT.FriendlyToPlayers = true

--ENT.WalkAnim = {ACT_RUN_PISTOL}
--ENT.WanderAnim = {ACT_RUN_PISTOL}
--ENT.RunAnim = {ACT_RUN_PISTOL}

ENT.DodgeChance = 40
--[[ENT.CrouchingChance = 25
ENT.StepChance = 20]]
ENT.AttractAlliesRange = 1024

ENT.MeleeRange = 100

ENT.ChaseRange = 512

ENT.MeleeDistance = 120

ENT.ShieldHealth = 150

ENT.ShieldUp = true

ENT.ActionTime = 2.5

ENT.CollisionMask = MASK_NPCSOLID

-- Flinching

ENT.FlinchChance = 30

ENT.FlinchDamage = 5

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

ENT.MeleeDamage = 45

ENT.NPSound = 0

ENT.NISound = 0

ENT.CanUse = true

ENT.SearchJustAsSpawned = false

ENT.Faction = "FACTION_FLOOD"

ENT.MeleeEvents = {
	["event_pattack"] = true,
	["event_mattack"] = true
}

ENT.CurMag = 100

ENT.PistolHolds = {
	["pistol"] = true,
	["revolver"] = true
}

ENT.RifleHolds = {
	["smg"] = true,
	["ar2"] = true,
	["crossbow"] = true,
	["shotgun"] = true
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
--	local attach = self:GetAttachment(1)
	local id = self:LookupBone("ValveBiped.Bip01_R_Hand")
	local pos = self:GetBonePosition(id)
	if pos == self:GetPos() then
		pos = self:GetBoneMatrix(id):GetTranslation()
	end
	pos = self:WorldToLocal(pos)+self:GetUp()*4
	wep:SetOwner(self)
	wep:SetPos(pos)
	wep:SetAngles(self:GetForward():Angle())
	wep:Spawn()
	wep:PhysicsInit(SOLID_NONE)	
	wep:SetSolid(SOLID_NONE)
	wep:SetMoveParent(self)
	wep:SetParent(self,1)
	wep:Fire("setparentattachment", "anim_attachment_RH")
	wep:AddEffects(EF_BONEMERGE)
	self.Weapon = wep
	wep:SetClip1(wep:GetMaxClip1())
end


function ENT:OnInitialize()
	self:SetBloodColor(DONT_BLEED)
	self:DoInit()
	self.VoiceType = self.VoiceType or "Flood_Human"
	self.Difficulty = GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()
	if math.random(1,4) == 1 and !self.GotUp then
		self:Give(self.PossibleWeapons[math.random(#self.PossibleWeapons)])
	end
	self:SetCollisionBounds(Vector(20,20,80),Vector(-20,-20,0))
	if IsValid(self.Weapon) then
		if !self.Weapon.NextPrimaryFire then self.Weapon.NextPrimaryFire = CurTime() end
		local relo = self.Weapon.AI_Reload
		self:SetNWEntity("wep",self.Weapon)
		--self:SetBodygroup(0,math.random(0,1))
		self.Weapon.AI_Reload = function()
			relo(self.Weapon)
			self:DoAnimationEvent(1689)
		end
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
	if IsValid(self.Weapon) then
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Weapon1"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Weapon"))}
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Weapon1")),self:GetSequenceActivity(self:LookupSequence("Idle_Weapon2"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Weapon1")),self:GetSequenceActivity(self:LookupSequence("Idle_Weapon2"))}
	else
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk"))}
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle1")),self:GetSequenceActivity(self:LookupSequence("Idle2")),self:GetSequenceActivity(self:LookupSequence("Idle3"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle1")),self:GetSequenceActivity(self:LookupSequence("Idle2")),self:GetSequenceActivity(self:LookupSequence("Idle3"))}
	end
	self.GetupAnim1 = "Reinfect"
	self.GetupAnim2 = "Resurrect"
	self.Seqs = {
		[1] = "Evade_Left",
		[2] = "Evade_Right"
	}
end

function ENT:OnLeaveGround(ent)
	if self:Health() <= 0 then 
		self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne_"..math.random(1,2).."")))
	else
		if self.loco:GetVelocity():IsZero() then
			self.OldSeq = self:GetSequence()
		else
			self.OldSeq = self:SelectWeightedSequence(self.RunAnim[math.random(#self.RunAnim)])
		end
		self.LastTimeOnGround = CurTime()
		self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
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
			self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	elseif self.OldSeq then
		self:ResetSequence(self.OldSeq)
	end
end

function ENT:Speak(voice)
	local character = self.Voices[self.VoiceType]
	if self.CurrentSound then self.CurrentSound:Stop() end
	if character[voice] and istable(character[voice]) then
		local sound = table.Random(character[voice])
		self.CurrentSound = CreateSound(self,sound)
		self.CurrentSound:SetSoundLevel(100)
		self.CurrentSound:Play()
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
	--print("yes",CurTime())
	if (ent.IsVJBaseSNPC == true or ent.CPTBase_NPC == true or ent.IsSLVBaseNPC == true or ent:GetNWBool( "bZelusSNPC" ) == true) or (ent:IsNPC() && ent:GetClass() != "npc_bullseye" && ent:Health() > 0 ) or (ent:IsPlayer() and ent:Alive()) or ((ent:IsNextBot()) and ent != self ) then
		local d = (ent:GetPos()-self:GetPos())+ent:GetUp()
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
	--ParticleEffect( "halo_reach_blood_impact_jackal", dmg:GetDamagePosition(), Angle(0,0,0), self )
	if self.NPSound < CurTime() then
		self:Speak("OnHurt")
		self.NPSound = CurTime()+math.random(2,5)
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
	--print(trace.HitGroup)
	if trace.HitGroup == 1 then
		info:ScaleDamage(5)
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
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
			self:WanderToPosition( (pos), self.WalkAnim[math.random(1,#self.WalkAnim)], self.MoveSpeed )
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
			timer.Simple( 15, function()
				if IsValid(self) and !IsValid(self.Enemy) then
					self.Alerted = false
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
			self:WanderToPosition( ((self.LastSeenEnemyPos or self:GetPos()) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed )
			coroutine.wait(1)
		else
			--if self:GetActivity() != self.IdleCalmAnim[1] then
			--	self:StartActivity(self.IdleCalmAnim[1])
			--end
			if  math.random(1,3) == 1 then
				self:WanderToPosition( ((self:GetPos()) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200), self.WalkAnim[math.random(1,#self.WalkAnim)], self.MoveSpeed )
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
			if !self.SpokeIdle then
				self:Speak("OnIdle")
				self.SpokeIdle = true
				timer.Simple( math.random(45,60), function()
					if IsValid(self) then
						self.SpokeIdle = false
					end
				end )
			end
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

function ENT:Flee(ent)
	ent = ent or self.Enemy
	if !IsValid(ent) then return end
	local navs = navmesh.Find( self:GetPos(), 1024, 100, 10 )
	local tbl = {}
	for k, nav in pairs(navs) do
		if !nav:IsVisible( self:WorldSpaceCenter() ) then
			tbl[nav:GetID()] = nav
		end
	end
	if table.Count(tbl) > 0 or #tbl > 0 then
		self.Hiding = true
		local area = table.Random(tbl)
		self:MoveToPosition( area:GetRandomPoint(), ACT_RUN_AGITATED, self.MoveSpeed*(6) )
		timer.Simple( 5, function()
			if IsValid(self) then
				self.Hiding = false
			end
		end )
	end
	if !self.Hiding then
		local nav = table.Random(navs)
		self:MoveToPosition( nav:GetRandomPoint(), ACT_RUN_AGITATED,self.MoveSpeed*(6) )
	end
end

function ENT:MoveToPosition( pos, anim, speed, getnear )
	if !util.IsInWorld( pos ) then return "Tried to move out of the world!" end
	self:StartActivity( anim )			-- Move animation
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self.loco:SetAcceleration( speed+speed )
	self:MoveToPos( pos, getnear )
	self:StartActivity( self.IdleAnim[math.random(1,#self.IdleAnim)] )
end	

function ENT:OnOtherKilled( victim, info )
	if victim == self then return end
	if self:Health() < 1 then return end
	local rel = self:CheckRelationships(victim)
	if rel == "foe" and victim == self.Enemy then
		if !victim.BeenNoticed then
			victim.BeenNoticed = true
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
		if self.SawAllyDie and !self.SawAlliesDie then self.SawAlliesDie = true end
		if !self.SawAllyDie then self.SawAllyDie = true end
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

function ENT:CustomBehaviour(ent)
	if !IsValid(ent) then return end
	if !ent:IsOnGround() then return self:StartShooting(ent) end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	local dist = self:GetRangeSquaredTo(ent:GetPos())
	if !self.IsSniper and ( ( ent.GetEnemy and ent:GetEnemy() == self ) or BeingStaredAt(self,ent,60) ) and los then
		if math.random(1,100) <= self.DodgeChance and !self.Dodged then
			local anim = self.Seqs[math.random(1,2)]
			self:Speak("OnDodge")
			return self:Dodge(anim)
		end
	end
	if los then
		if dist < self.MeleeDistance^2 then
			return self:Melee()
		end
		if IsValid(ent) then
			self.LastSeenEnemyPos = ent:GetPos()
		end
		self:StartShooting(ent)
		if dist > self.ChaseRange^2 then
			local chase = false
			if !IsValid(ent.Chaser1) or ent.Chaser1.Enemy != ent then
				ent.Chaser1 = self
				chase = true
			elseif !IsValid(ent.Chaser2) or ent.Chaser2.Enemy != ent then
				ent.Chaser2 = self
				chase = true
			end
			if chase then
				self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier, true )
			else
				local pos = ent:GetPos()+ent:GetRight()*math.random(512,-512)
				self:MoveToPosition( pos, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier, true )
				self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier, true )
			end
		else
			self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier, true )
		end
	elseif !los then
		if IsValid(obstr) then
			local ros = self:CheckRelationships(obstr)
			if ros == "foe" then
				self:SetEnemy(obstr)
			end
		else
			--self.LastTarget = ent
			--self:SetEnemy(nil)
			--self.Alerted = true
			self:StartChasing( ent, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		end
	end
end

function ENT:GetNear(ent)
	local t = math.Rand(0,1)+(self.ActionTime-(self.Difficulty*0.8))
	local stop = false
	local shoot = false
	local move = true
	timer.Simple( t, function()
		if IsValid(self) then
			stop = true
		end
	end )
	timer.Simple( t-math.Rand(0,1), function()
		if IsValid(self) then
			move = false
		end
	end )
	timer.Simple( t/2, function()
		if IsValid(self) then
			shoot = true
			dir = dire
		end
	end )
	if self.IsSniper then
		self:ResetSequence("Move_Rifle_Slow")
		self.loco:SetDesiredSpeed(self.MoveSpeed*2.5)
	else
		self:StartMovingAnimations(self.WalkAnim[math.random(#self.WalkAnim)],self.MoveSpeed*self.MoveSpeedMultiplier)
	end
	local r = math.random(2,3)
	local dir
	local dire
	if r == 2 then
		dir = self:GetRight()*1
		dire = self:GetForward()*math.random(1,-1)
	elseif r == 3 then
		dir = self:GetRight()*-1
		dire = self:GetForward()*math.random(1,-1)
	end
	while (!stop) do
		if IsValid(ent) then
			if shoot then
				shoot = false
				self:ShootBullet(ent)
			end
			self.loco:FaceTowards(ent:GetPos())
			if move then
				self.loco:Approach(self:GetPos()+dir,1)
			else
				self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
			end
			coroutine.wait(0.01)
		else
			stop = true
		end
	end
	self:StartActivity( self.IdleAnim[math.random(#self.IdleAnim)] )
end

function ENT:MoveToPos( pos, getnear ) -- MoveToPos but I added some stuff
	for i = 1, #self.IdleAnim do
		if self.loco:GetVelocity():IsZero() and self:GetActivity() == self.IdleAnim[i] then
			self:StartActivity( self.WanderAnim[math.random(1,#self.WanderAnim)] )
		end
	end
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or self.PathMinLookAheadDistance )
	path:SetGoalTolerance( options.tolerance or self.PathGoalTolerance )
	path:Compute( self, pos )
	if ( !IsValid(path) ) then return "failed" end
	while ( IsValid(path) ) do
		if GetConVar( "ai_disabled" ):GetInt() == 1 then
			return "Disabled thinking"
		end
		if self.UpdateTime < CurTime() then
			if self.loco:GetVelocity():IsZero() and self.loco:IsAttemptingToMove() then
				-- We are stuck, don't bother
				return "Give up"
			end
			self.UpdateTime = CurTime()+0.25
		end
		if IsValid(self.Enemy) and getnear and self.NextUpdateT < CurTime() then
			self.NextUpdateT = CurTime()+0.5
			local ent = self.Enemy
			local cansee = self:CanSee( ent:GetPos() + ent:OBBCenter(), ent )
			saw = cansee
			local dist = self:GetPos():DistToSqr(ent:GetPos())
			if dist < self.MeleeDistance^2 then
				return self:Melee()
			elseif dist < self.ChaseRange^2 then
				return self:ChaseEnt( self.Enemy, true )
			elseif dist > self.LoseEnemyDistance^2 then
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				return "Lost enemy"
			end
			if cansee then
				self.LastSeenEnemyPos = ent:GetPos()
			end
		end
		path:Update( self )
		if ( options.draw ) then
			path:Draw()
		end
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		coroutine.yield()
	end
	return "ok"
end

function ENT:StartShooting(ent)
	if IsValid(self.Weapon) then
		ent = ent or self.Enemy or self:GetEnemy()
		if !IsValid(ent) then return end
		self:StartActivity( self.IdleAnim[math.random(#self.IdleAnim)] )
		local t = math.Rand(0,1)+(self.ActionTime-(self.Difficulty*0.8))
		timer.Simple( t/2, function()
			if IsValid(self) then
				self:ShootBullet(ent)
			end
		end )
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
	if !self.ShootQuote and math.random(1,4) == 1 then
		self.ShootQuote = true
		timer.Simple( 5, function()
			if IsValid(self) then
				self.ShootQuote = false
			end
		end )
		self:Speak("OnDamagedFoe")
	end
	self:FireWep()
	--self:CustomBehaviour(ent)
end

function ENT:GetEyeTrace()
	return util.TraceLine( { start = self:WorldSpaceCenter()+self:GetUp()*40, endpos = (self:WorldSpaceCenter())+self:GetAimVector()*99999999, filter = self } )
end

function ENT:KeyDown(key)
	if key == IN_ATTACK then
		return self.StartS
	end
	return false
end

function ENT:ViewPunch(sex)
	-- no
end

function ENT:FireWep()
	local n = self:GetCurrentWeaponProficiency()+2
	for i = 1, n do
		timer.Simple( 0.1*i, function()
			if IsValid(self) then
				--self:DoGestureSeq(self.FireAnim)
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
	
	self:PlaySequenceAndPWait( name, speed, self:GetPos() )

end

function ENT:GetAimVector(pos)
	if self.IsControlled then
		return self.DPly:GetAimVector()
	end
	if IsValid(self.Enemy) then
		local p = self.Enemy:WorldSpaceCenter()
		if pos then p = pos end
		if self.GetShootPos then
			return (p-self:GetShootPos()):GetNormalized()
		else
			return (p-self:WorldSpaceCenter()):GetNormalized()
		end
	else
		return self:GetForward()
	end
end

function ENT:GetShootPos()
	--[[if IsValid(self:GetActiveWeapon()) then
		return self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment("muzzle")).Pos
	end]]
	if self.IsSniper then
		if self.Weapon:GetClass() == "astw2_haloreach_focus_rifle" then
			return self:WorldSpaceCenter()+self:GetUp()*40
		else
			return self:WorldSpaceCenter()
		end
	else
		return self:WorldSpaceCenter()
	end
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
	if self.MeleeEvents[options] then
		self:DoMeleeDamage()
	end
end

local se = {
	[1] = "Step Right",
	[2] = "Step Left"
}

function ENT:DoMeleeDamage()
	local damage = self.MeleeDamage
	for	k,v in pairs(ents.FindInCone(self:WorldSpaceCenter(), self.MeleeDir or self:GetForward(), self.MeleeRange,  math.cos( math.rad( self.MeleeConeAngle ) ))) do
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

function ENT:Melee()
	--self:RemoveAllGestures()
	self:Speak("OnMelee")
	local ang = self:GetAimVector():Angle()
	local name = "Attack"..math.random(1,4)..""
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
		if ydif >= 270 or ydif <= 90 then
			self:SetAngles(Angle(self:GetAngles().p,ang.y,self:GetAngles().r))
			--self:EmitSound( self.OnMeleeSoundTbl[math.random(1,#self.OnMeleeSoundTbl)] )
			move = true
			angl = false
			self.MeleeDir = self:GetForward()
		elseif ydif < 270 and ydif > 90 then -- Back
			dir = -1
			name = "Attack_Backwards"
			--self:EmitSound( self.OnMeleeBackSoundTbl[math.random(1,#self.OnMeleeBackSoundTbl)] )
			yd = 180
			move = true
			self.MeleeDir = -self:GetForward()
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
			if !ang1 then
				mov:Rotate(Angle(0,ang.y+a.y,0))
			end
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

function ENT:OnLeaveGround( ent )
	self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Air")) )
end

function ENT:JumpTo(ent)
	local dir = self:GetAimVector()*1200
	self.loco:JumpAcrossGap(self:GetPos()+dir,self:GetForward())
	local func = function()
		while (!self.loco:IsOnGround()) do
			coroutine.wait(0.01)
		end
		self:PlaySequenceAndWait( "Land" )
	end
	table.insert(self.StuffToRunInCoroutine,func)
	self:ResetAI()
end

ENT.NextUpdateT = CurTime()

ENT.UpdateDelay = 0.5

function ENT:ChaseEnt(ent,los)
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( self.PathMinLookAheadDistance )
	path:SetGoalTolerance( self.PathGoalTolerance )
	if !IsValid(ent) then return end
	path:Compute( self, ent:GetPos() )
	if ( !path:IsValid() ) then coroutine.wait(1) return "Failed" end
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
			if cansee and !los then
				return "GotLOS"
			elseif dist < self.MeleeDistance^2 then
				return self:Melee()
			elseif dist > self.LoseEnemyDistance^2 then
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				return "Lost enemy"
			end
			if cansee then
				self.LastSeenEnemyPos = ent:GetPos()
			end
			if !self.Jumped then
				self.Jumped = true
				timer.Simple( math.random(10,15), function()
					if IsValid(self) then
						self.Jumped = false
					end
				end )
				if dist > 800^2 then
					return self:JumpTo(ent)
				end
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
	self:Speak("OnAlert")
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

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	--self:SetBodygroup(3,1)
	self.KilledDmgInfo = dmginfo
	local killer = dmginfo:GetAttacker()
	--self.BehaveThread = nil
	local class = self:GetClass()
	local rag = self:CreateRagdoll( dmginfo )
	if !self.GotUp and math.random(1,10) <= 3 then
		timer.Simple( math.random(5,10), function()
			if IsValid(rag) then
				local pos = rag:GetPos()
				local ang = Angle(0,rag:GetAngles().y,0)
				local sel = ents.Create( class )
				sel.IsNTarget = true
				sel:SetPos(rag:GetPos())
				sel:SetAngles(ang)
				sel:Spawn()
				sel.GotUp = true
				local func = function()
					sel:PlaySequenceAndWait( sel.GetupAnim1 )
					sel.IsNTarget = false
					sel:PlaySequenceAndWait( sel.GetupAnim2 )
				end
				table.insert(sel.StuffToRunInCoroutine,func)
				undo.ReplaceEntity(rag,sel)
				--killer:TakeDamage(100,sel,sel) -- heart attack
				rag:Remove()
			end
		end )
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
			if !self.IsSniper then
				local a,len = self:LookupSequence("pistol_reload")
				local func = function()
					self:DoGestureSeq(a)
				end
				table.insert(self.StuffToRunInCoroutine,func)
			end
		end
	end
end

function ENT:SetViewPunchAngles(no)
	-- No
end

function ENT:GetCurrentWeaponProficiency()
	return self.Difficulty*2 or 1
end

local moves = {
	[ACT_RUN_AGITATED] = true,
	[ACT_WALK_CROUCH_AIM] = true,
	[ACT_RUN] = true,
	[ACT_RUN_PISTOL] = true,
	[ACT_RUN_RIFLE] = true
}
function ENT:FootstepSound()
	local character = self.Voices[self.VoiceType]
	if character["OnStep"] and istable(character["OnStep"]) then
		local sound = table.Random(character["OnStep"])
		self:EmitSound(sound,55)
	end
end


function ENT:BodyUpdate()
	local act = self:GetActivity()
	if moves[act] and self:Health() > 0 then
		self:BodyMoveXY()
	end
	if !self.loco:GetVelocity():IsZero() and self.loco:IsOnGround() then
	if !self.LMove then
			self.LMove = CurTime()+0.27
		else
			if self.LMove < CurTime() then
				self:FootstepSound()
				self.LMove = CurTime()+0.27
			end
		end
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