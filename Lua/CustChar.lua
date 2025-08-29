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
			local ammoCount = player.doom.ammo[ammoType]
			if ammoCount <= -1 then
				return false
			end
			return ammoCount
		end
		return false
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

	hasWeapon = function(player, weapon)
		if not player or not player.doom or not weapon then return false end
		return player.doom.weapons[weapon]
	end,

	giveAmmoFor = function(player, aType, amount, source, dflags)
		if not player or not player.doom or not aType then return false end
		local curAmmo = player.doom.ammo[aType]
		local maxAmmo = P_GetMethodsForSkin(player).getMaxFor(player, aType)
		player.doom.ammo[aType] = min(curAmmo + amount, maxAmmo)
		return true
	end,

	damage = function(player, damage, attacker, proj, damageType, minhealth)
		local player, mobj = resolvePlayerAndMobj(player)
		if not player or not mobj then return false end
		if (player.playerstate or PST_LIVE) == PST_DEAD then return false end

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
		noWeapons = true,
		noHUD = true,
		customDamage = true,
		-- TODO: Re-make this! Slowpoke.
		methods = {
			getHealth = function(player)
				if not player or not player.mo then return nil end
				return (player.mo.hl and player.mo.hl.health) or nil
			end,

			setHealth = function(player, health)
				if not player or not player.mo then return false end
				if player.mo.hl then
					player.mo.hl.health = health
					return true
				end
				return false
			end,

			getArmor = function(player)
				if not player or not player.mo then return nil end
				if player.mo.doom and player.mo.doom.armor ~= nil then
					return player.mo.hl.armor / FRACUNIT
				end
				return nil
			end,

			setArmor = function(player, armor, efficiency)
				if not player or not player.mo then return false end
				if not player.mo.hl then return false end

				player.mo.hl.armor = armor*FRACUNIT

				return true
			end,

			getCurAmmo = function(player)
				if not player then return nil end
				if player.hlinv then
					local weapon = player.doom.curwep
					local wpnStats = doom.weapons[weapon] or {}
					local ammoType = wpnStats.ammotype
					if not ammoType then return nil end
					local ammoCount = player.doom.ammo[ammoType]
					if ammoCount <= -1 then
						return false
					end
					return ammoCount
				end
				return false
			end,

			getCurAmmoType = function(player)
				if not player then return nil end
				if player.hlinv then
					local weapon = player.doom.curwep
					local wpnStats = doom.weapons[weapon] or {}
					local ammoType = wpnStats.ammotype
					return ammoType
				end
				return nil
			end,

			getAmmoFor = function(player, aType, amount)
				if not player or not aType then return false end
				return player.hlinv.ammo[aType]
			end,

			setAmmoFor = function(player, aType, amount)
				if not player or not aType then return false end
				player.hlinv.ammo[aType] = amount
				return true
			end,

			giveAmmoFor = function(player, aType, amount, source, dflags)
				if not player or not aType then return false end
				player.hlinv.ammo[aType] = amount
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
				local wepRemaps = {
					pistol = "weapon_9mmhandgun",
					shotgun = "weapon_shotgun",
					supershotgun = "weapon_357",
					chaingun = "weapon_mp5",
					rocketlauncher = "weapon_rpg",
					plasmarifle = "weapon_egon",
					bfg9000 = "weapon_gauss",
				}
				player.hlinv.weapons[wepRemaps[weapon]] = true
				return true
			end,

			hasWeapon = function(player, weapon)
				local wepRemaps = {
					pistol = "weapon_9mmhandgun",
					shotgun = "weapon_shotgun",
					supershotgun = "weapon_357",
					chaingun = "weapon_mp5",
					rocketlauncher = "weapon_rpg",
					plasmarifle = "weapon_egon",
					bfg9000 = "weapon_gauss",
				}
				return player.hlinv.weapons[wepRemaps[weapon]]
			end,

			damage = function(player, damage, attacker, proj, damageType, minhealth)
				if (player.playerstate or PST_LIVE) == PST_DEAD then return false end
				local player, mobj = resolvePlayerAndMobj(player)
				P_DamageMobj(mobj, proj, attacker, damage, damageType)
			end,
		},
	},
	other = {
		methods = baseMethods
	}
}

setmetatable(doom.charSupport, {
	__index = function(t, key) return t.other end
})