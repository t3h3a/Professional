--[[
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║            ████████╗██╗  ██╗ █████╗ ███████╗██████╗            ║
║               ██╔══╝██║  ██║██╔══██╗██╔════╝██╔══██╗           ║
║               ██║   ███████║███████║█████╗  ██████╔╝           ║
║               ██║   ██╔══██║██╔══██║██╔══╝  ██╔══██╗           ║
║               ██║   ██║  ██║██║  ██║███████╗██║  ██║           ║
║               ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝           ║
║                            X100                                  ║
║  ✈ طيران  🧱 جدران  👁 ESP  🎯 Aimbot  🎵 موسيقى               ║
║  📍 مناطق  👥 تعقب  💫 متابعة  🛡️ حماية  📱 جوال              ║
╚══════════════════════════════════════════════════════════════════╝
]]

-- ══════════════════════════════════════
--           الخدمات الأساسية
-- ══════════════════════════════════════
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local RS            = game:GetService("RunService")
local TS            = game:GetService("TweenService")
local SG            = game:GetService("StarterGui")
local CG            = game:GetService("CoreGui")
local VU            = game:GetService("VirtualUser")
local Http          = game:GetService("HttpService")

local LP            = Players.LocalPlayer
local Cam           = workspace.CurrentCamera
local Char          = LP.Character or LP.CharacterAdded:Wait()
local Hum           = Char:WaitForChild("Humanoid")
local Root          = Char:WaitForChild("HumanoidRootPart")

-- ══════════════════════════════════════
--              الثيم الفاخر
-- ══════════════════════════════════════
local C = {
    BG          = Color3.fromRGB(5,   5,  12),
    BG2         = Color3.fromRGB(8,   8,  20),
    Surface     = Color3.fromRGB(12, 12,  26),
    SurfaceAlt  = Color3.fromRGB(18, 18,  36),
    Card        = Color3.fromRGB(16, 16,  32),
    Sidebar     = Color3.fromRGB(8,  10,  28),
    A1          = Color3.fromRGB(80, 120, 255),   -- أزرق أساسي
    A2          = Color3.fromRGB(120,160, 255),   -- أزرق فاتح
    A3          = Color3.fromRGB(180, 80, 255),   -- بنفسجي
    Green       = Color3.fromRGB(50, 200, 120),
    Red         = Color3.fromRGB(255,  60,  80),
    Yellow      = Color3.fromRGB(255, 190,  40),
    Cyan        = Color3.fromRGB(40,  210, 210),
    Pink        = Color3.fromRGB(255,  80, 180),
    Text        = Color3.fromRGB(230, 230, 248),
    TextSub     = Color3.fromRGB(140, 140, 175),
    TextMuted   = Color3.fromRGB(65,  65,  95),
    Track       = Color3.fromRGB(25,  25,  50),
    White       = Color3.fromRGB(255, 255, 255),
    Black       = Color3.fromRGB(0,   0,   0),
    SplashBG    = Color3.fromRGB(6,  10,  30),
    PixelColor  = Color3.fromRGB(60, 130, 255),
    PixelGlow   = Color3.fromRGB(100,180, 255),
}

local TI = {
    Snap   = TweenInfo.new(0.10, Enum.EasingStyle.Quad),
    Fast   = TweenInfo.new(0.18, Enum.EasingStyle.Quad),
    Med    = TweenInfo.new(0.28, Enum.EasingStyle.Quad),
    Spring = TweenInfo.new(0.35, Enum.EasingStyle.Back),
    Slow   = TweenInfo.new(0.55, Enum.EasingStyle.Quad),
    Sine   = TweenInfo.new(1.5,  Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
}

local function Tween(o, ti, p) TS:Create(o, ti, p):Play() end
local function Corner(r, p) local c=Instance.new("UICorner"); c.CornerRadius=r; c.Parent=p; return c end
local function Stroke(col, th, tr, p) local s=Instance.new("UIStroke"); s.Color=col; s.Thickness=th; s.Transparency=tr; s.Parent=p; return s end
local function Pad(t, b, l, r, p) local v=Instance.new("UIPadding"); v.PaddingTop=UDim.new(0,t); v.PaddingBottom=UDim.new(0,b); v.PaddingLeft=UDim.new(0,l); v.PaddingRight=UDim.new(0,r); v.Parent=p; return v end
local function ListLayout(dir, align, pad, p)
    local l=Instance.new("UIListLayout")
    l.FillDirection=dir or Enum.FillDirection.Vertical
    l.HorizontalAlignment=align or Enum.HorizontalAlignment.Center
    l.Padding=UDim.new(0,pad or 6)
    l.Parent=p; return l
end
local function GradH(c1, c2, p)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})
    g.Rotation=0; g.Parent=p; return g
end
local function GradV(c1, c2, p)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})
    g.Rotation=90; g.Parent=p; return g
end

-- ══════════════════════════════════════
--              المتغيرات
-- ══════════════════════════════════════
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
local ESP_Active    = false
local ESPs          = {}
local Aimbot_On     = false
local Following     = false
local Spectating    = false
local AllTabs       = {}
local AllPages      = {}

-- حفظ الإعدادات
local Settings = {FlySpeed=100, WalkSpd=16, JumpPow=50, SoundVol=50}
local function SaveSettings()
    pcall(function()
        writefile("thaer_x100.json", Http:JSONEncode(Settings))
    end)
end
local function LoadSettings()
    pcall(function()
        if isfile("thaer_x100.json") then
            local d = Http:JSONDecode(readfile("thaer_x100.json"))
            for k,v in pairs(d) do Settings[k] = v end
        end
    end)
end
LoadSettings()

-- ══════════════════════════════════════
--           الإشعارات
-- ══════════════════════════════════════
local function Notify(title, text, dur)
    pcall(function()
        SG:SetCore("SendNotification",{Title=title, Text=text, Duration=dur or 3})
    end)
end

-- ══════════════════════════════════════
--           الحماية AntiBan
-- ══════════════════════════════════════
local function AntiBan()
    pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if not checkcaller() and t:IsA("Humanoid") then
                if k=="WalkSpeed" then return WalkSpd end
                if k=="JumpPower" then return JumpPow  end
            end
            return old(t, k)
        end)
        setreadonly(mt, true)
    end)
    Notify("🛡️ Thaer X","تم تفعيل الحماية")
end
AntiBan()

-- ══════════════════════════════════════
--       Anti-AFK
-- ══════════════════════════════════════
LP.Idled:Connect(function()
    pcall(function()
        VU:Button2Down(Vector2.zero, Cam.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.zero, Cam.CFrame)
    end)
end)

-- ══════════════════════════════════════
--    نظام الطيران (يتبع الكاميرا)
-- ══════════════════════════════════════
local function StartFly()
    if Flying then return end
    Flying = true
    Cam = workspace.CurrentCamera

    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1e5,1e5,1e5)
    BV.Velocity  = Vector3.zero
    BV.Parent    = Root

    BG_Gyro = Instance.new("BodyGyro")
    BG_Gyro.MaxTorque = Vector3.new(4e5,4e5,4e5)
    BG_Gyro.P = 20000
    BG_Gyro.D = 1000
    BG_Gyro.CFrame = Root.CFrame
    BG_Gyro.Parent = Root

    Hum.PlatformStand = false
    Hum.AutoRotate    = false
    pcall(function() Hum:ChangeState(Enum.HumanoidStateType.Freefall) end)
    Notify("✈️ طيران","مفعّل | الكاميرا تتحكم بالاتجاه")
end

local function StopFly()
    if not Flying then return end
    Flying = false
    if BV      then BV:Destroy();      BV      = nil end
    if BG_Gyro then BG_Gyro:Destroy(); BG_Gyro = nil end
    Hum.PlatformStand = false
    Hum.AutoRotate    = true
    Notify("✈️ طيران","إيقاف")
end

-- تحديث الطيران — يتبع الكاميرا بشكل صحيح للكيبورد والجوال
RS.RenderStepped:Connect(function()
    if not Flying or not BV then return end
    Cam = workspace.CurrentCamera
    local cf   = Cam.CFrame
    local look = cf.LookVector
    local right = cf.RightVector

    -- كيبورد
    local dir = Vector3.zero
    if Keys.W then dir += look  end
    if Keys.S then dir -= look  end
    if Keys.D then dir += right end
    if Keys.A then dir -= right end

    -- جوال (Thumbstick عبر Humanoid.MoveDirection)
    if dir.Magnitude < 0.1 and Hum.MoveDirection.Magnitude > 0.1 then
        local md = Hum.MoveDirection
        -- نسقط على اتجاه الكاميرا
        local flat = Vector3.new(look.X, 0, look.Z).Unit
        local flatR = Vector3.new(right.X, 0, right.Z).Unit
        local dot_f = md:Dot(flat)
        local dot_r = md:Dot(flatR)
        dir = flat * dot_f + flatR * dot_r
    end

    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

    -- دعم أزرار الارتفاع للجوال
    if UIS.TouchEnabled then
        -- يمكن للمستخدم الضغط على Space أو أزرار مخصصة
    end

    local boost = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 2.5 or 1
    BV.Velocity = (dir.Magnitude > 0) and (dir.Unit * FlySpeed * boost) or Vector3.zero
    if BG_Gyro then
        BG_Gyro.CFrame = CFrame.new(Root.Position, Root.Position + Vector3.new(look.X,0,look.Z))
    end
end)

-- ══════════════════════════════════════
--        اختراق الجدران
-- ══════════════════════════════════════
RS.Stepped:Connect(function()
    if not NoClip then return end
    local c = LP.Character; if not c then return end
    for _, p in c:GetDescendants() do
        if p:IsA("BasePart") then pcall(function() p.CanCollide=false end) end
    end
end)

-- ══════════════════════════════════════
--        نقاط الإحداثيات
-- ══════════════════════════════════════
local function SaveCP(i)
    Checkpoints[i] = Root.CFrame
    Notify("📍 منطقة "..i,"تم الحفظ ✅")
end
local function LoadCP(i)
    if Checkpoints[i] then
        Root.CFrame = Checkpoints[i] + Vector3.new(0,3,0)
        Notify("🌀 منطقة "..i,"تم الانتقال 🚀")
    else
        Notify("⚠️ منطقة "..i,"لم تُحفظ بعد")
    end
end

-- ══════════════════════════════════════
--        البحث عن اللاعبين
-- ══════════════════════════════════════
local function FindPlayer(partial)
    if not partial or partial=="" then return nil end
    local low = partial:lower()
    for _, p in Players:GetPlayers() do
        if p ~= LP then
            if p.Name:lower():sub(1,#low)==low or p.DisplayName:lower():sub(1,#low)==low then return p end
        end
    end
    for _, p in Players:GetPlayers() do
        if p~=LP and (p.Name:lower():find(low,1,true) or p.DisplayName:lower():find(low,1,true)) then return p end
    end
    return nil
end

local function TeleToPlayer(p)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        Root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0)
        Notify("🎯 تيليپورت","→ "..p.Name)
    else Notify("⚠️","اللاعب غير موجود") end
end

-- ══════════════════════════════════════
--        ESP (رؤية اللاعبين)
-- ══════════════════════════════════════
local function CreateESP(player)
    if player == LP or ESPs[player] then return end
    local function Attach()
        if not player.Character then return end
        local head = player.Character:FindFirstChild("Head")
        if not head then return end
        local bill = Instance.new("BillboardGui")
        bill.Size        = UDim2.new(0,120,0,50)
        bill.StudsOffset = Vector3.new(0,2,0)
        bill.AlwaysOnTop = true
        bill.Parent      = head

        local bg = Instance.new("Frame")
        bg.Size              = UDim2.new(1,0,1,0)
        bg.BackgroundColor3  = Color3.fromRGB(0,0,0)
        bg.BackgroundTransparency = 0.6
        bg.Parent            = bill
        Corner(UDim.new(0,6), bg)
        Stroke(C.Cyan,1.5,0.3,bg)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size              = UDim2.new(1,-4,0.55,0)
        nameLbl.Position          = UDim2.new(0,2,0,2)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text              = "👤 "..player.Name
        nameLbl.TextColor3        = C.Cyan
        nameLbl.TextSize          = 12
        nameLbl.Font              = Enum.Font.GothamBold
        nameLbl.TextTruncate      = Enum.TextTruncate.AtEnd
        nameLbl.Parent            = bill

        local distLbl = Instance.new("TextLabel")
        distLbl.Size              = UDim2.new(1,-4,0.4,0)
        distLbl.Position          = UDim2.new(0,2,0.58,0)
        distLbl.BackgroundTransparency = 1
        distLbl.TextColor3        = C.TextSub
        distLbl.TextSize          = 10
        distLbl.Font              = Enum.Font.Gotham
        distLbl.Parent            = bill

        -- تحديث المسافة
        RS.RenderStepped:Connect(function()
            if not ESP_Active or not bill.Parent then return end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = math.floor((hrp.Position - Root.Position).Magnitude)
                distLbl.Text = "📏 "..d.." studs"
            end
        end)

        ESPs[player] = bill
    end

    Attach()
    player.CharacterAdded:Connect(function()
        if ESPs[player] then ESPs[player]:Destroy(); ESPs[player]=nil end
        task.wait(1); if ESP_Active then Attach() end
    end)
end

local function RemoveESP(player)
    if ESPs[player] then ESPs[player]:Destroy(); ESPs[player]=nil end
end

local function ToggleESP(v)
    ESP_Active = v
    for _, p in Players:GetPlayers() do
        if v then CreateESP(p) else RemoveESP(p) end
    end
    Notify("👁️ ESP", v and "مفعّل — ترى اللاعبين عبر الجدران" or "إيقاف")
end

Players.PlayerAdded:Connect(function(p) if ESP_Active then task.wait(2); CreateESP(p) end end)
Players.PlayerRemoving:Connect(RemoveESP)

-- ══════════════════════════════════════
--      Aimbot (قفل الكاميرا)
-- ══════════════════════════════════════
RS.RenderStepped:Connect(function()
    if not Aimbot_On then return end
    local closest, dist = nil, math.huge
    for _, p in Players:GetPlayers() do
        if p~=LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - Cam.CFrame.Position).Magnitude
                if d < dist then dist=d; closest=hrp end
            end
        end
    end
    if closest then
        Cam.CFrame = CFrame.new(Cam.CFrame.Position, closest.Position)
    end
end)

-- ══════════════════════════════════════
--      Spectate (مشاهدة لاعب)
-- ══════════════════════════════════════
local function Spectate(p)
    if p and p.Character then
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum then Cam.CameraSubject = hum; Spectating=true; Notify("👁️ Spectate","تشاهد: "..p.Name) end
    end
end
local function StopSpectate()
    local myHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if myHum then Cam.CameraSubject = myHum end
    Spectating = false; Notify("👁️ Spectate","عدت لشخصيتك")
end

-- ══════════════════════════════════════
--      Follow Player (متابعة)
-- ══════════════════════════════════════
RS.RenderStepped:Connect(function()
    if not Following or not CurrentTarget then return end
    local hrp = CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
    if hrp then Root.CFrame = hrp.CFrame * CFrame.new(0, 0, 3.5) end
end)

-- ══════════════════════════════════════
--      Fling (رمي لاعب)
-- ══════════════════════════════════════
local function Fling(p)
    if p and p.Character then
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(math.random(-8000,8000), 9999, math.random(-8000,8000))
            Notify("💥 Fling","تم رمي "..p.Name)
        end
    end
end

-- ══════════════════════════════════════
--      الموسيقى
-- ══════════════════════════════════════
local function PlaySound(id)
    if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy() end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..tostring(id)
    s.Volume = SoundVol; s.Looped = true
    s.Parent = Root; s:Play()
    CurrentSound = s
    Notify("🎵 موسيقى","تشغيل ID: "..tostring(id))
end
local function StopSound()
    if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy(); CurrentSound=nil end
    Notify("🔇 موسيقى","إيقاف")
end

-- السرعة والقفز
local function SetWalk(v) WalkSpd=v; pcall(function() Hum.WalkSpeed=v end); Settings.WalkSpd=v end
local function SetJump(v) JumpPow=v; pcall(function() Hum.JumpPower=v; Hum.UseJumpPower=true end); Settings.JumpPow=v end

-- إعادة التطبيق بعد البعث
LP.CharacterAdded:Connect(function(c)
    Char=c; Hum=c:WaitForChild("Humanoid"); Root=c:WaitForChild("HumanoidRootPart")
    Cam = workspace.CurrentCamera
    SetWalk(WalkSpd); SetJump(JumpPow)
    if Flying then
        if BV then BV:Destroy(); BV=nil end
        if BG_Gyro then BG_Gyro:Destroy(); BG_Gyro=nil end
        Flying=false; task.wait(0.6); StartFly()
    end
end)

-- مدخلات الكيبورد
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local k = inp.KeyCode
    if k==Enum.KeyCode.W then Keys.W=true
    elseif k==Enum.KeyCode.A then Keys.A=true
    elseif k==Enum.KeyCode.S then Keys.S=true
    elseif k==Enum.KeyCode.D then Keys.D=true
    elseif k==Enum.KeyCode.E then if Flying then StopFly() else StartFly() end
    elseif k==Enum.KeyCode.X then NoClip=not NoClip; Notify("🧱",NoClip and "جدران: مفعّل" or "جدران: إيقاف")
    elseif k==Enum.KeyCode.N then SaveCP(1)
    elseif k==Enum.KeyCode.M then SaveCP(2)
    elseif k==Enum.KeyCode.K then SaveCP(3)
    elseif k==Enum.KeyCode.B then LoadCP(1)
    elseif k==Enum.KeyCode.V then LoadCP(2)
    elseif k==Enum.KeyCode.J then LoadCP(3)
    elseif k==Enum.KeyCode.C then FlySpeed=math.min(600,FlySpeed+25); Notify("⚡","سرعة: "..FlySpeed)
    elseif k==Enum.KeyCode.Z then FlySpeed=math.max(30,FlySpeed-25); Notify("⚡","سرعة: "..FlySpeed)
    end
end)
UIS.InputEnded:Connect(function(i)
    local k=i.KeyCode
    if k==Enum.KeyCode.W then Keys.W=false elseif k==Enum.KeyCode.A then Keys.A=false
    elseif k==Enum.KeyCode.S then Keys.S=false elseif k==Enum.KeyCode.D then Keys.D=false end
end)

-- ════════════════════════════════════════════════════════
--
--                    بناء الواجهة
--
-- ════════════════════════════════════════════════════════

local GUI = Instance.new("ScreenGui")
GUI.Name           = "ThaerX100"
GUI.ResetOnSpawn   = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder   = 99
GUI.Parent         = CG

-- ════════════════════════════════════════════════════════
--         شاشة الترحيب (Splash Screen)
-- ════════════════════════════════════════════════════════

local Splash = Instance.new("Frame")
Splash.Name            = "Splash"
Splash.Size            = UDim2.new(1,0,1,0)
Splash.BackgroundColor3= C.SplashBG
Splash.BorderSizePixel = 0
Splash.ZIndex          = 200
Splash.Parent          = GUI

-- خلفية نجوم
for i=1,60 do
    local star = Instance.new("Frame")
    star.Size              = UDim2.new(0, math.random(1,3), 0, math.random(1,3))
    star.Position          = UDim2.new(math.random()/1, 0, math.random()/1, 0)
    star.BackgroundColor3  = Color3.fromRGB(200,220,255)
    star.BackgroundTransparency = math.random(30,80)/100
    star.BorderSizePixel   = 0
    star.ZIndex            = 201
    star.Parent            = Splash
    Corner(UDim.new(1,0), star)
end

-- الإطار المركزي
local SplashCard = Instance.new("Frame")
SplashCard.Name             = "SplashCard"
SplashCard.Size             = UDim2.new(0,460,0,320)
SplashCard.Position         = UDim2.new(0.5,-230,0.5,-160)
SplashCard.BackgroundColor3 = Color3.fromRGB(8,10,28)
SplashCard.BackgroundTransparency = 0.0
SplashCard.BorderSizePixel  = 0
SplashCard.ZIndex           = 202
SplashCard.Parent           = Splash
Corner(UDim.new(0,20), SplashCard)
Stroke(C.A1, 2, 0.2, SplashCard)

-- خط علوي ملوّن
local SplashTopLine = Instance.new("Frame")
SplashTopLine.Size             = UDim2.new(1,0,0,3)
SplashTopLine.BackgroundColor3 = C.A1
SplashTopLine.BorderSizePixel  = 0
SplashTopLine.ZIndex           = 203
SplashTopLine.Parent           = SplashCard
Corner(UDim.new(0,20), SplashTopLine)
GradH(Color3.fromRGB(80,140,255), Color3.fromRGB(180,80,255), SplashTopLine)

-- ── شعار البكسل آرت "THAER X" ──────────────────────────
-- كل حرف 5×7 بكسل، حجم كل بكسل 6×6 بودنة
local PIXEL_SIZE = 6
local PIXEL_GAP  = 1
local LETTER_GAP = 4

local Letters = {
    T = {
        {1,1,1,1,1},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
        {0,0,1,0,0},
    },
    H = {
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
    },
    A = {
        {0,0,1,0,0},
        {0,1,0,1,0},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
    },
    E = {
        {1,1,1,1,1},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,1,1,1,0},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,1,1,1,1},
    },
    R = {
        {1,1,1,1,0},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,0},
        {1,0,1,0,0},
        {1,0,0,1,0},
        {1,0,0,0,1},
    },
    X = {
        {1,0,0,0,1},
        {0,1,0,1,0},
        {0,0,1,0,0},
        {0,1,0,1,0},
        {0,0,1,0,0},
        {0,1,0,1,0},
        {1,0,0,0,1},
    },
    SP = { -- فراغ
        {0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},
    },
}

-- ترتيب الحروف: T H A E R [space] X
local sequence = {"T","H","A","E","R","SP","X"}

-- احسب العرض الكلي
local totalW = 0
for _, key in sequence do
    totalW += (#Letters[key][1]) * (PIXEL_SIZE+PIXEL_GAP)
    if key ~= "SP" then totalW += LETTER_GAP end
end

local logoH = 7 * (PIXEL_SIZE + PIXEL_GAP)
local logoStartX = (460 - totalW) / 2
local logoStartY = 38

local PixelCanvas = Instance.new("Frame")
PixelCanvas.Size             = UDim2.new(1,0,0,logoH+10)
PixelCanvas.Position         = UDim2.new(0,0,0,logoStartY-5)
PixelCanvas.BackgroundTransparency = 1
PixelCanvas.ZIndex           = 203
PixelCanvas.Parent           = SplashCard

local curX = logoStartX
for lIdx, key in sequence do
    local map = Letters[key]
    local cols = #map[1]
    for row = 1, #map do
        for col = 1, cols do
            if map[row][col] == 1 then
                local px = Instance.new("Frame")
                local px_x = curX + (col-1)*(PIXEL_SIZE+PIXEL_GAP)
                local px_y = (row-1)*(PIXEL_SIZE+PIXEL_GAP)
                px.Size             = UDim2.new(0,PIXEL_SIZE,0,PIXEL_SIZE)
                px.Position         = UDim2.new(0,px_x,0,px_y)
                px.BackgroundColor3 = C.PixelColor
                px.BorderSizePixel  = 0
                px.ZIndex           = 204
                px.Parent           = PixelCanvas

                -- Glow effect (إطار متوهج خلف البكسل)
                local glow = Instance.new("Frame")
                glow.Size             = UDim2.new(0,PIXEL_SIZE+4,0,PIXEL_SIZE+4)
                glow.Position         = UDim2.new(0,px_x-2,0,px_y-2)
                glow.BackgroundColor3 = C.A2
                glow.BackgroundTransparency = 0.82
                glow.BorderSizePixel  = 0
                glow.ZIndex           = 203
                glow.Parent           = PixelCanvas
                Corner(UDim.new(0,2), glow)
            end
        end
    end
    curX += cols*(PIXEL_SIZE+PIXEL_GAP) + LETTER_GAP
end

-- خط فاصل أسفل الشعار
local SplashLine = Instance.new("Frame")
SplashLine.Size             = UDim2.new(0.7,0,0,1)
SplashLine.Position         = UDim2.new(0.15,0,0,logoStartY+logoH+16)
SplashLine.BackgroundColor3 = C.A1
SplashLine.BackgroundTransparency = 0.5
SplashLine.BorderSizePixel  = 0
SplashLine.ZIndex           = 203
SplashLine.Parent           = SplashCard
GradH(Color3.fromRGB(0,0,0), Color3.fromRGB(80,130,255), SplashLine)

-- نص الترحيب
local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Size               = UDim2.new(1,-20,0,36)
WelcomeTitle.Position           = UDim2.new(0,10,0,logoStartY+logoH+26)
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Text               = "أهلاً في ثائر ادمن 🔥"
WelcomeTitle.TextColor3         = C.White
WelcomeTitle.TextSize           = 22
WelcomeTitle.Font               = Enum.Font.GothamBold
WelcomeTitle.ZIndex             = 203
WelcomeTitle.Parent             = SplashCard

local WelcomeSub = Instance.new("TextLabel")
WelcomeSub.Size               = UDim2.new(1,-20,0,20)
WelcomeSub.Position           = UDim2.new(0,10,0,logoStartY+logoH+64)
WelcomeSub.BackgroundTransparency = 1
WelcomeSub.Text               = "Ultimate Edition  •  جميع الأدوات جاهزة ✅"
WelcomeSub.TextColor3         = C.TextSub
WelcomeSub.TextSize           = 12
WelcomeSub.Font               = Enum.Font.GothamMedium
WelcomeSub.ZIndex             = 203
WelcomeSub.Parent             = SplashCard

-- بار التحميل
local LoadBG = Instance.new("Frame")
LoadBG.Size             = UDim2.new(0.78,0,0,8)
LoadBG.Position         = UDim2.new(0.11,0,0,logoStartY+logoH+94)
LoadBG.BackgroundColor3 = C.Track
LoadBG.BorderSizePixel  = 0
LoadBG.ZIndex           = 203
LoadBG.Parent           = SplashCard
Corner(UDim.new(1,0), LoadBG)

local LoadFill = Instance.new("Frame")
LoadFill.Size             = UDim2.new(0,0,1,0)
LoadFill.BackgroundColor3 = C.A1
LoadFill.BorderSizePixel  = 0
LoadFill.ZIndex           = 204
LoadFill.Parent           = LoadBG
Corner(UDim.new(1,0), LoadFill)
GradH(Color3.fromRGB(80,140,255), Color3.fromRGB(180,80,255), LoadFill)

local LoadText = Instance.new("TextLabel")
LoadText.Size               = UDim2.new(1,0,0,16)
LoadText.Position           = UDim2.new(0,0,0,logoStartY+logoH+108)
LoadText.BackgroundTransparency = 1
LoadText.Text               = "جارٍ التحميل..."
LoadText.TextColor3         = C.TextMuted
LoadText.TextSize           = 10
LoadText.Font               = Enum.Font.GothamMedium
LoadText.ZIndex             = 203
LoadText.Parent             = SplashCard

-- تشغيل بار التحميل ثم إغلاق Splash
task.spawn(function()
    local msgs = {"تحميل الميزات…","تفعيل الحماية…","إعداد ESP…","تجهيز الطيران…","اكتمل! ✅"}
    for i, msg in msgs do
        LoadText.Text = msg
        Tween(LoadFill, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {Size = UDim2.new(i/#msgs,0,1,0)})
        task.wait(0.48)
    end
    task.wait(0.3)
    Tween(Splash, TI.Med, {BackgroundTransparency=1})
    for _, d in Splash:GetDescendants() do
        if d:IsA("GuiObject") then
            pcall(function() Tween(d, TI.Fast, {BackgroundTransparency=1}) end)
        end
    end
    task.wait(0.35)
    Splash:Destroy()
end)

-- ════════════════════════════════════════════════════════
--       أيقونة التصغير (Floating Mini Icon)
-- ════════════════════════════════════════════════════════
local Mini = Instance.new("TextButton")
Mini.Name              = "MiniIcon"
Mini.Size              = UDim2.new(0,54,0,54)
Mini.Position          = UDim2.new(1,-70,0.72,0)
Mini.BackgroundColor3  = C.A1
Mini.Text              = "🔥"
Mini.TextSize          = 24
Mini.TextColor3        = C.White
Mini.Font              = Enum.Font.GothamBold
Mini.Visible           = false
Mini.ZIndex            = 50
Mini.Active            = true
Mini.Parent            = GUI
Corner(UDim.new(1,0), Mini)
Stroke(C.A2, 2, 0.4, Mini)
GradV(Color3.fromRGB(110,150,255), Color3.fromRGB(55,80,210), Mini)

local mDrag,mMoved,mOffset,mStart=false,false,Vector2.zero,Vector2.zero
Mini.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        mDrag=true; mMoved=false
        mStart=Vector2.new(i.Position.X,i.Position.Y)
        mOffset=Vector2.new(i.Position.X-Mini.AbsolutePosition.X,i.Position.Y-Mini.AbsolutePosition.Y)
    end
end)
UIS.InputChanged:Connect(function(i)
    if mDrag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local vp=workspace.CurrentCamera.ViewportSize; local sz=Mini.AbsoluteSize
        Mini.Position=UDim2.fromOffset(math.clamp(i.Position.X-mOffset.X,0,vp.X-sz.X),math.clamp(i.Position.Y-mOffset.Y,0,vp.Y-sz.Y))
        mMoved=(Vector2.new(i.Position.X,i.Position.Y)-mStart).Magnitude>6
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then mDrag=false end
end)

-- ════════════════════════════════════════════════════════
--         اللوحة الرئيسية (Main Panel)
-- ════════════════════════════════════════════════════════
local Panel = Instance.new("Frame")
Panel.Name             = "Panel"
Panel.Size             = UDim2.new(0,530,0,310)
Panel.Position         = UDim2.new(0.5,-265,0.5,-155)
Panel.BackgroundColor3 = C.BG
Panel.BackgroundTransparency = 0.04
Panel.BorderSizePixel  = 0
Panel.Active           = true
Panel.Draggable        = true
Panel.Visible          = false -- مخفية حتى تنتهي Splash
Panel.Parent           = GUI
Corner(UDim.new(0,16), Panel)
Stroke(C.A1, 1.5, 0.4, Panel)

-- خط توهج علوي
local TopBar = Instance.new("Frame")
TopBar.Size            = UDim2.new(1,0,0,3)
TopBar.BackgroundColor3= C.A1
TopBar.BorderSizePixel = 0
TopBar.ZIndex          = 2
TopBar.Parent          = Panel
Corner(UDim.new(0,16), TopBar)
GradH(Color3.fromRGB(80,140,255), Color3.fromRGB(200,80,255), TopBar)

-- ── شريط العنوان ──
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1,0,0,36)
TitleBar.BackgroundColor3 = C.Surface
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 3
TitleBar.Parent           = Panel
Corner(UDim.new(0,16), TitleBar)
GradH(Color3.fromRGB(14,18,50), Color3.fromRGB(8,10,30), TitleBar)

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size=UDim2.new(0,28,1,0); TitleIcon.Position=UDim2.new(0,8,0,0)
TitleIcon.BackgroundTransparency=1; TitleIcon.Text="🔥"; TitleIcon.TextSize=18
TitleIcon.Font=Enum.Font.GothamBold; TitleIcon.ZIndex=4; TitleIcon.Parent=TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size=UDim2.new(0,180,0.7,0); TitleLbl.Position=UDim2.new(0,36,0,4)
TitleLbl.BackgroundTransparency=1; TitleLbl.Text="THAER X100"
TitleLbl.TextColor3=C.White; TitleLbl.TextSize=14; TitleLbl.Font=Enum.Font.GothamBold
TitleLbl.TextXAlignment=Enum.TextXAlignment.Left; TitleLbl.ZIndex=4; TitleLbl.Parent=TitleBar

local SubLbl = Instance.new("TextLabel")
SubLbl.Size=UDim2.new(0,260,0.45,0); SubLbl.Position=UDim2.new(0,36,0.55,0)
SubLbl.BackgroundTransparency=1; SubLbl.Text="Ultimate Edition  •  v3.0 PRO"
SubLbl.TextColor3=C.TextMuted; SubLbl.TextSize=9; SubLbl.Font=Enum.Font.GothamMedium
SubLbl.TextXAlignment=Enum.TextXAlignment.Left; SubLbl.ZIndex=4; SubLbl.Parent=TitleBar

-- مؤشر الحالة (نقطة خضراء)
local StatusDot = Instance.new("Frame")
StatusDot.Size=UDim2.new(0,8,0,8); StatusDot.Position=UDim2.new(1,-64,0.5,-4)
StatusDot.BackgroundColor3=C.Green; StatusDot.BorderSizePixel=0; StatusDot.ZIndex=4; StatusDot.Parent=TitleBar
Corner(UDim.new(1,0), StatusDot)
Tween(StatusDot, TI.Sine, {BackgroundColor3=Color3.fromRGB(30,150,80)})

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size=UDim2.new(0,40,1,0); StatusLbl.Position=UDim2.new(1,-56,0,0)
StatusLbl.BackgroundTransparency=1; StatusLbl.Text="LIVE"; StatusLbl.TextColor3=C.Green
StatusLbl.TextSize=9; StatusLbl.Font=Enum.Font.GothamBold; StatusLbl.ZIndex=4; StatusLbl.Parent=TitleBar

-- زر الإخفاء
local HideBtn = Instance.new("TextButton")
HideBtn.Size=UDim2.new(0,24,0,20); HideBtn.Position=UDim2.new(1,-30,0.5,-10)
HideBtn.BackgroundColor3=C.Red; HideBtn.Text="─"; HideBtn.TextColor3=C.White
HideBtn.TextSize=13; HideBtn.Font=Enum.Font.GothamBold; HideBtn.ZIndex=10; HideBtn.Parent=TitleBar
Corner(UDim.new(0,6), HideBtn)

local function ShowPanel()
    Panel.Visible=true; Mini.Visible=false; UIHidden=false
    Panel.BackgroundTransparency=1
    Tween(Panel, TI.Med, {BackgroundTransparency=0.04})
end
local function HidePanel()
    UIHidden=true
    Tween(Panel, TI.Fast, {BackgroundTransparency=1})
    task.delay(0.22, function()
        if UIHidden then Panel.Visible=false; Panel.BackgroundTransparency=0.04; Mini.Visible=true end
    end)
    Notify("THAER X100","الواجهة مصغرة | اضغط 🔥 للإعادة")
end

HideBtn.MouseButton1Click:Connect(HidePanel)
Mini.MouseButton1Click:Connect(function() if not mMoved then ShowPanel() end end)
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.F5 then if UIHidden then ShowPanel() else HidePanel() end end
end)

-- إظهار اللوحة بعد Splash
task.delay(2.85, function() ShowPanel() end)

-- ── القائمة الجانبية ──
local Sidebar = Instance.new("Frame")
Sidebar.Size=UDim2.new(0,86,1,-36); Sidebar.Position=UDim2.new(0,0,0,36)
Sidebar.BackgroundColor3=C.Sidebar; Sidebar.BorderSizePixel=0; Sidebar.Parent=Panel
Corner(UDim.new(0,12), Sidebar)
GradV(Color3.fromRGB(10,14,40), Color3.fromRGB(6,8,22), Sidebar)

local SideDiv = Instance.new("Frame")
SideDiv.Size=UDim2.new(0,1,1,-36); SideDiv.Position=UDim2.new(0,86,0,36)
SideDiv.BackgroundColor3=C.A1; SideDiv.BackgroundTransparency=0.72; SideDiv.BorderSizePixel=0; SideDiv.Parent=Panel

ListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, 4, Sidebar)
Pad(8,8,0,0,Sidebar)

-- ── منطقة المحتوى ──
local Content = Instance.new("Frame")
Content.Size=UDim2.new(1,-92,1,-40); Content.Position=UDim2.new(0,90,0,38)
Content.BackgroundTransparency=1; Content.BorderSizePixel=0; Content.Parent=Panel

-- ════════════════════════════════════════════════════════
--             مساعدات بناء الصفحات
-- ════════════════════════════════════════════════════════

local function CreatePage()
    local sf = Instance.new("ScrollingFrame")
    sf.Size=UDim2.new(1,-2,1,-4); sf.Position=UDim2.new(0,1,0,2)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.ScrollingDirection=Enum.ScrollingDirection.Y; sf.ScrollBarThickness=3
    sf.ScrollBarImageColor3=C.A1; sf.Visible=false; sf.Active=true; sf.Parent=Content
    local lay=Instance.new("UIListLayout"); lay.Padding=UDim.new(0,7); lay.HorizontalAlignment=Enum.HorizontalAlignment.Center; lay.Parent=sf
    Pad(5,10,0,0,sf)
    return sf
end

local function HideAllPages()
    for _, p in ipairs(AllPages) do
        p.Visible = false
    end
end

local function SwitchPage(page, btn, ico, lbl)
    HideAllPages()
    for _, t in AllTabs do
        t.btn.BackgroundColor3=C.SurfaceAlt; t.btn.BackgroundTransparency=0.3
        Tween(t.ico, TI.Fast, {TextColor3=C.TextMuted})
        Tween(t.lbl, TI.Fast, {TextColor3=C.TextMuted})
    end
    page.Visible=true
    btn.BackgroundColor3=C.A1; btn.BackgroundTransparency=0.15
    Tween(ico, TI.Fast, {TextColor3=C.A2})
    Tween(lbl, TI.Fast, {TextColor3=C.TextSub})
end

local function AddTab(icon, label, page)
    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(0.94,0,0,60); btn.BackgroundColor3=C.SurfaceAlt
    btn.BackgroundTransparency=0.3; btn.Text=""; btn.Active=true; btn.Parent=Sidebar
    Corner(UDim.new(0,10), btn)
    Stroke(C.A1, 1, 0.82, btn)

    local ico=Instance.new("TextLabel"); ico.Size=UDim2.new(1,0,0,28); ico.Position=UDim2.new(0,0,0,7)
    ico.BackgroundTransparency=1; ico.Text=icon; ico.TextSize=20; ico.Font=Enum.Font.GothamBold
    ico.TextColor3=C.TextMuted; ico.Parent=btn

    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,0,13); lbl.Position=UDim2.new(0,0,0,37)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold
    lbl.TextColor3=C.TextMuted; lbl.Parent=btn

    local data = {btn=btn,ico=ico,lbl=lbl}
    table.insert(AllTabs, data); table.insert(AllPages, page)

    btn.MouseButton1Click:Connect(function() SwitchPage(page,btn,ico,lbl) end)
    btn.MouseEnter:Connect(function() if not page.Visible then Tween(btn,TI.Fast,{BackgroundTransparency=0.15}) end end)
    btn.MouseLeave:Connect(function() if not page.Visible then Tween(btn,TI.Fast,{BackgroundTransparency=0.3}) end end)
    return btn,ico,lbl
end

-- ── مكوّنات الصفحات ──────────────────────────────────────────────

local function MakeBtn(parent, text, col, cb)
    col = col or C.A1
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0.97,0,0,40); btn.BackgroundColor3=col
    btn.BackgroundTransparency=0.18; btn.Text=text; btn.TextColor3=C.White
    btn.TextSize=12; btn.Font=Enum.Font.GothamSemibold; btn.Active=true; btn.Parent=parent
    Corner(UDim.new(0,9),btn)
    Stroke(col,1,0.55,btn)
    btn.MouseButton1Down:Connect(function() Tween(btn,TI.Snap,{BackgroundTransparency=0.45}) end)
    btn.MouseButton1Up:Connect(function()
        Tween(btn,TI.Snap,{BackgroundTransparency=0.18})
        if cb then cb() end
    end)
    btn.MouseLeave:Connect(function() Tween(btn,TI.Snap,{BackgroundTransparency=0.18}) end)
    return btn
end

local function MakeIconCard(parent, icon, label, col)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(0.97, 0, 0, 54)
    card.BackgroundColor3 = C.Surface
    card.BackgroundTransparency = 0.05
    card.Text = ""
    card.Active = true
    card.Parent = parent
    Corner(UDim.new(0, 14), card)
    Stroke(col or C.A1, 1, 0.72, card)

    local left = Instance.new("Frame")
    left.Size = UDim2.new(0, 44, 0, 44)
    left.Position = UDim2.new(0, 6, 0.5, -22)
    left.BackgroundColor3 = col or C.A1
    left.BackgroundTransparency = 0.15
    left.BorderSizePixel = 0
    left.Parent = card
    Corner(UDim.new(0, 12), left)
    GradV(Color3.fromRGB(130,160,255), Color3.fromRGB(70,90,220), left)

    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(1, 0, 1, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextColor3 = C.White
    ic.TextSize = 22
    ic.Font = Enum.Font.GothamBold
    ic.Parent = left

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -62, 1, 0)
    txt.Position = UDim2.new(0, 60, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = label
    txt.TextColor3 = C.Text
    txt.TextSize = 12
    txt.Font = Enum.Font.GothamSemibold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = card

    return card
end

local function MakeGridButtons(parent, items)
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(0.97, 0, 0, 0)
    grid.AutomaticSize = Enum.AutomaticSize.Y
    grid.BackgroundTransparency = 1
    grid.Parent = parent

    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0.48, 0, 0, 40)
    layout.CellPadding = UDim2.new(0, 6, 0, 6)
    layout.FillDirectionMaxCells = 2
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = grid

    for _, item in ipairs(items) do
        MakeBtn(grid, item.text, item.col, item.cb)
    end

    return grid
end

local function MakeToggle(parent, text, col, cb)
    col = col or C.Green
    local on=false
    local row=Instance.new("Frame")
    row.Size=UDim2.new(0.97,0,0,40); row.BackgroundColor3=C.Card
    row.BackgroundTransparency=0.1; row.BorderSizePixel=0; row.Active=true; row.Parent=parent
    Corner(UDim.new(0,9),row)
    Stroke(C.A1,1,0.78,row)

    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-58,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.TextColor3=C.Text; lbl.TextSize=11
    lbl.Font=Enum.Font.GothamMedium; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row

    local track=Instance.new("TextButton"); track.Size=UDim2.new(0,42,0,22); track.Position=UDim2.new(1,-50,0.5,-11)
    track.BackgroundColor3=C.Track; track.Text=""; track.BorderSizePixel=0; track.Active=true; track.Parent=row
    Corner(UDim.new(0,11),track)

    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,16,0,16); thumb.Position=UDim2.new(0,3,0.5,-8)
    thumb.BackgroundColor3=C.TextSub; thumb.BorderSizePixel=0; thumb.Parent=track
    Corner(UDim.new(1,0),thumb)

    local statLbl=Instance.new("TextLabel"); statLbl.Size=UDim2.new(0,30,0,12); statLbl.Position=UDim2.new(1,-54,0,0)
    statLbl.BackgroundTransparency=1; statLbl.Text="OFF"; statLbl.TextColor3=C.TextMuted
    statLbl.TextSize=8; statLbl.Font=Enum.Font.GothamBold; statLbl.Parent=row

    local function Toggle()
        on=not on
        if on then
            Tween(track,TI.Med,{BackgroundColor3=col})
            Tween(thumb,TI.Spring,{Position=UDim2.new(0,23,0.5,-8),BackgroundColor3=C.White})
            Tween(lbl,TI.Fast,{TextColor3=col})
            statLbl.Text="ON"; statLbl.TextColor3=col
        else
            Tween(track,TI.Med,{BackgroundColor3=C.Track})
            Tween(thumb,TI.Spring,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextSub})
            Tween(lbl,TI.Fast,{TextColor3=C.Text})
            statLbl.Text="OFF"; statLbl.TextColor3=C.TextMuted
        end
        if cb then cb(on) end
    end
    track.MouseButton1Click:Connect(Toggle)
    row.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then Toggle() end
    end)
    return row, function() return on end
end

local function MakeSlider(parent, text, min, max, default, col, cb)
    col = col or C.A1
    local container=Instance.new("Frame")
    container.Size=UDim2.new(0.97,0,0,56); container.BackgroundColor3=C.Card
    container.BackgroundTransparency=0.1; container.BorderSizePixel=0; container.Active=true; container.Parent=parent
    Corner(UDim.new(0,9),container)
    Stroke(C.A1,1,0.78,container)
    Pad(6,6,10,10,container)

    local hdr=Instance.new("Frame"); hdr.Size=UDim2.new(1,-20,0,18); hdr.Position=UDim2.new(0,10,0,6)
    hdr.BackgroundTransparency=1; hdr.Parent=container

    local nameLbl=Instance.new("TextLabel"); nameLbl.Size=UDim2.new(0.72,0,1,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text; nameLbl.TextColor3=C.Text
    nameLbl.TextSize=11; nameLbl.Font=Enum.Font.GothamMedium; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.Parent=hdr

    local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0.28,0,1,0); valLbl.Position=UDim2.new(0.72,0,0,0)
    valLbl.BackgroundTransparency=1; valLbl.Text=tostring(default); valLbl.TextColor3=col
    valLbl.TextSize=11; valLbl.Font=Enum.Font.GothamBold; valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.Parent=hdr

    local track=Instance.new("Frame"); track.Size=UDim2.new(1,-20,0,9); track.Position=UDim2.new(0,10,0,30)
    track.BackgroundColor3=C.Track; track.BorderSizePixel=0; track.Active=true; track.Parent=container
    Corner(UDim.new(1,0),track)

    local initR=(default-min)/(max-min)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new(initR,0,1,0)
    fill.BackgroundColor3=col; fill.BorderSizePixel=0; fill.Parent=track
    Corner(UDim.new(1,0),fill)
    GradH(Color3.lerp(col,C.White,0.3),col,fill)

    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,17,0,17); thumb.Position=UDim2.new(initR,-8.5,0.5,-8.5)
    thumb.BackgroundColor3=C.White; thumb.BorderSizePixel=0; thumb.ZIndex=3; thumb.Active=true; thumb.Parent=track
    Corner(UDim.new(1,0),thumb); Stroke(col,2,0.35,thumb)

    local dragging=false
    local function Update(x)
        local abs=track.AbsoluteSize.X; if abs<=0 then return end
        local ratio=math.clamp((x-track.AbsolutePosition.X)/abs,0,1)
        local val=math.round(min+ratio*(max-min))
        fill.Size=UDim2.new(ratio,0,1,0); thumb.Position=UDim2.new(ratio,-8.5,0.5,-8.5)
        valLbl.Text=tostring(val); if cb then cb(val) end
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; Update(i.Position.X) end
    end)
    thumb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Update(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    return container
end

local function MakeInput(parent, placeholder, cb)
    local container=Instance.new("Frame")
    container.Size=UDim2.new(0.97,0,0,36); container.BackgroundColor3=C.SurfaceAlt
    container.BackgroundTransparency=0.1; container.BorderSizePixel=0; container.Parent=parent
    Corner(UDim.new(0,9),container); Stroke(C.A1,1,0.7,container)

    local box=Instance.new("TextBox"); box.Size=UDim2.new(1,-16,1,-6); box.Position=UDim2.new(0,8,0,3)
    box.BackgroundTransparency=1; box.PlaceholderText=placeholder; box.PlaceholderColor3=C.TextMuted
    box.TextColor3=C.Text; box.TextSize=11; box.Font=Enum.Font.GothamMedium
    box.ClearTextOnFocus=false; box.TextXAlignment=Enum.TextXAlignment.Left; box.Parent=container
    box.FocusLost:Connect(function(enter)
        if enter and box.Text~="" then if cb then cb(box.Text) end; box.Text="" end
    end)
    return container,box
end

local function MakeSectionLabel(parent, text)
    local wrap=Instance.new("Frame")
    wrap.Size=UDim2.new(0.97,0,0,24)
    wrap.BackgroundTransparency=1
    wrap.Parent=parent

    local top=Instance.new("Frame")
    top.Size=UDim2.new(1,0,0,6)
    top.BackgroundTransparency=1
    top.Parent=wrap

    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,0,18)
    lbl.BackgroundTransparency=1; lbl.Text=text
    lbl.TextColor3=C.TextMuted; lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=wrap

    return wrap
end

local function MakeInfoBox(parent, text, h)
    local box=Instance.new("TextLabel"); box.Size=UDim2.new(0.97,0,0,h or 60)
    box.BackgroundColor3=C.Surface; box.BackgroundTransparency=0.08
    box.TextColor3=C.TextSub; box.TextSize=10; box.Font=Enum.Font.GothamMedium
    box.Text=text; box.TextWrapped=true; box.TextXAlignment=Enum.TextXAlignment.Left
    box.Parent=parent; Corner(UDim.new(0,9),box); Stroke(C.A1,1,0.8,box)
    Pad(6,6,8,8,box)
    return box
end

local function MakeSpacer(parent, h)
    local s=Instance.new("Frame")
    s.Size=UDim2.new(0.97,0,0,h or 6)
    s.BackgroundTransparency=1
    s.Parent=parent
    return s
end

local function MakePageHeader(parent, title, sub)
    local head = Instance.new("Frame")
    head.Size = UDim2.new(0.97, 0, 0, 84)
    head.BackgroundColor3 = C.Surface
    head.BackgroundTransparency = 0.03
    head.Parent = parent
    Corner(UDim.new(0, 14), head)
    Stroke(C.A1, 1, 0.78, head)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 24)
    titleLbl.Position = UDim2.new(0, 12, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = C.White
    titleLbl.TextSize = 16
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = head

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -20, 0, 18)
    subLbl.Position = UDim2.new(0, 12, 0, 40)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = C.TextSub
    subLbl.TextSize = 11
    subLbl.Font = Enum.Font.GothamMedium
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Parent = head

    return head
end

local function InsertPageStyle(page)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = page
end

local function MakeHeroCard(parent)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.97, 0, 0, 120)
    card.BackgroundColor3 = C.Surface
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.Parent = parent
    Corner(UDim.new(0, 16), card)
    Stroke(C.A1, 1, 0.78, card)
    GradV(Color3.fromRGB(18, 18, 38), Color3.fromRGB(9, 10, 24), card)

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.BackgroundTransparency = 1
    shadow.Parent = card

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 78, 0, 78)
    avatar.Position = UDim2.new(0, 16, 0.5, -39)
    avatar.BackgroundTransparency = 1
    avatar.Image = ""
    avatar.Parent = card
    Corner(UDim.new(1, 0), avatar)
    Stroke(C.A2, 2, 0.35, avatar)

    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
        end)
        if ok and content then
            avatar.Image = content
        end
    end)

    local greet = Instance.new("TextLabel")
    greet.Size = UDim2.new(1, -118, 0, 24)
    greet.Position = UDim2.new(0, 108, 0, 24)
    greet.BackgroundTransparency = 1
    greet.Text = "مرحبا بك " .. LP.Name
    greet.TextColor3 = C.White
    greet.TextSize = 18
    greet.Font = Enum.Font.GothamBold
    greet.TextXAlignment = Enum.TextXAlignment.Left
    greet.Parent = card

    local welcome = Instance.new("TextLabel")
    welcome.Size = UDim2.new(1, -118, 0, 44)
    welcome.Position = UDim2.new(0, 108, 0, 50)
    welcome.BackgroundTransparency = 1
    welcome.TextWrapped = true
    welcome.Text = "اهلا بك الى ثائر ادمن يمكنك اضافتي على صفحه الانستجرام لتحديثات او تحسينات المقترحه (t2h0a)"
    welcome.TextColor3 = C.TextSub
    welcome.TextSize = 11
    welcome.Font = Enum.Font.GothamMedium
    welcome.TextXAlignment = Enum.TextXAlignment.Left
    welcome.TextYAlignment = Enum.TextYAlignment.Top
    welcome.Parent = card

    task.spawn(function()
        card.BackgroundTransparency = 1
        avatar.ImageTransparency = 1
        greet.TextTransparency = 1
        welcome.TextTransparency = 1
        Tween(card, TI.Med, {BackgroundTransparency = 0.05})
        Tween(avatar, TI.Slow, {ImageTransparency = 0})
        Tween(greet, TI.Med, {TextTransparency = 0})
        Tween(welcome, TI.Med, {TextTransparency = 0})
    end)

    return card
end

-- ════════════════════════════════════════════════════════
--                     الصفحات
-- ════════════════════════════════════════════════════════

-- ── 1. صفحة الطيران والحركة ──────────────────────────
local P1 = CreatePage()
local B1,I1,L1 = AddTab("✈️","طيران",P1)
InsertPageStyle(P1)
MakePageHeader(P1, "THAER X100", "التحكم الكامل بالطيران والجدران والحركة")
MakeHeroCard(P1)
MakeSpacer(P1, 6)
MakeSectionLabel(P1, "  ─── الصفحة الرئيسية")
MakeInfoBox(P1, "اهلا بك الى ثائر ادمن يمكنك اضافتي على صفحه الانستجرام لتحديثات او تحسينات المقترحه (t2h0a)", 52)

MakeSpacer(P1, 6)
MakeSectionLabel(P1, "  ─── الطيران وضع الشبح")
MakeToggle(P1, "✈️  تفعيل الطيران الحر", C.A2, function(v) if v then StartFly() else StopFly() end end)
MakeToggle(P1, "🧱  اختراق الجدران", C.Yellow, function(v) NoClip=v end)
MakeSpacer(P1, 6)
MakeSectionLabel(P1, "  ─── ضبط القيم")
MakeSlider(P1,"⚡ سرعة الطيران",30,600,Settings.FlySpeed,C.A2,function(v) FlySpeed=v; Settings.FlySpeed=v; SaveSettings() end)
MakeSlider(P1,"🏃 سرعة المشي (WalkSpeed)",0,250,Settings.WalkSpd,C.Cyan,function(v) SetWalk(v) end)
MakeSlider(P1,"🚀 قوة القفز (JumpPower)",0,350,Settings.JumpPow,C.Pink,function(v) SetJump(v) end)
MakeSpacer(P1, 6)
MakeSectionLabel(P1, "  ─── اختصارات الكيبورد")
MakeInfoBox(P1,"E: طيران/إيقاف  |  X: جدران\nShift: تسريع  |  C/Z: رفع/خفض السرعة\nF5: إخفاء/إظهار الواجهة",44)

-- ── 2. صفحة المناطق ──────────────────────────────────
local P2 = CreatePage()
AddTab("📍","مناطق",P2)
InsertPageStyle(P2)
MakePageHeader(P2, "المناطق", "احفظ وانتقل بسرعة بين 3 مواقع")

for i=1,3 do
    MakeSpacer(P2, 6)
    MakeSectionLabel(P2, "  ─── المنطقة "..i)
    local row=Instance.new("Frame"); row.Size=UDim2.new(0.97,0,0,40); row.BackgroundTransparency=1; row.Parent=P2
    local rlay=Instance.new("UIListLayout"); rlay.FillDirection=Enum.FillDirection.Horizontal; rlay.Padding=UDim.new(0,6); rlay.Parent=row
    local s=Instance.new("TextButton"); s.Size=UDim2.new(0.47,0,1,0); s.BackgroundColor3=C.A1
    s.BackgroundTransparency=0.18; s.Text="💾 حفظ "..i; s.TextColor3=C.White; s.TextSize=11
    s.Font=Enum.Font.GothamSemibold; s.Active=true; s.Parent=row; Corner(UDim.new(0,9),s)
    local t=Instance.new("TextButton"); t.Size=UDim2.new(0.47,0,1,0); t.BackgroundColor3=C.Green
    t.BackgroundTransparency=0.18; t.Text="🌀 انتقل "..i; t.TextColor3=C.White; t.TextSize=11
    t.Font=Enum.Font.GothamSemibold; t.Active=true; t.Parent=row; Corner(UDim.new(0,9),t)
    s.MouseButton1Click:Connect(function() SaveCP(i); Tween(s,TI.Snap,{BackgroundTransparency=0.45}); task.delay(0.15,function() Tween(s,TI.Fast,{BackgroundTransparency=0.18}) end) end)
    t.MouseButton1Click:Connect(function() LoadCP(i); Tween(t,TI.Snap,{BackgroundTransparency=0.45}); task.delay(0.15,function() Tween(t,TI.Fast,{BackgroundTransparency=0.18}) end) end)
end
MakeSpacer(P2, 6)
MakeSectionLabel(P2,"  ─── اختصارات")
MakeInfoBox(P2,"N/M/K → حفظ المناطق 1/2/3\nB/V/J → انتقل للمناطق 1/2/3",30)

-- ── 3. صفحة الموسيقى ─────────────────────────────────
local P3 = CreatePage()
AddTab("🎵","موسيقى",P3)
InsertPageStyle(P3)
MakePageHeader(P3, "الموسيقى", "تشغيل وتحكم بصوت نظيف وفخم")

local Songs={{"أغنية 1","3017157406"},{"أغنية 2","1843170826"},{"أغنية 3","9126245770"},{"أغنية 4","6698976160"},{"أغنية 5","9032979010"}}
MakeSpacer(P3, 6)
MakeSectionLabel(P3,"  ─── مكتبة الأغاني")
for _, s in Songs do
    MakeBtn(P3,"🎤  "..s[1], C.A3, function() PlaySound(s[2]) end)
end
MakeSpacer(P3, 6)
MakeSectionLabel(P3,"  ─── أغنية مخصصة (اكتب ID ثم Enter)")
MakeInput(P3,"أدخل ID الأغنية…",function(t) PlaySound(t) end)
MakeSpacer(P3, 6)
MakeSectionLabel(P3,"  ─── مستوى الصوت")
MakeSlider(P3,"🔊 الصوت",0,100,50,C.A3,function(v) SoundVol=v/100; if CurrentSound then CurrentSound.Volume=SoundVol end; Settings.SoundVol=v; SaveSettings() end)
MakeBtn(P3,"🔇  إيقاف الموسيقى",C.Red,StopSound)

-- ── 4. صفحة اللاعبين ─────────────────────────────────
local P4 = CreatePage()
AddTab("👥","لاعبين",P4)
InsertPageStyle(P4)
MakePageHeader(P4, "اللاعبين", "تحديد، متابعة، مشاهدة، ورمي")

MakeSpacer(P4, 6)
MakeSectionLabel(P4,"  ─── بحث عن لاعب (أول 3 حروف كافية)")
MakeInput(P4,"اكتب اسم اللاعب ثم Enter…",function(t)
    local p=FindPlayer(t)
    if p then CurrentTarget=p; Notify("✅ محدد",p.Name.." ("..p.DisplayName..")")
    else Notify("❌ خطأ","لا يوجد: "..t) end
end)

MakeSpacer(P4, 6)
MakeSectionLabel(P4,"  ─── أدوات اللاعب المحدد")
MakeGridButtons(P4, {
    {text="🎯  تيليپورت للاعب", col=C.Green, cb=function() if CurrentTarget then TeleToPlayer(CurrentTarget) else Notify("⚠️","اختر لاعب أولاً") end end},
    {text="💫  متابعة اللاعب", col=C.Cyan, cb=function() Following = not Following; if Following and not CurrentTarget then Notify("⚠️","اختر لاعب أولاً") end end},
    {text="👁️  مشاهدة", col=C.A3, cb=function() if CurrentTarget then Spectate(CurrentTarget) else Notify("⚠️","اختر لاعب أولاً") end end},
    {text="⛔  إيقاف المشاهدة", col=C.TextMuted, cb=StopSpectate},
    {text="💥  رمي اللاعب", col=C.Red, cb=function() if CurrentTarget then Fling(CurrentTarget) else Notify("⚠️","اختر لاعب أولاً") end end},
})
MakeBtn(P4,"👁️  إظهار كل التبويبات",C.A1,function()
    for _, p in ipairs(AllPages) do
        p.Visible = true
    end
    Notify("✅ تم","تم إظهار كل التبويبات")
end)

MakeSpacer(P4, 6)
MakeSectionLabel(P4,"  ─── قائمة اللاعبين (اضغط لتحديد)")
local listFrame=Instance.new("Frame"); listFrame.Size=UDim2.new(0.97,0,0,0); listFrame.AutomaticSize=Enum.AutomaticSize.Y
listFrame.BackgroundTransparency=1; listFrame.Parent=P4
ListLayout(Enum.FillDirection.Vertical,Enum.HorizontalAlignment.Center,8,listFrame)

local function RefreshList()
    for _,c in listFrame:GetChildren() do if not c:IsA("UIListLayout") then c:Destroy() end end
    for _,p in Players:GetPlayers() do
        if p~=LP then
            local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=C.SurfaceAlt
            row.BackgroundTransparency=0.2; row.Text="  👤 "..p.Name.."  ("..p.DisplayName..")"
            row.TextColor3=C.Text; row.TextSize=11; row.Font=Enum.Font.GothamMedium
            row.TextXAlignment=Enum.TextXAlignment.Left; row.Active=true; row.Parent=listFrame
            Corner(UDim.new(0,8),row)
            row.MouseButton1Click:Connect(function()
                CurrentTarget=p; Notify("✅ محدد",p.Name)
                Tween(row,TI.Fast,{BackgroundColor3=C.A1,BackgroundTransparency=0.2})
                task.delay(0.5,function() Tween(row,TI.Med,{BackgroundColor3=C.SurfaceAlt,BackgroundTransparency=0.2}) end)
            end)
        end
    end
end
RefreshList()
MakeBtn(P4,"🔄  تحديث القائمة",C.A1,RefreshList)

-- ── 5. صفحة ESP و Aimbot ─────────────────────────────
local P5 = CreatePage()
AddTab("👁️","ESP",P5)
InsertPageStyle(P5)
MakePageHeader(P5, "ESP و Aimbot", "رؤية اللاعبين وقفل الكاميرا")

MakeSpacer(P5, 6)
MakeSectionLabel(P5,"  ─── رؤية اللاعبين (ESP)")
MakeToggle(P5,"👁️  تفعيل ESP — رؤية عبر الجدران",C.Cyan,function(v) ToggleESP(v) end)
MakeToggle(P5,"🎯  Aimbot — قفل الكاميرا على الأقرب",C.Red,function(v) Aimbot_On=v; Notify("🎯 Aimbot",v and "مفعّل" or "إيقاف") end)
MakeToggle(P5,"👤  Follow Player",C.Green,function(v) Following=v end)
MakeBtn(P5,"👁️  Spectate Target",C.A3,function() if CurrentTarget then Spectate(CurrentTarget) else Notify("⚠️","اختر لاعب أولاً") end end)
MakeBtn(P5,"⛔  Stop Spectate",C.TextMuted,StopSpectate)
MakeBtn(P5,"💥  Fling Target",C.Red,function() if CurrentTarget then Fling(CurrentTarget) else Notify("⚠️","اختر لاعب أولاً") end end)
MakeSpacer(P5, 6)
MakeSectionLabel(P5,"  ─── معلومات")
MakeInfoBox(P5,"ESP: يعرض اسم اللاعب ومسافته فوق رأسه عبر الجدران.\n\nAimbot: يقفل الكاميرا على أقرب لاعب تلقائياً.",55)

-- ── 6. صفحة الأمان والإعدادات ──────────────────────────
local P6 = CreatePage()
AddTab("🛡️","أمان",P6)
InsertPageStyle(P6)
MakePageHeader(P6, "الأمان والإعدادات", "حفظ الإعدادات والحماية")

MakeSpacer(P6, 6)
MakeSectionLabel(P6,"  ─── نظام الحماية")
MakeBtn(P6,"🛡️  إعادة تفعيل الحماية",C.Yellow,AntiBan)
MakeBtn(P6,"💾  حفظ الإعدادات",C.Green,function() SaveSettings(); Notify("💾 تم","الإعدادات محفوظة ✅") end)
MakeBtn(P6,"🔄  إعادة تطبيق السرعة والقفز",C.A1,function() SetWalk(WalkSpd); SetJump(JumpPow); Notify("✅ تم","تطبيق القيم") end)
MakeBtn(P6,"✨  إظهار/إخفاء الواجهة",C.Cyan,function()
    if UIHidden then ShowPanel() else HidePanel() end
end)
MakeBtn(P6,"👁️  إظهار كل التبويبات",C.Cyan,function()
    for _, p in ipairs(AllPages) do p.Visible = true end
    Notify("✅ تم","تم إظهار كل الصفحات")
end)

MakeSpacer(P6, 6)
MakeSectionLabel(P6,"  ─── معلومات السكربت")
MakeInfoBox(P6,[[🔥 THAER X100 — Ultimate Edition v3.0

✈ E      → طيران/إيقاف
🧱 X      → اختراق الجدران
📍 N/M/K  → حفظ المناطق 1/2/3
🌀 B/V/J  → انتقل 1/2/3
⚡ C/Z    → رفع/خفض سرعة الطيران
📱 F5    → إخفاء/إظهار الواجهة]],110)

-- ════════════════════════════════════════════════════════
--         تفعيل الصفحة الأولى
-- ════════════════════════════════════════════════════════
SwitchPage(P1, B1, I1, L1)
Tween(I1, TI.Fast, {TextColor3=C.A2})
Tween(L1, TI.Fast, {TextColor3=C.TextSub})

-- إشعار النهاية
task.delay(3.2, function()
    Notify("🔥 THAER X100","مرحباً! جميع الميزات جاهزة 🚀", 4)
end)

print("[THAER X100] ✅ تم التحميل بنجاح")
