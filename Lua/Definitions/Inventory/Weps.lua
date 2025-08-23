DOOM_Freeslot("SPR_PUNG", "SPR_PISG",
"sfx_pistol", "sfx_dshtgn", "sfx_dbopn", "sfx_dbload", "sfx_dbcls")

doom.addWeapon("brassknuckles", {
	sprite = SPR_PUNG,
	weaponslot = 1,
	order = 1,
	damage = {5, 15},
	raycaster = true,
	pellets = 1,
	shotcost = 0,
	spread = {
		horiz = FRACUNIT*59/10,
		vert = 0,
	},
	states = {
		idle = {
			{frame = A, tics = INT32_MAX},
		},
		attack = {
			{frame = B, tics = 4},
			{frame = C, tics = 4, action = A_DoomPunch},
			{frame = D, tics = 5},
			{frame = C, tics = 4},
			{frame = B, tics = 5, action = A_DoomReFire},
		}
	},
	ammotype = "none",
})

doom.addWeapon("pistol", {
	sprite = SPR_PISG,
	weaponslot = 2,
	order = 1,
	damage = {5, 15},
	noinitfirespread = true,
	pellets = 1,
	firesound = sfx_pistol,
	spread = {
		horiz = FRACUNIT*59/10,
		vert = 0,
	},
	states = {
		idle = {
			{frame = A, tics = INT32_MAX},
		},
		attack = {
			{frame = A, tics = 4},
			{frame = B, tics = 6, action = A_DoomFire},
			{frame = C, tics = 4},
			{frame = B, tics = 5, action = A_DoomReFire},
		}
	},
	ammotype = "bullets",
})

DOOM_Freeslot("SPR_SHTG", "SPR_SHT2")

doom.addWeapon("supershotgun", {
	sprite = SPR_SHT2,
	weaponslot = 3,
	order = 1,
	damage = {5, 15},
	pellets = 20,
	firesound = sfx_dshtgn,
	shotcost = 2,
	spread = {
		horiz = FRACUNIT*59/10,
		vert = FRACUNIT*71/10,
	},
	raycaster = true,
	states = {
		idle = {
			{frame = A, tics = INT32_MAX},
		},
		attack = {
			{frame = A, tics = 3},
			{frame = A, tics = 7, action = A_DoomFire},
			{frame = B, tics = 7},
			{frame = C, tics = 7},
			{frame = D, tics = 7, action = A_PlaySound, var1 = sfx_dbopn, var2 = 1},
			{frame = E, tics = 7},
			{frame = F, tics = 7, action = A_PlaySound, var1 = sfx_dbload, var2 = 1},
			{frame = G, tics = 8},
			{frame = H, tics = 8, action = A_PlaySound, var1 = sfx_dbcls, var2 = 1},
			{frame = A, tics = 5, action = A_DoomReFire},
		}
	},
	ammotype = "shells",
})

doom.addWeapon("shotgun", {
	sprite = SPR_SHTG,
	weaponslot = 3,
	order = 2,
	damage = {5, 15},
	pellets = 7,
	firesound = sfx_pistol,
	spread = {
		horiz = FRACUNIT*59/10,
		vert = 0,
	},
	raycaster = true,
	states = {
		idle = {
			{frame = A, tics = INT32_MAX},
		},
		attack = {
			{frame = A, tics = 3},
			{frame = A, tics = 7, action = A_DoomFire},
			{frame = B, tics = 5},
			{frame = C, tics = 5},
			{frame = D, tics = 4},
			{frame = C, tics = 5},
			{frame = B, tics = 5},
			{frame = A, tics = 3},
			{frame = A, tics = 7, action = A_DoomReFire},
		}
	},
	ammotype = "shells",
})

DOOM_Freeslot("SPR_CHGG", "SPR_CHGF")

doom.addWeapon("chaingun", {
	sprite = SPR_CHGG,
	weaponslot = 4,
	order = 1,
	damage = {5, 15},
	noinitfirespread = true,
	pellets = 1,
	firesound = sfx_pistol,
	spread = {
		horiz = FRACUNIT*59/10,
		vert = 0,
	},
	states = {
		idle = {
			{frame = A, tics = INT32_MAX},
		},
		attack = {
			{frame = A, tics = 4, action = A_DoomFire},
			{frame = B, tics = 4, action = A_DoomFire},
			{frame = B, tics = 0, action = A_DoomReFire},
		}
	},
	raycaster = true,
	ammotype = "bullets",
})

doom.addWeapon("rocketlauncher", {
	sprite = SPR_CHGG,
	weaponslot = 5,
	order = 1,
	damage = {5, 15},
	noinitfirespread = true,
	pellets = 1,
	firesound = sfx_pistol,
	spread = {
		horiz = FRACUNIT*59/10,
		vert = 0,
	},
	states = {
		idle = {
			{frame = A, tics = INT32_MAX},
		},
		attack = {
			{frame = A, tics = 4, action = A_DoomFire},
			{frame = B, tics = 4, action = A_DoomFire},
			{frame = B, tics = 0, action = A_DoomReFire},
		}
	},
	raycaster = true,
	ammotype = "rockets",
})