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

SafeFreeSlot("SPR_CLIP", "sfx_itemup")
local name = "Clip"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2007,
	deathsound = sfx_itemup,
	sprite = SPR_CLIP,
	doomflags = DF_COUNTITEM
}

mobjinfo[MT_JACKO2].doomednum = -1

local states = {
	{frame = A, tics = 6},
}

local function onPickup(item, mobj)
	if not mobj.player then return true end -- Early exit WITHOUT doing vanilla special item stuff (Why is our second argument mobj_t and not player_t???)
	local player = mobj.player
	local funcs = P_GetMethodsForSkin(player)
	local ammo = funcs.getAmmoFor(player, "bullets")
	local maxammo = funcs.getMaxFor(player, "bullets")
	if ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "bullets", min(ammo + (10 / divisor), maxammo))
end

DefineDoomItem(name, object, states, onPickup)

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

SafeFreeSlot("SPR_BROK", "sfx_itemup")
local name = "RocketBox"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2046,
	deathsound = sfx_itemup,
	sprite = SPR_BROK,
	doomflags = DF_COUNTITEM
}

mobjinfo[MT_JACKO2].doomednum = -1

local states = {
	{frame = A, tics = 6},
}

local function onPickup(item, mobj)
	if not mobj.player then return true end -- Early exit WITHOUT doing vanilla special item stuff (Why is our second argument mobj_t and not player_t???)
	local player = mobj.player
	local funcs = P_GetMethodsForSkin(player)
	local ammo = funcs.getAmmoFor(player, "rockets")
	local maxammo = funcs.getMaxFor(player, "rockets")
	if ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	funcs.setAmmoFor(player, "rockets", min(ammo + 5, maxammo))
end

DefineDoomItem(name, object, states, onPickup)