AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Civilian"

ENT.Models = {"models/halo_reach/characters/other/civilian_female.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.MoveSpeedMultiplier = 2

ENT.FriendlyToPlayers = true

ENT.VoiceType = "FemaleTrooper1"

function ENT:DoInit()
	self:SetCollisionBounds(Vector(-20,-20,0),Vector(20,20,60))
	for i = 0, #self:GetBodyGroups() do
		self:SetBodygroup(i,math.random(0,self:GetBodygroupCount( i )-1))
	end
end

function ENT:OnLandOnGround(ent)
	if self.FlyingDead then
		self.HasLanded = true
	end
end

function ENT:SetupHoldtypes()
	self.DeadAirAnim = "Dead_Airborne"
	self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Panic_Idle_1")),self:GetSequenceActivity(self:LookupSequence("Panic_Idle_2"))}
	self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Panic_Idle_1")),self:GetSequenceActivity(self:LookupSequence("Panic_Idle_2"))}
	self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Panic_Sprint")),self:GetSequenceActivity(self:LookupSequence("Panic_Run_1"))}
	self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Panic_Walk"))}
	self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Panic_Walk"))}
	self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Panic_Crouch_Idle_1")),self:GetSequenceActivity(self:LookupSequence("Panic_Crouch_Idle_2")),self:GetSequenceActivity(self:LookupSequence("Panic_Crouch_Idle_3"))}
	self.CrouchEnterAnim = "Panic_Duck_And_Cover_Enter"
	self.CrouchExitAnim = "Panic_Duck_And_Cover_Exit"
	self.AllowGrenade = false
	self.CanShootCrouch = false
	self.CanMelee = false
end

function ENT:OnHaveEnemy(ent)
	if !self.HasSeenEnemies then
		self.HasSeenEnemies = true
		self:Speak("OnAlert")
	else
		if !self.SpokeMore then
			self:Speak("OnAlertMoreFoes")
			self.SpokeMore = true
			timer.Simple( math.random(5,10), function()
				if IsValid(self) then
					self.SpokeMore = false
				end
			end )
		end
	end
	if !self.IsInVehicle then
		self:ResetAI()
	end
end

function ENT:DoCustomIdle()
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
		--if self:GetActivity() != self.IdleCalmAnim[1] then
		--	self:StartActivity(self.IdleCalmAnim[1])
		--end
		if !self.SpokeIdle then
			self:Speak("OnIdle")
			self.SpokeIdle = true
			timer.Simple( math.random(45,60), function()
				if IsValid(self) then
					self.SpokeIdle = false
				end
			end )
		end
		if math.random(1,3) == 1 then
			self:WanderToPosition( ((self:GetPos()) + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		else
			local anim = self.IdleCalmAnim[math.random(#self.IdleCalmAnim)]
			local seq = self:SelectWeightedSequence(anim)
			self:StartActivity(anim)
			self:SearchEnemy()
			timer.Simple( self:SequenceDuration(seq)/2, function()
				if IsValid(self) then
					self:SearchEnemy()
				end
			end )
			coroutine.wait(self:SequenceDuration(seq))
			self:SearchEnemy()
		end
	end
	--self:WanderToPosition( (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.WanderDistance), self.WanderAnim[math.random(1,#self.WanderAnim)], self.MoveSpeed )
end

function ENT:CustomBehaviour(ent)
	if !IsValid(ent) then return end
	if !self.Hiding then
		local tbl = self:FindCoverSpots(ent)
		self.Hiding = true
		timer.Simple( math.random(4,10), function()
			if IsValid(self) then
				self.Hiding = false
			end
		end )
		if table.Count(tbl) > 0 or #tbl > 0 then
			local area = table.Random(tbl)
			self:MoveToPosition( area, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
			--if math.random(1,2) == 1 then
				--self:Speak("OnCover")
			--end
		else
			self:MoveToPosition( (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * math.random(512,1024)), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		end
	end
	if math.random(1,2) == 1 then
		self:PlaySequenceAndWait(self.CrouchEnterAnim)
		self:PlaySequenceAndWait(self:SelectWeightedSequence(self.CrouchIdleAnim[math.random(#self.CrouchIdleAnim)]))
		self:PlaySequenceAndWait(self.CrouchExitAnim)
	end
end

function ENT:MoveToPos( pos, options ) -- MoveToPos but I added some stuff
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
	local checked = false
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
			if !checked then
				checked = true
				if math.random(1,3) == 1 then
					local act = self:GetActivity()
					self:PlaySequenceAndPWait("Panic_Run_2",1,self:GetPos())
					--self:SetPos(self:GetPos()+self:GetForward()*80)
					self:StartActivity(act) 
				end
				timer.Simple( math.random(4,8), function()
					if IsValid(self) then checked = false end
				end )
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

function ENT:OnOtherKilled( victim, info )
	if victim == self then return end
	if self:Health() < 1 then return end
	local rel = self:CheckRelationships(victim)
	if rel == "friend" then

	elseif rel == "foe" and !victim.BeenNoticed then
		--victim.BeenNoticed = true
	end
	if victim == self.Enemy then self:GetATarget() end
end

function ENT:PlaySequenceAndPWait( name, speed, p )

	local an = self:GetAngles()
	
	if isstring(name) then name = self:LookupSequence(name) end

    local len = self:SetSequence( name )
    speed = speed or 1

    self:ResetSequenceInfo()
    self:SetCycle( 0 )
    self:SetPlaybackRate( speed )
	local stop = false
	timer.Simple( len-0.1, function()
		if IsValid(self) then stop = true end
	end )
    while (!stop) do
        local good,pos,ang = self:GetSequenceMovement(name,0,self:GetCycle())
		pos:Rotate(Angle(0,ang.y+an.y,0))
        local position = pos+p    
		if util.IsInWorld(position) then
			 self:SetPos(position)
		end
	--	if self:GetCycle() > 0.7 then
     --       local good,pos,ang = self:GetSequenceMovement(name,0,0.7)
     --       position = p+pos
     --   end
		self:SetAngles(ang+an)
        coroutine.yield()
    end

end

function ENT:OnTraceAttack( info, dir, trace )
	if trace.HitGroup == 1 then
		info:ScaleDamage(3)
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
end

function ENT:DoKilledAnim()
	if self.KilledDmgInfo:GetDamageType() != DMG_BLAST then
		if self.KilledDmgInfo:GetDamage() <= 150 then
			self:Speak("OnDeath")
			local anim = self:DetermineDeathAnim(self.KilledDmgInfo)
			--print("dead",anim)
			if anim == true then 
				local rag = self:BecomeRagdoll(self.KilledDmgInfo)
				return
			else
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
				self:PlaySequenceAndPWait(seq, 1, self:GetPos())
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
		self.FlyingDead = true
		local dir = ((self:GetPos()-self.KilledDmgInfo:GetDamagePosition())):GetNormalized()
		dir = dir+self:GetUp()*2
		local force = self.KilledDmgInfo:GetDamage()*1.5
		self:SetAngles(Angle(0,dir:Angle().y,0))
		self.loco:Jump()
		self.loco:SetVelocity(dir*force)
		coroutine.wait(0.5)
		while (!self.HasLanded) do
			if self.AlternateLanded then
				local rag
				if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
					timer.Simple( 60, function()
						if IsValid(rag) then
							rag:Remove()
						end
					end)
				end
				rag = self:CreateRagdoll(DamageInfo())
				return
			end
			coroutine.wait(0.01)
		end
		self:PlaySequenceAndWait("Dead_Land")
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
end

list.Set( "NPC", "npc_iv04_hr_human_civilian", {
	Name = "Civilian",
	Class = "npc_iv04_hr_human_civilian",
	Category = "Halo Reach"
} )