AddCSLuaFile()
ENT.Base = "npc_iv04_base"
ENT.PrintName = "Pelican"
ENT.Models  = {"models/halo_reach/vehicles/unsc/pelican.mdl"}

ENT.MoveSpeed = 300
ENT.MoveSpeedMultiplier = 1 -- When running, the move speed will be x times faster

ENT.Faction = "FACTION_UNSC"

ENT.StartHealth = 500

ENT.LoseEnemyDistance = 9999999

ENT.SightDistance = 9999999

ENT.BehaviourType = 3

ENT.DState = 1

ENT.NUT = 0

ENT.Preset = {}

ENT.FriendlyToPlayers = true

ENT.IsDropship = true

--ENT.TakeOffSounds = { "oddworld/strangers_wrath/dropship/fx_native4_01_drop01_takeoff.ogg", "oddworld/strangers_wrath/dropship/fx_native4_01_drop02_takeoff.ogg","oddworld/strangers_wrath/dropship/fx_native4_01_drop03_takeoff.ogg", "oddworld/strangers_wrath/dropship/fx_cargoship_fly_away.ogg" }
ENT.SoundIdle = { "vehicles/pelican_engine_pelengine.wav" }
--ENT.LandingSounds = { "oddworld/strangers_wrath/dropship/fx_drop01_landing.ogg", "oddworld/strangers_wrath/dropship/fx_drop02_landing.ogg","oddworld/strangers_wrath/dropship/fx_drop03_landing.ogg" }
--ENT.ShootSounds = { "oddworld/strangers_wrath/dropship/fx_dropship_missle.ogg" }
--ENT.OpenDoorSounds = { "oddworld/strangers_wrath/dropship/fx_dropship_doors_open.ogg" }
--ENT.CloseDoorSounds = { "oddworld/strangers_wrath/dropship/fx_dropship_doors_close.ogg" }
--ENT.FlySounds = { "oddworld/strangers_wrath/dropship/fx_dropship_flyby1_r05w.ogg", "oddworld/strangers_wrath/dropship/fx_dropship_flyby2.ogg" }

function ENT:HandleAnimEvent(event,eventTime,cycle,type,options)
	--[[if options ==  "event_osw_dropship_deploy" then
		self:DeploySquad()
	end]]
end

ENT.InfantryAtts = {
	[1] = "spawner_l1",
	[2] = "spawner_l2",
	[3] = "spawner_l3",
	[4] = "spawner_l4",
	[5] = "spawner_l5",
	[6] = "spawner_r1",
	[7] = "spawner_r2",
	[8] = "spawner_r3",
	[9] = "spawner_r4",
	[10] = "spawner_r5"
}

ENT.Passengers = {

}
 
function ENT:PrepareMarines(int)
	for i = 1, int do
		local at = self.InfantryAtts[i]
		local attachment = self:GetAttachment(self:LookupAttachment(at))
		local ent = ents.Create( self.PassengersClass[math.random(#self.PassengersClass)] )
		ent.OldGravity = ent.loco:GetGravity()
		ent.loco:SetGravity(0)
		ent:SetPos(attachment.Pos)
		ent:SetAngles(attachment.Ang)
		ent.InPelican = true
		ent.IsInVehicle = true
		ent.Pelican = self
		ent.PelicanId = i
		local s = i
		ent.SideAnim = "Left"
		if s > 5 then s = s-5 ent.SideAnim = "Right" end
		ent.SAnimId = s
		ent:Spawn()
		ent.OSM = ent:GetSolidMask()
		ent:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
		ent.OCG = ent:GetCollisionGroup()
		ent.OOHE = ent.OnHaveEnemy
		ent.OnHaveEnemy = function(ent) end -- lol
		ent.OOLOG = ent.OnLandOnGround
		ent.OOI = ent.OnInjured
		ent.OOTA = ent.OnTraceAttack
		ent.OnInjured = function(s) end
		ent.OnTraceAttack = function(s,a,e) end
		ent.OOOK = ent.OnOtherKilled
		ent.OnOtherKilled = function(s,s1) end
		ent.OnLandOnGround = function(s,e)
			ent:SetCollisionGroup(ent.OCG)
			ent:SetSolidMask(ent.OSM)
			ent.OnHaveEnemy = ent.OOHE
			ent:OOLOG(s,e)
			ent.OnLandOnGround = ent.OOLOG
			ent.OnInjured = ent.OOI
			ent.OnTraceAttack = ent.OOTA
			ent.OnOtherKilled = ent.OOOK
		end
		ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		ent:SetParent(self)
		ent:SetOwner(self)
		local func = function()
			while (ent.InPelican and !ent.PLanded) do
				coroutine.wait(0.01)
			end
			local anim
			if ent.SideAnim == "Left" then
				anim = ent.PelicanPassengerLExitAnims[ent.SAnimId]
			else
				anim = ent.PelicanPassengerRExitAnims[ent.SAnimId]
			end
			ent:PlaySequenceAndPWait(anim,1,ent:GetPos())
			ent.PExited = true
			local dir = ent:GetRight()
			while (!ent.loco:IsOnGround()) do
				ent.loco:SetVelocity(Vector(0,0,-800)+ent:GetForward()*math.random(1,5))
				coroutine.wait(0.01)
			end
		end
		table.insert(ent.StuffToRunInCoroutine,func)
		self.Passengers[#self.Passengers+1] = ent
	end
end

ENT.PassengersClass = {
	"npc_iv04_hr_human_odst",
	"npc_iv04_hr_human_odst",
	"npc_iv04_hr_human_odst",
	"npc_iv04_hr_human_odst",
	"npc_iv04_hr_human_odst_female"
}

function ENT:PreInit()
	self.StopMovement = true
	self.loco:SetGravity( 0 )
	local func = function()
		self:PelicanCycle()
	end
	table.insert(self.StuffToRunInCoroutine,func)
	self:ResetAI()
	--self.IsNTarget = (GetConVar("hce_dropship_targetting"):GetInt() == 0)
	--self.loco:Jump()
end

function ENT:BeforeThink()
	--self:StartActivity(ACT_IDLE)
end

ENT.Quotes = {}

function ENT:Speak(quote)
	local tbl = self.Quotes[quote]
	if tbl then
		local snd = table.Random(tbl) 
		--self:EmitSound(snd,100)
		if self.VSound and self.VSound:IsPlaying() then self.VSound:Stop() end
		self.VSound = CreateSound( self, snd )
		self.VSound:SetSoundLevel( 100 )
		self.VSound:Play()
		--print("indeed")
	end
end

function ENT:OnInitialize()
	--self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
	self.IsNTarget = true
	self:SetBloodColor( BLOOD_COLOR_MECH )
	snd = table.Random(self.SoundIdle)
	--if self:WaterLevel() != 0 then 	if self.EngineSnd then self.EngineSnd:Stop() end return end
	--if !self.EngineSnd and isstring(snd) then self.EngineSnd = CreateSound(self,snd) end
	--if self.EngineSnd then
	--	self.EngineSnd:Play()
	--end
	for i = 2, 5 do
		ParticleEffectAttach( "halo_reach_pelican_thruster_fx", PATTACH_POINT_FOLLOW, self, i )
	end
	local r = math.random(5,10)
	self.MarinesCount = r
	self:PrepareMarines(r)
	--self:SetPos(self:GetPos()+Vector(0,0,200))
	--local who = math.random(0,2)
	--self:SetBodygroup(1,who)
	local mins, maxs = self:GetCollisionBounds()
	self:SetCollisionBounds(mins+Vector(50,50,30),maxs+Vector(-50,-50,-30))
	--print(who)
end

function ENT:OnRemove()
    if SERVER then
        --self.EngineSnd:Stop()
    end
end

function ENT:OnContact( ent ) -- When we touch someBODY
	if ent == game.GetWorld() then return "no" end
	local v = ent
	--[[if (v.IsVJBaseSNPC == true or v.CPTBase_NPC == true or v.IsSLVBaseNPC == true or v:GetNWBool( "bZelusSNPC" ) == true) or (v:IsNPC() && v:GetClass() != "npc_bullseye" && v:Health() > 0 ) or (v:IsPlayer() and v:Alive()) or ( (v:IsNextBot()) and v != self ) then
		local d = self:GetPos()-ent:GetPos()
		self.loco:SetVelocity(d*0.25)
	end]]
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
	if self:CheckRelationships(dmg:GetAttacker()) == "friend" then dmg:ScaleDamage(0) return end
	if dmg:GetDamageType() != DMG_BLAST and dmg:GetDamageType() != DMG_AIRBOAT then dmg:ScaleDamage(0) end
	if self:CheckRelationships(dmg:GetAttacker()) == true then
		self:SetEnemy(dmg:GetAttacker())
	end
end

function ENT:PelicanCycle()
	self:PlaySequenceAndWait("Arrival")
	self.IsNTarget = false
	self:DropTroops()
	self.IsNTarget = true
	self:PlaySequenceAndWait("Departure")
	self:Remove() -- Very cool
end

ENT.NInvisT = 0

ENT.InvisDel = 0.5

function ENT:CanSee(pos)
	local tr = {
		start = self:GetPos(),
		endpos = pos,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
		mask = MASK_NPCSOLID_BRUSHONLY,
		filter = {self,self:GetOwner()}
	}
	return !util.TraceHull(tr).Hit
end

function ENT:CanSee(pos)
	local tr = {
		start = self:GetPos(),
		endpos = pos,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
		mask = MASK_NPCSOLID_BRUSHONLY,
		filter = {self,self:GetOwner()}
	}
	return !util.TraceHull(tr).Hit
end

ENT.NextTurretThink = 0

function ENT:GetShootPos()
	return self:GetAttachment(1).Pos
end

if SERVER then

	function ENT:Think()
		if self.StopMovement then
			self.loco:SetVelocity(Vector(0,0,0))
		end
		if self.NextTurretThink < CurTime() then
			self.NextTurretThink = CurTime()+2
			if !IsValid(self.Enemy) then
				self:SearchEnemy()
			else
				if self.GunnerShoot then
					for i = 1, math.random(5,15) do
						timer.Simple( i*0.1, function()
							if IsValid(self) and IsValid(self.Enemy) then
								local att = self:GetAttachment(1)
								local bullet = {}
								bullet.Attacker = self
								bullet.TracerName = "effect_astw2_halo_ce_tracer_ar"
								bullet.Damage = 12
								bullet.Spread = Vector( 0.01, 0.01 )
								bullet.Src = att.Pos
								bullet.Dir = self:GetAimVector()
								ParticleEffect( "astw2_halo_3_muzzle_machine_gun_turret", att.Pos, att.Ang, self )
								sound.Play("halo/halo_reach/weapons/machine_gun_turret_fire1.ogg",self:GetShootPos(),100)
								self:FireBullets( bullet )
							end
						end )
					end
				end
			end
		end
		--self:ResetSequence("reference")
	end

end

function ENT:DropTroops()
	local pass = #self.Passengers
	self:DoGestureSeq("Doors Open")
	--self:DoGestureSeq("Doors Open Idle",false)
	timer.Simple( 1, function()
		if IsValid(self) then
			self:DoGestureSeq("Doors Open Idle",false,0)
		end
	end )
	coroutine.wait(1)
	for i = 1, pass do 
		local ent = self.Passengers[i]
		if !IsValid(ent) then continue end
		ent.PLanded = true
		ent:SetEnemy(self.Enemy)
		while (!ent.PExited) do
			coroutine.wait(0.01)
		end
		ent.IsInVehicle = false
		ent.InPelican = false
		ent.Pelican = nil
		ent.loco:SetGravity(ent.OldGravity)
		ent:SetParent(nil)
		ent:ResetSequence(ent.AirAnim)
		local dir = ent:GetRight()
		if ent.SideAnim == "Right" then dir = -ent:GetRight() end
		ent:SetPos(ent:GetPos()+(dir*((40*pass)-10)))
	end
	self:RemoveAllGestures()
	self:DoGestureSeq("Doors Close")
	timer.Simple( 1, function()
		if IsValid(self) then
			self:DoGestureSeq("Doors Close Idle",false,0)
		end
	end )
end

function ENT:TakeOff()
	local t = CurTime()+8
	--local snd = table.Random(self.TakeOffSounds)
	--self:EmitSound(snd,100)
	--self:SetPos(self:GetPos()+self:GetUp()*10)
	while ( t > CurTime() ) do
		self.loco:SetVelocity(self:GetUp()*100)
		coroutine.wait(0.01)
	end
	self.DState = 5
end

ENT.WA = 20
ENT.WR = 20
ENT.WL = 20

ENT.LTP = 0
ENT.LTPP = 0

function ENT:BodyUpdate()
	local goal = self:GetPos()+self.loco:GetVelocity()
	local y = (goal-self:GetPos()):Angle().y
	local di = math.AngleDifference(self:GetAngles().y,y)
	self:SetPoseParameter("move_yaw",di)
	self:SetPoseParameter("walk_yaw",di)
	local look = false
	local goal
	local y
	local di = 0
	local p
	local dip = 0
	if IsValid(self.Enemy) then
		goal = self.Enemy:WorldSpaceCenter()
		local an = (goal-self:GetAttachment(1).Pos):Angle()
		y = an.y
		di = math.AngleDifference(self:GetAngles().y,y)
		p = an.p
		dip = math.AngleDifference(self:GetAngles().p,p)
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
					self.GunnerShoot = false
				else
					self.GunnerShoot = true
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
	self:FrameAdvance()
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	ParticleEffect("halo_reach_explosion_unsc",self:GetPos()+self:GetForward()*-300+self:GetUp()*140,self:GetAngles()+Angle(-90,0,0),nil)
	self:Remove()
end

list.Set( "NPC", "npc_iv04_hr_pelican_oni", {
	Name = "Pelican (ONI)",
	Class = "npc_iv04_hr_pelican_oni",
	Category = "Halo Reach"
} )