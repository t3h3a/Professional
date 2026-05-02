--[[
    ═══════════════════════════════════════════════════════════════
    اسم السكربت: ثائر | Thaer - Shadow Edition X100
    التوافق: جميع مابات Roblox + Delta Executor
    المفتاح: thaer2008
    ═══════════════════════════════════════════════════════════════
]]

-- ========== [ الجزء 1: نظام Metatable Hooking - Anti Ban Shield ] ==========
local MT = getrawmetatable(game)
local OldIndex = MT.__index
local OldNewIndex = MT.__newindex
setreadonly(MT, false)

MT.__index = newcclosure(function(t, k)
    if not checkcaller() then
        if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
            if k == "WalkSpeed" then return 16 end
            if k == "JumpPower" then return 50 end
        end
        if t:IsA("Humanoid") and k == "Gravity" then return 196.2 end
    end
    return OldIndex(t, k)
end)

MT.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() then
        if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower" or k == "Gravity") then
            return
        end
    end
    OldNewIndex(t, k, v)
end)

setreadonly(MT, true)

print("🛡️ [ثائر] Metatable Hooking نشط")

-- ========== [ الجزء 2: إعدادات أساسية ] ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- متغيرات الطيران
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity = nil
local FlyKeybind = Enum.KeyCode.E

-- حفظ المناطق
local Checkpoint1 = nil
local Checkpoint2 = nil

-- نظام الصوت العالمي
local CurrentSound = nil
local SoundPlaying = false
local SoundVolume = 0.5
local SongId = "3017157406"

-- نظام KeySystem - المفتاح الجديد
local Key = "thaer2008"

-- ========== [ الجزء 3: نظام الطيران بالكاميرا ] ==========
local KeyStates = {
    W = false, A = false, S = false, D = false
}

local function UpdateFlight()
    if not Flying then return end
    
    local moveDirection = Vector3.new()
    
    if KeyStates.W then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
    if KeyStates.S then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
    if KeyStates.A then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
    if KeyStates.D then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
        
        local cameraCFrame = Camera.CFrame
        local forward = cameraCFrame.LookVector
        local right = cameraCFrame.RightVector
        
        local moveVector = (forward * moveDirection.Z + right * moveDirection.X)
        
        if BodyVelocity then
            BodyVelocity.Velocity = moveVector * FlySpeed
        end
    else
        if BodyVelocity then
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
    if Input.KeyCode == FlyKeybind then
        ToggleFly()
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = false end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = false end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = false end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = false end
end)

local function StartFly()
    if not Flying then
        Flying = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = RootPart
        
        RunService.RenderStepped:Connect(function()
            if Flying then
                UpdateFlight()
            end
        end)
        
        pcall(function()
            Rayfield:Notify({
                Title = "✈️ ثائر",
                Content = "الطيران الحر بالكاميرا مفعل",
                Duration = 2,
                Icon = "✈️"
            })
        end)
    end
end

local function StopFly()
    if Flying then
        Flying = false
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end

function ToggleFly()
    if Flying then StopFly() else StartFly() end
end

-- ========== [ الجزء 4: اختراق الجدران ] ==========
local function StartNoClip()
    NoClip = true
    RunService.Stepped:Connect(function()
        if NoClip and Character and Character.Parent then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") and not checkcaller() then
                    pcall(function()
                        Part.CanCollide = false
                    end)
                end
            end
        end
    end)
end

local function StopNoClip()
    NoClip = false
    if Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                pcall(function()
                    Part.CanCollide = true
                end)
            end
        end
    end
end

-- ========== [ الجزء 5: نظام السرعة الفيزيائي ] ==========
local SpeedBoostActive = false
local SpeedBoostVelocity = nil

local function StartSpeedBoost(speed)
    if SpeedBoostActive then return end
    SpeedBoostActive = true
    
    SpeedBoostVelocity = Instance.new("BodyVelocity")
    SpeedBoostVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    SpeedBoostVelocity.Velocity = Vector3.new(0, 0, 0)
    SpeedBoostVelocity.Parent = RootPart
    
    local Keys = {W = false, A = false, S = false, D = false}
    
    local conn1 = UserInputService.InputBegan:Connect(function(Input, GP)
        if GP then return end
        if Input.KeyCode == Enum.KeyCode.W then Keys.W = true end
        if Input.KeyCode == Enum.KeyCode.A then Keys.A = true end
        if Input.KeyCode == Enum.KeyCode.S then Keys.S = true end
        if Input.KeyCode == Enum.KeyCode.D then Keys.D = true end
    end)
    
    local conn2 = UserInputService.InputEnded:Connect(function(Input)
        if Input.KeyCode == Enum.KeyCode.W then Keys.W = false end
        if Input.KeyCode == Enum.KeyCode.A then Keys.A = false end
        if Input.KeyCode == Enum.KeyCode.S then Keys.S = false end
        if Input.KeyCode == Enum.KeyCode.D then Keys.D = false end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not SpeedBoostActive then return end
        
        local moveDir = Vector3.new()
        if Keys.W then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if Keys.S then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if Keys.A then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if Keys.D then moveDir = moveDir + Vector3.new(1, 0, 0) end
        
        if moveDir.Magnitude > 0 then
            local forward = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            local velocity = (forward * moveDir.Z + right * moveDir.X) * speed
            if SpeedBoostVelocity then
                SpeedBoostVelocity.Velocity = velocity
            end
        else
            if SpeedBoostVelocity then
                SpeedBoostVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function StopSpeedBoost()
    SpeedBoostActive = false
    if SpeedBoostVelocity then
        SpeedBoostVelocity:Destroy()
        SpeedBoostVelocity = nil
    end
end

-- ========== [ الجزء 6: نظام الصوت العالمي ] ==========
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
    
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        sound.Parent = Character.HumanoidRootPart
    else
        sound.Parent = RootPart
    end
    
    sound:Play()
    CurrentSound = sound
    SoundPlaying = true
    
    return sound
end

local function StopGlobalSound()
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil
    end
    SoundPlaying = false
end

local function SetSoundVolume(volume)
    SoundVolume = volume
    if CurrentSound then
        CurrentSound.Volume = volume
    end
end

-- ========== [ الجزء 7: البحث عن اللاعبين ] ==========
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

local function SmoothTeleport(targetCFrame)
    local tween = TweenService:Create(RootPart, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
    tween:Play()
    tween.Completed:Wait()
end

-- ========== [ الجزء 8: تحميل Rayfield ] ==========
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:SetConfig({
    SecureMode = true,
    KeySystem = true,
    Key = Key
})

-- ========== [ الجزء 9: الواجهة ] ==========
local Window = Rayfield:CreateWindow({
    Name = "🔥 ثائر X100 | النواة النارية",
    LoadingTitle = "ثائر قادم...",
    LoadingSubtitle = "الهاكر الأسطوري",
    Icon = "🔥",
    Theme = "Amethyst",
    Acrylic = true,
    AcrylicColor = Color3.fromRGB(10, 0, 20),
    KeySystem = true,
    KeySettings = {
        Title = "مفتاح التفعيل - ثائر X100",
        Subtitle = "أدخل المفتاح للدخول إلى النظام",
        Note = "المفتاح: thaer2008",
        Key = Key,
    }
})

-- ========== [ تبويب 1: الطيران والسرعة ] ==========
local MovementTab = Window:CreateTab("🎮 CENTRAL COMMAND")

MovementTab:CreateSection("⚡ FLIGHT SYSTEM")

MovementTab:CreateButton({
    Name = "🔥 تفعيل الطيران الحر",
    Icon = "✈️",
    Callback = function()
        StartFly()
    end
})

MovementTab:CreateButton({
    Name = "🛑 إيقاف الطيران",
    Icon = "⭕",
    Callback = function()
        StopFly()
    end
})

MovementTab:CreateSlider({
    Name = "⚡ سرعة الطيران",
    Icon = "📈",
    Range = {30, 300},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 100,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end
})

MovementTab:CreateKeybind({
    Name = "⌨️ اختصار الطيران",
    Icon = "🔑",
    CurrentKeybind = "E",
    Flag = "FlyKeybind",
    Callback = function(Key)
        FlyKeybind = Enum.KeyCode[Key]
    end
})

MovementTab:CreateSection("🧱 WALL HACK")

MovementTab:CreateButton({
    Name = "🔥 تفعيل اختراق الجدران",
    Icon = "🧱",
    Callback = function()
        StartNoClip()
    end
})

MovementTab:CreateButton({
    Name = "🚫 إيقاف اختراق الجدران",
    Icon = "🔒",
    Callback = function()
        StopNoClip()
    end
})

MovementTab:CreateSection("🛡️ SPEED BYPASS")

MovementTab:CreateSlider({
    Name = "🚀 ضبط سرعة المشي",
    Icon = "💨",
    Range = {20, 250},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "SpeedBoost",
    Callback = function(Value)
        StartSpeedBoost(Value)
    end
})

MovementTab:CreateButton({
    Name = "🛑 إيقاف سرعة المشي",
    Icon = "⭕",
    Callback = function()
        StopSpeedBoost()
    end
})

-- ========== [ تبويب 2: الأغاني ] ==========
local AudioTab = Window:CreateTab("🎵 AUDIO OVERDRIVE")

AudioTab:CreateSection("🎵 GLOBAL SOUND SYSTEM")

AudioTab:CreateDropdown({
    Name = "🎵 قائمة الأغاني الجاهزة",
    Icon = "📀",
    Options = {
        "الاغنية 1 - ID: 3017157406",
        "الاغنية 2 - ID: 1843170826", 
        "الاغنية 3 - ID: 9126245770",
        "الاغنية 4 - ID: 6698976160",
        "الاغنية 5 - ID: 9032979010"
    },
    CurrentOption = "الاغنية 1 - ID: 3017157406",
    Flag = "SongDropdown",
    Callback = function(Option)
        local id = string.match(Option, "ID: (%d+)")
        if id then
            SongId = id
            if SoundPlaying then
                PlayGlobalSound(SongId, SoundVolume)
            end
        end
    end
})

AudioTab:CreateInput({
    Name = "🎼 كود أغنية مخصص",
    Icon = "🎤",
    PlaceholderText = "أدخل رقم الأغنية...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            SongId = Text
            if SoundPlaying then
                PlayGlobalSound(SongId, SoundVolume)
            end
        end
    end
})

AudioTab:CreateButton({
    Name = "🔊 تشغيل الأغنية",
    Icon = "🎵",
    Callback = function()
        PlayGlobalSound(SongId, SoundVolume)
    end
})

AudioTab:CreateButton({
    Name = "🔇 إيقاف الأغنية",
    Icon = "⏹️",
    Callback = function()
        StopGlobalSound()
    end
})

AudioTab:CreateSlider({
    Name = "🔊 مستوى الصوت",
    Icon = "📢",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "Volume",
    CurrentValue = 0.5,
    Flag = "Volume",
    Callback = function(Value)
        SetSoundVolume(Value)
    end
})

-- ========== [ تبويب 3: التيليپورت ] ==========
local TeleportTab = Window:CreateTab("🌀 TELEPORT STATION")

TeleportTab:CreateSection("💾 CHECKPOINT SYSTEM")

TeleportTab:CreateButton({
    Name = "📍 حفظ المنطقة 1",
    Icon = "💾",
    Callback = function()
        Checkpoint1 = RootPart.CFrame
    end
})

TeleportTab:CreateButton({
    Name = "🌀 تيليپورت للمنطقة 1",
    Icon = "📡",
    Callback = function()
        if Checkpoint1 then
            SmoothTeleport(Checkpoint1)
        end
    end
})

TeleportTab:CreateButton({
    Name = "📍 حفظ المنطقة 2",
    Icon = "💾",
    Callback = function()
        Checkpoint2 = RootPart.CFrame
    end
})

TeleportTab:CreateButton({
    Name = "🌀 تيليپورت للمنطقة 2",
    Icon = "📡",
    Callback = function()
        if Checkpoint2 then
            SmoothTeleport(Checkpoint2)
        end
    end
})

-- ========== [ تبويب 4: تعقب اللاعبين ] ==========
local PlayersTab = Window:CreateTab("👥 PLAYER HUNTER")

PlayersTab:CreateSection("🔍 SEARCH & DESTROY")

local CurrentTarget = nil

PlayersTab:CreateInput({
    Name = "🎯 ابحث عن لاعب",
    Icon = "🔍",
    PlaceholderText = "أدخل أول 3 أحرف...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            CurrentTarget = FindPlayer(Text)
        end
    end
})

PlayersTab:CreateButton({
    Name = "🌀 تيليپورت إلى اللاعب",
    Icon = "📡",
    Callback = function()
        if CurrentTarget and CurrentTarget.Character then
            SmoothTeleport(CurrentTarget.Character.HumanoidRootPart.CFrame)
        end
    end
})

-- ========== [ تبويب 5: الأمان ] ==========
local SecurityTab = Window:CreateTab("🛡️ SECURITY")

SecurityTab:CreateSection("🛡️ ANTI-BAN SHIELD")

SecurityTab:CreateParagraph({
    Title = "🔒 حالة الحماية",
    Icon = "🛡️",
    Content = [[
╔══════════════════════════════╗
║  ✅ Metatable Hooking: نشط   ║
║  ✅ Secure Mode: مفعل        ║
║  ✅ Acrylic UI: مفعل         ║
║  ✅ BodyVelocity Bypass: نشط ║
║  ✅ Stepped Noclip: نشط      ║
╚══════════════════════════════╝
    ]]
})

SecurityTab:CreateButton({
    Name = "🔄 إعادة ربط السكربت",
    Icon = "🔄",
    Callback = function()
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            Character = newChar
            Humanoid = Character:WaitForChild("Humanoid")
            RootPart = Character:WaitForChild("HumanoidRootPart")
        end)
    end
})

-- ========== [ تبويب 6: المعلومات ] ==========
local InfoTab = Window:CreateTab("ℹ️ SYSTEM INFO")

InfoTab:CreateParagraph({
    Title = "🔥 ثائر X100",
    Icon = "⚡",
    Content = [[
╔════════════════════════════════════════╗
║                                        ║
║     ثائر - الهاكر الأسطوري             ║
║     الإصدار: X100                      ║
║     المفتاح: thaer2008                 ║
║                                        ║
╠════════════════════════════════════════╣
║                                        ║
║  ✈️ طيران بالكاميرا                     ║
║  🧱 اختراق جدران                        ║
║  🎵 نظام أغاني عالمي                     ║
║  💾 حفظ منطقتين                         ║
║  👥 تعقب لاعبين                         ║
║  🛡️ حماية كاملة                         ║
║                                        ║
╠════════════════════════════════════════╣
║                                        ║
║  🎮 الاختصارات:                         ║
║     • E → الطيران                      ║
║     • Right Ctrl → إخفاء الواجهة       ║
║                                        ║
╚════════════════════════════════════════╝
    ]]
})

-- ========== [ إخفاء/إظهار الواجهة ] ==========
local UIHidden = false
UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.RightControl then
        UIHidden = not UIHidden
        pcall(function()
            if UIHidden then
                Rayfield:Hide()
            else
                Rayfield:Show()
            end
        end)
    end
end)

-- ========== [ رسالة الترحيب ] ==========
pcall(function()
    Rayfield:Notify({
        Title = "🔥 ثائر X100",
        Content = "أهلاً إلى ثائر بلاي | المفتاح: thaer2008",
        Duration = 5,
        Icon = "🔥"
    })
end)

print("🔥 ثائر X100 - تم التحميل بنجاح | المفتاح: thaer2008")