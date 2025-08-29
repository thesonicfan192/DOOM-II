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

SafeFreeSlot("SPR_CSAW", "sfx_wpnup")
local name = "Chainsaw"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2005,
	deathsound = sfx_wpnup,
	sprite = SPR_CSAW,
	doomflags = DF_COUNTITEM
}

local states = {
	{frame = A, tics = 6},
}

local function onPickup(item, mobj)
	if not mobj.player then return true end -- Early exit WITHOUT doing vanilla special item stuff (Why is our second argument mobj_t and not player_t???)
	local player = mobj.player
	local funcs = P_GetMethodsForSkin(player)
	if funcs.hasWeapon(player, "chainsaw") then return true end
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "chainsaw")
	DOOM_DoMessage(player, "GOTCHAINSAW")
end

DefineDoomItem(name, object, states, onPickup)

SafeFreeSlot("SPR_SHOT", "sfx_wpnup")
local name = "Shotgun"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2001,
	deathsound = sfx_wpnup,
	sprite = SPR_SHOT,
	doomflags = DF_COUNTITEM
}

local states = {
	{frame = A, tics = 6},
}

local function onPickup(item, mobj)
	if not mobj.player then return true end -- Early exit WITHOUT doing vanilla special item stuff (Why is our second argument mobj_t and not player_t???)
	local player = mobj.player
	local funcs = P_GetMethodsForSkin(player)
	local funcs = P_GetMethodsForSkin(player)
	local ammo = funcs.getAmmoFor(player, "shells")
	local maxammo = funcs.getMaxFor(player, "shells")
	if funcs.hasWeapon(player, "shotgun") and ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "shells", min(ammo + (8 / divisor), maxammo), "shotgun", item.doom.flags)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "shotgun")
	DOOM_DoMessage(player, "GOTSHOTGUN")
end

DefineDoomItem(name, object, states, onPickup)

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
	local ammo = funcs.getAmmoFor(player, "shells")
	local maxammo = funcs.getMaxFor(player, "shells")
	if funcs.hasWeapon(player, "supershotgun") and ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "shells", min(ammo + (8 / divisor), maxammo), "supershotgun", item.doom.flags)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "supershotgun")
	DOOM_DoMessage(player, "GOTSHOTGUN2")
end

DefineDoomItem(name, object, states, onPickup)

SafeFreeSlot("SPR_LAUN", "sfx_wpnup")
local name = "RPG"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2003,
	deathsound = sfx_wpnup,
	sprite = SPR_LAUN,
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
	local ammo = funcs.getAmmoFor(player, "rockets")
	local maxammo = funcs.getMaxFor(player, "rockets")
	if funcs.hasWeapon(player, "rocketlauncher") and ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "rockets", min(ammo + (2 / divisor), maxammo), "rocketlauncher", item.doom.flags)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "rocketlauncher")
	DOOM_DoMessage(player, "GOTLAUNCHER")
end

DefineDoomItem(name, object, states, onPickup)

SafeFreeSlot("SPR_MGUN", "sfx_wpnup")
local name = "Chaingun"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2002,
	deathsound = sfx_wpnup,
	sprite = SPR_MGUN,
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
	local ammo = funcs.getAmmoFor(player, "bullets")
	local maxammo = funcs.getMaxFor(player, "bullets")
	if funcs.hasWeapon(player, "chaingun") and ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "bullets", min(ammo + (20 / divisor), maxammo), "chaingun", item.doom.flags)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "chaingun")
	DOOM_DoMessage(player, "GOTCHAINGUN")
end

DefineDoomItem(name, object, states, onPickup)

SafeFreeSlot("SPR_PLAS", "sfx_wpnup")
local name = "PlasmaRifle"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2004,
	deathsound = sfx_wpnup,
	sprite = SPR_PLAS,
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
	local ammo = funcs.getAmmoFor(player, "cells")
	local maxammo = funcs.getMaxFor(player, "cells")
	if funcs.hasWeapon(player, "plasmarifle") and ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "cells", min(ammo + (40 / divisor), maxammo), "plasmarifle", item.doom.flags)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "plasmarifle")
	DOOM_DoMessage(player, "GOTPLASMA")
end

DefineDoomItem(name, object, states, onPickup)

SafeFreeSlot("SPR_BFUG", "sfx_wpnup")
local name = "BFG9000"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2006,
	deathsound = sfx_wpnup,
	sprite = SPR_BFUG,
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
	local ammo = funcs.getAmmoFor(player, "cells")
	local maxammo = funcs.getMaxFor(player, "cells")
	if funcs.hasWeapon(player, "bfg9000") and ammo >= maxammo then return true end
	player.doom.bonuscount = 32
	local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
	funcs.setAmmoFor(player, "cells", min(ammo + (40 / divisor), maxammo), "bfg9000", item.doom.flags)
	player.doom.bonuscount = 32
	funcs.giveWeapon(player, "bfg9000")
	DOOM_DoMessage(player, "GOTBFG9000")
end

DefineDoomItem(name, object, states, onPickup)