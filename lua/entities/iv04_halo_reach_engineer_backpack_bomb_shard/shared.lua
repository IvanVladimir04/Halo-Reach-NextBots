ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Engineer Backpack Bomb Shard"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/halo_reach/characters/covenant/engineer_backpack_bomb_shard.mdl"
ENT.FuseTime = 7
ENT.ArmTime = 0.2
ENT.ImpactFuse = true

AddCSLuaFile()

function ENT:Initialize()
    if SERVER then
	util.SpriteTrail( self, 0, Color(85,155,255,155), false, 25, 0, 0.35, 1, "effects/halo2/plasma_contrail" )
        self:SetModel( self.Model )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
	    phys:SetMass(1)
            phys:SetBuoyancyRatio(0)
	    phys:EnableGravity( true )
        end
	
        self.kt = CurTime() + self.FuseTime
        self.at = CurTime() + self.ArmTime
	self.motorsound = CreateSound( self, "halo_reach/vehicles/damage_effects/covy_damloops_med/c_damage_med/loop/covy_dam_med_loop1.ogg") 
	 self.motorsound:Play()
    end
	    self.at = CurTime() + self.ArmTime
    self.Armed = false
	
end

function ENT:OnRemove()
    if SERVER then
        self.motorsound:Stop()
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
            -- self:EmitSound(Sound("halo/halo_reach/weapons/frag_armed" .. math.random(1,3) .. ".ogg"))
		end
		end
	if self.at <= CurTime() and self.ImpactFuse then
            self:Detonate()


        end
		-- local effectdata = EffectData()
            -- effectdata:SetOrigin( self:GetPos() )
        -- util.Effect( "StunstickImpact", effectdata)
end

function ENT:ClientThink()
	
	do --Projectile Simulating Inclination Angles
		self:SetAngles( self:GetVelocity():Angle() + Angle(90,0,-90) )	
	end
	
            if !self:IsValid() or self:WaterLevel() > 2 then return end


    return 0.1
end

function ENT:ServerThink()
    if CurTime() >= self.at and !self.Armed then
        self:Arm()
        self.Armed = true
    end

        if self.Armed then
            -- local phys = self:GetPhysicsObject()
            -- phys:ApplyForceCenter( self:GetAngles():Up()  )
        end

        if CurTime() >= self.kt then
            self:Detonate()
        end
-- local phys = self:GetPhysicsObject()

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

function ENT:Think()
    if SERVER then self:NextThink( self:ServerThink() or 0.1 ) end
    if CLIENT then self:SetNextClientThink( self:ClientThink() or 0.1 ) end
    return true
end

function ENT:Detonate()
    if SERVER then
        if !self:IsValid() then return end
        local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() + Vector(0,0,50) )

        if self:WaterLevel() >= 1 then
            util.Effect( "WaterSurfaceExplosion", effectdata )
        else
            -- util.Effect( "gow_explosion_frag", effectdata)
		ParticleEffect( "iv04_halo_reach_plasma_explosion_small", self:GetPos(), self:GetAngles() )
		sound.Play( "halo_reach/vehicles/damage_effects/cov_damage_small/cov_damage_small" .. math.random(1,17) .. ".ogg",  self:GetPos(), 100, 100 )

        end
	
        local attacker = self

        if self.Owner:IsValid() then
            attacker = self.Owner
        end

        util.BlastDamage(self, attacker, self:GetPos(), 128, 55)
	self.motorsound:Stop()
        self:Remove()
    end
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()
		local light = DynamicLight(self:EntIndex())
        if (light) then
            light.Pos = self:GetPos()
            light.r = 75
            light.g = 155
            light.b = 255
            light.Brightness = 10
            light.Decay = 0
            light.Size = 15
            light.DieTime = CurTime() + 0.1
        end
        cam.Start3D() -- Start the 3D function so we can draw onto the screen.
            render.SetMaterial( Material("effects/halo3/flare1") ) -- Tell render what material we want, in this case the flash from the gravgun
            render.DrawSprite( self:GetPos(), math.random(15, 25), math.random(15, 25), Color(75, 135, 175) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
        cam.End3D()
    end
end