local ammoMap = {
	"bullets",
	"shells",
	"rockets",
	"cells"
}

local weaponMap = {
	"brassknuckles",
	"pistol",
	"shotgun",
	"chaingun",
	"rocketlauncher",
	"plasmarifle",
	"bfg9000"
}

COM_AddCommand("idkfa", function(player, victim)
	local funcs = P_GetMethodsForSkin(player)
	funcs.setArmor(player, 200, FRACUNIT/2)
	player.doom.keys = doom.KEY_RED|doom.KEY_BLUE|doom.KEY_YELLOW
	for i = 1, 4 do
		local aType = ammoMap[i]
		local max = funcs.getMaxFor(player, aType)
		funcs.setAmmoFor(player, aType, max)
	end
	for i = 1, #weaponMap do
		funcs.giveWeapon(player, weaponMap[i])
	end
	if not doom.isdoom1 then
		funcs.giveWeapon(player, "supershotgun")
	end
end)

COM_AddCommand("doom_skill", function(player, victim)

end)

COM_AddCommand("doom_endoom", function(player, level)
	doom.showendoom = true
end)