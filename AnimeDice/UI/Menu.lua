local Menu = {}

function Menu.init(byteUiLibrary, config, playerFeature)
	byteUiLibrary:Notify({
		Title = "Byte - Anime DICE",
		Content = "Anime DICE Hub loaded successfully!",
		Delay = 4
	})

	local Window = byteUiLibrary.new({
		Title = "ANIME DICE HUB",
		SubTitle = "Byte Edition"
	})

	-- TAB 1: ROLL DICE
	local TabDice = Window:CreateTab({
		Name = "Roll Dice"
	})

	local SecRoll = TabDice:AddSection("Auto Roll Dice")

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
		Min = 0.05,
		Max = 1,
		Default = config.RollDelay or 0.2,
		Increment = 0.05,
		Callback = function(val)
			config.RollDelay = val
		end
	})

	SecRoll:AddDropdown({
		Title = "Select Dice Type",
		Options = {"Normal", "Golden", "Diamond", "Rainbow", "Mythic"},
		Default = "Normal",
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
		Name = "Auto Farm"
	})

	local SecFarm = TabFarm:AddSection("Farm Monsters & Bosses")

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
		Options = {"All", "Bandit", "Samurai", "Curse Spirit", "Demon", "Dragon Boss"},
		Default = "All",
		Callback = function(selected)
			config.SelectedMob = selected[1]
		end
	})

	SecFarm:AddSlider({
		Title = "Attack Distance",
		Min = 3,
		Max = 15,
		Default = 7,
		Increment = 1,
		Callback = function(val)
			config.FarmDistance = val
		end
	})

	-- TAB 3: UPGRADES
	local TabUpgrades = Window:CreateTab({
		Name = "Upgrades"
	})

	local SecUpgrade = TabUpgrades:AddSection("Auto Upgrade Stats")

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
		Name = "Player"
	})

	local SecPlayer = TabPlayer:AddSection("Movement & Abilities")

	SecPlayer:AddSlider({
		Title = "WalkSpeed",
		Min = 16,
		Max = 250,
		Default = 16,
		Increment = 1,
		Callback = function(val)
			config.WalkSpeed = val
			if playerFeature then playerFeature:applyStats() end
		end
	})

	SecPlayer:AddSlider({
		Title = "JumpPower",
		Min = 50,
		Max = 350,
		Default = 50,
		Increment = 5,
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
		Name = "Settings"
	})

	local SecMisc = TabMisc:AddSection("Information & Community")

	SecMisc:AddParagraph({
		Title = "Anime DICE Script",
		Content = "Official Byte edition script running on ByteUi."
	})

	SecMisc:AddButton({
		Title = "Copy Byte Discord",
		Callback = function()
			if setclipboard then
				setclipboard("https://discord.gg/xbyte")
				byteUiLibrary:Notify({
					Title = "Clipboard",
					Content = "Copied discord.gg/xbyte to clipboard!",
					Delay = 3
				})
			end
		end
	})

	return Window
end

return Menu
