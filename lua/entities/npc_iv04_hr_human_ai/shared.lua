AddCSLuaFile()
include("voices.lua")

ENT.Base 			= "npc_iv04_weaponuserbase"

ENT.MoveSpeed = 100

ENT.MoveSpeedMultiplier = 1.5

ENT.BehaviourType = 3

ENT.CustomIdle = true

ENT.SightType = 2

ENT.Faction = "FACTION_UNSC"

ENT.AIType = "Defensive"

ENT.ExtraSpread = 0

ENT.ShootDist = 1024

ENT.CanUse = true

ENT.GrenadeRange = 768

ENT.GrenadeChances = 30

ENT.MeleeDamage = 0

ENT.MeleeRange = 70

ENT.FlinchChance = 30

ENT.FlinchDamage = 10

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

ENT.FlinchMove = {
	[1] = 50,
	[3] = 50,
	[4] = 50,
	[5] = 50,
	[6] = 0,
	[7] = 0
}

ENT.UsableWeps = {
	["astw2_haloreach_assault_rifle"] = true,
	["astw2_haloreach_dmr"] = true,
	["astw2_haloreach_shotgun"] = true,
	["astw2_haloreach_magnum"] = true,
	["astw2_haloreach_rocket_launcher"] = true,
	["astw2_haloreach_sniper_rifle"] = true,
	["astw2_haloreach_spartan_laser"] = false
}

function ENT:Give(class)
	local wep = ents.Create(class)
	local attach = self:GetAttachment(1)
	local pos = attach.Pos
	local offpos = self.WepOffsets[class].pos
	local offang = self.WepOffsets[class].ang
	local off = self:GetForward()*offpos.x+self:GetRight()*offpos.y+self:GetUp()*offpos.z
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
	self:DoInit()
	self:SetupHoldtypes()
end

function ENT:DoInit()

end

function ENT:GetCurrentWeaponProficiency()
	return self.WeaponAccuracy or 1
end

function ENT:Use( activator )
	if !self.CanUse then return end
	if self:CheckRelationships(activator) == "friend" and activator:IsPlayer() then
		local ply = activator
		if ply:KeyDown(IN_WALK) then
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
		elseif self.UsableWeps[activator:GetActiveWeapon():GetClass()] and self.Weapon:GetClass() != activator:GetActiveWeapon():GetClass() then
			self.CanUse = false
			local stop = false
			for i = 1, 200 do
				timer.Simple( 0.01*i, function()
					if stop then return end
					if IsValid(self) then
						if IsValid(ply) then
							if !ply:KeyDown(IN_USE) or !self.UsableWeps[activator:GetActiveWeapon():GetClass()] and self.Weapon:GetClass() != activator:GetActiveWeapon():GetClass() then
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
									local clone = ents.Create(self:GetClass())
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
									self:Remove()
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
	if hold == "pistol" then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle_Low"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol_Holstered"))}
		self.MeleeAnim = {"Melee_Pistol_1","Melee_Pistol_2"}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Pistol"))
		self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Pistol"))
		self.CalmTurnLeftAnim = "Pistol_Holstered_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Pistol_Holstered_Turn_Right_Idle"
		self.TurnLeftAnim = "Pistol_Turn_Left_Idle"
		self.TurnRightAnim = "Pistol_Turn_Right_Idle"
		self.SurpriseAnim = "Surprised_1handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle_Crouch"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol_Crouch"))}
		self.GrenadeAnim = "Throw_Grenade"
		self.AllowGrenade = true
		self.CanShootCrouch = true
		self.CanMelee = true
	elseif self.RifleHolds[hold] then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Passive_Idle"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_1")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_2")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_3")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_4")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_5"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle_Holstered"))}
		self.MeleeAnim = {"Melee_Rifle_1","Melee_Rifle_2"}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Rifle"))
		if self.Weapon:GetClass() == "astw2_haloreach_sniper_rifle" then
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Sniper"))
			self.Weapon.BurstLength = 1
		elseif hold == "ar2" then
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Rifle"))
		elseif hold == "shotgun" then
			self.Weapon.Acc = 0
			self.Weapon.Primary.RecoilAcc = 0
			self.WeaponAccuracy = 9
			self.Weapon.BurstLength = 1
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Shotgun"))
		end
		self.CalmTurnLeftAnim = "Passive_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Passive_Turn_Right_Idle"
		self.TurnLeftAnim = "Rifle_Turn_Left_Idle"
		self.TurnRightAnim = "Rifle_Turn_Right_Idle"
		self.SurpriseAnim = "Surprised_2handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_Crouch"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle_Crouch"))}
		self.GrenadeAnim = "Throw_Grenade"
		self.AllowGrenade = true
		self.CanShootCrouch = true
		self.CanMelee = true
	elseif hold == "rpg" then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Missile"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Missile"))}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Missile"))
		self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Missile"))
		self.CalmTurnLeftAnim = "Missile_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Missile_Turn_Right_Idle"
		self.TurnLeftAnim = "Missile_Turn_Left_Idle"
		self.TurnRightAnim = "Missile_Turn_Right_Idle"
		self.SurpriseAnim = "Surprised_2handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle_Crouch"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Missile_Crouch"))}
		self.AllowGrenade = false
		self.CanShootCrouch = true
		self.CanMelee = false
	end
end

function ENT:DoCustomIdle()
	if self.IsFollowingPlayer then
		local dist = self:GetRangeSquaredTo(self.FollowingPlayer)
		if dist > 300^2 then
			self:WanderToPosition( (self.FollowingPlayer:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300), self.RunCalmAnim[math.random(1,#self.RunCalmAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
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
	coroutine.wait(self:SequenceDuration(seq))
	self:SearchEnemy()
end

function ENT:OnHaveEnemy(ent)
	if !self.IsOnVehicle then
		if !self.BeenSurprised and math.random(1,3) == 1 then
			self.BeenSurprised = true
			local xy = ent:GetPos().x+ent:GetPos().y
			local xy2 = self:GetPos().x+self:GetPos().y
			local dif = math.abs(xy-xy2)
			if dif < 700 then
				local func = function()
					self:PlaySequenceAndMove(self:LookupSequence(self.SurpriseAnim),1,self:GetForward()*-1,50,0.7)
				end
				table.insert(self.StuffToRunInCoroutine,func)
			end
		end
		self:ResetAI()
	end
end

function ENT:OnLostSeenEnemy(ent)
	if ent == self.Enemy then
		self:SetEnemy(nil)
		self:GetATarget()
	end
end

function ENT:OnTraceAttack( info, dir, trace )
	if trace.HitGroup == 1 then
		info:ScaleDamage(3)
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	local hg = trace.HitGroup
	if self.FlinchAnims[hg] and !self.DoneFlinch and math.random(100) < self.FlinchChance and info:GetDamage() > self.FlinchDamage then
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
	end
end

function ENT:OnInjured(dmg)
	local rel = self:CheckRelationships(dmg:GetAttacker())
	local ht = self:Health()
	if rel == "friend" and self.BeenInjured then dmg:ScaleDamage(0) return end
	if rel == "foe" then self:SetEnemy(dmg:GetAttacker()) end
	local total = dmg:GetDamage()
	--print(self.Shield, "before")
	self.HealthActual = self:Health()
	self.HealthH = CurTime()
	local htt = CurTime()
	local htl = self:Health()
	local dm = dmg:GetDamage()
	local ht = self:Health()-math.abs(dm)
	--print(self.Shield, "now")
	timer.Simple( 2, function()
		if IsValid(self) and htt == self.HealthH then
			--print("Starting regeneration")
			for i = 1, 10 do
				timer.Simple( 0.4*i, function()
					if IsValid(self) and htl == self.HealthActual then
						--print("Regenerating", (self.HealthActual-ht)/10)
						self:SetHealth(self:Health()+((self.HealthActual-ht)/10))
					end
				end )
			end
		end
	end )
end

function ENT:GetShootPos()
	if IsValid(self:GetActiveWeapon()) then
		return self:GetActiveWeapon():GetAttachment(1).Pos
	else
		return self:WorldSpaceCenter()
	end
end

function ENT:HasToReload()
	return self.Weapon:Clip1() == 0
end

function ENT:DoMelee()
	if IsValid(self.Enemy) then
		local ang = (self.Enemy:GetPos()-self:GetPos()):GetNormalized():Angle()
		self:SetAngles(Angle(0,ang.y,0))
	end	
	self.DoneMelee = true
	self.DoingMelee = true
	timer.Simple( math.random(5,10), function()
		if IsValid(self) then
			self.DoneMelee = false
		end
	end )
	local anim = self.MeleeAnim[math.random(#self.MeleeAnim)]
	local id, len = self:LookupSequence(anim)
	timer.Simple( len*0.4, function()
		if IsValid(self) then
			self:DoMeleeDamage()
		end
	end )
	timer.Simple( len, function()
		if IsValid(self) then
			self.DoingMelee = false
		end
	end )
	self:PlaySequenceAndPWait(anim,1,self:GetPos())
end

function ENT:DoMeleeDamage()
	local damage = self.MeleeDamage
	for	k,v in pairs(ents.FindInCone(self:WorldSpaceCenter(), self:GetForward(), self.MeleeRange,  math.cos( math.rad( self.MeleeConeAngle ) ))) do
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

function ENT:ThrowGrenade()
	self.ThrowedGrenade = true
	timer.Simple( math.random(5,10), function()
		if IsValid(self) then
			self.ThrowedGrenade = false
		end
	end )
	local grenade
	timer.Simple( 0.8, function()
		if IsValid(self) then
			--grenade = ents.Create("astw2_halo_cea_frag_grenade_thrown")
			grenade = ents.Create("frag_grenade_h3")
			local att = self:GetAttachment(2)
			grenade:SetPos(att.Pos)
			grenade:SetAngles(att.Ang)
			grenade:SetOwner(self)
			grenade:Spawn()
			grenade:Activate()
			grenade:SetMoveType( MOVETYPE_NONE )
			grenade:SetParent( self, 2 )
		end
	end )
	timer.Simple( 1.5, function()
		if IsValid(self) and IsValid(grenade) then
			grenade:SetMoveType( MOVETYPE_VPHYSICS )
			grenade:SetParent( nil )
			grenade:SetPos(self:GetAttachment(2).Pos)
			local prop = grenade:GetPhysicsObject()
			if IsValid(prop) then
				prop:Wake()
				prop:EnableGravity(true)
				prop:SetVelocity( (self:GetAimVector() * 500)+(self:GetUp()*(math.random(10,50)*5)) )
			end
		end
	end )
	self:PlaySequenceAndMove(self.GrenadeAnim,1,self:GetForward(),40,0.8)
	return self:CustomBehaviour(self.Enemy)
end

function ENT:CustomBehaviour(ent)
	ent = ent or self.Enemy
	if !IsValid(ent) then self:GetATarget() end
	if !IsValid(self.Enemy) then return else ent = self.Enemy end
	local los = self:IsAbleToSee( ent, false )
	local range = self:GetRangeSquaredTo(ent)
	if los and !self.DoneMelee and range < self.MeleeRange^2 then
		self:DoMelee()
	end
	if range > self.ShootDist^2 and range > (self.MeleeRange*2)^2 then
		self.StopShoot = true
	else
		self.StopShoot = false
	end
	if self.AllowGrenade and range < self.GrenadeRange^2 then
		self.CanThrowGrenade = true
	else
		self.CanThrowGrenade = false
	end
	if !IsValid(ent) then return end
	if self.AIType == "Static" then
	
		if self:HasToReload() then
			self.Weapon:AI_PrimaryAttack()
			return
		end
		local should, dif = self:ShouldFace(ent)
		if should then
			self:TurnTo(dif)
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
			local dire = (self:GetPos()-ent:GetPos()):GetNormalized()
			local r = math.random(3,4)
			local dir = dire+self:GetRight()*1
			timer.Simple( r*0.25, function()
				if IsValid(self) then
					dir = dire
				end
			end )
			for i = 1, r*100 do
				
				timer.Simple( 0.01*i, function()
					if IsValid(self) then
						self.loco:Approach(self:GetPos()+dir,1)
						self.loco:FaceTowards(self:GetPos()+dir)
					end
				end )
				
			end
			self:StartMovingAnimations( self.RunAnim[math.random(#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
			coroutine.wait(r)
			self.Weapon:AI_PrimaryAttack()
			return
		end
		local should, dif = self:ShouldFace(ent)
		if should then
			self:TurnTo(dif)
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
				if math.random(1,3) == 1 then
					anim = self.CrouchMoveAnim
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
						if IsValid(self) and self:Health() > 0 then
							self.loco:Approach(self:GetPos()+dir,1)
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
						if IsValid(self) and self:Health() > 0 then
							self.loco:Approach(self:GetPos()+self:GetRight()*r,1)
						end
					end )
				
				end
			else
				self:SetEnemy(nil)
			end
		end
		coroutine.wait(wait)
		
	end
	return self:CustomBehaviour(ent)
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

function ENT:Shoot()
	if !IsValid(self.Weapon) then return end
	if self.StopShoot then return end
	self.Weapon:AI_PrimaryAttack()
	self:DoGesture(self.ShootAnim)
end

function ENT:PlaySequenceAndPWait( name, speed, p )
    local len = self:SetSequence( name )
	if isstring(name) then name = self:LookupSequence(name) end
    speed = speed or 1
	local stop = false
	timer.Simple( len, function()
		stop = true
	end )

    self:ResetSequenceInfo()
    self:SetCycle( 0 )
    self:SetPlaybackRate( speed )
    while (!stop) do
        local good,pos,ang = self:GetSequenceMovement(name,0,self:GetCycle())
		--print(ang,good,p,pos)
        local position = pos+p   
        self:SetPos(position)
		self:SetAngles(ang+self:GetAngles())
        coroutine.wait(0.0005)
    end

end

function ENT:PlaySequenceAndMove( name, speed, dir, sp, cyc )
    local len = self:SetSequence( name )
	if isstring(name) then name = self:LookupSequence(name) end
	local stop = false
	timer.Simple( len, function()
		stop = true
	end )
    self:ResetSequenceInfo()
    self:SetCycle( 0 )
    self:SetPlaybackRate( speed )
	self.loco:SetDesiredSpeed(sp)
    while (!stop) do
		if self:GetCycle() < cyc then
			self.loco:Approach(self:GetPos()+dir,1)
		end
        coroutine.wait(0.01)
    end

end

--[[ENT.NThink = 0

function ENT:Think()
	if self.NThink < CurTime() then
		self.NThink = CurTime()+0.3
		local look = false
		local goal
		local y
		local di = 0
		local p
		local dip = 0
		if IsValid(self.Enemy) then
			goal = self.Enemy:WorldSpaceCenter()
			y = (goal-self:WorldSpaceCenter()):Angle().y
			di = math.AngleDifference(self:GetAngles().y,y)
			p = (goal-self:WorldSpaceCenter()):Angle().p
			dip = math.AngleDifference(self:GetAngles().p,p)
		end
		self:SetPoseParameter("aim_yaw",-di)
		self:SetPoseParameter("aim_pitch",-dip)
    end
end]]

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if !self.loco:GetVelocity():IsZero() then
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
	if !self.DoingFlinch and self:Health() > 0 and !self.DoingMelee then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
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

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.KilledDmgInfo = dmginfo
	self.BehaveThread = nil
	self.DieThread = coroutine.create( function() self:DoKilledAnim() end )
	coroutine.resume( self.DieThread )
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
			if y <= 135 and y > 45 then -- Left
				anim = "Death_Front_Left_Head"
			elseif y < 225 and y > 135 then -- Front
				anim = "Death_Front_Head_"..math.random(1,2)..""
			elseif y >= 225 and y < 315 then -- Right
				anim = "Death_Front_Right_Head"
			elseif y <= 45 or y >= 315 then -- Back
				anim = "Death_Back_Head"
			end
		else
			if y <= 135 and y > 45 then -- Right
				anim = "Death_Front_Right_Gut"
			elseif y < 225 and y > 135 then -- Front
				anim = "Death_Back_Gut_2"
			elseif y >= 225 and y < 315 then -- Left
				anim = "Death_Front_Left_Gut"
			elseif y <= 45 or y >= 315 then -- Back
				anim = "Death_Back_Gut_1"
			end
		end
	else
		return true
	end
	return anim
end

function ENT:DoKilledAnim()
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
				local rag = self:BecomeRagdoll(DamageInfo())
			end
		end )
		self:PlaySequenceAndPWait(seq, 1, self:GetPos())
	else
		local wep = ents.Create(self.Weapon:GetClass())
		wep:SetPos(self.Weapon:GetPos())
		wep:SetAngles(self.Weapon:GetAngles())
		wep:Spawn()
		self.Weapon:Remove()
		self:BecomeRagdoll(DamageInfo())
	end
end