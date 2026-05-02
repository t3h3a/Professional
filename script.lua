--[[
    ═══════════════════════════════════════════════════════════════════════════════
    
                         ████████╗██╗  ██╗ █████╗ ██╗██████╗ 
                         ╚══██╔══╝██║  ██║██╔══██╗██║██╔══██╗
                            ██║   ███████║███████║██║██████╔╝
                            ██║   ██╔══██║██╔══██║██║██╔══██╗
                            ██║   ██║  ██║██║  ██║██║██║  ██║
                            ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
    
    ╔═════════════════════════════════════════════════════════════════════════════╗
    ║                                                                             ║
    ║                      ثائر X100 - الهاكر الأسطوري                            ║
    ║                                                                             ║
    ║   الإصدار: Ultimate Edition                                                 ║
    ║   المطور: Shadow Team                                                        ║
    ║   التوافق: Delta Executor + جميع مابات Roblox                               ║
    ║   المفتاح: thaer2008                                                         ║
    ║                                                                             ║
    ╚═════════════════════════════════════════════════════════════════════════════╝
    
    ═══════════════════════════════════════════════════════════════════════════════
--]]

-- ========== [ الجزء 1: نظام الحماية المتقدم Metatable Hooking ] ==========

local MT = getrawmetatable(game)
local OldIndex = MT.__index
local OldNewIndex = MT.__newindex
setreadonly(MT, false)

-- إخفاء القيم الحقيقية عن كاشفات اللعبة
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

-- منع تغيير القيم من أي مصدر خارجي
MT.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() then
        if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower" or k == "Gravity") then
            return
        end
    end
    OldNewIndex(t, k, v)
end)

setreadonly(MT, true)

-- إخفاء اسم السكربت
pcall(function()
    debug.info = function() end
    script.Name = "SystemCore"
end)

print("🛡️ [ثائر] تم تفعيل Metatable Hooking")

-- ========== [ الجزء 2: Anti-AFK ونظام البقاء في السيرفر ] ==========

local function AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    local GC = game:GetService("GuiService")
    
    spawn(function()
        while wait(45) do
            if not Flying and not NoClip then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    GC.SelectedObject = nil
                end)
            end
        end
    end)
end

-- ========== [ الجزء 3: إعدادات أساسية ومتغيرات ] ==========

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

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
local NoclipConnection = nil

-- حفظ المناطق
local Checkpoint1 = nil
local Checkpoint2 = nil

-- نظام الصوت العالمي
local CurrentSound = nil
local SoundPlaying = false
local SoundVolume = 0.5
local SongId = "3017157406"

-- نظام السرعة الفيزيائي
local SpeedBoostActive = false
local SpeedBoostVelocity = nil

-- نظام KeySystem
local Key = "thaer2008"

-- ========== [ الجزء 4: تحميل Rayfield مع رابط احتياطي ] ==========

local function LoadRayfield()
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    
    if success and result then
        return result
    end
    
    local success2, result2 = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()
    end)
    
    if success2 and result2 then
        return result2
    end
    
    return nil
end

local Rayfield = LoadRayfield()
if not Rayfield then
    warn("Failed to load Rayfield")
end

-- ========== [ الجزء 5: نظام الطيران بالكاميرا ] ==========

local KeyStates = {W = false, A = false, S = false, D = false}

local function UpdateFlight()
    if not Flying or not BodyVelocity then return end
    
    local moveDirection = Vector3.new()
    if KeyStates.W then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
    if KeyStates.S then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
    if KeyStates.A then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
    if KeyStates.D then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
        local cameraCFrame = Camera.CFrame
        local moveVector = (cameraCFrame.LookVector * moveDirection.Z + cameraCFrame.RightVector * moveDirection.X)
        BodyVelocity.Velocity = moveVector * FlySpeed
    else
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

-- تسجيل المدخلات
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
    if Input.KeyCode == FlyKeybind then
        if Flying then StopFly() else StartFly() end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = false end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = false end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = false end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = false end
end)

local function StartFly()
    if Flying then return end
    Flying = true
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    
    RunService.RenderStepped:Connect(function()
        UpdateFlight()
    end)
    
    pcall(function()
        Rayfield:Notify({Title = "✈️ ثائر", Content = "تفعيل الطيران الحر بالكاميرا", Duration = 2, Icon = "✈️"})
    end)
end

local function StopFly()
    if not Flying then return end
    Flying = false
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
end

-- ========== [ الجزء 6: نظام اختراق الجدران المحسن ] ==========

local function StartNoClip()
    if NoClip then return end
    NoClip = true
    
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        if NoClip and Character and Character.Parent then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") and Part.Name ~= "Head" then
                    pcall(function() Part.CanCollide = false end)
                end
            end
        end
    end)
    
    pcall(function()
        Rayfield:Notify({Title = "🧱 ثائر", Content = "تفعيل اختراق الجدران", Duration = 2, Icon = "🧱"})
    end)
end

local function StopNoClip()
    NoClip = false
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    if Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                pcall(function() Part.CanCollide = true end)
            end
        end
    end
end

-- ========== [ الجزء 7: نظام السرعة الفيزيائي BodyVelocity Bypass ] ==========

local function StartSpeedBoost(speed)
    if SpeedBoostActive then
        if SpeedBoostVelocity then SpeedBoostVelocity:Destroy() end
    end
    
    SpeedBoostActive = true
    SpeedBoostVelocity = Instance.new("BodyVelocity")
    
    local randomForce = math.random(80000, 150000)
    SpeedBoostVelocity.MaxForce = Vector3.new(randomForce, randomForce, randomForce)
    SpeedBoostVelocity.Velocity = Vector3.new(0, 0, 0)
    SpeedBoostVelocity.Parent = RootPart
    
    local Keys = {W = false, A = false, S = false, D = false}
    
    UserInputService.InputBegan:Connect(function(Input, GP)
        if GP then return end
        if Input.KeyCode == Enum.KeyCode.W then Keys.W = true end
        if Input.KeyCode == Enum.KeyCode.A then Keys.A = true end
        if Input.KeyCode == Enum.KeyCode.S then Keys.S = true end
        if Input.KeyCode == Enum.KeyCode.D then Keys.D = true end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.KeyCode == Enum.KeyCode.W then Keys.W = false end
        if Input.KeyCode == Enum.KeyCode.A then Keys.A = false end
        if Input.KeyCode == Enum.KeyCode.S then Keys.S = false end
        if Input.KeyCode == Enum.KeyCode.D then Keys.D = false end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not SpeedBoostActive or not SpeedBoostVelocity then return end
        
        local moveDir = Vector3.new()
        if Keys.W then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if Keys.S then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if Keys.A then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if Keys.D then moveDir = moveDir + Vector3.new(1, 0, 0) end
        
        if moveDir.Magnitude > 0 then
            local forward = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            local velocity = (forward * moveDir.Z + right * moveDir.X) * speed
            SpeedBoostVelocity.Velocity = velocity
        else
            SpeedBoostVelocity.Velocity = Vector3.new(0, 0, 0)
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

-- ========== [ الجزء 8: نظام الصوت العالمي ] ==========

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

-- ========== [ الجزء 9: نظام التيليپورت والبحث ] ==========

local function SmoothTeleport(targetCFrame)
    local tween = TweenService:Create(RootPart, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
    tween:Play()
    tween.Completed:Wait()
end

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

-- ========== [ الجزء 10: التعامل التلقائي مع الموت ] ==========

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    wait(0.5)
    if NoClip then StartNoClip() end
    if Flying then StartFly() end
    
    pcall(function()
        Rayfield:Notify({Title = "🔄 ثائر", Content = "تم إعادة الربط تلقائياً", Duration = 2, Icon = "🔄"})
    end)
end)

-- ========== [ الجزء 11: تشغيل Anti-AFK ] ==========
AntiAFK()

-- ========== [ الجزء 12: الواجهة الفخمة Acrylic UI ] ==========

if Rayfield then
    Rayfield:SetConfig({
        SecureMode = true,
        KeySystem = true,
        Key = Key
    })

    local Window = Rayfield:CreateWindow({
        Name = "🔥 ثائر X100 | النواة النارية",
        LoadingTitle = "⚡ ثائر قادم...",
        LoadingSubtitle = "الهاكر الأسطوري",
        Icon = "🔥",
        Theme = "Amethyst",
        Acrylic = true,
        AcrylicColor = Color3.fromRGB(10, 0, 20),
        KeySystem = true,
        KeySettings = {
            Title = "🔐 مفتاح التفعيل - ثائر X100",
            Subtitle = "أدخل المفتاح للدخول إلى النظام",
            Note = "المفتاح: thaer2008",
            Key = Key,
        }
    })

    -- ===== تبويب 1: CENTRAL COMMAND (التحكم المركزي) =====
    local MovementTab = Window:CreateTab("🎮 CENTRAL COMMAND")

    MovementTab:CreateSection("⚡ FLIGHT SYSTEM - الطيران الحر")

    MovementTab:CreateButton({Name = "🔥 تفعيل الطيران", Icon = "✈️", Callback = StartFly})
    MovementTab:CreateButton({Name = "🛑 إيقاف الطيران", Icon = "⭕", Callback = StopFly})

    MovementTab:CreateSlider({
        Name = "⚡ سرعة الطيران", Icon = "📈", Range = {30, 300}, Increment = 5,
        Suffix = "Speed", CurrentValue = 100, Flag = "FlySpeed",
        Callback = function(v) FlySpeed = v end
    })

    MovementTab:CreateKeybind({
        Name = "⌨️ اختصار الطيران", Icon = "🔑", CurrentKeybind = "E", Flag = "FlyKeybind",
        Callback = function(k) FlyKeybind = Enum.KeyCode[k] end
    })

    MovementTab:CreateSection("🧱 WALL HACK - اختراق الجدران")

    MovementTab:CreateButton({Name = "🔥 تفعيل اختراق الجدران", Icon = "🧱", Callback = StartNoClip})
    MovementTab:CreateButton({Name = "🚫 إيقاف اختراق الجدران", Icon = "🔒", Callback = StopNoClip})

    MovementTab:CreateSection("🛡️ SPEED BYPASS - تجاوز السرعة")

    MovementTab:CreateSlider({
        Name = "🚀 سرعة المشي الفيزيائية", Icon = "💨", Range = {20, 250}, Increment = 5,
        Suffix = "Speed", CurrentValue = 50, Flag = "SpeedBoost",
        Callback = StartSpeedBoost
    })

    MovementTab:CreateButton({Name = "🛑 إيقاف سرعة المشي", Icon = "⭕", Callback = StopSpeedBoost})

    -- ===== تبويب 2: AUDIO OVERDRIVE (نظام الأغاني) =====
    local AudioTab = Window:CreateTab("🎵 AUDIO OVERDRIVE")

    AudioTab:CreateSection("🎵 GLOBAL SOUND SYSTEM")

    AudioTab:CreateDropdown({
        Name = "🎵 قائمة الأغاني الجاهزة", Icon = "📀",
        Options = {"🎵 أغنية 1 - ID: 3017157406", "🎵 أغنية 2 - ID: 1843170826", "🎵 أغنية 3 - ID: 9126245770", "🎵 أغنية 4 - ID: 6698976160", "🎵 أغنية 5 - ID: 9032979010"},
        CurrentOption = "🎵 أغنية 1 - ID: 3017157406", Flag = "SongDropdown",
        Callback = function(opt)
            local id = string.match(opt, "ID: (%d+)")
            if id then SongId = id; if SoundPlaying then PlayGlobalSound(SongId, SoundVolume) end end
        end
    })

    AudioTab:CreateInput({
        Name = "🎼 كود أغنية مخصص", Icon = "🎤", PlaceholderText = "أدخل رقم الأغنية...",
        RemoveTextAfterFocusLost = false,
        Callback = function(txt) if txt and txt ~= "" then SongId = txt; if SoundPlaying then PlayGlobalSound(SongId, SoundVolume) end end end
    })

    AudioTab:CreateButton({Name = "🔊 تشغيل الأغنية", Icon = "🎵", Callback = function() PlayGlobalSound(SongId, SoundVolume) end})
    AudioTab:CreateButton({Name = "🔇 إيقاف الأغنية", Icon = "⏹️", Callback = StopGlobalSound})

    AudioTab:CreateSlider({
        Name = "🔊 مستوى الصوت", Icon = "📢", Range = {0, 1}, Increment = 0.05,
        Suffix = "Volume", CurrentValue = 0.5, Flag = "Volume",
        Callback = function(v) SoundVolume = v; if CurrentSound then CurrentSound.Volume = v end end
    })

    -- ===== تبويب 3: TELEPORT STATION (التيليپورت) =====
    local TeleportTab = Window:CreateTab("🌀 TELEPORT STATION")

    TeleportTab:CreateSection("💾 CHECKPOINT SYSTEM")

    TeleportTab:CreateButton({Name = "📍 حفظ المنطقة 1", Icon = "💾", Callback = function() Checkpoint1 = RootPart.CFrame end})
    TeleportTab:CreateButton({Name = "🌀 تيليپورت للمنطقة 1", Icon = "📡", Callback = function() if Checkpoint1 then SmoothTeleport(Checkpoint1) end end})
    TeleportTab:CreateButton({Name = "📍 حفظ المنطقة 2", Icon = "💾", Callback = function() Checkpoint2 = RootPart.CFrame end})
    TeleportTab:CreateButton({Name = "🌀 تيليپورت للمنطقة 2", Icon = "📡", Callback = function() if Checkpoint2 then SmoothTeleport(Checkpoint2) end end})

    -- ===== تبويب 4: PLAYER HUNTER (تعقب اللاعبين) =====
    local PlayersTab = Window:CreateTab("👥 PLAYER HUNTER")
    local CurrentTarget = nil

    PlayersTab:CreateSection("🔍 SEARCH & DESTROY")

    PlayersTab:CreateInput({
        Name = "🎯 ابحث عن لاعب", Icon = "🔍", PlaceholderText = "أدخل أول 3 أحرف من اسم اللاعب...",
        RemoveTextAfterFocusLost = false,
        Callback = function(txt)
            if txt and txt ~= "" then
                CurrentTarget = FindPlayer(txt)
                if CurrentTarget then
                    Rayfield:Notify({Title = "✅ تم العثور", Content = CurrentTarget.Name, Duration = 2, Icon = "✅"})
                else
                    Rayfield:Notify({Title = "❌ خطأ", Content = "لم يتم العثور على لاعب", Duration = 2, Icon = "❌"})
                end
            end
        end
    })

    PlayersTab:CreateButton({Name = "🌀 تيليپورت إلى اللاعب", Icon = "📡", Callback = function() if CurrentTarget and CurrentTarget.Character then SmoothTeleport(CurrentTarget.Character.HumanoidRootPart.CFrame) end end})

    -- ===== تبويب 5: SECURITY PROTOCOL (الأمان) =====
    local SecurityTab = Window:CreateTab("🛡️ SECURITY")

    SecurityTab:CreateSection("🛡️ ANTI-BAN SHIELD")

    SecurityTab:CreateParagraph({
        Title = "🔒 حالة الحماية", Icon = "🛡️",
        Content = [[
╔════════════════════════════════════════╗
║  ✅ Metatable Hooking    : نشط         ║
║  ✅ Secure Mode          : مفعل        ║
║  ✅ Acrylic UI           : مفعل        ║
║  ✅ BodyVelocity Bypass  : نشط         ║
║  ✅ Stepped Noclip       : نشط         ║
║  ✅ Anti-AFK             : نشط         ║
║  ✅ Auto-Reconnect       : نشط         ║
╚════════════════════════════════════════╝
    ]]
    })

    -- ===== تبويب 6: SYSTEM INFO (معلومات) =====
    local InfoTab = Window:CreateTab("ℹ️ SYSTEM INFO")

    InfoTab:CreateParagraph({
        Title = "🔥 ثائر X100", Icon = "⚡",
        Content = [[
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║                     ثائر X100 - الهاكر الأسطوري              ║
║                                                              ║
║   ┌──────────────────────────────────────────────────────┐  ║
║   │  ✈️ طيران بالكاميرا (Camera-Relative Flight)         │  ║
║   │  🧱 اختراق جدران محصن (Stepped Noclip)              │  ║
║   │  🎵 نظام أغاني عالمي (Global Sound System)           │  ║
║   │  💾 حفظ منطقتين (Dual Checkpoints)                  │  ║
║   │  👥 تعقب لاعبين (Player Tracker)                    │  ║
║   │  🛡️ حماية كاملة من الباند (Anti-Ban Shield)         │  ║
║   │  ⚡ سرعة فيزيائية متطورة (BodyVelocity Bypass)      │  ║
║   └──────────────────────────────────────────────────────┘  ║
║                                                              ║
║   ┌──────────────────────────────────────────────────────┐  ║
║   │                    الاختصارات                        │  ║
║   │  🎮 E            → تفعيل/إيقاف الطيران               │  ║
║   │  🎮 Right Ctrl   → إظهار/إخفاء الواجهة               │  ║
║   │  🎮 WASD         → التحريك باتجاه الكاميرا           │  ║
║   └──────────────────────────────────────────────────────┘  ║
║                                                              ║
║   ┌──────────────────────────────────────────────────────┐  ║
║   │                  معلومات السكربت                     │  ║
║   │  👑 المطور: Thaer Team                              │  ║
║   │  📌 الإصدار: X100 Ultimate Edition                   │  ║
║   │  🔑 المفتاح: thaer2008                               │  ║
║   │  🎯 التوافق: Delta Executor + جميع المابات           │  ║
║   └──────────────────────────────────────────────────────┘  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
    ]]
    })

    -- ===== إخفاء/إظهار الواجهة =====
    local UIHidden = false
    UserInputService.InputBegan:Connect(function(Input, GP)
        if GP then return end
        if Input.KeyCode == Enum.KeyCode.RightControl then
            UIHidden = not UIHidden
            pcall(function()
                if UIHidden then Rayfield:Hide() else Rayfield:Show() end
            end)
        end
    end)

    -- ===== رسالة الترحيب =====
    pcall(function()
        Rayfield:Notify({Title = "🔥 ثائر X100", Content = "أهلاً إلى ثائر بلاي | النظام جاهز للاختراق", Duration = 5, Icon = "🔥"})
    end)

end

-- ========== [ نهاية السكربت ] ==========

print([[

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ████████╗██╗  ██╗ █████╗ ██╗██████╗                       ║
║   ╚══██╔══╝██║  ██║██╔══██╗██║██╔══██╗                      ║
║      ██║   ███████║███████║██║██████╔╝                      ║
║      ██║   ██╔══██║██╔══██║██║██╔══██╗                      ║
║      ██║   ██║  ██║██║  ██║██║██║  ██║                      ║
║      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝                      ║
║                                                              ║
║              ثائر X100 - تم التحميل بنجاح                    ║
║                                                              ║
║   🛡️ Metatable Hooking : نشط                                ║
║   🔒 Secure Mode       : مفعل                               ║
║   🎯 المفتاح           : thaer2008                          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

]])