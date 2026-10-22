--[[
    =======================================================
    MẪU TRIỂN KHAI MENU VỚI SPEED HUB X 5.0.0 UI LIBRARY
    =======================================================
    File UI gốc: Speed Hub X 5.0.0 Ui Source Code.txt
--]]

-- 1. NẠP THƯ VIỆN UI
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

-- 2. HIỂN THỊ THÔNG BÁO CHÀO MỪNG (Notification)
Speed_Library:SetNotification({
    Title = "Speed Hub X",
    Description = "v5.0.0",
    Content = "Menu đã được nạp thành công! Chúc bạn chơi game vui vẻ.",
    Time = 0.5,  -- Thời gian chạy hiệu ứng trượt
    Delay = 4    -- Tự đóng sau 4 giây
})

-- 3. KHỞI TẠO CỬA SỔ CHÍNH (Window)
local Window = Speed_Library:CreateWindow({
    Title = "MY CUSTOM HUB",
    Description = "v5.0.0",
    ["Tab Width"] = 130,                     -- Độ rộng cột tab bên trái
    SizeUi = UDim2.fromOffset(560, 340)       -- Kích thước khung menu
})

--------------------------------------------------------------------------------
-- TAB 1: NHÂN VẬT & DI CHUYỂN
--------------------------------------------------------------------------------
local TabPlayer = Window:CreateTab({
    Name = "Nhân vật",
    Icon = "rbxassetid://10723415766" -- Icon người chơi
})

local SecMovement = TabPlayer:AddSection("Chỉ số di chuyển", true) -- true: mặc định mở

-- Thanh trượt chỉnh WalkSpeed
SecMovement:AddSlider({
    Title = "Tốc độ chạy (WalkSpeed)",
    Content = "Điều chỉnh tốc độ di chuyển của nhân vật",
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

-- Thanh trượt chỉnh JumpPower
SecMovement:AddSlider({
    Title = "Độ cao nhảy (JumpPower)",
    Content = "Điều chỉnh lực nhảy của nhân vật",
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

local SecAbilities = TabPlayer:AddSection("Khả năng đặc biệt", false)

-- Toggle Infinite Jump
local InfiniteJumpEnabled = false
SecAbilities:AddToggle({
    Title = "Nhảy vô hạn (Infinite Jump)",
    Content = "Cho phép nhảy liên tục trên không trung",
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

-- Button Reset nhân vật
SecAbilities:AddButton({
    Title = "Hồi sinh (Reset Character)",
    Content = "Tự động hạ gục nhân vật để hồi sinh tại điểm spawn",
    Icon = "rbxassetid://10747373176",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.Health = 0
        end
    end
})

--------------------------------------------------------------------------------
-- TAB 2: TỰ ĐỘNG & FARM (AUTOMATION)
--------------------------------------------------------------------------------
local TabFarm = Window:CreateTab({
    Name = "Tự động",
    Icon = "rbxassetid://10734950309"
})

local SecAuto = TabFarm:AddSection("Cấu hình Auto Farm", true)

-- Dropdown chọn mục tiêu quái
local SelectedMob = "Slime"
SecAuto:AddDropdown({
    Title = "Chọn Quái Vật",
    Content = "Chọn loại quái muốn tự động tấn công",
    Multi = false, -- Chọn 1 loại duy nhất
    Options = {"Slime", "Goblin", "Bandit", "Zombie", "Boss Dragon"},
    Default = {"Slime"},
    Callback = function(selectedList)
        SelectedMob = selectedList[1]
        print("[AutoFarm] Đã chọn quái:", SelectedMob)
    end
})

-- Dropdown đa chọn (Multi) vật phẩm cần nhặt
local SelectedItems = {"Vàng", "Ngọc"}
SecAuto:AddDropdown({
    Title = "Nhặt vật phẩm tự động",
    Content = "Có thể chọn nhiều loại vật phẩm cùng lúc",
    Multi = true, -- Chọn nhiều mục
    Options = {"Vàng", "Ngọc", "Trang bị", "Bình máu", "Bình mana"},
    Default = {"Vàng", "Ngọc"},
    Callback = function(selectedList)
        SelectedItems = selectedList
        print("[AutoFarm] Danh sách nhặt:", table.concat(selectedList, ", "))
    end
})

-- Toggle bật tắt Auto Farm
local AutoFarmRunning = false
SecAuto:AddToggle({
    Title = "Kích hoạt Auto Farm",
    Content = "Bắt đầu tự động tìm và đánh quái đã chọn",
    Default = false,
    Callback = function(state)
        AutoFarmRunning = state
        if state then
            Speed_Library:SetNotification({
                Title = "Auto Farm",
                Description = "Đang chạy",
                Content = "Bắt đầu farm quái: " .. tostring(SelectedMob),
                Delay = 3
            })
        else
            Speed_Library:SetNotification({
                Title = "Auto Farm",
                Description = "Đã dừng",
                Content = "Đã dừng chế độ tự động farm.",
                Delay = 3
            })
        end
    end
})

-- Loop giả lập Auto Farm
task.spawn(function()
    while true do
        task.wait(1)
        if AutoFarmRunning then
            -- Logic farm quái của bạn đặt tại đây:
            -- print("Đang đánh: " .. tostring(SelectedMob))
        end
    end
end)

--------------------------------------------------------------------------------
-- TAB 3: TIỆN ÍCH & CÀI ĐẶT
--------------------------------------------------------------------------------
local TabMisc = Window:CreateTab({
    Name = "Cài đặt",
    Icon = "rbxassetid://10734950020"
})

local SecInfo = TabMisc:AddSection("Thông tin & Tiện ích", true)

-- Hiển thị thông tin phiên bản
SecInfo:AddParagraph({
    Title = "Giới thiệu Script",
    Content = "Menu được xây dựng trên nền tảng Speed Hub X UI v5.0.0. Hỗ trợ mượt mà trên cả PC và Mobile."
})

-- Thêm đường gạch phân cách
SecInfo:AddLine()

-- Ô nhập liệu Input: Webhook hoặc Key
SecInfo:AddInput({
    Title = "Mã kích hoạt / Key",
    Content = "Nhập key bản quyền nếu có",
    Default = "",
    Callback = function(text)
        print("Người dùng đã nhập key:", text)
    end
})

-- Nút sao chép link Discord
SecInfo:AddButton({
    Title = "Sao chép link Discord",
    Content = "Copy link cộng đồng vào clipboard của bạn",
    Icon = "rbxassetid://10709798574",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/xbyte")
            Speed_Library:SetNotification({
                Title = "Clipboard",
                Description = "Thành công",
                Content = "Đã sao chép link Discord vào bộ nhớ tạm!",
                Delay = 3
            })
        else
            print("Executor không hỗ trợ setclipboard")
        end
    end
})
