ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Scarab Cannon Projectile"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/halo/combat_evolved/weapons/grenade_plasma.mdl"
ENT.FuseTime = 7
ENT.ArmTime = 0
ENT.ImpactFuse = false
ENT.BlastRadius = 64
ENT.BlastDMG = 128
AddCSLuaFile()

function ENT:Initialize()
    if SERVER then
	 util.SpriteTrail( self, 0, Color(185,255,85,200), false, 512, 128, 3, 0.01, "effects/halo3/hunter_beam_final" )
        self:SetModel( self.Model )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
		phys:SetMass(2)
            phys:SetBuoyancyRatio(0)
	phys:EnableGravity( false )
        end

        self.kt = CurTime() + self.FuseTime
        self.at = CurTime() + self.ArmTime
	self.bt = CurTime() + 1
	self.motorsound = CreateSound( self, "halo_reach/vehicles/scarab/flak_cannon_loop2_h3/flak_loop2_h3/loop/loop"..math.random(1,3)..".ogg")
	self.motorsound:Play()
    end
end

function ENT:OnRemove()
    if SERVER then
		if self.motorsound then
			self.motorsound:Stop()
		end
    end
end

function ENT:Arm()
    if SERVER then
        self.motorsound:Play()
    end
end

function ENT:PhysicsCollide(data, physobj)
if SERVER then
		if data.Speed > 25 then
           self:Detonate()
		end
		if self.at <= CurTime() then
            self:Detonate()


        end
		end
	
		local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )
        util.Effect( "StunstickImpact", effectdata)
end


function ENT:ClientThink()
	
	do --Projectile Simulating Inclination Angles
		self:SetAngles( self:GetVelocity():Angle() + Angle(90,0,-90) )	
	end
	
            local emitter = ParticleEmitter(self:GetPos())

            if !self:IsValid() or self:WaterLevel() > 2 then return end

	local smoke = emitter:Add("effects/halo_spv3/energy/plasma_arcs_3", self:GetPos())
        smoke:SetGravity( Vector(math.Rand(-45, 45), math.Rand(-45, 45), math.Rand(-20, -25)) )
        smoke:SetVelocity( self:GetAngles():Forward() * -50 )
        smoke:SetDieTime( math.Rand(2.4,2.6) )
        smoke:SetStartAlpha( 255 )
        smoke:SetEndAlpha( 0 )
        smoke:SetStartSize( 120 )
        smoke:SetEndSize( 100 )
        smoke:SetRoll( math.Rand(-180, 180) )
        smoke:SetRollDelta( math.Rand(-0.2,0.2) )
        smoke:SetColor( 125, 255, 100 )
        smoke:SetAirResistance( 0 )
        smoke:SetPos( self:GetPos() )
        smoke:SetLighting( false )
	

    
	local smoke2 = emitter:Add("effects/halo_spv3/energy/sharp_plasma", self:GetPos())
        smoke2:SetGravity( Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(-20, -25)) )
        smoke2:SetVelocity( self:GetAngles():Forward() * -50 )
        smoke2:SetDieTime( math.Rand(2.2,2.4) )
        smoke2:SetStartAlpha( 255 )
        smoke2:SetEndAlpha( 0 )
        smoke2:SetStartSize( 160 )
        smoke2:SetEndSize( 120 )
        smoke2:SetRoll( math.Rand(-180, 180) )
        smoke2:SetRollDelta( math.Rand(-0.2,0.2) )
        smoke2:SetColor( 200,255, 200 )
        smoke2:SetAirResistance( 50 )
        smoke2:SetPos( self:GetPos() )
        smoke2:SetLighting( false )
        emitter:Finish()
		
	return 0.35
end

function ENT:Think()
    if SERVER then self:NextThink( self:ServerThink() or 0.35 ) end
    if CLIENT then self:SetNextClientThink( self:ClientThink() or 0.35 ) end
    return true
end


function ENT:ServerThink()

        if CurTime() >= self.at then
            local targets = ents.FindInSphere(self:GetPos(), 16)
            for _, k in pairs(targets) do
                if k:IsPlayer() or k:IsNPC() then
                    if self:Visible( k ) and k:Health() > 0 then
                        self:Detonate()
                    end
                elseif (k:IsValid() and scripted_ents.IsBasedOn( k:GetClass(), "base_nextbot" )) then
                    self:Detonate()
                end
            end
        end

        if CurTime() >= self.kt then
            self:Detonate()
        end
    return 0.2
end


function ENT:Detonate()
    if SERVER then
        if !self:IsValid() then return end
        local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )

        if self:WaterLevel() >= 1 then
            util.Effect( "WaterSurfaceExplosion", effectdata )
	ParticleEffect( "astw2_halo_reach_fuel_rod_explosion", self:GetPos(), self:GetAngles() )
	sound.Play( "halo_reach/vehicles/scarab/scarab_beam_impacts/scarab_beam_impacts" .. math.random(1,4) .. ".ogg",  self:GetPos(), 100, 100 )
        else
		ParticleEffect( "astw2_halo_reach_fuel_rod_explosion", self:GetPos(), self:GetAngles() )
	sound.Play( "halo_reach/vehicles/scarab/scarab_beam_impacts/scarab_beam_impacts" .. math.random(1,4) .. ".ogg",  self:GetPos(), 100, 100 )
	util.ScreenShake(self:GetPos(),5000,100,0.4,1000)
        end

        local attacker = self

        if self.Owner:IsValid() then
            attacker = self.Owner
        end

        util.BlastDamage(self, attacker, self:GetPos(), self.BlastRadius, self.BlastDMG)

        self:Remove()
    end
end

function ENT:Draw()
    if CLIENT then
        -- self:DrawModel()

        if self:IsValid() then
            cam.Start3D() -- Start the 3D function so we can draw onto the screen.
                render.SetMaterial( Material("effects/halo3/8pt_ringed_star_flare") ) -- Tell render what material we want, in this case the flash from the gravgun
                render.DrawSprite( self:GetPos(), math.random(100, 115), math.random(125, 150), Color(225, 255, 150) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
            cam.End3D()
        end
    end
end