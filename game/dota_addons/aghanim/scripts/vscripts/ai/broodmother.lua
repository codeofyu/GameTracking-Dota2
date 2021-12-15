
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hWebAbility = thisEntity:FindAbilityByName( "broodmother_web" )

	thisEntity:SetContextThink( "BroodmotherThink", BroodmotherThink, 0.5 )
end

--------------------------------------------------------------------------------

function BroodmotherThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local fSearchRange = thisEntity.hWebAbility:GetCastRange( thisEntity:GetOrigin(), nil )
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.1
	end

	if thisEntity.hWebAbility and thisEntity.hWebAbility:IsFullyCastable() then
		local hFarthestEnemy = hEnemies[ #hEnemies ]
		--local hRandomEnemy = hEnemies[ RandomInt( 1, #hEnemies ) ] 

		return CastWeb( hFarthestEnemy )
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastWeb( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hWebAbility:entindex(),
		Queue = false,
	})

	local fReturnTime = thisEntity.hWebAbility:GetCastPoint() + 0.1
	return fReturnTime
end

--------------------------------------------------------------------------------
