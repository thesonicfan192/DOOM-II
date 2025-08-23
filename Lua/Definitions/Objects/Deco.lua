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

SafeFreeSlot("SPR_COLU")
local name = "FloorLamp"

local object = {
	radius = 20,
	height = 16,
	doomednum = 2028,
	sprite = SPR_COLU,
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

SafeFreeSlot("SPR_TLP2")
local name = "ShortTechnoFloorLamp"

local object = {
	radius = 16,
	height = 60,
	doomednum = 86,
	sprite = SPR_TLP2,
	bulletheight = 16,
	flags = MF_SOLID,
}

local states = {
	{frame = A|FF_FULLBRIGHT, tics = 4},
	{frame = B|FF_FULLBRIGHT, tics = 4},
	{frame = C|FF_FULLBRIGHT, tics = 4},
	{frame = D|FF_FULLBRIGHT, tics = 4},
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

SafeFreeSlot("SPR_TLMP")
local name = "TallTechnoFloorLamp"

local object = {
	radius = 16,
	height = 80,
	doomednum = 85,
	sprite = SPR_TLMP,
	bulletheight = 16,
	flags = MF_SOLID,
}

local states = {
	{frame = A|FF_FULLBRIGHT, tics = 4},
	{frame = B|FF_FULLBRIGHT, tics = 4},
	{frame = C|FF_FULLBRIGHT, tics = 4},
	{frame = D|FF_FULLBRIGHT, tics = 4},
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