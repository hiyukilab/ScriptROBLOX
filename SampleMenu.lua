--[[
    BYTE HUB - SAMPLE TEMPLATE (SPEED HUB X UI v5.0.0)
    https://discord.gg/xbyte
--]]

-- 1. LOAD UI LIBRARY
local Speed_Library
if isfile and isfile("Speed Hub X 5.0.0 Ui Source Code.txt") then
    Speed_Library = loadstring(readfile("Speed Hub X 5.0.0 Ui Source Code.txt"))()
else
    local fetch = (request and function(url) return request({Url = url, Method = "GET"}).Body end)
        or (httpget and function(url) return httpget(url) end)
        or function(url) return game:HttpGet(url) end
    Speed_Library = loadstring(fetch("https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/Speed%20Hub%20X%205.0.0%20Ui%20Source%20Code.txt"))()
end

if not Speed_Library then return end

-- 2. NOTIFICATION
Speed_Library:SetNotification({
    Title = "Byte Hub",
    Description = "v5.0.0",
    Content = "Menu loaded successfully! Enjoy playing.",
    Time = 0.5,
    Delay = 4
})

-- 3. MAIN WINDOW
local Window = Speed_Library:CreateWindow({
    Title = "BYTE HUB",
    Description = "v5.0.0",
    ["Tab Width"] = 130,
    SizeUi = UDim2.fromOffset(560, 340)
})

-- TAB 1: PLAYER & MOVEMENT
local TabPlayer = Window:CreateTab({
    Name = "Player",
    Icon = "rbxassetid://10723415766"
})

local SecMovement = TabPlayer:AddSection("Movement Stats", true)

SecMovement:AddSlider({
    Title = "WalkSpeed",
    Content = "Adjust character movement speed",
    Increment = 1,
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

SecMovement:AddSlider({
    Title = "JumpPower",
    Content = "Adjust character jump height",
    Increment = 5,
    Min = 50,
    Max = 350,
    Default = 50,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = value
        end
    end
})

local SecAbilities = TabPlayer:AddSection("Abilities", false)

local InfiniteJumpEnabled = false
SecAbilities:AddToggle({
    Title = "Infinite Jump",
    Content = "Allow infinite jumps in mid-air",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

SecAbilities:AddButton({
    Title = "Reset Character",
    Content = "Instantly respawn at spawn location",
    Icon = "rbxassetid://10747373176",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.Health = 0
        end
    end
})

-- TAB 2: AUTOMATION & FARM
local TabFarm = Window:CreateTab({
    Name = "Automation",
    Icon = "rbxassetid://10734950309"
})

local SecAuto = TabFarm:AddSection("Auto Farm Configuration", true)

local SelectedMob = "Slime"
SecAuto:AddDropdown({
    Title = "Select Target Mob",
    Content = "Choose monster type to attack",
    Multi = false,
    Options = {"Slime", "Goblin", "Bandit", "Zombie", "Boss Dragon"},
    Default = {"Slime"},
    Callback = function(selectedList)
        SelectedMob = selectedList[1]
    end
})

local SelectedItems = {"Gold", "Gems"}
SecAuto:AddDropdown({
    Title = "Auto Collect Items",
    Content = "Choose items to collect automatically",
    Multi = true,
    Options = {"Gold", "Gems", "Equipment", "Health Potion", "Mana Potion"},
    Default = {"Gold", "Gems"},
    Callback = function(selectedList)
        SelectedItems = selectedList
    end
})

local AutoFarmRunning = false
SecAuto:AddToggle({
    Title = "Enable Auto Farm",
    Content = "Start hunting selected monsters automatically",
    Default = false,
    Callback = function(state)
        AutoFarmRunning = state
        if state then
            Speed_Library:SetNotification({
                Title = "Auto Farm",
                Description = "Running",
                Content = "Started farming: " .. tostring(SelectedMob),
                Delay = 3
            })
        else
            Speed_Library:SetNotification({
                Title = "Auto Farm",
                Description = "Stopped",
                Content = "Auto farm stopped.",
                Delay = 3
            })
        end
    end
})

-- TAB 3: SETTINGS
local TabMisc = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://10734950020"
})

local SecInfo = TabMisc:AddSection("Information & Community", true)

SecInfo:AddParagraph({
    Title = "About Script",
    Content = "Built on Speed Hub X UI v5.0.0. Optimized for mobile and PC."
})

SecInfo:AddLine()

SecInfo:AddInput({
    Title = "Activation Key",
    Content = "Enter license key if required",
    Default = "",
    Callback = function(text)
        print("User entered key:", text)
    end
})

SecInfo:AddButton({
    Title = "Copy Discord Link",
    Content = "Copy community invite link: discord.gg/xbyte",
    Icon = "rbxassetid://10709798574",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/xbyte")
            Speed_Library:SetNotification({
                Title = "Clipboard",
                Description = "Success",
                Content = "Copied Discord link to clipboard!",
                Delay = 3
            })
        end
    end
})
