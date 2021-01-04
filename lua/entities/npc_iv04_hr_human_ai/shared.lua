AddCSLuaFile()
include("voices.lua")

ENT.Base 			= "npc_iv04_weaponuserbase"

ENT.MoveSpeed = 100

ENT.MoveSpeedMultiplier = 1.5

ENT.BehaviourType = 3

ENT.CustomIdle = true

ENT.SightType = 2

ENT.Faction = "FACTION_UNSC"

ENT.AIType = "Offensive"

ENT.ExtraSpread = 0

ENT.ShootDist = 1024

ENT.SightDistance = 2048

ENT.CanUse = true

ENT.GrenadeRange = 768

ENT.GrenadeChances = 30

ENT.MeleeDamage = 0

ENT.MeleeRange = 70

ENT.FlinchChance = 30

ENT.FlinchDamage = 10

ENT.RunBehaviourTime = 0

ENT.SeenVehicles = {}

ENT.CountedVehicles = 0

ENT.IsUNSC = true

ENT.CollisionMask = MASK_NPCSOLID

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
	["astw2_haloreach_spartan_laser"] = true,
	["astw2_haloreach_needler"] = true
}

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
	self.StartPosition = self:GetPos()
	self.AIType = GetConVar("halo_reach_nextbots_ai_type"):GetString() or self.AIType
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
	["rpg"] = true
}

function ENT:GetAmmoCount( no )
	return self.Weapon:Clip1()
end

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
	self.WarthogDriverEnter = "Warthog_Driver_Enter"
	self.WarthogDriverExit = "Warthog_Driver_Exit"
	self.WarthogDriverIdle = "Warthog_Driver_Idle"
	self.WarthogPassengerEnter = "Warthog_Passenger_Enter"
	self.WarthogPassengerExit = "Warthog_Passenger_Exit"
	self.WarthogGunnerEnter = "Warthog_Gunner_Enter"
	self.WarthogGunnerExit = "Warthog_Gunner_Exit"
	self.WarthogGunnerIdle = "Warthog_Gunner_Idle"
	if self.PistolHolds[hold] then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle_Low"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Pistol_Idle"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Pistol"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Pistol"))}
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
		self.WarthogPassengerIdle = "Warthog_Passenger_Idle_Pistol"
		if self.Weapon:GetClass() == "astw2_haloreach_magnum" then
			self.Weapon.BurstLength = 4
		end
		self.AllowGrenade = true
		self.CanShootCrouch = true
		self.CanMelee = true
	elseif self.RifleHolds[hold] then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Passive_Idle"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_1")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_2")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_3")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_4")),self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_5"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Rifle"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle_Holstered"))}
		self.MeleeAnim = {"Melee_Rifle_1","Melee_Rifle_2"}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Rifle"))
		if self.Weapon:GetClass() == "astw2_haloreach_sniper_rifle" then
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Sniper"))
			self.Weapon.BurstLength = 1
		elseif self.Weapon:GetClass() == "astw2_haloreach_grenade_launcher" then
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Grenade_Launcher"))
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_GL"))
		elseif hold == "ar2" then
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Rifle"))
		elseif hold == "shotgun" then
			self.Weapon.Acc = 0
			self.Weapon.Primary.RecoilAcc = 0
			self.WeaponAccuracy = 9
			self.Weapon.BurstLength = 1
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Shotgun"))
		else
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Rifle"))
		end
		self.CalmTurnLeftAnim = "Passive_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Passive_Turn_Right_Idle"
		self.TurnLeftAnim = "Rifle_Turn_Left_Idle"
		self.TurnRightAnim = "Rifle_Turn_Right_Idle"
		self.SurpriseAnim = "Surprised_2handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Rifle_Idle_Crouch"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Rifle_Crouch"))}
		self.GrenadeAnim = "Throw_Grenade"
		self.WarthogPassengerIdle = "Warthog_Passenger_Idle_Rifle"
		self.AllowGrenade = true
		self.CanShootCrouch = true
		self.CanMelee = true
	elseif hold == "rpg" then
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Missile_Idle"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Move_Missile"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Missile"))}
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
		self.WarthogPassengerIdle = "Warthog_Passenger_Idle_Missile"
		self.AllowGrenade = false
		self.CanShootCrouch = true
		self.CanMelee = false
	end
end

function ENT:DoCustomIdle()
	if self.IsInVehicle then return self:VehicleIdle() end
	local can, veh = self:CanEnterAVehicle()
	if can then
		self:EnterVehicle(veh)
		return self:VehicleIdle()
	end
	if self.IsFollowingPlayer then
		if self.FollowingPlayer:InVehicle() then
			local ent = self.FollowingPlayer:GetVehicle():GetParent()
			if IsValid(ent) and self.DriveThese[ent:GetModel()] and !self.SeenVehicles[ent] then
				self.SeenVehicles[ent] = true
				self.CountedVehicles = self.CountedVehicles+1
			end
		end
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

function ENT:OnHaveEnemy(ent)
	if !self.IsInVehicle then
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
	if !self.IsInVehicle and self.FlinchAnims[hg] and !self.DoneFlinch and math.random(100) < self.FlinchChance and info:GetDamage() > self.FlinchDamage then
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

function ENT:OnLeaveGround(ent)
	if self:Health() <= 0 then 
		self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne")))
	end
end

function ENT:OnLandOnGround(ent)
	if self.FlyingDead then
		self.HasLanded = true
	end
end

function ENT:OnInjured(dmg)
	local rel = self:CheckRelationships(dmg:GetAttacker())
	local ht = self:Health()
	if rel == "friend" and !dmg:GetAttacker():IsPlayer() then
		if self.BeenInjured then
			dmg:ScaleDamage(0)
			return
		else
			self.BeenInjured = true
			timer.Simple( math.random(5,10), function()
				if IsValid(self) then
					self.BeenInjured = false
				end
			end )
		end
	end
	if IsValid(self.Enemy) then
		--print(#self:PossibleTargets())
		if rel == "foe" and !self.Switched then 
			self.Switched = true
			timer.Simple( math.random(3,6), function()
				if IsValid(self) then
					self.Switched = false
				end
			end )
			self:SetEnemy(dmg:GetAttacker()) 
		end
		if (self:Health() < self.StartHealth/2 or #self:PossibleTargets() > 4 )and !self.Covered then
			self.Covered = true
			self.NeedsToCover = true
			timer.Simple( math.random(10,20), function()
				if IsValid(self) then
					self.Covered = false
				end
			end )
		end
	else
		if rel == "foe" then
			self:SetEnemy(dmg:GetAttacker()) 
		end
	end
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
	self.ThrowingGrenade = true
	local grenade
	timer.Simple( 0.8, function()
		if IsValid(self) then
			grenade = ents.Create("astw2_haloreach_frag_thrown")
			local att = self:GetAttachment(2)
			grenade:SetPos(att.Pos)
			grenade:SetAngles(att.Ang)
			grenade:SetOwner(self)
			grenade:Spawn()
			grenade:Activate()
			grenade:SetMoveType( MOVETYPE_NONE )
			grenade:SetParent( self, 2 )
			grenade.BlastRadius = 200
			grenade.BlastDMG = 80
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
	self.ThrowingGrenade = false
end

function ENT:FindCoverSpots(ent,r)
	r = r or math.random(3,4)
	local dire = (self:GetPos()-ent:GetPos()):GetNormalized()
	local navs = navmesh.Find( self:GetPos()+(dire*512), 1024, 100, 10 )
	local tbl = {}
	local found = false
	for k, nav in pairs(navs) do
		local covers = nav:GetHidingSpots(3)
		if istable(covers) and #covers > 0 then
			for i = 1, #covers do
				if !ent:VisibleVec(covers[i]) then
					tbl[#tbl+1] = covers[i]
				end
			end
		end
		if !nav:IsVisible( ent:WorldSpaceCenter() ) then
			tbl[nav:GetID()] = nav:GetRandomPoint()
		end
	end
	return tbl, dire
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
	if ent:IsVehicle() and self.DriveThese[ent:GetModel()] and !self.SeenVehicles[ent] then
		self.SeenVehicles[ent] = true
		self.CountedVehicles = self.CountedVehicles+1
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

ENT.DriveThese = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = true,
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = true,
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = true
}

ENT.PassengerSlots = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = 3,
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = 3,
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = 3
}

ENT.TurretTypes = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = "MG",
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = "Gauss",
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = "Rocket"
}

ENT.TurretBones = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = "turret",
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = "turret_2",
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = "turret_2"
}

function ENT:CanEnterAVehicle()
	local ve
	local can = false
	for veh, bool in pairs(self.SeenVehicles) do
		if IsValid(veh) then
			if !veh.PassengerS then veh.PassengerS = {} end
			local total = 0
			for i = 1, #veh.PassengerS do
				local pas = veh.PassengerS[i]
				if IsValid(pas) or ( ( i == 1 and !IsValid(veh:GetDriver()) ) or ( IsValid(veh.pSeat[i-1]) and IsValid(veh.pSeat[i-1]:GetDriver()) ) ) then
					total = total+1
				end
			end
			if total < self.PassengerSlots[veh:GetModel()] then
				ve = veh
				can = true
				break
			end
		else
			self.SeenVehicles[veh] = nil
		end
	end
	return can, ve
end

function ENT:Think()
	if self.IsInVehicle then
		if self.VehicleRole == "Gunner" then
			self:SetPos(self.Vehicle:GetBonePosition(self.Vehicle:LookupBone(self.TurretBone))+self:GetUp()*26+self:GetForward()*-20)
		else
			local offs = {
				["Driver"] = self.Vehicle:GetRight()*-18+self.Vehicle:GetUp()*38+self.Vehicle:GetForward()*-16,
				["Passenger"] = self.Vehicle:GetRight()*18+self.Vehicle:GetUp()*6+self.Vehicle:GetForward()*67
			}
			self:SetPos(self.Seat:GetPos()+offs[self.VehicleRole])
		end
	end
end

function ENT:VehicleIdle()
	self:SearchEnemy()
	if self.VehicleRole == "Gunner" then
		self:PlaySequenceAndWait(self.WarthogGunnerIdle)
	elseif self.VehicleRole == "Driver" then
		if self.IsFollowingPlayer then
			self:Drive(self.FollowingPlayer:GetPos()+self.FollowingPlayer:GetForward()*-400)
		end
		self:PlaySequenceAndWait(self.WarthogDriverIdle)
	elseif self.VehicleRole == "Passenger" then
		self:PlaySequenceAndWait(self.WarthogPassengerIdle)
	end
end

--[[ Stuff to make the vehicle move:
    veh:SetActive(true)
    veh:StartEngine()

    veh.PressedKeys["A"] = true/false
    veh.PressedKeys["S"] = true/false
    veh.PressedKeys["D"] = true/false
    veh.PressedKeys["W"] = true/false
	veh.PressedKeys["joystick_steer_left"] = true/false
	veh.PressedKeys["joystick_steer_right"] = true/false
	
	veh.PressedKeys["Space"] = false
   
    veh:PlayerSteerVehicle( self, left, right )
    self is the driver
    left, right are 0 or 1
    
    function ENT:GetInfoNum(no,yes)
        return 1
    end
]]

function ENT:AdjustKeys(ang)
	local veh = self.Vehicle
	local dif = math.AngleDifference(self:GetAngles().y,ang.y)
	local right = 0
	local left = 0
	if dif < 0 then dif = dif + 360 end
	if ( dif > 195 and dif < 345 ) or ( dif < 165 and dif > 15 )then
		if dif >= 180 then
			veh.PressedKeys["A"] = true
			veh.PressedKeys["D"] = false
			veh.PressedKeys["joystick_steer_right"] = false
			veh.PressedKeys["joystick_steer_left"] = true
			left = 1
			--print("left")
		else
			veh.PressedKeys["A"] = false
			veh.PressedKeys["D"] = true
			veh.PressedKeys["joystick_steer_right"] = true
			veh.PressedKeys["joystick_steer_left"] = false
			right = 1
			--print("right")
		end
	else
		veh.PressedKeys["A"] = false
		veh.PressedKeys["D"] = false
		veh.PressedKeys["joystick_steer_right"] = false
		veh.PressedKeys["joystick_steer_left"] = false
	end
	if ( dif < 90 and dif > 270 ) then
		veh.PressedKeys["S"] = true
		veh.PressedKeys["W"] = false
		--print("back")
	else
		veh.PressedKeys["S"] = false
		veh.PressedKeys["W"] = true
		--print("front")
	end
	veh.PressedKeys["Space"] = false
   
    veh:PlayerSteerVehicle( self, left, right )
end

function ENT:Drive(goal,pathed,path)
	local pos = goal
	local stop = false
	local timed = false
	while (!stop) do
		if pathed then
			if !IsValid(path) then
				stop = true
			end
			pos = path:GetCurrentGoal().pos
			path:Draw()
		elseif !timed then
			timed = true
			timer.Simple( math.random(3,5), function()
				if IsValid(self) then
					stop = true
				end
			end )
		end
		local ang = (pos-self:GetPos()):GetNormalized():Angle()
		self:AdjustKeys(ang)
		coroutine.wait(0.3)
	end
	self.Vehicle.PressedKeys["Space"] = true
	self.Vehicle.PressedKeys["S"] = false
	self.Vehicle.PressedKeys["W"] = false
	self.Vehicle.PressedKeys["A"] = false
	self.Vehicle.PressedKeys["D"] = false
	self.Vehicle.PressedKeys["joystick_steer_right"] = false
	self.Vehicle.PressedKeys["joystick_steer_left"] = false
end

function ENT:VehicleBehavior(ent,dist)
	if self.VehicleRole == "Gunner" then
		if self.GunnerShoot and !self.Shot then
			self.Shot = true
			timer.Simple( math.random( 4,6 ), function()
				if IsValid(self) then
					self.Shot = false
				end
			end )
			if self.TurretType == "MG" then
				local del = 0.5
				for i = 1, math.random(30,40) do
					del = del-0.1
					if del < 0.1 then del = 0.1 end
					timer.Simple( i*del, function()
						if IsValid(self) and IsValid(self.Vehicle) then
							local bullet = {}
							bullet.Attacker = self
							bullet.Damage = 8
							local dir
							local origin = self.Vehicle:GetAttachment(self.Vehicle:LookupAttachment("muzzle")).Pos
							ParticleEffectAttach( "simphys_halo_warthog_chaingun_muzzle", PATTACH_POINT_FOLLOW, self.Vehicle, 5 )
							self.Vehicle:EmitSound("hce_turret")
							local ens = ents.Create("prop_physics")
							ens:SetPos(origin)
							ens:SetAngles(self.Vehicle:GetAttachment(self.Vehicle:LookupAttachment("muzzle")).Ang)
							bullet.TracerName = "effect_simfphys_halo_warthog_chaingun_tracer"
							bullet.Src = ens:GetPos()
							bullet.Spread = Vector(0.05,0.05,0.05)
							if IsValid(self.Enemy) then
								dir = (self.Enemy:WorldSpaceCenter()-origin):GetNormalized()
							end
							bullet.Dir = dir or self:GetAimVector()
							ens:FireBullets(bullet)
							ens:Remove()
						end
					end )
				end
			elseif self.TurretType == "Gauss" then
				local vehicle = self.Vehicle
				
				vehicle.wOldPos = vehicle.wOldPos or vehicle:GetPos()
				local deltapos = vehicle:GetPos() - vehicle.wOldPos
				vehicle.wOldPos = vehicle:GetPos()
				
				local AttachmentID = vehicle.swapMuzzle and vehicle:LookupAttachment( "muzzle" ) or vehicle:LookupAttachment( "muzzle" )
				local Attachment = vehicle:GetAttachment( AttachmentID )
							
				local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
				local shootDirection = Attachment.Ang:Forward()
			
				self.Vehicle:EmitSound("gauss_fire")

				self.Vehicle:GetPhysicsObject():ApplyForceOffset( -shootDirection * 150000, shootOrigin )
					
				local projectile = {}
					projectile.filter = self.Vehicle.VehicleData["filter"]
					projectile.shootOrigin = shootOrigin
					projectile.shootDirection = shootDirection
					projectile.attacker = self
					projectile.attackingent = vehicle
					projectile.Damage = 500
					projectile.Force = 64000
					projectile.Size = 25
					projectile.BlastRadius = 50
					projectile.BlastDamage = 2500
					projectile.DeflectAng = 10
					projectile.BlastEffect = "simfphys_hce_snow_gauss"
					projectile.MuzzleVelocity = 640
				
				AVX.FirePhysProjectile( projectile )
			elseif self.TurretType == "Rocket" then
				for i = 1, 6 do 
					timer.Simple( 0.3*i, function()
						if IsValid(self) and IsValid(self.Vehicle) then
							local vehicle = self.Vehicle
							
							vehicle.wOldPos = vehicle.wOldPos or vehicle:GetPos()
							local deltapos = vehicle:GetPos() - vehicle.wOldPos
							vehicle.wOldPos = vehicle:GetPos()
							
							local AttachmentID = math.random(6,7)
							local Attachment = vehicle:GetAttachment( AttachmentID )
										
							local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
							local shootDirection = Attachment.Ang:Forward()
						
							vehicle:EmitSound("reach_rocket_fire")

							vehicle:GetPhysicsObject():ApplyForceOffset( -shootDirection * 80000, shootOrigin )
							local projectile = {}
								projectile.filter = vehicle.VehicleData["filter"]
								projectile.shootOrigin = shootOrigin
								projectile.shootDirection = shootDirection
								projectile.attacker = self
								projectile.attackingent = vehicle
								projectile.Damage = 250
								projectile.Force = 64000
								projectile.Size = 50
								projectile.BlastRadius = 200
								projectile.BlastDamage = 800
								projectile.DeflectAng = 1
								projectile.BlastEffect = "simfphys_hce_snow_rocket_reach"
								projectile.MuzzleVelocity = 50
							
							HCE.FirePhysProjectile( projectile )
						end
					end )
				end
				
			end
		end
		self:PlaySequenceAndWait(self.WarthogGunnerIdle)
	elseif self.VehicleRole == "Driver" then
		self:SetSequence(self.WarthogDriverIdle)
		local r = math.random(1,2)
		if r == 2 then r = -1 end
		local goal = ent:GetPos()+self:GetRight()*(r*600)+self:GetForward()*math.random(100,1000)
		self:Drive(goal,false,nil)
	elseif self.VehicleRole == "Passenger" then
		local y = math.AngleDifference(self:GetAngles().y,(ent:WorldSpaceCenter()-self:GetShootPos()):GetNormalized():Angle().y)
		if math.abs(y) <= 90 then
			self.Weapon:AI_PrimaryAttack()
		else
			self:SetEnemy(nil)
		end
		self:PlaySequenceAndWait(self.WarthogPassengerIdle)
	end
end

ENT.VehicleSlots = {
	["models/snowysnowtime/vehicles/haloreach/warthog.mdl"] = {
		[1] = "Driver",
		[2] = "Gunner",
		[3] = "Passenger"
	},
	["models/snowysnowtime/vehicles/haloreach/warthog_rocket.mdl"] = {
		[1] = "Driver",
		[2] = "Gunner",
		[3] = "Passenger"
	},
	["models/snowysnowtime/vehicles/haloreach/warthog_gauss.mdl"] = {
		[1] = "Driver",
		[2] = "Gunner",
		[3] = "Passenger"
	}
}

function ENT:EnterVehicle(veh)
	local dirs = {
		[1] = veh:GetRight()*-80,
		[2] = veh:GetForward()*-160,
		[3] = veh:GetRight()*80
	}
	local seat
	local clss = veh:GetModel()
	local e
	for i = 1, self.PassengerSlots[clss] do
		if !IsValid(veh.PassengerS[i]) then
			if ( i == 1 and !IsValid(veh:GetDriver()) ) or ( IsValid(veh.pSeat[i-1]) and !IsValid(veh.pSeat[i-1]:GetDriver()) ) then
				veh.PassengerS[i] = self
				if i == 1 then
					seat = veh
				else
					seat = veh.pSeat[i-1]
				end
				e = i
				break
			end
		end
	end
	self.VehicleRole = self.VehicleSlots[clss][e]
	self.TurretType = self.TurretTypes[clss]
	self.TurretBone = self.TurretBones[clss]
	self:MoveToPosition(seat:GetPos()+dirs[e],self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier)
	for i = 1, self.PassengerSlots[clss] do
		if veh.PassengerS[i] == self then
			if ( i == 1 and IsValid(veh:GetDriver()) ) or ( IsValid(veh.pSeat[i-1]) and IsValid(veh.pSeat[i-1]:GetDriver()) ) then
				local rude
				if i == 1 then
					rude = veh:GetDriver()
				else
					if IsValid(veh.pSeat[i-1]) then
						rude = veh.pSeat[i-1]:GetDriver()
					end
				end
				veh.PassengerS[i] = rude
				self.VehicleRole = "No"
				self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
				return
			end
		end
	end
	self.IsInVehicle = true
	self.Vehicle = veh
	self.Seat = seat
	--self:SetPos(seat:GetPos())
	self:SetParent(seat)
	self:SetOwner(seat)
	self.TraceMask = MASK_VISIBLE_AND_NPCS
	if self.VehicleRole == "Gunner" then
		self.LTPP = veh:GetPoseParameter("turret_yaw")
		self.LTP = veh:GetPoseParameter("spin_cannon")
		self.Weapon:SetNoDraw(true)
		self:SetAngles(Angle(veh:GetAngles().p,veh:GetAngles().y+veh:GetPoseParameter("turret_yaw"),0))
		self:PlaySequenceAndWait(self.WarthogGunnerEnter)
	elseif self.VehicleRole == "Driver" then
		veh:SetActive(true)
		veh:StartEngine()
		self.Weapon:SetNoDraw(true)
		self:PlaySequenceAndWait(self.WarthogDriverEnter)
		self:SetAngles(Angle(veh:GetAngles().p,veh:GetAngles().y,0))
	elseif self.VehicleRole == "Passenger" then
		self:SetAngles(Angle(veh:GetAngles().p,veh:GetAngles().y,0))
		self:PlaySequenceAndWait(self.WarthogPassengerEnter)
	end
end

function ENT:GetInfoNum(no,yes)
    return 1
end

function ENT:CustomBehaviour(ent,range)
	ent = ent or self.Enemy
	if !IsValid(ent) then self:GetATarget() end
	if !IsValid(self.Enemy) then return else ent = self.Enemy end
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
	if IsValid(obstr) then	
		if ( self.DriveThese[obstr:GetModel()] and !self.SeenVehicles[obstr] ) then
			self.SeenVehicles[obstr] = true
			self.CountedVehicles = self.CountedVehicles+1
		elseif ( ( obstr:IsNPC() or obstr:IsPlayer() or obstr:IsNextBot() ) and obstr:Health() > 0 ) and self:CheckRelationships(obstr) == "foe" then
			ent = obstr
			self:SetEnemy(ent)
		end
	end
	if self.IsInVehicle then return self:VehicleBehavior(ent,range) end
	local can, veh = self:CanEnterAVehicle()
	if can then
		self:EnterVehicle(veh)
		return self:VehicleBehavior(ent,range)
	end
	if los and !self.DoneMelee and range < self.MeleeRange^2 then
		self:DoMelee()
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
				self:MoveToPosition( area, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
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
				self:MoveToPosition( area, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
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
	
			local wait = math.random(1,2)
			if math.random(1,2) == 1 then
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
					dire = dir
				end
				local switch = math.Rand(0.3,0.7)
				timer.Simple( wait*switch, function()
					if IsValid(self) then
						dir = dire
					end
				end )
				local re = math.random(1,3)
				if re == 1 then
					anim = self.CrouchMoveAnim
					speed = self.MoveSpeed
					mul = 1
					dire = dir
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
			--victim.BeenNoticed = self.IsSergeant
			if self.SawAllyDie and !self.SawAlliesDie then self.SawAlliesDie = true end
			if !self.SawAllyDie then self.SawAllyDie = true end
			local attacker = info:GetAttacker()
			if attacker:IsPlayer() and self.FriendlyToPlayers then
				self.NoticedKills = self.NoticedKills+1
				if self.NoticedKills > 1 then
					--self:Speak("AllianceBroken")
					self.FriendlyToPlayers = false
					self.LastAllyKill = CurTime()
					local last = self.LastAllyKill
					timer.Simple( 30, function()
						if IsValid(self) then
							if self.LastAllyKill == last then
								self.FriendlyToPlayers = true
								self.NoticedKills = 0
								self:SetEnemy(nil)
								--self:Speak("AllianceReformed")
							end
						end
					end )
				else
					--self:Speak("FriendKilledByPlayer")
				end
				
			elseif attacker:IsPlayer() and !self.FriendlyToPlayers then
				--self:Speak("FriendKilledByEnemyPlayer")
				self.LastAllyKill = CurTime()
				local last = self.LastAllyKill
				timer.Simple( 30, function()
					if IsValid(self) then
						if self.LastAllyKill == last then
							self.NoticedKills = 0
							self.FriendlyToPlayers = true
							self:SetEnemy(nil)
							--self:Speak("AllianceReformed")
						end
					end
				end )
			elseif attacker.Faction == "FACTION_COVENANT" then
				--self:Speak("FriendKilledByCovenant")
				
			elseif ( attacker:IsNPC() and attacker.IsVJBaseSNPC and string.StartWith(attacker:GetClass(), "npc_vj_flood") ) or victim.HasBeenLatchedOn then
				-- Killed by flood
				--self:Speak("FriendKilledByFlood")
				
			elseif self:CheckRelationships(attacker) == "friend" then
				--self:Speak("FriendKilledByFriend")
				
			elseif victim:IsPlayer() then
				if info:GetAttacker() == self then
					--self:Speak("KilledFriendPlayer")
					--self:NearbyReply("KilledFriendPlayerAlly")
				else
					--self:Speak("FriendPlayerDie")
				end
				
			else
				if info:GetAttacker() == self then
					--self:Speak("KilledFriend")
					--self:NearbyReply("KilledFriendAlly")
				else
					if self.SawAlliesDie then
						local AI = self.AIType
						self.AIType = "Defensive"
						local func = function()
							if self.IsSergeant and !self.IsInVehicle then
								self:PlaySequenceAndMove(self:LookupSequence("Signal_Fallback"),1,self:GetForward()*-1,50,0.7)
							end
						end
						timer.Simple( math.random(15,20), function()
							if IsValid(self) then
								self.AIType = AI
							end
						end )
						table.insert(self.StuffToRunInCoroutine,func)
						self:ResetAI()
						--self:Speak("NearMassacre")
					else
						--self:Speak("FriendKilledByEnemy")
					end
				end
				
			end
		end
	elseif rel == "foe" and !victim.BeenNoticed then
		victim.BeenNoticed = true
		local spoke = false
		self.CountedEnemies = self.CountedEnemies+1
		if self.CountedEnemies > 4 and !self.MentionedSpree then
			self.MentionedSpree = true
			timer.Simple( 30, function()
				if IsValid(self) then
					self.MentionedSpree = false
				end
			end )
			--self:Speak("KillingSpree")
			self.Taunting = true
			timer.Simple( 2, function()
				if IsValid(self) then
					self.Taunting = false
				end
			end )
			local func = function()
				if self.IsInVehicle then return end
				if self.IsSergeant then
					self:PlaySequenceAndPWait("Signal_Advance",1,self:GetPos())
				else
					if math.random(1,2) == 1 then
						self:PlaySequenceAndWait("Taunt")
					else
						self:PlaySequenceAndWait("Taunt_Shakefist")
					end
				end
			end
			table.insert(self.StuffToRunInCoroutine,func)
		end
		timer.Simple( 60, function()
			if IsValid(self) then
				self.CountedEnemies = self.CountedEnemies-1
			end
		end )
	end
	if victim == self.Enemy then
		local new = self:GetATarget()
		if !IsValid(new) and math.random(1,2) == 1 then
			self.SpecificGoal = victim:GetPos()
			local func = function()
				if self.IsInVehicle then return end
				self:MoveToPosition(self.SpecificGoal+((self:WorldSpaceCenter()-(self.SpecificGoal)):GetNormalized()*80),self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier)
				local lim = math.random(4,6)
				local old = self.Weapon.Fire_AngleOffset
				self.Weapon.Fire_AngleOffset = Angle(math.AngleDifference(self:GetAimVector():Angle().p,self:EyeAngles().p),math.AngleDifference(self:EyeAngles().y,self:GetAimVector():Angle().y),0)
				for i = 1, lim do
					timer.Simple( (self.Weapon.Primary.Delay*i), function()
						if IsValid(self) then
							self.Weapon:ShootBullets()
							self.Weapon:FiringEffects()
							self.Weapon:EmitSound( self.Weapon.Sound, self.Weapon.Sound_Vol, self.Weapon.Sound_Pitch, 1, CHAN_WEAPON )
							self:OnFiring()
							if i == lim then self.SpecificGoal = nil self.Weapon.Fire_AngleOffset = old end
						end
					end )
				end
			end
			table.insert(self.StuffToRunInCoroutine,func)
		end
	end
end

function ENT:KeyDown(s)
	local fuckoff = true
	return false
end

function ENT:ViewPunch()
	-- STFU
end

function ENT:GetEyeTrace(pos)
	return util.TraceLine({start = self:GetShootPos(), endpos = pos, filter = self})
end

function ENT:GetAimVector(pos)
	if self.IsControlled then
		return self.DPly:GetAimVector()
	end
	local dir
	if self.SpecificGoal then
		dir = (self.SpecificGoal-self:GetShootPos()):GetNormalized()
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
		return dir or self:GetForward()
	end
end

function ENT:StartChasing( ent, anim, speed, los )
	self:StartActivity( anim )			-- Move animation
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,los)
end

ENT.NextUpdateT = CurTime()

ENT.UpdateDelay = 0.5

ENT.TraceMask = MASK_ALL

function ENT:ChaseEnt(ent,los)
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( self.PathMinLookAheadDistance )
	path:SetGoalTolerance( self.PathGoalTolerance )
	if !IsValid(ent) then return end
	path:Compute( self, ent:GetPos() )
	if ( !path:IsValid() ) then return "Failed" end
	while ( path:IsValid() and IsValid(ent) ) do
		if self.NextUpdateT < CurTime() then
			self.NextUpdateT = CurTime()+self.UpdateDelay
			local cansee, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
			if IsValid(obstr) and ( ( obstr:IsNPC() or obstr:IsPlayer() or obstr:IsNextBot() ) and obstr:Health() > 0 ) and self:CheckRelationships(obstr) == "foe" then
				self:SetEnemy(obstr)
				return "New Target"
			end
			local dist = self:GetPos():DistToSqr(ent:GetPos())
			if !los and cansee then
				return "Obtained LOS"
			elseif los and cansee and dist < self.ShootDist^2 then
				return "Obtained range"
			end
			if self.loco:GetVelocity():IsZero() and self.loco:IsAttemptingToMove() then
				-- We are stuck, don't bother
				return "Give up"
			end
			if dist < self.MeleeRange^2 then
				return self:DoMelee()
			elseif dist > self.LoseEnemyDistance^2 then
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				return "Lost enemy"
			end
		end
		if path:GetAge() > self.RebuildPathTime then
			if self.OnRebuildPath == true then
				self:OnRebuiltPath()
			end	
			path:Compute( self, ent:GetPos() )
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
end

function ENT:OnFiring()
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
		self:SetPoseParameter("walk_yaw",di)
	end
	local look = false
	local goal
	local y
	local di = 0
	local p
	local dip = 0
	if IsValid(self.Enemy) or self.SpecificGoal then
		goal = self.SpecificGoal
		if IsValid(self.Enemy) then
			goal = self.Enemy:WorldSpaceCenter()
		end
		local an = (goal-self:WorldSpaceCenter()):Angle()
		y = an.y
		di = math.AngleDifference(self:GetAngles().y,y)
		p = an.p
		dip = math.AngleDifference(self:GetAngles().p,p)
		if self.IsInVehicle then
			if !self.Transitioned and self.VehicleRole == "Gunner" then
				local vy = math.AngleDifference(self.Vehicle:GetAngles().y+self.LTPP,y)
				local vp = math.AngleDifference(self.Vehicle:GetAngles().p+self.LTP,p)
				self.Transitioned = true
				timer.Simple(0.01, function()
					if IsValid(self) then
						self.Transitioned = false
					end
				end )
				if math.abs(vy) > 5 then
					self.LTPP = self.Vehicle:GetPoseParameter("turret_yaw")
					local i
					if vy < 0 then
						i = 2
					else
						i = -2
					end
					self:SetAngles(Angle(self.Vehicle:GetAngles().p,self:GetAngles().y+i,self.Vehicle:GetAngles().r))
					self.Vehicle:SetPoseParameter("turret_yaw",self.LTPP+i)
					self.GunnerShoot = false
				else
					self.GunnerShoot = true
				end
				if math.abs(vp) > 2 then
					self.LTP = self.Vehicle:GetPoseParameter("spin_cannon")
					local i
					if (vp/2) <= self.LTP then
						i = -1
					else
						i = 1
					end
					self.Vehicle:SetPoseParameter("spin_cannon",self.LTP+i)
				end
			end
		end
	end
	self:SetPoseParameter("aim_yaw",-di)
	self:SetPoseParameter("aim_pitch",-dip)
	if !self.DoingFlinch and self:Health() > 0 and !self.ThrowingGrenade and !self.DoingMelee and !self.Taunting and !self.ThrowGrenade then
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