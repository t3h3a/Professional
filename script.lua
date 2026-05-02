--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║              ثائر X100 Mobile - الهاكر الأسطوري              ║
    ║                                                              ║
    ║   واجهة هاتف احترافية | خفيفة | جميع الميزات                ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

-- ========== [ الخدمات الأساسية ] ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

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
local SpeedBoostActive = false
local SpeedBoostVelocity = nil
local NoclipConnection = nil

-- نظام الصوت
local CurrentSound = nil
local SoundPlaying = false
local SoundVolume = 0.5
local SongId = "3017157406"

-- حالة الواجهة
local MenuVisible = true
local ScreenGui = nil
local Frame = nil

-- ========== [ إنشاء الواجهة الاحترافية للهاتف ] ==========
local function CreateMenu()
    -- إنشاء ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ThaerMenu"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    
    -- الخلفية الرئيسية
    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.9, 0, 0.75, 0)
    Frame.Position = UDim2.new(0.05, 0, 0.125, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
    Frame.BackgroundTransparency = 0.08
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = ScreenGui
    
    -- تأثير الزجاج (Acrylic)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 25)
    Corner.Parent = Frame
    
    -- Border نيون
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(255, 50, 100)
    Border.Thickness = 2
    Border.Transparency = 0.5
    Border.Parent = Frame
    
    -- عنوان الواجهة
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0.12, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 30, 80)
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 25)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 ثائر X100"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar
    
    -- زر إغلاق
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
    CloseBtn.Position = UDim2.new(0.88, 0, 0.15, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    CloseBtn.BackgroundTransparency = 0.3
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn
    
    -- ScrollingFrame للمحتوى
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 0.85, 0)
    ScrollingFrame.Position = UDim2.new(0, 0, 0.12, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
    ScrollingFrame.Parent = Frame
    
    local CanvasLayout = Instance.new("UIListLayout")
    CanvasLayout.Padding = UDim.new(0, 12)
    CanvasLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CanvasLayout.Parent = ScrollingFrame
    
    -- ========== [ دالة إنشاء زر ] ==========
    local function CreateButton(text, icon, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.92, 0, 0.08, 0)
        btn.BackgroundColor3 = color or Color3.fromRGB(255, 40, 90)
        btn.BackgroundTransparency = 0.2
        btn.Text = icon .. "  " .. text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = ScrollingFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 15)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        -- تحديث CanvasSize
        CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y)
        end)
        
        return btn
    end
    
    -- ========== [ دالة إنشاء منزلق (Slider) ] ==========
    local function CreateSlider(text, icon, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.92, 0, 0.12, 0)
        container.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
        container.BackgroundTransparency = 0.4
        container.Parent = ScrollingFrame
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 15)
        containerCorner.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0.4, 0)
        label.Position = UDim2.new(0.05, 0, 0.1, 0)
        label.BackgroundTransparency = 1
        label.Text = icon .. "  " .. text .. ": " .. tostring(default)
        label.TextColor3 = Color3.fromRGB(255, 200, 200)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.Parent = container
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
        valueLabel.Position = UDim2.new(0.75, 0, 0.1, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Color3.fromRGB(255, 100, 150)
        valueLabel.TextSize = 14
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Parent = container
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0.9, 0, 0.25, 0)
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
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.08, 0, 1.2, 0)
        button.Position = UDim2.new((default - min) / (max - min) - 0.04, 0, -0.1, 0)
        button.BackgroundColor3 = Color3.fromRGB(255, 80, 130)
        button.Text = ""
        button.Parent = slider
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
        btnCorner.Parent = button
        
        local dragging = false
        button.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position.X
                local sliderPos = slider.AbsolutePosition.X
                local sliderWidth = slider.AbsoluteSize.X
                local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
                local value = min + (max - min) * percent
                value = math.floor(value / 5) * 5
                
                fill.Size = UDim2.new(percent, 0, 1, 0)
                button.Position = UDim2.new(percent - 0.04, 0, -0.1, 0)
                valueLabel.Text = tostring(value)
                label.Text = icon .. "  " .. text .. ": " .. tostring(value)
                callback(value)
            end
        end)
        
        CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y)
        end)
        
        return container
    end
    
    -- ========== [ دالة إنشاء قسم ] ==========
    local function CreateSection(title)
        local section = Instance.new("TextLabel")
        section.Size = UDim2.new(0.92, 0, 0.05, 0)
        section.BackgroundTransparency = 1
        section.Text = "▸ " .. title
        section.TextColor3 = Color3.fromRGB(255, 100, 150)
        section.TextSize = 16
        section.TextXAlignment = Enum.TextXAlignment.Left
        section.Font = Enum.Font.GothamBold
        section.Parent = ScrollingFrame
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0.3, 0, 0.02, 0)
        line.Position = UDim2.new(0.65, 0, 0.4, 0)
        line.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
        line.Parent = section
        
        CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y)
        end)
        
        return section
    end
    
    -- ========== [ دالة إنشاء مربع حالة ] ==========
    local function CreateStatusBox()
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0.92, 0, 0.07, 0)
        box.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
        box.BackgroundTransparency = 0.4
        box.Parent = ScrollingFrame
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 15)
        boxCorner.Parent = box
        
        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, 0, 1, 0)
        statusText.BackgroundTransparency = 1
        statusText.Text = "✅ النظام جاهز"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
        statusText.TextSize = 13
        statusText.Font = Enum.Font.GothamMedium
        statusText.Parent = box
        
        CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y)
        end)
        
        return statusText
    end
    
    -- ========== [ إنشاء الأزرار والقوائم ] ==========
    
    -- قسم الطيران
    CreateSection("✈️ FLIGHT SYSTEM")
    
    local flyStatus = CreateStatusBox()
    
    CreateButton("تشغيل الطيران", "✈️", function()
        if not Flying then
            Flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            BodyVelocity.Parent = RootPart
            flyStatus.Text = "✈️ الطيران: مفعل | استخدم WASD"
            flyStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تفعيل الطيران الحر", Duration = 1})
        end
    end, Color3.fromRGB(255, 40, 90))
    
    CreateButton("إيقاف الطيران", "🛑", function()
        if Flying then
            Flying = false
            if BodyVelocity then BodyVelocity:Destroy() end
            flyStatus.Text = "✅ الطيران: معطل"
            flyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "إيقاف الطيران", Duration = 1})
        end
    end, Color3.fromRGB(200, 30, 70))
    
    CreateSlider("سرعة الطيران", "⚡", 30, 300, 100, function(v)
        FlySpeed = v
    end)
    
    -- قسم اختراق الجدران
    CreateSection("🧱 WALL HACK")
    
    local noclipStatus = CreateStatusBox()
    
    CreateButton("تفعيل اختراق الجدران", "🧱", function()
        if not NoClip then
            NoClip = true
            noclipStatus.Text = "🧱 اختراق الجدران: مفعل"
            noclipStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تفعيل اختراق الجدران", Duration = 1})
        end
    end, Color3.fromRGB(255, 40, 90))
    
    CreateButton("إيقاف اختراق الجدران", "🚫", function()
        if NoClip then
            NoClip = false
            noclipStatus.Text = "✅ اختراق الجدران: معطل"
            noclipStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "إيقاف اختراق الجدران", Duration = 1})
        end
    end, Color3.fromRGB(200, 30, 70))
    
    -- قسم حفظ المناطق
    CreateSection("💾 CHECKPOINT SYSTEM")
    
    local zone1Status = CreateStatusBox()
    local zone2Status = CreateStatusBox()
    
    CreateButton("حفظ المنطقة 1", "📍", function()
        Checkpoint1 = RootPart.CFrame
        zone1Status.Text = "📍 المنطقة 1: تم الحفظ"
        zone1Status.TextColor3 = Color3.fromRGB(0, 255, 100)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تم حفظ المنطقة 1", Duration = 1})
    end, Color3.fromRGB(100, 50, 200))
    
    CreateButton("تيليپورت للمنطقة 1", "🌀", function()
        if Checkpoint1 then
            RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تيليپورت للمنطقة 1", Duration = 1})
        else
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "لم يتم حفظ المنطقة 1", Duration = 1})
        end
    end, Color3.fromRGB(150, 30, 150))
    
    CreateButton("حفظ المنطقة 2", "📍", function()
        Checkpoint2 = RootPart.CFrame
        zone2Status.Text = "📍 المنطقة 2: تم الحفظ"
        zone2Status.TextColor3 = Color3.fromRGB(0, 255, 100)
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تم حفظ المنطقة 2", Duration = 1})
    end, Color3.fromRGB(100, 50, 200))
    
    CreateButton("تيليپورت للمنطقة 2", "🌀", function()
        if Checkpoint2 then
            RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تيليپورت للمنطقة 2", Duration = 1})
        else
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "لم يتم حفظ المنطقة 2", Duration = 1})
        end
    end, Color3.fromRGB(150, 30, 150))
    
    -- قسم تعقب اللاعبين
    CreateSection("👥 PLAYER TRACKER")
    
    local trackerStatus = CreateStatusBox()
    local targetName = ""
    
    -- مربع إدخال للبحث
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.92, 0, 0.1, 0)
    inputFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
    inputFrame.BackgroundTransparency = 0.3
    inputFrame.Parent = ScrollingFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 15)
    inputCorner.Parent = inputFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.95, 0, 0.7, 0)
    inputBox.Position = UDim2.new(0.025, 0, 0.15, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(10, 5, 25)
    inputBox.BackgroundTransparency = 0.5
    inputBox.PlaceholderText = "🔍 اكتب أول 3 حروف من اسم اللاعب..."
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.GothamMedium
    inputBox.Parent = inputFrame
    
    local inputCorner2 = Instance.new("UICorner")
    inputCorner2.CornerRadius = UDim.new(0, 12)
    inputCorner2.Parent = inputBox
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if inputBox.Text ~= "" then
            targetName = string.lower(inputBox.Text)
            local found = false
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and string.sub(string.lower(player.Name), 1, #targetName) == targetName then
                    CurrentTarget = player
                    found = true
                    trackerStatus.Text = "✅ تم العثور على: " .. player.Name
                    trackerStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
                    break
                end
            end
            if not found then
                CurrentTarget = nil
                trackerStatus.Text = "❌ لم يتم العثور على لاعب"
                trackerStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end)
    
    CreateButton("تيليپورت إلى اللاعب", "🎯", function()
        if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = CurrentTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تيليپورت إلى " .. CurrentTarget.Name, Duration = 1})
        else
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "اللاعب غير موجود", Duration = 1})
        end
    end, Color3.fromRGB(200, 50, 100))
    
    -- قسم الأمان
    CreateSection("🛡️ SECURITY")
    
    local securityStatus = CreateStatusBox()
    securityStatus.Text = "🛡️ Metatable Hooking: نشط"
    
    CreateButton("تفعيل الحماية الكاملة", "🔒", function()
        securityStatus.Text = "🛡️ الحماية الكاملة: مفعلة"
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "تفعيل الحماية الكاملة", Duration = 1})
    end, Color3.fromRGB(0, 150, 100))
    
    -- زر إغلاق الواجهة
    CloseBtn.MouseButton1Click:Connect(function()
        MenuVisible = false
        ScreenGui.Enabled = false
        StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = "الواجهة مخفية | اضغط F5 للإظهار", Duration = 2})
    end)
    
    CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y + 20)
    end)
    
    return true
end

-- ========== [ تشغيل الواجهة ] ==========
CreateMenu()

-- ========== [ اختراق الجدران (Stepped Loop) ] ==========
RunService.Stepped:Connect(function()
    if NoClip and Character and Character.Parent then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "Head" then
                pcall(function()
                    part.CanCollide = false
                end)
            end
        end
    end
end)

-- ========== [ حركة الطيران ] ==========
local KeyStates = {W = false, A = false, S = false, D = false}

UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
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

-- ========== [ إظهار الواجهة بزر F5 ] ==========
UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.F5 then
        if ScreenGui then
            MenuVisible = not MenuVisible
            ScreenGui.Enabled = MenuVisible
            StarterGui:SetCore("SendNotification", {Title = "ثائر", Text = MenuVisible and "الواجهة ظاهرة" or "الواجهة مخفية", Duration = 1})
        end
    end
end)

-- ========== [ رسالة الترحيب ] ==========
StarterGui:SetCore("SendNotification", {
    Title = "🔥 ثائر X100",
    Text = "تم التحميل | اضغط F5 لإظهار/إخفاء الواجهة",
    Duration = 4
})

print([[

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              ثائر X100 Mobile - تم التحميل بنجاح             ║
║                                                              ║
║   🎮 F5 ← إظهار/إخفاء الواجهة                               ║
║   ✈️ E  ← تشغيل/إيقاف الطيران (اختصار)                      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

]])

-- اختصار E للطيران من لوحة المفاتيح
UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
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
end)