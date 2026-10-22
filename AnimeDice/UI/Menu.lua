local Menu = {}

function Menu.init(speedLibrary, config, playerFeature)
	speedLibrary:SetNotification({
		Title = "Byte - Anime DICE",
		Description = "v1.0.0",
		Content = "Menu Anime DICE đã nạp thành công!",
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
		Name = "Xúc Xắc",
		Icon = "rbxassetid://10723346959"
	})

	local SecRoll = TabDice:AddSection("Tự Động Lắc Xúc Xắc", true)

	SecRoll:AddToggle({
		Title = "Tự Động Lắc (Auto Roll)",
		Content = "Tự động kích hoạt lắc xúc xắc liên tục",
		Default = false,
		Callback = function(state)
			config.AutoRoll = state
		end
	})

	SecRoll:AddSlider({
		Title = "Tốc độ lắc (Delay)",
		Content = "Khoảng cách thời gian giữa mỗi lần lắc (giây)",
		Increment = 0.05,
		Min = 0.05,
		Max = 1,
		Default = config.RollDelay or 0.2,
		Callback = function(val)
			config.RollDelay = val
		end
	})

	SecRoll:AddDropdown({
		Title = "Chọn Loại Xúc Xắc",
		Content = "Loại xúc xắc ưu tiên roll",
		Multi = false,
		Options = {"Normal", "Golden", "Diamond", "Rainbow", "Mythic"},
		Default = {"Normal"},
		Callback = function(selected)
			config.SelectedDice = selected[1]
		end
	})

	SecRoll:AddToggle({
		Title = "Tự Trang Bị Tốt Nhất (Equip Best)",
		Content = "Tự động đeo xúc xắc có chỉ số cao nhất",
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

	local SecFarm = TabFarm:AddSection("Đánh Quái & Boss", true)

	SecFarm:AddToggle({
		Title = "Tự Động Đánh Quái (Auto Farm)",
		Content = "Tự động bay đến quái và tấn công",
		Default = false,
		Callback = function(state)
			config.AutoFarm = state
		end
	})

	SecFarm:AddDropdown({
		Title = "Chọn Quái Vật",
		Content = "Chọn quái muốn farm",
		Multi = false,
		Options = {"All", "Bandit", "Samurai", "Curse Spirit", "Demon", "Dragon Boss"},
		Default = {"All"},
		Callback = function(selected)
			config.SelectedMob = selected[1]
		end
	})

	SecFarm:AddSlider({
		Title = "Khoảng cách đứng",
		Content = "Khoảng cách từ nhân vật tới quái",
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
		Name = "Nâng Cấp",
		Icon = "rbxassetid://10747372992"
	})

	local SecUpgrade = TabUpgrades:AddSection("Tự Động Nâng Cấp", true)

	SecUpgrade:AddToggle({
		Title = "Auto Upgrade Luck",
		Content = "Tự động tăng chỉ số may mắn khi đủ tiền",
		Default = false,
		Callback = function(state)
			config.AutoUpgradeLuck = state
		end
	})

	SecUpgrade:AddToggle({
		Title = "Auto Upgrade Damage",
		Content = "Tự động tăng sát thương xúc xắc",
		Default = false,
		Callback = function(state)
			config.AutoUpgradeDamage = state
		end
	})

	SecUpgrade:AddToggle({
		Title = "Auto Upgrade Coins",
		Content = "Tự động nâng cấp hệ số nhân tiền",
		Default = false,
		Callback = function(state)
			config.AutoUpgradeCoins = state
		end
	})

	-- TAB 4: PLAYER
	local TabPlayer = Window:CreateTab({
		Name = "Nhân Vật",
		Icon = "rbxassetid://10723415766"
	})

	local SecPlayer = TabPlayer:AddSection("Di Chuyển & Khả Năng", true)

	SecPlayer:AddSlider({
		Title = "WalkSpeed",
		Content = "Tốc độ chạy",
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
		Content = "Lực nhảy",
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
		Content = "Nhảy vô hạn trên không",
		Default = false,
		Callback = function(state)
			config.InfiniteJump = state
		end
	})

	SecPlayer:AddToggle({
		Title = "Noclip",
		Content = "Đi xuyên tường / vật thể",
		Default = false,
		Callback = function(state)
			config.Noclip = state
		end
	})

	-- TAB 5: MISC
	local TabMisc = Window:CreateTab({
		Name = "Cài Đặt",
		Icon = "rbxassetid://10734950020"
	})

	local SecMisc = TabMisc:AddSection("Thông Tin & Hỗ Trợ", true)

	SecMisc:AddParagraph({
		Title = "Anime DICE Script",
		Content = "Phiên bản thiết kế riêng cho Byte Executor trên nền tảng Speed Hub X UI."
	})

	SecMisc:AddButton({
		Title = "Sao chép Discord Byte",
		Content = "Tham gia cộng đồng Byte: discord.gg/xbyte",
		Icon = "rbxassetid://10709798574",
		Callback = function()
			if setclipboard then
				setclipboard("https://discord.gg/xbyte")
				speedLibrary:SetNotification({
					Title = "Clipboard",
					Description = "Thành công",
					Content = "Đã copy link discord.gg/xbyte!",
					Delay = 3
				})
			end
		end
	})

	return Window
end

return Menu
