--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║              ثائر X100 | النسخة الشاملة النهائية            ║
    ║                                                              ║
    ║   ✈️ طيران بالكاميرا  |  🧱 اختراق جدران  |  💾 حفظ منطقتين  ║
    ║   🎵 راديو عالمي      |  👥 تعقب لاعبين   |  ⚡ سرعة متغيرة  ║
    ║   🛡️ حماية كاملة     |  🎮 سكربتات جاهزة |  🔑 اختصارات     ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

-- ========== [ تحميل مكتبة Kavo UI ] ==========
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 ثائر X100 | الهاكر الأسطوري", "BloodTheme")

-- ========== [ الخدمات والمتغيرات الأساسية ] ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- متغيرات الطيران
local Flying = false
local FlySpeed = 100
local BodyVelocity = nil
local FlyKeybind = Enum.KeyCode.E

-- متغيرات اختراق الجدران
local NoClip = false
local NoclipConnection = nil

-- حفظ المناطق
local Checkpoint1 = nil
local Checkpoint2 = nil

-- نظام الصوت العالمي
local CurrentSound = nil
local SoundPlaying = false
local SoundVolume = 0.5
local SongId = "3017157406"

-- قائمة الأغاني الجاهزة
local SongsList = {
    "3017157406",  -- أغنية 1
    "1843170826",  -- أغنية 2
    "9126245770",  -- أغنية 3
    "6698976160",  -- أغنية 4
    "9032979010"   -- أغنية 5
}

-- سرعة المشي
local WalkSpeedValue = 16

-- ========== [ دوال مساعدة ] ==========
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
    BodyVelocity.Parent = RootPart
    Notify("✈️ ثائر", "تفعيل الطيران الحر")
end

local function StopFly()
    if not Flying then return end
    Flying = false
    if BodyVelocity then BodyVelocity:Destroy() end
    Notify("✈️ ثائر", "إيقاف الطيران")
end

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
local function StartNoClip()
    if NoClip then return end
    NoClip = true
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        if NoClip and Character then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") and Part.Name ~= "Head" then
                    pcall(function() Part.CanCollide = false end)
                end
            end
        end
    end)
    Notify("🧱 ثائر", "تفعيل اختراق الجدران")
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
    Notify("🧱 ثائر", "إيقاف اختراق الجدران")
end

-- ========== [ نظام حفظ المناطق ] ==========
local function SaveCheckpoint(num)
    if num == 1 then
        Checkpoint1 = RootPart.CFrame
        Notify("💾 ثائر", "تم حفظ المنطقة 1")
    else
        Checkpoint2 = RootPart.CFrame
        Notify("💾 ثائر", "تم حفظ المنطقة 2")
    end
end

local function TeleportToCheckpoint(num)
    if num == 1 and Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 1")
    elseif num == 2 and Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        Notify("🌀 ثائر", "تيليپورت للمنطقة 2")
    else
        Notify("⚠️ ثائر", "لم يتم حفظ المنطقة")
    end
end

-- ========== [ نظام الموسيقى ] ==========
local function PlayGlobalSound(soundId)
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = SoundVolume
    sound.Looped = true
    sound.Parent = RootPart
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

-- ========== [ نظام تعقب اللاعبين ] ==========
local CurrentTarget = nil

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

-- ========== [ نظام السرعة ] ==========
local function SetWalkSpeed(speed)
    WalkSpeedValue = speed
    pcall(function()
        Humanoid.WalkSpeed = speed
    end)
    Notify("⚡ ثائر", "سرعة المشي: " .. speed)
end

local function ResetWalkSpeed()
    SetWalkSpeed(16)
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

-- ========== [ إنشاء الواجهة Kavo UI ] ==========

-- تبويب الحركة
local MovementTab = Window:NewTab("✈️ الحركة")
local MovementSection = MovementTab:NewSection("التحكم بالحركة")

-- سرعة المشي
MovementSection:NewSlider("🚀 سرعة المشي", "ضبط سرعة المشي", 500, 16, function(s)
    SetWalkSpeed(s)
end)

-- زر إعادة ضبط السرعة
MovementSection:NewButton("🔄 إعادة ضبط السرعة", "إعادة السرعة إلى 16", function()
    ResetWalkSpeed()
end)

-- زر الطيران
MovementSection:NewButton("✈️ تشغيل الطيران", "تفعيل وضع الطيران", function()
    StartFly()
end)

-- زر إيقاف الطيران
MovementSection:NewButton("🛑 إيقاف الطيران", "إلغاء وضع الطيران", function()
    StopFly()
end)

-- منزلق سرعة الطيران
MovementSection:NewSlider("⚡ سرعة الطيران", "ضبط سرعة الطيران", 300, 30, function(s)
    FlySpeed = s
end)

-- اختصار الطيران
MovementSection:NewKeybind("⌨️ اختصار الطيران", "تغيير زر تشغيل الطيران", Enum.KeyCode.E, function(key)
    FlyKeybind = key
    Notify("⌨️ ثائر", "اختصار الطيران: " .. tostring(key))
end)

-- زر اختراق الجدران
MovementSection:NewButton("🧱 تشغيل اختراق الجدران", "تفعيل اختراق الجدران", function()
    StartNoClip()
end)

-- زر إيقاف اختراق الجدران
MovementSection:NewButton("🚫 إيقاف اختراق الجدران", "إلغاء اختراق الجدران", function()
    StopNoClip()
end)

-- ========== تبويب حفظ المناطق ==========
local CheckpointTab = Window:NewTab("💾 المناطق")
local CheckpointSection = CheckpointTab:NewSection("حفظ المناطق")

CheckpointSection:NewButton("📍 حفظ المنطقة 1", "حفظ الموقع الحالي كمنطقة 1", function()
    SaveCheckpoint(1)
end)

CheckpointSection:NewButton("🌀 تيليپورت للمنطقة 1", "الانتقال إلى المنطقة 1", function()
    TeleportToCheckpoint(1)
end)

CheckpointSection:NewButton("📍 حفظ المنطقة 2", "حفظ الموقع الحالي كمنطقة 2", function()
    SaveCheckpoint(2)
end)

CheckpointSection:NewButton("🌀 تيليپورت للمنطقة 2", "الانتقال إلى المنطقة 2", function()
    TeleportToCheckpoint(2)
end)

-- ========== تبويب الموسيقى ==========
local MusicTab = Window:NewTab("🎵 الراديو")
local MusicSection = MusicTab:NewSection("الموسيقى العالمية")

-- أزرار الأغاني
for i, songId in ipairs(SongsList) do
    MusicSection:NewButton("🎤 أغنية " .. i, "تشغيل أغنية " .. i, function()
        PlayGlobalSound(songId)
    end)
end

-- صندوق إدخال كود مخصص
MusicSection:NewTextBox("🎼 كود أغنية مخصص", "أدخل رقم الأغنية", function(txt)
    if txt and txt ~= "" then
        PlayGlobalSound(txt)
    end
end)

-- منزلق الصوت
MusicSection:NewSlider("🔊 مستوى الصوت", "ضبط مستوى الصوت", 100, 0, function(s)
    SoundVolume = s / 100
    if CurrentSound then
        CurrentSound.Volume = SoundVolume
    end
end)

-- زر إيقاف الموسيقى
MusicSection:NewButton("🔇 إيقاف الموسيقى", "إيقاف تشغيل الموسيقى", function()
    StopGlobalSound()
end)

-- ========== تبويب تعقب اللاعبين ==========
local PlayersTab = Window:NewTab("👥 اللاعبين")
local PlayersSection = PlayersTab:NewSection("تعقب اللاعبين")

-- صندوق بحث عن لاعب
PlayersSection:NewTextBox("🔍 ابحث عن لاعب", "أدخل أول 3 حروف من اسم اللاعب", function(txt)
    CurrentTarget = FindPlayer(txt)
    if CurrentTarget then
        Notify("✅ ثائر", "تم العثور على: " .. CurrentTarget.Name)
    else
        Notify("❌ ثائر", "لم يتم العثور على لاعب")
    end
end)

-- زر التيليپورت للاعب
PlayersSection:NewButton("🌀 تيليپورت إلى اللاعب", "الانتقال إلى اللاعب المحدد", function()
    if CurrentTarget then
        TeleportToPlayer(CurrentTarget)
    else
        Notify("⚠️ ثائر", "ابحث عن لاعب أولاً")
    end
end)

-- ========== تبويب السكربتات الجاهزة (VR7) ==========
local ScriptsTab = Window:NewTab("📦 سكربتات")
local ScriptsSection = ScriptsTab:NewSection("سكربتات جاهزة")

-- زر أوتو تخطي
ScriptsSection:NewButton("⚡ اوتو تخطي", "تشغيل سكربت التخطي التلقائي", function()
    loadstring(game:HttpGet("https://pastefy.app/ai6KHo37/raw"))()
end)

-- زر Infinite Yield
ScriptsSection:NewButton("👑 Infinite Yield", "تشغيل سكربت الأدمن الوهمي", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- ========== تبويب الأمان ==========
local SecurityTab = Window:NewTab("🛡️ الأمان")
local SecuritySection = SecurityTab:NewSection("الحماية")

SecuritySection:NewButton("🔒 تفعيل الحماية الكاملة", "تفعيل Metatable Hooking", function()
    AntiBan()
end)

-- ========== تبويب المعلومات ==========
local InfoTab = Window:NewTab("ℹ️ معلومات")
local InfoSection = InfoTab:NewSection("عن السكربت")

InfoSection:NewLabel("🔥 ثائر X100")
InfoSection:NewLabel("النسخة: Ultimate Edition")
InfoSection:NewLabel("المطور: Shadow Team")
InfoSection:NewLabel("التوافق: جميع مابات روبلوكس")

-- ========== اختصار إخفاء الواجهة ==========
Library:ToggleUI()

-- ========== رسالة الترحيب ==========
Notify("🔥 ثائر X100", "تم التحميل | جميع الميزات جاهزة | اضغط G لإظهار/إخفاء الواجهة")