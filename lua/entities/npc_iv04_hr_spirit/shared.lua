AddCSLuaFile()
ENT.Base = "npc_iv04_base"
ENT.PrintName = "Spirit"
ENT.Models  = {"models/halo_reach/vehicles/covenant/spirit.mdl"}

ENT.MoveSpeed = 1000
ENT.MoveSpeedMultiplier = 1 -- When running, the move speed will be x times faster

ENT.Faction = "FACTION_COVENANT"

ENT.StartHealth = 2500

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

ENT.Gibs = {
	[1] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_1.mdl",
	[2] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_2.mdl",
	[3] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_3.mdl",
	[4] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_4.mdl",
	[5] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_5.mdl",
	[6] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_6.mdl",
	[7] = "models/halo_reach/vehicles/covenant/gibs/spirit_gib_7.mdl",
	[8] = "models/halo_reach/vehicles/covenant/gibs/spirit_turret_gib_1.mdl",
	[9] = "models/halo_reach/vehicles/covenant/gibs/spirit_turret_gib_2.mdl"
}

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
	[6] = "spawner_l6",
	[7] = "spawner_l7",
	[8] = "spawner_l8",
	[9] = "spawner_r1",
	[10] = "spawner_r2",
	[11] = "spawner_r3",
	[12] = "spawner_r4",
	[13] = "spawner_r5",
	[14] = "spawner_r6",
	[15] = "spawner_r7",
	[16] = "spawner_r8"
}


ENT.Squads = {
	[1] = {
		["Minor"] = {
			[1] = "npc_iv04_hr_elite_minor",
			[2] = "npc_iv04_hr_grunt_minor",
			[3] = "npc_iv04_hr_grunt_minor",
			[4] = "npc_iv04_hr_grunt_minor",
			[5] = "npc_iv04_hr_elite_minor",
			[6] = "npc_iv04_hr_grunt_minor",
			[7] = "npc_iv04_hr_grunt_minor",
			[8] = "npc_iv04_hr_grunt_minor",
			[9] = "npc_iv04_hr_grunt_minor",
			[10] = "npc_iv04_hr_grunt_minor",
			[11] = "npc_iv04_hr_elite_minor",
			[12] = "npc_iv04_hr_elite_minor",
			[13] = "npc_iv04_hr_elite_minor",
			[14] = "npc_iv04_hr_grunt_minor",
			[15] = "npc_iv04_hr_grunt_minor",
			[16] = "npc_iv04_hr_grunt_minor"
		},
		["Major"] = {
			[1] = "npc_iv04_hr_elite_major",
			[2] = "npc_iv04_hr_grunt_major",
			[3] = "npc_iv04_hr_grunt_major",
			[4] = "npc_iv04_hr_grunt_minor",
			[5] = "npc_iv04_hr_elite_minor",
			[6] = "npc_iv04_hr_grunt_major",
			[7] = "npc_iv04_hr_grunt_major",
			[8] = "npc_iv04_hr_grunt_minor",
			[9] = "npc_iv04_hr_grunt_major",
			[10] = "npc_iv04_hr_grunt_minor",
			[11] = "npc_iv04_hr_elite_major",
			[12] = "npc_iv04_hr_elite_major",
			[13] = "npc_iv04_hr_elite_major",
			[14] = "npc_iv04_hr_grunt_major",
			[15] = "npc_iv04_hr_grunt_major",
			[16] = "npc_iv04_hr_grunt_major"
		},
		["Heavy"] = {
			[1] = "npc_iv04_hr_elite_ranger",
			[2] = "npc_iv04_hr_elite_ranger",
			[3] = "npc_iv04_hr_elite_ranger",
			[4] = "npc_iv04_hr_elite_ranger",
			[5] = "npc_iv04_hr_elite_ranger",
			[6] = "npc_iv04_hr_grunt_heavy",
			[7] = "npc_iv04_hr_grunt_heavy",
			[8] = "npc_iv04_hr_grunt_heavy",
			[9] = "npc_iv04_hr_grunt_heavy",
			[10] = "npc_iv04_hr_grunt_heavy",
			[11] = "npc_iv04_hr_elite_major",
			[12] = "npc_iv04_hr_elite_major",
			[13] = "npc_iv04_hr_elite_major",
			[14] = "npc_iv04_hr_grunt_major",
			[15] = "npc_iv04_hr_grunt_major",
			[16] = "npc_iv04_hr_grunt_major"
		},
		["Ultra"] = {
			[1] = "npc_iv04_hr_elite_ultra",
			[2] = "npc_iv04_hr_elite_ultra",
			[3] = "npc_iv04_hr_elite_ultra",
			[4] = "npc_iv04_hr_elite_ultra",
			[5] = "npc_iv04_hr_grunt_ultra",
			[6] = "npc_iv04_hr_grunt_ultra",
			[7] = "npc_iv04_hr_grunt_ultra",
			[8] = "npc_iv04_hr_grunt_ultra",
			[9] = "npc_iv04_hr_grunt_ultra",
			[10] = "npc_iv04_hr_grunt_ultra",
			[11] = "npc_iv04_hr_elite_ultra",
			[12] = "npc_iv04_hr_elite_ultra",
			[13] = "npc_iv04_hr_elite_ultra",
			[14] = "npc_iv04_hr_grunt_ultra",
			[15] = "npc_iv04_hr_grunt_ultra",
			[16] = "npc_iv04_hr_grunt_ultra"
		},
		["Generals"] = {
			[1] = "npc_iv04_hr_elite_general",
			[2] = "npc_iv04_hr_elite_general",
			[3] = "npc_iv04_hr_elite_general",
			[4] = "npc_iv04_hr_elite_general",
			[5] = "npc_iv04_hr_elite_general",
			[6] = "npc_iv04_hr_elite_general",
			[7] = "npc_iv04_hr_elite_general",
			[8] = "npc_iv04_hr_elite_general",
			[9] = "npc_iv04_hr_elite_general",
			[10] = "npc_iv04_hr_elite_general",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_grunt_ultra",
			[15] = "npc_iv04_hr_grunt_ultra",
			[16] = "npc_iv04_hr_grunt_ultra"
		},
	},
	[2] = {
		["Minor"] = {
			[1] = "npc_iv04_hr_brute_minor",
			[2] = "npc_iv04_hr_brute_minor",
			[3] = "npc_iv04_hr_grunt_minor",
			[4] = "npc_iv04_hr_grunt_minor",
			[5] = "npc_iv04_hr_brute_minor",
			[6] = "npc_iv04_hr_brute_minor",
			[7] = "npc_iv04_hr_grunt_minor",
			[8] = "npc_iv04_hr_grunt_minor",
			[9] = "npc_iv04_hr_grunt_minor",
			[10] = "npc_iv04_hr_grunt_minor",
			[11] = "npc_iv04_hr_jackal_minor",
			[12] = "npc_iv04_hr_jackal_minor",
			[13] = "npc_iv04_hr_jackal_minor",
			[14] = "npc_iv04_hr_grunt_minor",
			[15] = "npc_iv04_hr_grunt_minor",
			[16] = "npc_iv04_hr_grunt_minor"
		},
		["Major"] = {
			[1] = "npc_iv04_hr_brute_captain",
			[2] = "npc_iv04_hr_brute_captain",
			[3] = "npc_iv04_hr_grunt_major",
			[4] = "npc_iv04_hr_grunt_minor",
			[5] = "npc_iv04_hr_brute_captain",
			[6] = "npc_iv04_hr_brute_captain",
			[7] = "npc_iv04_hr_grunt_major",
			[8] = "npc_iv04_hr_grunt_minor",
			[9] = "npc_iv04_hr_grunt_major",
			[10] = "npc_iv04_hr_grunt_minor",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_grunt_ultra",
			[15] = "npc_iv04_hr_grunt_major",
			[16] = "npc_iv04_hr_grunt_major"
		},
		["Generals"] = {
			[1] = "npc_iv04_hr_brute_chieftain",
			[2] = "npc_iv04_hr_brute_chieftain",
			[3] = "npc_iv04_hr_brute_chieftain",
			[4] = "npc_iv04_hr_brute_chieftain",
			[5] = "npc_iv04_hr_brute_chieftain",
			[6] = "npc_iv04_hr_brute_chieftain",
			[7] = "npc_iv04_hr_brute_captain",
			[8] = "npc_iv04_hr_brute_captain",
			[9] = "npc_iv04_hr_brute_captain",
			[10] = "npc_iv04_hr_brute_captain",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_grunt_ultra",
			[15] = "npc_iv04_hr_grunt_ultra",
			[16] = "npc_iv04_hr_grunt_ultra"
		},
	},
	[3] = {
		["Minor"] = {
			[1] = "npc_iv04_hr_jackal_minor",
			[2] = "npc_iv04_hr_jackal_minor",
			[3] = "npc_iv04_hr_grunt_minor",
			[4] = "npc_iv04_hr_grunt_minor",
			[5] = "npc_iv04_hr_jackal_minor",
			[6] = "npc_iv04_hr_jackal_minor",
			[7] = "npc_iv04_hr_grunt_minor",
			[8] = "npc_iv04_hr_grunt_minor",
			[9] = "npc_iv04_hr_grunt_minor",
			[10] = "npc_iv04_hr_grunt_minor",
			[11] = "npc_iv04_hr_jackal_minor",
			[12] = "npc_iv04_hr_jackal_minor",
			[13] = "npc_iv04_hr_jackal_minor",
			[14] = "npc_iv04_hr_grunt_minor",
			[15] = "npc_iv04_hr_grunt_minor",
			[16] = "npc_iv04_hr_grunt_minor"
		},
		["Major"] = {
			[1] = "npc_iv04_hr_jackal_major",
			[2] = "npc_iv04_hr_grunt_major",
			[3] = "npc_iv04_hr_grunt_major",
			[4] = "npc_iv04_hr_jackal_major",
			[5] = "npc_iv04_hr_jackal_major",
			[6] = "npc_iv04_hr_jackal_major",
			[7] = "npc_iv04_hr_grunt_major",
			[8] = "npc_iv04_hr_grunt_major",
			[9] = "npc_iv04_hr_grunt_major",
			[10] = "npc_iv04_hr_grunt_major",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_grunt_major",
			[15] = "npc_iv04_hr_grunt_major",
			[16] = "npc_iv04_hr_grunt_major"
		},
		["Support"] = {
			[1] = "npc_iv04_hr_jackal_major",
			[2] = "npc_iv04_hr_jackal_major",
			[3] = "npc_iv04_hr_jackal_sniper",
			[4] = "npc_iv04_hr_jackal_sniper",
			[5] = "npc_iv04_hr_jackal_sniper",
			[6] = "npc_iv04_hr_grunt_heavy",
			[7] = "npc_iv04_hr_grunt_heavy",
			[8] = "npc_iv04_hr_grunt_heavy",
			[9] = "npc_iv04_hr_grunt_heavy",
			[10] = "npc_iv04_hr_grunt_heavy",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_jackal_sniper",
			[15] = "npc_iv04_hr_jackal_sniper",
			[16] = "npc_iv04_hr_jackal_major"
		},
		["Ultra"] = {
			[1] = "npc_iv04_hr_jackal_major",
			[2] = "npc_iv04_hr_jackal_major",
			[3] = "npc_iv04_hr_jackal_major",
			[4] = "npc_iv04_hr_jackal_major",
			[5] = "npc_iv04_hr_grunt_ultra",
			[6] = "npc_iv04_hr_grunt_ultra",
			[7] = "npc_iv04_hr_grunt_ultra",
			[8] = "npc_iv04_hr_grunt_ultra",
			[9] = "npc_iv04_hr_grunt_ultra",
			[10] = "npc_iv04_hr_grunt_ultra",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_grunt_ultra",
			[15] = "npc_iv04_hr_grunt_ultra",
			[16] = "npc_iv04_hr_grunt_ultra"
		}
	},
	[4] = {
		["Minor"] = {
			[1] = "npc_iv04_hr_skirmisher_major",
			[2] = "npc_iv04_hr_skirmisher_minor",
			[3] = "npc_iv04_hr_skirmisher_minor",
			[4] = "npc_iv04_hr_skirmisher_minor",
			[5] = "npc_iv04_hr_skirmisher_major",
			[6] = "npc_iv04_hr_skirmisher_minor",
			[7] = "npc_iv04_hr_skirmisher_minor",
			[8] = "npc_iv04_hr_skirmisher_minor",
			[9] = "npc_iv04_hr_skirmisher_major",
			[10] = "npc_iv04_hr_skirmisher_minor",
			[11] = "npc_iv04_hr_skirmisher_minor",
			[12] = "npc_iv04_hr_skirmisher_minor",
			[13] = "npc_iv04_hr_skirmisher_major",
			[14] = "npc_iv04_hr_skirmisher_minor",
			[15] = "npc_iv04_hr_skirmisher_minor",
			[16] = "npc_iv04_hr_skirmisher_minor"
		},
		["Major"] = {
			[1] = "npc_iv04_hr_skirmisher_commando",
			[2] = "npc_iv04_hr_skirmisher_major",
			[3] = "npc_iv04_hr_skirmisher_major",
			[4] = "npc_iv04_hr_skirmisher_major",
			[5] = "npc_iv04_hr_skirmisher_commando",
			[6] = "npc_iv04_hr_skirmisher_major",
			[7] = "npc_iv04_hr_skirmisher_major",
			[8] = "npc_iv04_hr_skirmisher_major",
			[9] = "npc_iv04_hr_skirmisher_major",
			[10] = "npc_iv04_hr_skirmisher_major",
			[11] = "npc_iv04_hr_skirmisher_commando",
			[12] = "npc_iv04_hr_skirmisher_major",
			[13] = "npc_iv04_hr_skirmisher_major",
			[14] = "npc_iv04_hr_skirmisher_major",
			[15] = "npc_iv04_hr_skirmisher_major",
			[16] = "npc_iv04_hr_skirmisher_major"
		},
		["Champions"] = {
			[1] = "npc_iv04_hr_skirmisher_murmillo",
			[2] = "npc_iv04_hr_skirmisher_murmillo",
			[3] = "npc_iv04_hr_skirmisher_champion",
			[4] = "npc_iv04_hr_skirmisher_champion",
			[5] = "npc_iv04_hr_skirmisher_murmillo",
			[6] = "npc_iv04_hr_skirmisher_murmillo",
			[7] = "npc_iv04_hr_skirmisher_champion",
			[8] = "npc_iv04_hr_skirmisher_champion",
			[9] = "npc_iv04_hr_skirmisher_champion",
			[10] = "npc_iv04_hr_skirmisher_champion",
			[11] = "npc_iv04_hr_skirmisher_champion",
			[12] = "npc_iv04_hr_skirmisher_champion",
			[13] = "npc_iv04_hr_skirmisher_champion",
			[14] = "npc_iv04_hr_skirmisher_murmillo",
			[15] = "npc_iv04_hr_skirmisher_murmillo",
			[16] = "npc_iv04_hr_skirmisher_murmillo"
		}
	},
	[5] = {
		["Hunters"] = {
			[1] = "npc_iv04_hr_hunter",
			[2] = "npc_iv04_hr_hunter",
			[3] = "npc_iv04_hr_grunt_major",
			[4] = "npc_iv04_hr_jackal_major",
			[5] = "npc_iv04_hr_jackal_major",
			[6] = "npc_iv04_hr_jackal_major",
			[7] = "npc_iv04_hr_grunt_major",
			[8] = "npc_iv04_hr_grunt_major",
			[9] = "npc_iv04_hr_grunt_major",
			[10] = "npc_iv04_hr_grunt_major",
			[11] = "npc_iv04_hr_jackal_major",
			[12] = "npc_iv04_hr_jackal_major",
			[13] = "npc_iv04_hr_jackal_major",
			[14] = "npc_iv04_hr_grunt_ultra",
			[15] = "npc_iv04_hr_grunt_ultra",
			[16] = "npc_iv04_hr_grunt_ultra"
		}
	}
}

ENT.Weights = {
	["Minor"] = 100,
	["Major"] = 50,
	["Heavy"] = 40,
	["Ultra"] = 40,
	["Support"] = 40,
	["Generals"] = 30,
	["Champions"] = 30,
	["Hunters"] = 100
}

ENT.Passengers = {

}

function ENT:PrepareTroops(int)
	local typ = self.Squads[math.random(#self.Squads)]
	local class
	local chances = 0
	local rand = {}
	for squad, tbl in pairs(typ) do
		chances = chances+self.Weights[squad]
		rand[chances] = squad
	end
	local r1 = math.random(chances)
	for weight, squad in pairs(rand) do
		if r1 > weight then
			--print("nope")
		else
			--print("yes",weight,squad)
			class = typ[squad]
		end
	end
	for i = 1, int do
		local at = self.InfantryAtts[i]
		local attachment = self:GetAttachment(self:LookupAttachment(at))
		local cl = class[i]
		--if math.random(1,20) == 1 and !self.SpawnedEngineer then self.SpawnedEngineer = true cl = "npc_iv04_hr_engineer" end
		local ent = ents.Create( cl )
		ent.OldGravity = ent.loco:GetGravity()
		ent.loco:SetGravity(0)
		ent:SetPos(attachment.Pos)
		ent:SetAngles(attachment.Ang)
		ent.InDropship = true
		ent.IsInVehicle = true
		ent.Dropship = self
		ent.DropshipId = i
		local s = i
		ent.SideAnim = "Left"
		if s > 8 then s = s-8 ent.SideAnim = "Right" end
		ent.SAnimId = s
		ent:Spawn()
		ent.OSM = ent:GetSolidMask()
		ent:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
		ent.OCG = ent:GetCollisionGroup()
		ent.OOHE = ent.OnHaveEnemy
		ent.OnHaveEnemy = function(ent) end -- lol
		ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
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
		ent:SetParent(self)
		ent:SetOwner(self)
		local func = function()
			while (ent.InDropship and !ent.DLanded) do
				coroutine.wait(0.01)
			end
			local anim
			anim = ent.SpiritPassengerExitAnims[math.random(#ent.SpiritPassengerExitAnims)]
			ent:PlaySequenceAndPWait(anim,1,ent:GetPos())
			ent.DExited = true
			local dir = ent:GetRight()
			if !ent.IsEngineer then
				while (!ent.loco:IsOnGround() ) do
					ent.loco:SetVelocity(Vector(0,0,-800)+ent:GetForward()*math.random(1,5))
					coroutine.wait(0.01)
				end
			else
				ent:OnLandOnGround(game.GetWorld())
				ent.FlyGoal = ent:GetPos()+ent:GetUp()*-200
				--print(1)
				ent:StartActivity(ent.IdleAnim[math.random(#ent.IdleAnim)])
				ent:MoveToPos( ent:GetPos()+ent:GetUp()*-200 )
				--print(2)
				--ent.FlyGoal = nil
			end
		end
		table.insert(ent.StuffToRunInCoroutine,func)
		self.Passengers[#self.Passengers+1] = ent
	end
end

function ENT:PreInit()
	--self.StopMovement = true
	self.loco:SetGravity( 0 )
	local func = function()
		self:PhantomCycle()
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
	snd = table.Random(self.SoundIdle)
	snd2 = table.Random(self.SoundIdle2)
	snd3 = table.Random(self.SoundIdle3)
	self.EngineSnd = CreateSound( self, snd )
	self.EngineSnd2 = CreateSound( self, snd2 )
	self.EngineSnd3 = CreateSound( self, snd3 )
	self.EngineSnd:SetSoundLevel(115)
	self.EngineSnd2:SetSoundLevel(85)
	self.EngineSnd3:SetSoundLevel(95)
	self.EngineSnd:Play()
	self.EngineSnd2:Play()
	self.EngineSnd3:Play()
	self:SetCollisionBounds(Vector(400,300,800),Vector(-400,-300,400))
	self.StartPos = self:GetPos()+self:GetUp()*500
	local startoff = self:GetForward()
	local endoff = self:GetForward()
	for i = 1, 7 do 
		if util.IsInWorld(self:GetPos()+self:GetForward()*(-1000*i)+self:GetUp()*1400) then
			startoff = self:GetForward()*(-1000*i)
		end
	end
	for i = 1, 7 do 
		if util.IsInWorld(self:GetPos()+self:GetForward()*(1000*i)+self:GetUp()*1400) then
			endoff = self:GetForward()*(1000*i)
		end
	end
	self.SpawnPos = self:GetPos()+startoff+self:GetUp()*1400
	self.EndPos = self:GetPos()+endoff+self:GetUp()*1400
	self:SetPos(self.SpawnPos)
end

function ENT:OnRemove()
	if SERVER then
		if self.EngineSnd then self.EngineSnd:Stop() end
		if self.EngineSnd2 then self.EngineSnd2:Stop() end
		if self.EngineSnd3 then self.EngineSnd3:Stop() end
		if IsValid(self.CurrentExitor) then
			local ent = self.CurrentExitor
	   		ent.IsInVehicle = false
			ent.InDropship = false
			ent.Dropship = nil
			ent.loco:SetGravity(ent.OldGravity)
			ent:SetParent(nil)
			--ent:ResetSequence(ent.AirAnim)
			local dir = ent:GetRight()
			if ent.SideAnim == "Right" then dir = -ent:GetRight() end
			ent:SetPos(ent:GetPos()+(dir*((40*1)-10)))
		end
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
	local right = direang:Right()
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

function ENT:Tilt(side,tim)
	--print("yes")
	tim = tim or 1
	local i
	if side == "Right" then
		i = 0.1
	elseif side == "Left" then
		i = -0.1
	else
		if math.random(1,2) == 1 then i = 0.1 else i = -0.1 end
	end
	for e = 1, tim*5 do
		timer.Simple( e*0.1, function()
			if IsValid(self) then
				self:SetAngles(Angle(self:GetAngles().p+i,self:GetAngles().y,self:GetAngles().r))
			end
		end )
	end
	for x = 1, tim*5 do
		timer.Simple( (x*0.1)+((tim*50)/10), function()
			if IsValid(self) then
				self:SetAngles(Angle(self:GetAngles().p-i,self:GetAngles().y,self:GetAngles().r))
			end
		end )
	end
end

function ENT:PhantomCycle()
	self:ResetSequence("Idle")
	local ref = self.StartPos+self:GetUp()*1400
	self:MoveToPos(ref,true)
	local rig = self:GetForward()
	self.MoveSpeed = 700
	self:MoveToPos(ref+(rig)*60)
	self.MoveSpeed = 500
	self:MoveToPos(ref+(rig)*200)
	coroutine.wait(1)
	self.MoveSpeed = 300
	self:MoveToPos(self.StartPos+rig*260)
	--self.IsNTarget = false
	self.StopMovement = true
	local r = 16
	self.TroopsCount = r
	self:PrepareTroops(r)
	self:DropTroops()
	self.StopMovement = false
	self.MoveSpeed = 400
	self:MoveToPos(ref+rig*360)
	self.MoveSpeed = 500
	self:MoveToPos(ref+rig*560)
	self.MoveSpeed = 600
	self:MoveToPos(ref+rig*660)
	self.MoveSpeed = 750
	self:MoveToPos(ref+rig*760)
	--self.IsNTarget = true
	self.MoveSpeed = 1200
	--self:MoveToPos(self.EndPos)
	--self:ResetSequence("Departure")
	self:GoAway()
	self:Remove() -- Very cool
end

ENT.NInvisT = 0

ENT.InvisDel = 0.5

function ENT:GoAway()
	local stop = false

	while (!stop) do
	
		if self.NInvisT < CurTime() then
			self.NInvisT = CurTime()+self.InvisDel
			if !util.IsInWorld(self:GetPos()+(self:GetForward())*1200) then
				stop = true
			end
			--debugoverlay.Sphere(self:GetPos()+self:GetForward()*1200,6)
		end
	
		self.loco:SetVelocity(self:GetForward()*self.MoveSpeed)
		
		--self.loco:FaceTowards(self:GetPos()+randdir)
	
		coroutine.wait(0.01)
	
	end
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
			self.NextTurretThink = CurTime()+math.random(4,6)
			self:Tilt()
			if !IsValid(self.Enemy) then
				self:SearchEnemy()
			else
				if self.GunnerShoot then
					for i = 1, math.random(2,4) do
						timer.Simple( (i*0.4)-0.4, function()
							if IsValid(self) and IsValid(self.Enemy) then
								local att = self:GetAttachment(1)
								local projec = ents.Create( "astw2_haloreach_concussion_round" )
								projec:SetPos(att.Pos)
								projec:SetAngles(att.Ang)
								projec:Spawn()
								--projec:SetCollisionGroup( COLLISION_GROUP_WORLD )
								projec.ServerThink = function() end
								projec:SetOwner(self)
								local phys = projec:GetPhysicsObject()
								if IsValid(phys) then
									phys:Wake()
									phys:SetVelocity( (self:GetAimVector()+self:GetRight()*(math.random(1,-1)*math.random(100))+self:GetForward()*(math.random(1,-1)*math.random(100)))*3000 )
								end
								ParticleEffect( "astw2_halo_reach_muzzle_concussion_rifle", att.Pos, att.Ang, self )
								sound.Play("halo_reach/vehicles/phantom/phantom_turret_fire.ogg",self:GetShootPos(),100)
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
	timer.Simple( 2, function()
		if IsValid(self) then
			self:DoGestureSeq("Doors Open Idle",false,0)
		end
	end )
	coroutine.wait(3)
	local s1 = 0
	local s2 = 2
	for i = 1, pass do 
		local ent = self.Passengers[i]
		if !IsValid(ent) then continue end
		ent.DLanded = true
		s1 = s1+1
		self.CurrentExitor = ent
		ent:SetEnemy(self.Enemy)
		if s1 == s2 then
			s2 = s2+2
			while (!ent.DExited) do
				coroutine.wait(0.01)
			end
		end
		ent.IsInVehicle = false
		ent.InDropship = false
		ent.Dropship = nil
		ent.loco:SetGravity(ent.OldGravity)
		ent:SetParent(nil)
		--ent:ResetSequence(ent.AirAnim)
		local dir = ent:GetRight()
		if ent.SideAnim == "Right" then dir = -ent:GetRight() end
		ent:SetPos(self:GetAttachment(self:LookupAttachment(self.InfantryAtts[ent.DropshipId])).Pos)
	end
	self:RemoveAllGestures()
	self:DoGestureSeq("Doors Close")
	timer.Simple( 3, function()
		if IsValid(self) then
			self:DoGestureSeq("Doors Close Idle",false,0)
		end
	end )
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
	self:EmitSound("halo_reach/vehicles/phantom/phantom_windup.ogg",100)
	local speed = (1.5/(GetConVar("halo_reach_nextbots_ai_scarab_explosions"):GetInt()/10))
	for i = 1, GetConVar("halo_reach_nextbots_ai_scarab_explosions"):GetInt()/10 do 
		timer.Simple( i*speed, function()
			if IsValid(self) then
				ParticleEffect("halo_reach_explosion_covenant",self:GetAttachment(math.random(17)).Pos,self:GetAngles()+Angle(-90,0,0),nil)
			end
		end )
	end
	timer.Simple( 1.5, function()
		if IsValid(self) then
			self:EmitSound("halo_reach/vehicles/phantom/phantom_destroyed.ogg",100)
			ParticleEffect("iv04_halo_reach_phantom_explosion",self:GetPos()+self:GetUp()*140,self:GetAngles()+Angle(-90,0,0),nil)
			for i = 1, #self.Gibs do
				local gib = ents.Create("prop_physics")
				gib:SetModel(self.Gibs[i])
				gib:SetPos( self:WorldSpaceCenter()+self:GetForward()*(80*i) )
				gib:Spawn()
				timer.Simple( 30, function()
					if IsValid(gib) then
						gib:Remove()
					end
				end )
				local phys = gib:GetPhysicsObject()
				if phys then
					phys:Wake()
					phys:SetMass( phys:GetMass()*10 )
				end
			end
			for k, v in pairs(player.GetAll()) do
				if self:GetRangeSquaredTo(v:WorldSpaceCenter()) < 4096^2 then
					v:SetNWBool("FoolNearBoom",true)
					timer.Simple( 5, function()
						if IsValid(v) then v:SetNWBool("FoolNearBoom",false) end
					end )
				end
			end
			self:Remove()
		end
	end )
end

list.Set( "NPC", "npc_iv04_hr_spirit", {
	Name = "Spirit",
	Class = "npc_iv04_hr_spirit",
	Category = "Halo Reach"
} )