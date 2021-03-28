if util.IsValidModel( "models/halo/halo_reach/weapons/needler_rifle.mdl" ) and file.Exists( "lua/autorun/astw2_halo_3_autorun.lua", "WORKSHOP" ) then
	CreateConVar( "halo_reach_nextbots_ai_type", "Offensive", FCVAR_ARCHIVE, "Type of AI the Halo Reach NextBots will spawn with (if you change this after spawning one its AI type won't change), possible values are Defensive, Offensive and Static. Note not all kind of nextbots can be affected by this!" )
	CreateConVar( "halo_reach_nextbots_ai_difficulty", 2, FCVAR_ARCHIVE, "Difficulty, (1 = easy, 2 = normal, 3 = heroic, 4 = legendary" )
	CreateConVar( "halo_reach_nextbots_ai_heroes", 1, FCVAR_ARCHIVE, "Are hero characters invincible?" )
	CreateConVar( "halo_reach_nextbots_ai_scarab_explosions", 14, FCVAR_ARCHIVE, "Amount of total plasma explosions the scarab uses" )
	CreateConVar( "halo_reach_nextbots_ai_great_schism", 1, FCVAR_ARCHIVE, "Allow funny space monkeys to take the control?" )
	CreateConVar( "halo_reach_nextbots_ai_flood_infection_climb", 1, FCVAR_ARCHIVE, "Allow infection forms to climb?" )
else
	print("You are either stupid for not getting the required addon or an asshole for not getting it knowing it was required")
end -- Dopey deserves the suscription, YOU KNOW IT

game.AddDecal( "iv04_halo_reach_blood_splat_hunter", "effects/halo_reach/decals/blood_hunter" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_elite", "effects/halo_reach/decals/blood_elite" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_jackal", "effects/halo_reach/decals/blood_jackal" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_grunt", "effects/halo_reach/decals/blood_grunt" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_brute", "effects/halo_reach/decals/blood_brute" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_drone", "effects/halo_reach/decals/blood_drone" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_engineer", "effects/halo_reach/decals/blood_engineer" ) 
game.AddDecal( "iv04_halo_reach_blood_splat_guta", "effects/halo_reach/decals/blood_guta" )
game.AddParticles( "particles/iv04_halo_reach_grunt_methane_effects.pcf" )
game.AddParticles( "particles/iv04_halo_reach_elite_shield_pop_effects.pcf" )
game.AddParticles( "particles/iv04_halo_reach_covy_plasma_explosions.pcf" )
game.AddParticles( "particles/iv04_halo_reach_blood.pcf" )
game.AddParticles( "particles/iv04_halo_reach_explosions.pcf" )
game.AddParticles( "particles/iv04_halo_reach_covenant_explosions.pcf" )
game.AddParticles( "particles/iv04_halo_reach_covenant_vehicle_explosions.pcf" )
game.AddParticles( "particles/iv04_halo_reach_pelican_thruster_fx.pcf" )
game.AddParticles( "particles/iv04_halo_reach_phantom_muzzle_effects.pcf" )
game.AddParticles( "particles/iv04_halo_reach_shield_impact_effects.pcf" )
game.AddParticles( "particles/iv04_halo_reach_shield_pop_effects.pcf" )
game.AddParticles( "particles/iv04_halo_reach_flood_gibbing.pcf" )
game.AddParticles( "particles/iv04_halo_reach_unsc_explosions.pcf" )
game.AddParticles( "particles/iv04_halo_reach_pelican_thruster_fx.pcf" )
PrecacheParticleSystem( "halo_reach_droppod_thruster_fx" )
PrecacheParticleSystem( "iv04_halo_reach_flood_infection_form_gib" )
PrecacheParticleSystem( "iv04_halo_reach_flood_carrier_form_gib" )
PrecacheParticleSystem( "iv04_halo_reach_flood_combat_form_gib" )
PrecacheParticleSystem( "halo_reach_blood_impact_brute" )
PrecacheParticleSystem( "halo_reach_blood_impact_drone" )
PrecacheParticleSystem( "halo_reach_blood_impact_elite" )
PrecacheParticleSystem( "halo_reach_blood_impact_grunt" )
PrecacheParticleSystem( "halo_reach_blood_impact_human" )
PrecacheParticleSystem( "halo_reach_blood_impact_hunter" )
PrecacheParticleSystem( "halo_reach_blood_impact_jackal" )
PrecacheParticleSystem( "halo_reach_blood_impact_drone_gib" )
PrecacheParticleSystem( "iv04_halo_reach_explosion_engineer" )
PrecacheParticleSystem( "iv04_halo_reach_engineer_shield_pulsate" )
PrecacheParticleSystem( "iv04_halo_reach_plasma_explosion_tiny" )
PrecacheParticleSystem( "iv04_halo_reach_plasma_explosion_small" )
PrecacheParticleSystem( "iv04_halo_reach_elite_shield_pop" )
PrecacheParticleSystem( "iv04_halo_reach_covenant_explosions" )
PrecacheParticleSystem( "halo_reach_explosion_unsc" )
PrecacheParticleSystem( "halo_reach_explosion_covenant" )
PrecacheParticleSystem( "halo_reach_explosion_covenant_large" )
PrecacheParticleSystem( "iv04_halo_reach_grunt_methane_leak_violent" )
PrecacheParticleSystem( "halo_reach_pelican_thruster_fx" )
PrecacheParticleSystem( "halo_reach_pelican_thruster_fx_throttle" )
PrecacheParticleSystem( "halo_reach_phantom_muzzle_flash" )
PrecacheParticleSystem( "halo_reach_shield_impact_effect" )
PrecacheParticleSystem( "halo_reach_spartan_shield_impact_effect" )
PrecacheParticleSystem( "halo_reach_shield_pop" )
PrecacheParticleSystem( "halo_reach_spartan_shield_pop" )
PrecacheParticleSystem( "halo_reach_jackal_shield_deplete_effect" )
PrecacheParticleSystem( "halo_reach_jackal_shield_deplete_effect_red" )
PrecacheParticleSystem( "halo_reach_jackal_shield_deplete_effect_blue" )
PrecacheParticleSystem( "halo_reach_jackal_shield_impact_effect" )
PrecacheParticleSystem( "iv04_halo_reach_explosion_engineer" )
PrecacheParticleSystem( "iv04_halo_reach_phantom_explosion" )
PrecacheParticleSystem( "iv04_halo_reach_scarab_explosion" )
PrecacheParticleSystem( "iv04_halo_reach_engineer_beam" )
PrecacheParticleSystem( "iv04_halo_reach_jackal_sniper_glow" )
PrecacheParticleSystem( "halo_reach_explosion_unsc_large" )

HRNBsTbl = {

}

if SERVER then

	util.AddNetworkString( "HRNBsSpartanSpawned" )

	HRHS = {} -- Halo Reach Human Squads
	
	HRHS.Signals = {
		--["Retreat"] = true
	}
	
	HRHS.SignalT = {
		["Retreat"] = 0
	}
	
	HRHS.SignalCaller = {
		-- ["EntityHere"] = true
	}
	
	function HRHS:WasSignalGiven(sign,tolerance)
		if HRHS.Signals[sign] and ( HRHS.SignalT[sign]+tolerance > CurTime() ) then
			return true
		end
		return false
	end
	
	function HRHS:Signal(sign,caller)
		--print(sign)
		self.Signals[sign] = true
		self.SignalT[sign] = CurTime()
		self.SignalCaller[sign] = caller
	end
	
	function HRHS:GetCaller(sign)
		return self.SignalCaller[sign]
	end

end