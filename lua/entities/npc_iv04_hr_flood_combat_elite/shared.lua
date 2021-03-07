AddCSLuaFile()
ENT.Base 			= "npc_iv04_hr_flood_combat_ai"
ENT.PrintName = "Flood Elite Combat Form"
ENT.StartHealth = 120
ENT.Models = {"models/halo_reach/characters/other/flood_elite_combat_form.mdl"}

ENT.PossibleWeapons = {
	"astw2_halo_cea_plasma_rifle",
	"astw2_halo_cea_shotgun",
	"astw2_halo_cea_plasma_pistol"
}

ENT.VoiceType = "Flood_Elite"

function ENT:SetupHoldtypes()
	if !IsValid(self.Weapon) then
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk"))}
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Unarmed3")),self:GetSequenceActivity(self:LookupSequence("Idle_Unarmed2")),self:GetSequenceActivity(self:LookupSequence("Idle_Unarmed1"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle_Unarmed3")),self:GetSequenceActivity(self:LookupSequence("Idle_Unarmed2")),self:GetSequenceActivity(self:LookupSequence("Idle_Unarmed1"))}
	else
		self.RunAnim = {self:GetSequenceActivity(self:LookupSequence("Run_Weapon"))}
		self.WalkAnim = {self:GetSequenceActivity(self:LookupSequence("Walk_Weapon"))}
		self.IdleCalmAnim = {self:GetSequenceActivity(self:LookupSequence("Idle1")),self:GetSequenceActivity(self:LookupSequence("Idle2")),self:GetSequenceActivity(self:LookupSequence("Idle3")),self:GetSequenceActivity(self:LookupSequence("Idle4"))}
		self.IdleAnim = {self:GetSequenceActivity(self:LookupSequence("Idle1")),self:GetSequenceActivity(self:LookupSequence("Idle2")),self:GetSequenceActivity(self:LookupSequence("Idle3")),self:GetSequenceActivity(self:LookupSequence("Idle4"))}
	end
	self:SetColor(Color(math.random(255),math.random(255),math.random(255)))
	self.GetupAnim1 = "Infect"
	self.GetupAnim2 = "Resurrect"
	self.Seqs = {
		[1] = "Evade_Left",
		[2] = "Evade_Right"
	}
end

list.Set( "NPC", "npc_iv04_hr_flood_combat_elite", {
	Name = "Flood Elite Combat Form",
	Class = "npc_iv04_hr_flood_combat_elite",
	Category = "Halo Reach Aftermath"
} )