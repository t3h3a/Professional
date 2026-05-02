--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║                       ثائر X100 - الهاكر الأسطوري                            ║
    ║                                                                              ║
    ║   ✈️ طيران بالكاميرا  |  🧱 اختراق جدران  |  💾 حفظ منطقتين                  ║
    ║   🎵 موسيقى عالمية    |  👥 تعقب لاعبين   |  ⚡ سرعة متغيرة                  ║
    ║   🛡️ حماية كاملة     |  📱 متجاوب مع الهاتف |  🎮 تحكم باللمس                ║
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
local MenuVisible = true
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
    
    -- اختصار E للطيران
    if Input.KeyCode == Enum.KeyCode.E then
        if Flying then
            Flying = false
            if BodyVelocity then BodyVelocity:Destroy() end
            Notify("✈️ ثائر", "إيقاف الطيران")
        else
            Flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.Parent = RootPart
            Notify("✈️ ثائر", "تفعيل الطيران الحر")
        end
    end
    
    -- اختصار X لاختراق الجدران
    if Input.KeyCode == Enum.KeyCode.X then
        NoClip = not NoClip
        Notify("🧱 ثائر", NoClip and "تفعيل اختراق الجدران" or "إيقاف اختراق الجدران")
    end
    
    -- اختصار N لحفظ المنطقة 1
    if Input.KeyCode == Enum.KeyCode.N then
        Checkpoint1 = RootPart.CFrame
        Notify("💾 ثائر", "تم حفظ المنطقة 1")
    end
    
    -- اختصار M لحفظ المنطقة 2
    if Input.KeyCode == Enum.KeyCode.M then
        Checkpoint2 = RootPart.CFrame
        Notify("💾 ثائر", "تم حفظ المنطقة 2")
    end
    
    -- اختصار B للتيليپورت للمنطقة 1
    if Input.KeyCode == Enum.KeyCode.B and Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 1")
    end
    
    -- اختصار V للتيليپورت للمنطقة 2
    if Input.KeyCode == Enum.KeyCode.V and Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 2")
    end
    
    -- اختصار C زيادة سرعة الطيران
    if Input.KeyCode == Enum.KeyCode.C then
        FlySpeed = math.min(300, FlySpeed + 25)
        Notify("⚡ السرعة", "سرعة الطيران: " .. FlySpeed)
    end
    
    -- اختصار Z إنقاص سرعة الطيران
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

-- حركة الطيران
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

-- تفعيل الحماية تلقائياً
AntiBan()

-- ========== [ إنشاء الواجهة المتجاوبة لجميع الشاشات ] ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerX100"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (قابل للسحب ومتجاوب)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- زوايا دائرية
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- إطار نيون حول الواجهة
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 50, 100)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 30, 80)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = TitleBar

-- عنوان ثائر
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🔥 ثائر X100"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

-- زر إغلاق/تصغير الواجهة
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.12, 0, 0.7, 0)
HideBtn.Position = UDim2.new(0.87, 0, 0.15, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 100)
HideBtn.BackgroundTransparency = 0.2
HideBtn.Text = "🗕"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 16
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = TitleBar

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(1, 0)
HideCorner.Parent = HideBtn

-- ScrollingFrame للمحتوى (قابل للتمرير للشاشات الصغيرة)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0.87, 0)
ScrollFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
ScrollFrame.Parent = MainFrame

local CanvasLayout = Instance.new("UIListLayout")
CanvasLayout.Padding = UDim.new(0, 8)
CanvasLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CanvasLayout.Parent = ScrollFrame

local function UpdateCanvas()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y + 20)
end
CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

-- ========== [ دالة إنشاء قسم ] ==========
local function CreateSection(title, icon)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.95, 0, 0.06, 0)
    section.BackgroundTransparency = 1
    section.Parent = ScrollFrame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.3, 0, 0.02, 0)
    line.Position = UDim2.new(0.65, 0, 0.45, 0)
    line.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    line.BackgroundTransparency = 0.5
    line.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = icon .. " " .. title
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 150)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = section
    
    UpdateCanvas()
    return section
end

-- ========== [ دالة إنشاء زر تبديل ] ==========
local function CreateToggle(text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0.09, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
    btn.BackgroundTransparency = 0.3
    btn.Text = icon .. " " .. text .. " 🔘 OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(255, 40, 100)
            btn.BackgroundTransparency = 0.2
            btn.Text = icon .. " " .. text .. " 🔴 ON"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
            btn.BackgroundTransparency = 0.3
            btn.Text = icon .. " " .. text .. " 🔘 OFF"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(active)
    end)
    
    UpdateCanvas()
    return btn
end

-- ========== [ دالة إنشاء زر عادي ] ==========
local function CreateButton(text, icon, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0.09, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 30, 90)
    btn.BackgroundTransparency = 0.15
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    UpdateCanvas()
    return btn
end

-- ========== [ دالة إنشاء منزلق ] ==========
local function CreateSlider(text, icon, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0.12, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 8, 28)
    container.BackgroundTransparency = 0.4
    container.Parent = ScrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.35, 0)
    label.Position = UDim2.new(0.05, 0, 0.05, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 200, 200)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.25, 0, 0.35, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0.05, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 80, 140)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = container
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.9, 0, 0.3, 0)
    slider.Position = UDim2.new(0.05, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
    slider.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0.1, 0, 1.3, 0)
    thumb.Position = UDim2.new((default - min) / (max - min) - 0.05, 0, -0.15, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 80, 130)
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
    
    UpdateCanvas()
    return container
end

-- ========== [ دالة إنشاء صندوق إدخال ] ==========
local function CreateInputBox(placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0.1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 8, 28)
    container.BackgroundTransparency = 0.4
    container.Parent = ScrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = container
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.95, 0, 0.7, 0)
    input.Position = UDim2.new(0.025, 0, 0.15, 0)
    input.BackgroundColor3 = Color3.fromRGB(5, 3, 15)
    input.BackgroundTransparency = 0.3
    input.PlaceholderText = placeholder
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 12
    input.Font = Enum.Font.GothamMedium
    input.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        if input.Text ~= "" then
            callback(input.Text)
            input.Text = ""
        end
    end)
    
    UpdateCanvas()
    return input
end

-- ========== [ بناء الواجهة ] ==========

-- قسم الطيران
CreateSection("FLIGHT", "✈️")

CreateToggle("الطيران الحر", "✈️", function(active)
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

CreateSlider("سرعة الطيران", "⚡", 30, 300, 100, function(value)
    FlySpeed = value
end)

CreateSlider("سرعة المشي", "🚶", 16, 250, 16, function(value)
    WalkSpeedValue = value
    pcall(function() Humanoid.WalkSpeed = value end)
end)

-- قسم اختراق الجدران
CreateSection("WALL HACK", "🧱")

CreateToggle("اختراق الجدران", "🧱", function(active)
    NoClip = active
    Notify("🧱 ثائر", active and "تفعيل اختراق الجدران" or "إيقاف اختراق الجدران")
end)

-- قسم حفظ المناطق
CreateSection("CHECKPOINTS", "💾")

CreateButton("حفظ المنطقة 1", "📍", function()
    Checkpoint1 = RootPart.CFrame
    Notify("💾 ثائر", "تم حفظ المنطقة 1")
end)

CreateButton("تيليپورت للمنطقة 1", "🌀", function()
    if Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 1")
    end
end)

CreateButton("حفظ المنطقة 2", "📍", function()
    Checkpoint2 = RootPart.CFrame
    Notify("💾 ثائر", "تم حفظ المنطقة 2")
end)

CreateButton("تيليپورت للمنطقة 2", "🌀", function()
    if Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 2")
    end
end)

-- قسم الموسيقى
CreateSection("MUSIC", "🎵")

for _, song in pairs(SongsList) do
    CreateButton(song.name, "🎤", function()
        PlayGlobalSound(song.id)
    end)
end

CreateInputBox("أدخل كود الأغنية (ID)", function(text)
    if text and text ~= "" then
        PlayGlobalSound(text)
    end
end)

CreateSlider("مستوى الصوت", "🔊", 0, 100, 50, function(value)
    SoundVolume = value / 100
    if CurrentSound then
        CurrentSound.Volume = SoundVolume
    end
end)

CreateButton("إيقاف الموسيقى", "🔇", function()
    StopGlobalSound()
end)

-- قسم تعقب اللاعبين
CreateSection("PLAYER TRACKER", "👥")

CreateInputBox("أدخل اسم اللاعب", function(text)
    CurrentTarget = FindPlayer(text)
    if CurrentTarget then
        Notify("✅ ثائر", "تم العثور على: " .. CurrentTarget.Name)
    else
        Notify("❌ ثائر", "لم يتم العثور على لاعب")
    end
end)

CreateButton("تيليپورت إلى اللاعب", "🎯", function()
    if CurrentTarget then
        TeleportToPlayer(CurrentTarget)
    else
        Notify("⚠️ ثائر", "ابحث عن لاعب أولاً")
    end
end)

-- قسم الأمان
CreateSection("SECURITY", "🛡️")

CreateButton("تفعيل الحماية الكاملة", "🔒", function()
    AntiBan()
end)

-- قسم المعلومات
CreateSection("INFO", "ℹ️")

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0.95, 0, 0.12, 0)
InfoText.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
InfoText.BackgroundTransparency = 0.4
InfoText.Text = "🔥 ثائر X100\nالمطور: Shadow Team\nالنسخة: Ultimate Edition\nجميع الحقوق محفوظة"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.GothamMedium
InfoText.Parent = ScrollFrame

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 12)
InfoCorner.Parent = InfoText

UpdateCanvas()

-- ========== [ إخفاء/إظهار الواجهة ] ==========
local UIHidden = false
HideBtn.MouseButton1Click:Connect(function()
    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden
    Notify("ثائر", UIHidden and "الواجهة مخفية" or "الواجهة ظاهرة")
end)

-- زر F5 لإظهار/إخفاء الواجهة
UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.F5 then
        UIHidden = not UIHidden
        MainFrame.Visible = not UIHidden
        Notify("ثائر", UIHidden and "الواجهة مخفية" or "الواجهة ظاهرة")
    end
end)

-- ========== [ نافذة الترحيب المنزلقة ] ==========
local WelcomeToast = Instance.new("Frame")
WelcomeToast.Size = UDim2.new(0, 260, 0, 50)
WelcomeToast.Position = UDim2.new(0.5, -130, 0, -60)
WelcomeToast.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
WelcomeToast.BackgroundTransparency = 0.1
WelcomeToast.Parent = ScreenGui

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(1, 0)
ToastCorner.Parent = WelcomeToast

local ToastText = Instance.new("TextLabel")
ToastText.Size = UDim2.new(1, 0, 1, 0)
ToastText.BackgroundTransparency = 1
ToastText.Text = "🔥 أهلاً إلى ثائر بلاي | النظام جاهز للاختراق"
ToastText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToastText.TextSize = 14
ToastText.Font = Enum.Font.GothamBold
ToastText.Parent = WelcomeToast

-- حركة نزول الترحيب
local ToastTween = TweenService:Create(WelcomeToast, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -130, 0.05, 0)})
ToastTween:Play()
wait(4)
local ToastHide = TweenService:Create(WelcomeToast, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -130, 0, -60)})
ToastHide:Play()
wait(0.3)
WelcomeToast:Destroy()

-- ========== [ رسالة النهاية ] ==========
Notify("🔥 ثائر X100", "تم التحميل | E:طيران | X:جدران | N,M:حفظ | B,V:تيليپورت | C,Z:سرعة | G:واجهة")

print([[
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                         ثائر X100 - تم التحميل بنجاح                         ║
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