local function SafeFreeSlot(...)
    local ret = {}
    for _, name in ipairs({...}) do
        if rawget(_G, name) ~= nil then
            ret[name] = _G[name]
        else
            ret[name] = freeslot(name)
        end
    end
    return ret
end

-- Clip
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
local states = {
    {frame = A, tics = 6},
}
local function onPickup(item, mobj)
    if not mobj.player then return true end
    local player = mobj.player
    local funcs = P_GetMethodsForSkin(player)
    local ammo = funcs.getAmmoFor(player, "bullets")
    local maxammo = funcs.getMaxFor(player, "bullets")
    if ammo >= maxammo then return true end
    player.doom.bonuscount = 32
    local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
    funcs.giveAmmoFor(player, "bullets", 10 / divisor, "clip", item.doom.flags)
    DOOM_DoMessage(player, "GOTCLIP")
end
DefineDoomItem(name, object, states, onPickup)

-- ClipBox
SafeFreeSlot("SPR_AMMO", "sfx_itemup")
local name = "ClipBox"
local object = {
    radius = 20,
    height = 16,
    doomednum = 2048,
    deathsound = sfx_itemup,
    sprite = SPR_AMMO,
    doomflags = DF_COUNTITEM
}
local states = {
    {frame = A, tics = 6},
}
local function onPickup(item, mobj)
    if not mobj.player then return true end
    local player = mobj.player
    local funcs = P_GetMethodsForSkin(player)
    local ammo = funcs.getAmmoFor(player, "bullets")
    local maxammo = funcs.getMaxFor(player, "bullets")
    if ammo >= maxammo then return true end
    player.doom.bonuscount = 32
    local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
    funcs.giveAmmoFor(player, "bullets", 50 / divisor, "clipbox", item.doom.flags)
    DOOM_DoMessage(player, "GOTCLIPBOX")
end
DefineDoomItem(name, object, states, onPickup)

-- Shells
SafeFreeSlot("SPR_SHEL", "sfx_itemup")
local name = "Shells"
local object = {
    radius = 20,
    height = 16,
    doomednum = 2008,
    deathsound = sfx_itemup,
    sprite = SPR_SHEL,
    doomflags = DF_COUNTITEM
}
local states = {
    {frame = A, tics = 6},
}
local function onPickup(item, mobj)
    if not mobj.player then return true end
    local player = mobj.player
    local funcs = P_GetMethodsForSkin(player)
    local ammo = funcs.getAmmoFor(player, "shells")
    local maxammo = funcs.getMaxFor(player, "shells")
    if ammo >= maxammo then return true end
    player.doom.bonuscount = 32
    local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
    funcs.giveAmmoFor(player, "shells", 4 / divisor, "shells", item.doom.flags)
    DOOM_DoMessage(player, "GOTSHELLS")
end
DefineDoomItem(name, object, states, onPickup)

-- ShellBox
SafeFreeSlot("SPR_SBOX", "sfx_itemup")
local name = "ShellBox"
local object = {
    radius = 20,
    height = 16,
    doomednum = 2049,
    deathsound = sfx_itemup,
    sprite = SPR_SBOX,
    doomflags = DF_COUNTITEM
}
local states = {
    {frame = A, tics = 6},
}
local function onPickup(item, mobj)
    if not mobj.player then return true end
    local player = mobj.player
    local funcs = P_GetMethodsForSkin(player)
    local ammo = funcs.getAmmoFor(player, "shells")
    local maxammo = funcs.getMaxFor(player, "shells")
    if ammo >= maxammo then return true end
    player.doom.bonuscount = 32
    local divisor = (item.doom.flags & DF_DROPPED) and 2 or 1
    funcs.giveAmmoFor(player, "shells", 20 / divisor, "shellbox", item.doom.flags)
    DOOM_DoMessage(player, "GOTSHELLBOX")
end
DefineDoomItem(name, object, states, onPickup)

-- Rocket
SafeFreeSlot("SPR_ROCK", "sfx_itemup")
local name = "Rocket"
local object = {
    radius = 20,
    height = 16,
    doomednum = 2010,
    deathsound = sfx_itemup,
    sprite = SPR_ROCK,
    doomflags = DF_COUNTITEM
}
local states = {
    {frame = A, tics = 6},
}
local function onPickup(item, mobj)
    if not mobj.player then return true end
    local player = mobj.player
    local funcs = P_GetMethodsForSkin(player)
    local ammo = funcs.getAmmoFor(player, "rockets")
    local maxammo = funcs.getMaxFor(player, "rockets")
    if ammo >= maxammo then return true end
    player.doom.bonuscount = 32
    funcs.giveAmmoFor(player, "rockets", 1, "rockets", item.doom.flags)
    DOOM_DoMessage(player, "GOTROCKET")
end
DefineDoomItem(name, object, states, onPickup)

-- RocketBox
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
local states = {
    {frame = A, tics = 6},
}
local function onPickup(item, mobj)
    if not mobj.player then return true end
    local player = mobj.player
    local funcs = P_GetMethodsForSkin(player)
    local ammo = funcs.getAmmoFor(player, "rockets")
    local maxammo = funcs.getMaxFor(player, "rockets")
    if ammo >= maxammo then return true end
    player.doom.bonuscount = 32
    funcs.giveAmmoFor(player, "rockets", 5, "rocketbox", item.doom.flags)
    DOOM_DoMessage(player, "GOTROCKBOX")
end
DefineDoomItem(name, object, states, onPickup)