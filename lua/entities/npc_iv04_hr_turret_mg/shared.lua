AddCSLuaFile()
ENT.Base = "npc_iv04_base"
ENT.PrintName = "Anti Infantry Turret"
ENT.Models  = {"models/halo_reach/vehicles/unsc/anti_infantry_turret.mdl"}

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

ENT.CustomIdle = true

function ENT:HandleAnimEvent(event,eventTime,cycle,type,options)
	--[[if options ==  "event_osw_dropship_deploy" then
		self:DeploySquad()
	end]]
end

function ENT:PreInit()
	self.StopMovement = true
	local func = function()
		self:PlaySequenceAndWait("Turret_Open")
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
	self:SetBloodColor( BLOOD_COLOR_MECH )
	--snd = table.Random(self.SoundIdle)
	--self:SetCollisionBounds(mins+Vector(50,50,30),maxs+Vector(-50,-50,-30))
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

function ENT:DoCustomIdle()
	return self:DoWander()
end

function ENT:OnInjured(dmg)
	if self:CheckRelationships(dmg:GetAttacker()) == "friend" then dmg:ScaleDamage(0) return end
	if dmg:GetDamageType() != DMG_BLAST and dmg:GetDamageType() != DMG_AIRBOAT then dmg:ScaleDamage(0) end
	if self:CheckRelationships(dmg:GetAttacker()) == true then
		self:SetEnemy(dmg:GetAttacker())
	end
end

function ENT:DoWander()
	self:PlaySequenceAndWait("Unarmed_Idle")
end

function ENT:CustomBehaviour(ent,range)
	self:PlaySequenceAndWait("Unarmed_Idle")
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

ENT.NextTurretThink = 0

function ENT:GetShootPos()
	return self:GetAttachment(1).Pos
end

if SERVER then

	function ENT:Think()
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

ENT.LTP = 0
ENT.LTPP = 0

function ENT:BodyUpdate()
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
				--print(vy,vp)
				if math.abs(vy) > 5 then
					self.LTPP = self:GetPoseParameter("aim_yaw")
					local i
					if vy < 0 then
						i = 1
					else
						i = -1
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
	ParticleEffect("halo_reach_explosion_unsc",self:GetPos(),self:GetAngles()+Angle(-90,0,0),nil)
	self:Remove()
end

list.Set( "NPC", "npc_iv04_hr_turret_mg", {
	Name = "Anti Infantry Turret",
	Class = "npc_iv04_hr_turret_mg",
	Category = "Halo Reach"
} )