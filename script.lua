--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║                       ثائر X100 - النسخة الأفقية                             ║
    ║                                                                              ║
    ║   ✈️ طيران بالكاميرا  |  🧱 اختراق جدران  |  💾 حفظ منطقتين                  ║
    ║   🎵 موسيقى عالمية    |  👥 تعقب لاعبين   |  ⚡ سرعة متغيرة                  ║
    ║   🛡️ حماية كاملة     |  📱 واجهة أفقية   |  🎮 قائمة جانبية                 ║
    ║                                                                              ║
    ║                         جميع الحقوق محفوظة © ثائر 2024                       ║
    ║                                                                              ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
--]]

-- ========== [ الخدمات الأساسية ] ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- ========== [ متغيرات السكربت ] ==========
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity = nil
local Checkpoint1 = nil
local Checkpoint2 = nil
local CurrentTarget = nil
local WalkSpeedValue = 16

-- متغيرات الموسيقى
local CurrentSound = nil
local SoundPlaying = false
local SoundVolume = 0.5
local SongId = "3017157406"

-- قائمة الأغاني الجاهزة
local SongsList = {
    {name = "🎵 أغنية 1", id = "3017157406"},
    {name = "🎵 أغنية 2", id = "1843170826"},
    {name = "🎵 أغنية 3", id = "9126245770"},
    {name = "🎵 أغنية 4", id = "6698976160"},
    {name = "🎵 أغنية 5", id = "9032979010"}
}

-- ========== [ دالة الإشعارات ] ==========
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

-- ========== [ نظام الطيران بالكاميرا ] ==========
local KeyStates = {W = false, A = false, S = false, D = false}

UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
    
    if Input.KeyCode == Enum.KeyCode.E then
        if Flying then
            Flying = false
            if BodyVelocity then BodyVelocity:Destroy() end
            Notify("✈️ ثائر", "إيقاف الطيران")
        else
            Flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            BodyVelocity.Parent = RootPart
            Notify("✈️ ثائر", "تفعيل الطيران")
        end
    end
    
    if Input.KeyCode == Enum.KeyCode.X then
        NoClip = not NoClip
        Notify("🧱 ثائر", NoClip and "تفعيل اختراق الجدران" or "إيقاف اختراق الجدران")
    end
    
    if Input.KeyCode == Enum.KeyCode.N then
        Checkpoint1 = RootPart.CFrame
        Notify("💾 ثائر", "تم حفظ المنطقة 1")
    end
    
    if Input.KeyCode == Enum.KeyCode.M then
        Checkpoint2 = RootPart.CFrame
        Notify("💾 ثائر", "تم حفظ المنطقة 2")
    end
    
    if Input.KeyCode == Enum.KeyCode.B and Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 1")
    end
    
    if Input.KeyCode == Enum.KeyCode.V and Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 2")
    end
    
    if Input.KeyCode == Enum.KeyCode.C then
        FlySpeed = math.min(300, FlySpeed + 25)
        Notify("⚡ السرعة", "سرعة الطيران: " .. FlySpeed)
    end
    
    if Input.KeyCode == Enum.KeyCode.Z then
        FlySpeed = math.max(30, FlySpeed - 25)
        Notify("⚡ السرعة", "سرعة الطيران: " .. FlySpeed)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = false end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = false end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = false end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = false end
end)

RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity then
        local moveDir = Vector3.new()
        if KeyStates.W then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if KeyStates.S then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if KeyStates.A then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if KeyStates.D then moveDir = moveDir + Vector3.new(1, 0, 0) end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            local moveVector = (Camera.CFrame.LookVector * moveDir.Z + Camera.CFrame.RightVector * moveDir.X)
            BodyVelocity.Velocity = moveVector * FlySpeed
        else
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- ========== [ نظام اختراق الجدران ] ==========
RunService.Stepped:Connect(function()
    if NoClip and Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") and Part.Name ~= "Head" then
                pcall(function() Part.CanCollide = false end)
            end
        end
    end
end)

-- ========== [ نظام تعقب اللاعبين ] ==========
local function FindPlayer(partialName)
    if not partialName or partialName == "" then return nil end
    local lowerPartial = string.lower(partialName)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if string.sub(string.lower(player.Name), 1, #lowerPartial) == lowerPartial then
                return player
            end
        end
    end
    return nil
end

local function TeleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت إلى " .. targetPlayer.Name)
        return true
    end
    return false
end

-- ========== [ نظام الموسيقى العالمية ] ==========
local function PlayGlobalSound(soundId)
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = SoundVolume
    sound.Looped = true
    sound.PlayOnRemove = false
    
    local target = Character and Character:FindFirstChild("HumanoidRootPart") or RootPart
    sound.Parent = target
    sound:Play()
    
    CurrentSound = sound
    SoundPlaying = true
    Notify("🎵 ثائر", "تشغيل الموسيقى")
end

local function StopGlobalSound()
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil
    end
    SoundPlaying = false
    Notify("🔇 ثائر", "إيقاف الموسيقى")
end

-- ========== [ نظام الأمان Metatable Hooking ] ==========
local function AntiBan()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() then
            if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
                if k == "WalkSpeed" then return 16 end
                if k == "JumpPower" then return 50 end
            end
        end
        return oldIndex(t, k)
    end)
    
    setreadonly(mt, true)
    Notify("🛡️ ثائر", "تفعيل الحماية الكاملة")
end

AntiBan()

-- ========== [ إنشاء الواجهة الأفقية (منيو جانبي) ] ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerX100"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ===== الإطار الرئيسي =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 260)  -- مقاس عرضي يناسب الهاتف
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 18)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 100, 200)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- ===== شريط العنوان =====
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.12, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 60, 150)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🔥 ثائر X100"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
HideBtn.Position = UDim2.new(0.89, 0, 0.15, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
HideBtn.BackgroundTransparency = 0.2
HideBtn.Text = "🗕"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 14
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = TitleBar

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(1, 0)
HideCorner.Parent = HideBtn

-- ===== القائمة الجانبية (Sidebar) =====
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 120, 1, -36)
SideBar.Position = UDim2.new(0, 0, 0, 36)
SideBar.BackgroundColor3 = Color3.fromRGB(0, 20, 60)
SideBar.BackgroundTransparency = 0.1
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarCorner = Instance.new("UICorner")
SideBarCorner.CornerRadius = UDim.new(0, 0)
SideBarCorner.Parent = SideBar

-- ===== الحاوية (Container) =====
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -130, 1, -36)
Container.Position = UDim2.new(0, 125, 0, 36)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Parent = MainFrame

-- ===== ترتيب الأزرار في القائمة الجانبية =====
local SideBarLayout = Instance.new("UIListLayout")
SideBarLayout.Padding = UDim.new(0, 6)
SideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideBarLayout.Parent = SideBar

-- ========== [ دوال إنشاء الواجهة الأفقية ] ==========

-- دالة إنشاء زر تبويب جانبي
local function CreateTab(name, pageFrame)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
    tabBtn.BackgroundTransparency = 0.3
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = SideBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(Container:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        pageFrame.Visible = true
        
        -- تغيير لون الزر المحدد
        for _, btn in pairs(SideBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
                btn.BackgroundTransparency = 0.3
                btn.TextColor3 = Color3.fromRGB(100, 180, 255)
            end
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
        tabBtn.BackgroundTransparency = 0.1
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    UpdateSideBarHeight()
    return tabBtn
end

-- دالة إنشاء صفحة (حاوية محتوى)
local function CreatePage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 255)
    page.Parent = Container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page
    
    local function UpdatePageCanvas()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdatePageCanvas)
    UpdatePageCanvas()
    
    return page
end

-- تحديث ارتفاع القائمة الجانبية
local function UpdateSideBarHeight()
    local totalHeight = 0
    for _, btn in pairs(SideBar:GetChildren()) do
        if btn:IsA("TextButton") then
            totalHeight = totalHeight + btn.AbsoluteSize.Y + 6
        end
    end
    SideBarLayout.Padding = UDim.new(0, 6)
end

-- ===== دوال إنشاء العناصر داخل الصفحات =====

local function CreateButton(page, text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
    btn.BackgroundTransparency = 0.2
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = page
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(page, text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
    btn.BackgroundTransparency = 0.2
    btn.Text = icon .. " " .. text .. " 🔘 OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = page
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
            btn.BackgroundTransparency = 0.1
            btn.Text = icon .. " " .. text .. " 🔴 ON"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
            btn.BackgroundTransparency = 0.2
            btn.Text = icon .. " " .. text .. " 🔘 OFF"
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        callback(active)
    end)
    return btn
end

local function CreateSlider(page, text, icon, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0, 55)
    container.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
    container.BackgroundTransparency = 0.3
    container.Parent = page
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.4, 0)
    label.Position = UDim2.new(0.05, 0, 0.05, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 200, 240)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.25, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0.05, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = container
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.9, 0, 0.3, 0)
    slider.Position = UDim2.new(0.05, 0, 0.55, 0)
    slider.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
    slider.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0.1, 0, 1.3, 0)
    thumb.Position = UDim2.new((default - min) / (max - min) - 0.05, 0, -0.15, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    thumb.Text = ""
    thumb.Parent = slider
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local dragging = false
    thumb.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent - 0.05, 0, -0.15, 0)
            valueLabel.Text = tostring(value)
            label.Text = icon .. " " .. text .. ": " .. tostring(value)
            callback(value)
        end
    end)
    
    return container
end

local function CreateInputBox(page, placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0, 45)
    container.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
    container.BackgroundTransparency = 0.3
    container.Parent = page
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.95, 0, 0.7, 0)
    input.Position = UDim2.new(0.025, 0, 0.15, 0)
    input.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    input.BackgroundTransparency = 0.2
    input.PlaceholderText = placeholder
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 12
    input.Font = Enum.Font.GothamMedium
    input.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        if input.Text ~= "" then
            callback(input.Text)
            input.Text = ""
        end
    end)
    
    return container
end

-- ========== [ إنشاء الصفحات والأزرار ] ==========

-- صفحة الطيران
local FlightPage = CreatePage()
CreateTab("✈️ طيران", FlightPage)

CreateToggle(FlightPage, "الطيران الحر", "✈️", function(active)
    if active then
        Flying = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.Parent = RootPart
        Notify("✈️ ثائر", "تفعيل الطيران")
    else
        Flying = false
        if BodyVelocity then BodyVelocity:Destroy() end
        Notify("✈️ ثائر", "إيقاف الطيران")
    end
end)

CreateSlider(FlightPage, "سرعة الطيران", "⚡", 30, 300, 100, function(value)
    FlySpeed = value
end)

CreateSlider(FlightPage, "سرعة المشي", "🚶", 16, 250, 16, function(value)
    WalkSpeedValue = value
    pcall(function() Humanoid.WalkSpeed = value end)
end)

CreateToggle(FlightPage, "اختراق الجدران", "🧱", function(active)
    NoClip = active
    Notify("🧱 ثائر", active and "تفعيل اختراق الجدران" or "إيقاف اختراق الجدران")
end)

-- صفحة المناطق
local CheckpointPage = CreatePage()
CreateTab("💾 مناطق", CheckpointPage)

CreateButton(CheckpointPage, "حفظ المنطقة 1", "📍", function()
    Checkpoint1 = RootPart.CFrame
    Notify("💾 ثائر", "تم حفظ المنطقة 1")
end)

CreateButton(CheckpointPage, "تيليپورت للمنطقة 1", "🌀", function()
    if Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 1")
    end
end)

CreateButton(CheckpointPage, "حفظ المنطقة 2", "📍", function()
    Checkpoint2 = RootPart.CFrame
    Notify("💾 ثائر", "تم حفظ المنطقة 2")
end)

CreateButton(CheckpointPage, "تيليپورت للمنطقة 2", "🌀", function()
    if Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 2")
    end
end)

-- صفحة الموسيقى
local MusicPage = CreatePage()
CreateTab("🎵 موسيقى", MusicPage)

for _, song in pairs(SongsList) do
    CreateButton(MusicPage, song.name, "🎤", function()
        PlayGlobalSound(song.id)
    end)
end

CreateInputBox(MusicPage, "أدخل كود الأغنية (ID)", function(text)
    if text and text ~= "" then
        PlayGlobalSound(text)
    end
end)

CreateSlider(MusicPage, "مستوى الصوت", "🔊", 0, 100, 50, function(value)
    SoundVolume = value / 100
    if CurrentSound then
        CurrentSound.Volume = SoundVolume
    end
end)

CreateButton(MusicPage, "إيقاف الموسيقى", "🔇", function()
    StopGlobalSound()
end)

-- صفحة اللاعبين
local PlayersPage = CreatePage()
CreateTab("👥 لاعبين", PlayersPage)

CreateInputBox(PlayersPage, "أدخل اسم اللاعب", function(text)
    CurrentTarget = FindPlayer(text)
    if CurrentTarget then
        Notify("✅ ثائر", "تم العثور على: " .. CurrentTarget.Name)
    else
        Notify("❌ ثائر", "لم يتم العثور على لاعب")
    end
end)

CreateButton(PlayersPage, "تيليپورت إلى اللاعب", "🎯", function()
    if CurrentTarget then
        TeleportToPlayer(CurrentTarget)
    else
        Notify("⚠️ ثائر", "ابحث عن لاعب أولاً")
    end
end)

-- صفحة الأمان
local SecurityPage = CreatePage()
CreateTab("🛡️ أمان", SecurityPage)

CreateButton(SecurityPage, "تفعيل الحماية الكاملة", "🔒", function()
    AntiBan()
end)

-- صفحة المعلومات
local InfoPage = CreatePage()
CreateTab("ℹ️ معلومات", InfoPage)

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0.95, 0, 0, 100)
InfoText.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
InfoText.BackgroundTransparency = 0.3
InfoText.Text = "🔥 ثائر X100\n\nالنسخة: Ultimate Edition\nالمطور: Shadow Team\n\nاختصارات:\nE ← طيران\nX ← جدران\nN,M ← حفظ\nB,V ← تيليپورت\nC,Z ← سرعة\nF5 ← إخفاء الواجهة"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.GothamMedium
InfoText.Parent = InfoPage

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = InfoText

-- إظهار الصفحة الأولى
for _, child in pairs(Container:GetChildren()) do
    if child:IsA("ScrollingFrame") then
        child.Visible = false
    end
end
FlightPage.Visible = true

-- ========== [ تحديث ارتفاع القائمة الجانبية ] ==========
UpdateSideBarHeight()

-- ========== [ إخفاء/إظهار الواجهة ] ==========
local UIHidden = false
HideBtn.MouseButton1Click:Connect(function()
    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden
    Notify("ثائر", UIHidden and "الواجهة مخفية" or "الواجهة ظاهرة")
end)

UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.F5 then
        UIHidden = not UIHidden
        MainFrame.Visible = not UIHidden
        Notify("ثائر", UIHidden and "الواجهة مخفية" or "الواجهة ظاهرة")
    end
end)

-- ========== [ رسالة الترحيب ] ==========
Notify("🔥 ثائر X100", "تم التحميل | E:طيران | X:جدران | F5:إخفاء الواجهة")

print([[
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                    ثائر X100 - النسخة الأفقية - تم التحميل                   ║
║                                                                              ║
║   🎮 E  ← طيران                                            ║
║   🎮 X  ← اختراق جدران                                     ║
║   🎮 N  ← حفظ المنطقة 1                                    ║
║   🎮 M  ← حفظ المنطقة 2                                    ║
║   🎮 B  ← تيليپورت للمنطقة 1                               ║
║   🎮 V  ← تيليپورت للمنطقة 2                               ║
║   🎮 C  ↑ سرعة الطيران                                     ║
║   🎮 Z  ↓ سرعة الطيران                                     ║
║   🎮 F5 ← إظهار/إخفاء الواجهة                              ║
║                                                                              ║
║                         جميع الحقوق محفوظة © ثائر 2024                       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
]])