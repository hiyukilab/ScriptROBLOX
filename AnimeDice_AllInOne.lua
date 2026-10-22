--[[
    ====================================================================
    BYTE HUB - ANIME DICE (ALL-IN-ONE STANDALONE)
    https://discord.gg/xbyte
    ====================================================================
--]]

if not game:IsLoaded() then
	pcall(function() game.Loaded:Wait() end)
end

local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer
while not localPlayer do
	task.wait(0.2)
	localPlayer = playersService.LocalPlayer
end

local TARGET_PLACE_ID = "113290951185459"
local TARGET_UNIVERSE_ID = "10708913337"

local currentPlaceId = tostring(game.PlaceId)
local currentGameId = tostring(game.GameId)

local isAllowed = (currentPlaceId == TARGET_PLACE_ID)
	or (currentGameId == TARGET_UNIVERSE_ID)
	or (currentGameId == TARGET_PLACE_ID)

if not isAllowed then
	local msg = "Game is not supported! Script only runs on Anime DICE (Place: 113290951185459). Current: Place=" .. currentPlaceId .. ", Game=" .. currentGameId
	warn("[Byte] " .. msg)
	pcall(function()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ByteNotice"
		screenGui.ResetOnSpawn = false
		local parent = (gethui and gethui()) or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui") or (localPlayer and localPlayer:FindFirstChild("PlayerGui"))
		screenGui.Parent = parent

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 420, 0, 110)
		frame.Position = UDim2.new(0.5, -210, 0.25, 0)
		frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		frame.BorderSizePixel = 0
		frame.Parent = screenGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(250, 40, 40)
		stroke.Thickness = 1.6
		stroke.Parent = frame

		local title = Instance.new("TextLabel")
		title.Text = "BYTE HUB - GAME NOT SUPPORTED"
		title.Font = Enum.Font.GothamBold
		title.TextSize = 14
		title.TextColor3 = Color3.fromRGB(255, 60, 60)
		title.Size = UDim2.new(1, -20, 0, 25)
		title.Position = UDim2.new(0, 10, 0, 8)
		title.BackgroundTransparency = 1
		title.Parent = frame

		local body = Instance.new("TextLabel")
		body.Text = msg
		body.Font = Enum.Font.Gotham
		body.TextSize = 12
		body.TextColor3 = Color3.fromRGB(230, 230, 230)
		body.TextWrapped = true
		body.Size = UDim2.new(1, -20, 0, 60)
		body.Position = UDim2.new(0, 10, 0, 35)
		body.BackgroundTransparency = 1
		body.Parent = frame

		task.delay(10, function()
			pcall(function() screenGui:Destroy() end)
		end)
	end)
	if localPlayer then
		pcall(function() localPlayer:Kick(msg) end)
	end
	return
end

local ByteUi = (function()
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

end)()

local Config = (function()
local Config = {
	AutoRoll = false,
	SelectedDice = "Normal",
	RollDelay = 0.2,
	AutoEquipBest = false,
	
	AutoFarm = false,
	SelectedMob = "All",
	FarmDistance = 7,
	AutoSkills = false,
	
	AutoUpgradeLuck = false,
	AutoUpgradeDamage = false,
	AutoUpgradeCoins = false,
	
	WalkSpeed = 16,
	JumpPower = 50,
	InfiniteJump = false,
	Noclip = false
}

return Config

end)()

local Roll = (function()
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

end)()

local Combat = (function()
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

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

function Combat:getPlayer()
	return playersService.LocalPlayer
end

function Combat:getClosestTarget()
	local player = self:getPlayer()
	local char = player and player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = char.HumanoidRootPart.Position

	local closest, minDist = nil, math.huge
	
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
					local player = self:getPlayer()
					local char = player and player.Character
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

end)()

local Upgrades = (function()
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

end)()

local PlayerFeature = (function()
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

end)()

local Menu = (function()
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

end)()

local rollService = Roll.new(Config)
local combatService = Combat.new(Config)
local upgradeService = Upgrades.new(Config)
local playerService = PlayerFeature.new(Config)

pcall(function() rollService:start() end)
pcall(function() combatService:start() end)
pcall(function() upgradeService:start() end)
pcall(function() playerService:start() end)

local ok, err = xpcall(function()
	Menu.init(ByteUi, Config, playerService)
end, function(e)
	warn("[Byte Hub] Menu.init Error: " .. tostring(e))
	warn(debug.traceback())
end)

if not ok then
	warn("[Byte Hub] Failed to launch Menu: " .. tostring(err))
end
