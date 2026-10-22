local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local Roll = {}
Roll.__index = Roll

function Roll.new(config)
	local self = setmetatable({}, Roll)
	self.config = config
	self.running = false
	self.controller = nil
	self:initController()
	return self
end

function Roll:initController()
	pcall(function()
		local rollingFolder = replicatedStorage:FindFirstChild("Framework")
			and replicatedStorage.Framework:FindFirstChild("Features")
			and replicatedStorage.Framework.Features:FindFirstChild("Rolling")
		
		if rollingFolder and rollingFolder:FindFirstChild("RollController") then
			if setthreadidentity then setthreadidentity(2) end
			self.controller = require(rollingFolder.RollController)
			if setthreadidentity then setthreadidentity(8) end
		end
	end)
end

function Roll:findRemote(possibleNames)
	for _, name in ipairs(possibleNames) do
		local remote = replicatedStorage:FindFirstChild(name, true)
		if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
			return remote
		end
	end
	return nil
end

function Roll:executeRoll()
	if not self.controller then
		self:initController()
	end

	-- Try calling RollController directly (from ReplicatedStorage.Framework.Features.Rolling.RollController)
	if self.controller then
		local rollFn = self.controller.roll or self.controller.Roll or self.controller.requestRoll
		if typeof(rollFn) == "function" then
			local ok = pcall(function() rollFn(self.controller, 1) end)
			if not ok then
				pcall(function() rollFn(1) end)
			end
			return
		end
	end

	-- Fallback to Remote search
	local rollRemote = self:findRemote({"RollDice", "Roll", "RollEvent", "DiceRoll", "RequestRoll"})
	if rollRemote then
		if rollRemote:IsA("RemoteEvent") then
			rollRemote:FireServer(1)
		elseif rollRemote:IsA("RemoteFunction") then
			rollRemote:InvokeServer(1)
		end
	end
end

function Roll:executeEquipBest()
	local equipRemote = self:findRemote({"EquipBest", "AutoEquip", "EquipBestDice", "Equip"})
	if equipRemote then
		if equipRemote:IsA("RemoteEvent") then
			equipRemote:FireServer()
		elseif equipRemote:IsA("RemoteFunction") then
			equipRemote:InvokeServer()
		end
	end
end

function Roll:start()
	if self.running then return end
	self.running = true
	
	task.spawn(function()
		while self.running do
			if self.config.AutoRoll then
				pcall(function()
					self:executeRoll()
				end)
			end
			task.wait(self.config.RollDelay or 0.2)
		end
	end)

	task.spawn(function()
		while self.running do
			if self.config.AutoEquipBest then
				pcall(function()
					self:executeEquipBest()
				end)
			end
			task.wait(2)
		end
	end)
end

function Roll:stop()
	self.running = false
end

return Roll
