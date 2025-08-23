local name = "Corpse"


local object = {
	radius = 16,
	height = 20,
	doomednum = 15,
	sprite = SPR_PLAY,
}

local states = {
	{frame = N, tics = INT32_MAX},
}

local function onPickup(item, mobj)
	if not mobj.player then return true end -- Early exit WITHOUT doing vanilla special item stuff (Why is our second argument mobj_t and not player_t???)
	local player = mobj.player
	local funcs = P_GetMethodsForSkin(player)
	local health = funcs.getArmor(player)
	player.doom.bonuscount = 32
	funcs.setArmor(player, min(health + 1, 200))
end

DefineDoomDeco(name, object, states, onPickup)