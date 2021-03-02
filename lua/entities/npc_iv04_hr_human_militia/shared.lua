AddCSLuaFile()

ENT.Base 			= "npc_iv04_hr_human_ai"

ENT.PrintName = "Militia"

ENT.Models = {"models/halo_reach/characters/other/militia.mdl"}

ENT.StartHealth = 100

ENT.Relationship = 1

ENT.FriendlyToPlayers = true

ENT.PossibleWeapons = {
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	"astw2_haloreach_assault_rifle",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_dmr",
	--"astw2_haloreach_shotgun",
	"astw2_haloreach_magnum"
	--[["astw2_haloreach_rocket_launcher",
	"astw2_haloreach_sniper_rifle",
	"astw2_haloreach_spartan_laser"]]
}

ENT.RandomCombinations = {
	[1] = Color(127,95,0),
	[2] = Color(0,0,0),
	[3] = Color(255,255,255)
}

function ENT:PreInit()
	--[[local r = self.RandomCombinations[math.random(#self.RandomCombinations)]
	self.ColR = r.r
	self.ColG = r.g
	self.ColB = r.b
	self.GetPlayerColor = function()
		return Vector(self.ColR/255,self.ColG/255,self.ColB/255)
	end
	self:SetNWVector("SPColor",self:GetPlayerColor())]]
end

if CLIENT then

	function ENT:Initialize()
		--timer.Simple( 1, function()
			--print(self:GetNWVector("SPColor"))
		--	if IsValid(self) then
			--[[	self.GetPlayerColor = function()
					return self:GetNWVector("SPColor",Vector(0,0,0))
				end]]
			--end
	--	end )
	end

end

function ENT:DoInit()
	local wep = table.Random(self.PossibleWeapons)
	self:Give(wep)
	--self:SetSkin(1)
	--self:SetBodygroup(2,2)
	self:SetBodygroup(2,math.random(0,2))
	self:SetBodygroup(3,math.random(0,5))
	local r = math.random(0,6)
	if r == 5 then self.IsSergeant = true end
	self:SetBodygroup(4,r)
	self:SetBodygroup(5,math.random(-4,1))
	self:SetBodygroup(6,math.random(0,3))
	self:SetBodygroup(7,math.random(0,6))
	self:SetBodygroup(8,math.random(0,2))
	self:SetBodygroup(9,math.random(-2,3))
	self:SetBodygroup(10,math.random(-2,2))
	self:SetBodygroup(11,math.random(0,2))
	self:SetBodygroup(12,math.random(0,2))
	self:SetBodygroup(13,math.random(0,2))
	self:SetBodygroup(14,math.random(0,3))
end

list.Set( "NPC", "npc_iv04_hr_human_militia", {
	Name = "Militia",
	Class = "npc_iv04_hr_human_militia",
	Category = "Halo Reach"
} )