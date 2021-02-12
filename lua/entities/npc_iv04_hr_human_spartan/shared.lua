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

ENT.VoiceType = "Spartan"

ENT.PossibleWeapons = {
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_dmr",
	"astw2_haloreach_dmr",
	"astw2_haloreach_shotgun",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_magnum",
	"astw2_haloreach_magnum",
	"astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"
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

function ENT:StartChasing( ent, anim, speed, los )
	if !los then anim = self.SprintAnim speed = speed*2 end
	self:StartActivity( anim )			-- Move animation
	self.loco:SetDesiredSpeed( speed )		-- Move speed
	self:ChaseEnt(ent,los)
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
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_All_Melee_03"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_All_Single_05"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_All_Single_05"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_All_Single_05"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_All_Melee_06"))}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_PISTOL"))
		self.SprintAnim = self:GetSequenceActivity(self:LookupSequence("Run_All_01"))
		self.Weapon.BurstLength = 2
		self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Pistol"))
		if self.Weapon:GetClass() == "astw2_haloreach_plasma_pistol" then
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Sniper"))
			self.MeleeAnim = "Bash_1hand_1"
		else
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Grenade_Launcher"))
			self.MeleeAnim = "Bash_1hand_2"
			--self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Crossbow"))
		end
		self.AirAnim = "Jump_PISTOL"
		self.LandAnim = "Land_Soft"
		self.LandHardAnim = "Land_Hard"
		self.SurpriseAnim = "Surprised_2handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_PISTOL"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_All_Single_05"))}
		self.GrenadeAnim = "Attack_GRENADE"
		self.WarthogPassengerIdle = "Warthog_Passenger_Idle_Rifle"
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
		self.SprintAnim = self:GetSequenceActivity(self:LookupSequence("Run_All_02"))
		if self.Weapon:GetClass() == "astw2_haloreach_sniper_rifle" then
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Sniper"))
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Ar2"))
			self.MeleeAnim = "Bash_2hands_5"
			self.Weapon.BurstLength = 1
		elseif self.Weapon:GetClass() == "astw2_haloreach_grenade_launcher" then
			--self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Grenade_Launcher"))
			self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_Ar2"))
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
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_All_Automatic_02"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_All_Automatic_02"))}
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_All_Single_07"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_All_Automatic_02"))}
		self.RunCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_All_Single_07"))}
		self.ShootAnim = self:GetSequenceActivity(self:LookupSequence("Attack_Rpg"))
		self.SprintAnim = self:GetSequenceActivity(self:LookupSequence("Run_All_02"))
		self.Weapon.BurstLength = 2
		self.ReloadAnim = self:GetSequenceActivity(self:LookupSequence("Reload_RPG"))
		self.MeleeAnim = "Bash_2hands_3"
		self.AirAnim = "Jump_RPG"
		self.LandAnim = "Land_Soft"
		self.LandHardAnim = "Land_Hard"
		self.SurpriseAnim = "Surprised_2handed"
		self.CrouchIdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Crouch_RPG"))}
		self.CrouchMoveAnim = {self:GetSequenceActivity(self:LookupSequence("Cwalk_All_Single_07"))}
		self.GrenadeAnim = "Attack_GRENADE"
		self.WarthogPassengerIdle = "Warthog_Passenger_Idle_Rifle"
		self.AllowGrenade = true
		self.CanShootCrouch = true
		self.CanMelee = true
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

function ENT:CustomBehaviour(ent,range)
	ent = ent or self.Enemy
	if !IsValid(ent) then self:GetATarget() end
	if !IsValid(self.Enemy) then return else ent = self.Enemy end
	local mins, maxs = ent:GetCollisionBounds()
	local los, obstr = self:IsOnLineOfSight(self:WorldSpaceCenter()+self:GetUp()*40,ent:WorldSpaceCenter()+ent:GetUp()*(maxs*0.25),{self,ent,self:GetOwner()})	if IsValid(obstr) then	
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
				if math.random(1,2) == 1 then
					self:Speak("OnCover")
				end
				return
			end
		end
		if !IsValid(ent) then return end
		local wait = math.Rand(1,1.5)
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
			if math.random(1,2) == 1 then
				self:Speak("OnCover")
			end
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
		
			if self.StopShoot then
				self:Speak("OnCharge")
				self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,true)
			end
			if !IsValid(ent) then return end
	
			local wait = math.Rand(1,1.5)
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
		
			self:Speak("OnInvestigate")
		
			self:StartChasing(self.Enemy,self.RunAnim[math.random(#self.RunAnim)],self.MoveSpeed*self.MoveSpeedMultiplier,false)
		
		end
		
	end
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