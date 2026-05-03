--[[
-- Professional Mobile Admin Panel - Standalone Unified Version
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==============================
-- [1] Theme_Config
-- ==============================
local Theme = {
	Colors = {
		Background       = Color3.fromRGB(12, 12, 18),
		Surface          = Color3.fromRGB(20, 20, 30),
		SurfaceAlt       = Color3.fromRGB(28, 28, 42),
		Accent           = Color3.fromRGB(88, 130, 255),
		AccentDark       = Color3.fromRGB(50, 90, 200),
		AccentGlow       = Color3.fromRGB(120, 160, 255),
		TextPrimary      = Color3.fromRGB(230, 230, 240),
		TextSecondary    = Color3.fromRGB(140, 140, 165),
		TextMuted        = Color3.fromRGB(80, 80, 100),
		Success          = Color3.fromRGB(72, 210, 140),
		Warning          = Color3.fromRGB(255, 185, 60),
		Danger           = Color3.fromRGB(255, 85, 100),
		SliderTrack      = Color3.fromRGB(35, 35, 55),
		SliderFill       = Color3.fromRGB(88, 130, 255),
		SliderThumb      = Color3.fromRGB(200, 215, 255),
		Divider          = Color3.fromRGB(40, 40, 60),
		FloatingIcon     = Color3.fromRGB(88, 130, 255),
		Overlay          = Color3.fromRGB(5, 5, 10),
	},
	Transparency = {
		Background   = 0.08,
		Surface      = 0.12,
		SurfaceAlt   = 0.05,
		Stroke       = 0.75,
		Overlay      = 0.35,
	},
	Radius = {
		Panel        = UDim.new(0, 16),
		Button       = UDim.new(0, 10),
		Slider       = UDim.new(0, 6),
		Chip         = UDim.new(0, 20),
		FloatIcon    = UDim.new(0, 28),
		Input        = UDim.new(0, 8),
	},
	Stroke = {
		Thickness    = 1,
		Color        = Color3.fromRGB(80, 100, 200),
		Transparency = 0.72,
	},
	Gradients = {
		Sidebar = {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 22, 50)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 30)),
			}),
			Rotation = 90,
		},
		Button = {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 140, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 200)),
			}),
			Rotation = 90,
		},
		Danger = {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 110)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 55, 70)),
			}),
			Rotation = 90,
		},
		Success = {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 150)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 170, 110)),
			}),
			Rotation = 90,
		},
	},
	Font = {
		Title    = Enum.Font.GothamBold,
		Body     = Enum.Font.Gotham,
		Mono     = Enum.Font.RobotoMono,
		Label    = Enum.Font.GothamMedium,
	},
	Size = {
		TitleText  = 15,
		BodyText   = 13,
		LabelText  = 11,
		SmallText  = 10,
	}
}

-- ==========================================
-- [[ 3. PHYSICS SYSTEM ]]
-- ==========================================
local Physics = { flightActive = false, ghostActive = false, checkpoints = {nil, nil, nil} }
local flightVelocity, flightConn, flightGyro, ghostLoop, ghostParts = nil, nil, nil, nil, {}
local FLIGHT_SPEED, FLIGHT_BOOST = 60, 2.5

local function getCharacter() return LocalPlayer.Character end
local function getRootPart() local c = getCharacter() return c and c:FindFirstChild("HumanoidRootPart") or (LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")) end
local function getHumanoid() local c = getCharacter() return c and c:FindFirstChildOfClass("Humanoid") end

function Physics.setWalkSpeed(v) local h = getHumanoid() if h then h.WalkSpeed = math.clamp(v, 0, 500) end end
function Physics.setJumpPower(v) local h = getHumanoid() if h then h.JumpPower = math.clamp(v, 0, 500) h.UseJumpPower = true end end

-- Optimization: Cache parts for Ghost Mode
local function updateGhostParts()
	ghostParts = {}
	local char = getCharacter()
	if char then
		for _, p in char:GetDescendants() do
			if p:IsA("BasePart") then table.insert(ghostParts, p) end
		end
	end
end

function Physics.enableFlight()
	if Physics.flightActive then return end
	local root = getRootPart() if not root then return end
	Physics.flightActive = true
	Physics.disableGhost()
	local hum = getHumanoid() if hum then hum.PlatformStand = true end
	flightVelocity = Instance.new("BodyVelocity", root)
	flightVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	flightGyro = Instance.new("BodyGyro", root)
	flightGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	flightGyro.P = 1e4
	flightGyro.D = 500
	flightConn = RunService.Heartbeat:Connect(function()
		local camCF = workspace.CurrentCamera.CFrame
		local direction = Vector3.zero
		local speed = FLIGHT_SPEED * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and FLIGHT_BOOST or 1)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then direction -= Vector3.new(0, 1, 0) end
		flightVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * speed or Vector3.zero
		flightGyro.CFrame = camCF
	end)
end

function Physics.disableFlight()
	if not Physics.flightActive then return end
	Physics.flightActive = false
	if flightConn then flightConn:Disconnect() end
	if flightVelocity then flightVelocity:Destroy() end
	if flightGyro then flightGyro:Destroy() end
	local hum = getHumanoid() if hum then hum.PlatformStand = false end
end

function Physics.toggleFlight()
	if Physics.flightActive then Physics.disableFlight() return false else Physics.enableFlight() return true end
end

function Physics.enableGhost()
	if Physics.ghostActive then return end
	Physics.ghostActive = true
	Physics.disableFlight()
	updateGhostParts()
	ghostLoop = RunService.Stepped:Connect(function() 
		for _, p in ipairs(ghostParts) do if p and p.Parent and p.CanCollide then p.CanCollide = false end end 
	end)
end

function Physics.disableGhost()
	if not Physics.ghostActive then return end
	Physics.ghostActive = false
	if ghostLoop then ghostLoop:Disconnect() ghostLoop = nil end
	for _, p in ipairs(ghostParts) do if p and p.Parent then p.CanCollide = true end end
end

function Physics.toggleGhost() if Physics.ghostActive then Physics.disableGhost() return false else Physics.enableGhost() return true end end
function Physics.resetAll() Physics.disableFlight() Physics.disableGhost() Physics.setWalkSpeed(16) Physics.setJumpPower(50) end
function Physics.saveCheckpoint(slot) local r = getRootPart() if r then Physics.checkpoints[slot] = r.CFrame return true end return false end
function Physics.loadCheckpoint(slot) local r = getRootPart() if r and Physics.checkpoints[slot] then r.CFrame = Physics.checkpoints[slot] return true end return false end
function Physics.clearCheckpoint(slot) slot = math.clamp(slot, 1, 3) Physics.checkpoints[slot] = nil end

-- ==========================================
-- [[ 4. TARGETING SYSTEM ]]
-- ==========================================
local Targeting = { followActive = false, followLoop = nil }

function Targeting.findPlayer(partial)
	if not partial or partial == "" or #partial < 2 then return nil end
	partial = partial:lower()
	local bestMatch, bestScore = nil, math.huge
	for _, p in Players:GetPlayers() do
		local n, d = p.Name:lower(), p.DisplayName:lower()
		if n:sub(1, #partial) == partial or d:sub(1, #partial) == partial then
			if #n < bestScore then bestScore = #n bestMatch = p end
		elseif n:find(partial) or d:find(partial) then
			if not bestMatch then bestMatch = p end
		end
	end
	return bestMatch
end

function Targeting.getPlayerList() local l = {} for _, p in Players:GetPlayers() do table.insert(l, {name = p.Name, displayName = p.DisplayName, userId = p.UserId}) end return l end

local function findTool(name)
	name = name:lower()
	for _, p in Players:GetPlayers() do
		local b = p:FindFirstChild("Backpack")
		if b then for _, v in b:GetChildren() do if v:IsA("Tool") and v.Name:lower():find(name) then return v end end end
		local c = p.Character
		if c then for _, v in c:GetChildren() do if v:IsA("Tool") and v.Name:lower():find(name) then return v end end end
	end
	for _, v in workspace:GetDescendants() do if v:IsA("Tool") and v.Name:lower():find(name) then return v end end
	return nil
end

function Targeting.startToolFollow(pName, tName, onStatus)
	Targeting.stopToolFollow()
	local target = Targeting.findPlayer(pName)
	local tool = findTool(tName or "")
	if not target then onStatus("Player not found: " .. pName, "danger") return end
	if not tool or not tool:FindFirstChild("Handle") then onStatus("Tool not found: " .. (tName or ""), "danger") return end
	local bp = Instance.new("BodyPosition", tool.Handle)
	bp.Name = "_FollowBP" bp.MaxForce = Vector3.new(1e6, 1e6, 1e6) bp.P, bp.D = 5000, 500
	Targeting.followActive = true
	onStatus("Following: " .. target.Name, "success")
	Targeting.followLoop = RunService.Heartbeat:Connect(function()
		local char = target.Character local root = char and char:FindFirstChild("HumanoidRootPart")
		if root and bp.Parent then bp.Position = bp.Position:Lerp(root.Position + Vector3.new(0, 3, 0), 0.15) end
	end)
end

function Targeting.stopToolFollow()
	Targeting.followActive = false
	if Targeting.followLoop then Targeting.followLoop:Disconnect() end
	for _, v in workspace:GetDescendants() do if v.Name == "_FollowBP" then v:Destroy() end end
end

function Targeting.teleportToPlayer(name, selfPlayer)
	local t = Targeting.findPlayer(name)
	local tr = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
	local sr = selfPlayer.Character and selfPlayer.Character:FindFirstChild("HumanoidRootPart")
	if tr and sr then sr.CFrame = tr.CFrame + Vector3.new(3, 0, 0) return true, "Teleported to " .. t.Name end
	return false, "Teleport Failed"
end

function Targeting.getPlayerPosition(name)
	local t = Targeting.findPlayer(name)
	local r = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
	if r then
		local p = r.Position return { player = t.Name, x = math.round(p.X), y = math.round(p.Y), z = math.round(p.Z) }
	end
end

-- ==========================================
-- [[ 5. UI CONSTRUCTOR SYSTEM ]]
-- ==========================================
local UI = {}

function UI.createScreenGui(name)
	local sg = Instance.new("ScreenGui", RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui)
	sg.Name = name sg.ResetOnSpawn = false sg.IgnoreGuiInset = true
	return sg
end

function UI.createMainPanel(parent)
	local f = Instance.new("Frame", parent)
	f.Size = UDim2.new(0.85, 0, 0.85, 0)
	f.Position = UDim2.new(0.5, 0, 0.5, 0)
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.BackgroundColor3 = Theme.Colors.Background
	f.BorderSizePixel = 0
	f.ClipsDescendants = true
	Instance.new("UICorner", f).CornerRadius = Theme.Radius.Panel
	local s = Instance.new("UIStroke", f)
	s.Color = Theme.Stroke.Color s.Thickness = Theme.Stroke.Thickness s.Transparency = Theme.Stroke.Transparency
	
	local sz = Instance.new("UISizeConstraint", f)
	sz.MaxSize = Vector2.new(450, 520) sz.MinSize = Vector2.new(300, 300)
	return f
end

function UI.createSidebar(parent)
	local s = Instance.new("Frame", parent)
	s.Size = UDim2.new(0, 75, 1, -60)
	s.Position = UDim2.new(0, 10, 0, 50)
	s.BackgroundTransparency = 1

	local g = Instance.new("UIGradient", s)
	g.Color = Theme.Gradients.Sidebar.Color
	g.Rotation = Theme.Gradients.Sidebar.Rotation
	
	local l = Instance.new("UIListLayout", s)
	l.Padding = UDim.new(0, 8) l.HorizontalAlignment = Enum.HorizontalAlignment.Center
	return s
end

function UI.createContentArea(parent)
	local c = Instance.new("ScrollingFrame", parent)
	c.Size = UDim2.new(1, -100, 1, -70)
	c.Position = UDim2.new(0, 90, 0, 60)
	c.BackgroundTransparency = 1 c.BorderSizePixel = 0
	c.ScrollBarThickness = 1 c.ScrollBarImageColor3 = Theme.Colors.Accent
	c.CanvasSize = UDim2.new(0,0,0,0)
	c.AutomaticCanvasSize = Enum.AutomaticSize.Y
	return c
end

function UI.createTabButton(parent, label, icon)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 65, 0, 65)
	b.BackgroundColor3 = Theme.Colors.Surface
	b.BackgroundTransparency = 1 b.Text = ""
	Instance.new("UICorner", b).CornerRadius = Theme.Radius.Button
	
	local i = Instance.new("TextLabel", b)
	i.Size = UDim2.new(1, 0, 0.6, 0) i.Text = icon i.TextSize = 24 i.BackgroundTransparency = 1
	i.TextColor3 = Theme.Colors.TextSecondary i.Font = Theme.Font.Body
	
	local t = Instance.new("TextLabel", b)
	t.Size = UDim2.new(1, 0, 0.4, 0) t.Position = UDim2.new(0, 0, 0.6, 0)
	t.Text = label t.TextSize = Theme.Size.SmallText t.BackgroundTransparency = 1
	t.TextColor3 = Theme.Colors.TextSecondary t.Font = Theme.Font.Label
	
	local function applyFeedback(active)
		local color = active and Theme.Colors.TextPrimary or Theme.Colors.TextSecondary
		TweenService:Create(i, TweenInfo.new(0.2), {TextColor3 = color}):Play()
		TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = color}):Play()
	end

	b.MouseEnter:Connect(function() if t.TextColor3 ~= Theme.Colors.TextPrimary then applyFeedback(true) end end)
	b.MouseLeave:Connect(function() if t.TextColor3 ~= Theme.Colors.TextPrimary then applyFeedback(false) end end)
	
	b.MouseButton1Down:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play()
	end)
	b.MouseButton1Up:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.new(0, 65, 0, 65)}):Play()
	end)
	
	return b, t, i
end

function UI.createCard(parent, size)
	local c = Instance.new("Frame", parent)
	c.Size = size or UDim2.new(1, -10, 0, 0)
	c.AutomaticSize = Enum.AutomaticSize.Y
	c.BackgroundColor3 = Theme.Colors.Surface
	c.BackgroundTransparency = Theme.Transparency.Surface
	Instance.new("UICorner", c).CornerRadius = Theme.Radius.Button
	local p = Instance.new("UIPadding", c)
	p.PaddingLeft = UDim.new(0, 10) p.PaddingRight = UDim.new(0, 10)
	p.PaddingTop = UDim.new(0, 10) p.PaddingBottom = UDim.new(0, 10)
	Instance.new("UIListLayout", c).Padding = UDim.new(0, 8)
	
	local s = Instance.new("UIStroke", c)
	s.Color = Theme.Colors.Divider s.Thickness = 1 s.Transparency = 0.8
	
	return c
end

function UI.createSectionHeader(parent, text)
	local h = Instance.new("TextLabel", parent)
	h.Size = UDim2.new(1, 0, 0, 20) h.BackgroundTransparency = 1
	h.Text = text h.TextColor3 = Theme.Colors.AccentGlow
	h.TextSize = Theme.Size.LabelText h.Font = Theme.Font.Title h.TextXAlignment = Enum.TextXAlignment.Left
end

function UI.createSlider(parent, label, min, max, default, callback)
	local f = Instance.new("Frame", parent) f.Size = UDim2.new(1, 0, 0, 45) f.BackgroundTransparency = 1
	local l = Instance.new("TextLabel", f) l.Size = UDim2.new(1, 0, 0, 15) l.Text = label .. ": " .. default
	l.TextColor3 = Theme.Colors.TextSecondary l.TextSize = Theme.Size.SmallText l.Font = Theme.Font.Label
	l.BackgroundTransparency = 1 l.TextXAlignment = Enum.TextXAlignment.Left
	
	local track = Instance.new("Frame", f) track.Size = UDim2.new(1, 0, 0, 4) track.Position = UDim2.new(0, 0, 0, 25)
	track.BackgroundColor3 = Theme.Colors.SliderTrack Instance.new("UICorner", track).CornerRadius = Theme.Radius.Slider
	
	local fill = Instance.new("Frame", track) fill.BackgroundColor3 = Theme.Colors.SliderFill
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0) Instance.new("UICorner", fill).CornerRadius = Theme.Radius.Slider
	
	local thumb = Instance.new("Frame", track) thumb.Size = UDim2.new(0, 12, 0, 12) thumb.AnchorPoint = Vector2.new(0.5, 0.5)
	thumb.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0) thumb.BackgroundColor3 = Theme.Colors.SliderThumb
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
	
	local dragging = false
	local function update(input)
		local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * pos)
		fill.Size = UDim2.new(pos, 0, 1, 0) 
		thumb.Position = UDim2.new(pos, 0, 0.5, 0)
		l.Text = label .. ": " .. val 
		callback(val)
	end
	thumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
	
	return f, function() return tonumber(l.Text:match("%d+$")) end
end

function UI.createToggle(parent, label, default)
	local b = Instance.new("TextButton", parent) b.Size = UDim2.new(1, 0, 0, 40) b.BackgroundColor3 = Theme.Colors.SurfaceAlt
	b.Text = "  " .. label b.TextColor3 = Theme.Colors.TextPrimary b.TextXAlignment = Enum.TextXAlignment.Left
	b.Font = Theme.Font.Body b.TextSize = Theme.Size.BodyText
	Instance.new("UICorner", b).CornerRadius = Theme.Radius.Input
	
	local indicator = Instance.new("Frame", b) indicator.Size = UDim2.new(0, 40, 0, 20) indicator.Position = UDim2.new(1, -50, 0.5, -10)
	indicator.BackgroundColor3 = default and Theme.Colors.Success or Theme.Colors.SliderTrack
	local ic = Instance.new("UICorner", indicator) ic.CornerRadius = UDim.new(1, 0)
	
	local active = default
	local thumb = Instance.new("Frame", indicator)
	thumb.Size = UDim2.new(0, 16, 0, 16)
	thumb.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	thumb.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)

	b.MouseButton1Click:Connect(function() 
		active = not active 
		TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = active and Theme.Colors.Success or Theme.Colors.SliderTrack}):Play()
		TweenService:Create(thumb, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
	end)
	
	return b, function() return active end, function(v) 
		active = v 
		indicator.BackgroundColor3 = v and Theme.Colors.Success or Theme.Colors.SliderTrack 
		thumb.Position = v and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) 
	end
end

function UI.createButton(parent, text, style)
	local b = Instance.new("TextButton", parent) b.Size = UDim2.new(1, 0, 0, 40)
	b.BackgroundColor3 = Theme.Colors[style:sub(1,1):upper()..style:sub(2)] or Theme.Colors.Accent
	b.Text = text b.TextColor3 = Color3.new(1,1,1) b.Font = Theme.Font.Label b.TextSize = Theme.Size.BodyText
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = Theme.Radius.Button
	
	local styleKey = style:sub(1,1):upper()..style:sub(2)
	if Theme.Gradients[styleKey] then
		local g = Instance.new("UIGradient", b)
		g.Color = Theme.Gradients[styleKey].Color
		g.Rotation = Theme.Gradients[styleKey].Rotation
	end
	
	b.MouseButton1Down:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.3, Size = UDim2.new(0.98, 0, 0, 38)}):Play() end)
	b.MouseButton1Up:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0, Size = UDim2.new(1, 0, 0, 40)}):Play() end)
	
	return b
end

function UI.createInput(parent, placeholder)
	local i = Instance.new("TextBox", parent) i.Size = UDim2.new(1, 0, 0, 40) i.BackgroundColor3 = Theme.Colors.SurfaceAlt
	i.PlaceholderText = placeholder i.Text = "" i.TextColor3 = Theme.Colors.TextPrimary
	i.PlaceholderColor3 = Theme.Colors.TextMuted i.Font = Theme.Font.Body i.TextSize = Theme.Size.BodyText
	Instance.new("UICorner", i).CornerRadius = Theme.Radius.Input
	local p = Instance.new("UIPadding", i) p.PaddingLeft = UDim.new(0, 8)
	return i
end

function UI.showToast(parent, msg, style)
	local t = Instance.new("Frame", parent) t.Size = UDim2.new(0, 260, 0, 50) t.Position = UDim2.new(0.5, -130, 1, 60)
	t.BackgroundColor3 = Theme.Colors.Surface t.BorderSizePixel = 0 Instance.new("UICorner", t).CornerRadius = Theme.Radius.Button
	
	local styleKey = style:sub(1,1):upper()..style:sub(2)
	local l = Instance.new("TextLabel", t) l.Size = UDim2.new(1, -20, 1, 0) l.Position = UDim2.new(0, 10, 0, 0)
	l.Text = msg l.TextColor3 = Theme.Colors[styleKey] or Color3.new(1,1,1)
	l.BackgroundTransparency = 1 l.Font = Theme.Font.Label l.TextSize = Theme.Size.SmallText l.TextWrapped = true
	
	local s = Instance.new("UIStroke", t)
	s.Color = Theme.Colors[styleKey] or Theme.Colors.Accent s.Thickness = 1 s.Transparency = 0.5

	TweenService:Create(t, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -130, 0.85, -50)}):Play()
	task.delay(2.5, function() 
		TweenService:Create(t, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -130, 1, 60)}):Play() 
		task.wait(0.3) t:Destroy() 
	end)
end

function UI.createFloatingIcon(parent, callback)
	local b = Instance.new("TextButton", parent) b.Size = UDim2.new(0, 55, 0, 55) b.Position = UDim2.new(1, -65, 0.5, -27)
	b.BackgroundColor3 = Theme.Colors.FloatingIcon b.Text = "⚡" b.TextSize = 24 b.TextColor3 = Color3.new(1,1,1)
	b.AutoButtonColor = true
	Instance.new("UICorner", b).CornerRadius = Theme.Radius.FloatIcon
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.new(1,1,1) s.Thickness = 2 s.Transparency = 0.6
	
	b.MouseButton1Down:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.new(0, 48, 0, 48)}):Play() end)
	b.MouseButton1Up:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.new(0, 55, 0, 55)}):Play() end)
	
	b.MouseButton1Click:Connect(callback) return b
end

-- ==========================================
-- [[ 6. MAIN APPLICATION LOGIC ]]
-- ==========================================
local screenGui = UI.createScreenGui("AdvancedAdminDashboard")
local mainPanel = UI.createMainPanel(screenGui)
mainPanel.Visible = false

-- Create CanvasGroup for high-quality fade animations
local cg = Instance.new("CanvasGroup", mainPanel)
cg.Size = UDim2.new(1, 0, 1, 0)
cg.BackgroundTransparency = 1
cg.Name = "AnimationContainer"

local sidebar = UI.createSidebar(mainPanel)
local contentArea = UI.createContentArea(mainPanel)

local activeTab = nil
local tabButtons, pages = {}, {}

local function setActiveTab(name, btn, icon, lbl)
	if activeTab == name then return end
	for n, d in tabButtons do
		TweenService:Create(d.btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(d.icon, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextSecondary}):Play()
		TweenService:Create(d.lbl, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextSecondary}):Play()
		if pages[n] then pages[n].Visible = false end
	end
	activeTab = name
	TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
	TweenService:Create(icon, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.AccentGlow}):Play()
	TweenService:Create(lbl, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextPrimary}):Play()
	if pages[name] then pages[name].Visible = true end
end

local function registerTab(name, icon, label)
	local btn, lbl, iconLbl = UI.createTabButton(sidebar, label, icon)
	tabButtons[name] = {btn = btn, icon = iconLbl, lbl = lbl}
	local page = Instance.new("Frame", contentArea)
	page.Size = UDim2.new(1, 0, 0, 0) page.AutomaticSize = Enum.AutomaticSize.Y
	page.BackgroundTransparency = 1 page.Visible = false
	Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
	pages[name] = page
	btn.MouseButton1Click:Connect(function() setActiveTab(name, btn, iconLbl, lbl) end)
	return page
end

local function createNote(parent, text)
	local n = Instance.new("TextLabel", parent)
	n.Size = UDim2.new(1, 0, 0, 30) n.BackgroundTransparency = 1
	n.Text = text n.TextColor3 = Theme.Colors.TextMuted
	n.TextSize = Theme.Size.SmallText n.Font = Theme.Font.Body
	n.TextWrapped = true n.TextXAlignment = Enum.TextXAlignment.Left
	return n
end

local movePage = registerTab("move", "🏃", "Movement")
local ghostPage = registerTab("ghost", "👻", "Ghost")
local checkPage = registerTab("check", "📍", "Locations")
local targetPage = registerTab("target", "🎯", "Targeting")

do
	local card = UI.createCard(movePage)
	UI.createSectionHeader(card, "Speed & Jump")
	UI.createSlider(card, "Walk Speed", 0, 250, 16, Physics.setWalkSpeed)
	UI.createSlider(card, "Jump Power", 0, 250, 50, Physics.setJumpPower)
	UI.createButton(card, "Reset Movement", "danger").MouseButton1Click:Connect(function() Physics.setWalkSpeed(16) Physics.setJumpPower(50) UI.showToast(screenGui, "Movement Reset", "info") end)
	
	local flightCard = UI.createCard(movePage)
	UI.createSectionHeader(flightCard, "Flight Navigation")
	local fTog = UI.createToggle(flightCard, "Enable Flight Mode", false)
	fTog.MouseButton1Click:Connect(function() 
		local active = Physics.toggleFlight() 
		UI.showToast(screenGui, active and "✈ Flight Mode Enabled" or "Flight Mode Disabled", active and "success" or "info") 
	end)
	createNote(flightCard, "WASD to Move | Space to Ascend | Ctrl to Descend | Shift to Boost")
end

do
	local card = UI.createCard(ghostPage)
	UI.createSectionHeader(card, "Developer Ghost Mode")
	local gTog = UI.createToggle(card, "Noclip (Ghost Mode)", false)
	gTog.MouseButton1Click:Connect(function() 
		local active = Physics.toggleGhost() 
		UI.showToast(screenGui, active and "👻 Ghost Mode Enabled" or "Ghost Mode Disabled", active and "warning" or "info") 
	end)
	createNote(card, "Allows passing through walls. Periodically disables character collision.")
	UI.createButton(card, "Reset All Physics", "danger").MouseButton1Click:Connect(function() Physics.resetAll() UI.showToast(screenGui, "All Systems Reset", "info") end)
end

do
	local card = UI.createCard(checkPage)
	UI.createSectionHeader(card, "Coordinate Checkpoints")
	for i = 1, 3 do
		local row = Instance.new("Frame", card) row.Size = UDim2.new(1, 0, 0, 38) row.BackgroundTransparency = 1
		Instance.new("UIListLayout", row).FillDirection = Enum.FillDirection.Horizontal
		Instance.new("UIListLayout", row).Padding = UDim.new(0, 8)
		local l = Instance.new("TextLabel", row) l.Size = UDim2.new(0, 60, 1, 0) l.Text = "Slot " .. i l.TextColor3 = Theme.Colors.TextPrimary l.BackgroundTransparency = 1
		local sBtn = UI.createButton(row, "Save", "primary") sBtn.Size = UDim2.new(0, 75, 1, -4)
		sBtn.MouseButton1Click:Connect(function() Physics.saveCheckpoint(i) UI.showToast(screenGui, "Saved Slot " .. i, "success") end)
		local lBtn = UI.createButton(row, "Load", "success") lBtn.Size = UDim2.new(0, 75, 1, -4)
		lBtn.MouseButton1Click:Connect(function() if Physics.loadCheckpoint(i) then UI.showToast(screenGui, "Teleported", "success") else UI.showToast(screenGui, "No Data in Slot " .. i, "warning") end end)
		local cBtn = UI.createButton(row, "Clear", "danger") cBtn.Size = UDim2.new(0, 65, 1, -4)
		cBtn.MouseButton1Click:Connect(function() Physics.clearCheckpoint(i) UI.showToast(screenGui, "Slot " .. i .. " Cleared", "info") end)
	end
end

do
	local card = UI.createCard(targetPage)
	UI.createSectionHeader(card, "Smart Tool Follow")
	local pIn = UI.createInput(card, "Target Player Name")
	local tIn = UI.createInput(card, "Tool Name (Partial)")
	UI.createButton(card, "Start Following", "primary").MouseButton1Click:Connect(function() 
		if pIn.Text == "" then UI.showToast(screenGui, "Please enter a player name", "warning") return end
		Targeting.startToolFollow(pIn.Text, tIn.Text, function(m, s) UI.showToast(screenGui, m, s) end) 
	end)
	UI.createButton(card, "Stop Follow", "danger").MouseButton1Click:Connect(function() Targeting.stopToolFollow() UI.showToast(screenGui, "Follow Stopped", "info") end)

	local teleCard = UI.createCard(targetPage)
	UI.createSectionHeader(teleCard, "Instant Teleport")
	local teleIn = UI.createInput(teleCard, "Player to Teleport To")
	UI.createButton(teleCard, "Teleport Now", "success").MouseButton1Click:Connect(function() 
		if teleIn.Text == "" then UI.showToast(screenGui, "Enter a player name", "warning") return end
		local ok, msg = Targeting.teleportToPlayer(teleIn.Text, LocalPlayer) UI.showToast(screenGui, msg, ok and "success" or "danger") 
	end)

	local listCard = UI.createCard(targetPage)
	UI.createSectionHeader(listCard, "Server Players")
	
	local searchIn = UI.createInput(listCard, "Filter Players...")
	local listFrame = Instance.new("Frame", listCard) listFrame.Size = UDim2.new(1, 0, 0, 0) listFrame.AutomaticSize = Enum.AutomaticSize.Y listFrame.BackgroundTransparency = 1
	Instance.new("UIListLayout", listFrame).Padding = UDim.new(0, 4)
	
	local function refreshList(filter)
		for _, v in listFrame:GetChildren() do if not v:IsA("UIListLayout") then v:Destroy() end end
		for _, info in Targeting.getPlayerList() do
			local nameMatch = info.name:lower():find(filter:lower() or "", 1, true)
			local dispMatch = info.displayName:lower():find(filter:lower() or "", 1, true)
			if not filter or filter == "" or nameMatch or dispMatch then
				local r = Instance.new("TextButton", listFrame)
				r.Size = UDim2.new(1, 0, 0, 28) r.BackgroundColor3 = Theme.Colors.SurfaceAlt r.BackgroundTransparency = 0.5
				r.Text = ("  %s  (@%s)"):format(info.displayName, info.name)
				r.TextColor3 = Theme.Colors.TextPrimary r.TextSize = Theme.Size.SmallText r.Font = Theme.Font.Mono r.TextXAlignment = Enum.TextXAlignment.Left
				Instance.new("UICorner", r).CornerRadius = UDim.new(0, 6)
				r.MouseButton1Click:Connect(function()
					teleIn.Text = info.name pIn.Text = info.name UI.showToast(screenGui, "Selected " .. info.name, "info") 
				end)
			end
		end
	end
	
	searchIn:GetPropertyChangedSignal("Text"):Connect(function() refreshList(searchIn.Text) end)
	refreshList()
	local conn1 = Players.PlayerAdded:Connect(function() refreshList(searchIn.Text) end)
	local conn2 = Players.PlayerRemoving:Connect(function() refreshList(searchIn.Text) end)
	
	mainPanel.Destroying:Connect(function()
		conn1:Disconnect() conn2:Disconnect()
	end)
end

-- Boundary-Aware Draggable Logic for Mobile
local function initDraggable(frame)
	local dragging, dragStart, startPos, moved = false, nil, nil, false
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true moved = false dragStart = input.Position startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			if delta.Magnitude > 5 then moved = true end
			local targetX = startPos.X.Offset + delta.X
			local targetY = startPos.Y.Offset + delta.Y
			
			-- Constrain to screen boundaries
			local screen = workspace.CurrentCamera.ViewportSize
			targetX = math.clamp(targetX, -screen.X/2 + frame.AbsoluteSize.X/2, screen.X/2 - frame.AbsoluteSize.X/2)
			targetY = math.clamp(targetY, -screen.Y/2 + frame.AbsoluteSize.Y/2, screen.Y/2 - frame.AbsoluteSize.Y/2)
			
			frame.Position = UDim2.new(startPos.X.Scale, targetX, startPos.Y.Scale, targetY)
		end
	end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local panelVisible = false
local function togglePanel()
	panelVisible = not panelVisible
	if panelVisible then
		mainPanel.Visible = true 
		cg.GroupTransparency = 1
		mainPanel.Size = UDim2.new(0.3, 0, 0.3, 0)
		TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0.85, 0, 0.85, 0)}):Play()
		TweenService:Create(cg, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()
	else
		local t = TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0.1, 0, 0.1, 0)})
		TweenService:Create(cg, TweenInfo.new(0.3), {GroupTransparency = 1}):Play()
		t:Play()
		t.Completed:Connect(function() mainPanel.Visible = false end)
	end
end

initDraggable(mainPanel)
UI.createFloatingIcon(screenGui, togglePanel)
setActiveTab("move", tabButtons.move.btn, tabButtons.move.icon, tabButtons.move.lbl)

local title = Instance.new("TextLabel", mainPanel)
title.Size = UDim2.new(0, 220, 0, 30) title.Position = UDim2.new(0, 96, 0, 8)
title.Text = "Advanced Admin Panel" title.TextColor3 = Theme.Colors.TextPrimary
title.Font = Theme.Font.Title title.TextSize = Theme.Size.TitleText title.BackgroundTransparency = 1 title.TextXAlignment = Enum.TextXAlignment.Left title.ZIndex = 10

local version = Instance.new("TextLabel", mainPanel)
version.Size = UDim2.new(0, 150, 0, 30) version.Position = UDim2.new(0, 96, 0, 22)
version.Text = "v2.5 • Final Pro Mobile" version.TextColor3 = Theme.Colors.TextMuted
version.Font = Theme.Font.Mono version.TextSize = Theme.Size.SmallText version.BackgroundTransparency = 1 version.TextXAlignment = Enum.TextXAlignment.Left version.ZIndex = 10

local closeBtn = Instance.new("TextButton", mainPanel)
closeBtn.Size = UDim2.new(0, 32, 0, 32) closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Theme.Colors.Danger closeBtn.Text = "✕" closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Theme.Font.Label closeBtn.TextSize = 15 closeBtn.ZIndex = 11
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(togglePanel)

-- Move content to CanvasGroup for smooth fade animation
for _, v in ipairs(mainPanel:GetChildren()) do 
	if v ~= cg and not v:IsA("UISizeConstraint") then 
		v.Parent = cg 
	end 
end

LocalPlayer.CharacterAdded:Connect(function() task.wait(1) Physics.resetAll() updateGhostParts() end)
print("[AdminPanel] Professional Mobile Version loaded successfully.")
