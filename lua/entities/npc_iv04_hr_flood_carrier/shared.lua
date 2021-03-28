AddCSLuaFile()
include("voices.lua")
ENT.Base 			= "npc_iv04_base"
ENT.StartHealth = 50
ENT.Models  = {"models/halo_reach/characters/other/flood_carrier.mdl"}
ENT.Relationship = 4
ENT.MeleeDamage = 50
--ENT.RunAnim = {ACT_WALK}
ENT.SightType = 1
ENT.BehaviourType = 1
ENT.Faction = "FACTION_FLOOD"
--ENT.MeleeSound = { "doom_3/zombie2/zombie_attack1.ogg", "doom_3/zombie2/zombie_attack2.ogg", "doom_3/zombie2/zombie_attack3.ogg" }
ENT.MoveSpeed = 30
ENT.MoveSpeedMultiplier = 2 -- When running, the move speed will be x times faster
ENT.PrintName = "Flood Carrier Form"

ENT.MeleeRange = 120

ENT.IdleSoundDelay = 8

ENT.NPSound = 0

ENT.NISound = 0

ENT.VJ_NPC_Class = {"CLASS_HALO_FLOOD","CLASS_FLOOD","CLASS_PARASITE"}

ENT.SearchJustAsSpawned = true

ENT.VJ_EnhancedFlood = true

ENT.LoseEnemyDistance = 15000

ENT.VoiceType = "Flood_Carrier"

function ENT:CustomRelationshipsSetUp()
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


function ENT:OnInitialize()
	self:SetSolidMask(MASK_NPCSOLID)
	self:SetBloodColor(DONT_BLEED)
end

function ENT:BeforeThink()

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
			self:WanderToPosition( ((self.LastSeenEnemyPos or self:GetPos()) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200), self.WalkAnim[math.random(1,#self.WalkAnim)], self.MoveSpeed )
			coroutine.wait(1)
		else
			if self:GetActivity() != 1 then
				self:StartActivity(1)
			end
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

function ENT:OnHaveEnemy(ent)
	self:Speak("OnAlertWalk")
end

function ENT:OnInjured(dmg)
	local rel = self:CheckRelationships(dmg:GetAttacker())
	if rel == "friend" and !dmg:GetAttacker():IsPlayer() then
		dmg:ScaleDamage(0)
		return 
	end
end

function ENT:FireAnimationEvent(pos,ang,event,name)
	--[[print(pos)
	print(ang)
	print(event)
	print(name)]]
end

function ENT:HandleAnimEvent(event,eventTime,cycle,type,options)
	--[[print(event)
	print(eventTime)
	print(cycle)
	print(type)
	print(options)]]
	--if options == self.MeleeEvent then
		--self:DoMeleeDamage()
	--end
end

function ENT:DoMeleeDamage()
	local damage = self.MeleeDamage
	for	k,v in pairs(ents.FindInSphere(self:GetPos()+self:OBBCenter(), self.MeleeRange )) do
		if v != self and self:CheckRelationships(v) != "friend" and (v:IsNPC() or v:IsNextBot() or v:IsPlayer()) then
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

function ENT:DoKilled( info )

end

function ENT:Melee(damage) -- This section is really cancerous and a mess, if you want a nice melee I suggest you look at the oddworld stranger's wrath ones
	if self.DoingMelee == true then return end
	if !damage then damage = self.MeleeDamage end
	if IsValid(self.Enemy) then
		for i = 1, 30 do
			self.loco:FaceTowards( self.Enemy:GetPos() )
		end
	end
	local sequence = "Suicide"..math.random(1,2)..""
	self:Speak("OnSuicide")
	local id,len = self:LookupSequence(sequence)
	self:PlaySequenceAndPWait( id, 1, self:GetPos() )
	self:DoMeleeDamage()
	self:OnKilled(DamageInfo())
end

ENT.MeleeCheckDelay = 0.5

function ENT:ChaseEnt(ent) -- Modified MoveToPos to integrate some stuff
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( self.PathMinLookAheadDistance )
	path:SetGoalTolerance( self.PathGoalTolerance )
	if !IsValid(ent) then return end
	path:Compute(self,ent:GetPos())
	local goal
	local dis
	while ( IsValid(ent) and IsValid(path) ) do
		if GetConVar( "ai_disabled" ):GetInt() == 1 then
			self:StartActivity( self.IdleAnim[math.random(1,#self.IdleAnim)] )
			return "Disabled thinking"
		end
		if self.NextMeleeCheck < CurTime() then
			self.NextMeleeCheck = CurTime()+self.MeleeCheckDelay
			if self.loco:GetVelocity():IsZero() and self.loco:IsAttemptingToMove() then
				-- We are stuck, don't bother
				return "Give up"
			end
			local dist = self:GetPos():DistToSqr(ent:GetPos())
			if dist > self.LoseEnemyDistance^2 then 
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				self.State = "Idle"
				return "Lost Enemy"
			end
			if dist < self.MeleeRange^2 and self.HasMeleeAttack then
				return self:Melee(self.MeleeDamage)
			end
		end
		if ent:IsPlayer() then
			if GetConVar( "ai_ignoreplayers" ):GetInt() == 1 or !ent:Alive() then	
				self:SetEnemy(nil)
				return "Ignore players on"
			end
		end
		if path:GetAge() > self.RebuildPathTime then
			path:Compute(self,ent:GetPos())
			self:OnRebuiltPath()
		end
		path:Update( self )
		if self.loco:IsStuck() then
			self:OnStuck()
			return "Stuck"
		end
		coroutine.yield()
	end
	coroutine.wait(1)
	return "ok"
end

function ENT:OnKilled(dmginfo)
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	ParticleEffect("iv04_halo_reach_flood_carrier_form_gib", self:WorldSpaceCenter(), self:GetAngles(), nil )
	self:Speak("OnExplode")
	for i = 1, math.random(6,10) do
		local pop = ents.Create( "npc_iv04_hr_flood_infection_form" )
		pop:SetPos( self:WorldSpaceCenter()+self:GetUp()*math.random(20,70)+self:GetRight()*math.random(50,-50)+self:GetForward()*math.random(50,-50) )
		local dir = self:GetForward()*math.random(1,-1)+self:GetRight()*math.random(1,-1)+self:GetUp()*1
		pop.loco:SetVelocity( dir*10 )
		pop:SetAngles(Angle(0,dir:Angle().y,0))
		pop.FromCarrier = true
		pop:Spawn()
		pop.OCG = pop:GetCollisionGroup()
		pop:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
		--pop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		--pop:SetCollisionBounds(Vector(0,0,0),Vector(-0,-0,0))
		timer.Simple(2, function()
			if IsValid(pop) then
				pop:SetCollisionBounds(Vector(8,8,15),Vector(-8,-8,0))
				pop:SetCollisionGroup(pop.OCG)
				pop:SetSolidMask(MASK_NPCSOLID)
			end
		end )
	end
	self:Remove()
end

function ENT:BodyUpdate()
	local act = self:GetActivity()
	for i = 1, #self.WalkAnim do
		if act == self.WalkAnim[i] then
			self:BodyMoveXY()
		end
	end
	for i = 1, #self.WanderAnim do
		if act == self.WanderAnim[i] then
			self:BodyMoveXY()
		end
	end
	self:FrameAdvance()
end

list.Set( "NPC", "npc_iv04_hr_flood_carrier", {
	Name = "Flood Carrier Form",
	Class = "npc_iv04_hr_flood_carrier",
	Category = "Halo Reach Aftermath"
} )