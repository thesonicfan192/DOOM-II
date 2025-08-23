skincolors[SKINCOLOR_GREEN].ramp = {112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127}

-- Find closest palette index to given RGB values
-- Arguments mimic color.rgbToPalette's (r, g, b) style
local function rgbToPalette(red, green, blue)
	-- Clamp in case inputs go outside 0–255
	if red < 0 then red = 0 elseif red > 255 then red = 255 end
	if green < 0 then green = 0 elseif green > 255 then green = 255 end
	if blue < 0 then blue = 0 elseif blue > 255 then blue = 255 end

	local bestIndex = 0
	local bestDist = 1/0 -- Infinity

	for idx, col in pairs(doom.playpal) do
		local dr = red - col[1]
		local dg = green - col[2]
		local db = blue - col[3]
		local dist = dr*dr + dg*dg + db*db
		if dist < bestDist then
			bestDist = dist
			bestIndex = idx
		end
	end

	return bestIndex
end
/*
for i = 0, MAXSKINCOLORS - 1 do
    local color = skincolors[i]
    for s = 1, 16 do
		local r, g, b = color.paletteToRgb(color.ramp[s])
		-- color.ramp[s] = 
	end
end
*/