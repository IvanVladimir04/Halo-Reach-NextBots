local checked = {

}

local approved = {

}

local colorz = {

}

-- The code below is not mine, it's already in gmod and I only edited it

--matproxy.ActiveList[ "PlayerColor" ] = nil
--matproxy.ProxyList[ "PlayerColor" ] = nil

matproxy.Add( {
	name = "PlayerColor",

	init = function( self, mat, values )
		self.ResultTo = values.resultvar
	end,

	bind = function( self, mat, ent )
		if ( !IsValid( ent ) ) then return end
		if ent.FriendlyToPlayers then print(ent) end
		if ent.HasSpecialColor then
			--print(ent,ent.HasSpecialColor,ent.SpecialColor)
			local col = HRNBsColors[ent:EntIndex()]
			if ( isvector( col ) ) then
				mat:SetVector( self.ResultTo, col )
			end
		else
			if ( ent:IsRagdoll() ) then
				local owner = ent:GetRagdollOwner()
				if ( IsValid( owner ) ) then ent = owner end
			end
			if ( ent.GetPlayerColor ) then
				local col = ent:GetPlayerColor()
				if ( isvector( col ) ) then
					mat:SetVector( self.ResultTo, col )
				end
			else
				mat:SetVector( self.ResultTo, Vector( 62 / 255, 88 / 255, 106 / 255 ) )
			end
		end
	end
} )