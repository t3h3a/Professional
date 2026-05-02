--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║             ثائر X100 PRO - النسخة الإصلاحية الفخمة            ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- إعدادات
local Flying, NoClip = false, false
local FlySpeed = 100
local BodyVelocity, BodyGyro
local MusicIDs = {"rbxassetid://1837879075", "rbxassetid://6015093561"}
local CurrentMusic, MusicIndex = nil, 1

-- ========== [ الواجهة الرئيسية ] ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaerFixedUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- شعار التصغير
local MinIcon = Instance.new("TextButton")
MinIcon.Size = UDim2.new(0, 55, 0, 55)
MinIcon.Position = UDim2.new(0.05, 0, 0.1, 0)
MinIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MinIcon.Text = "🔥"
MinIcon.TextSize = 30
MinIcon.Visible = false
MinIcon.Parent = ScreenGui
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(1, 0)

-- القائمة الجانبية
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 90, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)

-- حاوية الصفحات
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -100, 1, -10)
PagesContainer.Position = UDim2.new(0, 95, 0, 5)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local function CreatePage()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 0
    f.Visible = false
    f.Parent = PagesContainer
    local layout = Instance.new("UIListLayout", f)
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local MainTab = CreatePage()
local MusicTab = CreatePage()
MainTab.Visible = true

-- ========== [ وظيفة إنشاء الأزرار ] ==========
local function NewButton(parent, text, color, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(func)
    return btn
end

-- زر الطيران
local flyBtn = NewButton(MainTab, "✈️ طيران: إيقاف", Color3.fromRGB(40, 40, 40), function()
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
end)

-- زر الجدران
local noclipBtn = NewButton(MainTab, "🧱 جدران: إيقاف", Color3.fromRGB(40, 40, 40), function()
    NoClip = not NoClip
end)

-- صفحة الموسيقى والسرعة
NewButton(MusicTab, "🎵 تشغيل موسيقى", Color3.fromRGB(70, 0, 150), function()
    if CurrentMusic then CurrentMusic:Stop() CurrentMusic:Destroy() CurrentMusic = nil
    else
        CurrentMusic = Instance.new("Sound", workspace)
        CurrentMusic.SoundId = MusicIDs[MusicIndex]
        CurrentMusic:Play()
    end
end)

NewButton(MusicTab, "⚡ سرعة +50", Color3.fromRGB(180, 120, 0), function()
    FlySpeed = FlySpeed + 50
end)

-- ========== [ التنقل ] ==========
local function TabBtn(text, pos, target)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 50)
    b.Position = UDim2.new(0, 0, 0, pos)
    b.BackgroundTransparency = 1
    b.Text = text
    b.TextColor3 = Color3.white
    b.Font = Enum.Font.GothamBold
    b.Parent = SideBar
    b.MouseButton1Click:Connect(function()
        MainTab.Visible = false
        MusicTab.Visible = false
        target.Visible = true
    end)
end

TabBtn("الرئيسية", 10, MainTab)
TabBtn("المزايا", 60, MusicTab)

-- زر التصغير
local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.TextColor3 = Color3.white
Instance.new("UICorner", Close)

Close.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinIcon.Visible = true
end)

MinIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinIcon.Visible = false
end)

-- ========== [ المحرك ] ==========
RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity and BodyGyro then
        BodyVelocity.Velocity = Camera.CFrame.LookVector * FlySpeed
        BodyGyro.CFrame = Camera.CFrame
    end
    flyBtn.Text = Flying and "✈️ طيران: يعمل" or "✈️ طيران: إيقاف"
    flyBtn.BackgroundColor3 = Flying and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(40, 40, 40)
    noclipBtn.Text = NoClip and "🧱 جدران: يعمل" or "🧱 جدران: إيقاف"
    noclipBtn.BackgroundColor3 = NoClip and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(40, 40, 40)
end)

RunService.Stepped:Connect(function()
    if NoClip and Character then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)