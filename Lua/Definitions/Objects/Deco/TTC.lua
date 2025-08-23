local function SafeFreeSlot(...)
    local ret = {}
    for _, name in ipairs({...}) do
        -- If already freed, just use the existing slot
        if rawget(_G, name) ~= nil then
            ret[name] = _G[name]
        else
            -- Otherwise, safely freeslot it and return the value
            ret[name] = freeslot(name)
        end
    end
    return ret
end

SafeFreeSlot("SPR_ELEC")
local name = "TallTechnoColumn"

local object = {
	radius = 16,
	height = 128,
	doomednum = 48,
	sprite = SPR_ELEC,
	bulletheight = 16,
	flags = MF_SOLID,
}

local states = {
	{frame = A, tics = INT32_MAX},
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