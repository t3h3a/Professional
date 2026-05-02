-- ثائر - النسخة البسيطة التي تعمل 100%
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- متغيرات
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity = nil
local Checkpoint1 = nil
local Checkpoint2 = nil

-- إشعار بدء التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 ثائر",
    Text = "تم التحميل | اضغط E للطيران | X لاختراق الجدران",
    Duration = 5
})

-- ========== الطيران بالكاميرا ==========
local KeyStates = {W = false, A = false, S = false, D = false}

UserInputService.InputBegan:Connect(function(Input, GP)
    if GP then return end
    if Input.KeyCode == Enum.KeyCode.W then KeyStates.W = true end
    if Input.KeyCode == Enum.KeyCode.A then KeyStates.A = true end
    if Input.KeyCode == Enum.KeyCode.S then KeyStates.S = true end
    if Input.KeyCode == Enum.KeyCode.D then KeyStates.D = true end
    
    -- تشغيل/إيقاف الطيران بزر E
    if Input.KeyCode == Enum.KeyCode.E then
        if Flying then
            Flying = false
            if BodyVelocity then BodyVelocity:Destroy() end
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "✈️", Text = "إيقاف الطيران", Duration = 1})
        else
            Flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            BodyVelocity.Parent = RootPart
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "✈️", Text = "تفعيل الطيران", Duration = 1})
        end
    end
    
    -- تشغيل/إيقاف اختراق الجدران بزر X
    if Input.KeyCode == Enum.KeyCode.X then
        NoClip = not NoClip
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🧱", Text = NoClip and "اختراق الجدران مفعل" or "اختراق الجدران معطل", Duration = 1})
    end
    
    -- حفظ المنطقة 1 بزر N
    if Input.KeyCode == Enum.KeyCode.N then
        Checkpoint1 = RootPart.CFrame
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "💾", Text = "تم حفظ المنطقة 1", Duration = 1})
    end
    
    -- حفظ المنطقة 2 بزر M
    if Input.KeyCode == Enum.KeyCode.M then
        Checkpoint2 = RootPart.CFrame
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "💾", Text = "تم حفظ المنطقة 2", Duration = 1})
    end
    
    -- تيليپورت للمنطقة 1 بزر B
    if Input.KeyCode == Enum.KeyCode.B and Checkpoint1 then
        RootPart.CFrame = Checkpoint1 + Vector3.new(0, 3, 0)
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🌀", Text = "تيليپورت للمنطقة 1", Duration = 1})
    end
    
    -- تيليپورت للمنطقة 2 بزر V
    if Input.KeyCode == Enum.KeyCode.V and Checkpoint2 then
        RootPart.CFrame = Checkpoint2 + Vector3.new(0, 3, 0)
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🌀", Text = "تيليپورت للمنطقة 2", Duration = 1})
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

-- اختراق الجدران
RunService.Stepped:Connect(function()
    if NoClip and Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") and Part.Name ~= "Head" then
                pcall(function() Part.CanCollide = false end)
            end
        end
    end
end)

print("🔥 ثائر جاهز | E:طيران | X:جدران | N,M:حفظ | B,V:تيليپورت")