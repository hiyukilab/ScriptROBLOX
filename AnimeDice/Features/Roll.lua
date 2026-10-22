local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local Roll = {}
Roll.__index = Roll

function Roll.new(config)
	local self = setmetatable({}, Roll)
	self.config = config
	self.running = false
	return self
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
	local rollRemote = self:findRemote({"RollDice", "Roll", "RollEvent", "DiceRoll", "RequestRoll"})
	if rollRemote then
		if rollRemote:IsA("RemoteEvent") then
			rollRemote:FireServer(self.config.SelectedDice or 1)
		elseif rollRemote:IsA("RemoteFunction") then
			rollRemote:InvokeServer(self.config.SelectedDice or 1)
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
