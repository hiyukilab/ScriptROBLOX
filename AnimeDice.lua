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
	local msg = "Game is not supported! Script only runs on Anime DICE (Place: 113290951185459, Game: 10708913337). Current: Place=" .. currentPlaceId .. ", Game=" .. currentGameId
	warn("[Byte] " .. msg)
	if localPlayer then
		pcall(function() localPlayer:Kick(msg) end)
	end
	return
end

local function loadFile(relPath)
	if isfile and isfile(relPath) then
		return loadstring(readfile(relPath))()
	end
	local url = "https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/" .. relPath:gsub("\\", "/")
	local fetch = (request and function(u) return request({Url = u, Method = "GET"}).Body end)
		or (httpget and function(u) return httpget(u) end)
		or function(u) return game:HttpGet(u) end
	return loadstring(fetch(url))()
end

local Speed_Library = loadFile("Speed Hub X 5.0.0 Ui Source Code.txt")
if not Speed_Library then return end

local AnimeDiceApp = loadFile("AnimeDice/Main.lua")
if AnimeDiceApp and AnimeDiceApp.InitUI then
	AnimeDiceApp.InitUI(Speed_Library)
end
