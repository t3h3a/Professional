--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║                    ثائر X100 - النسخة الاحترافية النهائية                    ║
    ║                                                                              ║
    ║   ✈️ طيران بالكاميرا  |  🧱 اختراق جدران  |  💾 حفظ 3 مناطق                  ║
    ║   🎵 موسيقى عالمية    |  👥 تعقب لاعبين   |  ⚡ سرعة + قفز متغيرة            ║
    ║   🛡️ حماية كاملة     |  📱 واجهة أفقية   |  🎮 أيقونة تصغير                 ║
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
local BodyGyro = nil
local Checkpoint1 = nil
local Checkpoint2 = nil
local Checkpoint3 = nil
local Checkpoints = {nil, nil, nil}
local CurrentTarget = nil
local WalkSpeedValue = 16
local JumpPowerValue = 50
local UIHidden = false

-- ========== [ نظام الإشعارات ] ==========
local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 2
        })
    end)
end

-- ========== [ نظام الحماية Metatable Hooking ] ==========
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

-- ========== [ نظام الطيران المحسن (BodyVelocity + BodyGyro) ] ==========
local KeyStates = {W = false, A = false, S = false, D = false}

local function UpdateFlight()
    if not Flying or not BodyVelocity then return end
    
    Camera = workspace.CurrentCamera or Camera
    local cameraCFrame = Camera.CFrame
    local moveVector = Vector3.new()
    if KeyStates.W then moveVector = moveVector + cameraCFrame.LookVector end
    if KeyStates.S then moveVector = moveVector - cameraCFrame.LookVector end
    if KeyStates.A then moveVector = moveVector - cameraCFrame.RightVector end
    if KeyStates.D then moveVector = moveVector + cameraCFrame.RightVector end
    if moveVector.Magnitude <= 0 and Humanoid.MoveDirection.Magnitude > 0 then
        moveVector = Humanoid.MoveDirection
    end
    
    if moveVector.Magnitude > 0 then
        BodyVelocity.Velocity = moveVector.Unit * FlySpeed
        
        -- تحديث اتجاه الجيروسكوب للحفاظ على التوازن
        if BodyGyro then
            BodyGyro.CFrame = CFrame.new(RootPart.Position, RootPart.Position + cameraCFrame.LookVector)
            BodyGyro.D = 15e3
        end
    else
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

local function StartFly()
    if Flying then return end
    Flying = true
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.P = 15e3
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Parent = RootPart
    
    Humanoid.PlatformStand = false
    Humanoid.AutoRotate = false
    Humanoid.Sit = false
    pcall(function()
        Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end)
    Notify("✈️ ثائر", "تفعيل الطيران الحر")
end

local function StopFly()
    if not Flying then return end
    Flying = false
    if BodyVelocity then BodyVelocity:Destroy(); BodyVelocity = nil end
    if BodyGyro then BodyGyro:Destroy(); BodyGyro = nil end
    Humanoid.PlatformStand = false
    Humanoid.AutoRotate = true
    Notify("✈️ ثائر", "إيقاف الطيران")
end

local function SaveCheckpoint(index)
    Checkpoints[index] = RootPart.CFrame
    if index == 1 then Checkpoint1 = Checkpoints[index] end
    if index == 2 then Checkpoint2 = Checkpoints[index] end
    if index == 3 then Checkpoint3 = Checkpoints[index] end
    Notify("Checkpoint", "Saved checkpoint " .. tostring(index))
end

local function GetCheckpoint(index)
    if Checkpoints[index] then return Checkpoints[index] end
    if index == 1 then return Checkpoint1 end
    if index == 2 then return Checkpoint2 end
    if index == 3 then return Checkpoint3 end
    return nil
end

local function TeleportCheckpoint(index)
    local checkpoint = GetCheckpoint(index)
    if checkpoint then
        RootPart.CFrame = checkpoint + Vector3.new(0, 3, 0)
        Notify("Checkpoint", "Teleported to checkpoint " .. tostring(index))
    end
end

-- ربط المدخلات
UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
    
    if Input.KeyCode == Enum.KeyCode.E then
        if Flying then StopFly() else StartFly() end
    end
    
    if Input.KeyCode == Enum.KeyCode.X then
        NoClip = not NoClip
        Notify("🧱 ثائر", NoClip and "تفعيل اختراق الجدران" or "إيقاف اختراق الجدران")
    end
    
    if Input.KeyCode == Enum.KeyCode.N then
        SaveCheckpoint(1)
    end
    if Input.KeyCode == Enum.KeyCode.M then
        SaveCheckpoint(2)
    end
    if Input.KeyCode == Enum.KeyCode.K then
        SaveCheckpoint(3)
    end
    
    if Input.KeyCode == Enum.KeyCode.B then
        TeleportCheckpoint(1)
    end
    if Input.KeyCode == Enum.KeyCode.V then
        TeleportCheckpoint(2)
    end
    if Input.KeyCode == Enum.KeyCode.J then
        TeleportCheckpoint(3)
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

-- تحديث الطيران في كل إطار
RunService.RenderStepped:Connect(UpdateFlight)

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
local CurrentSound = nil
local SoundVolume = 0.5

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
    Notify("🎵 ثائر", "تشغيل الموسيقى")
end

local function StopGlobalSound()
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil
    end
    Notify("🔇 ثائر", "إيقاف الموسيقى")
end

-- ========== [ دوال السرعة والقفز ] ==========
local function SetWalkSpeed(speed)
    WalkSpeedValue = speed
    pcall(function()
        Humanoid.WalkSpeed = speed
    end)
end

local function SetJumpPower(power)
    JumpPowerValue = power
    pcall(function()
        Humanoid.JumpPower = power
        Humanoid.UseJumpPower = true
    end)
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Camera = workspace.CurrentCamera or Camera
    SetWalkSpeed(WalkSpeedValue)
    SetJumpPower(JumpPowerValue)

    if Flying then
        if BodyVelocity then BodyVelocity:Destroy(); BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy(); BodyGyro = nil end
        Flying = false
        StartFly()
    end
end)

-- ========== [ إنشاء الواجهة الأفقية ] ==========

-- ===== 1. القاعدة الرئيسية =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerX100"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ===== 2. أيقونة التصغير (تظهر عند إخفاء الواجهة) =====
local MainFrame = nil
local MiniIcon = Instance.new("TextButton")
MiniIcon.Size = UDim2.new(0, 50, 0, 50)
MiniIcon.Position = UDim2.new(1, -60, 1, -60)
MiniIcon.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
MiniIcon.BackgroundTransparency = 0.1
MiniIcon.Text = "🔥"
MiniIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniIcon.TextSize = 24
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.Active = true
MiniIcon.Visible = false
MiniIcon.ZIndex = 20
MiniIcon.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniIcon

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255, 255, 255)
MiniStroke.Thickness = 1
MiniStroke.Transparency = 0.45
MiniStroke.Parent = MiniIcon

-- ===== 3. الإطار الرئيسي =====
MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 260)
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

-- ===== 4. شريط العنوان =====
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
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

-- زر التصغير
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
HideBtn.Position = UDim2.new(0.89, 0, 0.15, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
HideBtn.BackgroundTransparency = 0.1
HideBtn.Text = "🗕"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 14
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Active = true
HideBtn.Parent = TitleBar

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(1, 0)
HideCorner.Parent = HideBtn

local HideStroke = Instance.new("UIStroke")
HideStroke.Color = Color3.fromRGB(255, 255, 255)
HideStroke.Thickness = 1
HideStroke.Transparency = 0.55
HideStroke.Parent = HideBtn

HideBtn.ZIndex = 10

local panelTween = nil
local function ShowPanel()
    if panelTween then panelTween:Cancel() end
    MainFrame.Visible = true
    MiniIcon.Visible = false
    UIHidden = false
    MainFrame.BackgroundTransparency = 1
    panelTween = TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.15
    })
    panelTween:Play()
end

local function HidePanel()
    if panelTween then panelTween:Cancel() end
    UIHidden = true
    panelTween = TweenService:Create(MainFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    panelTween:Play()
    panelTween.Completed:Connect(function()
        if UIHidden then
            MainFrame.Visible = false
            MainFrame.BackgroundTransparency = 0.15
            MiniIcon.Visible = true
        end
    end)
    Notify("ثائر", "الواجهة مصغرة | اسحب الأيقونة أو اضغط عليها للإظهار")
end

local miniDragging = false
local miniMoved = false
local miniDragOffset = Vector2.new()
local miniDragStart = Vector2.new()

MiniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniMoved = false
        miniDragStart = Vector2.new(input.Position.X, input.Position.Y)
        miniDragOffset = Vector2.new(input.Position.X - MiniIcon.AbsolutePosition.X, input.Position.Y - MiniIcon.AbsolutePosition.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if miniDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        Camera = workspace.CurrentCamera or Camera
        local viewport = Camera.ViewportSize
        local iconSize = MiniIcon.AbsoluteSize
        local x = math.clamp(input.Position.X - miniDragOffset.X, 0, viewport.X - iconSize.X)
        local y = math.clamp(input.Position.Y - miniDragOffset.Y, 0, viewport.Y - iconSize.Y)
        MiniIcon.Position = UDim2.fromOffset(x, y)
        miniMoved = (Vector2.new(input.Position.X, input.Position.Y) - miniDragStart).Magnitude > 6
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = false
    end
end)

MiniIcon.MouseButton1Click:Connect(function()
    if not miniMoved then
        ShowPanel()
    end
end)

HideBtn.MouseButton1Click:Connect(HidePanel)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        if UIHidden then
            ShowPanel()
        else
            HidePanel()
        end
    end
end)

-- ===== 5. القائمة الجانبية =====
local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0, 110, 1, -36)
SideBar.Position = UDim2.new(0, 0, 0, 36)
SideBar.BackgroundColor3 = Color3.fromRGB(0, 20, 60)
SideBar.BackgroundTransparency = 0.1
SideBar.BorderSizePixel = 0
SideBar.Active = true
SideBar.CanvasSize = UDim2.new(0, 0, 0, 0)
SideBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
SideBar.ScrollingDirection = Enum.ScrollingDirection.Y
SideBar.ScrollBarThickness = 3
SideBar.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 255)
SideBar.Parent = MainFrame

local SideBarLayout = Instance.new("UIListLayout")
SideBarLayout.Padding = UDim.new(0, 6)
SideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideBarLayout.Parent = SideBar

SideBarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SideBar.CanvasSize = UDim2.new(0, 0, 0, SideBarLayout.AbsoluteContentSize.Y + 12)
end)

-- ===== 6. الحاوية الرئيسية =====
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -120, 1, -36)
Container.Position = UDim2.new(0, 115, 0, 36)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Parent = MainFrame

-- ========== [ دوال إنشاء النظام ] ==========

local function CreatePage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.Active = true
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.ScrollBarThickness = 6
    page.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 255)
    page.Parent = Container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page
    
    local function UpdateCanvas()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
    UpdateCanvas()
    
    return page
end

local function CreateTab(name, targetPage)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(100, 180, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Active = true
    btn.Parent = SideBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(80, 160, 255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.65
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(Container:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        targetPage.Visible = true
        
        for _, b in pairs(SideBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
                b.BackgroundTransparency = 0.3
                b.TextColor3 = Color3.fromRGB(100, 180, 255)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
        btn.BackgroundTransparency = 0.1
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return btn
end

local function CreateButton(page, text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
    btn.BackgroundTransparency = 0.2
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Active = true
    btn.Parent = page
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 120, 200)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(page, text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
    btn.BackgroundTransparency = 0.2
    btn.Text = icon .. " " .. text .. " 🔘 OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Active = true
    btn.Parent = page
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 120, 200)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
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
    container.Active = true
    container.Parent = page
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container

    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Color3.fromRGB(50, 120, 200)
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.75
    containerStroke.Parent = container
    
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
    slider.Active = true
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
    thumb.Active = true
    thumb.AutoButtonColor = false
    thumb.Parent = slider
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local dragging = false
    local activeInput = nil

    local function SetSliderFromX(x)
        local sliderWidth = slider.AbsoluteSize.X
        if sliderWidth <= 0 then return end

        local percent = math.clamp((x - slider.AbsolutePosition.X) / sliderWidth, 0, 1)
        local value = math.floor(min + (max - min) * percent + 0.5)

        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(math.clamp(percent - 0.05, -0.05, 0.95), 0, -0.15, 0)
        valueLabel.Text = tostring(value)
        label.Text = icon .. " " .. text .. ": " .. tostring(value)
        callback(value)
    end

    local function BeginSliderDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeInput = input
            page.ScrollingEnabled = false
            SetSliderFromX(input.Position.X)
        end
    end

    slider.InputBegan:Connect(BeginSliderDrag)
    thumb.InputBegan:Connect(BeginSliderDrag)

    UserInputService.InputEnded:Connect(function(input)
        if input == activeInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            activeInput = nil
            page.ScrollingEnabled = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == activeInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            SetSliderFromX(input.Position.X)
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

-- ========== [ بناء الصفحات ] ==========

-- صفحة الطيران
local FlightPage = CreatePage()
CreateTab("✈️ طيران", FlightPage)

CreateToggle(FlightPage, "الطيران الحر", "✈️", function(active)
    if active then StartFly() else StopFly() end
end)

CreateSlider(FlightPage, "سرعة الطيران", "⚡", 30, 300, 100, function(value)
    FlySpeed = value
end)

CreateSlider(FlightPage, "سرعة المشي", "🚶", 16, 250, 16, function(value)
    SetWalkSpeed(value)
end)

CreateSlider(FlightPage, "قوة القفز", "🚀", 50, 500, 50, function(value)
    SetJumpPower(value)
end)

CreateToggle(FlightPage, "اختراق الجدران", "🧱", function(active)
    NoClip = active
end)

-- صفحة المناطق (3 مناطق)
local CheckpointPage = CreatePage()
CreateTab("💾 مناطق", CheckpointPage)

CreateButton(CheckpointPage, "حفظ المنطقة 1", "📍", function()
    SaveCheckpoint(1)
end)
CreateButton(CheckpointPage, "تيليپورت 1", "🌀", function()
    TeleportCheckpoint(1)
end)

CreateButton(CheckpointPage, "حفظ المنطقة 2", "📍", function()
    SaveCheckpoint(2)
end)
CreateButton(CheckpointPage, "تيليپورت 2", "🌀", function()
    TeleportCheckpoint(2)
end)

CreateButton(CheckpointPage, "حفظ المنطقة 3", "📍", function()
    SaveCheckpoint(3)
end)
CreateButton(CheckpointPage, "تيليپورت 3", "🌀", function()
    TeleportCheckpoint(3)
end)

-- صفحة الموسيقى
local MusicPage = CreatePage()
CreateTab("🎵 موسيقى", MusicPage)

local songs = {"3017157406", "1843170826", "9126245770", "6698976160", "9032979010"}
for i, id in ipairs(songs) do
    CreateButton(MusicPage, "أغنية " .. i, "🎤", function()
        PlayGlobalSound(id)
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

CreateButton(PlayersPage, "تيليپورت للاعب", "🎯", function()
    if CurrentTarget then
        TeleportToPlayer(CurrentTarget)
    else
        Notify("⚠️ ثائر", "ابحث عن لاعب أولاً")
    end
end)

-- صفحة الأمان
local SecurityPage = CreatePage()
CreateTab("🛡️ أمان", SecurityPage)

CreateButton(SecurityPage, "تفعيل الحماية", "🔒", function()
    AntiBan()
end)

-- صفحة المعلومات
local InfoPage = CreatePage()
CreateTab("ℹ️ معلومات", InfoPage)

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0.95, 0, 0, 140)
InfoText.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
InfoText.BackgroundTransparency = 0.3
InfoText.Text = "🔥 ثائر X100\n\nالنسخة: Ultimate Edition\nالمطور: Shadow Team\n\nاختصارات:\nE ← طيران\nX ← جدران\nN,M,K ← حفظ\nB,V,J ← تيليپورت\nC,Z ← سرعة الطيران\nF5 ← إخفاء الواجهة"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.GothamMedium
InfoText.Parent = InfoPage

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = InfoText

-- ========== [ إظهار الصفحة الأولى ] ==========
for _, child in pairs(Container:GetChildren()) do
    if child:IsA("ScrollingFrame") then
        child.Visible = false
    end
end
FlightPage.Visible = true

-- ========== [ رسالة البداية ] ==========
Notify("🔥 ثائر X100", "تم التحميل | جميع الميزات جاهزة", 5)

print([[
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                    ثائر X100 - النسخة الاحترافية النهائية                    ║
║                                                                              ║
║   🎮 E  ← طيران                                            ║
║   🎮 X  ← اختراق جدران                                     ║
║   🎮 N  ← حفظ المنطقة 1                                    ║
║   🎮 M  ← حفظ المنطقة 2                                    ║
║   🎮 K  ← حفظ المنطقة 3                                    ║
║   🎮 B  ← تيليپورت 1                                       ║
║   🎮 V  ← تيليپورت 2                                       ║
║   🎮 J  ← تيليپورت 3                                       ║
║   🎮 C  ← +25 سرعة الطيران                                 ║
║   🎮 Z  ← -25 سرعة الطيران                                 ║
║   🎮 F5 ← إظهار/إخفاء الواجهة                              ║
║                                                                              ║
║                         جميع الحقوق محفوظة © ثائر 2024                       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
]])
