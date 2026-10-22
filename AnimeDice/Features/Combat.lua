local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local localPlayer = playersService.LocalPlayer

local Combat = {}
Combat.__index = Combat

function Combat.new(config)
	local self = setmetatable({}, Combat)
	self.config = config
	self.running = false
	return self
end

function Combat:findRemote(names)
	for _, name in ipairs(names) do
		local r = replicatedStorage:FindFirstChild(name, true)
		if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
			return r
		end
	end
	return nil
end

function Combat:getClosestTarget()
	local char = localPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = char.HumanoidRootPart.Position

	local closest, minDist = nil, math.huge
	local candidates = {}
	
	local mobsFolder = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Monsters") or workspace
	for _, obj in ipairs(mobsFolder:GetChildren()) do
		if obj:IsA("Model") and obj ~= char and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
			local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("Head")
			if root then
				if self.config.SelectedMob == "All" or string.find(string.lower(obj.Name), string.lower(self.config.SelectedMob)) then
					local dist = (root.Position - myPos).Magnitude
					if dist < minDist then
						minDist = dist
						closest = obj
					end
				end
			end
		end
	end
	return closest
end

function Combat:attackTarget(target)
	local attackRemote = self:findRemote({"Attack", "Damage", "ClickAttack", "Hit", "Fight", "CombatHit"})
	if attackRemote then
		if attackRemote:IsA("RemoteEvent") then
			attackRemote:FireServer(target)
		elseif attackRemote:IsA("RemoteFunction") then
			attackRemote:InvokeServer(target)
		end
	end
end

function Combat:start()
	if self.running then return end
	self.running = true

	task.spawn(function()
		while self.running do
			if self.config.AutoFarm then
				local target = self:getClosestTarget()
				if target then
					local char = localPlayer.Character
					local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
					if char and char:FindFirstChild("HumanoidRootPart") and targetRoot then
						char.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, self.config.FarmDistance or 5)
						self:attackTarget(target)
					end
				end
			end
			task.wait(0.1)
		end
	end)
end

function Combat:stop()
	self.running = false
end

return Combat
