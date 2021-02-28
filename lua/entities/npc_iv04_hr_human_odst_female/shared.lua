AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "ODST"

ENT.Models = {"models/halo_reach/characters/unsc/marine_shared_female.mdl"}

ENT.StartHealth = 140

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.PossibleWeapons = {
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_dmr",
	"astw2_haloreach_dmr",
	"astw2_haloreach_shotgun"
	--"astw2_haloreach_magnum"
	--[["astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"]]
}

ENT.WepOffsets = {
	["astw2_haloreach_assault_rifle"] = {ang = Angle(-10,0,0), pos = {x=8,y=3,z=-2}},
	["astw2_haloreach_rocket_launcher"] = {ang = Angle(260,160,120), pos = {x=5,y=2,z=-3}},
	["astw2_haloreach_spartan_laser"] = {ang = Angle(260,160,100), pos = {x=3,y=0,z=1}},
	["astw2_haloreach_dmr"] = {ang = Angle(-10,0,0), pos = {x=8,y=3,z=-2}},
	["astw2_haloreach_sniper_rifle"] = {ang = Angle(170,0,-100), pos = {x=4,y=2,z=-0.8}},
	["astw2_haloreach_shotgun"] = {ang = Angle(170,0,-100), pos = {x=4,y=2,z=-0.8}},
	["astw2_haloreach_magnum"] = {ang = Angle(280,210,70), pos = {x=4,y=-0,z=2}}
}

ENT.FPossibleVoices = {
	[1] = "FemaleTrooper1"
}

function ENT:OnInitialize()
	self.StartPosition = self:GetPos()
	self.VoiceType = self.FPossibleVoices[math.random(#self.FPossibleVoices)]
	self.AIType = GetConVar("halo_reach_nextbots_ai_type"):GetString() or self.AIType
	self:DoInit()
	self:SetupHoldtypes()
end

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:Give(wep)
	local head = 4
	self:SetBodygroup(2,head)
	local helm
	helm = math.random(4,5)
	self:SetBodygroup(3,helm)
	self:SetBodygroup(6,1)
	self:SetSkin(2)
	self:SetBodygroup(9,2)
	self:SetBodygroup(12,3)
	self:SetBodygroup(13,3)
	self:SetBodygroup(15,1)
	self:SetBodygroup(16,1)
end

function ENT:OnTraceAttack( info, dir, trace )
	if self:Health() - info:GetDamage() < 1 then self.DeathHitGroup = trace.HitGroup return end
	local hg = trace.HitGroup
	if self.FlinchAnims[hg] and !self.DoneFlinch and math.random(100) < self.FlinchChance and info:GetDamage() > self.FlinchDamage then
		self.DoneFlinch = true
		self.DoingFlinch = true
		timer.Simple( math.random(1,2), function()
			if IsValid(self) then
				self.DoneFlinch = false
			end
		end )
		local seq,len = self:LookupSequence(self.FlinchAnims[hg])
		timer.Simple( len, function()
			if IsValid(self) then
				self.DoingFlinch = false
			end
		end )
		local func = function()
			self:PlaySequenceAndMove(seq,1,self:GetForward()*-1,self.FlinchMove[hg],0.4)
		end
		table.insert(self.StuffToRunInCoroutine,func)
		self:ResetAI()
	end
end

list.Set( "NPC", "npc_iv04_hr_human_odst_female", {
	Name = "Orbital Drop Shock Trooper (Female)",
	Class = "npc_iv04_hr_human_odst_female",
	Category = "Halo Reach"
} )