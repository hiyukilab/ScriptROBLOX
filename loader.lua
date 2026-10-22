--[[
    BYTE HUB - UNIVERSAL LOADER
    https://discord.gg/xbyte
--]]

local get = (request and function(u) return request({Url = u, Method = "GET"}).Body end)
	or (httpget and function(u) return httpget(u) end)
	or function(u) return game:HttpGet(u) end

loadstring(get("https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/AnimeDice_AllInOne.lua"))()
