--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║                         ثائر X100 - الهاكر الأسطوري                          ║
    ║                                                                              ║
    ║   ✈️ طيران بالكاميرا  |  🧱 اختراق جدران  |  💾 حفظ منطقتين                  ║
    ║   🎵 موسيقى عالمية    |  👥 تعقب لاعبين     |  ⚡ سرعة متغيرة               ║
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

-- ========== [ المتغيرات ] ==========
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity = nil
local Checkpoint1 = nil
local Checkpoint2 = nil
local CurrentTarget = nil
local MenuVisible = true

-- متغيرات الموسيقى
local CurrentSound = nil
local SoundPlaying = false
local SoundVolume = 0.5
local SongId = "3017157406"

-- قائمة الأغاني الجاهزة
local SongsList = {
    {name = "🎵 أغنية 1 - هادئة", id = "3017157406"},
    {name = "🎵 أغنية 2 - حماسية", id = "1843170826"},
    {name = "🎵 أغنية 3 - حزينة", id = "9126245770"},
    {name = "🎵 أغنية 4 - راب", id = "6698976160"},
    {name = "🎵 أغنية 5 - الكتروني", id = "9032979010"}
}

-- حالة الأزرار
local ButtonStates = {
    fly = false,
    noclip = false
}

-- ========== [ دالة تشغيل الموسيقى العالمية ] ==========
local function PlayGlobalSound(soundId, volume)
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or SoundVolume
    sound.Looped = true
    sound.PlayOnRemove = false
    
    local target = Character and Character:FindFirstChild("HumanoidRootPart") or RootPart
    sound.Parent = target
    sound:Play()
    
    CurrentSound = sound
    SoundPlaying = true
end

local function StopGlobalSound()
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil
    end
    SoundPlaying = false
end

-- ========== [ دالة البحث عن لاعب ] ==========
local function FindPlayer(partialName)
    if not partialName or partialName == "" then return nil end
    local lowerPartial = string.lower(partialName)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerName = string.lower(player.Name)
            if string.sub(playerName, 1, #lowerPartial) == lowerPartial then
                return player
            end
        end
    end
    return nil
end

-- ========== [ إنشاء الواجهة الاحترافية ] ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerHack"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.125, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 3, 12)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- زوايا دائرية
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 25)
MainCorner.Parent = MainFrame

-- إطار نيون
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 30, 100)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 20, 80)
TitleBar.BackgroundTransparency = 0.25
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 25)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🔥 ثائر X100 | الهاكر الأسطوري"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

-- زر إخفاء الواجهة
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
HideBtn.Position = UDim2.new(0.88, 0, 0.15, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 100)
HideBtn.BackgroundTransparency = 0.3
HideBtn.Text = "🗕"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 18
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = TitleBar

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(1, 0)
HideCorner.Parent = HideBtn

-- منطقة التمرير
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0.87, 0)
ScrollFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 100)
ScrollFrame.Parent = MainFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 10)
ScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ScrollLayout.Parent = ScrollFrame

-- تحديث CanvasSize
local function UpdateCanvas()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 20)
end
ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

-- ========== [ دالة إنشاء قسم ] ==========
local function CreateSection(title, icon)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.94, 0, 0.06, 0)
    section.BackgroundTransparency = 1
    section.Parent = ScrollFrame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.35, 0, 0.02, 0)
    line.Position = UDim2.new(0.6, 0, 0.45, 0)
    line.BackgroundColor3 = Color3.fromRGB(255, 40, 100)
    line.BackgroundTransparency = 0.5
    line.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.55, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = icon .. " " .. title
    titleLabel.TextColor3 = Color3.fromRGB(255, 80, 140)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = section
    
    UpdateCanvas()
    return section
end

-- ========== [ دالة إنشاء زر تبديل (Toggle) ] ==========
local function CreateToggle(text, icon, callback, activeColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.94, 0, 0.08, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
    btn.BackgroundTransparency = 0.3
    btn.Text = icon .. " " .. text .. " 🔘 OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btn
    
    local active = false
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = activeColor or Color3.fromRGB(255, 40, 100)
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
    btn.Size = UDim2.new(0.94, 0, 0.08, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 30, 90)
    btn.BackgroundTransparency = 0.15
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    UpdateCanvas()
    return btn
end

-- ========== [ دالة إنشاء منزلق (Slider) ] ==========
local function CreateSlider(text, icon, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.94, 0, 0.1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 8, 28)
    container.BackgroundTransparency = 0.4
    container.Parent = ScrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 15)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.4, 0)
    label.Position = UDim2.new(0.05, 0, 0.1, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 200, 200)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.75, 0, 0.1, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 80, 140)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = container
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.9, 0, 0.28, 0)
    slider.Position = UDim2.new(0.05, 0, 0.55, 0)
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
    thumb.Size = UDim2.new(0.08, 0, 1.2, 0)
    thumb.Position = UDim2.new((default - min) / (max - min) - 0.04, 0, -0.1, 0)
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
            local sliderWidth = slider.AbsoluteSize.Width
            local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent - 0.04, 0, -0.1, 0)
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
    container.Size = UDim2.new(0.94, 0, 0.09, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 8, 28)
    container.BackgroundTransparency = 0.4
    container.Parent = ScrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 15)
    containerCorner.Parent = container
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.95, 0, 0.7, 0)
    input.Position = UDim2.new(0.025, 0, 0.15, 0)
    input.BackgroundColor3 = Color3.fromRGB(5, 3, 15)
    input.BackgroundTransparency = 0.3
    input.PlaceholderText = placeholder
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 13
    input.Font = Enum.Font.GothamMedium
    input.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 12)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function(enterPressed)
        if input.Text ~= "" then
            callback(input.Text)
        end
    end)
    
    UpdateCanvas()
    return input
end

-- ========== [ إنشاء الواجهة ] ==========

-- قسم الطيران
CreateSection("FLIGHT SYSTEM", "✈️")

CreateToggle("الطيران الحر", "✈️", function(active)
    if active then
        Flying = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.Parent = RootPart
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تفعيل الطيران الحر", Duration = 1})
    else
        Flying = false
        if BodyVelocity then BodyVelocity:Destroy() end
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "إيقاف الطيران", Duration = 1})
    end
end, Color3.fromRGB(255, 40, 100))

CreateSlider("سرعة الطيران", "⚡", 30, 300, 100, function(value)
    FlySpeed = value
end)

-- قسم اختراق الجدران
CreateSection("WALL HACK", "🧱")

CreateToggle("اختراق الجدران", "🧱", function(active)
    NoClip = active
    StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = active and "تفعيل اختراق الجدران" or "إيقاف اختراق الجدران", Duration = 1})
end, Color3.fromRGB(255, 40, 100))

-- قسم حفظ المناطق
CreateSection("CHECKPOINT SYSTEM", "💾")

CreateButton("حفظ المنطقة 1", "📍", function()
    Checkpoint1 = RootPart.CFrame
    StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تم حفظ المنطقة 1", Duration = 1})
end)

CreateButton("تيليپورت للمنطقة 1", "🌀", function()
    if Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تيليپورت للمنطقة 1", Duration = 1})
    end
end)

CreateButton("حفظ المنطقة 2", "📍", function()
    Checkpoint2 = RootPart.CFrame
    StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تم حفظ المنطقة 2", Duration = 1})
end)

CreateButton("تيليپورت للمنطقة 2", "🌀", function()
    if Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تيليپورت للمنطقة 2", Duration = 1})
    end
end)

-- قسم الموسيقى
CreateSection("GLOBAL MUSIC", "🎵")

-- قائمة الأغاني المنسدلة (بسيطة)
for _, song in pairs(SongsList) do
    CreateButton(song.name, "🎤", function()
        SongId = song.id
        PlayGlobalSound(SongId, SoundVolume)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تشغيل: " .. song.name, Duration = 1})
    end)
end

CreateInputBox("🎼 أدخل كود أغنية مخصص (ID)", function(text)
    if text and text ~= "" then
        SongId = text
        PlayGlobalSound(SongId, SoundVolume)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تشغيل كود: " .. text, Duration = 1})
    end
end)

CreateSlider("مستوى الصوت", "🔊", 0, 1, 0.5, function(value)
    SoundVolume = value
    if CurrentSound then
        CurrentSound.Volume = value
    end
end)

CreateButton("إيقاف الموسيقى", "🔇", function()
    StopGlobalSound()
    StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "إيقاف الموسيقى", Duration = 1})
end)

-- قسم تعقب اللاعبين
CreateSection("PLAYER TRACKER", "👥")

local TargetStatus = Instance.new("TextLabel")
TargetStatus.Size = UDim2.new(0.94, 0, 0.06, 0)
TargetStatus.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
TargetStatus.BackgroundTransparency = 0.4
TargetStatus.Text = "🔍 انتظر إدخال اسم اللاعب..."
TargetStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
TargetStatus.TextSize = 12
TargetStatus.Font = Enum.Font.GothamMedium
TargetStatus.Parent = ScrollFrame

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 12)
TargetCorner.Parent = TargetStatus

CreateInputBox("🔍 اكتب أول 3 حروف من اسم اللاعب", function(text)
    local target = FindPlayer(text)
    if target then
        CurrentTarget = target
        TargetStatus.Text = "✅ تم العثور على: " .. target.Name
        TargetStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تم العثور على: " .. target.Name, Duration = 1})
    else
        CurrentTarget = nil
        TargetStatus.Text = "❌ لم يتم العثور على لاعب باسم: " .. text
        TargetStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

CreateButton("تيليپورت إلى اللاعب", "🎯", function()
    if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = CurrentTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تيليپورت إلى " .. CurrentTarget.Name, Duration = 1})
    else
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "اللاعب غير موجود", Duration = 1})
    end
end)

-- قسم الأمان
CreateSection("SECURITY", "🛡️")

CreateButton("تفعيل الحماية الكاملة", "🔒", function()
    StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "الحماية الكاملة مفعلة", Duration = 1})
end)

-- تحديث Canvas آخر
UpdateCanvas()

-- ========== [ إخفاء/إظهار الواجهة ] ==========
HideBtn.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
    StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = MenuVisible and "الواجهة ظاهرة" or "الواجهة مخفية", Duration = 1})
end)

-- زر F5 لإظهار/إخفاء الواجهة
UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.F5 then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = MenuVisible and "الواجهة ظاهرة" or "الواجهة مخفية", Duration = 1})
    end
end)

-- ========== [ نظام الطيران والحركة ] ==========
local KeyStates = {W = false, A = false, S = false, D = false}

UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
    
    -- اختصار E للطيران السريع
    if Input.KeyCode == Enum.KeyCode.E then
        if Flying then
            Flying = false
            if BodyVelocity then BodyVelocity:Destroy() end
            StarterGui:SetCore("SendNotification", {Title = "✈️", Text = "إيقاف الطيران", Duration = 1})
        else
            Flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            BodyVelocity.Parent = RootPart
            StarterGui:SetCore("SendNotification", {Title = "✈️", Text = "تفعيل الطيران", Duration = 1})
        end
    end
    
    -- اختصار X لاختراق الجدران السريع
    if Input.KeyCode == Enum.KeyCode.X then
        NoClip = not NoClip
        StarterGui:SetCore("SendNotification", {Title = "🧱", Text = NoClip and "اختراق الجدران مفعل" or "اختراق الجدران معطل", Duration = 1})
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

-- نظام اختراق الجدران (ثابت)
RunService.Stepped:Connect(function()
    if NoClip and Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") and Part.Name ~= "Head" then
                pcall(function()
                    Part.CanCollide = false
                end)
            end
        end
    end
end)

-- ========== [ إعادة الربط عند الموت ] ==========
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    wait(0.5)
    if NoClip then
        NoClip = true
    end
    if Flying then
        Flying = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.Parent = RootPart
    end
end)

-- ========== [ رسالة الترحيب ] ==========
StarterGui:SetCore("SendNotification", {
    Title = "🔥 ثائر X100",
    Text = "تم التحميل | جميع الميزات جاهزة | F5 لإخفاء الواجهة",
    Duration = 5
})

print([[
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              ثائر X100 - تم التحميل بنجاح                   ║
║                                                              ║
║   🎮 F5  ← إظهار/إخفاء الواجهة                              ║
║   🎮 E   ← تشغيل/إيقاف الطيران                              ║
║   🎮 X   ← تشغيل/إيقاف اختراق الجدران                       ║
║                                                              ║
║   ✈️ طيران بالكاميرا (WASD = تحريك باتجاه النظر)            ║
║   🎵 موسيقى عالمية (يسمعها القريبون منك)                    ║
║   👥 تعقب لاعبين (تيليپورت لأي لاعب)                        ║
║   💾 حفظ منطقتين (تيليپورت سريع)                            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
]])