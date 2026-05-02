--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║             ثائر X100 - النسخة المطورة (خفيف جداً)              ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- ========== [ المتغيرات والإعدادات ] ==========
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity = nil
local BodyGyro = nil
local Checkpoint1 = nil

-- نظام الموسيقى (قائمة تشغيل خفيفة)
local MusicIDs = {
    "rbxassetid://1837879075", -- Epic
    "rbxassetid://6015093561", -- Chill
    "rbxassetid://9048375443"  -- Phonk
}
local CurrentMusic = nil
local MusicIndex = 1

-- ========== [ وظائف المساعدة ] ==========
local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

local function ToggleMusic()
    if CurrentMusic then
        CurrentMusic:Stop()
        CurrentMusic:Destroy()
        CurrentMusic = nil
        Notify("الموسيقى", "إيقاف التشغيل")
    else
        CurrentMusic = Instance.new("Sound", game.Workspace)
        CurrentMusic.SoundId = MusicIDs[MusicIndex]
        CurrentMusic.Volume = 0.5
        CurrentMusic.Looped = true
        CurrentMusic:Play()
        Notify("الموسيقى", "تشغيل المقطع رقم " .. MusicIndex)
    end
end

-- ========== [ التحكم ] ==========
local KeyStates = {W = false, A = false, S = false, D = false, Q = false, E = false}

UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    
    -- الطيران المحسن (E)
    if Input.KeyCode == Enum.KeyCode.E then
        Flying = not Flying
        if Flying then
            BodyVelocity = Instance.new("BodyVelocity", RootPart)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro = Instance.new("BodyGyro", RootPart)
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            Notify("ثائر", "الطيران مفعل (WASD)")
        else
            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end
            Notify("ثائر", "الطيران معطل")
        end
    end

    -- اختراق الجدران (X)
    if Input.KeyCode == Enum.KeyCode.X then
        NoClip = not NoClip
        Notify("الحالة", NoClip and "اختراق الجدران مفعل" or "اختراق الجدران معطل")
    end

    -- التحكم بالموسيقى (M) وتغييرها (L)
    if Input.KeyCode == Enum.KeyCode.M then ToggleMusic() end
    if Input.KeyCode == Enum.KeyCode.L then
        MusicIndex = MusicIndex % #MusicIDs + 1
        if CurrentMusic then ToggleMusic() ToggleMusic() end
    end

    -- زيادة السرعة (R) وتقليلها (T)
    if Input.KeyCode == Enum.KeyCode.R then 
        FlySpeed = FlySpeed + 50 
        Notify("السرعة", "السرعة الحالية: " .. FlySpeed)
    end
    if Input.KeyCode == Enum.KeyCode.T then 
        FlySpeed = math.max(10, FlySpeed - 50)
        Notify("السرعة", "السرعة الحالية: " .. FlySpeed)
    end

    -- حفظ الموقع (N) والعودة له (B)
    if Input.KeyCode == Enum.KeyCode.N then 
        Checkpoint1 = RootPart.CFrame 
        Notify("النظام", "تم حفظ الموقع الحالي")
    end
    if Input.KeyCode == Enum.KeyCode.B and Checkpoint1 then 
        RootPart.CFrame = Checkpoint1 
    end

    -- رصد الأزرار للحركة
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = false end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = false end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = false end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = false end
end)

-- ========== [ التحديث المستمر ] ==========
RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity and BodyGyro then
        local moveDir = Vector3.new(0,0,0)
        if KeyStates.W then moveDir = moveDir + Camera.CFrame.LookVector end
        if KeyStates.S then moveDir = moveDir - Camera.CFrame.LookVector end
        if KeyStates.A then moveDir = moveDir - Camera.CFrame.RightVector end
        if KeyStates.D then moveDir = moveDir + Camera.CFrame.RightVector end
        
        BodyVelocity.Velocity = moveDir * FlySpeed
        BodyGyro.CFrame = Camera.CFrame
    end
end)

RunService.Stepped:Connect(function()
    if NoClip and Character then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

Notify("مرحباً ثائر", "تم تشغيل السكربت المطور بنجاح!")