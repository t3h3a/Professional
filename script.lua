-- ============================================================
--   THAER X100 | Professional Admin Panel
--   For private/personal Roblox game admin/debug use
--   Single-file LocalScript
--   v1.1.0 — Fixed Fly, Dual Language (AR/EN), Smaller UI
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- LANGUAGE SYSTEM
-- ============================================================

local CurrentLanguage = "EN"

local Lang = {
	EN = {
		-- Sidebar nav
		Home         = "Home",
		Movement     = "Movement",
		Checkpoints  = "Checkpoints",
		Players      = "Players",
		ESP          = "ESP",
		ExternalScripts = "External Scripts",
		Settings     = "Settings",
		-- Home page
		WelcomeMsg   = "Welcome to THAER X100 Admin Panel.\nUse the sidebar to navigate between tools.",
		-- Movement page
		MovementTitle   = "Movement Tools",
		MovementSub     = "Fly, speed, jump and collision debug",
		SectionFlight   = "Flight",
		SectionCharacter= "Character",
		FlyMode         = "✈️  Fly Mode",
		NoClip          = "🧱  NoClip",
		FlySpeed        = "Fly Speed",
		WalkSpeed       = "Walk Speed",
		JumpPower       = "Jump Power",
		ResetCharacter  = "Reset Character",
		-- Checkpoints page
		CheckpointsTitle = "Checkpoints",
		CheckpointsSub   = "Save and teleport to positions",
		Slot             = "Slot",
		Save             = "💾  Save",
		Teleport         = "📍  Teleport",
		-- Players page
		PlayersTitle   = "Player Tools",
		PlayersSub     = "Admin tools for managing players",
		TargetPlayer   = "Target Player",
		PlayerNameHint = "Player name...",
		TeleportTo     = "🔍  Teleport To Player",
		FollowPlayer   = "👣  Follow Player",
		SpectatePlayer = "🎥  Spectate Player",
		StopFollowSpec = "⏹  Stop Follow / Spectate",
		PlayerList     = "Player List",
		-- ESP page
		ESPTitle       = "ESP / Overlay",
		ESPSub         = "Admin visibility tools",
		PlayerOverlay  = "Player Overlay",
		ShowNamesDist  = "👁  Show Player Names & Distance",
		ESPInfo        = "Shows player names and their distance from you as a floating label. Useful for admin monitoring in your game.",
		MusicPlayer    = "Music Player",
		SoundIDHint    = "Sound Asset ID (numbers only)...",
		Volume         = "Volume",
		PlayMusic      = "▶  Play Music",
		StopMusic      = "⏹  Stop Music",
		-- External scripts page
		Scripts        = "Scripts",
		Animations     = "💃 Animations",
		-- Settings page
		SettingsTitle  = "Settings",
		SettingsSub    = "Admin panel configuration",
		General        = "General",
		AntiAFK        = "💤  Anti-AFK",
		Data           = "Data",
		SaveSettings   = "💾  Save Settings",
		ResetDefaults  = "🔄  Reset to Defaults",
		UI             = "UI",
		HidePanel      = "Hide Panel",
		Language       = "Language",
		LangToggle     = "🌐  Switch to Arabic / عربي",
		Version        = "THAER X100  |  v1.1.0  |  For authorized admin use only",
		-- Status bar
		StatFly        = "Fly",
		StatNoClip     = "NoClip",
		StatESP        = "ESP",
		StatAntiAFK    = "AntiAFK",
	},
	AR = {
		-- Sidebar nav
		Home         = "الرئيسية",
		Movement     = "الحركة",
		Checkpoints  = "نقاط الحفظ",
		Players      = "اللاعبين",
		ESP          = "الرادار",
		ExternalScripts = "External Scripts",
		Settings     = "الإعدادات",
		-- Home page
		WelcomeMsg   = "مرحباً في لوحة إدارة THAER X100.\nاستخدم الشريط الجانبي للتنقل بين الأدوات.",
		-- Movement page
		MovementTitle   = "أدوات الحركة",
		MovementSub     = "الطيران والسرعة والقفز وإزالة التصادم",
		SectionFlight   = "الطيران",
		SectionCharacter= "الشخصية",
		FlyMode         = "✈️  وضع الطيران",
		NoClip          = "🧱  اختراق الجدران",
		FlySpeed        = "سرعة الطيران",
		WalkSpeed       = "سرعة المشي",
		JumpPower       = "قوة القفز",
		ResetCharacter  = "إعادة تعيين الشخصية",
		-- Checkpoints page
		CheckpointsTitle = "نقاط الحفظ",
		CheckpointsSub   = "احفظ وانتقل إلى المواقع",
		Slot             = "خانة",
		Save             = "💾  حفظ",
		Teleport         = "📍  انتقال",
		-- Players page
		PlayersTitle   = "أدوات اللاعبين",
		PlayersSub     = "أدوات الإدارة للاعبين",
		TargetPlayer   = "اللاعب المستهدف",
		PlayerNameHint = "اسم اللاعب...",
		TeleportTo     = "🔍  انتقل إلى اللاعب",
		FollowPlayer   = "👣  تتبع اللاعب",
		SpectatePlayer = "🎥  مشاهدة اللاعب",
		StopFollowSpec = "⏹  إيقاف التتبع / المشاهدة",
		PlayerList     = "قائمة اللاعبين",
		-- ESP page
		ESPTitle       = "الرادار / التراكب",
		ESPSub         = "أدوات الرؤية للمشرف",
		PlayerOverlay  = "تراكب اللاعبين",
		ShowNamesDist  = "👁  عرض أسماء اللاعبين والمسافة",
		ESPInfo        = "يعرض أسماء اللاعبين ومسافتهم منك كعلامة عائمة. مفيد لمراقبة المشرف في لعبتك.",
		MusicPlayer    = "مشغل الموسيقى",
		SoundIDHint    = "معرف الصوت (أرقام فقط)...",
		Volume         = "الصوت",
		PlayMusic      = "▶  تشغيل الموسيقى",
		StopMusic      = "⏹  إيقاف الموسيقى",
		-- External scripts page
		Scripts        = "Scripts",
		Animations     = "💃 Animations",
		-- Settings page
		SettingsTitle  = "الإعدادات",
		SettingsSub    = "إعدادات لوحة الإدارة",
		General        = "عام",
		AntiAFK        = "💤  مكافحة الخمول",
		Data           = "البيانات",
		SaveSettings   = "💾  حفظ الإعدادات",
		ResetDefaults  = "🔄  إعادة للافتراضي",
		UI             = "الواجهة",
		HidePanel      = "إخفاء اللوحة",
		Language       = "اللغة",
		LangToggle     = "🌐  Switch to English / إنجليزي",
		Version        = "THAER X100  |  v1.1.0  |  للاستخدام المرخص فقط",
		-- Status bar
		StatFly        = "طيران",
		StatNoClip     = "اختراق",
		StatESP        = "رادار",
		StatAntiAFK    = "مكافحة الخمول",
	},
}

local function T(key)
	return (Lang[CurrentLanguage] and Lang[CurrentLanguage][key]) or key
end

local function IsArabic()
	return CurrentLanguage == "AR"
end

local function GetTextAlign()
	return IsArabic() and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
end

-- ============================================================
-- SETTINGS / STATE
-- ============================================================

local Config = {
	FlySpeed        = 40,
	WalkSpeed       = 16,
	JumpPower       = 50,
	FlyEnabled      = false,
	NoClipEnabled   = false,
	ESPEnabled      = false,
	AntiAFKEnabled  = true,
	MusicVolume     = 0.5,
	CurrentPage     = "Home",
}

local Checkpoints   = {nil, nil, nil}
local FollowTarget  = nil
local SpectateTarget= nil
local SpectateConn  = nil
local FollowConn    = nil
local FlyConn       = nil
local NoClipConn    = nil
local ESPObjects    = {}
local ActiveMusic   = nil

-- ============================================================
-- SAVE / LOAD
-- ============================================================

local function SaveSettings()
	local ok, data = pcall(function()
		return HttpService:JSONEncode({
			FlySpeed    = Config.FlySpeed,
			WalkSpeed   = Config.WalkSpeed,
			JumpPower   = Config.JumpPower,
			MusicVolume = Config.MusicVolume,
		})
	end)
	if ok and writefile then
		pcall(writefile, "thaer_admin_settings.json", data)
	end
end

local function LoadSettings()
	if readfile then
		local ok, raw = pcall(readfile, "thaer_admin_settings.json")
		if ok and raw then
			local ok2, t = pcall(HttpService.JSONDecode, HttpService, raw)
			if ok2 and t then
				for k, v in pairs(t) do Config[k] = v end
			end
		end
	end
end

LoadSettings()

-- ============================================================
-- HELPER
-- ============================================================

local function GetCharacter()
	return LocalPlayer.Character
end

local function GetHumanoid()
	local c = GetCharacter()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
	local c = GetCharacter()
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function SafeGetCharParts()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp  = char:WaitForChild("HumanoidRootPart", 5)
	local hum  = char:WaitForChild("Humanoid", 5)
	return char, hrp, hum
end

local function Tween(obj, props, t, style, dir)
	style = style or Enum.EasingStyle.Quart
	dir   = dir   or Enum.EasingDirection.Out
	TweenService:Create(obj, TweenInfo.new(t or 0.3, style, dir), props):Play()
end

-- ============================================================
-- ANTI-AFK
-- ============================================================

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
	if Config.AntiAFKEnabled then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-- ============================================================
-- FLY SYSTEM (FIXED & STABLE)
-- ============================================================

local function StopFly()
	Config.FlyEnabled = false
	if FlyConn then FlyConn:Disconnect() FlyConn = nil end
	local c = GetCharacter()
	if c then
		for _, v in pairs(c:GetDescendants()) do
			if v.Name == "FlyVelocity" or v.Name == "FlyGyro" then
				pcall(function() v:Destroy() end)
			end
		end
	end
	local h = GetHumanoid()
	if h then
		h:ChangeState(Enum.HumanoidStateType.GettingUp)
		pcall(function() h.PlatformStand = false end)
		-- دفع بسيط للأسفل للتأكد من استجابة الفيزياء فوراً
		local hrp = GetHRP()
		if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, -1, 0) end
	end
end

local function StartFly()
	-- Always cleanly stop any previous fly first
	StopFly()

	-- Safely get character parts (wait if needed)
	local char, hrp, hum
	local ok = pcall(function()
		char, hrp, hum = SafeGetCharParts()
	end)

	if not ok or not hrp or not hum then
		warn("[THAER X100] Fly: Could not get character parts.")
		return
	end

	Config.FlyEnabled = true

	-- Clean up any leftover physics objects
	for _, v in pairs(char:GetDescendants()) do
		if v.Name == "FlyVelocity" or v.Name == "FlyGyro" then
			pcall(function() v:Destroy() end)
		end
	end

	-- Create BodyVelocity
	local bv = Instance.new("BodyVelocity")
	bv.Name     = "FlyVelocity"
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bv.Parent   = hrp

	-- Create BodyGyro
	local bg = Instance.new("BodyGyro")
	bg.Name      = "FlyGyro"
	bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bg.P         = 9000
	bg.D         = 500
	bg.CFrame    = hrp.CFrame
	bg.Parent    = hrp

	FlyConn = RunService.Heartbeat:Connect(function()
		-- Validate everything each tick
		local currentHRP = GetHRP()
		local currentHum = GetHumanoid()

		if not Config.FlyEnabled or not currentHRP or not currentHum then
			StopFly()
			return
		end

		-- التأكد من أن اللاعب غير مثبت برمجياً (Anchored)
		if hrp.Anchored then
			hrp.Anchored = false
		end

		-- Check physics objects still exist
		if not hrp or not hrp.Parent or not bv or not bv.Parent or not bg or not bg.Parent then
			StopFly()
			return
		end

		-- تطبيق حالة السباحة باستمرار لضمان الحركة ومنع التعليق
		if currentHum:GetState() ~= Enum.HumanoidStateType.Swimming then
			currentHum:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		currentHum.PlatformStand = false

		local speed = Config.FlySpeed
		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		if shift then speed = speed * 2 end

		local cam = Camera
		local cf  = cam.CFrame

		local dir = Vector3.zero
		
		-- حساب الاتجاه بناءً على نظر الكاميرا (3D Movement)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			dir = dir + cf.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			dir = dir - cf.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			dir = dir - cf.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			dir = dir + cf.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then -- صعود يدوي
			dir = dir + Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then -- نزول يدوي
			dir = dir - Vector3.new(0, 1, 0)
		end

		if dir.Magnitude > 0 then
			bv.Velocity = dir.Unit * speed
		else
			bv.Velocity = Vector3.zero
		end

		-- Gyro always follows camera horizontal look
		local flatLook = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
		if flatLook.Magnitude > 0.01 then
			bg.CFrame = CFrame.new(Vector3.zero, flatLook)
		end
	end)
end

-- Restart fly if character respawns while fly is "on"
LocalPlayer.CharacterAdded:Connect(function()
	local wasFlying   = Config.FlyEnabled
	local wasNoClip   = Config.NoClipEnabled

	Config.FlyEnabled    = false
	Config.NoClipEnabled = false
	FlyConn    = nil
	NoClipConn = nil

	-- Wait for character to fully load
	task.wait(0.5)

	if wasFlying then
		StartFly()
	end
	if wasNoClip then
		StartNoClip()
	end
end)

-- ============================================================
-- NOCLIP SYSTEM
-- ============================================================

local function StopNoClip()
	Config.NoClipEnabled = false
	if NoClipConn then NoClipConn:Disconnect() NoClipConn = nil end
	local c = GetCharacter()
	if c then
		for _, p in pairs(c:GetDescendants()) do
			if p:IsA("BasePart") then
				pcall(function() p.CanCollide = true end)
			end
		end
	end
end

function StartNoClip()
	Config.NoClipEnabled = true
	NoClipConn = RunService.Stepped:Connect(function()
		if not Config.NoClipEnabled then StopNoClip() return end
		local c = GetCharacter()
		if c then
			for _, p in pairs(c:GetDescendants()) do
				if p:IsA("BasePart") then
					pcall(function() p.CanCollide = false end)
				end
			end
		end
	end)
end

-- ============================================================
-- CHECKPOINTS
-- ============================================================

local function SaveCheckpoint(slot)
	local hrp = GetHRP()
	if hrp then Checkpoints[slot] = hrp.CFrame end
end

local function LoadCheckpoint(slot)
	local cf  = Checkpoints[slot]
	local hrp = GetHRP()
	if cf and hrp then hrp.CFrame = cf end
end

-- ============================================================
-- PLAYER TOOLS
-- ============================================================

local function GetPlayerByName(name)
	name = name:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(name) then return p end
	end
end

local function TeleportToPlayer(target)
	local hrp  = GetHRP()
	local tc   = target.Character
	local thrp = tc and tc:FindFirstChild("HumanoidRootPart")
	if hrp and thrp then
		hrp.CFrame = thrp.CFrame + Vector3.new(3, 0, 0)
	end
end

local function StopFollow()
	if FollowConn then FollowConn:Disconnect() FollowConn = nil end
	FollowTarget = nil
end

local function StartFollow(target)
	StopFollow()
	FollowTarget = target
	FollowConn = RunService.Heartbeat:Connect(function()
		local hrp  = GetHRP()
		local tc   = FollowTarget and FollowTarget.Character
		local thrp = tc and tc:FindFirstChild("HumanoidRootPart")
		if hrp and thrp then
			hrp.CFrame = thrp.CFrame + thrp.CFrame.LookVector * -3
		end
	end)
end

local function StopSpectate()
	if SpectateConn then SpectateConn:Disconnect() SpectateConn = nil end
	SpectateTarget = nil
	Camera.CameraType = Enum.CameraType.Custom
	Camera.CameraSubject = GetHumanoid()
end

local function StartSpectate(target)
	StopSpectate()
	SpectateTarget = target
	Camera.CameraType = Enum.CameraType.Custom
	SpectateConn = RunService.RenderStepped:Connect(function()
		local tc = SpectateTarget and SpectateTarget.Character
		local th = tc and tc:FindFirstChildOfClass("Humanoid")
		if th then
			Camera.CameraSubject = th
		end
	end)
end

-- ============================================================
-- ESP SYSTEM
-- ============================================================

local function ClearESP()
	for _, v in pairs(ESPObjects) do pcall(function() v:Destroy() end) end
	ESPObjects = {}
end

local function BuildESP()
	ClearESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local bb = Instance.new("BillboardGui")
			bb.Name       = "AdminESP"
			bb.AlwaysOnTop= true
			bb.Size        = UDim2.new(0, 110, 0, 36)
			bb.StudsOffset = Vector3.new(0, 3, 0)

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundColor3       = Color3.fromRGB(10, 10, 30)
			lbl.BackgroundTransparency = 0.4
			lbl.Size                   = UDim2.fromScale(1, 1)
			lbl.Font                   = Enum.Font.GothamBold
			lbl.TextColor3             = Color3.fromRGB(140, 100, 255)
			lbl.TextSize               = 12
			lbl.Parent                 = bb

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = lbl

			local function UpdateESP()
				local c  = p.Character
				local hr = c and c:FindFirstChild("HumanoidRootPart")
				local lh = GetHRP()
				if hr and lh then
					local dist = math.floor((hr.Position - lh.Position).Magnitude)
					lbl.Text   = p.Name .. "\n" .. dist .. " studs"
					bb.Adornee = hr
					bb.Parent  = Workspace
				else
					bb.Parent = nil
				end
			end

			local conn = RunService.Heartbeat:Connect(UpdateESP)
			table.insert(ESPObjects, bb)
			table.insert(ESPObjects, {Disconnect = function() conn:Disconnect() end})
		end
	end
end

local function UpdateESPState()
	if Config.ESPEnabled then BuildESP() else ClearESP() end
end

-- ============================================================
-- MUSIC SYSTEM
-- ============================================================

local function PlayMusic(id, vol)
	if ActiveMusic then ActiveMusic:Destroy() ActiveMusic = nil end
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. tostring(id)
	s.Volume  = vol or Config.MusicVolume
	s.Looped  = true
	s.Parent  = SoundService
	s:Play()
	ActiveMusic = s
end

local function StopMusic()
	if ActiveMusic then ActiveMusic:Stop() ActiveMusic:Destroy() ActiveMusic = nil end
end

-- ============================================================
-- GUI BUILDING
-- ============================================================

local old = LocalPlayer.PlayerGui:FindFirstChild("ThaerAdminUI")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "ThaerAdminUI"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent         = LocalPlayer.PlayerGui

-- ============================================================
-- COLOR PALETTE
-- ============================================================

local C = {
	BG        = Color3.fromRGB(8,   10,  22),
	Panel     = Color3.fromRGB(14,  16,  36),
	Sidebar   = Color3.fromRGB(10,  12,  28),
	Card      = Color3.fromRGB(18,  20,  46),
	Accent    = Color3.fromRGB(110, 60,  240),
	AccentB   = Color3.fromRGB(60,  120, 255),
	Text      = Color3.fromRGB(220, 220, 255),
	SubText   = Color3.fromRGB(120, 110, 170),
	Success   = Color3.fromRGB(60,  210, 140),
	Danger    = Color3.fromRGB(230, 70,  90),
	Toggle_On = Color3.fromRGB(110, 60,  240),
	Toggle_Off= Color3.fromRGB(40,  40,  70),
	White     = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
-- UI COMPONENT FUNCTIONS
-- ============================================================

local function AddCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
	return c
end

local function AddStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color     = color or C.Accent
	s.Thickness = thickness or 1.2
	s.Parent    = parent
	return s
end

local function AddGradient(parent, c0, c1, rotation)
	local g = Instance.new("UIGradient")
	g.Color    = ColorSequence.new(c0 or C.Accent, c1 or C.AccentB)
	g.Rotation = rotation or 90
	g.Parent   = parent
	return g
end

local function AddListLayout(parent, padding, direction, halign, valign)
	local l = Instance.new("UIListLayout")
	l.Padding             = UDim.new(0, padding or 6)
	l.FillDirection       = direction or Enum.FillDirection.Vertical
	l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Center
	l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
	l.SortOrder           = Enum.SortOrder.LayoutOrder
	l.Parent              = parent
	return l
end

local function AddPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 6)
	p.PaddingBottom = UDim.new(0, bottom or 6)
	p.PaddingLeft   = UDim.new(0, left   or 6)
	p.PaddingRight  = UDim.new(0, right  or 6)
	p.Parent        = parent
	return p
end

local function MakeSectionLabel(parent, text, order)
	local f = Instance.new("Frame")
	f.Size                = UDim2.new(0.97, 0, 0, 18)
	f.BackgroundTransparency = 1
	f.LayoutOrder         = order or 0
	f.Parent              = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBold
	lbl.Text              = "▸  " .. text:upper()
	lbl.TextColor3        = C.Accent
	lbl.TextSize          = 10
	lbl.TextXAlignment    = GetTextAlign()
	lbl.Parent            = f
	return f, lbl
end

local function MakePageHeader(parent, titleKey, subtitleKey, order)
	local f = Instance.new("Frame")
	f.Size            = UDim2.new(0.97, 0, 0, 50)
	f.BackgroundColor3= C.Card
	f.LayoutOrder     = order or 0
	f.Parent          = parent
	AddCorner(f, 10)
	AddStroke(f, C.Accent, 1)

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 80)),
	})
	grad.Rotation = 135
	grad.Parent   = f

	local t = Instance.new("TextLabel")
	t.Position        = UDim2.new(0, 12, 0, 7)
	t.Size            = UDim2.new(1, -12, 0, 20)
	t.BackgroundTransparency = 1
	t.Font            = Enum.Font.GothamBold
	t.Text            = T(titleKey)
	t.TextColor3      = C.White
	t.TextSize        = 15
	t.TextXAlignment  = GetTextAlign()
	t.Parent          = f

	local s = Instance.new("TextLabel")
	s.Position        = UDim2.new(0, 12, 0, 29)
	s.Size            = UDim2.new(1, -12, 0, 14)
	s.BackgroundTransparency = 1
	s.Font            = Enum.Font.Gotham
	s.Text            = T(subtitleKey)
	s.TextColor3      = C.SubText
	s.TextSize        = 10
	s.TextXAlignment  = GetTextAlign()
	s.Parent          = f
	return f, t, s
end

local function MakeButton(parent, textKey, color, order, callback)
	color = color or C.Accent
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(0.97, 0, 0, 34)
	btn.BackgroundColor3 = color
	btn.Font             = Enum.Font.GothamBold
	btn.Text             = T(textKey)
	btn.TextColor3       = C.White
	btn.TextSize         = 12
	btn.AutoButtonColor  = false
	btn.LayoutOrder      = order or 0
	btn.Parent           = parent
	AddCorner(btn, 7)
	AddStroke(btn, color, 1)

	btn.MouseEnter:Connect(function()
		Tween(btn, {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.15)}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, {BackgroundColor3 = color}, 0.15)
	end)
	btn.MouseButton1Click:Connect(function()
		Tween(btn, {Size = UDim2.new(0.93, 0, 0, 31)}, 0.07)
		task.delay(0.07, function() Tween(btn, {Size = UDim2.new(0.97, 0, 0, 34)}, 0.1) end)
		if callback then callback() end
	end)
	return btn
end

-- Raw text version of MakeButton (for non-key strings)
local function MakeButtonRaw(parent, text, color, order, callback)
	color = color or C.Accent
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(0.97, 0, 0, 34)
	btn.BackgroundColor3 = color
	btn.Font             = Enum.Font.GothamBold
	btn.Text             = text
	btn.TextColor3       = C.White
	btn.TextSize         = 12
	btn.AutoButtonColor  = false
	btn.LayoutOrder      = order or 0
	btn.Parent           = parent
	AddCorner(btn, 7)
	AddStroke(btn, color, 1)

	btn.MouseEnter:Connect(function()
		Tween(btn, {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.15)}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, {BackgroundColor3 = color}, 0.15)
	end)
	btn.MouseButton1Click:Connect(function()
		Tween(btn, {Size = UDim2.new(0.93, 0, 0, 31)}, 0.07)
		task.delay(0.07, function() Tween(btn, {Size = UDim2.new(0.97, 0, 0, 34)}, 0.1) end)
		if callback then callback() end
	end)
	return btn
end

local function MakeToggle(parent, textKey, state, order, callback)
	local frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0.97, 0, 0, 34)
	frame.BackgroundColor3 = C.Card
	frame.LayoutOrder      = order or 0
	frame.Parent           = parent
	AddCorner(frame, 7)
	AddStroke(frame, C.Accent, 1)

	local lbl = Instance.new("TextLabel")
	lbl.Position         = UDim2.new(0, 10, 0, 0)
	lbl.Size             = UDim2.new(1, -64, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font             = Enum.Font.Gotham
	lbl.Text             = T(textKey)
	lbl.TextColor3       = C.Text
	lbl.TextSize         = 12
	lbl.TextXAlignment   = GetTextAlign()
	lbl.Parent           = frame

	local track = Instance.new("Frame")
	track.Position       = UDim2.new(1, -48, 0.5, -9)
	track.Size           = UDim2.new(0, 38, 0, 18)
	track.BackgroundColor3 = state and C.Toggle_On or C.Toggle_Off
	track.Parent         = frame
	AddCorner(track, 9)

	local knob = Instance.new("Frame")
	knob.Position        = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	knob.Size            = UDim2.new(0, 15, 0, 15)
	knob.BackgroundColor3= C.White
	knob.Parent          = track
	AddCorner(knob, 8)

	local current = state or false
	local btn = Instance.new("TextButton")
	btn.Size               = UDim2.fromScale(1, 1)
	btn.BackgroundTransparency = 1
	btn.Text               = ""
	btn.Parent             = frame

	btn.MouseButton1Click:Connect(function()
		current = not current
		Tween(track, {BackgroundColor3 = current and C.Toggle_On or C.Toggle_Off}, 0.2)
		Tween(knob, {Position = current and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,2,0.5,-7)}, 0.2)
		if callback then callback(current) end
	end)

	return frame, function(v)
		current = v
		Tween(track, {BackgroundColor3 = v and C.Toggle_On or C.Toggle_Off}, 0.2)
		Tween(knob, {Position = v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,2,0.5,-7)}, 0.2)
	end, lbl
end

local function MakeSlider(parent, textKey, min, max, value, order, callback)
	local frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0.97, 0, 0, 52)
	frame.BackgroundColor3 = C.Card
	frame.LayoutOrder      = order or 0
	frame.Parent           = parent
	AddCorner(frame, 7)
	AddStroke(frame, C.Accent, 1)

	local lbl = Instance.new("TextLabel")
	lbl.Position           = UDim2.new(0, 10, 0, 5)
	lbl.Size               = UDim2.new(0.6, 0, 0, 17)
	lbl.BackgroundTransparency = 1
	lbl.Font               = Enum.Font.Gotham
	lbl.Text               = T(textKey)
	lbl.TextColor3         = C.Text
	lbl.TextSize           = 12
	lbl.TextXAlignment     = GetTextAlign()
	lbl.Parent             = frame

	local valLbl = Instance.new("TextLabel")
	valLbl.Position        = UDim2.new(0.6, 0, 0, 5)
	valLbl.Size            = UDim2.new(0.37, 0, 0, 17)
	valLbl.BackgroundTransparency = 1
	valLbl.Font            = Enum.Font.GothamBold
	valLbl.Text            = tostring(value)
	valLbl.TextColor3      = C.Accent
	valLbl.TextSize        = 12
	valLbl.TextXAlignment  = Enum.TextXAlignment.Right
	valLbl.Parent          = frame

	local track = Instance.new("Frame")
	track.Position         = UDim2.new(0, 10, 0, 30)
	track.Size             = UDim2.new(1, -20, 0, 5)
	track.BackgroundColor3 = C.Sidebar
	track.Parent           = frame
	AddCorner(track, 3)

	local fill = Instance.new("Frame")
	fill.Size              = UDim2.new((value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3  = C.Accent
	fill.Parent            = track
	AddCorner(fill, 3)

	local knob = Instance.new("Frame")
	knob.AnchorPoint       = Vector2.new(0.5, 0.5)
	knob.Position          = UDim2.new((value - min)/(max - min), 0, 0.5, 0)
	knob.Size              = UDim2.new(0, 12, 0, 12)
	knob.BackgroundColor3  = C.White
	knob.Parent            = track
	AddCorner(knob, 6)

	local dragging = false
	local function Update(x)
		local abs  = track.AbsolutePosition.X
		local wid  = track.AbsoluteSize.X
		local pct  = math.clamp((x - abs) / wid, 0, 1)
		local val  = math.floor(min + pct * (max - min))
		Tween(fill,  {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
		Tween(knob,  {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.05)
		valLbl.Text = tostring(val)
		if callback then callback(val) end
	end

	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or
		   i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			Update(i.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or
			i.UserInputType == Enum.UserInputType.Touch) then
			Update(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or
		   i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	return frame, lbl
end

local function MakeInput(parent, placeholderKey, order, callback)
	local frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0.97, 0, 0, 34)
	frame.BackgroundColor3 = C.Card
	frame.LayoutOrder      = order or 0
	frame.Parent           = parent
	AddCorner(frame, 7)
	AddStroke(frame, C.Accent, 1)

	local tb = Instance.new("TextBox")
	tb.Size               = UDim2.new(1, -14, 1, 0)
	tb.Position           = UDim2.new(0, 7, 0, 0)
	tb.BackgroundTransparency = 1
	tb.Font               = Enum.Font.Gotham
	tb.PlaceholderText    = T(placeholderKey)
	tb.PlaceholderColor3  = C.SubText
	tb.Text               = ""
	tb.TextColor3         = C.Text
	tb.TextSize           = 12
	tb.TextXAlignment     = GetTextAlign()
	tb.ClearTextOnFocus   = false
	tb.Parent             = frame

	tb.Focused:Connect(function()
		Tween(frame, {BackgroundColor3 = C.Card:Lerp(C.Accent, 0.1)}, 0.2)
	end)
	tb.FocusLost:Connect(function(enter)
		Tween(frame, {BackgroundColor3 = C.Card}, 0.2)
		if enter and callback then callback(tb.Text) end
	end)
	return frame, tb
end

local function MakeHeroCard(parent, order)
	local card = Instance.new("Frame")
	card.Size             = UDim2.new(0.97, 0, 0, 90)
	card.BackgroundColor3 = C.Card
	card.LayoutOrder      = order or 0
	card.Parent           = parent
	AddCorner(card, 12)
	AddStroke(card, C.Accent, 1.5)

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(40, 10, 100)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 20, 80)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 40, 90)),
	})
	grad.Rotation = 120
	grad.Parent   = card

	local img = Instance.new("ImageLabel")
	img.Position       = UDim2.new(0, 10, 0.5, -28)
	img.Size           = UDim2.new(0, 56, 0, 56)
	img.BackgroundColor3 = C.BG
	img.Image          = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
	img.Parent         = card
	AddCorner(img, 28)
	AddStroke(img, C.Accent, 2)

	local name = Instance.new("TextLabel")
	name.Position      = UDim2.new(0, 76, 0, 18)
	name.Size          = UDim2.new(1, -90, 0, 22)
	name.BackgroundTransparency = 1
	name.Font          = Enum.Font.GothamBold
	name.Text          = LocalPlayer.DisplayName
	name.TextColor3    = C.White
	name.TextSize      = 17
	name.TextXAlignment= Enum.TextXAlignment.Left
	name.Parent        = card

	local uname = Instance.new("TextLabel")
	uname.Position     = UDim2.new(0, 76, 0, 40)
	uname.Size         = UDim2.new(1, -90, 0, 15)
	uname.BackgroundTransparency = 1
	uname.Font         = Enum.Font.Gotham
	uname.Text         = "@" .. LocalPlayer.Name
	uname.TextColor3   = C.SubText
	uname.TextSize     = 11
	uname.TextXAlignment = Enum.TextXAlignment.Left
	uname.Parent       = card

	local badge = Instance.new("TextLabel")
	badge.Position     = UDim2.new(0, 76, 0, 60)
	badge.Size         = UDim2.new(0, 70, 0, 17)
	badge.BackgroundColor3 = C.Accent
	badge.Font         = Enum.Font.GothamBold
	badge.Text         = "⚙ ADMIN"
	badge.TextColor3   = C.White
	badge.TextSize     = 9
	badge.Parent       = card
	AddCorner(badge, 5)
	return card
end

-- ============================================================
-- SPLASH SCREEN
-- ============================================================

local Splash = Instance.new("Frame")
Splash.Name             = "Splash"
Splash.Size             = UDim2.fromScale(1, 1)
Splash.BackgroundColor3 = C.BG
Splash.ZIndex           = 100
Splash.Parent           = ScreenGui

local splashGrad = Instance.new("UIGradient")
splashGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(4, 4, 20)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 4, 30)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(4, 8, 25)),
})
splashGrad.Rotation = 135
splashGrad.Parent   = Splash

for i = 1, 3 do
	local orb = Instance.new("Frame")
	orb.AnchorPoint        = Vector2.new(0.5, 0.5)
	orb.Position           = UDim2.new(math.random(20, 80)/100, 0, math.random(20, 80)/100, 0)
	orb.Size               = UDim2.new(0, 180, 0, 180)
	orb.BackgroundColor3   = i == 1 and Color3.fromRGB(80, 0, 180) or
	                          i == 2 and Color3.fromRGB(0, 60, 200) or
	                                     Color3.fromRGB(120, 0, 150)
	orb.BackgroundTransparency = 0.85
	orb.ZIndex             = 99
	orb.Parent             = Splash
	AddCorner(orb, 100)
end

local logoFrame = Instance.new("Frame")
logoFrame.AnchorPoint        = Vector2.new(0.5, 0.5)
logoFrame.Position           = UDim2.new(0.5, 0, 0.42, 0)
logoFrame.Size               = UDim2.new(0, 300, 0, 80)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex             = 101
logoFrame.Parent             = Splash

local logoText = Instance.new("TextLabel")
logoText.Size                = UDim2.fromScale(1, 0.6)
logoText.BackgroundTransparency = 1
logoText.Font                = Enum.Font.GothamBlack
logoText.Text                = "THAER X100"
logoText.TextColor3          = C.White
logoText.TextSize            = 38
logoText.ZIndex              = 102
logoText.Parent              = logoFrame

local logoGrad = Instance.new("UIGradient")
logoGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 80,  255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 160, 255)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  60,  240)),
})
logoGrad.Rotation = 45
logoGrad.Parent   = logoText

local logoSub = Instance.new("TextLabel")
logoSub.Size                = UDim2.new(1, 0, 0.38, 0)
logoSub.Position            = UDim2.new(0, 0, 0.62, 0)
logoSub.BackgroundTransparency = 1
logoSub.Font                = Enum.Font.Gotham
logoSub.Text                = "Professional Admin Panel"
logoSub.TextColor3          = C.SubText
logoSub.TextSize            = 13
logoSub.ZIndex              = 102
logoSub.Parent              = logoFrame

local barBG = Instance.new("Frame")
barBG.AnchorPoint           = Vector2.new(0.5, 0.5)
barBG.Position              = UDim2.new(0.5, 0, 0.65, 0)
barBG.Size                  = UDim2.new(0, 280, 0, 4)
barBG.BackgroundColor3      = C.Sidebar
barBG.ZIndex                = 101
barBG.Parent                = Splash
AddCorner(barBG, 2)

local barFill = Instance.new("Frame")
barFill.Size                = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3    = C.Accent
barFill.ZIndex              = 102
barFill.Parent              = barBG
AddCorner(barFill, 2)
AddGradient(barFill, Color3.fromRGB(120, 60, 255), Color3.fromRGB(60, 120, 255), 90)

local loadingLbl = Instance.new("TextLabel")
loadingLbl.AnchorPoint      = Vector2.new(0.5, 0.5)
loadingLbl.Position         = UDim2.new(0.5, 0, 0.72, 0)
loadingLbl.Size             = UDim2.new(0, 300, 0, 20)
loadingLbl.BackgroundTransparency = 1
loadingLbl.Font             = Enum.Font.Gotham
loadingLbl.Text             = "Initializing systems..."
loadingLbl.TextColor3       = C.SubText
loadingLbl.TextSize         = 11
loadingLbl.ZIndex           = 101
loadingLbl.Parent           = Splash

local loadingMessages = {
	"Initializing systems...",
	"Loading UI components...",
	"Connecting to game services...",
	"Setting up admin tools...",
	"Applying visual effects...",
	"Almost ready...",
	"Welcome, Admin!",
}

-- ============================================================
-- MAIN PANEL
-- ============================================================

local MainPanel = Instance.new("Frame")
MainPanel.Name              = "MainPanel"
MainPanel.AnchorPoint       = Vector2.new(0.5, 0.5)
MainPanel.Position          = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.Size              = UDim2.new(0, 580, 0, 380)  -- Reduced from 700x460
MainPanel.BackgroundColor3  = C.BG
MainPanel.Visible           = false
MainPanel.Parent            = ScreenGui
AddCorner(MainPanel, 14)
AddStroke(MainPanel, C.Accent, 1.5)

local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 12, 28)),
})
panelGrad.Rotation = 130
panelGrad.Parent   = MainPanel

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = C.Sidebar
TitleBar.Parent           = MainPanel
AddCorner(TitleBar, 14)

local tbMask = Instance.new("Frame")
tbMask.Position           = UDim2.new(0, 0, 0.5, 0)
tbMask.Size               = UDim2.new(1, 0, 0.5, 0)
tbMask.BackgroundColor3   = C.Sidebar
tbMask.BorderSizePixel    = 0
tbMask.Parent             = TitleBar

local tbTitle = Instance.new("TextLabel")
tbTitle.Position          = UDim2.new(0, 14, 0, 0)
tbTitle.Size              = UDim2.new(0.5, 0, 1, 0)
tbTitle.BackgroundTransparency = 1
tbTitle.Font              = Enum.Font.GothamBold
tbTitle.Text              = "THAER X100  ·  Admin Panel"
tbTitle.TextColor3        = C.Text
tbTitle.TextSize          = 11
tbTitle.TextXAlignment    = Enum.TextXAlignment.Left
tbTitle.Parent            = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Position         = UDim2.new(1, -32, 0.5, -11)
CloseBtn.Size             = UDim2.new(0, 22, 0, 22)
CloseBtn.BackgroundColor3 = C.Danger
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = C.White
CloseBtn.TextSize         = 10
CloseBtn.Parent           = TitleBar
AddCorner(CloseBtn, 11)

local MinBtn = Instance.new("TextButton")
MinBtn.Position           = UDim2.new(1, -58, 0.5, -11)
MinBtn.Size               = UDim2.new(0, 22, 0, 22)
MinBtn.BackgroundColor3   = Color3.fromRGB(220, 160, 30)
MinBtn.Font               = Enum.Font.GothamBold
MinBtn.Text               = "−"
MinBtn.TextColor3         = C.White
MinBtn.TextSize           = 12
MinBtn.Parent             = TitleBar
AddCorner(MinBtn, 11)

-- Sidebar (narrowed slightly)
local SIDEBAR_W = 118

local Sidebar = Instance.new("Frame")
Sidebar.Name              = "Sidebar"
Sidebar.Position          = UDim2.new(0, 0, 0, 36)
Sidebar.Size              = UDim2.new(0, SIDEBAR_W, 1, -36)
Sidebar.BackgroundColor3  = C.Sidebar
Sidebar.Parent            = MainPanel

local sbMaskTop = Instance.new("Frame")
sbMaskTop.Size            = UDim2.new(1, 0, 0, 8)
sbMaskTop.BackgroundColor3= C.Sidebar
sbMaskTop.BorderSizePixel = 0
sbMaskTop.Parent          = Sidebar

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius     = UDim.new(0, 14)
sbCorner.Parent           = Sidebar

local sbMaskBR = Instance.new("Frame")
sbMaskBR.Position         = UDim2.new(0.5, 0, 0, 0)
sbMaskBR.Size             = UDim2.new(0.5, 0, 1, 0)
sbMaskBR.BackgroundColor3 = C.Sidebar
sbMaskBR.BorderSizePixel  = 0
sbMaskBR.Parent           = Sidebar

local sbMaskTop2 = Instance.new("Frame")
sbMaskTop2.Size           = UDim2.new(1, 0, 0, 14)
sbMaskTop2.BackgroundColor3= C.Sidebar
sbMaskTop2.BorderSizePixel= 0
sbMaskTop2.Parent         = Sidebar

local sbBrand = Instance.new("TextLabel")
sbBrand.Position          = UDim2.new(0, 0, 0, 10)
sbBrand.Size              = UDim2.new(1, 0, 0, 26)
sbBrand.BackgroundTransparency = 1
sbBrand.Font              = Enum.Font.GothamBlack
sbBrand.Text              = "TX100"
sbBrand.TextColor3        = C.Accent
sbBrand.TextSize          = 15
sbBrand.Parent            = Sidebar

local sbNav = Instance.new("Frame")
sbNav.Position            = UDim2.new(0, 0, 0, 44)
sbNav.Size                = UDim2.new(1, 0, 1, -44)
sbNav.BackgroundTransparency = 1
sbNav.Parent              = Sidebar

AddListLayout(sbNav, 3, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
AddPadding(sbNav, 3, 3, 5, 5)

-- Content area
local ContentArea = Instance.new("Frame")
ContentArea.Name          = "Content"
ContentArea.Position      = UDim2.new(0, SIDEBAR_W, 0, 36)
ContentArea.Size          = UDim2.new(1, -SIDEBAR_W, 1, -36)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent        = MainPanel

-- ============================================================
-- PAGE CONTAINERS
-- ============================================================

local Pages = {}

local function MakePage(name)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name               = name
	scroll.Size               = UDim2.fromScale(1, 1)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = C.Accent
	scroll.CanvasSize         = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize= Enum.AutomaticSize.Y
	scroll.Visible            = false
	scroll.Parent             = ContentArea

	AddListLayout(scroll, 6, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
	AddPadding(scroll, 8, 8, 5, 5)

	Pages[name] = scroll
	return scroll
end

local PageHome        = MakePage("Home")
local PageMovement    = MakePage("Movement")
local PageCheckpoints = MakePage("Checkpoints")
local PagePlayers     = MakePage("Players")
local PageESP         = MakePage("ESP")
local PageExternalScripts = MakePage("ExternalScripts")
local PageSettings    = MakePage("Settings")

-- ============================================================
-- SIDEBAR NAVIGATION
-- ============================================================

local navDefs = {
	{icon = "🏠", labelKey = "Home",        page = "Home"},
	{icon = "✈️",  labelKey = "Movement",    page = "Movement"},
	{icon = "📍", labelKey = "Checkpoints", page = "Checkpoints"},
	{icon = "👥", labelKey = "Players",     page = "Players"},
	{icon = "👁",  labelKey = "ESP",         page = "ESP"},
	{icon = "📜", labelKey = "ExternalScripts", page = "ExternalScripts"},
	{icon = "⚙️",  labelKey = "Settings",    page = "Settings"},
}

local navBtns = {}

local function ShowPage(name)
	for n, pg in pairs(Pages) do
		pg.Visible = (n == name)
	end
	for _, nb in pairs(navBtns) do
		local active = (nb.pageName == name)
		Tween(nb.frame, {BackgroundColor3 = active and C.Accent or Color3.fromRGB(0, 0, 0)}, 0.2)
		Tween(nb.frame, {BackgroundTransparency = active and 0 or 1}, 0.2)
		nb.lbl.TextColor3 = active and C.White or C.SubText
	end
	Config.CurrentPage = name
end

for i, def in ipairs(navDefs) do
	local btn = Instance.new("TextButton")
	btn.Size               = UDim2.new(1, -4, 0, 30)
	btn.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
	btn.BackgroundTransparency = 1
	btn.Text               = ""
	btn.LayoutOrder        = i
	btn.Parent             = sbNav
	AddCorner(btn, 7)

	local iconL = Instance.new("TextLabel")
	iconL.Position         = UDim2.new(0, 7, 0.5, -8)
	iconL.Size             = UDim2.new(0, 18, 0, 16)
	iconL.BackgroundTransparency = 1
	iconL.Font             = Enum.Font.GothamBold
	iconL.Text             = def.icon
	iconL.TextSize         = 13
	iconL.TextColor3       = C.SubText
	iconL.Parent           = btn

	local lbl = Instance.new("TextLabel")
	lbl.Position           = UDim2.new(0, 28, 0.5, -8)
	lbl.Size               = UDim2.new(1, -32, 0, 16)
	lbl.BackgroundTransparency = 1
	lbl.Font               = Enum.Font.Gotham
	lbl.Text               = T(def.labelKey)
	lbl.TextSize           = 11
	lbl.TextColor3         = C.SubText
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.Parent             = btn

	table.insert(navBtns, {frame = btn, lbl = lbl, pageName = def.page, labelKey = def.labelKey, iconL = iconL})

	btn.MouseButton1Click:Connect(function() ShowPage(def.page) end)
	btn.MouseEnter:Connect(function()
		if Config.CurrentPage ~= def.page then
			Tween(btn, {BackgroundTransparency = 0.7}, 0.12)
			Tween(btn, {BackgroundColor3 = C.Accent}, 0.12)
		end
	end)
	btn.MouseLeave:Connect(function()
		if Config.CurrentPage ~= def.page then
			Tween(btn, {BackgroundTransparency = 1}, 0.12)
		end
	end)
end

-- ============================================================
-- LANGUAGE REFRESH (updates all translatable UI elements)
-- ============================================================

-- We collect references to all translatable labels so we can refresh them
local TranslatableElements = {}  -- {type="label"/"textbox", obj=..., key=...}

-- ============================================================
-- PAGE: HOME
-- ============================================================

MakeHeroCard(PageHome, 1)

local statusCard = Instance.new("Frame")
statusCard.Size             = UDim2.new(0.97, 0, 0, 58)
statusCard.BackgroundColor3 = C.Card
statusCard.LayoutOrder      = 2
statusCard.Parent           = PageHome
AddCorner(statusCard, 8)
AddStroke(statusCard, C.AccentB, 1)

local statusList = Instance.new("UIListLayout")
statusList.FillDirection    = Enum.FillDirection.Horizontal
statusList.Padding          = UDim.new(0, 0)
statusList.HorizontalAlignment = Enum.HorizontalAlignment.Left
statusList.VerticalAlignment   = Enum.VerticalAlignment.Center
statusList.Parent           = statusCard

local statItems = {
	{lbl = "StatFly",    val = function() return Config.FlyEnabled      and "ON" or "OFF" end, color = function() return Config.FlyEnabled      and C.Success or C.SubText end},
	{lbl = "StatNoClip", val = function() return Config.NoClipEnabled   and "ON" or "OFF" end, color = function() return Config.NoClipEnabled   and C.Success or C.SubText end},
	{lbl = "StatESP",    val = function() return Config.ESPEnabled      and "ON" or "OFF" end, color = function() return Config.ESPEnabled      and C.Success or C.SubText end},
	{lbl = "StatAntiAFK",val = function() return Config.AntiAFKEnabled  and "ON" or "OFF" end, color = function() return Config.AntiAFKEnabled  and C.Success or C.SubText end},
}

local statValueLabels = {}
for _, si in ipairs(statItems) do
	local col = Instance.new("Frame")
	col.Size               = UDim2.new(0.25, 0, 1, 0)
	col.BackgroundTransparency = 1
	col.Parent             = statusCard

	local vl = Instance.new("TextLabel")
	vl.Size                = UDim2.new(1, 0, 0.52, 0)
	vl.Position            = UDim2.new(0, 0, 0.08, 0)
	vl.BackgroundTransparency = 1
	vl.Font                = Enum.Font.GothamBold
	vl.Text                = si.val()
	vl.TextColor3          = si.color()
	vl.TextSize            = 12
	vl.Parent              = col

	local ll = Instance.new("TextLabel")
	ll.Size                = UDim2.new(1, 0, 0.35, 0)
	ll.Position            = UDim2.new(0, 0, 0.6, 0)
	ll.BackgroundTransparency = 1
	ll.Font                = Enum.Font.Gotham
	ll.Text                = T(si.lbl)
	ll.TextColor3          = C.SubText
	ll.TextSize            = 9
	ll.Parent              = col

	table.insert(statValueLabels, {vl = vl, ll = ll, si = si})
end

RunService.Heartbeat:Connect(function()
	for _, sv in pairs(statValueLabels) do
		sv.vl.Text       = sv.si.val()
		sv.vl.TextColor3 = sv.si.color()
	end
end)

local infoTxt = Instance.new("TextLabel")
infoTxt.Size               = UDim2.new(0.97, 0, 0, 30)
infoTxt.BackgroundTransparency = 1
infoTxt.Font               = Enum.Font.Gotham
infoTxt.Text               = T("WelcomeMsg")
infoTxt.TextColor3         = C.SubText
infoTxt.TextSize           = 10
infoTxt.TextWrapped        = true
infoTxt.LayoutOrder        = 3
infoTxt.TextXAlignment     = GetTextAlign()
infoTxt.Parent             = PageHome

-- ============================================================
-- PAGE: MOVEMENT
-- ============================================================

local movHeader, movHeaderT, movHeaderS = MakePageHeader(PageMovement, "MovementTitle", "MovementSub", 1)
local movSec1, movSec1L = MakeSectionLabel(PageMovement, T("SectionFlight"), 2)

local _, flyToggleUpdate, flyToggleLbl
_, flyToggleUpdate, flyToggleLbl = MakeToggle(PageMovement, "FlyMode", false, 3, function(v)
	if v then StartFly() else StopFly() end
end)

local flySlider, flySliderLbl = MakeSlider(PageMovement, "FlySpeed", 5, 200, Config.FlySpeed, 4, function(v)
	Config.FlySpeed = v
end)

local movSec2, movSec2L = MakeSectionLabel(PageMovement, T("SectionCharacter"), 5)

local _, noclipUpdate, noclipToggleLbl
_, noclipUpdate, noclipToggleLbl = MakeToggle(PageMovement, "NoClip", false, 6, function(v)
	if v then StartNoClip() else StopNoClip() end
end)

local wsSlider, wsSliderLbl = MakeSlider(PageMovement, "WalkSpeed", 1, 200, Config.WalkSpeed, 7, function(v)
	Config.WalkSpeed = v
	local h = GetHumanoid()
	if h then h.WalkSpeed = v end
end)

local jpSlider, jpSliderLbl = MakeSlider(PageMovement, "JumpPower", 1, 200, Config.JumpPower, 8, function(v)
	Config.JumpPower = v
	local h = GetHumanoid()
	if h then h.JumpPower = v end
end)

local resetCharBtn = MakeButton(PageMovement, "ResetCharacter", C.Danger, 9, function()
	local h = GetHumanoid()
	if h then h.Health = 0 end
end)

-- ============================================================
-- PAGE: CHECKPOINTS
-- ============================================================

local cpHeader, cpHeaderT, cpHeaderS = MakePageHeader(PageCheckpoints, "CheckpointsTitle", "CheckpointsSub", 1)
local cpSlotLabels = {}
local cpSaveBtns   = {}
local cpLoadBtns   = {}

for i = 1, 3 do
	local _, slbl = MakeSectionLabel(PageCheckpoints, T("Slot") .. " " .. i, (i-1)*3 + 2)
	table.insert(cpSlotLabels, slbl)

	local row = Instance.new("Frame")
	row.Size               = UDim2.new(0.97, 0, 0, 34)
	row.BackgroundTransparency = 1
	row.LayoutOrder        = (i-1)*3 + 3
	row.Parent             = PageCheckpoints

	local rowList = Instance.new("UIListLayout")
	rowList.FillDirection  = Enum.FillDirection.Horizontal
	rowList.Padding        = UDim.new(0, 6)
	rowList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	rowList.VerticalAlignment   = Enum.VerticalAlignment.Center
	rowList.Parent         = row

	local saveBtn = Instance.new("TextButton")
	saveBtn.Size           = UDim2.new(0.47, 0, 0, 34)
	saveBtn.BackgroundColor3 = C.AccentB
	saveBtn.Font           = Enum.Font.GothamBold
	saveBtn.Text           = T("Save")
	saveBtn.TextColor3     = C.White
	saveBtn.TextSize       = 12
	saveBtn.Parent         = row
	AddCorner(saveBtn, 7)
	table.insert(cpSaveBtns, saveBtn)

	local loadBtn = Instance.new("TextButton")
	loadBtn.Size           = UDim2.new(0.47, 0, 0, 34)
	loadBtn.BackgroundColor3 = C.Accent
	loadBtn.Font           = Enum.Font.GothamBold
	loadBtn.Text           = T("Teleport")
	loadBtn.TextColor3     = C.White
	loadBtn.TextSize       = 12
	loadBtn.Parent         = row
	AddCorner(loadBtn, 7)
	table.insert(cpLoadBtns, loadBtn)

	local slot = i
	saveBtn.MouseButton1Click:Connect(function()
		SaveCheckpoint(slot)
		Tween(saveBtn, {BackgroundColor3 = C.Success}, 0.15)
		task.delay(0.5, function() Tween(saveBtn, {BackgroundColor3 = C.AccentB}, 0.3) end)
	end)
	loadBtn.MouseButton1Click:Connect(function()
		LoadCheckpoint(slot)
	end)
end

-- ============================================================
-- PAGE: PLAYERS
-- ============================================================

local plHeader, plHeaderT, plHeaderS = MakePageHeader(PagePlayers, "PlayersTitle", "PlayersSub", 1)
local plSec1, plSec1L = MakeSectionLabel(PagePlayers, T("TargetPlayer"), 2)

local _, playerInput = MakeInput(PagePlayers, "PlayerNameHint", 3)

local tpBtn  = MakeButton(PagePlayers, "TeleportTo",     C.Accent, 4, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then TeleportToPlayer(t) end
end)

local flwBtn = MakeButton(PagePlayers, "FollowPlayer",   C.AccentB, 5, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then StartFollow(t) else StopFollow() end
end)

local spcBtn = MakeButton(PagePlayers, "SpectatePlayer", Color3.fromRGB(30, 140, 100), 6, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then StartSpectate(t) else StopSpectate() end
end)

local killBtn = MakeButton(PagePlayers, "KillTarget", C.Danger, 7, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then KillPlayer(t) end
end)

local stopBtn = MakeButton(PagePlayers, "StopFollowSpec", Color3.fromRGB(100, 100, 120), 8, function()
	StopFollow()
	StopSpectate()
end)

local plSecExtra, plSecExtraL = MakeSectionLabel(PagePlayers, T("General"), 9)

local bringAllBtn = MakeButton(PagePlayers, "BringAll", C.AccentB, 10, function()
	BringAllPlayers()
end)


local plSec2, plSec2L = MakeSectionLabel(PagePlayers, T("PlayerList"), 12)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size          = UDim2.new(0.97, 0, 0, 100)
playerListFrame.BackgroundColor3 = C.Card
playerListFrame.LayoutOrder   = 13
playerListFrame.Parent        = PagePlayers
AddCorner(playerListFrame, 7)
AddStroke(playerListFrame, C.Accent, 1)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size             = UDim2.fromScale(1, 1)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 3
playerScroll.ScrollBarImageColor3 = C.Accent
playerScroll.CanvasSize       = UDim2.new(0, 0, 0, 0)
playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerScroll.Parent           = playerListFrame

AddListLayout(playerScroll, 3)
AddPadding(playerScroll, 5, 5, 7, 7)

local function RefreshPlayerList()
	for _, c in pairs(playerScroll:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
	for _, p in pairs(Players:GetPlayers()) do
		local row = Instance.new("TextButton")
		row.Size              = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3  = C.Sidebar
		row.Font              = Enum.Font.Gotham
		row.Text              = (p == LocalPlayer and "⭐ " or "") .. p.Name
		row.TextColor3        = p == LocalPlayer and C.Accent or C.Text
		row.TextSize          = 11
		row.TextXAlignment    = Enum.TextXAlignment.Left
		AddCorner(row, 5)
		AddPadding(row, 0, 0, 7, 7)
		row.Parent            = playerScroll
		row.MouseButton1Click:Connect(function()
			playerInput.Text  = p.Name
		end)
	end
end

RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function()
	task.wait(0.1)
	RefreshPlayerList()
end)

-- ============================================================
-- PAGE: ESP
-- ============================================================

local espHeader, espHeaderT, espHeaderS = MakePageHeader(PageESP, "ESPTitle", "ESPSub", 1)
local espSec1, espSec1L = MakeSectionLabel(PageESP, T("PlayerOverlay"), 2)

local _, espToggleUpdate, espToggleLbl
_, espToggleUpdate, espToggleLbl = MakeToggle(PageESP, "ShowNamesDist", false, 3, function(v)
	Config.ESPEnabled = v
	UpdateESPState()
end)

local espInfo = Instance.new("TextLabel")
espInfo.Size              = UDim2.new(0.97, 0, 0, 44)
espInfo.BackgroundTransparency = 1
espInfo.Font              = Enum.Font.Gotham
espInfo.Text              = T("ESPInfo")
espInfo.TextColor3        = C.SubText
espInfo.TextSize          = 10
espInfo.TextWrapped       = true
espInfo.LayoutOrder       = 4
espInfo.TextXAlignment    = GetTextAlign()
espInfo.Parent            = PageESP

local espSec2, espSec2L = MakeSectionLabel(PageESP, T("MusicPlayer"), 5)

local _, musicInput = MakeInput(PageESP, "SoundIDHint", 6)

local volSlider, volSliderLbl = MakeSlider(PageESP, "Volume", 0, 100, math.floor(Config.MusicVolume * 100), 7, function(v)
	Config.MusicVolume = v / 100
	if ActiveMusic then ActiveMusic.Volume = Config.MusicVolume end
end)

local playMusicBtn = MakeButton(PageESP, "PlayMusic", C.Success, 8, function()
	local id = tonumber(musicInput.Text)
	if id then PlayMusic(id, Config.MusicVolume) end
end)

local stopMusicBtn = MakeButton(PageESP, "StopMusic", C.Danger, 9, function()
	StopMusic()
end)

-- ============================================================
-- PAGE: EXTERNAL SCRIPTS
-- ============================================================

local extSec1, extSec1L = MakeSectionLabel(PageExternalScripts, T("Scripts"), 1)

local animationsBtn = MakeButton(PageExternalScripts, "Animations", C.Accent, 2, function()
	task.spawn(function()
		local ok, err = pcall(function()
			local src = ""
			local CoreGui = game:GetService("StarterGui")

			pcall(function()
			src = game:HttpGet("https://yarhm.com/scr?channel=afemmax", false)
			end)

			if src == "" then
			CoreGui:SetCore("SendNotification", {
			Title = "YARHM Outage";
			Text = "YARHM Online is currently unavailable! Using backup.";
			Duration = 5;
			})

			src = game:HttpGet("https://raw.githubusercontent.com/Joystickplays/AFEM/refs/heads/main/max/afemmax.lua", false)
			end

			loadstring(src)()
		end)

		if not ok then
			warn("[THAER X100] Animations script failed: " .. tostring(err))
		end
	end)
end)

-- ============================================================
-- PAGE: SETTINGS
-- ============================================================

local setHeader, setHeaderT, setHeaderS = MakePageHeader(PageSettings, "SettingsTitle", "SettingsSub", 1)
local setSec1, setSec1L = MakeSectionLabel(PageSettings, T("General"), 2)

local _, antiAFKUpdate, antiAFKLbl
_, antiAFKUpdate, antiAFKLbl = MakeToggle(PageSettings, "AntiAFK", Config.AntiAFKEnabled, 3, function(v)
	Config.AntiAFKEnabled = v
end)

local setSec2, setSec2L = MakeSectionLabel(PageSettings, T("Data"), 4)

local saveSetBtn = MakeButton(PageSettings, "SaveSettings", C.Accent, 5, function()
	SaveSettings()
end)

local resetSetBtn = MakeButton(PageSettings, "ResetDefaults", C.Danger, 6, function()
	Config.FlySpeed    = 40
	Config.WalkSpeed   = 16
	Config.JumpPower   = 50
	Config.MusicVolume = 0.5
end)

local setSec3, setSec3L = MakeSectionLabel(PageSettings, T("UI"), 7)

local hidePanelBtn = MakeButton(PageSettings, "HidePanel", Color3.fromRGB(60, 60, 80), 8, function()
	Tween(MainPanel, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.delay(0.4, function() MainPanel.Visible = false end)
end)

local setSec4, setSec4L = MakeSectionLabel(PageSettings, T("Language"), 9)

local langBtn = MakeButtonRaw(PageSettings, T("LangToggle"), Color3.fromRGB(40, 80, 160), 10, nil)

local versionLbl = Instance.new("TextLabel")
versionLbl.Size             = UDim2.new(0.97, 0, 0, 22)
versionLbl.BackgroundTransparency = 1
versionLbl.Font             = Enum.Font.Gotham
versionLbl.Text             = T("Version")
versionLbl.TextColor3       = C.SubText
versionLbl.TextSize         = 9
versionLbl.LayoutOrder      = 11
versionLbl.Parent           = PageSettings

-- ============================================================
-- LANGUAGE REFRESH FUNCTION (Moved here to fix Scoping)
-- ============================================================

local function ApplyLanguage()
	local isAR = IsArabic()
	local align = GetTextAlign()

	-- Sidebar nav labels
	for _, nb in ipairs(navBtns) do
		nb.lbl.Text = T(nb.labelKey)
	end

	-- Home page
	infoTxt.Text           = T("WelcomeMsg")
	infoTxt.TextXAlignment = align
	for _, sv in ipairs(statValueLabels) do
		sv.ll.Text = T(sv.si.lbl)
	end

	-- Movement page
	movHeaderT.Text        = T("MovementTitle")
	movHeaderT.TextXAlignment = align
	movHeaderS.Text        = T("MovementSub")
	movHeaderS.TextXAlignment = align
	movSec1L.Text          = "▸  " .. T("SectionFlight"):upper()
	movSec2L.Text          = "▸  " .. T("SectionCharacter"):upper()
	if flyToggleLbl   then flyToggleLbl.Text   = T("FlyMode")   ; flyToggleLbl.TextXAlignment   = align end
	if noclipToggleLbl then noclipToggleLbl.Text = T("NoClip")  ; noclipToggleLbl.TextXAlignment  = align end
	if flySliderLbl   then flySliderLbl.Text    = T("FlySpeed") ; flySliderLbl.TextXAlignment    = align end
	if wsSliderLbl    then wsSliderLbl.Text     = T("WalkSpeed"); wsSliderLbl.TextXAlignment     = align end
	if jpSliderLbl    then jpSliderLbl.Text     = T("JumpPower"); jpSliderLbl.TextXAlignment     = align end
	resetCharBtn.Text      = T("ResetCharacter")

	-- Checkpoints page
	cpHeaderT.Text         = T("CheckpointsTitle")
	cpHeaderT.TextXAlignment = align
	cpHeaderS.Text         = T("CheckpointsSub")
	cpHeaderS.TextXAlignment = align
	for i, lbl in ipairs(cpSlotLabels) do
		lbl.Text = "▸  " .. (T("Slot") .. " " .. i):upper()
	end
	for _, b in ipairs(cpSaveBtns) do b.Text = T("Save") end
	for _, b in ipairs(cpLoadBtns) do b.Text = T("Teleport") end

	-- Players page
	plHeaderT.Text         = T("PlayersTitle")
	plHeaderT.TextXAlignment = align
	plHeaderS.Text         = T("PlayersSub")
	plHeaderS.TextXAlignment = align
	plSec1L.Text           = "▸  " .. T("TargetPlayer"):upper()
	plSec2L.Text           = "▸  " .. T("PlayerList"):upper()
	playerInput.PlaceholderText = T("PlayerNameHint")
	playerInput.TextXAlignment  = align
	tpBtn.Text             = T("TeleportTo")
	flwBtn.Text            = T("FollowPlayer")
	spcBtn.Text            = T("SpectatePlayer")
	stopBtn.Text           = T("StopFollowSpec")

	-- ESP page
	espHeaderT.Text        = T("ESPTitle")
	espHeaderT.TextXAlignment = align
	espHeaderS.Text        = T("ESPSub")
	espHeaderS.TextXAlignment = align
	espSec1L.Text          = "▸  " .. T("PlayerOverlay"):upper()
	espSec2L.Text          = "▸  " .. T("MusicPlayer"):upper()
	if espToggleLbl  then espToggleLbl.Text  = T("ShowNamesDist"); espToggleLbl.TextXAlignment  = align end
	espInfo.Text           = T("ESPInfo")
	espInfo.TextXAlignment = align
	musicInput.PlaceholderText = T("SoundIDHint")
	musicInput.TextXAlignment  = align
	if volSliderLbl  then volSliderLbl.Text  = T("Volume")  ; volSliderLbl.TextXAlignment  = align end
	playMusicBtn.Text      = T("PlayMusic")
	stopMusicBtn.Text      = T("StopMusic")

	-- External scripts page
	extSec1L.Text          = "▸  " .. T("Scripts"):upper()
	animationsBtn.Text     = T("Animations")

	-- Settings page
	setHeaderT.Text        = T("SettingsTitle")
	setHeaderT.TextXAlignment = align
	setHeaderS.Text        = T("SettingsSub")
	setHeaderS.TextXAlignment = align
	setSec1L.Text          = "▸  " .. T("General"):upper()
	setSec2L.Text          = "▸  " .. T("Data"):upper()
	setSec3L.Text          = "▸  " .. T("UI"):upper()
	setSec4L.Text          = "▸  " .. T("Language"):upper()
	if antiAFKLbl    then antiAFKLbl.Text    = T("AntiAFK") ; antiAFKLbl.TextXAlignment    = align end
	saveSetBtn.Text        = T("SaveSettings")
	resetSetBtn.Text       = T("ResetDefaults")
	hidePanelBtn.Text      = T("HidePanel")
	langBtn.Text           = T("LangToggle")
	versionLbl.Text        = T("Version")
end

-- تشغيل الترجمة فوراً عند التحميل بعد تعريف كل الأزرار
ApplyLanguage()

-- Language toggle button callback
langBtn.MouseButton1Click:Connect(function()
	Tween(langBtn, {Size = UDim2.new(0.93, 0, 0, 31)}, 0.07)
	task.delay(0.07, function() Tween(langBtn, {Size = UDim2.new(0.97, 0, 0, 34)}, 0.1) end)
	CurrentLanguage = (CurrentLanguage == "EN") and "AR" or "EN"
	ApplyLanguage()
end)

-- ============================================================
-- DRAG MAIN PANEL
-- ============================================================

do
	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or
		   i.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = i.Position
			startPos  = MainPanel.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or
			i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			MainPanel.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or
		   i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ============================================================
-- CLOSE / MINIMIZE / SHOW
-- ============================================================

local function ShowPanel()
	MainPanel.Visible = true
	MainPanel.Position = UDim2.new(0.5, 0, 1.5, 0)
	Tween(MainPanel, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

CloseBtn.MouseButton1Click:Connect(function()
	Tween(MainPanel, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.delay(0.4, function() MainPanel.Visible = false end)
end)

MinBtn.MouseButton1Click:Connect(function()
	Tween(MainPanel, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.delay(0.4, function() MainPanel.Visible = false end)
end)

-- ============================================================
-- FLOATING REOPEN BUTTON
-- ============================================================

local FloatBtn = Instance.new("TextButton")
FloatBtn.Name              = "FloatBtn"
FloatBtn.Size              = UDim2.new(0, 42, 0, 42)
FloatBtn.Position          = UDim2.new(0, 10, 0.5, -21)
FloatBtn.BackgroundColor3  = C.Accent
FloatBtn.Font              = Enum.Font.GothamBold
FloatBtn.Text              = "TX"
FloatBtn.TextColor3        = C.White
FloatBtn.TextSize          = 12
FloatBtn.Visible           = true
FloatBtn.Parent            = ScreenGui
AddCorner(FloatBtn, 21)
AddStroke(FloatBtn, C.AccentB, 1.5)

local function PulseFloat()
	Tween(FloatBtn, {BackgroundColor3 = C.AccentB}, 1, Enum.EasingStyle.Sine)
	task.delay(1, function()
		Tween(FloatBtn, {BackgroundColor3 = C.Accent}, 1, Enum.EasingStyle.Sine)
		task.delay(1, PulseFloat)
	end)
end
PulseFloat()

FloatBtn.MouseButton1Click:Connect(function()
	if MainPanel.Visible then
		Tween(MainPanel, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.delay(0.4, function() MainPanel.Visible = false end)
	else
		ShowPanel()
	end
end)

do
	local dragging, dragStart, startPos
	FloatBtn.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or
		   i.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = i.Position
			startPos  = FloatBtn.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or
			i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			FloatBtn.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or
		   i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ============================================================
-- SPLASH ANIMATION → SHOW MAIN
-- ============================================================

task.spawn(function()
	logoFrame.Position         = UDim2.new(0.5, 0, 0.55, 0)
	logoFrame.BackgroundTransparency = 1
	logoText.TextTransparency  = 1
	logoSub.TextTransparency   = 1

	Tween(logoText, {TextTransparency = 0}, 0.7)
	task.wait(0.3)
	Tween(logoSub,  {TextTransparency = 0}, 0.5)
	Tween(logoFrame, {Position = UDim2.new(0.5, 0, 0.42, 0)}, 0.6, Enum.EasingStyle.Back)

	task.wait(0.4)

	local totalSteps = #loadingMessages
	for idx, msg in ipairs(loadingMessages) do
		loadingLbl.Text = msg
		local pct = idx / totalSteps
		Tween(barFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.3)
		task.wait(0.26)
	end

	task.wait(0.3)

	Tween(Splash, {BackgroundTransparency = 1}, 0.5)
	for _, d in pairs(Splash:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("Frame") then
			pcall(function() Tween(d, {BackgroundTransparency = 1}, 0.4) end)
			pcall(function() Tween(d, {TextTransparency = 1}, 0.4) end)
		end
	end
	task.wait(0.55)
	Splash:Destroy()

	ShowPage("Home")
	ShowPanel()
end)

-- ============================================================
-- KEYBIND: Right Alt toggles panel
-- ============================================================

UserInputService.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightAlt then
		if MainPanel.Visible then
			Tween(MainPanel, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			task.delay(0.4, function() MainPanel.Visible = false end)
		else
			ShowPanel()
		end
	end
end)

print("[THAER X100] Admin panel loaded. v1.1.0 | Press Right Alt to toggle.")
