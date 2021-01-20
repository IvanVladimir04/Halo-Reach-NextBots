AddCSLuaFile()
include("voices.lua")
ENT.Base 			= "npc_iv04_weaponuserbase"
ENT.PrintName = "Skirmisher"
ENT.StartHealth = 75
ENT.MoveSpeed = 145
ENT.MoveSpeedMultiplier = 2.3
ENT.BehaviourType = 3
ENT.BulletNumber = 1
ENT.IdleSoundDelay = math.random(6,10)
ENT.Models = {}
ENT.SightType = 2
 
ENT.HasArmor = false

ENT.MeleeDamage = 35

ENT.MeleeRange = 100

ENT.ChaseRange = 256

ENT.DodgeChance = 50
--[[ENT.CrouchingChance = 25
ENT.StepChance = 20]]
ENT.AttractAlliesRange = 1024

-- Flinching

ENT.FlinchChance = 30

ENT.FlinchDamage = 10

ENT.FlinchHitgroups = {
	[7] = ACT_FLINCH_HEAD,
	[2] = ACT_FLINCH_CHEST,
	[3] = ACT_FLINCH_LEFTARM,
	[4] = ACT_FLINCH_RIGHTARM,
	[5] = ACT_FLINCH_LEFTLEG,
	[6] = ACT_FLINCH_RIGHTLEG,
	[1] = ACT_FLINCH_STOMACH
}

--ENT.Footsteps = { "doom_3/zombie_pistol/step1.ogg", "doom_3/zombie_pistol/step2.ogg", "doom_3/zombie_pistol/step3.ogg", "doom_3/zombie_pistol/step4.ogg" }

ENT.NPSound = 0

ENT.NISound = 0

ENT.CanUse = true

ENT.SearchJustAsSpawned = false

ENT.CustomIdle = true

ENT.Shield = 0

ENT.Faction = "FACTION_COVENANT"

ENT.AIType = "Offensive"

ENT.ExtraSpread = 0

ENT.ShootDist = 1024

ENT.SightDistance = 2048

ENT.CanUse = true

ENT.GrenadeRange = 768

ENT.GrenadeChances = 0

ENT.MeleeDamage = 10

--ENT.StepEvent = "D3HumanNextbot.Step"

local seqs = {
	[1] = "evade_right",
	[2] = "evade_left"
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

ENT.IsElite = false

ENT.StartWeapons = {
	[1] = "astw2_haloreach_plasma_pistol",
	[2] = "astw2_haloreach_needler_rifle",
	[3] = "astw2_haloreach_needler"
}

function ENT:OnInitialize()
	self:Give(self.StartWeapons[math.random(#self.StartWeapons)])
	self:SetupHoldtypes()
	self:DoInit()
end

function ENT:DoInit()
	--print(marinevariant)
	self:SetCollisionBounds(Vector(-15,-15,0),Vector(15,15,80))
	if !IsValid(self.Weapon) then
		--self:Give(self.PossibleWeapons[math.random(1,#self.PossibleWeapons)])
	end
	local r = math.random(1,2)
	if r == 2 then r = 0 end
	self:SetBodygroup(0,r)
	self:SetBodygroup(1,r)
	self:SetBodygroup(2,r)
	self:SetBloodColor(DONT_BLEED)
	self.ShouldWander = false
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

function ENT:OnLeaveGround(ent)
	if self:Health() <= 0 then 
		self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne_"..math.random(1,2).."")))
	end
end

function ENT:OnLandOnGround(ent)
	if self.FlyingDead then
		self.HasLanded = true
	end
end

function ENT:Speak(voice)
	local character = self.Voices["Skirmisher"]
	if character[voice] and istable(character[voice]) then
		local sound = table.Random(character[voice])
		self:EmitSound(sound,100)
	end
end

function ENT:BeforeThink()
	local valid = IsValid(self.Enemy)
	if self.NISound < CurTime() and !valid then
		if istable(self.IdleSound) then
			local snd = table.Random(self.IdleSound)
			self:EmitSound(snd,100)
		end
		self.NISound = CurTime()+self.IdleSoundDelay
	elseif self.NISound < CurTime() and valid then
		if istable(self.IdleCombatSound) then
			local snd = table.Random(self.IdleCombatSound)
			self:EmitSound(snd,100)
		end
		self.NISound = CurTime()+self.IdleSoundDelay
	end
end

function ENT:Use( activator )
	if !self.CanUse then return end
	if self:CheckRelationships(activator) == "friend" and activator:IsPlayer() then
		local ply = activator
		if ply:KeyDown(IN_WALK) then
			self.IsFollowingPlayer = !self.IsFollowingPlayer
			if !IsValid(self.FollowingPlayer) then
				self.FollowingPlayer = ply
				self:SetNWInt("optredisp",1)
			else
				self.FollowingPlayer = nil
				self.StartPosition = self:GetPos()
				self:SetNWInt("optredisp",0)
			end
			self.CanUse = false
			timer.Simple( 1, function()
				if IsValid(self) then
					self.CanUse = true
				end
			end )
		elseif IsValid(ply:GetActiveWeapon()) and IsValid(self.Weapon) and self.Weapon:GetClass() != ply:GetActiveWeapon():GetClass() and self.TotalHolds[ply:GetActiveWeapon().HoldType_Aim] then
			self.CanUse = false
			local stop = false
			for i = 1, 200 do
				timer.Simple( 0.01*i, function()
					if stop then return end
					if IsValid(self) then
						if IsValid(ply) then
							if ( !ply:KeyDown(IN_USE) and self.Weapon:GetClass() != ply:GetActiveWeapon():GetClass() ) or !self.TotalHolds[ply:GetActiveWeapon().HoldType_Aim] then
								self.CanUse = true
								stop = true
							else
								if i == 200 then
									local gift = ply:GetActiveWeapon():GetClass()
									local ammo = self.Weapon:Clip1()+self.Weapon:GetMaxClip1()*math.random(1,4)
									local t = self.Weapon:GetPrimaryAmmoType()
									local give = self.Weapon:GetClass()
									ply:GetActiveWeapon():Remove()
									local wep = ply:Give(give,true)
									ply:GiveAmmo(ammo,t,true)
									ply:SelectWeapon(give)
									self.Weapon:Remove()
									self:Give(gift)
									self:SetupHoldtypes()
									self.CanUse = true
									--[[local clone = ents.Create(self:GetClass())
									clone:SetPos(self:GetPos())
									clone:SetAngles(self:GetAngles())
									clone:SetHealth(self:Health())
									clone.DoInit = function()
										clone:Give(gift)
										clone:SetSkin(self:GetSkin())
										for i = 1, table.Count( self:GetBodyGroups() ) do
											clone:SetBodygroup( i-1,self:GetBodygroup( i-1 ) )
											if i == table.Count( self:GetBodyGroups() ) then
												clone:SetBodygroup( i,self:GetBodygroup( i ) )
											end
										end
									end
									clone:Spawn()
									undo.ReplaceEntity(self,clone)
									self:Remove()]]
								end
							end
						else
							stop = true
							self.CanUse = true
						end
					end
				end )
			end
		end
	end
end

ENT.RifleHolds = {
	["crossbow"] = true,
	["ar2"] = true,
	["shotgun"] = true
}

ENT.PistolHolds = {
	["pistol"] = true,
	["revolver"] = true
}

ENT.TotalHolds = {
	["crossbow"] = true,
	["ar2"] = true,
	["shotgun"] = true,
	["pistol"] = true,
	["revolver"] = true,
}

ENT.WeaponBursts = {
	["astw2_haloreach_magnum"] = 4,
	["astw2_haloreach_needler"] = 3,
	["astw2_haloreach_plasma_rifle"] = 2,
	["astw2_haloreach_plasma_pistol"] = 2,
	["astw2_haloreach_plasma_repeater"] = 4
}

function ENT:SetupHoldtypes()
	local hold = self.Weapon.HoldType_Aim
	if !self.Weapon.NextPrimaryFire then self.Weapon.NextPrimaryFire = CurTime() end
	local relo = self.Weapon.AI_Reload
	self:SetNWEntity("wep",self.Weapon)
	self.Weapon.TrueScope = false
	self.Weapon.AI_Reload = function()
		relo(self.Weapon)
		self:DoAnimationEvent(1689)
	end
	-- self.WarthogDriverEnter = "Warthog_Driver_Enter"
	-- self.WarthogDriverExit = "Warthog_Driver_Exit"
	-- self.WarthogDriverIdle = "Warthog_Idle"
	-- self.WarthogPassengerEnter = "Warthog_Passenger_Enter"
	-- self.WarthogPassengerExit = "Warthog_Passenger_Exit"
	-- self.WarthogGunnerEnter = "Warthog_Gunner_Enter"
	-- self.WarthogGunnerExit = "Warthog_Gunner_Exit"
	-- self.WarthogGunnerIdle = "Ghost_Idle"
	if self.WeaponBursts[self.Weapon:GetClass()] then
		self.Weapon.BurstLength = self.WeaponBursts[self.Weapon:GetClass()]
	end
	if self.PistolHolds[hold] then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol"))}
		self.MeleeAnim = {"Attack_Plasma_Pistol"}
		self.MeleeBackAnim = "Attack_Plasma_Pistol"
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Plasma_Pistol"))
		self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Pistol_Reload"))
		self.CalmTurnLeftAnim = "Pistol_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Pistol_Turn_Right_Idle"
		self.TurnLeftAnim = "Pistol_Turn_Left_Idle"
		self.TurnRightAnim = "Pistol_Turn_Right_Idle"
		self.SurpriseAnim = "Warn"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol_Crouch"))}
		self.GrenadeAnim = "Attack_Needler"
		self.WarthogPassengerIdle = "Phantom_Passenger_Idle_1"
		self.AllowGrenade = false
		self.CanShootCrouch = true
		self.CanMelee = false
	elseif self.RifleHolds[hold] then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle_Slow"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle"))}
		self.MeleeAnim = {"Attack_Needler_Rifle"}
		self.MeleeBackAnim = "Attack_Needler_Rifle"
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Needler_Rifle"))	
		if hold == "shotgun" then
			self.Weapon.Acc = 0
			self.Weapon.Primary.RecoilAcc = 0
			self.WeaponAccuracy = 9
			self.Weapon.BurstLength = 1
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Pistol_Reload"))
		else
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Pistol_Reload"))
		end
		self.CalmTurnLeftAnim = "Rifle_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Rifle_Turn_Right_Idle"
		self.TurnLeftAnim = "Rifle_Turn_Left_Idle"
		self.TurnRightAnim = "Rifle_Turn_Right_Idle"
		self.SurpriseAnim = "Surprised"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle_Slow"))}
		self.GrenadeAnim = "Pistol_Reload"
		self.WarthogPassengerIdle = "Sit_Rifle"
		self.AllowGrenade = false
		self.CanShootCrouch = true
		self.CanMelee = false
	end
end

local thingstoavoid = {
	["prop_physics"] = true,
	["prop_ragdoll"] = true
}

function ENT:OnContact( ent ) -- When we touch someBODY
	if ent == game.GetWorld() then return "no" end
	if (ent.IsVJBaseSNPC == true or ent.CPTBase_NPC == true or ent.IsSLVBaseNPC == true or ent:GetNWBool( "bZelusSNPC" ) == true) or (ent:IsNPC() && ent:GetClass() != "npc_bullseye" && ent:Health() > 0 ) or (ent:IsPlayer() and ent:Alive()) or ((ent:IsNextBot()) and ent != self ) then
		local d = self:GetPos()-ent:GetPos()
		self.loco:SetVelocity(d*1)
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

function ENT:GetInfoNum(no,yes)
    return 1
end

function ENT:NearbyReply( quote, dist, tim )
	tim = tim or math.random(2,4)
	dist = dist or 500
	for k, v in pairs(ents.FindInSphere(self:GetPos(),dist)) do
		if v != self and self:CheckRelationships(v) == "friend" and v.Speak then
			timer.Simple( tim, function()
				if IsValid(v) then
					v:Speak(quote)
				end
			end )
			break
		end
	end
end

local dmgtypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true
}

function ENT:OnInjured(dmg)
	--print("no")
	local rel = self:CheckRelationships(dmg:GetAttacker())
	local ht = self:Health()
	if rel == "friend" and self.BeenInjured then dmg:ScaleDamage(0) return end
	if self.HasArmor then
		ht = ht + self.Shield
	end
	if self.Shield > 0 then
		self:SetBodygroup(4,1)
		self.LShieldHurt = CurTime()
		local h = self.LShieldHurt
		timer.Simple( 1, function()
			if IsValid(self) and h == self.LShieldHurt then
				self:SetBodygroup(4,0)
			end
		end )
	else
			ParticleEffect( "blood_impact_elite", dmg:GetDamagePosition(), Angle(0,0,0), self )
	end
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
		if self.Shield < 0 then self.Shield = 0 end
		local shild = self.Shield
		timer.Simple( 3, function()
			if IsValid(self) and shield == self.ShieldH then
				local stop = false
				for i = 1, 10 do
					timer.Simple( 0.35*i, function()
						if IsValid(self) and shield == self.ShieldH and !stop then
							self.Shield = self.Shield+7.9
							if self.Shield > 79 then self.Shield = 79
								stop = true
							end
						end
					end )
				end
			end
		end )
	end
	if (ht) - math.abs(dmg:GetDamage()) < 1 then return end
	local total = dmg:GetDamage()
	--print(self.Shield, "before")
	self.HealthActual = self:Health()
	self.HealthH = CurTime()
	local htt = CurTime()
	local htl = self:Health()
	local dm = dmg:GetDamage()
	local ht = self:Health()-math.abs(dm)
	--print(self.Shield, "now")
	timer.Simple( 6, function()
		if IsValid(self) and htt == self.HealthH then
			--print("Starting regeneration")
			for i = 1, 10 do
				timer.Simple( 2*i, function()
					if IsValid(self) and htl == self.HealthActual then
						--print("Regenerating", (self.HealthActual-ht)/10)
						self:SetHealth(self:Health()+((self.HealthActual-ht)/10))
					end
				end )
			end
		end
	end )
	--[[if self.HasArmor and dmgtypes[dmg:GetDamageType()] then
		local snd = table.Random(self.ArmorSounds)
		self:EmitSound(snd,100)
	end]]
	--[[if !self.DoingFlinch and self.loco:GetVelocity():IsZero() then
		if math.random(1,2) == 1 then
			self.DoingFlinch = true
			local id, dur = self:LookupSequence("flinch_back_chest")
			timer.Simple(dur, function()
				if IsValid(self) then
					self.DoingFlinch = false
				end
			end )
			local dir = (dmg:GetDamagePosition()-self:NearestPoint(dmg:GetDamagePosition())):Angle()
			local func = function()
				self:SetAngles(Angle(self:GetAngles().p,dir.y,self:GetAngles().r))
				self:PlaySequenceAndWait(id)
				self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
			end
			table.insert(self.StuffToRunInCoroutine,func)
			self:ResetAI()
		end
	end]]
	--[[if self:Health() - math.abs(total) < (self.StartHealth*0.5) and !self.Reacted then
		self.Reacted = true
		if math.random(1,2) == 1 then
			self:Speak("Berserk")
			self.Berserk = true
			local func = function()
				self:PlaySequenceAndWait("berserk_pistol")
			end
			table.insert(self.StuffToRunInCoroutine,func)
		end
	end
	if rel == "friend" and dmg:GetAttacker():IsPlayer() then
		if self.NPSound < CurTime() then
			self:Speak("HurtFriendPlayer")
			self.NPSound = CurTime()+math.random(1,4)
			return
		end
	elseif rel == "friend" then
		if self.NPSound < CurTime() then
			self.BeenInjured = true
			self:Speak("HurtFriend")
			self.NPSound = CurTime()+math.random(1,4)
			timer.Simple( self.NPSound-CurTime(), function()
				if IsValid(self) then
					self.BeenInjured = false
				end
			end )
			local at = dmg:GetAttacker()
			if at.IsElite then
				timer.Simple( math.random(1,2), function()
					if IsValid(at) then
						if math.random(1,2) == 1 then
							at:Speak("HurtFriendResponse")
						else
							at:Speak("DamagedAlly")
						end
					end
				end )
			end
			return
		end
	end]]
	if !IsValid(self.Enemy) then
		if self:CheckRelationships(dmg:GetAttacker()) == "foe" then
			--self:Speak("Surprise")
			self:SetEnemy(dmg:GetAttacker())
		end
	else
		--[[if self.NPSound < CurTime() then
			if dmg:GetDamage() > 10 then
				self:Speak("PainMajor")
			else
				self:Speak("PainMinor")
			end
			self.NPSound = CurTime()+math.random(2,5)
		end]]
	end
end

ENT.Variations = {
	[ACT_FLINCH_CHEST] = {["Back"] = "flinch_back_chest", ["Front"] = "flinch_front_chest"},
	[ACT_FLINCH_STOMACH] = {["Back"] = "flinch_back_gut", ["Front"] = "flinch_front_gut"}
}

function ENT:OnTraceAttack( info, dir, trace )
	--print(trace.HitGroup)
	if trace.HitGroup == 1 and self.Shield < 1 then
		info:ScaleDamage(3)
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	-- if self.Shield > 0 then
		-- ParticleEffect( "impact_shield_elite", info:GetDamagePosition(), Angle(0,0,0), self )
	-- end
	if !self.DoingFlinch and info:GetDamage() > self.FlinchDamage then	--Comment out if needed
		if self.FlinchHitgroups[trace.HitGroup] then
			local act
			if self.Variations[self.FlinchHitgroups[trace.HitGroup]] then
				act = self.FlinchHitgroups[trace.HitBox]
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
				self:PlaySequenceAndWait(id)
				self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
			end
			table.insert(self.StuffToRunInCoroutine,func)
			self:ResetAI()
		end
	end
end

function ENT:LocalAllies()
	local allies = {}
	for k, v in pairs(ents.FindInSphere(self:GetPos(),500)) do
		if v:IsNextBot() and self:CheckRelationships(v) == "friend" then
			allies[#allies+1] = v
		end
	end
	return allies
end

function ENT:DoCustomIdle()
	if self.IsFollowingPlayer then
		local dist = self:GetRangeSquaredTo(self.FollowingPlayer)
		if dist > 300^2 then
			self:WanderToPosition( (self.FollowingPlayer:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300), self.RunCalmAnim[math.random(1,#self.RunCalmAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		end
	elseif self.AIType == "Defensive" then
		local dist = self:GetRangeSquaredTo(self.StartPosition)
		if dist > 300^2 then
			self:WanderToPosition( (self.StartPosition + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300), self.RunCalmAnim[math.random(1,#self.RunCalmAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
		end
	end
	if math.random(1,4) == 1 then
		if math.random(1,2) == 1 then
			self:TurnTo(math.random(45,140),true)
		else
			self:TurnTo(math.random(-45,-140),true)
		end
	end
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

ENT.NoticedKills = 0

ENT.CountedEnemies = 0

ENT.MentionedSpree = false

ENT.CountedAllies = 0

ENT.MentionedAllySpree = false

function ENT:OnOtherKilled( victim, info )
	if victim == self then return end
	if self:Health() < 1 then return end
	local rel = self:CheckRelationships(victim)
	if rel == "friend" then
		if !victim.BeenNoticed then
			victim.BeenNoticed = true
			if self.SawAllyDie and !self.SawAlliesDie then self.SawAlliesDie = true end
			if !self.SawAllyDie then self.SawAllyDie = true end
			local attacker = info:GetAttacker()
			if attacker:IsPlayer() and self.FriendlyToPlayers then
				self.NoticedKills = self.NoticedKills+1
				if self.NoticedKills > 1 then
					self:Speak("AllianceBroken")
					self.FriendlyToPlayers = false
					self.LastAllyKill = CurTime()
					local last = self.LastAllyKill
					timer.Simple( 30, function()
						if IsValid(self) then
							if self.LastAllyKill == last then
								self.FriendlyToPlayers = true
								self.NoticedKills = 0
								self:SetEnemy(nil)
								self:Speak("AllianceReformed")
							end
						end
					end )
					for k, v in pairs(self:LocalAllies()) do
						v.FriendlyToPlayers = false
						v.LastAllyKill = CurTime()
						local las = v.LastAllyKill
						timer.Simple( 30, function()
							if IsValid(v) then
								if v.LastAllyKill == las then
									v.FriendlyToPlayers = true
									v.NoticedKills = 0
									v:SetEnemy(nil)
									v:Speak("AllianceReformed")
								end
							end
						end )
					end
				else
					self:Speak("FriendKilledByPlayer")
				end
				
			elseif attacker:IsPlayer() and !self.FriendlyToPlayers then
				self:Speak("FriendKilledByEnemyPlayer")
				self.LastAllyKill = CurTime()
				local last = self.LastAllyKill
				timer.Simple( 30, function()
					if IsValid(self) then
						if self.LastAllyKill == last then
							self.NoticedKills = 0
							self.FriendlyToPlayers = true
							self:SetEnemy(nil)
							self:Speak("AllianceReformed")
						end
					end
				end )
			elseif attacker.Faction == "FACTION_COVENANT" then
				self:Speak("FriendKilledByCovenant")
				
			elseif ( attacker:IsNPC() and attacker.IsVJBaseSNPC and string.StartWith(attacker:GetClass(), "npc_vj_flood") ) or victim.HasBeenLatchedOn then
				-- Killed by flood
				self:Speak("FriendKilledByFlood")
				
			elseif self:CheckRelationships(attacker) == "friend" then
				self:Speak("FriendKilledByFriend")
				
			elseif victim:IsPlayer() then
				if info:GetAttacker() == self then
					self:Speak("KilledFriendPlayer")
					self:NearbyReply("KilledFriendPlayerAlly")
				else
					self:Speak("FriendPlayerDie")
				end
				
			else
				if info:GetAttacker() == self then
					self:Speak("KilledFriend")
					self:NearbyReply("KilledFriendAlly")
				else
					if self.SawAlliesDie then
						self:Speak("NearMassacre")
					else
						self:Speak("FriendKilledByEnemy")
					end
				end
				
			end
		end
	elseif rel == "foe" and victim == self.Enemy then
		local spoke = false
		self.CountedEnemies = self.CountedEnemies+1
		if self.CountedEnemies > 4 and !self.MentionedSpree then
			self.MentionedSpree = true
			timer.Simple( 30, function()
				if IsValid(self) then
					self.MentionedSpree = false
				end
			end )
			self:Speak("KillingSpree")
		end
		timer.Simple( 30, function()
			if IsValid(self) then
				self.CountedEnemies = self.CountedEnemies-1
			end
		end )
		if victim:IsPlayer() then
			self:Speak("KilledEnemyPlayer")
			spoke = true
			for id, v in ipairs(self:LocalAllies()) do
				if !v.SpokeAllyKill then
					v.SpokeAllyKill = true
					v:Speak("KilledEnemyPlayerAlly")
					timer.Simple( math.random(2,4), function()
						if IsValid(v) then
							v.SpokeAllyKill = false
						end
					end )
					break
				end
			end
		elseif ( victim:IsNPC() and victim.IsVJBaseSNPC and string.StartWith(victim:GetClass(), "npc_vj_flood") ) then	
			if victim.HasDeathRagdoll then
				self:Speak("KilledFloodCombat")
				spoke = true
				for id, v in ipairs(self:LocalAllies()) do
					if !v.SpokeAllyKill then
						v.SpokeAllyKill = true
						v:Speak("KilledFloodCombatAlly")
						timer.Simple( math.random(2,4), function()
							if IsValid(v) then
								v.SpokeAllyKill = false
							end
						end )
						break
					end
				end
			else
				self:Speak("KilledEnemyFloodCarrier")
				spoke = true
				for id, v in ipairs(self:LocalAllies()) do
					if !v.SpokeAllyKill then
						v.SpokeAllyKill = true
						v:Speak("KilledEnemyFloodCarrierAlly")
						timer.Simple( math.random(2,4), function()
							if IsValid(v) then
								v.SpokeAllyKill = false
							end
						end )
						break
					end
				end
			end
			
		elseif victim.timeDeath then -- Sentinel
			--print("die robot")
			self:Speak("KilledEnemySentinel")
			spoke = true
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
					self:WanderToPosition( self.LastSeenEnemyPos, self.RunAnim[1], self.MoveSpeed )
					self:Speak("Taunt")
				end
				table.insert(self.StuffToRunInCoroutine,func)
			end
		elseif !spoke then
			if info:GetDamageType() == DMG_BLAST then
				self:Speak("KilledEnemyGrenade")
			elseif IsValid(info:GetInflictor()) and self:CheckRelationships(info:GetInflictor():GetOwner()) == "friend" then
				self:Speak("KilledEnemyGrenade")
				self:NearbyReply("AllyKillGrenade")
			else
				self:Speak("KilledEnemyBullet")
			end
		end
	end
end

function ENT:ThrowGrenade(ent)
	ent = ent or self.Enemy
	if !IsValid(ent) then return end
	local pos = ent:GetPos()
	self:Speak("GrenadeThrowing")
	timer.Simple( 0.3, function()
		if IsValid(self) and !self.DoingFlinch then
			ent = ent or self.Enemy
			local gre = ents.Create("astw2_halo_cea_plasma_grenade_thrown")
			gre:SetPos(self:WorldSpaceCenter()+self:GetRight()*-40)
			gre:SetAngles(self:GetAngles())
			gre:SetOwner(self)
			gre:Spawn()
			gre:Activate()
			local p = gre:GetPhysicsObject()
			if IsValid(p) then
				p:Wake()
				p:SetVelocity( (self:GetAimVector() * 500)+(self:GetUp()*(math.random(10,50)*5)) )
			end
		end
	end )
	self.ThrowedGrenade = true
	timer.Simple( math.random(10,15), function()
		if IsValid(self) then
			self.ThrowedGrenade = false
		end
	end )
	self:Speak("ThrowGrenade")
	self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
	self:DoGesture(self.GrenadeAnim)
	coroutine.wait(0.5)
end

function ENT:HasToReload()
	return self.Weapon:Clip1() == 0
end

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
			v:EmitSound( self.OnMeleeSoundTbl[math.random(1,#self.OnMeleeSoundTbl)] )
			if v:IsPlayer() then
				v:ViewPunch( self.ViewPunchPlayers )
			end
			if IsValid(v:GetPhysicsObject()) then
				v:GetPhysicsObject():ApplyForceCenter( v:GetPhysicsObject():GetPos() +((v:GetPhysicsObject():GetPos()-self:GetPos()):GetNormalized())*self.MeleeForce )
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

function ENT:CustomBehaviour(ent,range)
	ent = ent or self.Enemy
	if !IsValid(ent) then self:GetATarget() end
	if !IsValid(self.Enemy) then return else ent = self.Enemy end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	if IsValid(obstr) then	
		if self:CheckRelationships(obstr) == "foe" then
			ent = obstr
			self:SetEnemy(ent)
		end
	end
	if los and !self.DoneMelee and range < self.MeleeRange^2 then
		self:DoMelee()
	elseif los and !self.DoneMelee and range < self.ChaseRange^2 then
		self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true)
	end
	if range > self.ShootDist^2 then
		self.StopShoot = true
	else
		self.StopShoot = false
	end
	if self.AllowGrenade and range < self.GrenadeRange^2 and range > (self.MeleeRange*2)^2 then
		self.CanThrowGrenade = true
	else
		self.CanThrowGrenade = false
	end
	if !IsValid(ent) then return end
	local reloaded = false
	if self.AIType == "Static" then
	
		if self:HasToReload() then
			self.Weapon:AI_PrimaryAttack()
			reloaded = true
			return
		end
		local should, dif = self:ShouldFace(ent)
		if should then
			if !reloaded then
				self:Shoot()
			end
			self:TurnTo(dif)
			coroutine.wait(0.2)
			return
		end
		if !IsValid(ent) then return end
		if los then
			if self.CanThrowGrenade and !self.ThrowedGrenade and math.random(1,100) <= self.GrenadeChances then
				return self:ThrowGrenade()
			else
				if self.CanShootCrouch and math.random(1,2) == 1 then
					self:StartActivity(self.CrouchIdleAnim[math.random(#self.CrouchIdleAnim)])
				else
					self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
				end
				self:Shoot()
			end
		else
			self:SetEnemy(nil)
		end
		coroutine.wait(math.random(2,3))
		
	elseif self.AIType == "Defensive" then
	
		if self:HasToReload() then
			reloaded = true
			local r = math.random(3,4)
			local tbl,dire = self:FindCoverSpots(ent,r)
			if table.Count(tbl) > 0 or #tbl > 0 then
				local area = table.Random(tbl)
				self:MoveToPosition( area:GetRandomPoint(), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
				self.Weapon:AI_PrimaryAttack()
			else
				local dir = dire+self:GetRight()*1
				timer.Simple( r*0.25, function()
					if IsValid(self) then
						dir = dire
					end
				end )
				for i = 1, r*100 do
					
					timer.Simple( 0.01*i, function()
						if IsValid(self) and self:Health() > 0 and !self.DoneFlinch and !self.Taunting then
							self.loco:Approach(self:GetPos()+dir,1)
							self.loco:FaceTowards(self:GetPos()+dir)
						end
					end )
					
				end
				self:StartMovingAnimations( self.RunAnim[math.random(#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
				coroutine.wait(r)
				self.Weapon:AI_PrimaryAttack()
			end
			return
		elseif self.NeedsToCover then
			self.NeedsToCover = false
			local tbl = self:FindCoverSpots(ent)
			if table.Count(tbl) > 0 or #tbl > 0 then
				local area = table.Random(tbl)
				self:MoveToPosition( area:GetRandomPoint(), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
				return
			end
		end
		local should, dif = self:ShouldFace(ent)
		if should then
			if !reloaded then
				self:Shoot()
			end
			self:TurnTo(dif)
			coroutine.wait(0.2)
			return
		end
		if !IsValid(ent) then return end
		local wait = math.random(2,3)
		if los then
			if math.random(1,3) == 1 then
				local anim
				local speed
				local mul
				local r2 = math.random(1,2)
				if r2 == 2 then r2 = -1 end
				local dir
				local dire
				if math.random(1,2) == 1 then
					dir = (self:GetRight()*r2)
					dire = self:GetForward()*1
				else
					dir = (self:GetForward()*1)
					dire = (self:GetRight()*r2)
				end
				timer.Simple( wait*0.7, function()
					if IsValid(self) then
						dir = dire
					end
				end )
				local ra = math.random(1,3)
				if ra == 1 then
					anim = self.CrouchMoveAnim
					speed = self.MoveSpeed
					mul = 1
				elseif ra == 2 then
					anim = self.WalkAnim
					speed = self.MoveSpeed
					mul = 1
				else
					anim = self.RunAnim
					speed = self.MoveSpeed
					mul = self.MoveSpeedMultiplier
				end
				self:StartMovingAnimations( anim[math.random(#anim)], speed*mul )
				for i = 1, wait*100 do
				
					timer.Simple( 0.01*i, function()
						if IsValid(self) and self:Health() > 0 and !self.DoneFlinch and !self.Taunting then
							if IsValid(self.Enemy) then
								self.loco:Approach(self:GetPos()+dir,1)
							else
								self:StartActivity( self.IdleAnim[math.random(#self.IdleAnim)] )
							end
						end
					end )
				
				end
			else
				if self.CanThrowGrenade and !self.ThrowedGrenade and math.random(1,100) <= self.GrenadeChances then
					return self:ThrowGrenade()
				else
					if self.CanShootCrouch and math.random(1,2) == 1 then
						self:StartActivity(self.CrouchIdleAnim[math.random(#self.CrouchIdleAnim)])
					else
						self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
					end
				end
			end
			self:Shoot()
		else
			if math.random(1,2) == 1 then
				self:StartMovingAnimations( self.RunAnim[math.random(#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
				local r = math.random(1,2)
				if r == 2 then r = -1 end
				for i = 1, 100 do
				
					timer.Simple( 0.01*i, function()
						if IsValid(self) and self:Health() > 0 and !self.DoneFlinch and !self.Taunting then
							self.loco:Approach(self:GetPos()+self:GetRight()*r,1)
						end
					end )
				
				end
			else
				self:SetEnemy(nil)
			end
		end
		coroutine.wait(wait)
		
	elseif self.AIType == "Offensive" then
	
		if self:HasToReload() then
			reloaded = true
			self.Weapon:AI_PrimaryAttack()
			return
		elseif self.NeedsToCover then
			local r = math.random(3,4)
			self.NeedsToCover = false
			local dir = self:GetForward()*-1
			timer.Simple( r*0.25, function()
				if IsValid(self) then
					dir = dir+self:GetRight()*math.random(1,-1)
				end
			end )
			for i = 1, r*100 do
					
				timer.Simple( 0.01*i, function()
					if IsValid(self) and self:Health() > 0 and !self.DoneFlinch and !self.Taunting then
						self.loco:Approach(self:GetPos()+dir,1)
						if IsValid(self.Enemy) then
							self.loco:FaceTowards(self.Enemy:GetPos())
						else
							self.loco:FaceTowards(self:GetPos()+dir)
						end
					end
				end )
				
			end
			self:StartMovingAnimations( self.RunAnim[math.random(#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
			self.Weapon:AI_PrimaryAttack()
			coroutine.wait(r)
		end
		
		if los then
		
			local should, dif = self:ShouldFace(ent)
			if should then
				if !reloaded then
					self:Shoot()
				end
				self:TurnTo(dif)
				coroutine.wait(0.2)
				return
			end
			if self.StopShoot then
				self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true)
			end
			if !IsValid(ent) then return end
	
			local wait = math.random(2,3)
			if math.random(1,3) != 1 then
				local anim
				local speed
				local mul
				local r2 = math.random(1,2)
				if r2 == 2 then r2 = -1 end
				local dir
				local dire
				local ra = math.random(1,3)
				if ra == 1 then
					dir = (self:GetRight()*r2)
					dire = self:GetForward()*1
				elseif ra == 2 then
					dir = (self:GetForward()*1)
					dire = (self:GetRight()*r2)
				else
					dir = (self:GetForward()*-1)
					dire = (self:GetRight()*r2)
				end
				local switch = math.Rand(0.3,0.7)
				timer.Simple( wait*switch, function()
					if IsValid(self) then
						dir = dire
					end
				end )
				local re = math.random(1,5)
				if re == 1 then
					anim = self.CrouchMoveAnim
					speed = self.MoveSpeed
					mul = 1
				elseif re == 2 then
					anim = self.WalkAnim
					speed = self.MoveSpeed
					mul = 1
				else
					anim = self.RunAnim
					speed = self.MoveSpeed
					mul = self.MoveSpeedMultiplier
				end
				self:StartMovingAnimations( anim[math.random(#anim)], speed*mul )
				local idled = false
				for i = 1, wait*100 do
				
					timer.Simple( 0.01*i, function()
						if IsValid(self) and self:Health() > 0 and !self.DoneFlinch and !self.Taunting then
							if IsValid(self.Enemy) then
								self.loco:Approach(self:GetPos()+dir,1)
							else
								if !idled then
									idled = true
									self:StartActivity( self.IdleAnim[math.random(#self.IdleAnim)] )
								end
							end
						end
					end )
				
				end
			else
				if self.CanThrowGrenade and !self.ThrowedGrenade and math.random(1,100) <= self.GrenadeChances then
					return self:ThrowGrenade()
				else
					if self.CanShootCrouch and math.random(1,2) == 1 then
						self:StartActivity(self.CrouchIdleAnim[math.random(#self.CrouchIdleAnim)])
					else
						self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
					end
				end
			end
			
			self:Shoot()
			
			coroutine.wait(wait)
		
		else
		
			self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,false)
		
		end
		
	end
end

function ENT:DoMelee()
	local anim = self.MeleeAnim[math.random(#self.MeleeAnim)]
	local turn = false
	if IsValid(self.Enemy) then
		local ang = (self.Enemy:GetPos()-self:GetPos()):GetNormalized():Angle()
		local ydif = math.AngleDifference(self:GetAngles().y,ang.y)
		if math.abs(ydif) > 180 then
			anim = self.MeleeBackAnim
			turn = true
		else
			self:SetAngles(Angle(0,ang.y,0))
		end
	end	
	self.DoneMelee = true
	self.DoingMelee = true
	timer.Simple( math.random(5,10), function()
		if IsValid(self) then
			self.DoneMelee = false
		end
	end )
	local id, len = self:LookupSequence(anim)
	timer.Simple( len*0.4, function()
		if IsValid(self) then
			self:DoMeleeDamage()
		end
	end )
	timer.Simple( len*1.2, function()
		if IsValid(self) then
			self.DoingMelee = false
			if turn then
				self:SetAngles(self:GetAngles()+Angle(0,180,0))
			end
		end
	end )
	self:PlaySequenceAndPWait(id,1,self:GetPos())
end

function ENT:RunToPosition( pos, anim, speed )
	if !util.IsInWorld( pos ) then return "Tried to move out of the world!" end
	self:StartActivity( anim )			-- Move animation
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self.loco:SetAcceleration( speed+speed )
	self:MoveToPos( pos )
end	

function ENT:Shoot()
	if !IsValid(self.Weapon) then return end
	if self.StopShoot then return end
	self.Weapon:AI_PrimaryAttack()
end

function ENT:OnFiring()
	self:DoGesture(self.ShootAnim)
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

function ENT:StartChasing( ent, anim, speed, sword )
	self:StartActivity( anim )
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,sword)
end

ENT.NextUpdateT = CurTime()

ENT.UpdateDelay = 0.5

function ENT:ChaseEnt(ent,sword)
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
			self.NextUpdateT = CurTime()+0.4
			local cansee = self:CanSee( ent:GetPos() + ent:OBBCenter(), ent )
			saw = cansee
			local dist = self:GetPos():DistToSqr(ent:GetPos())
			if dist < self.MeleeRange^2 then
				return --self:DoMelee()
			elseif !sword and dist > 250^2 then
				return "Got far"
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
	self.LastSeenEnemyPos = ent:GetPos()
	if new then
		--self:Speak("Alert")
	else
		if self.LastTarget == ent then
			--self:Speak("OldEnemySighted")
		else
			--self:Speak("SightedNewEnemy")
		end
	end
	self:AlertAllies(ent)
	--[[if math.random(1,2) == 1 and new then
		local func = function()
			self:PlaySequenceAndWait(self.AlertSeq)
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	end]]
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
				if v.Speak then
					v:Speak("Surprise")
				end
				if v.OnHaveEnemy then
					v:OnHaveEnemy(ent)
				end
				timer.Simple( math.random(2,4), function()
					if IsValid(v) and IsValid(ent) then
						v:Speak("AlertAllyResponse")
					end
				end )
			else
				v.LastSeenEnemyPos = ent:GetPos()
			end
			--print("Alerted"..v:GetClass().."whose's index is"..v:EntIndex().."and its target is"..ent:GetClass().."")
		end
	end
end

ENT.DeathHitGroups = {
	[7] = "Head",
	[1] = "Guts"
}

ENT.RandDeath = {
	[1] = 2,
	[2] = 3,
	[3] = 5
}

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
			anim = "Death4"
		else
			if ( y <= 45 or y >= 315 ) then
				anim = "Death1"
			elseif ( y > 45 and y <= 135 ) then -- left
				anim = "Death6"
			elseif ( y < 225 and y > 135 ) then -- front
				anim = self.RandDeath[math.random(#self.RandDeath)]
			elseif y >= 225 then -- right
				anim = "Death7"
			end
		end
	else
		anim = self.RandDeath[math.random(#self.RandDeath)]
	end
	local dm = info:GetDamageType()
	if dm == DMG_BLAST or ( info:GetDamage() > 45 and dmgtypes[dm] ) then
		anim = "Dead_Airborne_"..math.random(1,2)..""
	end
	return anim
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.KilledDmgInfo = dmginfo
	self.BehaveThread = nil
	self:SetSkin(1)
	self.DrownThread = coroutine.create( function() self:DoKilledAnim() end )
	coroutine.resume( self.DrownThread )
end

function ENT:DoKilledAnim()
	if self.KilledDmgInfo:GetDamageType() != DMG_BLAST then
		if self.KilledDmgInfo:GetDamage() <= 150 then
			local anim = self:DetermineDeathAnim(self.KilledDmgInfo)
			if anim == true then 
				local wep = ents.Create(self.Weapon:GetClass())
				wep:SetPos(self.Weapon:GetPos())
				wep:SetAngles(self.Weapon:GetAngles())
				wep:Spawn()
				self.Weapon:Remove()
				local rag = self:BecomeRagdoll(DamageInfo())
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
					local rag
					if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
						timer.Simple( 60, function()
							if IsValid(wep) then
								wep:Remove()
							end
							if IsValid(rag) then
								rag:Remove()
							end
						end)
					end
					rag = self:BecomeRagdoll(DamageInfo())
				end
			end )
			self:PlaySequenceAndPWait(seq, 1, self:GetPos())
		else
			local wep = ents.Create(self.Weapon:GetClass())
			wep:SetPos(self.Weapon:GetPos())
			wep:SetAngles(self.Weapon:GetAngles())
			wep:Spawn()
			self.Weapon:Remove()
			local rag
			if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
				timer.Simple( 60, function()
					if IsValid(wep) then
						wep:Remove()
					end
					if IsValid(rag) then
						rag:Remove()
					end
				end)
			end
			rag = self:BecomeRagdoll(DamageInfo())
		end
	else
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
		local rag
		if GetConVar( "ai_serverragdolls" ):GetInt() == 0 then
			timer.Simple( 60, function()
				if IsValid(wep) then
					wep:Remove()
				end
				if IsValid(rag) then
					rag:Remove()
				end
			end)
		end
		rag = self:BecomeRagdoll(DamageInfo())
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
		if !CLIENT then
			--local set = self.AnimSets[self.Weapon:GetClass()] or self.AnimSets["Rifle"]
			local a,len = self:LookupSequence(self:SelectWeightedSequence(self.ReloadAnim))
			self:DoGesture(self.ReloadAnim)
			local func = function()
				self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
				coroutine.wait(len)
				self:SetAmmo(wep:GetMaxClip1())
				wep:SetClip1(wep:GetMaxClip1())
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
	[ACT_RUN_RIFLE] = true,
	[ACT_RUN_AGITATED] = true,
	[ACT_RUN_CROUCH_RIFLE] = true,
	[ACT_RUN_PISTOL] = true,
	[ACT_RUN] = true,
	[ACT_RUN_ON_FIRE] = true,
	[ACT_RUN_AGITATED] = true
}

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if !self.loco:GetVelocity():IsZero() then
		local goal = self:GetPos()+self.loco:GetVelocity()
		local y = (goal-self:GetPos()):Angle().y
		local di = math.AngleDifference(self:GetAngles().y,y)
		self:SetPoseParameter("move_yaw",di)
		self:SetPoseParameter("walk_yaw",di)
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
	if !self.DoingFlinch and self:Health() > 0 and !self.DoingMelee and !self.Taunting then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
end

-- list.Set( "NPC", "npc_iv04_hce_elite_minor", {
	-- Name = "Skir Minor",
	-- Class = "npc_iv04_hce_elite_minor",
	-- Category = "Halo Combat Evolved"
-- } )