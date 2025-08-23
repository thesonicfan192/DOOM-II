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

SafeFreeSlot("SPR_SGN2")
local name = "SuperShotgun"

local object = {
	radius = 20,
	height = 16,
	doomednum = 82,
	deathsound = sfx_wpnup,
	sprite = SPR_SGN2,
	doomflags = DF_COUNTITEM
}

local states = {
	{frame = A, tics = 6},
}

local function onPickup(item, mobj)
	if not mobj.player then return true end -- Early exit WITHOUT doing vanilla special item stuff (Why is our second argument mobj_t and not player_t???)
	local player = mobj.player
	local funcs = P_GetMethodsForSkin(player)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "supershotgun")
end

DefineDoomItem(name, object, states, onPickup)