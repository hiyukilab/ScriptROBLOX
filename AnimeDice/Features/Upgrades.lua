local replicatedStorage = game:GetService("ReplicatedStorage")

local Upgrades = {}
Upgrades.__index = Upgrades

function Upgrades.new(config)
	local self = setmetatable({}, Upgrades)
	self.config = config
	self.running = false
	return self
end

function Upgrades:findRemote(names)
	for _, name in ipairs(names) do
		local r = replicatedStorage:FindFirstChild(name, true)
		if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
			return r
		end
	end
	return nil
end

function Upgrades:upgrade(statName)
	local upgradeRemote = self:findRemote({"Upgrade", "UpgradeStat", "BuyUpgrade", "UpgradeSkill"})
	if upgradeRemote then
		if upgradeRemote:IsA("RemoteEvent") then
			upgradeRemote:FireServer(statName)
		elseif upgradeRemote:IsA("RemoteFunction") then
			upgradeRemote:InvokeServer(statName)
		end
	end
end

function Upgrades:start()
	if self.running then return end
	self.running = true

	task.spawn(function()
		while self.running do
			if self.config.AutoUpgradeLuck then
				pcall(function() self:upgrade("Luck") end)
			end
			if self.config.AutoUpgradeDamage then
				pcall(function() self:upgrade("Damage") end)
			end
			if self.config.AutoUpgradeCoins then
				pcall(function() self:upgrade("Coins") end)
			end
			task.wait(1)
		end
	end)
end

function Upgrades:stop()
	self.running = false
end

return Upgrades
