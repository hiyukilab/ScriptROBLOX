--[[
    BYTE HUB - UNIVERSAL LOADER
    https://discord.gg/xbyte
--]]

if not game:IsLoaded() then
	pcall(function() game.Loaded:Wait() end)
end

local function getScript(url)
	local content = nil
	if request then
		local ok, res = pcall(function()
			return request({Url = url, Method = "GET"})
		end)
		if ok and res and res.Body and #res.Body > 0 then
			content = res.Body
		end
	end
	if not content then
		local ok, res = pcall(function()
			return game:HttpGet(url)
		end)
		if ok and res and #res > 0 then
			content = res
		end
	end
	return content
end

local rawCode = getScript("https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/AnimeDice_AllInOne.lua")
if rawCode and #rawCode > 0 then
	local fn, err = loadstring(rawCode)
	if fn then
		fn()
	else
		warn("[Byte Hub] Compilation error: " .. tostring(err))
	end
else
	warn("[Byte Hub] Could not download AnimeDice_AllInOne.lua from GitHub!")
end
