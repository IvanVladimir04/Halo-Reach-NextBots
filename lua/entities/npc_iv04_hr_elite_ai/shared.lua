AddCSLuaFile()
include("voices.lua")
ENT.Base 			= "npc_iv04_weaponuserbase"
ENT.PrintName = "Elite"
ENT.StartHealth = 50
ENT.MoveSpeed = 100
ENT.MoveSpeedMultiplier = 2.3
ENT.BehaviourType = 3
ENT.BulletNumber = 1
ENT.IdleSoundDelay = math.random(45,60)
ENT.Models = {}
ENT.SightType = 2
ENT.OnMeleeImpactSoundTbl = { "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit1.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit2.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit3.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit4.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit5.ogg" }
ENT.OnMeleeSwordImpactSoundTbl = { "halo/halo_reach/weapons/sword_hit_char1.ogg", "halo/halo_reach/weapons/sword_hit_char2.ogg", "halo/halo_reach/weapons/sword_hit_char3.ogg", "halo/halo_reach/weapons/sword_hit_char4.ogg", "halo/halo_reach/weapons/sword_hit_char5.ogg" }
ENT.Brute_OnMeleeImpactSoundTbl = { "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit1.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit2.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit3.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit4.ogg", "halo_reach/materials/organic_flesh/melee_impact/new_flesh_hit5.ogg" }

ENT.HasArmor = true

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

ENT.BloodEffect = "halo_reach_blood_impact_elite"

ENT.NPSound = 0

ENT.NISound = 0

ENT.CanUse = true

ENT.SearchJustAsSpawned = false

ENT.CustomIdle = true

ENT.Shield = 79

ENT.Faction = "FACTION_COVENANT"

ENT.AIType = "Offensive"

ENT.ExtraSpread = 0

ENT.ShootDist = 1024

ENT.SightDistance = 2048

ENT.CanUse = true

ENT.GrenadeRange = 1024

ENT.GrenadeChances = 30

ENT.MeleeDamage = 45

ENT.SeenVehicles = {}

ENT.CountedVehicles = 0

ENT.MaxShield = 79

ENT.ShieldRegen = 7.9

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

ENT.IsElite = true

ENT.ActionTime = 2.5

function ENT:OnInitialize()
	self.AIType = GetConVar("halo_reach_nextbots_ai_type"):GetString() or self.AIType
	self:Give(self.StartWeapons[math.random(#self.StartWeapons)])
	self.Difficulty = GetConVar("halo_reach_nextbots_ai_difficulty"):GetInt()
	self.Weapon.Primary.Damage = ((self.Weapon.Primary.Damage*self.Difficulty)*0.5)
	self:SetupHoldtypes()
	self:DoInit()
	self.StartPosition = self:GetPos()
	if self.IsBrute then 
		self.VoiceType = "Brute"
	else 
		self.VoiceType = "Elite"
		if GetConVar("halo_reach_nextbots_ai_great_schism"):GetInt() != 1 then
			self.FriendlyToPlayers = true
			self.Faction = "FACTION_UNSC"
		end
	end
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
		if self.IsBrute then
			self:StartActivity(self:GetSequenceActivity(self:LookupSequence(self.AirDeathAnim)))
		else
			self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Dead_Airborne_"..math.random(1,2).."")))
		end
	else
		if self.Leaped and self.IsBrute and self.IsAChasingEnemy then
			self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Leap_Hammer")))
		end
	end
end

function ENT:OnLandOnGround(ent)
	if self.FlyingDead then
		self.HasLanded = true
	else
		if self.Leaped and self.IsAChasingEnemy and self.IsBrute then
			local func = function()
				timer.Simple( 0.8, function()
					if IsValid(self) then
						self.Weapon:MeleeAttack()
					end
				end )
				self:PlaySequenceAndWait("Hammer_Melee2")
				self.Leaped = false
			end
			table.insert(self.StuffToRunInCoroutine,func)
			self:ResetAI()
		end
	end
end

function ENT:Speak(voice)
	local character = self.Voices["Elite"]
	if self.IsBrute then character = self.Voices["Brute"] end
	if self.CurrentSound then self.CurrentSound:Stop() end
	if character[voice] and istable(character[voice]) then
		local sound = table.Random(character[voice])
		self.CurrentSound = CreateSound(self,sound)
		self.CurrentSound:SetSoundLevel(100)
		self.CurrentSound:Play()
	end
end

function ENT:BeforeThink()
	local valid = IsValid(self.Enemy)
	if self.NISound < CurTime() and !valid then
		self:Speak("OnIdle")
		self.NISound = CurTime()+self.IdleSoundDelay
	elseif self.NISound < CurTime() and valid then
		self:Speak("OnAttack")
		self.NISound = CurTime()+self.IdleSoundDelay
	end
end

ENT.CanTrade = true

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
		elseif self.CanTrade and IsValid(ply:GetActiveWeapon()) and IsValid(self.Weapon) and self.Weapon:GetClass() != ply:GetActiveWeapon():GetClass() and self.TotalHolds[ply:GetActiveWeapon().HoldType_Aim] then
			self.CanUse = false
			local stop = false
			for i = 1, 200 do
				timer.Simple( 0.01*i, function()
					if stop then return end
					if IsValid(self) and IsValid(self.Weapon) then
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
	["smg"] = true,
	["revolver"] = true
}

ENT.HammerHolds = {
	["melee2"] = true
}

ENT.TotalHolds = {
	["crossbow"] = true,
	["ar2"] = true,
	["shotgun"] = true,
	["pistol"] = true,
	["revolver"] = true,
	["smg"] = true,
	["rpg"] = true
}

ENT.WeaponBursts = {
	["astw2_haloreach_magnum"] = 4,
	["astw2_haloreach_needler"] = 3,
	["astw2_haloreach_plasma_rifle"] = 2,
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
	self.WarthogDriverEnter = "Warthog_Driver_Enter"
	self.WarthogDriverExit = "Warthog_Driver_Exit"
	self.WarthogDriverIdle = "Warthog_Idle"
	self.WarthogPassengerEnter = "Warthog_Passenger_Enter"
	self.WarthogPassengerExit = "Warthog_Passenger_Exit"
	self.WarthogGunnerEnter = "Warthog_Gunner_Enter"
	self.WarthogGunnerExit = "Warthog_Gunner_Exit"
	self.WarthogGunnerIdle = "Ghost_Idle"
	if self.WeaponBursts[self.Weapon:GetClass()] then
		self.Weapon.BurstLength = self.WeaponBursts[self.Weapon:GetClass()]
	end
	--print(hold)
	if self.IsBrute then
		self.SpiritPassengerIdleAnims = {
			[1] = "Spirit_Passenger_Idle_1",
			[2] = "Spirit_Passenger_Idle_2",
			[3] = "Spirit_Passenger_Idle_3",
			[4] = "Spirit_Passenger_Idle_4"
		}
		self.SpiritPassengerExitAnims = {
			[1] = "Spirit_Passenger_Exit_1",
			[2] = "Spirit_Passenger_Exit_2",
			[3] = "Spirit_Passenger_Exit_3",
			[4] = "Spirit_Passenger_Exit_4"
		}
		if self.HammerHolds[hold] then
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Hammer"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Hammer"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Hammer")),self:GetSequenceActivity(self:LookupSequence("Run_Hammer1")),self:GetSequenceActivity(self:LookupSequence("Run_Hammer2")),self:GetSequenceActivity(self:LookupSequence("Run_Hammer3"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Hammer"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Hammer")),self:GetSequenceActivity(self:LookupSequence("Run_Hammer1")),self:GetSequenceActivity(self:LookupSequence("Run_Hammer2")),self:GetSequenceActivity(self:LookupSequence("Run_Hammer3"))}
			self.MeleeAnim = {"Hammer_Melee1","Hammer_Melee2","Hammer_Melee3","Hammer_Melee4"}
			self.MeleeBackAnim = "Hammer_Melee_Back"
			--self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Rifle_"..math.random(1,3)..""))
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Rifle"))
			self.CalmTurnLeftAnim = "Hammer_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Hammer_Turn_Right_Idle"
			self.TurnLeftAnim = "Hammer_Turn_Left_Idle"
			self.TurnRightAnim = "Hammer_Turn_Right_Idle"
			self.SurpriseAnim = "Taunt_Hammer_Point"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_Rifle"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Rifle"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Rifle"
			self.IsAChasingEnemy = true
			self.CanMelee = false
		elseif self.RifleHolds[hold] then
			self.Weapon.BurstLength = math.random(3,5)
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Rifle"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Rifle"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Rifle"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))}
			self.MeleeAnim = {"Rifle_Melee"}
			--self.MeleeBackAnim = "Rifle_Melee_Back"
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Rifle_"..math.random(1,3)..""))
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Rifle"))
			self.CalmTurnLeftAnim = "Rifle_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Rifle_Turn_Right_Idle"
			self.TurnLeftAnim = "Rifle_Turn_Left_Idle"
			self.TurnRightAnim = "Rifle_Turn_Right_Idle"
			self.SurpriseAnim = "Taunt_Rifle_Surprise"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_Rifle"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Rifle"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Rifle"
			--self.AllowGrenade = true
			self.CanShootCrouch = false
			self.CanMelee = true
		end
	else
		self.DropshipPassengerIdleAnims = {
			[1] = "Phantom_Passenger_Idle_1",
			[2] = "Phantom_Passenger_Idle_2"
		}
		self.DropshipPassengerExitAnims = {
			[1] = "Phantom_Passenger_Exit_1",
			[2] = "Phantom_Passenger_Exit_2"
		}
		self.SpiritPassengerIdleAnims = {
			[1] = "Spirit_Passenger_Idle_1",
			[2] = "Spirit_Passenger_Idle_2"
		}
		self.SpiritPassengerExitAnims = {
			[1] = "Spirit_Passenger_Exit_1",
			[2] = "Spirit_Passenger_Exit_2"
		}
		if self.PistolHolds[hold] then
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Pistol"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Pistol"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Pistol"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Pistol"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Pistol"))}
			self.MeleeAnim = {"Pistol_Melee_1","Pistol_Melee_2"}
			self.MeleeBackAnim = "Pistol_Melee_Back"
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Pistol"))
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Pistol"))
			self.CalmTurnLeftAnim = "Pistol_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Pistol_Turn_Right_Idle"
			self.TurnLeftAnim = "Pistol_Turn_Left_Idle"
			self.TurnRightAnim = "Pistol_Turn_Right_Idle"
			self.SurpriseAnim = "Surprised_1handed"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_PISTOL"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_Pistol"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Rifle"
			self.AllowGrenade = true
			self.CanShootCrouch = true
			self.CanMelee = true
		elseif self.RifleHolds[hold] then
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Rifle"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Rifle"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Rifle"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))}
			self.MeleeAnim = {"Rifle_Melee_1","Rifle_Melee_2"}
			self.MeleeBackAnim = "Rifle_Melee_Back"
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Rifle"))
			if self.Weapon:GetClass() == "astw2_haloreach_sniper_rifle" then
				self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Sniper"))
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
			self.CalmTurnLeftAnim = "Rifle_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Rifle_Turn_Right_Idle"
			self.TurnLeftAnim = "Rifle_Turn_Left_Idle"
			self.TurnRightAnim = "Rifle_Turn_Right_Idle"
			self.SurpriseAnim = "Surprised_2handed"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_Rifle"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_Rifle"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Rifle"
			self.AllowGrenade = true
			self.CanShootCrouch = true
			self.CanMelee = true
		elseif hold == "rpg" then
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Missile"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Missile"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Missile"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Missile"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Missile"))}
			self.MeleeAnim = {"Missile_Melee_1","Missile_Melee_2"}
			self.MeleeBackAnim = "Missile_Melee_Back"
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Missile"))
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Missile"))
			self.CalmTurnLeftAnim = "Missile_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Missile_Turn_Right_Idle"
			self.TurnLeftAnim = "Missile_Turn_Left_Idle"
			self.TurnRightAnim = "Missile_Turn_Right_Idle"
			self.SurpriseAnim = "Surprised_2handed"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_Missile"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_Missile"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Rifle"
			self.AllowGrenade = true
			self.CanShootCrouch = true
			self.CanMelee = true
		elseif hold == "physgun" then
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Turret"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Turret"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Turret"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Turret"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Turret"))}
			self.MeleeAnim = {"Rifle_Melee_1","Rifle_Melee_2"}
			self.MeleeBackAnim = "Rifle_Melee_Back"
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Turret"))
			
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Turret"))
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Physgun"))
			self.CalmTurnLeftAnim = "Turret_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Turret_Turn_Right_Idle"
			self.TurnLeftAnim = "Turret_Turn_Left_Idle"
			self.TurnRightAnim = "Turret_Turn_Right_Idle"
			self.SurpriseAnim = "Surprised_2handed"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Turret"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Turret"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Turret"
			self.AllowGrenade = false
			self.CanShootCrouch = false
			self.CanCrouch = false
			self.CanMelee = false
		elseif hold == "melee" or hold == "knife" then
			self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Sword"))}
			self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Sword"))}
			self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Sword"))}
			self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Sword"))}
			self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Sword"))}
			self.MeleeAnim = {"Sword_Melee_1","Sword_Melee_2","Sword_Melee_3","Sword_Melee_4","Sword_Melee_5"}
			self.MeleeBackAnim = nil
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Sword_Melee_1"))
			self.MeleeDamage = 200
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Pistol"))
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Sword_Melee_1"))
			self.CalmTurnLeftAnim = "Sword_Turn_Left_Idle"
			self.CalmTurnRightAnim = "Sword_Turn_Right_Idle"
			self.TurnLeftAnim = "Sword_Turn_Left_Idle"
			self.TurnRightAnim = "Sword_Turn_Right_Idle"
			self.SurpriseAnim = "Surprised_2handed"
			self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_Sword"))}
			self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_Sword"))}
			self.GrenadeAnim = "Attack_GRENADE_Throw"
			self.WarthogPassengerIdle = "Sit_Sword"
			self.AllowGrenade = true
			self.CanShootCrouch = false
			self.CanMelee = true
			self.IsAChasingEnemy = true
		end
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
			p:SetVelocity(d*1)
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
					if self.InPhantom then
						anim = self.DropshipPassengerIdleAnims[math.random(#self.DropshipPassengerIdleAnims)]
					else
						anim = self.SpiritPassengerIdleAnims[math.random(#self.SpiritPassengerIdleAnims)]
					end
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
		else
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
			ParticleEffect( self.BloodEffect, dmg:GetDamagePosition(), Angle(0,0,0), self )
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
	if self:Health() - math.abs(total) < (self.StartHealth*0.5) and !self.Reacted then
		self.Reacted = true
		if math.random(1,2) == 1 then
			self:Speak("OnBerserk")
			self.Berserk = true
			local func = function()
				local anim = "Taunt_Berserk"
				if self.IsBrute then anim = "Berserk_"..math.random(1,2).."" end
				local act = self:GetActivity()
				
				self:StartActivity(self:GetSequenceActivity(self:LookupSequence(anim)))
				self.Berserking = true
				while (self:GetCycle() != 1 ) do
					coroutine.yield()
				end
				self.Berserking = false
				self:StartActivity(act)
			end
			self.ActionTime = self.ActionTime*0.8 -- Act 20% faster
			self.Weapon.BurstLength = self.Weapon.BurstLength*1.20 -- Bursts of weapons are 20% larger
			table.insert(self.StuffToRunInCoroutine,func)
		end
	end
	local rel = self:CheckRelationships(dmg:GetAttacker())
	if !IsValid(self.Enemy) then
		if rel == "foe" then
			self:Speak("OnAlert")
			self:SetEnemy(dmg:GetAttacker())
		end
	else
		if rel == "foe" and !self.Switched then 
			self.Switched = true
			timer.Simple( math.random(5,10), function()
				if IsValid(self) then
					self.Switched = false
				end
			end )
			self:SetEnemy(dmg:GetAttacker()) 
		end
	end
end

ENT.Variations = {
	[ACT_FLINCH_CHEST] = {["Back"] = "flinch_back_chest", ["Front"] = "flinch_front_chest"},
	[ACT_FLINCH_STOMACH] = {["Back"] = "flinch_back_gut", ["Front"] = "flinch_front_gut"}
}

ENT.HeadHitGroup = 7

function ENT:OnTraceAttack( info, dir, trace )
	--print(trace.HitGroup)
	if trace.HitGroup == self.HeadHitGroup then
		if ( !self.HasHelmet and ( !self.HasArmor or self.Shield < 1) ) then
			info:ScaleDamage(3)
		elseif ( self.Shield <= 0 or !self.HasArmor ) and self.HasHelmet then
			self.HasHelmet = false
			local prop = ents.Create("prop_physics")
			prop:SetModel(self.HelmetModel)
			prop:SetPos(info:GetDamagePosition())
			prop:SetOwner(self)
			prop:SetAngles(self:GetAngles())
			prop:Spawn()
			self:SetBodygroup(self.HelmetBodygroup,1)
			info:ScaleDamage(0)
			if IsValid(prop:GetPhysicsObject()) then
				prop:GetPhysicsObject():Wake()
				prop:GetPhysicsObject():SetVelocity( trace.Normal*info:GetDamage()+self:GetUp()*100 )
			end
			timer.Simple( 10, function()
				if IsValid(prop) then
					prop:Remove()
				end
			end )
		end
	end
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	if self.Shield > 0 and self.HasArmor then
		ParticleEffect( "halo_reach_shield_impact_effect", info:GetDamagePosition(), Angle(0,0,0), self )
		sound.Play( "halo_reach/materials/energy_shield/sheildhit" .. math.random(1,3) .. ".ogg",  info:GetDamagePosition(), 100, 100 )
	end
	--if !self.DoingFlinch and info:GetDamage() > self.FlinchDamage then
		--if self.FlinchHitgroups[trace.HitGroup] then
		--	local act
			--if self.Variations[self.FlinchHitgroups[trace.HitGroup]] then
				--act = self.FlinchHitgroups[trace.HitBox]
			--	local ang = dir:Angle().y-self:GetAngles().y
				--local tbl = self.Variations[self.FlinchHitgroups[trace.HitGroup]]
				--if ang < 1 then ang = ang + 360 end
				--if ( ang < 90 or ang > 270 ) then
				---	act = tbl["Back"]
				--else
				--	act = tbl["Front"]
				--end
			--else
				--act = self:SelectWeightedSequence(self.FlinchHitgroups[trace.HitGroup])
			--end
			--self.DoingFlinch = true
			--local id, dur = self:LookupSequence(act)
			--timer.Simple(dur, function()
			--	if IsValid(self) then
					--self.DoingFlinch = false
			--	end
			--end )
			--local func = function()
			--	self:PlaySequenceAndWait(id)
			--	self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
			--end
			--table.insert(self.StuffToRunInCoroutine,func)
			--self:ResetAI()
		--end
	--end
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
			local goal = self.FollowingPlayer:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300
			local navs = navmesh.Find(goal,256,100,20)
			local nav = navs[math.random(#navs)]
			local pos = goal
			if nav then pos = nav:GetRandomPoint() end
			self:WanderToPosition( (pos), self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed )
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
	local t = self:SequenceDuration(seq)/2
	if t < 0.5 then t = 0.5 end
	timer.Simple( t, function()
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
			--victim.BeenNoticed = true
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
									--v:Speak("AllianceReformed")
								end
							end
						end )
					end
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
						--self:Speak("NearMassacre")
					else
						--self:Speak("FriendKilledByEnemy")
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
			--self:Speak("KillingSpree")
		end
		timer.Simple( 30, function()
			if IsValid(self) then
				self.CountedEnemies = self.CountedEnemies-1
			end
		end )
		if victim:IsPlayer() then
			self:Speak("OnKillPlayer")
			spoke = true
			for id, v in ipairs(self:LocalAllies()) do
				if !v.SpokeAllyKill then
					v.SpokeAllyKill = true
					--v:Speak("KilledEnemyPlayerAlly")
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
				--self:Speak("KilledFloodCombat")
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
				--self:Speak("KilledEnemyFloodCarrier")
				spoke = true
				for id, v in ipairs(self:LocalAllies()) do
					if !v.SpokeAllyKill then
						v.SpokeAllyKill = true
						--v:Speak("KilledEnemyFloodCarrierAlly")
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
			--self:Speak("KilledEnemySentinel")
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
					self:WanderToPosition( self.LastSeenEnemyPos, self.RunAnim[1], self.MoveSpeed*self.MoveSpeedMultiplier )
					self:Speak("OnTaunt")
				end
				table.insert(self.StuffToRunInCoroutine,func)
			end
		elseif !spoke then
			if info:GetDamageType() == DMG_BLAST then
				--self:Speak("KilledEnemyGrenade")
			elseif IsValid(self.Vehicle) then
				--self:Speak("KilledEnemyMountedWeapon")
			elseif IsValid(info:GetInflictor()) and self:CheckRelationships(info:GetInflictor():GetOwner()) == "friend" then
				--self:Speak("KilledEnemyGrenade")
				--self:NearbyReply("AllyKillGrenade")
			else
				--self:Speak("KilledEnemyBullet")
			end
		end
	end
end

function ENT:ThrowGrenade(range,ent)
	ent = ent or self.Enemy
	if !IsValid(ent) then return end
	local pos = ent:GetPos()
	self:Speak("OnGrenadeThrow")
	timer.Simple( 0.3, function()
		if IsValid(self) and !self.DoingFlinch then
			ent = ent or self.Enemy
			local gre = ents.Create("astw2_haloreach_plasma_thrown")
			gre:SetPos(self:WorldSpaceCenter()+self:GetRight()*-40)
			gre:SetAngles(self:GetAngles())
			gre:SetOwner(self)
			gre:Spawn()
			gre:Activate()
			local p = gre:GetPhysicsObject()
			if IsValid(p) then
				p:Wake()
				p:SetVelocity( (self:GetAimVector() * 1000)+(self:GetUp()*(math.random(10,50)*5)) )
			end
		end
	end )
	self.ThrowedGrenade = true
	timer.Simple( math.random(10,15), function()
		if IsValid(self) then
			self.ThrowedGrenade = false
		end
	end )
	--self:Speak("ThrowGrenade")
	self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
	self:DoGesture(self.GrenadeAnim)
	coroutine.wait(0.5)
end

function ENT:HasToReload()
	return self.Weapon:Clip1() == 0
end

function ENT:DoMeleeDamage()
	if self.IsAChasingEnemy and self.IsBrute then
		self.Weapon:MeleeAttack()
	else
		local damage = self.MeleeDamage
		for	k,v in pairs(ents.FindInCone(self:GetPos()+self:OBBCenter(), self:GetForward(), self.MeleeRange,  math.cos( math.rad( self.MeleeConeAngle ) ))) do
			if v != self and self:CheckRelationships(v) != "friend" then
				local h = v:Health()
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
				if ( v:IsNPC() or v:IsNextBot() or v:IsPlayer() ) and h > 0 then
					if self.IsBrute then
						v:EmitSound( self.OnMeleeImpactSoundTbl[math.random(#self.OnMeleeImpactSoundTbl)] )
					else
						local we = IsValid(self.Weapon)
						if we and (self.Weapon:GetClass() == "astw2_haloreach_energysword") then
							v:EmitSound( self.OnMeleeSwordImpactSoundTbl[math.random(#self.OnMeleeSwordImpactSoundTbl)] )
							ParticleEffect( "astw2_halo_3_muzzle_plasma_turret", v:WorldSpaceCenter(), Angle(0,0,0), self )
						end
						if !we or (self.Weapon:GetClass() != "astw2_haloreach_energysword") then
							v:EmitSound( self.OnMeleeImpactSoundTbl[math.random(#self.OnMeleeImpactSoundTbl)] )
						end		
					end						
					break
				end
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
	if self.IsAChasingEnemy then
		return self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true,false)
	end
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
	elseif los and !self.DoneMelee and range < self.ChaseRange^2 then
		self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true,false)
	end
	if range > self.ShootDist^2 and ent:IsOnGround() then
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
	--[[if !self.IsSniper and ( ( ent.GetEnemy and ent:GetEnemy() == self ) or BeingStaredAt(self,ent,60) ) and los then
		if math.random(1,100) <= self.DodgeChance and !self.Dodged then
			local anim = seqs[math.random(1,2)]
			self:Speak("OnDodge")
			return self:Dodge(anim)
		end
	end]]
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
				return self:ThrowGrenade(range)
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
		coroutine.wait(math.Rand(0,1)+(self.ActionTime-(self.Difficulty*0.5)))
		
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
		local wait = math.Rand(0,1)+(self.ActionTime-(self.Difficulty*0.5))
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
					return self:ThrowGrenade(range)
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
		
		self.Weapon:AI_PrimaryAttack()
		
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
				self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true,true)
			end
			if !IsValid(ent) then return end
			local wait = math.Rand(0,1)+(self.ActionTime-(self.Difficulty*0.5))
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
					return self:ThrowGrenade(range)
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

			self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,false,true)
		
		end
		
	end
end

function ENT:DoMelee()
	local anim = self.MeleeAnim[math.random(#self.MeleeAnim)]
	local turn = false
	if IsValid(self.Enemy) then
		local ang = (self.Enemy:GetPos()-self:GetPos()):GetNormalized():Angle()
		local ydif = math.AngleDifference(self:GetAngles().y,ang.y)
		if self.MeleeBackAnim and math.abs(ydif) > 180 then
			anim = self.MeleeBackAnim
			turn = true
		else
			self:SetAngles(Angle(0,ang.y,0))
		end
	end	
	self.DoneMelee = true
	self.DoingMelee = true
	self:Speak("OnMelee")
	local t = math.random(5,10)
	if self.IsAChasingEnemy then t = 2 end
	timer.Simple( t, function()
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
	if self.IsAChasingEnemy then
		self:PlaySequenceAndWait(id)
	else
		self:PlaySequenceAndPWait(id,1,self:GetPos())
	end
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

function ENT:StartChasing( ent, anim, speed, los, far )
	self:StartActivity( anim )
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,los,far)
end

ENT.NextUpdateT = CurTime()

ENT.UpdateDelay = 0.5

function ENT:ChaseEnt(ent,los,far)
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( self.PathMinLookAheadDistance )
	path:SetGoalTolerance( self.PathGoalTolerance )
	if !IsValid(ent) then return end
	if los and far then
		local goal = ent:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300
		local navs = navmesh.Find(goal,512,100,20)
		local nav = navs[math.random(#navs)]
		local pos = goal
		if nav then pos = nav:GetRandomPoint() end
		path:Compute( self, pos )
	else
		path:Compute( self, ent:GetPos() )
	end
	if ( !path:IsValid() ) then return "Failed" end
	local saw = false
	while ( path:IsValid() and IsValid(ent) ) do
		if !los and !self.DoingLose then
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
			local cansee, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter(),{self,ent,self:GetOwner()})
			saw = cansee
			--print(cansee,los)
			if IsValid(obstr) and ( ( obstr:IsNPC() or obstr:IsPlayer() or obstr:IsNextBot() ) and obstr:Health() > 0 ) and self:CheckRelationships(obstr) == "foe" then
				self:SetEnemy(obstr)
				return "Got A New Target"
			end
			local dist = self:GetPos():DistToSqr(ent:GetPos())
			if !self.Leaped and self.IsBrute and self.IsAChasingEnemy and dist > 400^2 and dist < 600^2 and math.random(1,100) <= self.LeapChance then
				local ang = (self.Enemy:GetPos()-self:GetPos()):GetNormalized():Angle()
				self:SetAngles(Angle(0,ang.y,0))
				self.Leaped = true
				self.loco:JumpAcrossGap(self:GetPos()+self:GetForward()*512,self:GetForward())
				while (!self.loco:IsOnGround()) do
					coroutine.wait(0.01)
				end
				return "Jumped"
			end
			if dist < self.MeleeRange^2 then
				return self:DoMelee()
			elseif cansee and !los then
				return "Got LOS Back"
			elseif los and !self.IsAChasingEnemy and !far and dist < self.ShootDist^2 and dist > 250^2 then
				return "Got far"
			elseif los and far and dist < self.ShootDist^2 then
				return "GainedDistance"
			elseif dist > self.LoseEnemyDistance^2 then
				self:OnLoseEnemy()
				self:SetEnemy(nil)
				return "Lost enemy"
			end
			if cansee then
				self.LastSeenEnemyPos = ent:GetPos()
			end
		end
		if path:GetAge() > self.RebuildPathTime and (!los or !far) then
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
		self:Speak("OnAlert")
		self:ResetAI()
	else
		if self.LastTarget == ent then
			--self:Speak("OldEnemySighted")
		else
			self:Speak("OnAlertMoreFoes")
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
					v:Speak("OnAlert")
				end
				if v.OnHaveEnemy then
					v:OnHaveEnemy(ent)
				end
				timer.Simple( math.random(2,4), function()
					if IsValid(v) and IsValid(ent) then
						--v:Speak("AlertAllyResponse")
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
	if dm == DMG_BLAST then
		anim = "Dead_Airborne_"..math.random(1,2)..""
	end
	return anim
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.KilledDmgInfo = dmginfo
	self.BehaveThread = nil
	self:SetSkin(1)
	if !self.IsBrute then
		self:SetBodygroup(4,0)
	end
	self.DrownThread = coroutine.create( function() self:DoKilledAnim() end )
	coroutine.resume( self.DrownThread )
end

function ENT:DoKilledAnim()
	if self.KilledDmgInfo:GetDamageType() != DMG_BLAST then
		if self.KilledDmgInfo:GetDamage() <= 150 or ( self.DeathHitGroup and self.DeathHitGroups[self.DeathHitGroup] == "Head" ) then
			self:Speak("OnDeath")
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
			self:Speak("OnDeathPainful")
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
			rag = self:BecomeRagdoll(self.KilledDmgInfo)
		end
	else
		self:Speak("OnDeathPainful")
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
		if self.IsBrute then
			self:PlaySequenceAndWait("Dead_Land_"..math.random(1,2).."")
		else
			self:PlaySequenceAndWait("Dead_Land")
		end
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
			local a,len
			if self.ReloadAnim then
				a,len = self:LookupSequence(self:SelectWeightedSequence(self.ReloadAnim))
				self:DoGesture(self.ReloadAnim)
			end
			local func = function()
				self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
				if !len then len = 2 end
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
	return self.Difficulty*2 or 1
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

function ENT:FootstepSound()
	local character = self.Voices[self.VoiceType]
	if character["OnStep"] and istable(character["OnStep"]) then
		local sound = table.Random(character["OnStep"])
		self:EmitSound(sound,70)
	end
end

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if !self.loco:GetVelocity():IsZero() and self.loco:IsOnGround() then
		if !self.LMove then
			if self.VoiceType == "Elite" then self.LMove = CurTime()+0.35
					else self.LMove = CurTime()+0.43
			end
		else
			if self.LMove < CurTime() then
				self:FootstepSound()
				if self.VoiceType == "Elite" then self.LMove = CurTime()+0.35
					else self.LMove = CurTime() + 0.43
				end
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
	if !self.DoingFlinch and self:Health() > 0 and !self.Berserking and !self.Leaped and !self.DoingMelee and !self.Taunting then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
end

--[[list.Set( "NPC", "npc_iv04_hce_elite_minor", {
	Name = "Elite Minor",
	Class = "npc_iv04_hce_elite_minor",
	Category = "Halo Combat Evolved"
} )]] -- Oops I never commented this out