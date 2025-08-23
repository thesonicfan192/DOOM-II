local function doLoadingShit()
	doom.patchesLoaded = false
end

addHook("AddonLoaded", doLoadingShit)
doLoadingShit()