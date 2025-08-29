states[S_DOOM_IMPFIRE] = {
    sprite    = SPR_BAL1,
    frame     = A|FF_ANIMATE,
	tics      = -1,
	var1      = 1,
	var2      = 4,
	nextstate = S_NULL
}

mobjinfo[MT_TROOPSHOT] = {
	spawnstate   = S_DOOM_IMPFIRE,
	seesound     = sfx_firsht,
	speed        = 10 * FRACUNIT,
	radius       = 6 * FRACUNIT,
	height       = 8 * FRACUNIT,
	flags        = MF_MISSILE|MF_NOGRAVITY,
}

local gameskill = 3
local sk_nightmare = 4

/*
void A_Look (mobj_t* actor)
{
    mobj_t*	targ;
	
    actor->threshold = 0;	// any shot will wake up
    targ = actor->subsector->sector->soundtarget;

    if (targ
	&& (targ->flags & MF_SHOOTABLE) )
    {
	actor->target = targ;

	if ( actor->flags & MF_AMBUSH )
	{
	    if (P_CheckSight (actor, actor->target))
		goto seeyou;
	}
	else
	    goto seeyou;
    }
	
	
    if (!P_LookForPlayers (actor, false) )
	return;
		
    // go into chase state
  seeyou:
    if (actor->info->seesound)
    {
	int		sound;
		
	switch (actor->info->seesound)
	{
	  case sfx_posit1:
	  case sfx_posit2:
	  case sfx_posit3:
	    sound = sfx_posit1+P_Random()%3;
	    break;

	  case sfx_bgsit1:
	  case sfx_bgsit2:
	    sound = sfx_bgsit1+P_Random()%2;
	    break;

	  default:
	    sound = actor->info->seesound;
	    break;
	}

	if (actor->type==MT_SPIDER
	    || actor->type == MT_CYBORG)
	{
	    // full volume
	    S_StartSound (NULL, sound);
	}
	else
	    S_StartSound (actor, sound);
    }

    P_SetMobjState (actor, actor->info->seestate);
}
*/

function A_DoomLook(actor)
	local targ = actor.subsector.sector.soundtarget
	actor.threshold = 0 // any shot will wake up

	local gotoseeyou = false

	if targ and (targ.flags & MF_SHOOTABLE) then
		actor.target = targ

		if (actor.flags2 & MF2_AMBUSH) then
			if P_CheckSight(actor, actor.target) then
				gotoseeyou = true
			end
		else
			gotoseeyou = true
		end
	end

	if not gotoseeyou then
		if not P_LookForPlayers(actor, MELEERANGE * 8, false) then
			return
		end
	end

	-- seeyou:
	local sound = nil
	if actor.info.seesound then
		local seesound = actor.info.seesound
		if seesound == sfx_posit1 or seesound == sfx_posit2 or seesound == sfx_posit3 then
			sound = sfx_posit1 + P_RandomByte()%3
		elseif seesound == sfx_bgsit1 or seesound == sfx_bgsit2 then
			sound = sfx_bgsit1 + P_RandomByte()%2
		else
			sound = seesound
		end
/*
		if actor.type == MT_SPIDER or actor.type == MT_CYBORG then
			S_StartSound(nil, sound) -- full volume
		else
			S_StartSound(actor, sound)
		end
*/
		S_StartSound(actor, sound)
	end

	actor.state = actor.info.seestate
	actor.reactiontime = 8
end

/*
//
// A_Chase
// Actor has a melee attack,
// so it tries to close as fast as possible
//
void A_Chase (mobj_t*	actor)
{
    int		delta;

    if (actor->reactiontime)
	actor->reactiontime--;
				

    // modify target threshold
    if  (actor->threshold)
    {
	if (!actor->target
	    || actor->target->health <= 0)
	{
	    actor->threshold = 0;
	}
	else
	    actor->threshold--;
    }
    
    // turn towards movement direction if not there yet
    if (actor->movedir < 8)
    {
	actor->angle &= (7<<29);
	delta = actor->angle - (actor->movedir << 29);
	
	if (delta > 0)
	    actor->angle -= ANG90/2;
	else if (delta < 0)
	    actor->angle += ANG90/2;
    }

    if (!actor->target
	|| !(actor->target->flags&MF_SHOOTABLE))
    {
	// look for a new target
	if (P_LookForPlayers(actor,true))
	    return; 	// got a new target
	
	P_SetMobjState (actor, actor->info->spawnstate);
	return;
    }
    
    // do not attack twice in a row
    if (actor->flags & MF_JUSTATTACKED)
    {
	actor->flags &= ~MF_JUSTATTACKED;
	if (gameskill != sk_nightmare && !fastparm)
	    P_NewChaseDir (actor);
	return;
    }
    
    // check for melee attack
    if (actor->info->meleestate
	&& P_CheckMeleeRange (actor))
    {
	if (actor->info->attacksound)
	    S_StartSound (actor, actor->info->attacksound);

	P_SetMobjState (actor, actor->info->meleestate);
	return;
    }
    
    // check for missile attack
    if (actor->info->missilestate)
    {
	if (gameskill < sk_nightmare
	    && !fastparm && actor->movecount)
	{
	    goto nomissile;
	}
	
	if (!P_CheckMissileRange (actor))
	    goto nomissile;
	
	P_SetMobjState (actor, actor->info->missilestate);
	actor->flags |= MF_JUSTATTACKED;
	return;
    }

    // ?
  nomissile:
    // possibly choose another target
    if (netgame
	&& !actor->threshold
	&& !P_CheckSight (actor, actor->target) )
    {
	if (P_LookForPlayers(actor,true))
	    return;	// got a new target
    }
    
    // chase towards player
    if (--actor->movecount<0
	|| !P_Move (actor))
    {
	P_NewChaseDir (actor);
    }
    
    // make active sound
    if (actor->info->activesound
	&& P_Random () < 3)
    {
	S_StartSound (actor, actor->info->activesound);
    }
}
*/

function A_DoomChase(actor)
	local delta

	if actor.reactiontime and actor.reactiontime > 0 then
		actor.reactiontime = $ - 1
	end

	// Modify target threshold
	if actor.threshold then
		if not actor.target or actor.target.health <= 0 then
			actor.threshold = 0
		else
			actor.threshold = $ - 1
		end
	end

	// Turn toward movement direction if not there yet
	if actor.movedir and actor.movedir < 8 then
		actor.angle = $ & (7 << 29)
		delta = actor.angle - (actor.movedir << 29)

		if delta > 0 then
			actor.angle = $ - (ANGLE_90 / 2)
		elseif delta < 0 then
			actor.angle = $ + (ANGLE_90 / 2)
		end
	end

	// No valid target
	if not actor.target or not (actor.target.flags & MF_SHOOTABLE) then
		if P_LookForPlayers(actor, MELEERANGE * 8, true) then
			return
		end

		actor.state = actor.info.spawnstate
		return
	end

	// Prevent attacking twice in a row
	if (actor.flags2 & MF2_JUSTATTACKED) then
		actor.flags2 = $ & ~MF2_JUSTATTACKED
		if gameskill ~= sk_nightmare and not fastparm then
			P_NewChaseDir(actor)
		end
		return
	end

	// Melee attack check
	if actor.info.meleestate and P_CheckMeleeRange(actor) then
		if actor.info.attacksound then
			S_StartSound(actor, actor.info.attacksound)
		end
		actor.state = actor.info.meleestate
		return
	end

	// Missile attack check
	local doMissile = true
	if actor.info.missilestate then
		if gameskill < sk_nightmare and not fastparm and actor.movecount then
			doMissile = false
		end

		if doMissile and P_CheckMissileRange(actor) then
			actor.state = actor.info.missilestate
			actor.flags2 = $ | MF2_JUSTATTACKED
			return
		end
	end

	// Possibly choose another target if in netgame and can't see player
	if netgame and actor.threshold == 0 and not P_CheckSight(actor, actor.target) then
		if P_LookForPlayers(actor, MELEERANGE * 8, true) then
			return
		end
	end

	// Chase toward player
	actor.movecount = $ - 1
	if actor.movecount < 0 or not P_Move(actor, actor.info.speed / FRACUNIT) then
		P_NewChaseDir(actor)
	end

	// Play active sound
	if actor.info.activesound and P_RandomByte() < 3 then
		S_StartSound(actor, actor.info.activesound)
	end
end

/*
void A_FaceTarget (mobj_t* actor)
{	
    if (!actor->target)
	return;
    
    actor->flags &= ~MF_AMBUSH;
	
    actor->angle = R_PointToAngle2 (actor->x,
				    actor->y,
				    actor->target->x,
				    actor->target->y);
    
    if (actor->target->flags & MF_SHADOW)
	actor->angle += (P_Random()-P_Random())<<21;
}
*/

function A_DoomFaceTarget(actor)
    if (not actor.target) then return end
    
    actor.flags2 = $ & ~MF2_AMBUSH
	
    actor.angle = R_PointToAngle2(actor.x,
				    actor.y,
				    actor.target.x,
				    actor.target.y)
    
    if (actor.target.doom.flags & DF_SHADOW) then
		actor.angle = $ + (P_RandomByte()-P_RandomByte())<<21
	end
end

/*
void A_TroopAttack (mobj_t* actor)
{
    int		damage;
	
    if (!actor->target)
	return;
		
    A_FaceTarget (actor);
    if (P_CheckMeleeRange (actor))
    {
	S_StartSound (actor, sfx_claw);
	damage = (P_Random()%8+1)*3;
	P_DamageMobj (actor->target, actor, actor, damage);
	return;
    }

    
    // launch a missile
    P_SpawnMissile (actor, actor->target, MT_TROOPSHOT);
}
*/

function A_DoomTroopAttack(actor)
    local damage
	
    if (not actor.target) then
		return
	end

    A_FaceTarget(actor);
    if (P_CheckMeleeRange (actor)) then
		S_StartSound (actor, sfx_claw);
		damage = (P_RandomByte()%8+1)*3;
		DOOM_DamageMobj(actor.target, actor, actor, damage);
		return
    end

    
    // launch a missile
    DOOM_SpawnMissile(actor, actor.target, MT_TROOPSHOT)
end

/*
void A_Pain (mobj_t* actor)
{
    if (actor->info->painsound)
	S_StartSound (actor, actor->info->painsound);	
}
*/

function A_DoomPain(actor)
    if (actor.info.painsound)
		S_StartSound (actor, actor.info.painsound)
	end
end

/*
void A_Scream (mobj_t* actor)
{
    int		sound;
	
    switch (actor->info->deathsound)
    {
      case 0:
	return;
		
      case sfx_podth1:
      case sfx_podth2:
      case sfx_podth3:
	sound = sfx_podth1 + P_Random ()%3;
	break;
		
      case sfx_bgdth1:
      case sfx_bgdth2:
	sound = sfx_bgdth1 + P_Random ()%2;
	break;
	
      default:
	sound = actor->info->deathsound;
	break;
    }

    // Check for bosses.
    if (actor->type==MT_SPIDER
	|| actor->type == MT_CYBORG)
    {
	// full volume
	S_StartSound (NULL, sound);
    }
    else
	S_StartSound (actor, sound);
}

*/
function A_DoomScream(actor)
    local sound
	
	if not actor.info.deathsound then
		return
	elseif actor.info.deathsound == sfx_podth1 or actor.info.deathsound == sfx_podth2 or actor.info.deathsound == sfx_podth3 then
		sound = sfx_podth1 + P_RandomByte()%3
	elseif actor.info.deathsound == sfx_bgdth1 or actor.info.deathsound == sfx_bgdth2 then
		sound = sfx_bgdth1 + P_RandomByte()%2
	else
		sound = actor.info.deathsound
	end
/*
    // Check for bosses.
    if (actor.type==MT_SPIDER or actor.type == MT_CYBORG)
		// full volume
		S_StartSound (NULL, sound)
    else
		S_StartSound (actor, sound)
	end
*/
	S_StartSound(actor, sound)
end

/*
void A_Fall (mobj_t *actor)
{
    // actor is on ground, it can be walked over
    actor->flags &= ~MF_SOLID;

    // So change this if corpse objects
    // are meant to be obstacles.
}
*/

function A_DoomFall(actor)
    // actor is on ground, it can be walked over
    actor.flags = $ & ~MF_SOLID

    // So change this if corpse objects
    // are meant to be obstacles.
end

/*
void A_XScream (mobj_t* actor)
{
    S_StartSound (actor, sfx_slop);	
}
*/

function A_DoomXScream(actor)
    S_StartSound(actor, sfx_slop)
end

/*
action void A_ReFire(statelabel flash = null, bool autoSwitch = true)
{
	let player = player;
	bool pending;

	if (NULL == player)
	{
		return;
	}
	pending = player.PendingWeapon != WP_NOCHANGE && (player.WeaponState & WF_REFIRESWITCHOK);
	if ((player.cmd.buttons & BT_ATTACK)
		&& !player.ReadyWeapon.bAltFire && !pending && player.health > 0)
	{
		player.refire++;
		player.mo.FireWeapon(ResolveState(flash));
	}
	else if ((player.cmd.buttons & BT_ALTATTACK)
		&& player.ReadyWeapon.bAltFire && !pending && player.health > 0)
	{
		player.refire++;
		player.mo.FireWeaponAlt(ResolveState(flash));
	}
	else
	{
		player.refire = 0;
		player.ReadyWeapon.CheckAmmo (player.ReadyWeapon.bAltFire? Weapon.AltFire : Weapon.PrimaryFire, autoSwitch);
	}
}
*/

function A_DoomPunch(actor)
	local player = actor.player
	if player == nil then return end
	local mult = player.doom.powers[pw_strength] and 10 or 1
	DOOM_Fire(player, MELEERANGE, 0, 0, 1, 5 * mult, 15 * mult)
end

-- Cut-down definitions for SPECIFICALLY enemies
doom.predefinedWeapons = {
	{
		damage = {5, 15},
		pellets = 1,
		firesound = sfx_pistol,
		spread = {
			horiz = FRACUNIT*59/10,
			vert = 0,
		},
	},
	{
		damage = {5, 15},
		pellets = 3,
		firesound = sfx_shotgn,
		spread = {
			horiz = FRACUNIT*59/10,
			vert = 0,
		},
	},
}

function A_DoomFire(actor, isPlayer, weaponDef, weapon)
    -- Determine if this is a player or enemy
    local isPlayerActor = isPlayer or (actor.player ~= nil)
    local player = actor.player
    
    if isPlayerActor then
        -- Player logic
        local funcs = P_GetMethodsForSkin(player)
        local curAmmo = funcs.getCurAmmo(player)
        local curType = funcs.getCurAmmoType(player)

        if curAmmo - weapon.shotcost < 0 then return end

		if weapon.firesound then
			S_StartSound(actor, weapon.firesound)
		end

        local spread

        if weapon.noinitfirespread and not player.doom.refire then
            spread = {horiz = 0, vert = 0}
        else
            spread = weapon.spread
        end

        funcs.setAmmoFor(player, curType, curAmmo - weapon.shotcost)

        DOOM_Fire(player, weapon.maxdist or MISSILERANGE, weapon.spread.horiz or 0, weapon.spread.vert or 0, weapon.pellets or 1, weapon.damage[1], weapon.damage[2])
    else
		local weapon = doom.predefinedWeapons[weaponDef or 1]
        -- Enemy logic
        S_StartSound(actor, weapon.firesound)
        
        -- For enemies, we need to create a mock player structure for Doom_Fire
        -- or modify Doom_Fire to accept enemy actors directly
        -- This assumes Doom_Fire can handle nil player for enemies
        DOOM_Fire(nil, weapon.maxdist or MISSILERANGE, weapon.spread.horiz or 0, weapon.spread.vert or 0, weapon.pellets or 1, weapon.damage[1], weapon.damage[2], actor)
    end
end

function A_DoomReFire(actor)
	local player = actor.player
	if player == nil then return end

	local wepDef = DOOM_GetWeaponDef(player)
	local curWepAmmo = player.doom.ammo[wepDef.ammotype]
	local ammoNeeded = wepDef.shotcost

	if max(curWepAmmo, 0) >= ammoNeeded and (player.cmd.buttons & BT_ATTACK) and not player.doom.switchtimer and player.mo.doom.health > 0 then
		player.doom.refire = ($ or 0) + 1
		DOOM_FireWeapon(player)
	else
		player.doom.refire = 0
		DOOM_DoAutoSwitch(player)
	end
end

/*
void A_CPosRefire (mobj_t* actor)
{	
    // keep firing unless target got out of sight
    A_FaceTarget (actor);

    if (P_Random () < 40)
	return;

    if (!actor->target
	|| actor->target->health <= 0
	|| !P_CheckSight (actor, actor->target) )
    {
	P_SetMobjState (actor, actor->info->seestate);
    }
}
*/

function A_CPosRefire(actor)
    A_DoomFaceTarget(actor)
	
	if P_RandomByte() < 40 then return end
	
	if not actor.target or actor.target.doom.health <= 0 or not P_CheckSight(actor, actor.target) then
		actor.state = actor.info.seestate
	end
end