if not game:IsLoaded() then
	pcall(function() game.Loaded:Wait() end)
end

local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer
while not localPlayer do
	task.wait(0.2)
	localPlayer = playersService.LocalPlayer
end

local TARGET_PLACE_ID = "113290951185459"
local TARGET_UNIVERSE_ID = "10708913337"

local currentPlaceId = tostring(game.PlaceId)
local currentGameId = tostring(game.GameId)

local isAllowed = (currentPlaceId == TARGET_PLACE_ID)
	or (currentGameId == TARGET_UNIVERSE_ID)
	or (currentGameId == TARGET_PLACE_ID)

if not isAllowed then
	local msg = "Game is not supported! Script only runs on Anime DICE (Place: 113290951185459). Current: Place=" .. currentPlaceId .. ", Game=" .. currentGameId
	warn("[Byte] " .. msg)
	if localPlayer then
		pcall(function() localPlayer:Kick(msg) end)
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
local ByteUi = loadModule("AnimeDice/UI/ByteUi.lua")
local Menu = loadModule("AnimeDice/UI/Menu.lua")

local rollService = Roll.new(Config)
local combatService = Combat.new(Config)
local upgradeService = Upgrades.new(Config)
local playerService = PlayerFeature.new(Config)

pcall(function() rollService:start() end)
pcall(function() combatService:start() end)
pcall(function() upgradeService:start() end)
pcall(function() playerService:start() end)

local ok, err = xpcall(function()
	Menu.init(ByteUi, Config, playerService)
end, function(e)
	warn("[Byte Error] Menu init failed: " .. tostring(e))
	warn(debug.traceback())
end)

return {
	Config = Config,
	ByteUi = ByteUi
}
