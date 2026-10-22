local playersService = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local localPlayer = playersService.LocalPlayer

local PlayerFeature = {}
PlayerFeature.__index = PlayerFeature

function PlayerFeature.new(config)
	local self = setmetatable({}, PlayerFeature)
	self.config = config
	self.connections = {}
	return self
end

function PlayerFeature:applyStats()
	local char = localPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char.Humanoid.WalkSpeed = self.config.WalkSpeed or 16
		char.Humanoid.UseJumpPower = true
		char.Humanoid.JumpPower = self.config.JumpPower or 50
	end
end

function PlayerFeature:start()
	local jumpConn = userInputService.JumpRequest:Connect(function()
		if self.config.InfiniteJump then
			local char = localPlayer.Character
			if char and char:FindFirstChildOfClass("Humanoid") then
				char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)
	table.insert(self.connections, jumpConn)

	local noclipConn = runService.Stepped:Connect(function()
		if self.config.Noclip then
			local char = localPlayer.Character
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

	local charAddedConn = localPlayer.CharacterAdded:Connect(function()
		task.wait(0.5)
		self:applyStats()
	end)
	table.insert(self.connections, charAddedConn)
end

function PlayerFeature:stop()
	for _, conn in ipairs(self.connections) do
		pcall(function() conn:Disconnect() end)
	end
	self.connections = {}
end

return PlayerFeature
