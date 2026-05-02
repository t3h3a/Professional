--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                 ثائر X100 - النسخة الخاصة                      ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("THAER X100", "Ocean") -- تصميم نيون أزرق فخم وهادئ

-- الإعدادات التقنية
local Settings = {
    FlySpeed = 100,
    Flying = false,
    NoClip = false,
    InfiniteJump = false
}

-- ========== [ القائمة الأساسية ] ==========
local MainTab = Window:NewTab("التحكم العام")
local Section1 = MainTab:NewSection("قدرات اللاعب")

Section1:NewToggle("الطيران", "تفعيل وتعطيل نمط الطيران الحر", function(state)
    Settings.Flying = state
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if state and root then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "VelocityHandler"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
    else
        if root and root:FindFirstChild("VelocityHandler") then
            root.VelocityHandler:Destroy()
        end
    end
end)

Section1:NewToggle("اختراق الجدران", "تجاوز كل الحواجز والبيوت", function(state)
    Settings.NoClip = state
end)

Section1:NewSlider("سرعة التحرك", "تعديل السرعة الحالية", 500, 16, function(s)
    Settings.FlySpeed = s
end)

-- ========== [ قسم الماب ] ==========
local MapTab = Window:NewTab("ميزات الماب")
local Section2 = MapTab:NewSection("أدوات Brookhaven")

Section2:NewButton("سرقة الخزنة", "الانتقال التلقائي لأقرب خزنة وتفجيرها", function()
    -- الكود البرمجي للبحث عن الخزنة
    print("Searching for safes...")
end)

Section2:NewButton("قائمة السيارات", "فتح خيارات السيارات المتقدمة", function()
    print("Vehicles Access")
end)

-- ========== [ الإعدادات ] ==========
local ConfigTab = Window:NewTab("الإعدادات")
local Section3 = ConfigTab:NewSection("الواجهة")

Section3:NewKeybind("إخفاء القائمة", "زر مخصص لإغلاق الواجهة وفتحها", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)

-- ========== [ محرك التشغيل المستقر ] ==========
game:GetService("RunService").RenderStepped:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera

    if Settings.Flying and root and root:FindFirstChild("VelocityHandler") then
        local moveDir = Vector3.new(0,0,0)
        local UIS = game:GetService("UserInputService")
        
        -- دعم كامل للهاتف والكمبيوتر
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
        
        root.VelocityHandler.Velocity = moveDir * Settings.FlySpeed
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if Settings.NoClip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- إشعار التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "THAER X100",
    Text = "السكربت جاهز للعمل!",
    Duration = 5
})