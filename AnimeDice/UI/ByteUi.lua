-- Services.
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local localPlayer = playersService.LocalPlayer
while not localPlayer do
	task.wait(0.1)
	localPlayer = playersService.LocalPlayer
end

local ByteUi = {}
ByteUi.__index = ByteUi

local THEME = {
	Background = Color3.fromRGB(16, 17, 21),
	Sidebar = Color3.fromRGB(22, 23, 29),
	Card = Color3.fromRGB(26, 28, 36),
	CardStroke = Color3.fromRGB(42, 45, 58),
	Accent = Color3.fromRGB(255, 45, 65),
	AccentDark = Color3.fromRGB(180, 25, 45),
	Text = Color3.fromRGB(245, 245, 250),
	SubText = Color3.fromRGB(145, 150, 165),
	FontBold = Enum.Font.GothamBold,
	FontMedium = Enum.Font.GothamMedium,
	FontRegular = Enum.Font.Gotham
}

local function getGuiParent()
	local parent = nil
	if gethui then
		pcall(function() parent = gethui() end)
	end
	if not parent and cloneref then
		pcall(function() parent = cloneref(game:GetService("CoreGui")) end)
	end
	if not parent then
		pcall(function() parent = game:GetService("CoreGui") end)
	end
	if not parent then
		parent = localPlayer:WaitForChild("PlayerGui")
	end
	return parent
end

local function makeDraggable(dragHandle, mainFrame)
	local dragging, dragStart, startPos = false, nil, nil

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function ByteUi:Notify(config)
	local title = config.Title or "Byte Hub"
	local content = config.Content or ""
	local duration = config.Delay or config.Duration or 3.5

	local parent = getGuiParent()
	local notifGui = parent:FindFirstChild("ByteNotifGui")
	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "ByteNotifGui"
		notifGui.ResetOnSpawn = false
		pcall(function() notifGui.Parent = parent end)
	end

	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(0, 280, 0, 65)
	notifFrame.Position = UDim2.new(1, 20, 1, -85)
	notifFrame.BackgroundColor3 = THEME.Sidebar
	notifFrame.BorderSizePixel = 0
	notifFrame.Parent = notifGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notifFrame

	local stroke = Instance.new("UIStroke")
	stroke.Color = THEME.Accent
	stroke.Thickness = 1.2
	stroke.Parent = notifFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.Font = THEME.FontBold
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = THEME.Accent
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.Size = UDim2.new(1, -24, 0, 18)
	titleLabel.Parent = notifFrame

	local bodyLabel = Instance.new("TextLabel")
	bodyLabel.Text = content
	bodyLabel.Font = THEME.FontRegular
	bodyLabel.TextSize = 11
	bodyLabel.TextColor3 = THEME.Text
	bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	bodyLabel.TextWrapped = true
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Position = UDim2.new(0, 12, 0, 28)
	bodyLabel.Size = UDim2.new(1, -24, 0, 30)
	bodyLabel.Parent = notifFrame

	tweenService:Create(notifFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -295, 1, -85)
	}):Play()

	task.delay(duration, function()
		if notifFrame and notifFrame.Parent then
			local closeTween = tweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 20, 1, -85)
			})
			closeTween:Play()
			closeTween.Completed:Connect(function()
				notifFrame:Destroy()
			end)
		end
	end)
end

function ByteUi.new(config)
	local self = setmetatable({}, ByteUi)
	self.title = config.Title or "BYTE HUB"
	self.subTitle = config.SubTitle or "Byte Edition"
	self.tabs = {}
	self.currentTab = nil

	local parent = getGuiParent()
	local existing = parent:FindFirstChild("ByteGui")
	if existing then
		existing:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ByteGui"
	screenGui.ResetOnSpawn = false
	pcall(function() screenGui.Parent = parent end)
	self.screenGui = screenGui

	-- Floating Toggle Button for Mobile / Quick Hide
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ByteToggle"
	toggleButton.Size = UDim2.new(0, 42, 0, 42)
	toggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
	toggleButton.BackgroundColor3 = THEME.Sidebar
	toggleButton.BorderSizePixel = 0
	toggleButton.Text = "B"
	toggleButton.TextColor3 = THEME.Accent
	toggleButton.Font = THEME.FontBold
	toggleButton.TextSize = 18
	toggleButton.Parent = screenGui

	local tbCorner = Instance.new("UICorner")
	tbCorner.CornerRadius = UDim.new(0, 10)
	tbCorner.Parent = toggleButton

	local tbStroke = Instance.new("UIStroke")
	tbStroke.Color = THEME.Accent
	tbStroke.Thickness = 1.4
	tbStroke.Parent = toggleButton

	makeDraggable(toggleButton, toggleButton)

	-- Main Window Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 560, 0, 360)
	mainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
	mainFrame.BackgroundColor3 = THEME.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	self.mainFrame = mainFrame

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = THEME.CardStroke
	mainStroke.Thickness = 1.2
	mainStroke.Parent = mainFrame

	toggleButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)

	-- Top Bar
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 40)
	topBar.BackgroundColor3 = THEME.Sidebar
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 10)
	topCorner.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = self.title .. " <font color=\"#FF2D41\">" .. self.subTitle .. "</font>"
	titleLabel.RichText = true
	titleLabel.Font = THEME.FontBold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = THEME.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 14, 0, 0)
	titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
	titleLabel.Parent = topBar

	local closeBtn = Instance.new("TextButton")
	closeBtn.Text = "X"
	closeBtn.Font = THEME.FontBold
	closeBtn.TextSize = 13
	closeBtn.TextColor3 = THEME.SubText
	closeBtn.BackgroundTransparency = 1
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.Position = UDim2.new(1, -36, 0, 4)
	closeBtn.Parent = topBar

	closeBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
	end)

	closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = THEME.Accent end)
	closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = THEME.SubText end)

	makeDraggable(topBar, mainFrame)

	-- Sidebar (Tabs container)
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 140, 1, -40)
	sidebar.Position = UDim2.new(0, 0, 0, 40)
	sidebar.BackgroundColor3 = THEME.Sidebar
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.Padding = UDim.new(0, 4)
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Parent = sidebar

	local sidebarPad = Instance.new("UIPadding")
	sidebarPad.PaddingTop = UDim.new(0, 8)
	sidebarPad.PaddingLeft = UDim.new(0, 8)
	sidebarPad.PaddingRight = UDim.new(0, 8)
	sidebarPad.Parent = sidebar
	self.sidebar = sidebar

	-- Content Area
	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -145, 1, -45)
	contentContainer.Position = UDim2.new(0, 143, 0, 43)
	contentContainer.BackgroundTransparency = 1
	contentContainer.Parent = mainFrame
	self.contentContainer = contentContainer

	return self
end

function ByteUi:CreateTab(config)
	local tabName = config.Name or "Tab"
	local tabIcon = config.Icon or ""

	local tabBtn = Instance.new("TextButton")
	tabBtn.Name = tabName .. "_Btn"
	tabBtn.Size = UDim2.new(1, 0, 0, 34)
	tabBtn.BackgroundColor3 = THEME.Card
	tabBtn.BackgroundTransparency = 1
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = "  " .. tabName
	tabBtn.TextColor3 = THEME.SubText
	tabBtn.Font = THEME.FontMedium
	tabBtn.TextSize = 12
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Parent = self.sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabBtn

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 3, 0.6, 0)
	indicator.Position = UDim2.new(0, 2, 0.2, 0)
	indicator.BackgroundColor3 = THEME.Accent
	indicator.BorderSizePixel = 0
	indicator.Visible = false
	indicator.Parent = tabBtn

	local indCorner = Instance.new("UICorner")
	indCorner.CornerRadius = UDim.new(0, 2)
	indCorner.Parent = indicator

	-- Tab Content ScrollFrame
	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Name = tabName .. "_Page"
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.ScrollBarThickness = 3
	tabContent.ScrollBarImageColor3 = THEME.CardStroke
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.Visible = false
	tabContent.Parent = self.contentContainer

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 6)
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Parent = tabContent

	local contentPad = Instance.new("UIPadding")
	contentPad.PaddingTop = UDim.new(0, 6)
	contentPad.PaddingLeft = UDim.new(0, 6)
	contentPad.PaddingRight = UDim.new(0, 10)
	contentPad.PaddingBottom = UDim.new(0, 8)
	contentPad.Parent = tabContent

	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
	end)

	local tabObj = {
		name = tabName,
		btn = tabBtn,
		content = tabContent,
		indicator = indicator
	}

	local function selectTab()
		for _, t in ipairs(self.tabs) do
			t.content.Visible = false
			t.btn.BackgroundTransparency = 1
			t.btn.TextColor3 = THEME.SubText
			t.indicator.Visible = false
		end
		tabContent.Visible = true
		tabBtn.BackgroundTransparency = 0.5
		tabBtn.TextColor3 = THEME.Text
		indicator.Visible = true
		self.currentTab = tabObj
	end

	tabBtn.MouseButton1Click:Connect(selectTab)

	table.insert(self.tabs, tabObj)
	if #self.tabs == 1 then
		selectTab()
	end

	function tabObj:AddSection(secTitle)
		local secLabel = Instance.new("TextLabel")
		secLabel.Text = string.upper(secTitle)
		secLabel.Font = THEME.FontBold
		secLabel.TextSize = 11
		secLabel.TextColor3 = THEME.Accent
		secLabel.TextXAlignment = Enum.TextXAlignment.Left
		secLabel.BackgroundTransparency = 1
		secLabel.Size = UDim2.new(1, 0, 0, 22)
		secLabel.Parent = tabContent

		local secObj = {}

		function secObj:AddToggle(opt)
			local title = opt.Title or "Toggle"
			local desc = opt.Content or ""
			local default = opt.Default or false
			local callback = opt.Callback or function() end

			local state = default

			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, desc ~= "" and 44 or 36)
			card.BackgroundColor3 = THEME.Card
			card.BorderSizePixel = 0
			card.Parent = tabContent

			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 6)
			cardCorner.Parent = card

			local cardStroke = Instance.new("UIStroke")
			cardStroke.Color = THEME.CardStroke
			cardStroke.Thickness = 1
			cardStroke.Parent = card

			local label = Instance.new("TextLabel")
			label.Text = title
			label.Font = THEME.FontMedium
			label.TextSize = 12
			label.TextColor3 = THEME.Text
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.BackgroundTransparency = 1
			label.Position = UDim2.new(0, 10, 0, desc ~= "" and 6 or 9)
			label.Size = UDim2.new(1, -70, 0, 15)
			label.Parent = card

			if desc ~= "" then
				local descLabel = Instance.new("TextLabel")
				descLabel.Text = desc
				descLabel.Font = THEME.FontRegular
				descLabel.TextSize = 10
				descLabel.TextColor3 = THEME.SubText
				descLabel.TextXAlignment = Enum.TextXAlignment.Left
				descLabel.BackgroundTransparency = 1
				descLabel.Position = UDim2.new(0, 10, 0, 23)
				descLabel.Size = UDim2.new(1, -70, 0, 14)
				descLabel.Parent = card
			end

			local togglePill = Instance.new("TextButton")
			togglePill.Size = UDim2.new(0, 40, 0, 20)
			togglePill.Position = UDim2.new(1, -50, 0.5, -10)
			togglePill.BackgroundColor3 = state and THEME.Accent or THEME.Sidebar
			togglePill.BorderSizePixel = 0
			togglePill.Text = ""
			togglePill.Parent = card

			local pillCorner = Instance.new("UICorner")
			pillCorner.CornerRadius = UDim.new(1, 0)
			pillCorner.Parent = togglePill

			local circle = Instance.new("Frame")
			circle.Size = UDim2.new(0, 14, 0, 14)
			circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
			circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			circle.BorderSizePixel = 0
			circle.Parent = togglePill

			local circleCorner = Instance.new("UICorner")
			circleCorner.CornerRadius = UDim.new(1, 0)
			circleCorner.Parent = circle

			local function updateToggle(val)
				state = val
				tweenService:Create(togglePill, TweenInfo.new(0.2), {
					BackgroundColor3 = state and THEME.Accent or THEME.Sidebar
				}):Play()
				tweenService:Create(circle, TweenInfo.new(0.2), {
					Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
				}):Play()
				callback(state)
			end

			togglePill.MouseButton1Click:Connect(function()
				updateToggle(not state)
			end)

			return {
				Set = updateToggle
			}
		end

		function secObj:AddSlider(opt)
			local title = opt.Title or "Slider"
			local min = opt.Min or 0
			local max = opt.Max or 100
			local default = opt.Default or min
			local inc = opt.Increment or 1
			local callback = opt.Callback or function() end

			local value = default

			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 48)
			card.BackgroundColor3 = THEME.Card
			card.BorderSizePixel = 0
			card.Parent = tabContent

			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 6)
			cardCorner.Parent = card

			local cardStroke = Instance.new("UIStroke")
			cardStroke.Color = THEME.CardStroke
			cardStroke.Thickness = 1
			cardStroke.Parent = card

			local label = Instance.new("TextLabel")
			label.Text = title
			label.Font = THEME.FontMedium
			label.TextSize = 12
			label.TextColor3 = THEME.Text
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.BackgroundTransparency = 1
			label.Position = UDim2.new(0, 10, 0, 6)
			label.Size = UDim2.new(0.7, 0, 0, 16)
			label.Parent = card

			local valLabel = Instance.new("TextLabel")
			valLabel.Text = tostring(value)
			valLabel.Font = THEME.FontBold
			valLabel.TextSize = 11
			valLabel.TextColor3 = THEME.Accent
			valLabel.TextXAlignment = Enum.TextXAlignment.Right
			valLabel.BackgroundTransparency = 1
			valLabel.Position = UDim2.new(0.7, 0, 0, 6)
			valLabel.Size = UDim2.new(0.3, -10, 0, 16)
			valLabel.Parent = card

			local sliderBg = Instance.new("TextButton")
			sliderBg.Text = ""
			sliderBg.AutoButtonColor = false
			sliderBg.Size = UDim2.new(1, -20, 0, 6)
			sliderBg.Position = UDim2.new(0, 10, 0, 30)
			sliderBg.BackgroundColor3 = THEME.Sidebar
			sliderBg.BorderSizePixel = 0
			sliderBg.Parent = card

			local sliderCorner = Instance.new("UICorner")
			sliderCorner.CornerRadius = UDim.new(1, 0)
			sliderCorner.Parent = sliderBg

			local fill = Instance.new("Frame")
			local startPct = math.clamp((value - min) / (max - min), 0, 1)
			fill.Size = UDim2.new(startPct, 0, 1, 0)
			fill.BackgroundColor3 = THEME.Accent
			fill.BorderSizePixel = 0
			fill.Parent = sliderBg

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = fill

			local dragging = false

			local function updateSlider(input)
				local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
				local rawVal = min + (max - min) * relX
				local steppedVal = math.floor(rawVal / inc + 0.5) * inc
				steppedVal = math.clamp(steppedVal, min, max)
				value = steppedVal
				valLabel.Text = tostring(value)
				fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
				callback(value)
			end

			sliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateSlider(input)
				end
			end)

			sliderBg.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			userInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)

			return {
				Set = function(newVal)
					value = math.clamp(newVal, min, max)
					valLabel.Text = tostring(value)
					fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
					callback(value)
				end
			}
		end

		function secObj:AddDropdown(opt)
			local title = opt.Title or "Dropdown"
			local options = opt.Options or {}
			local default = opt.Default or (options[1] or "None")
			local callback = opt.Callback or function() end

			local current = default
			local isOpen = false

			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 38)
			card.BackgroundColor3 = THEME.Card
			card.BorderSizePixel = 0
			card.ClipsDescendants = true
			card.Parent = tabContent

			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 6)
			cardCorner.Parent = card

			local cardStroke = Instance.new("UIStroke")
			cardStroke.Color = THEME.CardStroke
			cardStroke.Thickness = 1
			cardStroke.Parent = card

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 38)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.Parent = card

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Text = title
			titleLabel.Font = THEME.FontMedium
			titleLabel.TextSize = 12
			titleLabel.TextColor3 = THEME.Text
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.BackgroundTransparency = 1
			titleLabel.Position = UDim2.new(0, 10, 0, 0)
			titleLabel.Size = UDim2.new(0.5, 0, 0, 38)
			titleLabel.Parent = card

			local selLabel = Instance.new("TextLabel")
			selLabel.Text = tostring(current) .. " ▼"
			selLabel.Font = THEME.FontBold
			selLabel.TextSize = 11
			selLabel.TextColor3 = THEME.Accent
			selLabel.TextXAlignment = Enum.TextXAlignment.Right
			selLabel.BackgroundTransparency = 1
			selLabel.Position = UDim2.new(0.5, 0, 0, 0)
			selLabel.Size = UDim2.new(0.5, -12, 0, 38)
			selLabel.Parent = card

			local dropHolder = Instance.new("Frame")
			dropHolder.Size = UDim2.new(1, -16, 0, #options * 26)
			dropHolder.Position = UDim2.new(0, 8, 0, 40)
			dropHolder.BackgroundTransparency = 1
			dropHolder.Parent = card

			local dropLayout = Instance.new("UIListLayout")
			dropLayout.Padding = UDim.new(0, 2)
			dropLayout.Parent = dropHolder

			for _, optVal in ipairs(options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 24)
				optBtn.BackgroundColor3 = THEME.Sidebar
				optBtn.BorderSizePixel = 0
				optBtn.Text = "  " .. tostring(optVal)
				optBtn.Font = THEME.FontRegular
				optBtn.TextSize = 11
				optBtn.TextColor3 = (optVal == current) and THEME.Accent or THEME.Text
				optBtn.TextXAlignment = Enum.TextXAlignment.Left
				optBtn.Parent = dropHolder

				local optCorner = Instance.new("UICorner")
				optCorner.CornerRadius = UDim.new(0, 4)
				optCorner.Parent = optBtn

				optBtn.MouseButton1Click:Connect(function()
					current = optVal
					selLabel.Text = tostring(current) .. " ▼"
					isOpen = false
					card.Size = UDim2.new(1, 0, 0, 38)
					for _, b in ipairs(dropHolder:GetChildren()) do
						if b:IsA("TextButton") then
							b.TextColor3 = (b.Text:sub(3) == current) and THEME.Accent or THEME.Text
						end
					end
					callback({current})
				end)
			end

			btn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (44 + #options * 26) or 38
				card.Size = UDim2.new(1, 0, 0, targetHeight)
				selLabel.Text = tostring(current) .. (isOpen and " ▲" or " ▼")
			end)

			return {
				Set = function(val)
					current = val
					selLabel.Text = tostring(current) .. " ▼"
					callback({current})
				end
			}
		end

		function secObj:AddButton(opt)
			local title = opt.Title or "Button"
			local callback = opt.Callback or function() end

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 34)
			btn.BackgroundColor3 = THEME.Card
			btn.BorderSizePixel = 0
			btn.Text = title
			btn.TextColor3 = THEME.Text
			btn.Font = THEME.FontMedium
			btn.TextSize = 12
			btn.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = btn

			local stroke = Instance.new("UIStroke")
			stroke.Color = THEME.CardStroke
			stroke.Thickness = 1
			stroke.Parent = btn

			btn.MouseEnter:Connect(function()
				tweenService:Create(stroke, TweenInfo.new(0.2), { Color = THEME.Accent }):Play()
			end)

			btn.MouseLeave:Connect(function()
				tweenService:Create(stroke, TweenInfo.new(0.2), { Color = THEME.CardStroke }):Play()
			end)

			btn.MouseButton1Click:Connect(function()
				tweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = THEME.AccentDark }):Play()
				task.delay(0.15, function()
					tweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = THEME.Card }):Play()
				end)
				callback()
			end)
		end

		function secObj:AddParagraph(opt)
			local title = opt.Title or "Info"
			local content = opt.Content or ""

			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 52)
			card.BackgroundColor3 = THEME.Card
			card.BorderSizePixel = 0
			card.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = card

			local stroke = Instance.new("UIStroke")
			stroke.Color = THEME.CardStroke
			stroke.Thickness = 1
			stroke.Parent = card

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Text = title
			titleLabel.Font = THEME.FontBold
			titleLabel.TextSize = 11
			titleLabel.TextColor3 = THEME.Accent
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.BackgroundTransparency = 1
			titleLabel.Position = UDim2.new(0, 10, 0, 6)
			titleLabel.Size = UDim2.new(1, -20, 0, 16)
			titleLabel.Parent = card

			local descLabel = Instance.new("TextLabel")
			descLabel.Text = content
			descLabel.Font = THEME.FontRegular
			descLabel.TextSize = 10
			descLabel.TextColor3 = THEME.SubText
			descLabel.TextXAlignment = Enum.TextXAlignment.Left
			descLabel.TextWrapped = true
			descLabel.BackgroundTransparency = 1
			descLabel.Position = UDim2.new(0, 10, 0, 22)
			descLabel.Size = UDim2.new(1, -20, 0, 26)
			descLabel.Parent = card
		end

		return secObj
	end

	return tabObj
end

return ByteUi
