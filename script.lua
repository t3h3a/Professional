--[[
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║          ██████╗ ██████╗  ██████╗     ██╗  ██╗ ██╗ ██████╗      ║
║          ██╔══██╗██╔══██╗██╔═══██╗   ╚██╗██╔╝███║██╔═████╗     ║
║          ██████╔╝██████╔╝██║   ██║    ╚███╔╝ ╚██║██║██╔██║     ║
║          ██╔═══╝ ██╔══██╗██║   ██║    ██╔██╗  ██║████╔╝██║     ║
║          ██║     ██║  ██║╚██████╔╝   ██╔╝ ██╗ ██║╚██████╔╝     ║
║          ╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝  ╚═╝ ╚═╝ ╚═════╝      ║
║                                                                  ║
║           ✈ طيران   🧱 جدران   📍 مناطق   🎵 موسيقى            ║
║           👥 تعقب   ⚡ سرعة    🛡️ حماية   📱 جوال              ║
║                                                                  ║
║                 جميع الحقوق محفوظة © PRO X100                   ║
╚══════════════════════════════════════════════════════════════════╝
]]

-- ════════════════════════════════════════════
--              الخدمات الأساسية
-- ════════════════════════════════════════════
local Players          = game:GetService("Players")
local UIS              = game:GetService("UserInputService")
local RS               = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local StarterGui       = game:GetService("StarterGui")
local CoreGui          = game:GetService("CoreGui")

local LP               = Players.LocalPlayer
local Cam              = workspace.CurrentCamera
local Char             = LP.Character or LP.CharacterAdded:Wait()
local Hum              = Char:WaitForChild("Humanoid")
local Root             = Char:WaitForChild("HumanoidRootPart")

-- ════════════════════════════════════════════
--               الثيم / الألوان
-- ════════════════════════════════════════════
local C = {
    BG          = Color3.fromRGB(8,  8,  16),
    Surface     = Color3.fromRGB(14, 14, 26),
    SurfaceAlt  = Color3.fromRGB(22, 22, 38),
    Sidebar     = Color3.fromRGB(10, 12, 30),
    Accent      = Color3.fromRGB(80, 120, 255),
    AccentDark  = Color3.fromRGB(50,  80, 200),
    AccentGlow  = Color3.fromRGB(120,160, 255),
    Green       = Color3.fromRGB(60, 210, 130),
    Red         = Color3.fromRGB(255, 70,  90),
    Yellow      = Color3.fromRGB(255,185,  50),
    Text        = Color3.fromRGB(230,230,245),
    TextSub     = Color3.fromRGB(140,140,170),
    TextMuted   = Color3.fromRGB(70,  70, 100),
    White       = Color3.fromRGB(255,255,255),
    Track       = Color3.fromRGB(30,  30,  55),
}

local TI = {
    Fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad),
    Spring = TweenInfo.new(0.30, Enum.EasingStyle.Back),
}

-- ════════════════════════════════════════════
--                 المتغيرات
-- ════════════════════════════════════════════
local Flying        = false
local NoClip        = false
local FlySpeed      = 100
local BV, BG_Gyro   = nil, nil
local Checkpoints   = {nil, nil, nil}
local CurrentTarget = nil
local WalkSpd       = 16
local JumpPow       = 50
local CurrentSound  = nil
local SoundVol      = 0.5
local UIHidden      = false
local Keys          = {W=false,A=false,S=false,D=false}

-- ════════════════════════════════════════════
--              نظام الإشعارات
-- ════════════════════════════════════════════
local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification",{
            Title = title, Text = text, Duration = dur or 3
        })
    end)
end

-- ════════════════════════════════════════════
--              نظام الحماية (AntiBan)
-- ════════════════════════════════════════════
local function AntiBan()
    pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if not checkcaller() then
                if t:IsA("Humanoid") then
                    if k == "WalkSpeed"  then return WalkSpd  end
                    if k == "JumpPower"  then return JumpPow   end
                end
            end
            return old(t, k)
        end)
        setreadonly(mt, true)
        Notify("🛡️ PRO X100", "تم تفعيل الحماية")
    end)
end
AntiBan()

-- ════════════════════════════════════════════
--          نظام الطيران (Flight System)
-- ════════════════════════════════════════════
local function StartFly()
    if Flying then return end
    Flying = true
    Cam = workspace.CurrentCamera

    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1e5,1e5,1e5)
    BV.Velocity  = Vector3.zero
    BV.Parent    = Root

    BG_Gyro = Instance.new("BodyGyro")
    BG_Gyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    BG_Gyro.P = 15000
    BG_Gyro.CFrame = Root.CFrame
    BG_Gyro.Parent = Root

    Hum.PlatformStand = false
    Hum.AutoRotate    = false
    pcall(function() Hum:ChangeState(Enum.HumanoidStateType.Freefall) end)
    Notify("✈️ طيران", "مفعّل | WASD للحركة | Shift للتسريع")
end

local function StopFly()
    if not Flying then return end
    Flying = false
    if BV      then BV:Destroy();     BV      = nil end
    if BG_Gyro then BG_Gyro:Destroy(); BG_Gyro = nil end
    Hum.PlatformStand = false
    Hum.AutoRotate    = true
    Notify("✈️ طيران", "إيقاف")
end

RS.RenderStepped:Connect(function()
    if not Flying or not BV then return end
    Cam = workspace.CurrentCamera
    local cf  = Cam.CFrame
    local dir = Vector3.zero
    if Keys.W then dir += cf.LookVector  end
    if Keys.S then dir -= cf.LookVector  end
    if Keys.D then dir += cf.RightVector end
    if Keys.A then dir -= cf.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space)       then dir += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
    local boost = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 2.4 or 1
    BV.Velocity = (dir.Magnitude > 0) and (dir.Unit * FlySpeed * boost) or Vector3.zero
    if BG_Gyro then BG_Gyro.CFrame = cf end
end)

-- ════════════════════════════════════════════
--         نظام اختراق الجدران (NoClip)
-- ════════════════════════════════════════════
RS.Stepped:Connect(function()
    if not NoClip then return end
    local c = LP.Character
    if not c then return end
    for _, p in c:GetDescendants() do
        if p:IsA("BasePart") then
            pcall(function() p.CanCollide = false end)
        end
    end
end)

-- ════════════════════════════════════════════
--               نقاط الإحداثيات
-- ════════════════════════════════════════════
local function SaveCP(i)
    Checkpoints[i] = Root.CFrame
    Notify("📍 منطقة "..i, "تم الحفظ ✅")
end

local function LoadCP(i)
    if Checkpoints[i] then
        Root.CFrame = Checkpoints[i] + Vector3.new(0,3,0)
        Notify("🌀 منطقة "..i, "تم الانتقال 🚀")
    else
        Notify("⚠️ منطقة "..i, "لم يتم الحفظ بعد")
    end
end

-- ════════════════════════════════════════════
--           نظام تعقب اللاعبين
-- ════════════════════════════════════════════
local function FindPlayer(partial)
    if not partial or partial == "" then return nil end
    local low = partial:lower()
    for _, p in Players:GetPlayers() do
        if p ~= LP then
            if p.Name:lower():sub(1,#low) == low or
               p.DisplayName:lower():sub(1,#low) == low then
                return p
            end
        end
    end
    for _, p in Players:GetPlayers() do
        if p ~= LP then
            if p.Name:lower():find(low,1,true) then return p end
        end
    end
    return nil
end

local function TeleportToPlayer(p)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        Root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0)
        Notify("🎯 تيليپورت", "→ "..p.Name)
    else
        Notify("⚠️ خطأ", "اللاعب غير موجود")
    end
end

-- ════════════════════════════════════════════
--             نظام الموسيقى
-- ════════════════════════════════════════════
local function PlaySound(id)
    if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy() end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..tostring(id)
    s.Volume = SoundVol
    s.Looped = true
    s.Parent = Root
    s:Play()
    CurrentSound = s
    Notify("🎵 موسيقى", "تشغيل ID: "..tostring(id))
end

local function StopSound()
    if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy(); CurrentSound = nil end
    Notify("🔇 موسيقى", "إيقاف")
end

-- ════════════════════════════════════════════
--           السرعة والقفز
-- ════════════════════════════════════════════
local function SetWalk(v)
    WalkSpd = v
    pcall(function() Hum.WalkSpeed = v end)
end

local function SetJump(v)
    JumpPow = v
    pcall(function() Hum.JumpPower = v; Hum.UseJumpPower = true end)
end

-- إعادة التطبيق عند البعث
LP.CharacterAdded:Connect(function(c)
    Char = c
    Hum  = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
    Cam  = workspace.CurrentCamera
    SetWalk(WalkSpd); SetJump(JumpPow)
    if Flying then
        if BV      then BV:Destroy();     BV      = nil end
        if BG_Gyro then BG_Gyro:Destroy(); BG_Gyro = nil end
        Flying = false
        task.wait(0.5)
        StartFly()
    end
end)

-- مدخلات لوحة المفاتيح
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local k = inp.KeyCode
    if k == Enum.KeyCode.W then Keys.W = true
    elseif k == Enum.KeyCode.A then Keys.A = true
    elseif k == Enum.KeyCode.S then Keys.S = true
    elseif k == Enum.KeyCode.D then Keys.D = true
    elseif k == Enum.KeyCode.E then if Flying then StopFly() else StartFly() end
    elseif k == Enum.KeyCode.X then
        NoClip = not NoClip
        Notify("🧱 جدران", NoClip and "مفعّل" or "إيقاف")
    elseif k == Enum.KeyCode.N then SaveCP(1)
    elseif k == Enum.KeyCode.M then SaveCP(2)
    elseif k == Enum.KeyCode.K then SaveCP(3)
    elseif k == Enum.KeyCode.B then LoadCP(1)
    elseif k == Enum.KeyCode.V then LoadCP(2)
    elseif k == Enum.KeyCode.J then LoadCP(3)
    elseif k == Enum.KeyCode.C then FlySpeed = math.min(500, FlySpeed+25); Notify("⚡","سرعة: "..FlySpeed)
    elseif k == Enum.KeyCode.Z then FlySpeed = math.max(30,  FlySpeed-25); Notify("⚡","سرعة: "..FlySpeed)
    end
end)
UIS.InputEnded:Connect(function(inp)
    local k = inp.KeyCode
    if k==Enum.KeyCode.W then Keys.W=false
    elseif k==Enum.KeyCode.A then Keys.A=false
    elseif k==Enum.KeyCode.S then Keys.S=false
    elseif k==Enum.KeyCode.D then Keys.D=false end
end)

-- ════════════════════════════════════════════════════════════════
--
--                    بناء الواجهة الاحترافية
--
-- ════════════════════════════════════════════════════════════════

-- ── مساعدات UI ──────────────────────────────────────────────────
local function Corner(r, p)
    local c = Instance.new("UICorner"); c.CornerRadius = r; c.Parent = p; return c
end
local function Stroke(col, th, tr, p)
    local s = Instance.new("UIStroke")
    s.Color = col; s.Thickness = th; s.Transparency = tr; s.Parent = p; return s
end
local function Gradient(seq, rot, p)
    local g = Instance.new("UIGradient"); g.Color = seq; g.Rotation = rot; g.Parent = p; return g
end
local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

-- ── ScreenGui ───────────────────────────────────────────────────
local GUI = Instance.new("ScreenGui")
GUI.Name            = "PRO_X100"
GUI.ResetOnSpawn    = false
GUI.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder    = 99
GUI.Parent          = CoreGui

-- ════════════════════════════════════════════
--           أيقونة التصغير (Mini Icon)
-- ════════════════════════════════════════════
local Mini = Instance.new("TextButton")
Mini.Name              = "MiniIcon"
Mini.Size              = UDim2.new(0, 52, 0, 52)
Mini.Position          = UDim2.new(1, -68, 0.72, 0)
Mini.BackgroundColor3  = C.Accent
Mini.Text              = "⚙"
Mini.TextSize          = 24
Mini.TextColor3        = C.White
Mini.Font              = Enum.Font.GothamBold
Mini.Visible           = false
Mini.ZIndex            = 50
Mini.Active            = true
Mini.Parent            = GUI
Corner(UDim.new(1,0), Mini)
Stroke(C.AccentGlow, 2, 0.5, Mini)
Gradient(ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,160,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 200)),
}), 135, Mini)

-- سحب الأيقونة
local mDrag, mMoved, mOffset, mStart = false, false, Vector2.zero, Vector2.zero
Mini.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mDrag = true; mMoved = false
        mStart  = Vector2.new(i.Position.X, i.Position.Y)
        mOffset = Vector2.new(i.Position.X - Mini.AbsolutePosition.X, i.Position.Y - Mini.AbsolutePosition.Y)
    end
end)
UIS.InputChanged:Connect(function(i)
    if mDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local vp = workspace.CurrentCamera.ViewportSize
        local sz = Mini.AbsoluteSize
        local x  = math.clamp(i.Position.X - mOffset.X, 0, vp.X - sz.X)
        local y  = math.clamp(i.Position.Y - mOffset.Y, 0, vp.Y - sz.Y)
        Mini.Position = UDim2.fromOffset(x, y)
        mMoved = (Vector2.new(i.Position.X, i.Position.Y) - mStart).Magnitude > 6
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mDrag = false
    end
end)

-- ════════════════════════════════════════════
--         اللوحة الرئيسية (Main Frame)
-- ════════════════════════════════════════════
local Panel = Instance.new("Frame")
Panel.Name             = "Panel"
Panel.Size             = UDim2.new(0, 500, 0, 290)
Panel.Position         = UDim2.new(0.5,-250, 0.5,-145)
Panel.BackgroundColor3 = C.BG
Panel.BackgroundTransparency = 0.08
Panel.BorderSizePixel  = 0
Panel.Active           = true
Panel.Draggable        = true
Panel.Parent           = GUI
Corner(UDim.new(0,16), Panel)
Stroke(C.Accent, 1.5, 0.45, Panel)

-- ── شريط التدرج العلوي ──────────────────────────────────────────
local TopGlow = Instance.new("Frame")
TopGlow.Size             = UDim2.new(1, 0, 0, 2)
TopGlow.BackgroundColor3 = C.AccentGlow
TopGlow.BorderSizePixel  = 0
TopGlow.ZIndex           = 2
TopGlow.Parent           = Panel
Corner(UDim.new(0,16), TopGlow)
Gradient(ColorSequence.new({
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(100,180,255)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(180,100,255)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(100,180,255)),
}), 0, TopGlow)

-- ════════════════════════════════════════════
--             شريط العنوان
-- ════════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1, 0, 0, 34)
TitleBar.BackgroundColor3 = C.Surface
TitleBar.BackgroundTransparency = 0.0
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 3
TitleBar.Parent           = Panel
Corner(UDim.new(0,16), TitleBar)
Gradient(ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(14,20,55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,12,30)),
}), 0, TitleBar)

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size               = UDim2.new(0, 30, 1, 0)
TitleIcon.Position           = UDim2.new(0, 8, 0, 0)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text               = "🔥"
TitleIcon.TextSize           = 18
TitleIcon.Font               = Enum.Font.GothamBold
TitleIcon.ZIndex             = 4
TitleIcon.Parent             = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size               = UDim2.new(0, 180, 1, 0)
TitleLbl.Position           = UDim2.new(0, 36, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text               = "PRO X100"
TitleLbl.TextColor3         = C.White
TitleLbl.TextSize           = 14
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextXAlignment     = Enum.TextXAlignment.Left
TitleLbl.ZIndex             = 4
TitleLbl.Parent             = TitleBar

local SubLbl = Instance.new("TextLabel")
SubLbl.Size               = UDim2.new(0, 200, 0.55, 0)
SubLbl.Position           = UDim2.new(0, 36, 0.45, 0)
SubLbl.BackgroundTransparency = 1
SubLbl.Text               = "Ultimate Edition • v2.0"
SubLbl.TextColor3         = C.TextMuted
SubLbl.TextSize           = 9
SubLbl.Font               = Enum.Font.GothamMedium
SubLbl.TextXAlignment     = Enum.TextXAlignment.Left
SubLbl.ZIndex             = 4
SubLbl.Parent             = TitleBar

-- زر الإخفاء
local HideBtn = Instance.new("TextButton")
HideBtn.Size             = UDim2.new(0, 26, 0, 20)
HideBtn.Position         = UDim2.new(1, -32, 0.5, -10)
HideBtn.BackgroundColor3 = C.Red
HideBtn.Text             = "─"
HideBtn.TextColor3       = C.White
HideBtn.TextSize         = 13
HideBtn.Font             = Enum.Font.GothamBold
HideBtn.ZIndex           = 10
HideBtn.Parent           = TitleBar
Corner(UDim.new(0,6), HideBtn)

local function ShowPanel()
    Panel.Visible = true
    Mini.Visible  = false
    UIHidden      = false
    Panel.BackgroundTransparency = 1
    Tween(Panel, TI.Medium, {BackgroundTransparency = 0.08})
end

local function HidePanel()
    UIHidden = true
    Tween(Panel, TI.Fast, {BackgroundTransparency = 1})
    task.delay(0.2, function()
        if UIHidden then
            Panel.Visible = false
            Panel.BackgroundTransparency = 0.08
            Mini.Visible = true
        end
    end)
    Notify("PRO X100", "الواجهة مصغرة | اضغط الأيقونة لإعادة الفتح")
end

HideBtn.MouseButton1Click:Connect(HidePanel)
Mini.MouseButton1Click:Connect(function()
    if not mMoved then ShowPanel() end
end)
UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.F5 then
        if UIHidden then ShowPanel() else HidePanel() end
    end
end)

-- ════════════════════════════════════════════
--           القائمة الجانبية (Sidebar)
-- ════════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Size             = UDim2.new(0, 96, 1, -34)
Sidebar.Position         = UDim2.new(0, 0, 0, 34)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BackgroundTransparency = 0.0
Sidebar.BorderSizePixel  = 0
Sidebar.Parent           = Panel
Corner(UDim.new(0,12), Sidebar)
Gradient(ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,14,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 22)),
}), 90, Sidebar)

-- خط فاصل عمودي
local Divider = Instance.new("Frame")
Divider.Size             = UDim2.new(0, 1, 1, -34)
Divider.Position         = UDim2.new(0, 96, 0, 34)
Divider.BackgroundColor3 = C.Accent
Divider.BackgroundTransparency = 0.7
Divider.BorderSizePixel  = 0
Divider.Parent           = Panel

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding              = UDim.new(0, 5)
SideLayout.HorizontalAlignment  = Enum.HorizontalAlignment.Center
SideLayout.Parent               = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop  = UDim.new(0, 8)
SidePadding.Parent      = Sidebar

-- ════════════════════════════════════════════
--           منطقة المحتوى (Content)
-- ════════════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Size             = UDim2.new(1, -102, 1, -38)
ContentArea.Position         = UDim2.new(0, 100, 0, 36)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel  = 0
ContentArea.Parent           = Panel

-- ════════════════════════════════════════════
--         دوال مساعدة لبناء الواجهة
-- ════════════════════════════════════════════

local AllTabs  = {}
local AllPages = {}

local function CreatePage()
    local sf = Instance.new("ScrollingFrame")
    sf.Size                = UDim2.new(1, -4, 1, -6)
    sf.Position            = UDim2.new(0, 2, 0, 4)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel     = 0
    sf.CanvasSize          = UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection  = Enum.ScrollingDirection.Y
    sf.ScrollBarThickness  = 4
    sf.ScrollBarImageColor3 = C.Accent
    sf.Visible             = false
    sf.Active              = true
    sf.Parent              = ContentArea

    local lay = Instance.new("UIListLayout")
    lay.Padding             = UDim.new(0, 8)
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.Parent              = sf

    local pad = Instance.new("UIPadding")
    pad.PaddingTop   = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent       = sf

    return sf
end

local function SwitchPage(page, tabBtn)
    for _, p in AllPages  do p.Visible = false end
    for _, t in AllTabs do
        t.BackgroundColor3  = C.SurfaceAlt
        t.BackgroundTransparency = 0.3
        Tween(t, TI.Fast, {TextColor3 = C.TextSub})
    end
    page.Visible = true
    tabBtn.BackgroundColor3 = C.Accent
    tabBtn.BackgroundTransparency = 0.15
    Tween(tabBtn, TI.Fast, {TextColor3 = C.White})
end

local function AddTab(icon, label, page)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0.92, 0, 0, 58)
    btn.BackgroundColor3 = C.SurfaceAlt
    btn.BackgroundTransparency = 0.3
    btn.Text             = ""
    btn.Active           = true
    btn.Parent           = Sidebar
    Corner(UDim.new(0,10), btn)
    Stroke(C.Accent, 1, 0.78, btn)

    local ico = Instance.new("TextLabel")
    ico.Size               = UDim2.new(1,0,0,26)
    ico.Position           = UDim2.new(0,0,0,8)
    ico.BackgroundTransparency = 1
    ico.Text               = icon
    ico.TextSize           = 20
    ico.Font               = Enum.Font.GothamBold
    ico.TextColor3         = C.TextSub
    ico.Parent             = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1,0,0,14)
    lbl.Position           = UDim2.new(0,0,0,36)
    lbl.BackgroundTransparency = 1
    lbl.Text               = label
    lbl.TextSize           = 9
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextColor3         = C.TextMuted
    lbl.Parent             = btn

    table.insert(AllTabs, btn)
    table.insert(AllPages, page)

    btn.MouseButton1Click:Connect(function()
        SwitchPage(page, btn)
        Tween(ico, TI.Fast, {TextColor3 = C.AccentGlow})
        Tween(lbl, TI.Fast, {TextColor3 = C.TextSub})
    end)

    btn.MouseEnter:Connect(function()
        if AllPages[table.find(AllPages, page)] ~= nil and page.Visible then return end
        Tween(btn, TI.Fast, {BackgroundTransparency = 0.15})
    end)
    btn.MouseLeave:Connect(function()
        if page.Visible then return end
        Tween(btn, TI.Fast, {BackgroundTransparency = 0.3})
        Tween(ico, TI.Fast, {TextColor3 = C.TextSub})
        Tween(lbl, TI.Fast, {TextColor3 = C.TextMuted})
    end)

    return btn, ico, lbl
end

-- ── أداة: زر عادي ───────────────────────────────────────────────
local function MakeButton(parent, text, icon, colorDef, cb)
    colorDef = colorDef or C.Accent
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0.96, 0, 0, 38)
    btn.BackgroundColor3 = colorDef
    btn.BackgroundTransparency = 0.15
    btn.Text             = icon and (icon.." "..text) or text
    btn.TextColor3       = C.White
    btn.TextSize         = 12
    btn.Font             = Enum.Font.GothamSemibold
    btn.Active           = true
    btn.Parent           = parent
    Corner(UDim.new(0,9), btn)
    Stroke(colorDef, 1, 0.6, btn)

    btn.MouseButton1Down:Connect(function()
        Tween(btn, TI.Fast, {BackgroundTransparency = 0.4})
    end)
    btn.MouseButton1Up:Connect(function()
        Tween(btn, TI.Fast, {BackgroundTransparency = 0.15})
        if cb then cb() end
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, TI.Fast, {BackgroundTransparency = 0.15})
    end)
    return btn
end

-- ── أداة: Toggle ────────────────────────────────────────────────
local function MakeToggle(parent, text, icon, cb)
    local on = false

    local row = Instance.new("Frame")
    row.Size             = UDim2.new(0.96, 0, 0, 40)
    row.BackgroundColor3 = C.Surface
    row.BackgroundTransparency = 0.1
    row.BorderSizePixel  = 0
    row.Active           = true
    row.Parent           = parent
    Corner(UDim.new(0,9), row)
    Stroke(C.Accent, 1, 0.75, row)

    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1,-60,1,0)
    lbl.Position           = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = icon and (icon.." "..text) or text
    lbl.TextColor3         = C.Text
    lbl.TextSize           = 12
    lbl.Font               = Enum.Font.GothamMedium
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Parent             = row

    local track = Instance.new("TextButton")
    track.Size             = UDim2.new(0, 42, 0, 22)
    track.Position         = UDim2.new(1,-50, 0.5,-11)
    track.BackgroundColor3 = C.Track
    track.Text             = ""
    track.BorderSizePixel  = 0
    track.Active           = true
    track.Parent           = row
    Corner(UDim.new(0,11), track)

    local thumb = Instance.new("Frame")
    thumb.Size             = UDim2.new(0,16,0,16)
    thumb.Position         = UDim2.new(0,3,0.5,-8)
    thumb.BackgroundColor3 = C.TextSub
    thumb.BorderSizePixel  = 0
    thumb.Parent           = track
    Corner(UDim.new(1,0), thumb)

    local function Toggle()
        on = not on
        if on then
            Tween(track, TI.Medium, {BackgroundColor3 = C.Green})
            Tween(thumb, TI.Spring, {Position = UDim2.new(0,23,0.5,-8), BackgroundColor3 = C.White})
            Tween(lbl,   TI.Fast,   {TextColor3 = C.Green})
        else
            Tween(track, TI.Medium, {BackgroundColor3 = C.Track})
            Tween(thumb, TI.Spring, {Position = UDim2.new(0,3,0.5,-8), BackgroundColor3 = C.TextSub})
            Tween(lbl,   TI.Fast,   {TextColor3 = C.Text})
        end
        if cb then cb(on) end
    end

    track.MouseButton1Click:Connect(Toggle)
    row.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            Toggle()
        end
    end)

    return row, function() return on end
end

-- ── أداة: Slider ────────────────────────────────────────────────
local function MakeSlider(parent, text, icon, min, max, default, cb)
    local container = Instance.new("Frame")
    container.Size             = UDim2.new(0.96, 0, 0, 56)
    container.BackgroundColor3 = C.Surface
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel  = 0
    container.Active           = true
    container.Parent           = parent
    Corner(UDim.new(0,9), container)
    Stroke(C.Accent, 1, 0.75, container)

    local headerRow = Instance.new("Frame")
    headerRow.Size               = UDim2.new(1,-16, 0, 20)
    headerRow.Position           = UDim2.new(0,8,0,6)
    headerRow.BackgroundTransparency = 1
    headerRow.Parent             = container

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size               = UDim2.new(0.75, 0, 1, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text               = icon and (icon.." "..text) or text
    nameLbl.TextColor3         = C.Text
    nameLbl.TextSize           = 11
    nameLbl.Font               = Enum.Font.GothamMedium
    nameLbl.TextXAlignment     = Enum.TextXAlignment.Left
    nameLbl.Parent             = headerRow

    local valLbl = Instance.new("TextLabel")
    valLbl.Size               = UDim2.new(0.25, 0, 1, 0)
    valLbl.Position           = UDim2.new(0.75, 0, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text               = tostring(default)
    valLbl.TextColor3         = C.AccentGlow
    valLbl.TextSize           = 11
    valLbl.Font               = Enum.Font.GothamBold
    valLbl.TextXAlignment     = Enum.TextXAlignment.Right
    valLbl.Parent             = headerRow

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1,-16, 0, 10)
    track.Position         = UDim2.new(0,8,0,32)
    track.BackgroundColor3 = C.Track
    track.BorderSizePixel  = 0
    track.Active           = true
    track.Parent           = container
    Corner(UDim.new(1,0), track)

    local fill = Instance.new("Frame")
    local initR = (default - min) / (max - min)
    fill.Size             = UDim2.new(initR, 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.BorderSizePixel  = 0
    fill.Parent           = track
    Corner(UDim.new(1,0), fill)
    Gradient(ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120,160,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 220)),
    }), 0, fill)

    local thumb = Instance.new("Frame")
    thumb.Size             = UDim2.new(0, 18, 0, 18)
    thumb.Position         = UDim2.new(initR, -9, 0.5, -9)
    thumb.BackgroundColor3 = C.White
    thumb.BorderSizePixel  = 0
    thumb.ZIndex           = 3
    thumb.Active           = true
    thumb.Parent           = track
    Corner(UDim.new(1,0), thumb)
    Stroke(C.AccentGlow, 2, 0.4, thumb)

    local dragging = false

    local function Update(x)
        local abs = track.AbsoluteSize.X
        if abs <= 0 then return end
        local ratio = math.clamp((x - track.AbsolutePosition.X) / abs, 0, 1)
        local val   = math.round(min + ratio * (max - min))
        fill.Size         = UDim2.new(ratio, 0, 1, 0)
        thumb.Position    = UDim2.new(ratio, -9, 0.5, -9)
        valLbl.Text       = tostring(val)
        if cb then cb(val) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; Update(i.Position.X)
        end
    end)
    thumb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            Update(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return container
end

-- ── أداة: Input Box ─────────────────────────────────────────────
local function MakeInput(parent, placeholder, cb)
    local container = Instance.new("Frame")
    container.Size             = UDim2.new(0.96, 0, 0, 38)
    container.BackgroundColor3 = C.SurfaceAlt
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel  = 0
    container.Parent           = parent
    Corner(UDim.new(0,9), container)
    Stroke(C.Accent, 1, 0.68, container)

    local box = Instance.new("TextBox")
    box.Size               = UDim2.new(1,-16, 1, -8)
    box.Position           = UDim2.new(0,8,0,4)
    box.BackgroundTransparency = 1
    box.PlaceholderText    = placeholder
    box.PlaceholderColor3  = C.TextMuted
    box.TextColor3         = C.Text
    box.TextSize           = 12
    box.Font               = Enum.Font.GothamMedium
    box.ClearTextOnFocus   = false
    box.TextXAlignment     = Enum.TextXAlignment.Left
    box.Parent             = container

    box.FocusLost:Connect(function(enter)
        if enter and box.Text ~= "" then
            if cb then cb(box.Text) end
            box.Text = ""
        end
    end)

    return container, box
end

-- ── أداة: Section Divider ────────────────────────────────────────
local function MakeDivider(parent, text)
    local row = Instance.new("Frame")
    row.Size               = UDim2.new(0.96, 0, 0, 18)
    row.BackgroundTransparency = 1
    row.Parent             = parent

    local line = Instance.new("Frame")
    line.Size              = UDim2.new(1, 0, 0, 1)
    line.Position          = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3  = C.Accent
    line.BackgroundTransparency = 0.7
    line.BorderSizePixel   = 0
    line.Parent            = row

    if text then
        local lbl = Instance.new("TextLabel")
        lbl.Size               = UDim2.new(0, 0, 1, 0)
        lbl.AutomaticSize      = Enum.AutomaticSize.X
        lbl.Position           = UDim2.new(0.02, 0, 0, 0)
        lbl.BackgroundColor3   = C.BG
        lbl.BackgroundTransparency = 0.08
        lbl.Text               = "  "..text.."  "
        lbl.TextColor3         = C.TextMuted
        lbl.TextSize           = 9
        lbl.Font               = Enum.Font.GothamBold
        lbl.Parent             = row
        Corner(UDim.new(0,4), lbl)
    end
    return row
end

-- ════════════════════════════════════════════════════════════════
--                    بناء الصفحات
-- ════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 1. صفحة الطيران والحركة
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local P_Fly  = CreatePage()
local T_Fly, TI_Fly = AddTab("✈️","طيران", P_Fly)

MakeDivider(P_Fly, "الطيران وضع الشبح")
MakeToggle(P_Fly, "تفعيل الطيران الحر", "✈️", function(v)
    if v then StartFly() else StopFly() end
end)
MakeToggle(P_Fly, "اختراق الجدران", "🧱", function(v)
    NoClip = v
end)

MakeDivider(P_Fly, "ضبط السرعة")
MakeSlider(P_Fly, "سرعة الطيران", "⚡", 30, 500, 100, function(v)
    FlySpeed = v
end)
MakeSlider(P_Fly, "سرعة المشي (WalkSpeed)", "🏃", 0, 250, 16, function(v)
    SetWalk(v)
end)
MakeSlider(P_Fly, "قوة القفز (JumpPower)", "🚀", 0, 350, 50, function(v)
    SetJump(v)
end)

MakeDivider(P_Fly, "اختصارات")
do
    local info = Instance.new("TextLabel")
    info.Size              = UDim2.new(0.96, 0, 0, 68)
    info.BackgroundColor3  = C.Surface
    info.BackgroundTransparency = 0.1
    info.TextColor3        = C.TextSub
    info.TextSize          = 10
    info.Font              = Enum.Font.GothamMedium
    info.Text              = "E: طيران  |  X: جدران  |  Shift: تسريع\nC/Z: رفع/خفض سرعة الطيران\nF5: إخفاء/إظهار الواجهة"
    info.TextWrapped       = true
    info.Parent            = P_Fly
    Corner(UDim.new(0,9), info)
    Stroke(C.Accent, 1, 0.8, info)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 2. صفحة المناطق (Checkpoints)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local P_CP = CreatePage()
AddTab("📍","مناطق", P_CP)

for i = 1, 3 do
    MakeDivider(P_CP, "المنطقة "..i)
    local row = Instance.new("Frame")
    row.Size               = UDim2.new(0.96, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.Parent             = P_CP

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding       = UDim.new(0, 6)
    rowLayout.Parent        = row

    local saveBtn = Instance.new("TextButton")
    saveBtn.Size             = UDim2.new(0.48, 0, 1, 0)
    saveBtn.BackgroundColor3 = C.Accent
    saveBtn.BackgroundTransparency = 0.15
    saveBtn.Text             = "💾 حفظ المنطقة "..i
    saveBtn.TextColor3       = C.White
    saveBtn.TextSize         = 11
    saveBtn.Font             = Enum.Font.GothamSemibold
    saveBtn.Active           = true
    saveBtn.Parent           = row
    Corner(UDim.new(0,9), saveBtn)

    local teleBtn = Instance.new("TextButton")
    teleBtn.Size             = UDim2.new(0.48, 0, 1, 0)
    teleBtn.BackgroundColor3 = C.Green
    teleBtn.BackgroundTransparency = 0.15
    teleBtn.Text             = "🌀 انتقل "..i
    teleBtn.TextColor3       = C.White
    teleBtn.TextSize         = 11
    teleBtn.Font             = Enum.Font.GothamSemibold
    teleBtn.Active           = true
    teleBtn.Parent           = row
    Corner(UDim.new(0,9), teleBtn)

    saveBtn.MouseButton1Click:Connect(function() SaveCP(i) end)
    teleBtn.MouseButton1Click:Connect(function() LoadCP(i) end)

    saveBtn.MouseButton1Down:Connect(function() Tween(saveBtn, TI.Fast, {BackgroundTransparency=0.4}) end)
    saveBtn.MouseButton1Up:Connect(function()   Tween(saveBtn, TI.Fast, {BackgroundTransparency=0.15}) end)
    teleBtn.MouseButton1Down:Connect(function() Tween(teleBtn, TI.Fast, {BackgroundTransparency=0.4}) end)
    teleBtn.MouseButton1Up:Connect(function()   Tween(teleBtn, TI.Fast, {BackgroundTransparency=0.15}) end)
end

MakeDivider(P_CP, "اختصارات لوحة المفاتيح")
do
    local info = Instance.new("TextLabel")
    info.Size              = UDim2.new(0.96, 0, 0, 50)
    info.BackgroundColor3  = C.Surface
    info.BackgroundTransparency = 0.1
    info.TextColor3        = C.TextSub
    info.TextSize          = 10
    info.Font              = Enum.Font.GothamMedium
    info.Text              = "N/M/K: حفظ المناطق 1/2/3\nB/V/J: انتقل للمنطقة 1/2/3"
    info.TextWrapped       = true
    info.Parent            = P_CP
    Corner(UDim.new(0,9), info)
    Stroke(C.Accent,1,0.8,info)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 3. صفحة الموسيقى
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local P_Music = CreatePage()
AddTab("🎵","موسيقى", P_Music)

local Songs = {
    {"أغنية 1","3017157406"},
    {"أغنية 2","1843170826"},
    {"أغنية 3","9126245770"},
    {"أغنية 4","6698976160"},
    {"أغنية 5","9032979010"},
}

MakeDivider(P_Music, "مكتبة الأغاني")
for _, s in Songs do
    MakeButton(P_Music, s[1], "🎤", C.Accent, function()
        PlaySound(s[2])
    end)
end

MakeDivider(P_Music, "أغنية مخصصة")
local _, soundBox = MakeInput(P_Music, "أدخل ID الأغنية ثم اضغط Enter", function(t)
    PlaySound(t)
end)

MakeDivider(P_Music, "الصوت")
MakeSlider(P_Music, "مستوى الصوت", "🔊", 0, 100, 50, function(v)
    SoundVol = v / 100
    if CurrentSound then CurrentSound.Volume = SoundVol end
end)
MakeButton(P_Music, "إيقاف الموسيقى", "🔇", C.Red, StopSound)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 4. صفحة اللاعبين
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local P_Players = CreatePage()
AddTab("👥","لاعبين", P_Players)

MakeDivider(P_Players, "بحث عن لاعب (أول 3 حروف كافية)")
MakeInput(P_Players, "اكتب اسم اللاعب ثم Enter", function(t)
    local p = FindPlayer(t)
    if p then
        CurrentTarget = p
        Notify("✅ تم العثور", p.Name.." ("..p.DisplayName..")")
    else
        Notify("❌ خطأ", "لا يوجد لاعب باسم: "..t)
    end
end)

MakeButton(P_Players, "تيليپورت للاعب المحدد", "🎯", C.Green, function()
    if CurrentTarget then
        TeleportToPlayer(CurrentTarget)
    else
        Notify("⚠️","ابحث عن لاعب أولاً")
    end
end)

MakeDivider(P_Players, "قائمة اللاعبين")
local refreshBtn = MakeButton(P_Players, "تحديث القائمة", "🔄", C.AccentDark, nil)
local listFrame = Instance.new("Frame")
listFrame.Size               = UDim2.new(0.96, 0, 0, 0)
listFrame.AutomaticSize      = Enum.AutomaticSize.Y
listFrame.BackgroundTransparency = 1
listFrame.Parent             = P_Players

local listLayout = Instance.new("UIListLayout")
listLayout.Padding           = UDim.new(0, 4)
listLayout.Parent            = listFrame

local function RefreshList()
    for _, c in listFrame:GetChildren() do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    for _, p in Players:GetPlayers() do
        local row = Instance.new("TextButton")
        row.Size             = UDim2.new(1, 0, 0, 32)
        row.BackgroundColor3 = C.SurfaceAlt
        row.BackgroundTransparency = 0.2
        row.Text             = "👤 "..p.Name.." ("..p.DisplayName..")"
        row.TextColor3       = C.Text
        row.TextSize         = 11
        row.Font             = Enum.Font.GothamMedium
        row.TextXAlignment   = Enum.TextXAlignment.Left
        row.Active           = true
        row.Parent           = listFrame
        Corner(UDim.new(0,8), row)

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0,8)
        pad.Parent      = row

        row.MouseButton1Click:Connect(function()
            CurrentTarget = p
            Notify("✅ محدد", p.Name)
            Tween(row, TI.Fast, {BackgroundColor3 = C.Accent, BackgroundTransparency = 0.2})
            task.delay(0.5, function()
                Tween(row, TI.Fast, {BackgroundColor3 = C.SurfaceAlt, BackgroundTransparency = 0.2})
            end)
        end)
    end
end
RefreshList()
refreshBtn.MouseButton1Click:Connect(RefreshList)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 5. صفحة الأمان والمعلومات
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local P_Info = CreatePage()
AddTab("ℹ️","معلومات", P_Info)

MakeDivider(P_Info, "نظام الحماية")
MakeButton(P_Info, "إعادة تفعيل الحماية", "🛡️", C.Yellow, AntiBan)

MakeDivider(P_Info, "معلومات السكربت")
do
    local box = Instance.new("TextLabel")
    box.Size               = UDim2.new(0.96, 0, 0, 130)
    box.BackgroundColor3   = C.Surface
    box.BackgroundTransparency = 0.1
    box.TextColor3         = C.TextSub
    box.TextSize           = 11
    box.Font               = Enum.Font.GothamMedium
    box.Text               = [[🔥 PRO X100 — Ultimate Edition

✈ E     → طيران / إيقاف
🧱 X     → اختراق الجدران
📍 N/M/K → حفظ المناطق 1/2/3
🌀 B/V/J → انتقل 1/2/3
⚡ C/Z   → رفع/خفض سرعة الطيران
📱 F5   → إخفاء/إظهار الواجهة]]
    box.TextWrapped        = true
    box.TextXAlignment     = Enum.TextXAlignment.Left
    box.Parent             = P_Info
    Corner(UDim.new(0,9), box)
    Stroke(C.Accent, 1, 0.75, box)

    local pad = Instance.new("UIPadding")
    pad.PaddingAll = UDim.new(0,8)
    pad.Parent     = box
end

-- ════════════════════════════════════════════
--     تفعيل الصفحة الأولى وتأثير البداية
-- ════════════════════════════════════════════
SwitchPage(P_Fly, T_Fly)
Tween(TI_Fly, TI.Fast, {TextColor3 = C.AccentGlow})

-- ════════════════════════════════════════════
--           إشعار الترحيب
-- ════════════════════════════════════════════
task.delay(1, function()
    Notify("🔥 PRO X100", "تم التحميل بنجاح ✅ | جميع الميزات جاهزة", 4)
end)

print([[
╔══════════════════════════════════════════════════════╗
║          🔥 PRO X100 — تم التحميل بنجاح ✅            ║
╚══════════════════════════════════════════════════════╝
]])
