local function resolvePlayerAndMobj(target)
	-- Accept either player_t or mobj (caller may pass either).
	-- Returns: player, mobj (mobj may be nil if not available)
	if not target then return nil, nil end
	if target.player then -- it's an mobj
		return target.player, target
	end
	-- assume it's a player_t
	return target, target.mo
end

local function get_doom_mobj(player)
	return player and player.mo and player.mo.doom
end

local function safe_get_weapon(player)
	if not player then return nil end
	return player.doom and player.doom.curwep
end

local function safe_get_ammo(player, ammoType)
	if not player or not ammoType then return 0 end
	return (player.doom and player.doom.ammo and player.doom.ammo[ammoType]) or 0
end

-- unified damage applicator (returns true if handled)
local function apply_doom_damage(target, damage, attacker, proj, damageType, minhealth)
	local player, mobj = normalize_target(target)
	if not player or not mobj then return false end
	if player.playerstate ~= PST_LIVE then return false end

	local doomm = get_doom_mobj(player) or {}
	local efficiency = doomm.armorefficiency or 0

	local dmgToHealth = FixedMul(damage, efficiency)
	local dmgToArmor  = FixedMul(damage, FRACUNIT - efficiency)

	-- subtract
	doomm.health = (doomm.health or 0) - dmgToHealth
	doomm.armor  = (doomm.armor  or 0) - dmgToArmor

	-- armor underflow -> health gets remainder
	if doomm.armor < 0 then
		doomm.health = doomm.health + doomm.armor
		doomm.armor = 0
	end

	-- enforce minhealth
	if minhealth and doomm.health < minhealth then
		doomm.health = minhealth
	end

	if doomm.health < 1 and player.playerstate == PST_LIVE then
		P_KillMobj(mobj, proj, attacker, damageType)
	else
		P_PlayRinglossSound(mobj)
	end
	return true
end

local baseMethods = {
	getHealth = function(player)
		if not player or not player.mo then return nil end
		return (player.mo.doom and player.mo.doom.health) or nil
	end,

	setHealth = function(player, health)
		if not player or not player.mo then return false end
		if player.mo.doom then
			player.mo.doom.health = health
			return true
		elseif player.mo.hl then
			player.mo.hl.health = health
			return true
		end
		return false
	end,

	getArmor = function(player)
		if not player or not player.mo then return nil end
		if player.mo.doom and player.mo.doom.armor ~= nil then
			return player.mo.doom.armor
		end
		return nil
	end,

	setArmor = function(player, armor, efficiency)
		if not player or not player.mo then return false end
		if not player.mo.doom then return false end

		local doom = player.mo.doom
		local prevArmor = doom.armor or 0

		doom.armor = armor

		-- If efficiency was explicitly passed, use it
		if efficiency ~= nil then
			doom.armorefficiency = efficiency
		-- If armor was raised from 0 → >0 and efficiency wasn't passed, default it
		elseif prevArmor <= 0 and armor > 0 then
			doom.armorefficiency = FRACUNIT/3
		end

		return true
	end,

	getCurAmmo = function(player)
		if not player then return nil end
		if player.doom then
			local weapon = player.doom.curwep
			local wpnStats = doom.weapons[weapon] or {}
			local ammoType = wpnStats.ammotype
			if not ammoType then return nil end
			return player.doom.ammo[ammoType]
		end
		return nil
	end,

	getCurAmmoType = function(player)
		if not player then return nil end
		if player.doom then
			local weapon = player.doom.curwep
			local wpnStats = doom.weapons[weapon] or {}
			local ammoType = wpnStats.ammotype
			return ammoType
		end
		return nil
	end,

	getAmmoFor = function(player, aType, amount)
		if not player or not player.doom or not aType then return false end
		return player.doom.ammo[aType]
	end,

	setAmmoFor = function(player, aType, amount)
		if not player or not player.doom or not aType then return false end
		player.doom.ammo[aType] = amount
		return true
	end,

	getMaxFor = function(player, aType)
		if not player or not aType then return nil end
		if player.doom then
			if player.doom.backpack and doom.ammos[aType] then
				return doom.ammos[aType].backpackmax
			elseif doom.ammos[aType] then
				return doom.ammos[aType].max
			end
		end
		return nil
	end,

	giveWeapon = function(player, weapon)
		if not player or not player.doom or not weapon then return false end
		player.doom.weapons[weapon] = true
		return true
	end,

	-- Unified damage function:
	-- Accepts either a player or an mobj as first parameter (backwards-compatible).
	-- Returns true on handled damage, false otherwise.
	damage = function(player, damage, attacker, proj, damageType, minhealth)
		local player, mobj = resolvePlayerAndMobj(player)
		if not player or not mobj then return false end
		if player.playerstate ~= PST_LIVE then return false end

		-- doom-style with armor efficiency
		if player.mo.doom then
			local efficiency = player.mo.doom.armorefficiency or 0
			local damageToHealth = FixedMul(damage, efficiency)
			local damageToArmor  = FixedMul(damage, FRACUNIT - efficiency)

			player.mo.doom.health = player.mo.doom.health - damageToHealth
			player.mo.doom.armor  = player.mo.doom.armor  - damageToArmor

			if player.mo.doom.armor < 0 then
				player.mo.doom.health = player.mo.doom.health + player.mo.doom.armor
				player.mo.doom.armor = 0
			end

			if minhealth and player.mo.doom.health < minhealth then
				player.mo.doom.health = minhealth
			end

			if player.mo.doom.health < 1 and player.playerstate == PST_LIVE then
				P_KillMobj(mobj, proj, attacker, damageType)
			else
				P_PlayRinglossSound(mobj)
			end
			return true
		end

		return false
	end,
}

-- Helper to shallow-merge override table onto base
local function mergeMethods(base, overrides)
	local out = {}
	for k,v in pairs(base) do out[k] = v end
	if overrides then
		for k,v in pairs(overrides) do out[k] = v end
	end
	return out
end

-- Build doom.charSupport using baseMethods and per-char overrides
doom.charSupport = {
	kombifreeman = {
		-- TODO: Update this! Slowpoke.
		noHUD = true,
		noVanillaWeps = true,
		methods = {
			getHealth = function(player)
				return player.mo.hl.health
			end,
			getArmor = function(player)
				return player.mo.hl.armor / FRACUNIT
			end,
			getCurAmmo = function(player)
				local weapon   = player.hl.curwep
				local wpnStats = HLItems[weapon] or {}
				local curStats = wpnStats.primary
				if not curStats then return false end
	
				local ammoType	= curStats.ammo or "none"
				local clipCnt	 = (player.hlinv.wepclips[weapon] and player.hlinv.wepclips[weapon].primary) or 0
				local ammo = (player.hlinv.ammo[ammoType] or 0) + (clipCnt or 0)
				if ammo <= -1 then return false end
				return ammo
			end,
			setHealth = function(player, health)
				player.mo.hl.health = health
				return true
			end,
			setArmor = function(player, armor, _)
				player.mo.hl.armor = armor*FRACUNIT
				return true
			end,
			damage = function(mobj, damage, attacker, proj, damageType)
				P_DamageMobj(mobj, proj, attacker, damage, damageType)
			end,
		},
	},
	other = {
		noHUD = false,
		methods = baseMethods,
	}
}

setmetatable(doom.charSupport, {
	__index = function(t, key) return t.other end
})