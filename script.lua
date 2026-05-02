--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║             ثائر X100 PRO - النسخة الفخمة والمطورة             ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- إعدادات
local Flying = false
local NoClip = false
local FlySpeed = 100
local BodyVelocity, BodyGyro
local MusicIDs = {"rbxassetid://1837879075", "rbxassetid://6015093561", "rbxassetid://9048375443"}
local CurrentMusic, MusicIndex = nil, 1

-- ========== [ إنشاء الواجهة الفخمة ] ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerProUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- شعار التصغير (الشعار الصغير)
local MinIcon = Instance.new("TextButton")
MinIcon.Size = UDim2.new(0, 50, 0, 50)
MinIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
MinIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinIcon.Text = "🔥"
MinIcon.TextSize = 25
MinIcon.Visible = false
MinIcon.Parent = ScreenGui
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = MinIcon

-- اللوحة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame

-- القائمة الجانبية (Tabs)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 80, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.Parent = MainFrame

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -90, 1, -40)
Pages.Position = UDim2.new(0, 85, 0, 35)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

-- نظام الصفحات
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    page.Parent = Pages
    return page
end

local MainTab = CreatePage("Main")
local MusicTab = CreatePage("Music")
MainTab.Visible = true

-- ========== [ أزرار التحكم ] ==========

local function CreateToggle(parent, text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.white
    btn.Parent = parent
    Instance.new("UICorner").Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.BackgroundColor3 = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

-- صفحة الرئيسية
CreateToggle(MainTab, "✈️ تشغيل الطيران", 0, function()
    Flying = not Flying
    if Flying then
        BodyVelocity = Instance.new("BodyVelocity", RootPart)
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro = Instance.new("BodyGyro", RootPart)
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    else
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end
    return Flying
end)

CreateToggle(MainTab, "🧱 اختراق الجدران", 45, function()
    NoClip = not NoClip
    return NoClip
end)

-- صفحة الموسيقى والسرعة
CreateToggle(MusicTab, "🎵 تشغيل/إيقاف الموسيقى", 0, function()
    if CurrentMusic then 
        CurrentMusic:Stop() CurrentMusic:Destroy() CurrentMusic = nil 
        return false
    else
        CurrentMusic = Instance.new("Sound", workspace)
        CurrentMusic.SoundId = MusicIDs[MusicIndex]
        CurrentMusic:Play()
        return true
    end
end)

CreateToggle(MusicTab, "⚡ زيادة السرعة (+50)", 45, function()
    FlySpeed = FlySpeed + 50
    return true
end)

-- ========== [ التنقل والإخفاء ] ==========

local function TabBtn(text, pos, target)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, pos)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.white
    btn.Parent = SideBar
    btn.MouseButton1Click:Connect(function()
        MainTab.Visible = false
        MusicTab.Visible = false
        target.Visible = true
    end)
end

TabBtn("الرئيسية", 0, MainTab)
TabBtn("الموسيقى", 40, MusicTab)

-- زر التصغير (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "—"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Parent = MainFrame
Instance.new("UICorner").Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinIcon.Visible = true
end)

MinIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinIcon.Visible = false
end)

-- ========== [ تشغيل العمليات ] ==========

RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity and BodyGyro then
        BodyVelocity.Velocity = Camera.CFrame.LookVector * FlySpeed
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

print("🔥 تم تشغيل ثائر X100 PRO بنجاح!")