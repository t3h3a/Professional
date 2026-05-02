--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║             ثائر X100 PRO - النسخة النهائية المدمجة            ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- ========== المتغيرات الأساسية ==========
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity = nil
local Checkpoint1, Checkpoint2 = nil, nil
local MusicIDs = {"rbxassetid://1837879075", "rbxassetid://6015093561", "rbxassetid://9048375443"}
local CurrentMusic, MusicIndex = nil, 1

-- ========== إنشاء الواجهة الفخمة (بنفس منطق الكود الشغال) ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerFinalUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- اللوحة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 280)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 15)

-- شعار التصغير الذكي
local MinIcon = Instance.new("TextButton")
MinIcon.Size = UDim2.new(0, 50, 0, 50)
MinIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
MinIcon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MinIcon.Text = "🔥"
MinIcon.TextSize = 25
MinIcon.Visible = false
MinIcon.Parent = ScreenGui
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(1, 0)

-- وظيفة إنشاء الأزرار الفخمة
local function CreateBtn(text, pos, color, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(func)
    return btn
end

-- الأزرار
local flyBtn = CreateBtn("✈️ طيران: مغلق", 45, Color3.fromRGB(40, 40, 40), function()
    Flying = not Flying
    if Flying then
        BodyVelocity = Instance.new("BodyVelocity", RootPart)
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    else
        if BodyVelocity then BodyVelocity:Destroy() end
    end
end)

local noclipBtn = CreateBtn("🧱 جدران: مغلق", 90, Color3.fromRGB(40, 40, 40), function()
    NoClip = not NoClip
end)

CreateBtn("🎵 تشغيل الموسيقى", 135, Color3.fromRGB(70, 0, 150), function()
    if CurrentMusic then CurrentMusic:Stop() CurrentMusic:Destroy() CurrentMusic = nil
    else
        CurrentMusic = Instance.new("Sound", workspace)
        CurrentMusic.SoundId = MusicIDs[MusicIndex]
        CurrentMusic:Play()
    end
end)

CreateBtn("⚡ سرعة +50", 180, Color3.fromRGB(150, 100, 0), function()
    FlySpeed = FlySpeed + 50
    StarterGui:SetCore("SendNotification", {Title = "السرعة", Text = "السرعة: "..FlySpeed, Duration = 2})
end)

CreateBtn("❌ تصغير الواجهة", 225, Color3.fromRGB(200, 0, 0), function()
    MainFrame.Visible = false
    MinIcon.Visible = true
end)

MinIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinIcon.Visible = false
end)

-- ========== محرك الحركة (نفس كودك الشغال تماماً) ==========
local KeyStates = {W = false, A = false, S = false, D = false}

RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity then
        local moveDir = Vector3.new()
        if KeyStates.W or UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if KeyStates.S or UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if KeyStates.A or UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if KeyStates.D or UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
        
        local moveVector = (Camera.CFrame.LookVector * moveDir.Z + Camera.CFrame.RightVector * moveDir.X)
        BodyVelocity.Velocity = (moveDir.Magnitude > 0 and moveVector.Unit * FlySpeed or Vector3.new(0, 0, 0))
    end
    
    -- تحديث شكل الأزرار
    flyBtn.Text = Flying and "✈️ طيران: يعمل" or "✈️ طيران: مغلق"
    flyBtn.BackgroundColor3 = Flying and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    noclipBtn.Text = NoClip and "🧱 جدران: يعمل" or "🧱 جدران: مغلق"
    noclipBtn.BackgroundColor3 = NoClip and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

-- محرك اختراق الجدران (نفس كودك الشغال)
RunService.Stepped:Connect(function()
    if NoClip and Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                pcall(function() Part.CanCollide = false end)
            end
        end
    end
end)

StarterGui:SetCore("SendNotification", {Title = "🔥 ثائر PRO", Text = "الواجهة جاهزة للعمل!", Duration = 5})