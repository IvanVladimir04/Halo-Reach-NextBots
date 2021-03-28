AddCSLuaFile()
ENT.Base 			= "npc_iv04_base"
ENT.Models  = {"models/halo_reach/vehicles/covenant/scarab.mdl"}
ENT.Relationship = 4
ENT.StartHealth = 8000
ENT.MeleeDamage = 30
ENT.RunAnim = {ACT_WALK}
ENT.SightType = 3
ENT.BehaviourType = 3
ENT.Faction = "FACTION_COVENANT"
ENT.MoveSpeed = 200
ENT.MoveSpeedMultiplier = 1 -- When running, the move speed will be x times faster
ENT.CustomIdle = true

ENT.SearchJustAsSpawned = false

ENT.RunBehaviourTime = 0

ENT.Voices = {
	["Scarab"] = {
		["Spawned"] = {
			"halo_reach/vehicles/scarab/100pb_scripted_orbital_bounced/incoming1.ogg",
			"halo_reach/vehicles/scarab/100pb_scripted_orbital_bounced/incoming2.ogg"
		},
		["Land"] = {
			"halo_reach/vehicles/scarab/100pb_scripted_orbital_bounced/mono_hit1.ogg",
			"halo_reach/vehicles/scarab/100pb_scripted_orbital_bounced/mono_hit2.ogg"
		},
		["AA"] = {
			"halo_reach/vehicles/scarab/scarab_main_turret_fire/scarab_main_turret1.ogg",
			"halo_reach/vehicles/scarab/scarab_main_turret_fire/scarab_main_turret2.ogg",
			"halo_reach/vehicles/scarab/scarab_main_turret_fire/scarab_main_turret3.ogg"
		},
		["BeamCharge"] = {
			"halo_reach/vehicles/scarab/scarab_charge_h3.ogg"
		},
		["BeamIn"] = {
			"halo_reach/vehicles/scarab/scarab_beam_in.ogg"
		},
		["BeamLoop"] = {
			"halo_reach/vehicles/scarab/scarab_beam_loop.wav"
		},
		["BeamOut"] = {
			"halo_reach/vehicles/scarab/scarab_beam_out.ogg"
		},
		["Alarm"] = {
			"halo_reach/vehicles/scarab/scarab_alarm.ogg"
		},
		["DeathScreech"] = {
			"halo_reach/vehicles/scarab/scarab_death_roar.ogg"
		},
		["DeathExplosion"] = {
			"halo_reach/vehicles/scarab/scarab_destroyed_mono.ogg"
		}
	}
}

function ENT:FireAnimationEvent(pos,ang,event,name)
	--print(pos)
	--print(ang)
	--print(event)
	--print(name)--halo_reach/vehicles/scarab/scarab_steps/scarab_step (1-7) .ogg
	if options == "IV04_Reach_Scarab.Step" then
		self:EmitSound("halo_reach/vehicles/scarab/scarab_steps/scarab_step"..math.random(1,7)..".ogg",80)
	end
end

ENT.VoiceType = "Scarab"

function ENT:Speak(voice,stopothersounds)
	local character = self.Voices[self.VoiceType]
	if stopothersounds and self.CurrentSound then self.CurrentSound:Stop() end
	if character[voice] and istable(character[voice]) then
		local sound = table.Random(character[voice])
		self.CurrentSound = CreateSound(self,sound)
		self.CurrentSound:SetSoundLevel(100)
		self.CurrentSound:Play()
	end
end

ENT.VulnerableHitgroups = {
	[4] = true, -- front right leg
	[5] = true, -- front left leg
	[6] = true, -- back left leg
	[7] = true -- back right leg
}

ENT.LegsArmor = {
	[4] = 100,
	[5] = 100,
	[6] = 100,
	[7] = 100
}

ENT.LegsArmorBodygroups = {
	[6] = 1,
	[7] = 2,
	[5] = 3,
	[4] = 4
}
-- -16 min reasonable AA pitch
function ENT:OnInjured( info )	
	if IsValid(info:GetAttacker()) and self:CheckRelationships(info:GetAttacker()) == "friend" and !self.AllowFriendlyFire and !info:GetAttacker():IsPlayer() then
		info:ScaleDamage(0)
		return
	elseif !self.ChangedTarget and self:CheckRelationships(info:GetAttacker()) == "foe" then
		local ref = self:GetAttachment(2)
		local pos = info:GetAttacker():WorldSpaceCenter()
		local ang = ((pos-ref.Pos):GetNormalized()):Angle()
		local dif = math.AngleDifference(ref.Ang.p,ang.p)
		--print(dif)
		if dif >= -16 then
			self.ChangedTarget = true
			timer.Simple( math.random(2,5), function()
				if IsValid(self) then
					self.ChangedTarget = false
				end
			end )
			self.OtherTarget = info:GetAttacker()
		else
			self.ChangedTarget = true
			timer.Simple( math.random(2,5), function()
				if IsValid(self) then
					self.ChangedTarget = false
				end
			end )
			if IsValid(self.Enemy) then
				self:SetEnemy(info:GetAttacker())
			else
				self:SetEnemy(info:GetAttacker())
				self:OnHaveEnemy(info:GetAttacker())
			end
		end
	end
	local p = info:GetDamagePosition()
	if IsValid(info:GetInflictor()) then p = info:GetInflictor():WorldSpaceCenter() end
	local dir = (self:NearestPoint(p)-p):GetNormalized()
	local trace = util.TraceLine( {
		start = info:GetDamagePosition()+dir*-200,
		endpos = self:NearestPoint(info:GetDamagePosition()),
		filter = {}
	} )
	--print(trace.HitGroup)
	if self.VulnerableHitgroups[trace.HitGroup] then
		local tr = trace.HitGroup
		if self.LegsArmor[tr] > 0 then
			self.LegsArmor[tr] = self.LegsArmor[tr]-math.abs(info:GetDamage())
			if self.LegsArmor[tr] < 0 then 
				ParticleEffect("halo_reach_explosion_covenant",trace.HitPos,self:GetAngles()+Angle(-90,0,0),nil)
				self:SetBodygroup(self.LegsArmorBodygroups[tr],1) 
				self.LegsArmor[tr] = 0 
				local gib = ents.Create("prop_physics")
				gib:SetModel("models/halo_reach/vehicles/covenant/gibs/scarab_gib_armor_flap.mdl")
				gib:SetPos( trace.HitPos )
				gib:Spawn()
				timer.Simple( 30, function()
					if IsValid(gib) then	
						gib:Remove()
					end
				end )
				local phys = gib:GetPhysicsObject()
				if phys then
					phys:Wake()	
					phys:SetMass( phys:GetMass()*10 )
				end
			end
		end
		if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
		info:ScaleDamage(2)
	end
	if !info:IsExplosionDamage() then
		info:SetDamage(0)
	end
end

function ENT:BeforeThink()
	if !IsValid(self.OtherTarget) then
		self:AssignTarget(self.Enemy)
	end
end

function ENT:AssignTarget(ent)
	if !IsValid(ent) then return end
	local ref = self:GetAttachment(2)
	local pos =ent:WorldSpaceCenter()
	local ang = ((pos-ref.Pos):GetNormalized()):Angle()
	local dif = math.AngleDifference(ref.Ang.p,ang.p)
	--print(dif)
	if dif >= -16 then
		self.ChangedTarget = true
		timer.Simple( math.random(2,5), function()
			if IsValid(self) then
				self.ChangedTarget = false
			end
		end )
		self.OtherTarget = ent
	else
		self.ChangedTarget = true
		timer.Simple( math.random(2,5), function()
			if IsValid(self) then
				self.ChangedTarget = false
			end
		end )
		if IsValid(self.Enemy) then
			self:SetEnemy(ent)
		else
			self:SetEnemy(ent)
			self:OnHaveEnemy(ent)
		end
	end
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

function ENT:PreInit()
	--self:SetNoDraw(true)
end

function ENT:OnInitialize()
	self:SetBloodColor(BLOOD_COLOR_MECH)
	self:SetHealth(self.StartHealth*(GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()/2))
	local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos()+Vector(0,0,10000000000),
		filter = self
	} )
	if tr.HitSky then
		self:Speak("Spawned")
		local id, len = self:LookupSequence("Spawn_Drop")
		timer.Simple( len*0.34, function()
			if IsValid(self) then
				self:Speak("Land")
				util.ScreenShake( self:GetPos(), 500, 500, 3, 4096 )
			end
		end )
		timer.Simple( len*0.99, function()
			if IsValid(self) then
				local anim = self.IdleAnim[math.random(#self.IdleAnim)]
				self:StartActivity(anim)
				self.Landed = true
			end
		end )
		local func = function()
			self:PlaySequenceAndWait(id)
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	end
end

function ENT:OnHaveEnemy(ent)
	self:ResetAI()
end

function ENT:DoCustomIdle()
	local anim = self.IdleAnim[math.random(#self.IdleAnim)]
	local seq = self:SelectWeightedSequence(anim)
	self:StartActivity(anim)
	self:SearchEnemy()
	local dur = self:SequenceDuration(seq)
	timer.Simple( dur/2, function()
		if IsValid(self) then
			self:SearchEnemy()
		end
	end )
	coroutine.wait(dur)
	self:SearchEnemy()
end

function ENT:CustomBehaviour(ent,range)
	ent = ent or self.Enemy
	if !IsValid(ent) then self:GetATarget() end
	if !IsValid(self.Enemy) then return else ent = self.Enemy end
	local an = (self.Enemy:WorldSpaceCenter()-self:GetAttachment(1).Pos):GetNormalized():Angle()
	local angy = math.AngleDifference(an.y,self:GetAngles().y)
	--print(angy)
	if angy < 45 and angy > -45 then
		if self.HasTurned then
			self:StartActivity(self.LAct)
			self.HasTurned = false
		end
		sound.Play("halo_reach/vehicles/scarab/scarab_charge_h3.ogg",self:GetAttachment(1).Pos,100)
		for i = 1, 8 do
			timer.Simple( (i*0.5)+2.5, function()
				if IsValid(self) and IsValid(self.Enemy) then
					if i == 1 then
						sound.Play("halo_reach/vehicles/scarab/scarab_beam_in.ogg",self:GetAttachment(1).Pos,100)
					elseif i == 8 then
						sound.Play("halo_reach/vehicles/scarab/scarab_beam_out.ogg",self:GetAttachment(1).Pos,100)
					end
					local att = self:GetAttachment(1)
					local projec = ents.Create( "ent_proj_haloreach_scarab_cannon" )
					projec:SetPos(att.Pos)
					projec:SetAngles(att.Ang)
					projec:Spawn()
					--projec:SetCollisionGroup( COLLISION_GROUP_WORLD )
					projec.ServerThink = function() end
					projec:SetOwner(self)
					local phys = projec:GetPhysicsObject()
					if IsValid(phys) then
						phys:Wake()
						phys:SetVelocity( (self.Enemy:WorldSpaceCenter()-att.Pos):GetNormalized()*4000 )
					end
					--ParticleEffect( "astw2_halo_reach_muzzle_concussion_rifle", att.Pos, att.Ang, self )
				end
			end )
		end
		coroutine.wait( 12 )
	else
		self.HasTurned = true
		self.LAct = self:GetActivity()
		self:StartMovingAnimations( ACT_WALK, self.MoveSpeed*self.MoveSpeedMultiplier )
		for i = 1, 300 do
			timer.Simple( 0.01*i, function()
				if IsValid(self) and IsValid(self.Enemy) then
					local dir = (self.Enemy:WorldSpaceCenter()-self:GetAttachment(1).Pos):GetNormalized()
					local an = dir:Angle()
					local angy = math.AngleDifference(an.y,self:GetAngles().y)
					self.loco:Approach(self:GetPos()-dir,1)
					if angy > 30 then
						self:SetAngles(self:GetAngles()+Angle(0,0.1,0))
					elseif angy < -30 then
						self:SetAngles(self:GetAngles()+Angle(0,-0.1,0))
					end
				end
			end )
		end
		coroutine.wait(3)
	end
end

function ENT:GetSecondShootPos()
	return self:GetAttachment(2).Pos
end

ENT.NextTurretThink = 0

ENT.NMSound = 0

if SERVER then

	function ENT:Think()
		if self:Health() < 1 or !self.Landed then return end
		if self.NMSound < CurTime() then
			self.NMSound = self.NMSound+2.5
			if self.MShortSound then self.MShortSound:Stop() end
			self.MShortSound = CreateSound( self, "halo_reach/vehicles/scarab/scarab_walk_move_short/scarab_walk_short"..math.random(1,7)..".ogg" )
			self.MShortSound:SetSoundLevel( 80 )
			self.MShortSound:Play()
		end
		if self.NextTurretThink < CurTime() then
			self.NextTurretThink = CurTime()+math.random(6,10)
			if IsValid(self.OtherTarget) then
				if self.AAShoot then
					for i = 1, math.random(2,4) do
						timer.Simple( (i*0.4)-0.4, function()
							if IsValid(self) and IsValid(self.OtherTarget) then
								local att = self:GetAttachment(2)
								local projec = ents.Create( "ent_proj_haloreach_scarab_aa_gun" )
								projec:SetPos(att.Pos)
								projec:SetAngles(att.Ang)
								projec:Spawn()
								--projec:SetCollisionGroup( COLLISION_GROUP_WORLD )
								projec.ServerThink = function() end
								projec:SetOwner(self)
								local phys = projec:GetPhysicsObject()
								if IsValid(phys) then
									phys:Wake()
									phys:SetVelocity( (self.OtherTarget:WorldSpaceCenter()-att.Pos):GetNormalized()*4000 )
								end
								--ParticleEffect( "astw2_halo_reach_muzzle_concussion_rifle", att.Pos, att.Ang, self )
								sound.Play("halo_reach/vehicles/scarab/scarab_main_turret_fire/scarab_main_turret"..math.random(1,3)..".ogg",self:GetSecondShootPos(),100)
							end
						end )
					end
				end
			end
		end
		--self:ResetSequence("reference")
	end

end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:SetBodygroup(7,1)
	self:SetBodygroup(8,1)
	self:SetBodygroup(9,1)
	self:SetBodygroup(10,1)
	self:SetBodygroup(11,1)
	self:SetBodygroup(12,1)
	self:Speak("DeathScreech")
	for i = 1, 4 do
		timer.Simple( i, function()
			if IsValid(self) then
				self:Speak("Alarm")
			end
		end )
	end
	self.KilledDmgInfo = dmginfo
	self.BehaveThread = nil
	self.DieThread = coroutine.create( function() self:DoKilledAnim() end )
	coroutine.resume( self.DieThread )
	--if self.HasRagdoll == true then
	--	self:CreateRagdoll( dmginfo )
	--else
	--	self:Remove()
	--end
end

function ENT:DoKilledAnim()
	local anim = "Death"
	local len = self:SetSequence(anim)
	local speed = (14/GetConVar("halo_reach_nextbots_ai_scarab_explosions"):GetInt())
	for i = 1, GetConVar("halo_reach_nextbots_ai_scarab_explosions"):GetInt() do 
		timer.Simple( i*speed, function()
			if IsValid(self) then
				ParticleEffect("halo_reach_explosion_covenant",self:GetAttachment(math.random(18)).Pos,self:GetAngles()+Angle(-90,0,0),nil)
			end
		end )
	end
	timer.Simple( len*2, function()
		if IsValid(self) then
			self:Speak("DeathExplosion")
		end
	end )
	timer.Simple( len*2.2, function()
		if IsValid(self) then
			ParticleEffect( "iv04_halo_reach_scarab_explosion", self:WorldSpaceCenter(), Angle(0,0,0), nil )
			for k, v in pairs(ents.FindInSphere(self:GetPos(),2048)) do
				if v != self and (v:IsNPC() or v:IsNextBot() or v:IsPlayer() ) then
					local dmg = DamageInfo()
					dmg:SetAttacker(self)
					dmg:SetInflictor(self)
					dmg:SetDamage(600)
					dmg:SetDamageType(DMG_BLAST)
					v:TakeDamageInfo(dmg)
				end
			end
			for k, v in pairs(player.GetAll()) do
				if self:GetRangeSquaredTo(v:WorldSpaceCenter()) < 8096^2 then
					v:SetNWBool("FoolNearBoom",true)
					timer.Simple( 5, function()
						if IsValid(v) then v:SetNWBool("FoolNearBoom",false) end
					end )
				end
			end
			self:Remove()
		end
	end )
	self:PlaySequenceAndWait(anim)
end

ENT.LTP = 0
ENT.LTPP = 0
ENT.LTPAA = 0
ENT.LTPA = 0

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if !self.loco:GetVelocity():IsZero() and self.loco:IsOnGround() then
		local goal = self:GetPos()+self.loco:GetVelocity()
		local y = (goal-self:GetPos()):Angle().y
		local di = math.AngleDifference(self:GetAngles().y,y)
		self:SetPoseParameter("move_yaw",di)
	end
	local look = false
	local goal
	local y
	local di = 0
	local p
	local dip = 0
	if IsValid(self.OtherTarget) then
		goal = self.OtherTarget:WorldSpaceCenter()
		local an = (goal-self:GetAttachment(2).Pos):Angle()
		y = an.y
		p = an.p
		if !self.AATransitioned then
			local vy = math.AngleDifference(self:GetAngles().y+self.LTPAA,y)
			local vp = math.AngleDifference(self:GetAngles().p+self.LTPA,p)
			self.AATransitioned = true
			timer.Simple(0.01, function()
				if IsValid(self) then
					self.AATransitioned = false
				end
			end )
			if math.abs(vy) > 5 then
				self.LTPAA = self:GetPoseParameter("aim_yaw_turret")
				local i
				if vy < 0 then
					i = 2
				else
					i = -2
				end
				if self.LTPAA+i > 180 then
					self.LTPAA = (self.LTPAA)-360
				elseif self.LTPAA+i < -180 then
					self.LTPAA = (self.LTPAA)+360
				end
				self:SetPoseParameter("aim_yaw_turret",self.LTPAA+i)
				self.AAShoot = false
			else
				self.AAShoot = true
			end
			if math.abs(vp) > 2 then
				self.LTPA = self:GetPoseParameter("aim_pitch_turret")
				local i
				if (vp) <= self.LTPA/2 then
					i = 1
				else
					i = -1
				end
				self:SetPoseParameter("aim_pitch_turret",self.LTPA+i)
			end
		end
	end
	if IsValid(self.Enemy) then
		goal = self.Enemy:WorldSpaceCenter()
		local an = (goal-self:GetAttachment(1).Pos):Angle()
		y = an.y
		p = an.p
		if !self.Transitioned then
			local vy = math.AngleDifference(self:GetAngles().y+self.LTPP,y)
			local vp = math.AngleDifference(self:GetAngles().p+self.LTP,p)
			self.Transitioned = true
			timer.Simple(0.01, function()
				if IsValid(self) then
					self.Transitioned = false
				end
			end )
			if math.abs(vy) > 5 then
				self.LTPP = self:GetPoseParameter("aim_yaw")
				local i
				if vy < 0 then
					i = 2
				else
					i = -2
				end
				self:SetPoseParameter("aim_yaw",self.LTPP+i)
			end
			if math.abs(vp) > 2 then
				self.LTP = self:GetPoseParameter("aim_pitch")
				local i
				if (vp) <= self.LTP then
					i = 1
				else
					i = -1
				end
				self:SetPoseParameter("aim_pitch",self.LTP+i)
			end
		end
	end
	if !self.DoingFlinch and self:Health() > 0 then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
end

list.Set( "NPC", "npc_iv04_hr_scarab", {
	Name = "Scarab",
	Class = "npc_iv04_hr_scarab",
	Category = "Halo Reach"
} )