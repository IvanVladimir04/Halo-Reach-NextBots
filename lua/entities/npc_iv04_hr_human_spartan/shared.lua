AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Spartan"

ENT.Models = {
"models/halo_reach/players/spartan_male_1.mdl",
"models/halo_reach/players/spartan_male_2.mdl",
"models/halo_reach/players/spartan_male_3.mdl",
"models/halo_reach/players/spartan_male_4.mdl",
"models/halo_reach/players/spartan_male_5.mdl",
"models/halo_reach/players/spartan_male_6.mdl",
"models/halo_reach/players/spartan_male_7.mdl",
"models/halo_reach/players/spartan_male_8.mdl",
"models/halo_reach/players/spartan_male_9.mdl",
"models/halo_reach/players/spartan_male_10.mdl",
"models/halo_reach/players/spartan_male_11.mdl",
"models/halo_reach/players/spartan_male_12.mdl",
"models/halo_reach/players/spartan_male_13.mdl",
"models/halo_reach/players/spartan_male_14.mdl",
"models/halo_reach/players/spartan_male_15.mdl",
"models/halo_reach/players/spartan_male_16.mdl",
"models/halo_reach/players/spartan_male_17.mdl",
"models/halo_reach/players/spartan_male_18.mdl",
"models/halo_reach/players/spartan_male_19.mdl",
"models/halo_reach/players/spartan_male_20.mdl",
"models/halo_reach/players/spartan_male_21.mdl",
"models/halo_reach/players/spartan_male_22.mdl",
"models/halo_reach/players/spartan_male_23.mdl"
}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.MeleeDamage = 100

ENT.FlinchChance = 0

ENT.PossibleWeapons = {
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_dmr",
	"astw2_haloreach_dmr"
	--"astw2_haloreach_shotgun",
	--"astw2_haloreach_magnum"
	--[["astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"]]
}

ENT.Skins = {
	[1] = 0,
	[2] = 1,
	[3] = 2,
	[4] = 3,
	[5] = 4
}

ENT.BeenSurprised = true

function ENT:PreInit()
	self.ColR = math.random(255)
	self.ColG = math.random(255)
	self.ColB = math.random(255)
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	self:SetNWVector("SPColor",self:GetPlayerColor())
end

if CLIENT then

	function ENT:Initialize()
		--timer.Simple( 1, function()
			--print(self:GetNWVector("SPColor"))
		--	if IsValid(self) then
				self.GetPlayerColor = function()
					return self:GetNWVector("SPColor",Vector(0,0,0))
				end
			--end
	--	end )
	end

end

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:SetSkin(self.Skins[math.random(#self.Skins)])
	self:Give(wep)
	for i = 0, #self:GetBodyGroups() do
		self:SetBodygroup(i,math.random(0,self:GetBodygroupCount( i )-1))
	end
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
	self.DeadAirAnim = "Dead_Airborne"
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
		self.AirAnim = "Jump_Pistol"
		self.LandAnim = "Land_Pistol_Soft"
		self.LandHardAnim = "Land_Pistol_Hard"
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
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_All_02"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_All_Single_02"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_All_Single_02"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_All_Single_02"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_All_02"))}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Ar2"))
		if self.Weapon:GetClass() == "astw2_haloreach_sniper_rifle" then
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Sniper"))
			self.MeleeAnim = "Bash_2hands_5"
			self.Weapon.BurstLength = 1
		elseif self.Weapon:GetClass() == "astw2_haloreach_grenade_launcher" then
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Grenade_Launcher"))
			self.MeleeAnim = "Bash_2hands_4"
			self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Crossbow"))
		elseif hold == "ar2" then
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Ar2"))
			self.MeleeAnim = "Bash_2hands_1"
		elseif hold == "shotgun" then
			self.Weapon.Acc = 0
			self.Weapon.Primary.RecoilAcc = 0
			self.WeaponAccuracy = 9
			self.Weapon.BurstLength = 1
			self.MeleeAnim = "Bash_2hands_4"
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Shotgun"))
		else
			self.MeleeAnim = "Bash_2hands_2"
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Ar2"))
		end
		self.CalmTurnLeftAnim = "Passive_Turn_Left_Idle"
		self.CalmTurnRightAnim = "Passive_Turn_Right_Idle"
		self.TurnLeftAnim = "Rifle_Turn_Left_Idle"
		self.TurnRightAnim = "Rifle_Turn_Right_Idle"
		self.AirAnim = "Jump_AR2"
		self.LandAnim = "Land_Soft"
		self.LandHardAnim = "Land_Hard"
		self.SurpriseAnim = "Surprised_2handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_AR2"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_All_Single_02"))}
		self.GrenadeAnim = "Attack_GRENADE"
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
		self.AirAnim = "Jump_Missile"
		self.LandAnim = "Land_Soft"
		self.LandHardAnim = "Land_Hard"
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

function ENT:DoMelee()
	self:Speak("OnMelee")
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
	local anim = self.MeleeAnim
	local len = 1
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
	self:StartActivity(self.IdleAnim[math.random(#self.IdleAnim)])
	self:DoGestureSeq(anim)
	coroutine.wait(1)
end

function ENT:ThrowGrenade(dist)
	self.ThrowedGrenade = true
	timer.Simple( math.random(5,10), function()
		if IsValid(self) then
			self.ThrowedGrenade = false
		end
	end )
	self.ThrowingGrenade = true
	local grenade
	self:Speak("OnGrenadeThrow")
	timer.Simple( 0.2, function()
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
	timer.Simple( 0.3, function()
		if IsValid(self) and IsValid(grenade) then
			grenade:SetMoveType( MOVETYPE_VPHYSICS )
			grenade:SetParent( nil )
			grenade:SetPos(self:GetAttachment(2).Pos)
			local prop = grenade:GetPhysicsObject()
			if IsValid(prop) then
				prop:Wake()
				prop:EnableGravity(true)
				local vel = (self:GetUp()*(math.random(10,50)*5))
				vel = vel+((self:GetAimVector() * 600))
				prop:SetVelocity( vel )
			end
		end
	end )
	self:DoGestureSeq(self.GrenadeAnim)
	self.ThrowingGrenade = false
	coroutine.wait(1)
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
			self:WanderToPosition( (pos), self.RunCalmAnim[math.random(1,#self.RunCalmAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )	
		end
	elseif self.AIType == "Defensive" then
		local dist = self:GetRangeSquaredTo(self.StartPosition)
		if dist > 300^2 then
			self:WanderToPosition( (self.StartPosition + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300), self.RunCalmAnim[math.random(1,#self.RunCalmAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
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
			if !IsValid(self.Enemy) then
				--if self:CheckRelationships(attacker) == "foe" then
					local ang = (victim:GetPos()-self:GetPos()):Angle()
					local dif = math.AngleDifference(self:GetAngles().y,ang.y)
					local func = function()
						self:TurnTo(dif,false)
					end
					table.insert(self.StuffToRunInCoroutine,func)
					self:ResetAI()
				--end
				if attacker:IsPlayer() and self.FriendlyToPlayers then
					self.NoticedKills = self.NoticedKills+1
					if self.NoticedKills > 1 then
						self:Speak("OnBetrayal")
						self.FriendlyToPlayers = false
						self.LastAllyKill = CurTime()
						local last = self.LastAllyKill
						timer.Simple( 30, function()
							if IsValid(self) then
								if self.LastAllyKill == last then
									self.FriendlyToPlayers = true
									self.NoticedKills = 0
									self:SetEnemy(nil)
									self:Speak("OnForgive")
								end
							end
						end )
					else
						self:Speak("OnKillAlly")
					end
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
							self:Speak("OnForgive")
						end
					end
				end )
			else
				if self.SawAlliesDie then
					local AI = self.AIType
					self.AIType = "Defensive"
					local func = function()
						if self.IsSergeant and !self.IsInVehicle then
							HRHS:Signal("Retreat",self)
							self:PlaySequenceAndMove(self:LookupSequence("Signal_Fallback"),1,self:GetForward()*-1,50,0.7)
						else
							--print(HRHS:WasSignalGiven("Retreat",3))
							if !self.FollowingRetreatOrder and HRHS:WasSignalGiven("Retreat",3) and IsValid(HRHS:GetCaller("Retreat")) and (!IsValid(HRHS:GetCaller("Retreat").S1) or !IsValid(HRHS:GetCaller("Retreat").S2) ) then
								local leader = HRHS:GetCaller("Retreat")
								local goal = leader:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300
								local navs = navmesh.Find(goal,256,100,20)
								local nav = navs[math.random(#navs)]
								local pos = goal
								if nav then pos = nav:GetRandomPoint() end
								self.FollowingRetreatOrder = true
								if IsValid(leader.S1) then leader.S2 = self else leader.S1 = self end
								timer.Simple( math.random(4,10), function() if IsValid(self) then self.FollowingRetreatOrder = false end end )
								self:MoveToPosition( pos, self.RunAnim[math.random(1,#self.RunAnim)], self.MoveSpeed*self.MoveSpeedMultiplier )
								if leader.S1 == self then leader.S1 = nil elseif leader.S2 == self then leader.S2 = nil end
							end
						end
					end
					timer.Simple( math.random(20,30), function()
						if IsValid(self) then
							self.AIType = AI
						end
					end )
					table.insert(self.StuffToRunInCoroutine,func)
					self:ResetAI()
				--self:Speak("NearMassacre")
				end
			end
		end
	elseif rel == "foe" and !victim.BeenNoticed then
		--victim.BeenNoticed = true
		local spoke = false
		self.CountedEnemies = self.CountedEnemies+1
		if self.CountedEnemies > 4 and !self.MentionedSpree then
			self.MentionedSpree = true
			timer.Simple( 30, function()
				if IsValid(self) then
					self.MentionedSpree = false
				end
			end )
			self:Speak("OnTaunt")
			self.Taunting = true
			timer.Simple( 2, function()
				if IsValid(self) then
					self.Taunting = false
				end
			end )
			if self.IsSergeant or HRHS:WasSignalGiven(sign,4) then
				local AI = self.AIType
				self.AIType = "Offensive"
				timer.Simple( math.random(20,30), function()
					if IsValid(self) then
						self.AIType = AI
					end
				end )
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
		local spot = victim:WorldSpaceCenter() or self.RegisteredTargetPositions[victim]
		local new = self:GetATarget()
		if !IsValid(new) and self.AIType == "Offensive" and !self.ShootCorpseFilter[self:GetActiveWeapon():GetClass()] then
			if victim:IsPlayer() and !self.CommentedTraitorDeath then
				self.CommentedTraitorDeath = true
				timer.Simple( math.random(2,3), function()
					if IsValid(self) then
						self.CommentedTraitorDeath = false
					end
				end )
				self:Speak("OnKillPlayer")
			end
			if math.random(1,2) == 1 and isvector(spot) then
				self.SpecificGoal = spot
				local func = function()
					if self.IsInVehicle then return end
					coroutine.wait(1)
					self:WanderToPosition(spot+((self:WorldSpaceCenter()-(spot)):GetNormalized()*80),self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier)
					self:Speak("OnShootCorpse")
					local lim = math.random(4,6)
					local old = self.Weapon.Fire_AngleOffset
					self.Weapon.Fire_AngleOffset = Angle(math.AngleDifference(self:GetAimVector():Angle().p,self:EyeAngles().p),math.AngleDifference(self:EyeAngles().y,self:GetAimVector():Angle().y),0)
					for i = 1, lim do
						timer.Simple( (self.Weapon.Primary.Delay*i), function()
							if IsValid(self) and IsValid(self.Weapon) then
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
end

function ENT:BodyUpdate()
	local act = self:GetActivity()
	if !self.loco:GetVelocity():IsZero() and self.loco:IsOnGround() then
		if !self.LMove then
			self.LMove = CurTime()+0.3
		else
			if self.LMove < CurTime() then
				self:FootstepSound()
				self.LMove = CurTime()+0.3
			end
		end
		self:BodyMoveXY()
	else
		self.LMove = nil
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
				anim = "Death_6"
			elseif y < 225 and y > 135 then -- Front
				anim = "Death_11"
			elseif y >= 225 and y < 315 then -- Right
				anim = "Death_8"
			elseif y <= 45 or y >= 315 then -- Back
				anim = "Death"
			end
		else
			if y <= 135 and y > 45 then -- Right
				anim = "Death_10"
			elseif y < 225 and y > 135 then -- Front
				anim = "Death_4"
			elseif y >= 225 and y < 315 then -- Left
				anim = "Death_7"
			elseif y <= 45 or y >= 315 then -- Back
				anim = "Death"
			end
		end
	else
		return true
	end
	return anim
end

list.Set( "NPC", "npc_iv04_hr_human_spartan", {
	Name = "Spartan",
	Class = "npc_iv04_hr_human_spartan",
	Category = "Halo Reach"
} )