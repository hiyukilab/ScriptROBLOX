local TARGET_PLACE_ID = 113290951185459
local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer or playersService.PlayerAdded:Wait()

if game.PlaceId ~= TARGET_PLACE_ID and game.GameId ~= TARGET_PLACE_ID then
	local msg = "Game khong duoc ho tro! Script chi hoat dong tai Anime DICE (ID: " .. tostring(TARGET_PLACE_ID) .. ")"
	warn("[Byte] " .. msg)
	if localPlayer then
		localPlayer:Kick(msg)
	end
	return
end

local function loadModule(relPath)
	if isfile and isfile(relPath) then
		return loadstring(readfile(relPath))()
	end
	local url = "https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/" .. relPath:gsub("\\", "/")
	local fetch = (request and function(u) return request({Url = u, Method = "GET"}).Body end)
		or (httpget and function(u) return httpget(u) end)
		or function(u) return game:HttpGet(u) end
	return loadstring(fetch(url))()
end

local Config = loadModule("AnimeDice/Config.lua")
local Roll = loadModule("AnimeDice/Features/Roll.lua")
local Combat = loadModule("AnimeDice/Features/Combat.lua")
local Upgrades = loadModule("AnimeDice/Features/Upgrades.lua")
local PlayerFeature = loadModule("AnimeDice/Features/Player.lua")
local Menu = loadModule("AnimeDice/UI/Menu.lua")

local rollService = Roll.new(Config)
local combatService = Combat.new(Config)
local upgradeService = Upgrades.new(Config)
local playerService = PlayerFeature.new(Config)

rollService:start()
combatService:start()
upgradeService:start()
playerService:start()

local function initUI(speedLibrary)
	Menu.init(speedLibrary, Config, playerService)
end

return {
	Config = Config,
	InitUI = initUI
}
