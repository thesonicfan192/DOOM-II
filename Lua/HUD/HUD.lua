-- Table of face sprite names in Doom IWAD order
local st_faces = {
	-- Pain offset 0
	"STFST00", "STFST01", "STFST02",  -- straight ahead
	"STFTL00", "STFTR00",             -- turn left/right
	"STFOUCH0",                        -- ouch
	"STFEVL0",                         -- evil grin
	"STFKILL0",                        -- rampage

	-- Pain offset 1
	"STFST10", "STFST11", "STFST12",
	"STFTL10", "STFTR10",
	"STFOUCH1",
	"STFEVL1",
	"STFKILL1",

	-- Pain offset 2
	"STFST20", "STFST21", "STFST22",
	"STFTL20", "STFTR20",
	"STFOUCH2",
	"STFEVL2",
	"STFKILL2",

	-- Pain offset 3
	"STFST30", "STFST31", "STFST32",
	"STFTL30", "STFTR30",
	"STFOUCH3",
	"STFEVL3",
	"STFKILL3",

	-- Pain offset 4
	"STFST40", "STFST41", "STFST42",
	"STFTL40", "STFTR40",
	"STFOUCH4",
	"STFEVL4",
	"STFKILL4",

	-- God face
	"STFGOD0",

	-- Dead face
	"STFDEAD0"
}

local function drawWeapon(v, player)
	local bobAngle = ((128 * leveltime) & 8191) << 19
	local bobx = FixedMul((player.hl1wepbob or 0), cos(bobAngle))
	bobAngle = ((128 * leveltime) & 4095) << 19
	local boby = FixedMul((player.hl1wepbob or 0), sin(bobAngle))
	local preScaledOffset = (player.doom.deadtimer or player.deadtimer) + (player.doom and player.doom.switchtimer or 0)
	boby = $ + 6*FRACUNIT * preScaledOffset
	local sprite = doom.weapons[player.doom.curwep].sprite
	local whatFrame = doom.weapons[player.doom.curwep].states[player.doom.wepstate][player.doom.wepframe].frame
	local patch = v.getSpritePatch(sprite, whatFrame)
	local sector = R_PointInSubsector(player.mo.x, player.mo.y).sector

	local extraflag = (player.mo.doom.flags & DF_SHADOW) and V_MODULATE or 0

	v.drawScaled(bobx, boby + 16 * FRACUNIT, FRACUNIT, patch, V_PERPLAYER|extraflag, v.getSectorColormap(sector, player.mo.x, player.mo.y, player.mo.z, sector.lightlevel))
end

local function drawStatusBar(v, player)
	v.draw(0, 168, v.cachePatch("STBAR"), V_PERPLAYER)
	v.draw(104, 168, v.cachePatch("STARMS"), V_PERPLAYER)
	if netgame then
		v.draw(143, 169, v.cachePatch("STFB0"), V_PERPLAYER, v.getColormap("johndoom", player.mo.color))
	end
end

local function drawFace(v, player)
	local index = player.doom.faceindex + 1
	local patch = st_faces[index]
	if patch != nil then
		v.draw(143, 168, v.cachePatch(patch), V_PERPLAYER)
	else
		print(index .. " IS MISSING AN ASSOCIATED ENTRY! MOD SUCKS PLS FIX")
	end
end

hud.add(function(v, player)
	local support = P_GetSupportsForSkin(player)
	if support.noHUD then return end

	local funcs = P_GetMethodsForSkin(player)
	local myHealth = funcs.getHealth(player) or 0
	local myArmor = funcs.getArmor(player) or 0
	local myAmmo = funcs.getCurAmmo(player) or 0

	hud.disable("score")
	hud.disable("time")
	hud.disable("rings")
	hud.disable("crosshair")

	drawWeapon(v, player)
	drawStatusBar(v, player)
	drawFace(v, player)
-- 	print(player.doom.curwep, player.doom.curwepcat, player.doom.curwepslot)
	drawInFont(v, 0, 0, FRACUNIT, "STCFN", player.doom.message)

	local percentPatch = v.cachePatch("STTNUM0")
	local percentsOffset = percentPatch.width

	if myAmmo != false then
		drawInFont(v, 44*FRACUNIT, 171*FRACUNIT, FRACUNIT, "STT", tostring(myAmmo), V_PERPLAYER, "right")
	end
	drawInFont(v, (90 + percentsOffset)*FRACUNIT, 171*FRACUNIT, FRACUNIT, "STT", myHealth .. "%", V_PERPLAYER, "right")
	drawInFont(v, (221 + percentsOffset)*FRACUNIT, 171*FRACUNIT, FRACUNIT, "STT", myArmor .. "%", V_PERPLAYER, "right")
	local ammosToIndex = {
		"bullets",
		"shells",
		"rockets",
		"cells"
	}
	for i = 0, 3 do
		local whatToIndex = ammosToIndex[i + 1]
		drawInFont(v, 288*FRACUNIT, (173 + (i * 6))*FRACUNIT, FRACUNIT, "STYSNUM", player.doom.ammo[whatToIndex], V_PERPLAYER, "right")
	end
	for i = 0, 3 do
		local whatToIndex = ammosToIndex[i + 1]
		drawInFont(v, 314*FRACUNIT, (173 + (i * 6))*FRACUNIT, FRACUNIT, "STYSNUM", doom.ammos[whatToIndex].max, V_PERPLAYER, "right")
	end
	local whatToCheck = {
		"brassknuckles",
		"pistol",
		"shotgun",
		"chaingun",
		"rocketlauncher",
		"plasmarifle",
		"bfg9000"
	}
	for i = 0, 5 do
		local whatToIndex = whatToCheck[i + 2]
		local doIHaveIt = player.doom.weapons[whatToIndex]
		local whatFont = doIHaveIt and "STYSNUM" or "STGNUM"
		drawInFont(v, (111 + (i%3 * 12))*FRACUNIT, (172 + (i/3 * 10))*FRACUNIT, FRACUNIT, whatFont, i + 2, V_PERPLAYER, "left")
	end

local scale = FRACUNIT/2

local VIEW_XMIN, VIEW_YMIN = 0, 0
local VIEW_XMAX, VIEW_YMAX = 320, 200

-- Outcode flags
local INSIDE, LEFT, RIGHT, BOTTOM, TOP = 0, 1, 2, 4, 8

local function computeOutCode(x, y)
    local code = INSIDE
    if x < VIEW_XMIN then code = code | LEFT
    elseif x > VIEW_XMAX then code = code | RIGHT end
    if y < VIEW_YMIN then code = code | TOP
    elseif y > VIEW_YMAX then code = code | BOTTOM end
    return code
end

-- Clips a line to the viewport, returns (x1,y1,x2,y2) or nil if fully outside
local function clipLine(x1, y1, x2, y2)
    local outcode1 = computeOutCode(x1, y1)
    local outcode2 = computeOutCode(x2, y2)
    local accept = false

    while true do
        if outcode1 == 0 and outcode2 == 0 then
            -- both inside
            accept = true
            break
        elseif (outcode1 & outcode2) ~= 0 then
            -- both share an outside zone -> reject
            break
        else
            -- At least one endpoint is outside, clip it
            local outcodeOut = (outcode1 ~= 0) and outcode1 or outcode2
            local x, y

            if (outcodeOut & TOP) ~= 0 then
                x = x1 + (x2 - x1) * (VIEW_YMIN - y1) / (y2 - y1)
                y = VIEW_YMIN
            elseif (outcodeOut & BOTTOM) ~= 0 then
                x = x1 + (x2 - x1) * (VIEW_YMAX - y1) / (y2 - y1)
                y = VIEW_YMAX
            elseif (outcodeOut & RIGHT) ~= 0 then
                y = y1 + (y2 - y1) * (VIEW_XMAX - x1) / (x2 - x1)
                x = VIEW_XMAX
            elseif (outcodeOut & LEFT) ~= 0 then
                y = y1 + (y2 - y1) * (VIEW_XMIN - x1) / (x2 - x1)
                x = VIEW_XMIN
            end

            if outcodeOut == outcode1 then
                x1, y1 = x, y
                outcode1 = computeOutCode(x1, y1)
            else
                x2, y2 = x, y
                outcode2 = computeOutCode(x2, y2)
            end
        end
    end

    if accept then
        return x1, y1, x2, y2
    end
    return nil
end

for line in lines.iterate do
    local x1 = line.v1.x / scale
    local y1 = line.v1.y / scale
    local x2 = line.v2.x / scale
    local y2 = line.v2.y / scale

    local cx1, cy1, cx2, cy2 = clipLine(x1, y1, x2, y2)
    if cx1 then
        minimapDrawLine(v, cx1, cy1, cx2, cy2, 112, 0, FRACUNIT)
    end
end

	if doom.patchesLoaded then return end
	for i = 0, INT32_MAX do
		if R_CheckTextureNameForNum(i) == "-" then break end -- Probably at the end of list
		doom.texturesByNum[i] = v.cachePatch(R_TextureNameForNum(i))
	end
	doom.patchesLoaded = true
end, "game")

/*

	local cnt = player.doom.damagecount
	local redpal = (cnt+7)>>3
	local bonuspal = (player.doom.bonuscount+7)>>3
	local radpal = ( player.doom.powers[pw_ironfeet] > 4*32 or player.doom.powers[pw_ironfeet]&8) and 6 or 0
	if redpal >= 0 then
		v.drawFill(0, 0, 320, 200, 176|(redpal<<V_ALPHASHIFT))
	elseif bonuspal >= 0 then
		v.drawFill(0, 0, 320, 200, 161|(bonuspal<<V_ALPHASHIFT))
	elseif radpal then
		v.drawFill(0, 0, 320, 200, 114|(radpal<<V_ALPHASHIFT))
	end
*/