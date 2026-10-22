local playersService = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local PlayerFeature = {}
PlayerFeature.__index = PlayerFeature

function PlayerFeature.new(config)
	local self = setmetatable({}, PlayerFeature)
	self.config = config
	self.connections = {}
	return self
end

function PlayerFeature:getPlayer()
	return playersService.LocalPlayer
end

function PlayerFeature:applyStats()
	local player = self:getPlayer()
	local char = player and player.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char.Humanoid.WalkSpeed = self.config.WalkSpeed or 16
		char.Humanoid.UseJumpPower = true
		char.Humanoid.JumpPower = self.config.JumpPower or 50
	end
end

function PlayerFeature:start()
	local jumpConn = userInputService.JumpRequest:Connect(function()
		if self.config.InfiniteJump then
			local player = self:getPlayer()
			local char = player and player.Character
			if char and char:FindFirstChildOfClass("Humanoid") then
				char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)
	table.insert(self.connections, jumpConn)

	local noclipConn = runService.Stepped:Connect(function()
		if self.config.Noclip then
			local player = self:getPlayer()
			local char = player and player.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end
	end)
	table.insert(self.connections, noclipConn)

	task.spawn(function()
		local player = self:getPlayer()
		while not player do
			task.wait(0.2)
			player = self:getPlayer()
		end
		local charAddedConn = player.CharacterAdded:Connect(function()
			task.wait(0.5)
			self:applyStats()
		end)
		table.insert(self.connections, charAddedConn)
	end)
end

function PlayerFeature:stop()
	for _, conn in ipairs(self.connections) do
		pcall(function() conn:Disconnect() end)
	end
	self.connections = {}
end

return PlayerFeature
