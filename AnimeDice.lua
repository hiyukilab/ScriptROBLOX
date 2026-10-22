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
