-- ============================================================
--   THAER X100 | Professional Admin Panel
--   For private/personal Roblox game admin/debug use
--   Single-file LocalScript
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ============================================================
-- SETTINGS / STATE
-- ============================================================

local Config = {
	FlySpeed = 40,
	WalkSpeed = 16,
	JumpPower = 50,
	FlyEnabled = false,
	NoClipEnabled = false,
	ESPEnabled = false,
	AntiAFKEnabled = true,
	MusicVolume = 0.5,
	CurrentPage = "Home",
}

local Checkpoints = {nil, nil, nil}
local FollowTarget = nil
local SpectateTarget = nil
local SpectateConn = nil
local FollowConn = nil
local FlyConn = nil
local NoClipConn = nil
local ESPObjects = {}
local ActiveMusic = nil

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

local function GetCharacter() return LocalPlayer.Character end
local function GetHumanoid()
	local c = GetCharacter()
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function GetHRP()
	local c = GetCharacter()
	return c and c:FindFirstChild("HumanoidRootPart")
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
game:GetService("Players").LocalPlayer.Idled:Connect(function()
	if Config.AntiAFKEnabled then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-- ============================================================
-- FLY SYSTEM
-- ============================================================

local function StopFly()
	Config.FlyEnabled = false
	if FlyConn then FlyConn:Disconnect() FlyConn = nil end
	local c = GetCharacter()
	if c then
		for _, v in pairs(c:GetDescendants()) do
			if v.Name == "FlyVelocity" or v.Name == "FlyGyro" then v:Destroy() end
		end
	end
	local h = GetHumanoid()
	if h then h.PlatformStand = false end
end

local function StartFly()
	local hrp = GetHRP()
	local h   = GetHumanoid()
	if not hrp or not h then return end

	Config.FlyEnabled = true
	h.PlatformStand = true

	local bv = Instance.new("BodyVelocity")
	bv.Name = "FlyVelocity"
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.Name = "FlyGyro"
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.P = 5000
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	FlyConn = RunService.Heartbeat:Connect(function()
		local hrp2 = GetHRP()
		if not hrp2 or not Config.FlyEnabled then StopFly() return end

		local speed = Config.FlySpeed
		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		if shift then speed = speed * 2 end

		local dir = Vector3.zero
		local cf  = Camera.CFrame

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end

		bv.Velocity = dir.Magnitude > 0 and (dir.Unit * speed) or Vector3.zero
		bg.CFrame   = cf
	end)
end

-- ============================================================
-- NOCLIP SYSTEM
-- ============================================================

local function StopNoClip()
	Config.NoClipEnabled = false
	if NoClipConn then NoClipConn:Disconnect() NoClipConn = nil end
	local c = GetCharacter()
	if c then
		for _, p in pairs(c:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = true end
		end
	end
end

local function StartNoClip()
	Config.NoClipEnabled = true
	NoClipConn = RunService.Stepped:Connect(function()
		if not Config.NoClipEnabled then StopNoClip() return end
		local c = GetCharacter()
		if c then
			for _, p in pairs(c:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
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
		hrp.CFrame = thrp.CFrame + Vector3.new(3,0,0)
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
-- ESP SYSTEM (admin name overlay)
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
			bb.Name = "AdminESP"
			bb.AlwaysOnTop = true
			bb.Size = UDim2.new(0, 120, 0, 40)
			bb.StudsOffset = Vector3.new(0, 3, 0)

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
			lbl.BackgroundTransparency = 0.4
			lbl.Size = UDim2.fromScale(1, 1)
			lbl.Font = Enum.Font.GothamBold
			lbl.TextColor3 = Color3.fromRGB(140, 100, 255)
			lbl.TextSize = 13
			lbl.Parent = bb

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = lbl

			local function UpdateESP()
				local c  = p.Character
				local hr = c and c:FindFirstChild("HumanoidRootPart")
				local lh = GetHRP()
				if hr and lh then
					local dist = math.floor((hr.Position - lh.Position).Magnitude)
					lbl.Text = p.Name .. "\n" .. dist .. " studs"
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

-- Cleanup old instance
local old = LocalPlayer.PlayerGui:FindFirstChild("ThaerAdminUI")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "ThaerAdminUI"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Parent          = LocalPlayer.PlayerGui

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
	c.CornerRadius = UDim.new(0, radius or 10)
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
	l.Padding          = UDim.new(0, padding or 8)
	l.FillDirection    = direction or Enum.FillDirection.Vertical
	l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Center
	l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
	l.SortOrder        = Enum.SortOrder.LayoutOrder
	l.Parent           = parent
	return l
end

local function AddPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 8)
	p.PaddingBottom = UDim.new(0, bottom or 8)
	p.PaddingLeft   = UDim.new(0, left   or 8)
	p.PaddingRight  = UDim.new(0, right  or 8)
	p.Parent        = parent
	return p
end

local function MakeSectionLabel(parent, text, order)
	local f = Instance.new("Frame")
	f.Size            = UDim2.new(0.97, 0, 0, 22)
	f.BackgroundTransparency = 1
	f.LayoutOrder     = order or 0
	f.Parent          = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size            = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font            = Enum.Font.GothamBold
	lbl.Text            = "▸  " .. text:upper()
	lbl.TextColor3      = C.Accent
	lbl.TextSize        = 11
	lbl.TextXAlignment  = Enum.TextXAlignment.Left
	lbl.Parent          = f
	return f
end

local function MakePageHeader(parent, title, subtitle, order)
	local f = Instance.new("Frame")
	f.Size         = UDim2.new(0.97, 0, 0, 58)
	f.BackgroundColor3 = C.Card
	f.LayoutOrder  = order or 0
	f.Parent       = parent
	AddCorner(f, 12)
	AddStroke(f, C.Accent, 1)

	local grad = Instance.new("UIGradient")
	grad.Color    = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 80)),
	})
	grad.Rotation = 135
	grad.Parent   = f

	local t = Instance.new("TextLabel")
	t.Position   = UDim2.new(0, 14, 0, 8)
	t.Size       = UDim2.new(1, -14, 0, 24)
	t.BackgroundTransparency = 1
	t.Font       = Enum.Font.GothamBold
	t.Text       = title
	t.TextColor3 = C.White
	t.TextSize   = 18
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent     = f

	local s = Instance.new("TextLabel")
	s.Position   = UDim2.new(0, 14, 0, 34)
	s.Size       = UDim2.new(1, -14, 0, 18)
	s.BackgroundTransparency = 1
	s.Font       = Enum.Font.Gotham
	s.Text       = subtitle or ""
	s.TextColor3 = C.SubText
	s.TextSize   = 11
	s.TextXAlignment = Enum.TextXAlignment.Left
	s.Parent     = f
	return f
end

local function MakeButton(parent, text, color, order, callback)
	color = color or C.Accent
	local btn = Instance.new("TextButton")
	btn.Size           = UDim2.new(0.97, 0, 0, 40)
	btn.BackgroundColor3 = color
	btn.Font           = Enum.Font.GothamBold
	btn.Text           = text
	btn.TextColor3     = C.White
	btn.TextSize       = 13
	btn.AutoButtonColor = false
	btn.LayoutOrder    = order or 0
	btn.Parent         = parent
	AddCorner(btn, 8)
	AddStroke(btn, color, 1)

	btn.MouseEnter:Connect(function()
		Tween(btn, {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.15)}, 0.18)
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, {BackgroundColor3 = color}, 0.18)
	end)
	btn.MouseButton1Click:Connect(function()
		Tween(btn, {Size = UDim2.new(0.94, 0, 0, 37)}, 0.08)
		task.delay(0.08, function() Tween(btn, {Size = UDim2.new(0.97, 0, 0, 40)}, 0.12) end)
		if callback then callback() end
	end)
	return btn
end

local function MakeToggle(parent, text, state, order, callback)
	local frame = Instance.new("Frame")
	frame.Size         = UDim2.new(0.97, 0, 0, 40)
	frame.BackgroundColor3 = C.Card
	frame.LayoutOrder  = order or 0
	frame.Parent       = parent
	AddCorner(frame, 8)
	AddStroke(frame, C.Accent, 1)

	local lbl = Instance.new("TextLabel")
	lbl.Position   = UDim2.new(0, 12, 0, 0)
	lbl.Size       = UDim2.new(1, -70, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font       = Enum.Font.Gotham
	lbl.Text       = text
	lbl.TextColor3 = C.Text
	lbl.TextSize   = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent     = frame

	local track = Instance.new("Frame")
	track.Position = UDim2.new(1, -54, 0.5, -11)
	track.Size     = UDim2.new(0, 44, 0, 22)
	track.BackgroundColor3 = state and C.Toggle_On or C.Toggle_Off
	track.Parent   = frame
	AddCorner(track, 11)

	local knob = Instance.new("Frame")
	knob.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	knob.Size     = UDim2.new(0, 18, 0, 18)
	knob.BackgroundColor3 = C.White
	knob.Parent   = track
	AddCorner(knob, 9)

	local current = state or false
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(1,1)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		current = not current
		Tween(track, {BackgroundColor3 = current and C.Toggle_On or C.Toggle_Off}, 0.2)
		Tween(knob,  {Position = current and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,2,0.5,-8)}, 0.2)
		if callback then callback(current) end
	end)
	return frame, function(v)
		current = v
		Tween(track, {BackgroundColor3 = v and C.Toggle_On or C.Toggle_Off}, 0.2)
		Tween(knob,  {Position = v and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,2,0.5,-8)}, 0.2)
	end
end

local function MakeSlider(parent, text, min, max, value, order, callback)
	local frame = Instance.new("Frame")
	frame.Size         = UDim2.new(0.97, 0, 0, 60)
	frame.BackgroundColor3 = C.Card
	frame.LayoutOrder  = order or 0
	frame.Parent       = parent
	AddCorner(frame, 8)
	AddStroke(frame, C.Accent, 1)

	local lbl = Instance.new("TextLabel")
	lbl.Position   = UDim2.new(0, 12, 0, 6)
	lbl.Size       = UDim2.new(0.6, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Font       = Enum.Font.Gotham
	lbl.Text       = text
	lbl.TextColor3 = C.Text
	lbl.TextSize   = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent     = frame

	local valLbl = Instance.new("TextLabel")
	valLbl.Position   = UDim2.new(0.6, 0, 0, 6)
	valLbl.Size       = UDim2.new(0.37, 0, 0, 20)
	valLbl.BackgroundTransparency = 1
	valLbl.Font       = Enum.Font.GothamBold
	valLbl.Text       = tostring(value)
	valLbl.TextColor3 = C.Accent
	valLbl.TextSize   = 13
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.Parent     = frame

	local track = Instance.new("Frame")
	track.Position = UDim2.new(0, 12, 0, 36)
	track.Size     = UDim2.new(1, -24, 0, 6)
	track.BackgroundColor3 = C.Sidebar
	track.Parent   = frame
	AddCorner(track, 3)

	local fill = Instance.new("Frame")
	fill.Size   = UDim2.new((value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = C.Accent
	fill.Parent = track
	AddCorner(fill, 3)

	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position    = UDim2.new((value - min)/(max - min), 0, 0.5, 0)
	knob.Size        = UDim2.new(0, 14, 0, 14)
	knob.BackgroundColor3 = C.White
	knob.Parent      = track
	AddCorner(knob, 7)

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
	return frame
end

local function MakeInput(parent, placeholder, order, callback)
	local frame = Instance.new("Frame")
	frame.Size         = UDim2.new(0.97, 0, 0, 40)
	frame.BackgroundColor3 = C.Card
	frame.LayoutOrder  = order or 0
	frame.Parent       = parent
	AddCorner(frame, 8)
	AddStroke(frame, C.Accent, 1)

	local tb = Instance.new("TextBox")
	tb.Size             = UDim2.new(1, -16, 1, 0)
	tb.Position         = UDim2.new(0, 8, 0, 0)
	tb.BackgroundTransparency = 1
	tb.Font             = Enum.Font.Gotham
	tb.PlaceholderText  = placeholder or "Type here..."
	tb.PlaceholderColor3 = C.SubText
	tb.Text             = ""
	tb.TextColor3       = C.Text
	tb.TextSize         = 13
	tb.TextXAlignment   = Enum.TextXAlignment.Left
	tb.ClearTextOnFocus = false
	tb.Parent           = frame

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
	card.Size         = UDim2.new(0.97, 0, 0, 110)
	card.BackgroundColor3 = C.Card
	card.LayoutOrder  = order or 0
	card.Parent       = parent
	AddCorner(card, 14)
	AddStroke(card, C.Accent, 1.5)

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,  Color3.fromRGB(40, 10, 100)),
		ColorSequenceKeypoint.new(0.5,Color3.fromRGB(10, 20, 80)),
		ColorSequenceKeypoint.new(1,  Color3.fromRGB(10, 40, 90)),
	})
	grad.Rotation = 120
	grad.Parent   = card

	-- Avatar image
	local img = Instance.new("ImageLabel")
	img.Position = UDim2.new(0, 12, 0.5, -36)
	img.Size     = UDim2.new(0, 72, 0, 72)
	img.BackgroundColor3 = C.BG
	img.Image    = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
	img.Parent   = card
	AddCorner(img, 36)
	AddStroke(img, C.Accent, 2)

	local name = Instance.new("TextLabel")
	name.Position   = UDim2.new(0, 96, 0, 22)
	name.Size       = UDim2.new(1, -110, 0, 28)
	name.BackgroundTransparency = 1
	name.Font       = Enum.Font.GothamBold
	name.Text       = LocalPlayer.DisplayName
	name.TextColor3 = C.White
	name.TextSize   = 20
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.Parent     = card

	local uname = Instance.new("TextLabel")
	uname.Position   = UDim2.new(0, 96, 0, 50)
	uname.Size       = UDim2.new(1, -110, 0, 18)
	uname.BackgroundTransparency = 1
	uname.Font       = Enum.Font.Gotham
	uname.Text       = "@" .. LocalPlayer.Name
	uname.TextColor3 = C.SubText
	uname.TextSize   = 12
	uname.TextXAlignment = Enum.TextXAlignment.Left
	uname.Parent     = card

	local badge = Instance.new("TextLabel")
	badge.Position   = UDim2.new(0, 96, 0, 74)
	badge.Size       = UDim2.new(0, 80, 0, 20)
	badge.BackgroundColor3 = C.Accent
	badge.Font       = Enum.Font.GothamBold
	badge.Text       = "⚙ ADMIN"
	badge.TextColor3 = C.White
	badge.TextSize   = 10
	badge.Parent     = card
	AddCorner(badge, 6)
	return card
end

-- ============================================================
-- SPLASH SCREEN
-- ============================================================

local Splash = Instance.new("Frame")
Splash.Name            = "Splash"
Splash.Size            = UDim2.fromScale(1, 1)
Splash.BackgroundColor3 = C.BG
Splash.ZIndex          = 100
Splash.Parent          = ScreenGui

local splashGrad = Instance.new("UIGradient")
splashGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(4, 4, 20)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 4, 30)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(4, 8, 25)),
})
splashGrad.Rotation = 135
splashGrad.Parent   = Splash

-- Glow orbs (decoration)
for i = 1, 3 do
	local orb = Instance.new("Frame")
	orb.AnchorPoint = Vector2.new(0.5, 0.5)
	orb.Position    = UDim2.new(math.random(20,80)/100, 0, math.random(20,80)/100, 0)
	orb.Size        = UDim2.new(0, 200, 0, 200)
	orb.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 0, 180) or
	                        i == 2 and Color3.fromRGB(0, 60, 200) or
	                                   Color3.fromRGB(120, 0, 150)
	orb.BackgroundTransparency = 0.85
	orb.ZIndex      = 99
	orb.Parent      = Splash
	AddCorner(orb, 100)
end

local logoFrame = Instance.new("Frame")
logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
logoFrame.Position    = UDim2.new(0.5, 0, 0.42, 0)
logoFrame.Size        = UDim2.new(0, 340, 0, 90)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex      = 101
logoFrame.Parent      = Splash

local logoText = Instance.new("TextLabel")
logoText.Size       = UDim2.fromScale(1, 0.6)
logoText.BackgroundTransparency = 1
logoText.Font       = Enum.Font.GothamBlack
logoText.Text       = "THAER X100"
logoText.TextColor3 = C.White
logoText.TextSize   = 44
logoText.ZIndex     = 102
logoText.Parent     = logoFrame

local logoGrad = Instance.new("UIGradient")
logoGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 80,  255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 160, 255)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  60,  240)),
})
logoGrad.Rotation = 45
logoGrad.Parent   = logoText

local logoSub = Instance.new("TextLabel")
logoSub.Size       = UDim2.new(1, 0, 0.38, 0)
logoSub.Position   = UDim2.new(0, 0, 0.62, 0)
logoSub.BackgroundTransparency = 1
logoSub.Font       = Enum.Font.Gotham
logoSub.Text       = "Professional Admin Panel"
logoSub.TextColor3 = C.SubText
logoSub.TextSize   = 14
logoSub.ZIndex     = 102
logoSub.Parent     = logoFrame

-- Progress bar
local barBG = Instance.new("Frame")
barBG.AnchorPoint = Vector2.new(0.5, 0.5)
barBG.Position    = UDim2.new(0.5, 0, 0.65, 0)
barBG.Size        = UDim2.new(0, 320, 0, 4)
barBG.BackgroundColor3 = C.Sidebar
barBG.ZIndex      = 101
barBG.Parent      = Splash
AddCorner(barBG, 2)

local barFill = Instance.new("Frame")
barFill.Size      = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = C.Accent
barFill.ZIndex    = 102
barFill.Parent    = barBG
AddCorner(barFill, 2)
AddGradient(barFill, Color3.fromRGB(120, 60, 255), Color3.fromRGB(60, 120, 255), 90)

local loadingLbl = Instance.new("TextLabel")
loadingLbl.AnchorPoint = Vector2.new(0.5, 0.5)
loadingLbl.Position    = UDim2.new(0.5, 0, 0.72, 0)
loadingLbl.Size        = UDim2.new(0, 340, 0, 22)
loadingLbl.BackgroundTransparency = 1
loadingLbl.Font        = Enum.Font.Gotham
loadingLbl.Text        = "Initializing systems..."
loadingLbl.TextColor3  = C.SubText
loadingLbl.TextSize    = 12
loadingLbl.ZIndex      = 101
loadingLbl.Parent      = Splash

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
-- MAIN PANEL (built but invisible during splash)
-- ============================================================

local MainPanel = Instance.new("Frame")
MainPanel.Name          = "MainPanel"
MainPanel.AnchorPoint   = Vector2.new(0.5, 0.5)
MainPanel.Position      = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.Size          = UDim2.new(0, 700, 0, 460)
MainPanel.BackgroundColor3 = C.BG
MainPanel.Visible       = false
MainPanel.Parent        = ScreenGui
AddCorner(MainPanel, 16)
AddStroke(MainPanel, C.Accent, 1.5)

-- Panel background gradient
local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 12, 28)),
})
panelGrad.Rotation = 130
panelGrad.Parent   = MainPanel

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name   = "TitleBar"
TitleBar.Size   = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = C.Sidebar
TitleBar.Parent = MainPanel
AddCorner(TitleBar, 16)

-- Mask bottom corners of titlebar
local tbMask = Instance.new("Frame")
tbMask.Position = UDim2.new(0, 0, 0.5, 0)
tbMask.Size     = UDim2.new(1, 0, 0.5, 0)
tbMask.BackgroundColor3 = C.Sidebar
tbMask.BorderSizePixel  = 0
tbMask.Parent   = TitleBar

local tbTitle = Instance.new("TextLabel")
tbTitle.Position   = UDim2.new(0, 16, 0, 0)
tbTitle.Size       = UDim2.new(0.5, 0, 1, 0)
tbTitle.BackgroundTransparency = 1
tbTitle.Font       = Enum.Font.GothamBold
tbTitle.Text       = "THAER X100  ·  Admin Panel"
tbTitle.TextColor3 = C.Text
tbTitle.TextSize   = 13
tbTitle.TextXAlignment = Enum.TextXAlignment.Left
tbTitle.Parent     = TitleBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.Size     = UDim2.new(0, 26, 0, 26)
CloseBtn.BackgroundColor3 = C.Danger
CloseBtn.Font     = Enum.Font.GothamBold
CloseBtn.Text     = "✕"
CloseBtn.TextColor3 = C.White
CloseBtn.TextSize = 12
CloseBtn.Parent   = TitleBar
AddCorner(CloseBtn, 13)

-- Minimize button  
local MinBtn = Instance.new("TextButton")
MinBtn.Position = UDim2.new(1, -66, 0.5, -13)
MinBtn.Size     = UDim2.new(0, 26, 0, 26)
MinBtn.BackgroundColor3 = Color3.fromRGB(220, 160, 30)
MinBtn.Font     = Enum.Font.GothamBold
MinBtn.Text     = "−"
MinBtn.TextColor3 = C.White
MinBtn.TextSize = 14
MinBtn.Parent   = TitleBar
AddCorner(MinBtn, 13)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name   = "Sidebar"
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.Size   = UDim2.new(0, 140, 1, -42)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.Parent = MainPanel

local sbMaskTop = Instance.new("Frame")
sbMaskTop.Size = UDim2.new(1,0,0,10)
sbMaskTop.BackgroundColor3 = C.Sidebar
sbMaskTop.BorderSizePixel = 0
sbMaskTop.Parent = Sidebar

-- Round bottom-left corner of sidebar
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 16)
sbCorner.Parent = Sidebar

local sbMaskBR = Instance.new("Frame")
sbMaskBR.Position = UDim2.new(0.5, 0, 0, 0)
sbMaskBR.Size     = UDim2.new(0.5, 0, 1, 0)
sbMaskBR.BackgroundColor3 = C.Sidebar
sbMaskBR.BorderSizePixel  = 0
sbMaskBR.Parent   = Sidebar

local sbMaskTop2 = Instance.new("Frame")
sbMaskTop2.Size = UDim2.new(1,0,0,16)
sbMaskTop2.BackgroundColor3 = C.Sidebar
sbMaskTop2.BorderSizePixel  = 0
sbMaskTop2.Parent = Sidebar

-- Sidebar brand
local sbBrand = Instance.new("TextLabel")
sbBrand.Position   = UDim2.new(0, 0, 0, 12)
sbBrand.Size       = UDim2.new(1, 0, 0, 30)
sbBrand.BackgroundTransparency = 1
sbBrand.Font       = Enum.Font.GothamBlack
sbBrand.Text       = "TX100"
sbBrand.TextColor3 = C.Accent
sbBrand.TextSize   = 18
sbBrand.Parent     = Sidebar

local sbNav = Instance.new("Frame")
sbNav.Position = UDim2.new(0, 0, 0, 52)
sbNav.Size     = UDim2.new(1, 0, 1, -52)
sbNav.BackgroundTransparency = 1
sbNav.Parent   = Sidebar

AddListLayout(sbNav, 4, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
AddPadding(sbNav, 4, 4, 6, 6)

-- Content area
local ContentArea = Instance.new("Frame")
ContentArea.Name   = "Content"
ContentArea.Position = UDim2.new(0, 140, 0, 42)
ContentArea.Size   = UDim2.new(1, -140, 1, -42)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainPanel

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
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Visible            = false
	scroll.Parent             = ContentArea

	AddListLayout(scroll, 8, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
	AddPadding(scroll, 10, 10, 6, 6)

	Pages[name] = scroll
	return scroll
end

local PageHome       = MakePage("Home")
local PageMovement   = MakePage("Movement")
local PageCheckpoints= MakePage("Checkpoints")
local PagePlayers    = MakePage("Players")
local PageESP        = MakePage("ESP")
local PageSettings   = MakePage("Settings")

-- ============================================================
-- SIDEBAR NAVIGATION
-- ============================================================

local navDefs = {
	{icon="🏠", label="Home",        page="Home"},
	{icon="✈️",  label="Movement",    page="Movement"},
	{icon="📍", label="Checkpoints", page="Checkpoints"},
	{icon="👥", label="Players",     page="Players"},
	{icon="👁",  label="ESP",         page="ESP"},
	{icon="⚙️",  label="Settings",    page="Settings"},
}

local navBtns = {}

local function ShowPage(name)
	for n, pg in pairs(Pages) do
		pg.Visible = (n == name)
	end
	for _, nb in pairs(navBtns) do
		local active = (nb.pageName == name)
		Tween(nb.frame, {BackgroundColor3 = active and C.Accent or Color3.fromRGB(0,0,0,0)}, 0.2)
		Tween(nb.frame, {BackgroundTransparency = active and 0 or 1}, 0.2)
		nb.lbl.TextColor3 = active and C.White or C.SubText
	end
	Config.CurrentPage = name
end

for i, def in ipairs(navDefs) do
	local btn = Instance.new("TextButton")
	btn.Size   = UDim2.new(1, -4, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	btn.BackgroundTransparency = 1
	btn.Text   = ""
	btn.LayoutOrder = i
	btn.Parent = sbNav
	AddCorner(btn, 8)

	local iconL = Instance.new("TextLabel")
	iconL.Position   = UDim2.new(0, 8, 0.5, -9)
	iconL.Size       = UDim2.new(0, 22, 0, 18)
	iconL.BackgroundTransparency = 1
	iconL.Font       = Enum.Font.GothamBold
	iconL.Text       = def.icon
	iconL.TextSize   = 15
	iconL.TextColor3 = C.SubText
	iconL.Parent     = btn

	local lbl = Instance.new("TextLabel")
	lbl.Position   = UDim2.new(0, 34, 0.5, -9)
	lbl.Size       = UDim2.new(1, -38, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Font       = Enum.Font.Gotham
	lbl.Text       = def.label
	lbl.TextSize   = 12
	lbl.TextColor3 = C.SubText
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent     = btn

	table.insert(navBtns, {frame=btn, lbl=lbl, pageName=def.page})

	btn.MouseButton1Click:Connect(function() ShowPage(def.page) end)
	btn.MouseEnter:Connect(function()
		if Config.CurrentPage ~= def.page then
			Tween(btn, {BackgroundTransparency = 0.7}, 0.15)
			Tween(btn, {BackgroundColor3 = C.Accent}, 0.15)
		end
	end)
	btn.MouseLeave:Connect(function()
		if Config.CurrentPage ~= def.page then
			Tween(btn, {BackgroundTransparency = 1}, 0.15)
		end
	end)
end

-- ============================================================
-- PAGE: HOME
-- ============================================================

MakeHeroCard(PageHome, 1)

local statusCard = Instance.new("Frame")
statusCard.Size         = UDim2.new(0.97, 0, 0, 70)
statusCard.BackgroundColor3 = C.Card
statusCard.LayoutOrder  = 2
statusCard.Parent       = PageHome
AddCorner(statusCard, 10)
AddStroke(statusCard, C.AccentB, 1)

local statusList = Instance.new("UIListLayout")
statusList.FillDirection = Enum.FillDirection.Horizontal
statusList.Padding       = UDim.new(0, 0)
statusList.HorizontalAlignment = Enum.HorizontalAlignment.Left
statusList.VerticalAlignment   = Enum.VerticalAlignment.Center
statusList.Parent = statusCard

local statItems = {
	{lbl="Fly",    val=function() return Config.FlyEnabled     and "ON" or "OFF" end, color=function() return Config.FlyEnabled     and C.Success or C.SubText end},
	{lbl="NoClip", val=function() return Config.NoClipEnabled  and "ON" or "OFF" end, color=function() return Config.NoClipEnabled  and C.Success or C.SubText end},
	{lbl="ESP",    val=function() return Config.ESPEnabled     and "ON" or "OFF" end, color=function() return Config.ESPEnabled     and C.Success or C.SubText end},
	{lbl="AntiAFK",val=function() return Config.AntiAFKEnabled and "ON" or "OFF" end, color=function() return Config.AntiAFKEnabled and C.Success or C.SubText end},
}

local statValueLabels = {}
for _, si in ipairs(statItems) do
	local col = Instance.new("Frame")
	col.Size   = UDim2.new(0.25, 0, 1, 0)
	col.BackgroundTransparency = 1
	col.Parent = statusCard

	local vl = Instance.new("TextLabel")
	vl.Size   = UDim2.new(1, 0, 0.55, 0)
	vl.Position = UDim2.new(0, 0, 0.1, 0)
	vl.BackgroundTransparency = 1
	vl.Font   = Enum.Font.GothamBold
	vl.Text   = si.val()
	vl.TextColor3 = si.color()
	vl.TextSize   = 13
	vl.Parent = col

	local ll = Instance.new("TextLabel")
	ll.Size   = UDim2.new(1, 0, 0.35, 0)
	ll.Position = UDim2.new(0, 0, 0.6, 0)
	ll.BackgroundTransparency = 1
	ll.Font   = Enum.Font.Gotham
	ll.Text   = si.lbl
	ll.TextColor3 = C.SubText
	ll.TextSize   = 10
	ll.Parent = col

	table.insert(statValueLabels, {vl=vl, ll=ll, si=si})
end

RunService.Heartbeat:Connect(function()
	for _, sv in pairs(statValueLabels) do
		sv.vl.Text = sv.si.val()
		sv.vl.TextColor3 = sv.si.color()
	end
end)

local infoTxt = Instance.new("TextLabel")
infoTxt.Size   = UDim2.new(0.97, 0, 0, 36)
infoTxt.BackgroundTransparency = 1
infoTxt.Font   = Enum.Font.Gotham
infoTxt.Text   = "Welcome to THAER X100 Admin Panel.\nUse the sidebar to navigate between tools."
infoTxt.TextColor3 = C.SubText
infoTxt.TextSize   = 11
infoTxt.TextWrapped = true
infoTxt.LayoutOrder = 3
infoTxt.Parent = PageHome

-- ============================================================
-- PAGE: MOVEMENT
-- ============================================================

MakePageHeader(PageMovement, "Movement Tools", "Fly, speed, jump and collision debug", 1)
MakeSectionLabel(PageMovement, "Flight", 2)

local _, flyToggleUpdate
_, flyToggleUpdate = MakeToggle(PageMovement, "✈️  Fly Mode", false, 3, function(v)
	if v then StartFly() else StopFly() end
end)

MakeSlider(PageMovement, "Fly Speed", 5, 200, Config.FlySpeed, 4, function(v)
	Config.FlySpeed = v
end)

MakeSectionLabel(PageMovement, "Character", 5)

local _, noclipUpdate
_, noclipUpdate = MakeToggle(PageMovement, "🧱  NoClip", false, 6, function(v)
	if v then StartNoClip() else StopNoClip() end
end)

MakeSlider(PageMovement, "Walk Speed", 1, 200, Config.WalkSpeed, 7, function(v)
	Config.WalkSpeed = v
	local h = GetHumanoid()
	if h then h.WalkSpeed = v end
end)

MakeSlider(PageMovement, "Jump Power", 1, 200, Config.JumpPower, 8, function(v)
	Config.JumpPower = v
	local h = GetHumanoid()
	if h then h.JumpPower = v end
end)

MakeButton(PageMovement, "Reset Character", C.Danger, 9, function()
	local h = GetHumanoid()
	if h then h.Health = 0 end
end)

-- ============================================================
-- PAGE: CHECKPOINTS
-- ============================================================

MakePageHeader(PageCheckpoints, "Checkpoints", "Save and teleport to positions", 1)

for i = 1, 3 do
	MakeSectionLabel(PageCheckpoints, "Slot " .. i, (i-1)*3 + 2)

	local row = Instance.new("Frame")
	row.Size   = UDim2.new(0.97, 0, 0, 40)
	row.BackgroundTransparency = 1
	row.LayoutOrder = (i-1)*3 + 3
	row.Parent = PageCheckpoints

	local rowList = Instance.new("UIListLayout")
	rowList.FillDirection = Enum.FillDirection.Horizontal
	rowList.Padding       = UDim.new(0, 8)
	rowList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	rowList.VerticalAlignment   = Enum.VerticalAlignment.Center
	rowList.Parent = row

	local saveBtn = Instance.new("TextButton")
	saveBtn.Size   = UDim2.new(0.46, 0, 0, 40)
	saveBtn.BackgroundColor3 = C.AccentB
	saveBtn.Font   = Enum.Font.GothamBold
	saveBtn.Text   = "💾  Save"
	saveBtn.TextColor3 = C.White
	saveBtn.TextSize   = 13
	saveBtn.Parent = row
	AddCorner(saveBtn, 8)

	local loadBtn = Instance.new("TextButton")
	loadBtn.Size   = UDim2.new(0.46, 0, 0, 40)
	loadBtn.BackgroundColor3 = C.Accent
	loadBtn.Font   = Enum.Font.GothamBold
	loadBtn.Text   = "📍  Teleport"
	loadBtn.TextColor3 = C.White
	loadBtn.TextSize   = 13
	loadBtn.Parent = row
	AddCorner(loadBtn, 8)

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

MakePageHeader(PagePlayers, "Player Tools", "Admin tools for managing players", 1)
MakeSectionLabel(PagePlayers, "Target Player", 2)

local _, playerInput = MakeInput(PagePlayers, "Player name...", 3)

MakeButton(PagePlayers, "🔍  Teleport To Player", C.Accent, 4, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then TeleportToPlayer(t) end
end)

MakeButton(PagePlayers, "👣  Follow Player", C.AccentB, 5, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then
		StartFollow(t)
	else
		StopFollow()
	end
end)

MakeButton(PagePlayers, "🎥  Spectate Player", Color3.fromRGB(30, 140, 100), 6, function()
	local t = GetPlayerByName(playerInput.Text)
	if t then
		StartSpectate(t)
	else
		StopSpectate()
	end
end)

MakeButton(PagePlayers, "⏹  Stop Follow / Spectate", C.Danger, 7, function()
	StopFollow()
	StopSpectate()
end)

MakeSectionLabel(PagePlayers, "Player List", 8)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size         = UDim2.new(0.97, 0, 0, 120)
playerListFrame.BackgroundColor3 = C.Card
playerListFrame.LayoutOrder  = 9
playerListFrame.Parent       = PagePlayers
AddCorner(playerListFrame, 8)
AddStroke(playerListFrame, C.Accent, 1)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size   = UDim2.fromScale(1, 1)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 3
playerScroll.ScrollBarImageColor3 = C.Accent
playerScroll.CanvasSize = UDim2.new(0,0,0,0)
playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerScroll.Parent = playerListFrame

AddListLayout(playerScroll, 4)
AddPadding(playerScroll, 6, 6, 8, 8)

local function RefreshPlayerList()
	for _, c in pairs(playerScroll:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
	for _, p in pairs(Players:GetPlayers()) do
		local row = Instance.new("TextButton")
		row.Size   = UDim2.new(1, 0, 0, 28)
		row.BackgroundColor3 = C.Sidebar
		row.Font   = Enum.Font.Gotham
		row.Text   = (p == LocalPlayer and "⭐ " or "") .. p.Name
		row.TextColor3 = p == LocalPlayer and C.Accent or C.Text
		row.TextSize   = 12
		row.TextXAlignment = Enum.TextXAlignment.Left
		AddCorner(row, 6)
		AddPadding(row, 0, 0, 8, 8)
		row.Parent = playerScroll
		row.MouseButton1Click:Connect(function()
			playerInput.Text = p.Name
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

MakePageHeader(PageESP, "ESP / Overlay", "Admin visibility tools", 1)
MakeSectionLabel(PageESP, "Player Overlay", 2)

MakeToggle(PageESP, "👁  Show Player Names & Distance", false, 3, function(v)
	Config.ESPEnabled = v
	UpdateESPState()
end)

local espInfo = Instance.new("TextLabel")
espInfo.Size   = UDim2.new(0.97, 0, 0, 50)
espInfo.BackgroundTransparency = 1
espInfo.Font   = Enum.Font.Gotham
espInfo.Text   = "Shows player names and their distance from you as a floating label. Useful for admin monitoring in your game."
espInfo.TextColor3 = C.SubText
espInfo.TextSize   = 11
espInfo.TextWrapped = true
espInfo.LayoutOrder = 4
espInfo.Parent = PageESP

MakeSectionLabel(PageESP, "Music Player", 5)

local _, musicInput = MakeInput(PageESP, "Sound Asset ID (numbers only)...", 6)

MakeSlider(PageESP, "Volume", 0, 100, math.floor(Config.MusicVolume * 100), 7, function(v)
	Config.MusicVolume = v / 100
	if ActiveMusic then ActiveMusic.Volume = Config.MusicVolume end
end)

MakeButton(PageESP, "▶  Play Music", C.Success, 8, function()
	local id = tonumber(musicInput.Text)
	if id then PlayMusic(id, Config.MusicVolume) end
end)

MakeButton(PageESP, "⏹  Stop Music", C.Danger, 9, function()
	StopMusic()
end)

-- ============================================================
-- PAGE: SETTINGS
-- ============================================================

MakePageHeader(PageSettings, "Settings", "Admin panel configuration", 1)
MakeSectionLabel(PageSettings, "General", 2)

MakeToggle(PageSettings, "💤  Anti-AFK", Config.AntiAFKEnabled, 3, function(v)
	Config.AntiAFKEnabled = v
end)

MakeSectionLabel(PageSettings, "Data", 4)

MakeButton(PageSettings, "💾  Save Settings", C.Accent, 5, function()
	SaveSettings()
end)

MakeButton(PageSettings, "🔄  Reset to Defaults", C.Danger, 6, function()
	Config.FlySpeed    = 40
	Config.WalkSpeed   = 16
	Config.JumpPower   = 50
	Config.MusicVolume = 0.5
end)

MakeSectionLabel(PageSettings, "UI", 7)

MakeButton(PageSettings, "Hide Panel", Color3.fromRGB(60, 60, 80), 8, function()
	Tween(MainPanel, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.delay(0.4, function() MainPanel.Visible = false end)
end)

local versionLbl = Instance.new("TextLabel")
versionLbl.Size   = UDim2.new(0.97, 0, 0, 28)
versionLbl.BackgroundTransparency = 1
versionLbl.Font   = Enum.Font.Gotham
versionLbl.Text   = "THAER X100  |  v1.0.0  |  For authorized admin use only"
versionLbl.TextColor3 = C.SubText
versionLbl.TextSize   = 10
versionLbl.LayoutOrder = 9
versionLbl.Parent = PageSettings

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
-- CLOSE / MINIMIZE
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
FloatBtn.Name   = "FloatBtn"
FloatBtn.Size   = UDim2.new(0, 48, 0, 48)
FloatBtn.Position = UDim2.new(0, 12, 0.5, -24)
FloatBtn.BackgroundColor3 = C.Accent
FloatBtn.Font   = Enum.Font.GothamBold
FloatBtn.Text   = "TX"
FloatBtn.TextColor3 = C.White
FloatBtn.TextSize   = 13
FloatBtn.Visible    = true
FloatBtn.Parent = ScreenGui
AddCorner(FloatBtn, 24)
AddStroke(FloatBtn, C.AccentB, 1.5)

-- Pulse animation on float button
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

-- Drag float button
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
	-- Animate logo in
	logoFrame.Position = UDim2.new(0.5, 0, 0.55, 0)
	logoFrame.BackgroundTransparency = 1
	logoText.TextTransparency = 1
	logoSub.TextTransparency  = 1

	Tween(logoText, {TextTransparency = 0}, 0.7)
	task.wait(0.3)
	Tween(logoSub,  {TextTransparency = 0}, 0.5)
	Tween(logoFrame, {Position = UDim2.new(0.5, 0, 0.42, 0)}, 0.6, Enum.EasingStyle.Back)

	task.wait(0.4)

	local totalSteps = #loadingMessages
	for idx, msg in ipairs(loadingMessages) do
		loadingLbl.Text = msg
		local pct = idx / totalSteps
		Tween(barFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.35)
		task.wait(0.28)
	end

	task.wait(0.3)

	-- Fade out splash
	Tween(Splash, {BackgroundTransparency = 1}, 0.5)
	for _, d in pairs(Splash:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("Frame") then
			pcall(function() Tween(d, {BackgroundTransparency = 1}, 0.4) end)
			pcall(function() Tween(d, {TextTransparency = 1}, 0.4) end)
		end
	end
	task.wait(0.55)
	Splash:Destroy()

	-- Show main panel
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

-- ============================================================
-- CLEANUP on character respawn (restart fly/noclip state)
-- ============================================================

LocalPlayer.CharacterAdded:Connect(function()
	Config.FlyEnabled    = false
	Config.NoClipEnabled = false
	FlyConn    = nil
	NoClipConn = nil
end)

print("[THAER X100] Admin panel loaded. Press Right Alt to toggle.")