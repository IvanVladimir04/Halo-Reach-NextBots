AddCSLuaFile()
include("voices.lua")
ENT.Base 			= "npc_iv04_base"
ENT.MoveSpeed = 30
ENT.MoveSpeedMultiplier = 2
ENT.BehaviourType = 3
ENT.IdleSoundDelay = math.random(45,60)
ENT.SightType = 2
ENT.PrintName = "Engineer"

ENT.StartHealth = 100

ENT.Models = {"models/halo_reach/characters/covenant/engineer.mdl"}

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

ENT.IsEngineer = true

ENT.UseNBSight = true

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

function ENT:OnInitialize()
	self.OldGravity = self.loco:GetGravity()
	self.loco:SetGravity(0)
	ParticleEffectAttach( "iv04_halo_reach_jackal_sniper_glow", PATTACH_POINT_FOLLOW, self, 1 )
	--self.PerchOffChances = self.PerchChances[GetConVar("halo_reach_nextbots_ai_type"):GetString()]
	self.Del = 1.25-(GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()*0.25)
	--self.FlyGoal = self:WorldSpaceCenter()+self:GetUp()*math.random(160,240)
	self:DoInit()
	--self:Give("astw2_haloreach_plasma_pistol")
	--self:Give(self.StartWeapons[math.random(#self.StartWeapons)])
	self:SetBodygroup(3,1)
	self:SetCollisionBounds(Vector(40,20,50),Vector(-20,-20,0))
	local t1 = self.Voices["Engineer"]
	self.FlyLSound = CreateSound( self, table.Random(t1["FlyLoop"]) )
	self.FlyLSound:Play()
--	if !self.Weapon.NextPrimaryFire then self.Weapon.NextPrimaryFire = CurTime() end
--	local relo = self.Weapon.AI_Reload
--	self:SetNWEntity("wep",self.Weapon)
--	self.Weapon.AI_Reload = function()
--		relo(self.Weapon)
---		self:DoAnimationEvent(1689)
--	end
	self:SetupAnimations()
	--self:SetPos(self:GetPos()+self:GetUp()*150)
end

ENT.IsEngineer = true

if CLIENT then
	-- models/halo_reach/characters/covenant/elite/minor/energy_shield
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Initialize()
	end

end

function ENT:OnRemove()
	if self.FlyLSound then self.FlyLSound:Stop() end
end

function ENT:DoInit()
	--print(marinevariant)
	--self:SetCollisionBounds(Vector(-30,-30,0),Vector(30,30,80))
	self.Difficulty = GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
	self.DropshipPassengerIdleAnims = {
		[1] = "Phantom_Passenger_Idle"
	}
	self.DropshipPassengerExitAnims = {
		[1] = "Phantom_Passenger_Exit"
	}
end

function ENT:SetupAnimations()
	self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_2")),self:GetSequenceActivity(self:LookupSequence("Idle"))}
end

function ENT:OnLeaveGround(ent)
	if self:Health() <= 0 then 
		--self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne")))
	end
end

function ENT:OnLandOnGround(ent)
	--[[if self.FlyingDead then
		self.HasLanded = true
	elseif self.OldSeq then
		self:ResetSequence(self.OldSeq)
	elseif self.InFlight then
		self.InFlight = false
		local func = function()
			self:PlaySequenceAndWait("Flight_Land")
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	end]]
	--self.loco:Jump()
	--self.loco:SetVelocity(self:GetUp()*100)
	self:SetPos(self:GetPos()+self:GetUp()*150)
end

function ENT:Speak(voice)
	local character = self.Voices["Engineer"]
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

function ENT:HandleStanding()
end

ENT.CheckT = 0

ENT.CheckDel = 0.3

ENT.PathGoalTolerance = 80

function ENT:MoveToPos( pos )
	local goal = pos
	if !goal then return end
	local dire = (goal-self:WorldSpaceCenter()):GetNormalized()
	local reached = false
	while (!reached) do
		if GetConVar("ai_disabled"):GetBool() or self.Perching then
			reached = true
		end
		if self.CheckT < CurTime() then
			self.CheckT = CurTime()+self.CheckDel
			dire = (goal-self:WorldSpaceCenter()):GetNormalized()
			if self:NearestPoint(goal):DistToSqr(goal) < self.PathGoalTolerance^2 then
				reached = true
			end
		end
		self.loco:FaceTowards( pos )
		self.loco:SetVelocity( dire*(self.MoveSpeed*self.MoveSpeedMultiplier) )
		coroutine.wait(0.01)
	end
end

ENT.SCheck = 0

ENT.SCheckDel = 15

ENT.SFadeDel = 12

ENT.SRadius = 1024

if SERVER then

	function ENT:Think()
	
		if self.IsInVehicle then
			if self.InDropship then
				local att = self.Dropship:GetAttachment(self.Dropship:LookupAttachment(self.Dropship.InfantryAtts[self.DropshipId]))
				local ang = att.Ang
				local pos = att.Pos
				self:SetAngles(att.Ang)
				if !self.DLanded then
					self:SetPos(att.Pos+Vector(0,0,3))
					if !self.DidDropshipIdleAnim then
						self.DidDropshipIdleAnim = true
						local anim
						anim = self.DropshipPassengerIdleAnims[math.random(#self.DropshipPassengerIdleAnims)]
						local id, len = self:LookupSequence(anim)
						self:ResetSequence(id)
						--print(id,len)
						timer.Simple( len, function()
							if IsValid(self) then
								self.DidDropshipIdleAnim = false
							end
						end )
					end
				else
					local off = 0
					if self.SideAnim == "Right" then off = -0 end
					self:SetPos(att.Pos+Vector(0,0,3)-att.Ang:Right()*off)
				end
				--self.loco:SetVelocity(Vector(0,0,0))
			end
		elseif ( self:Health() > 0 ) then -- Stay in the air you fool

			if !self.FlyGoal and !IsValid(self.Enemy) then 
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
			
			if self.SCheck < CurTime() then
				self.SCheck = CurTime()+self.SCheckDel
				local p = self:WorldSpaceCenter()
				if !self.FirstTime then self.FirstTime = true p = p+Vector(0,0,150) end
				ParticleEffect( "iv04_halo_reach_engineer_shield_pulsate", p, self:GetAngles() )
				for k, v in pairs(ents.FindInSphere(self:WorldSpaceCenter(),1024)) do
					if v:Health() > 0 and (v:IsNextBot() or v:IsNPC() or v:IsPlayer()) and self:CheckRelationships(v) == "friend" and !v.BeenShielded then
						v.BeenShielded = true
						v:SetNWBool("ShieldingEnabled",true)
						v.EngineerShield = 100
						local changed = false
						if v.OnTraceAttack then
							v.OldOnTraceAttack = v.OnTraceAttack
							v.OnTraceAttack = function(v,dmg,dir,trace)
							ParticleEffect( "halo_reach_shield_impact_effect", dmg:GetDamagePosition(), Angle(0,0,0), self )
								--print(v,dmg)
								--dmg.PassedSHChecks = true
								--print(v,CurTime(),2)
								if v:GetNWBool("ShieldingEnabled",false) then
									--print("no damage")
									v.PassedSHChecks = CurTime()
									local d = v.EngineerShield
									v.EngineerShield = v.EngineerShield-dmg:GetDamage()
									dmg:SubtractDamage(d)
									if v.EngineerShield < 0 then v.OnInjured = v.OldOnInjured v.OnTraceAttack = v.OldOnTraceAttack v.EngineerShield = 0 v:SetNWBool( "ShieldingEnabled", false ) v.BeenShielded = false changed = true end
								end
								if dmg:GetDamage() > 0 then
									v:OldOnTraceAttack(dmg,dir,trace)
								end
							end
						end
						if v.OnInjured then
							v.OldOnInjured = v.OnInjured
							v.OnInjured = function(v,dmg)
								--print(v,CurTime(),1)
								if v.PassedSHChecks != CurTime() then
									if v:GetNWBool("ShieldingEnabled",false) then
										v.PassedSHChecks = CurTime()
										--print("no damage")
										local d = v.EngineerShield
										v.EngineerShield = v.EngineerShield-dmg:GetDamage()
										dmg:SubtractDamage(d)
										if v.EngineerShield < 0 then v.OnInjured = v.OldOnInjured v.OnTraceAttack = v.OldOnTraceAttack v.EngineerShield = 0 v:SetNWBool( "ShieldingEnabled", false ) v.BeenShielded = false changed = true end
									end
								end
								if dmg:GetDamage() > 0 then
									v:OldOnInjured(dmg)
								end
							end
						end
						timer.Simple( self.SFadeDel, function()
							if IsValid(v) and v.BeenShielded and !changed then
								v.BeenShielded = false
								v:SetNWBool("ShieldingEnabled",false)
								v.OnInjured = v.OldOnInjured
								v.OnTraceAttack = v.OldOnTraceAttack
							end
						end )
					end
				end
			end
			
		
		end
	
	end
	
elseif CLIENT then

	function ENT:Think()

			if self.SCheck < CurTime() then
				self.SCheck = CurTime()+self.SCheckDel
				for k, v in pairs(ents.FindInSphere(self:WorldSpaceCenter(),1024)) do
					if v:Health() > 0 and (v:IsNextBot() or v:IsNPC() or v:IsPlayer()) and self:CheckRelationships(v) == "friend" and !v:GetNWBool( "ShieldingEnabled", false ) then
						v.BeenShielded = true
						v.OldDraw = v.Draw
						v.Draw = function(v)
							v:DrawModel()
							render.SetColorModulation( 205, 45, 255 )
							render.MaterialOverride(HRShieldMaterial)
							
							v:DrawModel()
							render.MaterialOverride(nil)
						end
						for i = 1, 5 do
							timer.Simple( (self.SFadeDel/5)*i, function()
								if IsValid(v) then
									if i == 5 or !v:GetNWBool("ShieldingEnabled",false) then
										v.BeenShielded = false
										v.Draw = v.OldDraw
										ParticleEffect( "halo_reach_jackal_shield_deplete_effect_blue", v:WorldSpaceCenter(), Angle(0,0,0), self )
									end
								end
							end )
						end
					end
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

function ENT:OnTouchWorld( world )
	local p = world:NearestPoint(self:WorldSpaceCenter())
	local dir = (self:GetPos()-p):GetNormalized()
	self.loco:SetVelocity(dir*5)
end

function ENT:OnContact( ent ) -- When we touch someBODY
	if ent == game.GetWorld() then if self.FlyingDead then self.AlternateLanded = true else return self:OnTouchWorld(ent) end end
	if (ent:GetClass() == "prop_physics") or (ent.IsVJBaseSNPC == true or ent.CPTBase_NPC == true or ent.IsSLVBaseNPC == true or ent:GetNWBool( "bZelusSNPC" ) == true) or (ent:IsNPC() && ent:GetClass() != "npc_bullseye" && ent:Health() > 0 ) or (ent:IsPlayer() and ent:Alive()) or ((ent:IsNextBot()) and ent != self ) then
		local d = self:GetPos()-ent:GetPos()
		self.loco:SetVelocity(d)
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
	if self.HasArmor then
		ht = ht + self.Shield
	end
	if self.HasArmor and self.Shield > 0 then
		self:SetBodygroup(4,1)
		self.LShieldHurt = CurTime()
		local h = self.LShieldHurt
		timer.Simple( 1, function()
			if IsValid(self) and h == self.LShieldHurt then
				self:SetBodygroup(4,0)
			end
		end )
	else
		if dmg:GetDamage() > 0 then
			ParticleEffect( "halo_reach_blood_impact_grunt", dmg:GetDamagePosition(), Angle(0,0,0), self )
		end
	end
	local total = dmg:GetDamage()
	if self.HasArmor then
		--print(self.Shield, "before")
		self.ShieldActual = self.Shield
		self.ShieldH = CurTime()
		
		local shield = self.ShieldH
		local dm = dmg:GetDamage()
		total = dm-self.Shield
		if total < 0 then total = 0 end
		
		if dmg:IsBulletDamage() then
			dmg:SubtractDamage(self.Shield*2)
			self.Shield = self.Shield-math.abs(dm/2)
		else
			dmg:SubtractDamage(self.Shield)
			self.Shield = self.Shield-math.abs(dm)
		end
		if self.Shield < 0 then 
			self.Shield = 0 
			if self.ShieldActual > 0 then
				ParticleEffect( "iv04_halo_reach_elite_shield_pop", self:WorldSpaceCenter(), Angle(0,0,0), self )
			end
		end
		local shild = self.Shield
		timer.Simple( 3, function()
			if IsValid(self) and shield == self.ShieldH then
				local stop = false
				for i = 1, 10 do
					timer.Simple( 0.35*i, function()
						if IsValid(self) and shield == self.ShieldH and !stop then
							self.Shield = self.Shield+self.ShieldRegen
							if self.Shield > self.MaxShield then self.Shield = self.MaxShield
								stop = true
							end
						end
					end )
				end
			end
		end )
	end
	if (ht) - math.abs(dmg:GetDamage()) < 1 then return end
	if dmg:GetDamage() < 1 then return end
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
	--print(trace.HitGroup)
	if trace.HitGroup == 1 and self.LostProtection and ( !self.HasArmor or self.Shield < 1) then
		info:ScaleDamage(3)
	elseif !self.LostProtection then
		self.LostProtection = true
		self:SetBodygroup(2,1)
		self:StopParticles()
		local prop = ents.Create( "prop_physics" )
		prop:SetModel( "models/halo_reach/characters/covenant/engineer_helmet.mdl" )
		prop:SetPos(info:GetDamagePosition())
		prop:SetAngles(Angle(0,self:GetAngles().y,0))
		prop:Spawn()
		self.HasHelmet = false
		if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
			timer.Simple( 60, function()
				if IsValid(prop) then
					prop:Remove()
				end
			end)
		end
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	if self.HasArmor and self.Shield > 0 then
		ParticleEffect( "halo_reach_shield_impact_effect", info:GetDamagePosition(), Angle(0,0,0), self )
	end
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


function ENT:BeforeThink()
	local valid = IsValid(self.Enemy)
	if self.NISound < CurTime() and !valid then
		self:Speak("OnIdle")
		self.NISound = CurTime()+self.IdleSoundDelay
	end
end

function ENT:Wander()
	if self.IsControlled then return end
	if self:GetActivity() != ACT_IDLE then
		self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
	end
	if math.random(1,2) == 1 then
		local goal
		local fs = self:GetVisibleFriends()
		local f = fs[math.random(#fs)]
		if IsValid(f) then goal = Vector(f:GetPos().x,f:GetPos().y,(f:GetPos()+f:GetUp()*200).z) end
		self.FlyGoal = goal
		if goal then
			self:MoveToPos(goal)
			self.FlyGoal = nil
		end
	end
	self:SearchEnemy()
	coroutine.wait(1)
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
		self:GetATarget()
		if !found then
			if math.random(1,3) == 1 then
				if math.random(1,2) == 1 then
					self:Speak("OnTaunt")
				else
					self:Speak("OnVictory")
				end
			end
		end
	elseif rel == "friend" then
		--print(victim.IsElite,victim.IsLeader,victim.IsUltra)
		--print(victim.CovRank,self.CovRank)
		if !self.Scared then
			self.Scared = true
			self:ResetSequence("Run_Flee")
			self:Speak("OnFlee")
			timer.Simple( math.random(15,20), function()
				if IsValid(self) then
					self:ResetSequence("Idle_"..math.random(1,2).."")
					self.Scared = false
				end
			end )
		end
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

function ENT:GetVisibleFriends()
	local tbl = {}
	for ent, bool in pairs(self.RegisteredFriendlies) do
		if IsValid(ent) and ent:Health() > 0 then
			tbl[#tbl+1] = ent
		else
			self.RegisteredFriendlies[ent] = nil
		end
	end
	return tbl
end



function ENT:CustomBehaviour(ent)
	if !IsValid(ent) then return end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	local dist = self:GetRangeSquaredTo(ent:GetPos())
	self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
	if los then
		if IsValid(ent) then
			self.LastSeenEnemyPos = ent:GetPos()
		end
		local goal = Vector(self:GetPos().x,self:GetPos().y,self.FlyGoal.z)+self:GetForward()*math.random(512,-256)+self:GetRight()*math.random(512,-512)
		local fs = self:GetVisibleFriends()
		local f = fs[math.random(#fs)]
		if IsValid(f) then goal = Vector(f:GetPos().x,f:GetPos().y,(f:GetPos()+f:GetUp()*200).z) end
		self:MoveToPos(goal)
			--self.FlyGoal = self:GetPos()
		coroutine.wait(self.Del)
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

function ENT:RunToPosition( pos, anim, speed )
	if !util.IsInWorld( pos ) then return "Tried to move out of the world!" end
	self:StartActivity( anim )			-- Move animation
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self.loco:SetAcceleration( speed+speed )
	self:MoveToPos( pos )
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
end

local se = {
	[1] = "Step Right",
	[2] = "Step Left"
}

function ENT:StartChasing( ent, anim, speed, los, kam )
	self:StartActivity( anim )
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,los,kam)
end

function ENT:OnHaveEnemy(ent)
	self.FlyGoal = self:WorldSpaceCenter()+self:GetUp()*math.random(160,240)
	self.StartPoint = self:GetPos()
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
	self:Speak("OnDeathExplosion")
	self:StopParticles()
	ParticleEffect( "iv04_halo_reach_explosion_engineer", self:WorldSpaceCenter(), self:GetAngles() )
	if !self.LostProtection then
		local prop = ents.Create( "prop_physics" )
		prop:SetModel( "models/halo_reach/characters/covenant/engineer_helmet.mdl" )
		prop:SetPos(self:WorldSpaceCenter()+self:GetForward()*40)
		prop:SetAngles(Angle(0,self:GetAngles().y,0))
		prop:Spawn()
		self.HasHelmet = false
		if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
			timer.Simple( 60, function()
				if IsValid(prop) then
					prop:Remove()
				end
			end)
		end
	end
	local BOMB = ents.Create( "iv04_halo_reach_engineer_backpack_bomb" )
	BOMB:SetPos(self:WorldSpaceCenter())
	BOMB:SetAngles(Angle(0,self:GetAngles().y,0))
	BOMB:Spawn()
	BOMB:SetOwner(self)
	self:Remove()
	--self.DrownThread = coroutine.create( function() self:DoKilledAnim() end )
	--coroutine.resume( self.DrownThread )
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

list.Set( "NPC", "npc_iv04_hr_engineer", {
	Name = "Engineer",
	Class = "npc_iv04_hr_engineer",
	Category = "Halo Reach"
} )