AddCSLuaFile()
ENT.Base = "npc_iv04_base"
ENT.PrintName = "Droppod"
ENT.Models  = {"models/halo_reach/vehicles/covenant/drop_pod.mdl"}

ENT.MoveSpeed = 1000
ENT.MoveSpeedMultiplier = 1 -- When running, the move speed will be x times faster

ENT.Faction = "FACTION_COVENANT"

ENT.StartHealth = 10000

ENT.LoseEnemyDistance = 9999999

ENT.SightDistance = 9999999

ENT.BehaviourType = 3

ENT.DState = 1

ENT.NUT = 0

ENT.Preset = {}

ENT.IsDropship = true

--ENT.TakeOffSounds = { "oddworld/strangers_wrath/dropship/fx_native4_01_drop01_takeoff.ogg", "oddworld/strangers_wrath/dropship/fx_native4_01_drop02_takeoff.ogg","oddworld/strangers_wrath/dropship/fx_native4_01_drop03_takeoff.ogg", "oddworld/strangers_wrath/dropship/fx_cargoship_fly_away.ogg" }
ENT.SoundIdle = { "halo_reach/vehicles/tuning_fork/tuning_fork_engine/track2/loop.wav" }
ENT.SoundIdle2 = { "halo_reach/vehicles/tuning_fork/tuning_fork_lod/track1/loop/fork_lod_01.wav", "halo_reach/vehicles/tuning_fork/tuning_fork_lod/track1/loop/fork_lod_02.wav",
				"halo_reach/vehicles/tuning_fork/tuning_fork_lod/track1/loop/fork_lod_03.wav", "halo_reach/vehicles/tuning_fork/tuning_fork_lod/track1/loop/fork_lod_04.wav" }
ENT.SoundIdle3 = { "halo_reach/vehicles/tuning_fork/tuning_fork_engine/track1/loop.wav" }
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
	[1] = "spawner_1",
	[2] = "spawner_2",
	[3] = "spawner_3",
	[4] = "spawner_4"
}


ENT.Squads = {
	[1] = {
		[1] = "npc_iv04_hr_brute_minor",
		[2] = "npc_iv04_hr_brute_minor",
		[3] = "npc_iv04_hr_brute_minor",
		[4] = "npc_iv04_hr_brute_minor"
	},
	[2] = {
		[1] = "npc_iv04_hr_grunt_heavy",
		[2] = "npc_iv04_hr_grunt_heavy",
		[3] = "npc_iv04_hr_grunt_heavy",
		[4] = "npc_iv04_hr_grunt_heavy"
	},
	[3] = {
		[1] = "npc_iv04_hr_elite_ultra",
		[2] = "npc_iv04_hr_elite_ultra",
		[3] = "npc_iv04_hr_elite_ultra",
		[4] = "npc_iv04_hr_elite_ultra"
	}
}

ENT.Passengers = {

}

function ENT:OnLandOnGround(ent)
	ParticleEffect( "astw2_halo_3_spike_grenade_explosion", self:GetPos(), Angle(0,0,0), nil )
	self.loco:SetGravity(600)
	local func = function()
		self:DropTroops()
		timer.Simple( 30, function()
			if IsValid(self) then
				self:Remove() -- Very cool
			end
		end )
	end
	table.insert( self.StuffToRunInCoroutine, func)
	self:ResetAI()
end

function ENT:PreInit()
	self.loco:SetGravity( 0 )
	local func = function()
		self:DropPodCycle()
	end
	table.insert(self.StuffToRunInCoroutine,func)
	self:ResetAI()
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
	self:SetCollisionBounds(Vector(120,120,300),Vector(-120,-120,0))
	self.StartPos = self:GetPos()
	self:SetPos(self:GetPos()+self:GetUp()*1500)
	for i = 5, 7 do
		ParticleEffectAttach( "halo_reach_pelican_thruster_fx", PATTACH_POINT_FOLLOW, self, i )
	end
end

function ENT:OnRemove()
	if SERVER then
		if self.EngineSnd then self.EngineSnd:Stop() end
		if self.EngineSnd2 then self.EngineSnd2:Stop() end
		if self.EngineSnd3 then self.EngineSnd3:Stop() end
    end
end

function ENT:OnTouchWorld( ent )
	local p = ent:NearestPoint(self:WorldSpaceCenter())
	local dir = (self:WorldSpaceCenter()-p):GetNormalized()
	self.loco:SetVelocity(self.loco:GetVelocity()+dir*5)
end

function ENT:OnContact( ent ) -- When we touch someBODY
	if ent == game.GetWorld() then return self:OnTouchWorld(ent) end
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

ENT.CheckT = 0

ENT.CheckDel = 0.3

ENT.PathGoalTolerance = 180

function ENT:MoveToPos( pos,face )
	local face = face or false
	local goal = pos
	if !goal then return end
	local direang = (goal-self:WorldSpaceCenter()):GetNormalized():Angle()
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
		if face then
			self.loco:FaceTowards( self:GetPos()+direang:Forward() )
		end
		self.loco:SetVelocity( dire*(self.MoveSpeed*self.MoveSpeedMultiplier) )
		coroutine.wait(0.01)
	end
end

function ENT:DropPodCycle()
	self:ResetSequence("Idle")
	local ref = self:GetPos()+self:GetUp()*-1000
	self:MoveToPos(ref)
	self:StopParticles()
	coroutine.wait(1000)
	--self.StopMovement = true
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

if SERVER then

	function ENT:Think()
		if self.StopMovement then
			self.loco:SetVelocity(Vector(0,0,0))
		end
	end

end

ENT.CustomIdle = true

ENT.SearchJustAsSpawned = false

function ENT:HandleStanding()

end

function ENT:DropTroops()
	self:PlaySequenceAndWait( "Deploy" )
	local typ = self.Squads[math.random(#self.Squads)]
	for i = 1, 4 do
		local ent = ents.Create( typ[i] )
		local att = self:GetAttachment(self:LookupAttachment(self.InfantryAtts[i]))
		ent:SetPos( att.Pos+att.Ang:Forward()*100 )
		ent:SetAngles( att.Ang )
		ent:SetOwner( self )
		ent:Spawn()
		local func = function()
			ent:WanderToPosition(ent:GetPos()+ent:GetForward()*200+ent:GetRight()*math.random(200,-200),ent.RunAnim[math.random(#ent.RunAnim)],ent.MoveSpeed*ent.MoveSpeedMultiplier)
		end
		table.insert(ent.StuffToRunInCoroutine,func)
		ent:ResetAI()
	end
	coroutine.wait( 30 )
end

ENT.WA = 20
ENT.WR = 20
ENT.WL = 20

ENT.LTP = 0
ENT.LTPP = 0

function ENT:BodyUpdate()
	self:FrameAdvance()
end

function ENT:OnKilled( dmginfo ) -- When killed
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	ParticleEffect("astw2_halo_reach_plasma_explosion",self:GetPos()+self:GetUp()*140,self:GetAngles()+Angle(-90,0,0),nil)
	self:Remove()
end

list.Set( "NPC", "npc_iv04_hr_droppod", {
	Name = "Droppod",
	Class = "npc_iv04_hr_droppod",
	Category = "Halo Reach"
} )