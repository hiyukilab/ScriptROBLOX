local Menu = {}

function Menu.init(speedLibrary, config, playerFeature)
	speedLibrary:SetNotification({
		Title = "Byte - Anime DICE",
		Description = "v1.0.0",
		Content = "Anime DICE Hub loaded successfully!",
		Time = 0.5,
		Delay = 4
	})

	local Window = speedLibrary:CreateWindow({
		Title = "ANIME DICE HUB",
		Description = "Byte Edition",
		["Tab Width"] = 140,
		SizeUi = UDim2.fromOffset(580, 360)
	})

	-- TAB 1: ROLL DICE
	local TabDice = Window:CreateTab({
		Name = "Roll Dice",
		Icon = "rbxassetid://10723346959"
	})

	local SecRoll = TabDice:AddSection("Auto Roll Dice", true)

	SecRoll:AddToggle({
		Title = "Auto Roll",
		Content = "Automatically roll dice continuously",
		Default = false,
		Callback = function(state)
			config.AutoRoll = state
		end
	})

	SecRoll:AddSlider({
		Title = "Roll Delay",
		Content = "Delay between each roll in seconds",
		Increment = 0.05,
		Min = 0.05,
		Max = 1,
		Default = config.RollDelay or 0.2,
		Callback = function(val)
			config.RollDelay = val
		end
	})

	SecRoll:AddDropdown({
		Title = "Select Dice Type",
		Content = "Priority dice type to roll",
		Multi = false,
		Options = {"Normal", "Golden", "Diamond", "Rainbow", "Mythic"},
		Default = {"Normal"},
		Callback = function(selected)
			config.SelectedDice = selected[1]
		end
	})

	SecRoll:AddToggle({
		Title = "Auto Equip Best",
		Content = "Automatically equip highest stat dice",
		Default = false,
		Callback = function(state)
			config.AutoEquipBest = state
		end
	})

	-- TAB 2: AUTO FARM
	local TabFarm = Window:CreateTab({
		Name = "Auto Farm",
		Icon = "rbxassetid://10734950309"
	})

	local SecFarm = TabFarm:AddSection("Farm Monsters & Bosses", true)

	SecFarm:AddToggle({
		Title = "Auto Attack Mobs",
		Content = "Automatically teleport and attack target",
		Default = false,
		Callback = function(state)
			config.AutoFarm = state
		end
	})

	SecFarm:AddDropdown({
		Title = "Select Target Mob",
		Content = "Choose target mob to farm",
		Multi = false,
		Options = {"All", "Bandit", "Samurai", "Curse Spirit", "Demon", "Dragon Boss"},
		Default = {"All"},
		Callback = function(selected)
			config.SelectedMob = selected[1]
		end
	})

	SecFarm:AddSlider({
		Title = "Attack Distance",
		Content = "Distance between character and target",
		Increment = 1,
		Min = 3,
		Max = 15,
		Default = 7,
		Callback = function(val)
			config.FarmDistance = val
		end
	})

	-- TAB 3: UPGRADES
	local TabUpgrades = Window:CreateTab({
		Name = "Upgrades",
		Icon = "rbxassetid://10747372992"
	})

	local SecUpgrade = TabUpgrades:AddSection("Auto Upgrade Stats", true)

	SecUpgrade:AddToggle({
		Title = "Auto Upgrade Luck",
		Content = "Automatically increase luck when affordable",
		Default = false,
		Callback = function(state)
			config.AutoUpgradeLuck = state
		end
	})

	SecUpgrade:AddToggle({
		Title = "Auto Upgrade Damage",
		Content = "Automatically increase dice damage",
		Default = false,
		Callback = function(state)
			config.AutoUpgradeDamage = state
		end
	})

	SecUpgrade:AddToggle({
		Title = "Auto Upgrade Coins",
		Content = "Automatically upgrade coin multiplier",
		Default = false,
		Callback = function(state)
			config.AutoUpgradeCoins = state
		end
	})

	-- TAB 4: PLAYER
	local TabPlayer = Window:CreateTab({
		Name = "Player",
		Icon = "rbxassetid://10723415766"
	})

	local SecPlayer = TabPlayer:AddSection("Movement & Abilities", true)

	SecPlayer:AddSlider({
		Title = "WalkSpeed",
		Content = "Adjust character movement speed",
		Increment = 1,
		Min = 16,
		Max = 250,
		Default = 16,
		Callback = function(val)
			config.WalkSpeed = val
			if playerFeature then playerFeature:applyStats() end
		end
	})

	SecPlayer:AddSlider({
		Title = "JumpPower",
		Content = "Adjust character jump height",
		Increment = 5,
		Min = 50,
		Max = 350,
		Default = 50,
		Callback = function(val)
			config.JumpPower = val
			if playerFeature then playerFeature:applyStats() end
		end
	})

	SecPlayer:AddToggle({
		Title = "Infinite Jump",
		Content = "Jump infinitely in mid-air",
		Default = false,
		Callback = function(state)
			config.InfiniteJump = state
		end
	})

	SecPlayer:AddToggle({
		Title = "Noclip",
		Content = "Walk through walls and obstacles",
		Default = false,
		Callback = function(state)
			config.Noclip = state
		end
	})

	-- TAB 5: SETTINGS
	local TabMisc = Window:CreateTab({
		Name = "Settings",
		Icon = "rbxassetid://10734950020"
	})

	local SecMisc = TabMisc:AddSection("Information & Community", true)

	SecMisc:AddParagraph({
		Title = "Anime DICE Script",
		Content = "Official Byte edition script running on Speed Hub X UI."
	})

	SecMisc:AddButton({
		Title = "Copy Byte Discord",
		Content = "Join the official Byte community: discord.gg/xbyte",
		Icon = "rbxassetid://10709798574",
		Callback = function()
			if setclipboard then
				setclipboard("https://discord.gg/xbyte")
				speedLibrary:SetNotification({
					Title = "Clipboard",
					Description = "Success",
					Content = "Copied discord.gg/xbyte to clipboard!",
					Delay = 3
				})
			end
		end
	})

	return Window
end

return Menu
