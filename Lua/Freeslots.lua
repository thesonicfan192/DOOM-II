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

SafeFreeSlot("sfx_swtchn", "sfx_swtchx", "sfx_slop",
"sfx_pistol", "sfx_secret",
"MT_TROOPSHOT", "S_DOOM_IMPFIRE", "SPR_BAL1", "sfx_firsht", "sfx_bgact", "sfx_bgdth1", "sfx_bgdth2", "sfx_bgsit1", "sfx_bgsit2", "sfx_claw",
"sfx_podth1", "sfx_podth2", "sfx_podth3", "sfx_popain", "sfx_posact", "sfx_posit1", "sfx_posit2", "sfx_posit3", "MT_DOOM_TELEFOG", "SPR_TFOG", "sfx_telept")

SafeFreeSlot(
"S_TELEFOG1",
"S_TELEFOG2",
"S_TELEFOG3",
"S_TELEFOG4",
"S_TELEFOG5",
"S_TELEFOG6",
"S_TELEFOG7",
"S_TELEFOG8",
"S_TELEFOG9",
"S_TELEFOG10",
"S_TELEFOG11",
"S_TELEFOG12",
"TOL_DOOM",
"MT_DOOM_TELETARGET"
)

G_AddGametype({
    name = "DOOM",
    identifier = "doom",
    typeoflevel = TOL_SP|TOL_DOOM,
    rules = GTR_CAMPAIGN|GTR_FIRSTPERSON|GTR_FRIENDLYFIRE|GTR_RESPAWNDELAY|GTR_SPAWNENEMIES|GTR_ALLOWEXIT|GTR_NOTITLECARD,
    intermissiontype = int_none,
    headercolor = 103,
    description = "Ouggggghhhh I'm dooming it. I'm dooming it so good."
})

-- Idak how DOOM does this so this is the closest you'll get from me
local hardcodedDamageVals = {
	[MT_TROOPSHOT] = {3, 24}
}

local function BulletHitObject(tmthing, thing)
	-- print("Collision!")
    if tmthing.hitenemy then return false end
	-- print(tmthing.target, thing, tmthing.target == thing, thing.type != MT_METALSONIC_BATTLE)
    if tmthing.target == thing then return false end
	-- print(thing.type, thing.type == MT_METALSONIC_BATTLE)
	if not (thing.flags & MF_SHOOTABLE) then return false end

	local damageVals = hardcodedDamageVals[tmthing.type]
	local damage = (P_RandomByte() % (damageVals[2] / damageVals[1]) + 1) * damageVals[1]

	tmthing.hitenemy = true
    DOOM_DamageMobj(thing, tmthing, tmthing.target, damage, damagetype)
	P_KillMobj(tmthing)
	return false
end

local projectiles = {
	MT_TROOPSHOT,
}

for _, mt in ipairs(projectiles) do
    addHook("MobjMoveCollide", BulletHitObject, mt)
end

states[S_TELEFOG1] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|A,
    tics = 6,
	action = A_PlaySound,
	var1 = sfx_telept,
	var2 = 1,
    nextstate = S_TELEFOG2
}

states[S_TELEFOG2] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|B,
    tics = 6,
    nextstate = S_TELEFOG3
}

states[S_TELEFOG3] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|A,
    tics = 6,
    nextstate = S_TELEFOG4
}

states[S_TELEFOG4] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|B,
    tics = 6,
    nextstate = S_TELEFOG5
}

states[S_TELEFOG5] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|C,
    tics = 6,
    nextstate = S_TELEFOG6
}

states[S_TELEFOG6] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|D,
    tics = 6,
    nextstate = S_TELEFOG7
}

states[S_TELEFOG7] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|E,
    tics = 6,
    nextstate = S_TELEFOG8
}

states[S_TELEFOG8] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|F,
    tics = 6,
    nextstate = S_TELEFOG9
}

states[S_TELEFOG9] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|G,
    tics = 6,
    nextstate = S_TELEFOG10
}

states[S_TELEFOG10] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|H,
    tics = 6,
    nextstate = S_TELEFOG11
}

states[S_TELEFOG11] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|I,
    tics = 6,
    nextstate = S_TELEFOG12
}

states[S_TELEFOG12] = {
    sprite = SPR_TFOG,
    frame = FF_FULLBRIGHT|J,
    tics = 6,
    nextstate = S_NULL
}

mobjinfo[MT_DOOM_TELEFOG] = {
spawnstate = S_TELEFOG1,
spawnhealth = 1000,
deathstate = S_TELEFOG1,
radius = 20*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 5,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP,
}

mobjinfo[MT_DOOM_TELETARGET] = {
spawnstate = S_PLAY_STND,
spawnhealth = 1000,
doomednum = 14,
deathstate = S_PLAY_STND,
radius = 20*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 5,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP,
}