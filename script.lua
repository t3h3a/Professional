-- Standalone_Unified.lua
-- Single unified Roblox LocalScript generated from Theme_Config, UI_Module, Physics_Module, Targeting_Module, and Loader.
-- Place/run this as one LocalScript. No external ModuleScript files are required.

local CoreGui = game:GetService("CoreGui")

local Theme = {}
local UI = {}
local Physics = {}
local Targeting = {}

-- ==============================
-- Theme_Config.lua
-- ==============================
do
-- Theme_Config.lua
-- الألوان، الظلال، والزوايا المنحنية للواجهة

Theme.Colors = {
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
}

Theme.Transparency = {
	Background   = 0.08,
	Surface      = 0.12,
	SurfaceAlt   = 0.05,
	Stroke       = 0.75,
	Overlay      = 0.35,
}

Theme.Radius = {
	Panel        = UDim.new(0, 16),
	Button       = UDim.new(0, 10),
	Slider       = UDim.new(0, 6),
	Chip         = UDim.new(0, 20),
	FloatIcon    = UDim.new(0, 28),
	Input        = UDim.new(0, 8),
}

Theme.Stroke = {
	Thickness    = 1,
	Color        = Color3.fromRGB(80, 100, 200),
	Transparency = 0.72,
}

Theme.Gradients = {
	Sidebar = {
		Color  = ColorSequence.new({
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
}

Theme.Font = {
	Title    = Enum.Font.GothamBold,
	Body     = Enum.Font.Gotham,
	Mono     = Enum.Font.RobotoMono,
	Label    = Enum.Font.GothamMedium,
}

Theme.Size = {
	TitleText  = 15,
	BodyText   = 13,
	LabelText  = 11,
	SmallText  = 10,
}
end

-- ==============================
-- UI_Module.lua
-- ==============================
do
-- UI_Module.lua
-- بناء العناصر البصرية: أزرار، سلايدرات، قوائم، أنيميشن

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==============================
-- مساعد: إنشاء UICorner
-- ==============================
local function applyCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or Theme.Radius.Button
	corner.Parent = instance
	return corner
end

-- ==============================
-- مساعد: إنشاء UIStroke
-- ==============================
local function applyStroke(instance)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Stroke.Color
	stroke.Thickness = Theme.Stroke.Thickness
	stroke.Transparency = Theme.Stroke.Transparency
	stroke.Parent = instance
	return stroke
end

-- ==============================
-- مساعد: إنشاء UIGradient
-- ==============================
local function applyGradient(instance, gradientDef)
	local grad = Instance.new("UIGradient")
	grad.Color = gradientDef.Color
	grad.Rotation = gradientDef.Rotation
	grad.Parent = instance
	return grad
end

-- ==============================
-- تغيير شفافية بـ Tween
-- ==============================
local function tweenTransparency(obj, prop, target, duration)
	TweenService:Create(obj, TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quad), {[prop] = target}):Play()
end

-- ==============================
-- إنشاء الـ ScreenGui الرئيسية
-- ==============================
function UI.createScreenGui(name)
	local gui = Instance.new("ScreenGui")
	gui.Name = name or "AdminPanel"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 100
	gui.Parent = CoreGui
	return gui
end

-- ==============================
-- إنشاء اللوحة الرئيسية (Main Panel)
-- ==============================
function UI.createMainPanel(parent)
	local panel = Instance.new("Frame")
	panel.Name = "MainPanel"
	panel.Size = UDim2.new(0, 360, 0, 520)
	panel.Position = UDim2.new(0.5, -180, 0.5, -260)
	panel.BackgroundColor3 = Theme.Colors.Background
	panel.BackgroundTransparency = Theme.Transparency.Background
	panel.BorderSizePixel = 0
	panel.Parent = parent
	applyCorner(panel, Theme.Radius.Panel)
	applyStroke(panel)

	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 360 / 520
	aspect.Parent = panel

	return panel
end

-- ==============================
-- إنشاء القائمة الجانبية (Sidebar)
-- ==============================
function UI.createSidebar(parent)
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 90, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundColor3 = Theme.Colors.Surface
	sidebar.BackgroundTransparency = Theme.Transparency.Surface
	sidebar.BorderSizePixel = 0
	sidebar.Parent = parent
	applyCorner(sidebar, Theme.Radius.Panel)
	applyGradient(sidebar, Theme.Gradients.Sidebar)

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 6)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = sidebar

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 14)
	padding.Parent = sidebar

	return sidebar
end

-- ==============================
-- إنشاء منطقة المحتوى (Content Area)
-- ==============================
function UI.createContentArea(parent)
	local area = Instance.new("ScrollingFrame")
	area.Name = "ContentArea"
	area.Size = UDim2.new(1, -100, 1, -10)
	area.Position = UDim2.new(0, 96, 0, 5)
	area.BackgroundTransparency = 1
	area.BorderSizePixel = 0
	area.ScrollBarThickness = 3
	area.ScrollBarImageColor3 = Theme.Colors.Accent
	area.CanvasSize = UDim2.new(0, 0, 0, 0)
	area.AutomaticCanvasSize = Enum.AutomaticSize.Y
	area.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.Parent = area

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = area

	return area
end

-- ==============================
-- زر القائمة الجانبية (Tab Button)
-- ==============================
function UI.createTabButton(parent, label, icon)
	local btn = Instance.new("TextButton")
	btn.Name = "Tab_" .. label
	btn.Size = UDim2.new(0, 72, 0, 64)
	btn.BackgroundColor3 = Theme.Colors.SurfaceAlt
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.BorderSizePixel = 0
	btn.Parent = parent
	applyCorner(btn, UDim.new(0, 10))

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(1, 0, 0, 26)
	iconLabel.Position = UDim2.new(0, 0, 0, 10)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = icon or "•"
	iconLabel.TextColor3 = Theme.Colors.TextSecondary
	iconLabel.TextSize = 20
	iconLabel.Font = Theme.Font.Title
	iconLabel.Parent = btn

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0, 16)
	textLabel.Position = UDim2.new(0, 0, 0, 38)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = label
	textLabel.TextColor3 = Theme.Colors.TextSecondary
	textLabel.TextSize = Theme.Size.SmallText
	textLabel.Font = Theme.Font.Label
	textLabel.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
		TweenService:Create(iconLabel, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.AccentGlow}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(iconLabel, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextSecondary}):Play()
	end)

	return btn, textLabel, iconLabel
end

-- ==============================
-- زر عادي (Primary / Danger)
-- ==============================
function UI.createButton(parent, text, style)
	style = style or "primary"

	local btn = Instance.new("TextButton")
	btn.Name = "Btn_" .. text
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = style == "danger" and Theme.Colors.Danger or Theme.Colors.Accent
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Theme.Colors.TextPrimary
	btn.TextSize = Theme.Size.BodyText
	btn.Font = Theme.Font.Label
	btn.Parent = parent
	applyCorner(btn, Theme.Radius.Button)

	local gradDef = style == "danger" and Theme.Gradients.Danger
		or style == "success" and Theme.Gradients.Success
		or Theme.Gradients.Button
	applyGradient(btn, gradDef)

	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.25}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
	end)

	return btn
end

-- ==============================
-- Toggle (تفعيل / إيقاف)
-- ==============================
function UI.createToggle(parent, labelText, default)
	local state = default or false

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -56, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Theme.Colors.TextPrimary
	label.TextSize = Theme.Size.BodyText
	label.Font = Theme.Font.Body
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(0, 44, 0, 24)
	track.Position = UDim2.new(1, -44, 0.5, -12)
	track.BackgroundColor3 = state and Theme.Colors.Accent or Theme.Colors.SliderTrack
	track.Text = ""
	track.BorderSizePixel = 0
	track.Parent = container
	applyCorner(track, UDim.new(0, 12))

	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 18, 0, 18)
	thumb.Position = state and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	thumb.BackgroundColor3 = Theme.Colors.TextPrimary
	thumb.BorderSizePixel = 0
	thumb.Parent = track
	applyCorner(thumb, UDim.new(0, 9))

	track.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(track, TweenInfo.new(0.2), {
			BackgroundColor3 = state and Theme.Colors.Accent or Theme.Colors.SliderTrack
		}):Play()
		TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Position = state and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		}):Play()
	end)

	return track, function() return state end
end

-- ==============================
-- Slider مع دعم اللمس
-- ==============================
function UI.createSlider(parent, labelText, min, max, default, onChanged)
	min = min or 0
	max = max or 100
	default = math.clamp(default or min, min, max)

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 56)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local labelRow = Instance.new("Frame")
	labelRow.Size = UDim2.new(1, 0, 0, 20)
	labelRow.BackgroundTransparency = 1
	labelRow.Parent = container

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.7, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Theme.Colors.TextPrimary
	lbl.TextSize = Theme.Size.BodyText
	lbl.Font = Theme.Font.Body
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = labelRow

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
	valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(default)
	valueLabel.TextColor3 = Theme.Colors.Accent
	valueLabel.TextSize = Theme.Size.BodyText
	valueLabel.Font = Theme.Font.Mono
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = labelRow

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 10)
	track.Position = UDim2.new(0, 0, 0, 30)
	track.BackgroundColor3 = Theme.Colors.SliderTrack
	track.BorderSizePixel = 0
	track.Parent = container
	applyCorner(track, Theme.Radius.Slider)

	local fill = Instance.new("Frame")
	local initRatio = (default - min) / (max - min)
	fill.Size = UDim2.new(initRatio, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Colors.SliderFill
	fill.BorderSizePixel = 0
	fill.Parent = track
	applyCorner(fill, Theme.Radius.Slider)

	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 18, 0, 18)
	thumb.Position = UDim2.new(initRatio, -9, 0.5, -9)
	thumb.BackgroundColor3 = Theme.Colors.SliderThumb
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 3
	thumb.Parent = track
	applyCorner(thumb, UDim.new(0, 9))

	local dragging = false
	local currentValue = default

	local function updateSlider(inputX)
		local absPos = track.AbsolutePosition.X
		local absSize = track.AbsoluteSize.X
		local ratio = math.clamp((inputX - absPos) / absSize, 0, 1)
		local value = math.floor(min + ratio * (max - min))
		if value ~= currentValue then
			currentValue = value
			fill.Size = UDim2.new(ratio, 0, 1, 0)
			thumb.Position = UDim2.new(ratio, -9, 0.5, -9)
			valueLabel.Text = tostring(value)
			if onChanged then onChanged(value) end
		end
	end

	thumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or
		   input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging then
			if input.UserInputType == Enum.UserInputType.Touch then
				updateSlider(input.Position.X)
			elseif input.UserInputType == Enum.UserInputType.MouseMovement then
				updateSlider(input.Position.X)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or
		   input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or
		   input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input.Position.X)
		end
	end)

	return container, function() return currentValue end
end

-- ==============================
-- عنوان قسم (Section Header)
-- ==============================
function UI.createSectionHeader(parent, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 22)
	lbl.BackgroundTransparency = 1
	lbl.Text = string.upper(text)
	lbl.TextColor3 = Theme.Colors.TextMuted
	lbl.TextSize = Theme.Size.LabelText
	lbl.Font = Theme.Font.Label
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LetterSpacing = 3
	lbl.Parent = parent
	return lbl
end

-- ==============================
-- بطاقة (Card / Container)
-- ==============================
function UI.createCard(parent, title)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.BackgroundColor3 = Theme.Colors.Surface
	card.BackgroundTransparency = Theme.Transparency.Surface
	card.BorderSizePixel = 0
	card.Parent = parent
	applyCorner(card, UDim.new(0, 12))
	applyStroke(card)

	local padding = Instance.new("UIPadding")
	padding.PaddingAll = UDim.new(0, 12)
	padding.Parent = card

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = card

	if title then
		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, 0, 0, 18)
		header.BackgroundTransparency = 1
		header.Text = title
		header.TextColor3 = Theme.Colors.TextSecondary
		header.TextSize = Theme.Size.LabelText
		header.Font = Theme.Font.Label
		header.TextXAlignment = Enum.TextXAlignment.Left
		header.Parent = card
	end

	return card
end

-- ==============================
-- حقل إدخال نص (Text Input)
-- ==============================
function UI.createInput(parent, placeholder)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 34)
	box.BackgroundColor3 = Theme.Colors.SurfaceAlt
	box.BorderSizePixel = 0
	box.Text = ""
	box.PlaceholderText = placeholder or ""
	box.PlaceholderColor3 = Theme.Colors.TextMuted
	box.TextColor3 = Theme.Colors.TextPrimary
	box.TextSize = Theme.Size.BodyText
	box.Font = Theme.Font.Mono
	box.ClearTextOnFocus = false
	box.Parent = parent
	applyCorner(box, Theme.Radius.Input)
	applyStroke(box)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = box

	return box
end

-- ==============================
-- الأيقونة العائمة القابلة للسحب
-- ==============================
function UI.createFloatingIcon(parent, onToggle)
	local icon = Instance.new("TextButton")
	icon.Name = "FloatingIcon"
	icon.Size = UDim2.new(0, 56, 0, 56)
	icon.Position = UDim2.new(0, 16, 0.75, 0)
	icon.BackgroundColor3 = Theme.Colors.FloatingIcon
	icon.Text = "⚙"
	icon.TextSize = 24
	icon.TextColor3 = Color3.fromRGB(255, 255, 255)
	icon.Font = Theme.Font.Title
	icon.BorderSizePixel = 0
	icon.ZIndex = 200
	icon.Parent = parent
	applyCorner(icon, Theme.Radius.FloatIcon)
	applyStroke(icon)

	-- سحب الأيقونة (Drag)
	local dragging = false
	local dragStart, startPos

	icon.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or
		   input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = icon.Position
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging then
			local delta = input.Position - dragStart
			icon.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or
		   input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	icon.MouseButton1Click:Connect(function()
		if not dragging and onToggle then onToggle() end
	end)

	TweenService:Create(icon, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		BackgroundColor3 = Theme.Colors.AccentGlow
	}):Play()

	return icon
end

-- ==============================
-- نافذة منبثقة بسيطة (Toast)
-- ==============================
function UI.showToast(parent, message, style)
	style = style or "info"
	local colorMap = {
		info    = Theme.Colors.Accent,
		success = Theme.Colors.Success,
		warning = Theme.Colors.Warning,
		danger  = Theme.Colors.Danger,
	}

	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0, 220, 0, 40)
	toast.Position = UDim2.new(0.5, -110, 0, -50)
	toast.BackgroundColor3 = colorMap[style] or Theme.Colors.Accent
	toast.BorderSizePixel = 0
	toast.ZIndex = 500
	toast.Parent = parent
	applyCorner(toast, UDim.new(0, 10))

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = message
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = Theme.Size.BodyText
	lbl.Font = Theme.Font.Label
	lbl.ZIndex = 501
	lbl.Parent = toast

	TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -110, 0, 16)}):Play()
	task.delay(2.5, function()
		TweenService:Create(toast, TweenInfo.new(0.25), {Position = UDim2.new(0.5, -110, 0, -50)}):Play()
		task.wait(0.3)
		toast:Destroy()
	end)
end
end

-- ==============================
-- Physics_Module.lua
-- ==============================
do
-- Physics_Module.lua
-- نظام الطيران، السرعة، القفز، وضع الشبح (Ghost Mode)

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer   = Players.LocalPlayer
local Camera        = workspace.CurrentCamera

-- ==============================
-- الحالة الداخلية
-- ==============================
local flightActive   = false
local ghostActive    = false
local flightVelocity = nil
local ghostLoop      = nil
local flightConn     = nil
local FLIGHT_SPEED   = 60
local FLIGHT_BOOST   = 2.5

-- ==============================
-- مساعد: الحصول على الشخصية
-- ==============================
local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRootPart()
	local char = getCharacter()
	return char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
	local char = getCharacter()
	return char:FindFirstChildOfClass("Humanoid")
end

-- ==============================
-- تعديل السرعة (WalkSpeed)
-- ==============================
function Physics.setWalkSpeed(value)
	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = math.clamp(value, 0, 500)
	end
end

-- ==============================
-- تعديل قوة القفز (JumpPower)
-- ==============================
function Physics.setJumpPower(value)
	local hum = getHumanoid()
	if hum then
		hum.JumpPower = math.clamp(value, 0, 500)
		hum.UseJumpPower = true
	end
end

-- ==============================
-- نظام الطيران الحر (Free-Look Navigation)
-- مرتبط باتجاه الكاميرا عبر CFrame.LookVector
-- ==============================
function Physics.enableFlight()
	if flightActive then return end
	flightActive = true

	local root = getRootPart()
	if not root then flightActive = false return end

	-- إيقاف حركة الشخصية الطبيعية
	local hum = getHumanoid()
	if hum then hum.PlatformStand = true end

	-- إنشاء BodyVelocity للتحكم السلس
	flightVelocity = Instance.new("BodyVelocity")
	flightVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	flightVelocity.Velocity = Vector3.zero
	flightVelocity.Parent = root

	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.P = 1e4
	bodyGyro.Parent = root

	flightConn = RunService.Heartbeat:Connect(function()
		if not flightActive then return end
		local camCF = Camera.CFrame
		local lookVec = camCF.LookVector
		local rightVec = camCF.RightVector

		local direction = Vector3.zero
		local boost = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
			or UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)
		local speed = FLIGHT_SPEED * (boost and FLIGHT_BOOST or 1)

		-- حركة للأمام / للخلف
		if UserInputService:IsKeyDown(Enum.KeyCode.W) or
		   UserInputService:IsKeyDown(Enum.KeyCode.Up) then
			direction = direction + lookVec
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) or
		   UserInputService:IsKeyDown(Enum.KeyCode.Down) then
			direction = direction - lookVec
		end
		-- حركة يميناً / يساراً
		if UserInputService:IsKeyDown(Enum.KeyCode.D) or
		   UserInputService:IsKeyDown(Enum.KeyCode.Right) then
			direction = direction + rightVec
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) or
		   UserInputService:IsKeyDown(Enum.KeyCode.Left) then
			direction = direction - rightVec
		end
		-- صعود / هبوط
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction = direction + Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
		   UserInputService:IsKeyDown(Enum.KeyCode.C) then
			direction = direction - Vector3.new(0, 1, 0)
		end

		if direction.Magnitude > 0 then
			direction = direction.Unit * speed
		end

		flightVelocity.Velocity = direction
		bodyGyro.CFrame = camCF
	end)
end

function Physics.disableFlight()
	if not flightActive then return end
	flightActive = false

	if flightConn then flightConn:Disconnect() flightConn = nil end

	local root = getRootPart()
	if root then
		if flightVelocity then flightVelocity:Destroy() flightVelocity = nil end
		for _, v in root:GetChildren() do
			if v:IsA("BodyGyro") then v:Destroy() end
		end
	end

	local hum = getHumanoid()
	if hum then hum.PlatformStand = false end
end

function Physics.toggleFlight()
	if flightActive then
		Physics.disableFlight()
		return false
	else
		Physics.enableFlight()
		return true
	end
end

function Physics.isFlightActive()
	return flightActive
end

-- ==============================
-- وضع الشبح (Developer Ghost Mode)
-- يعطل CanCollide دورياً عبر Stepped
-- ==============================
function Physics.enableGhost()
	if ghostActive then return end
	ghostActive = true

	ghostLoop = RunService.Stepped:Connect(function()
		local char = LocalPlayer.Character
		if not char then return end
		for _, part in char:GetDescendants() do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end

function Physics.disableGhost()
	if not ghostActive then return end
	ghostActive = false
	if ghostLoop then ghostLoop:Disconnect() ghostLoop = nil end

	local char = LocalPlayer.Character
	if char then
		for _, part in char:GetDescendants() do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

function Physics.toggleGhost()
	if ghostActive then
		Physics.disableGhost()
		return false
	else
		Physics.enableGhost()
		return true
	end
end

function Physics.isGhostActive()
	return ghostActive
end

-- ==============================
-- إعادة الضبط (Reset Stats)
-- ==============================
function Physics.resetAll()
	Physics.disableFlight()
	Physics.disableGhost()
	Physics.setWalkSpeed(16)
	Physics.setJumpPower(50)
end

-- ==============================
-- نظام حفظ المواقع (Checkpoints)
-- يحفظ حتى 3 نقاط مرجعية
-- ==============================
local checkpoints = {nil, nil, nil}

function Physics.saveCheckpoint(slot)
	slot = math.clamp(slot, 1, 3)
	local root = getRootPart()
	if root then
		checkpoints[slot] = root.CFrame
		return true
	end
	return false
end

function Physics.loadCheckpoint(slot)
	slot = math.clamp(slot, 1, 3)
	if checkpoints[slot] then
		local root = getRootPart()
		if root then
			root.CFrame = checkpoints[slot]
			return true
		end
	end
	return false
end

function Physics.getCheckpoints()
	return checkpoints
end

function Physics.clearCheckpoint(slot)
	slot = math.clamp(slot, 1, 3)
	checkpoints[slot] = nil
end
end

-- ==============================
-- Targeting_Module.lua
-- ==============================
do
-- Targeting_Module.lua
-- نظام البحث عن اللاعبين (Partial Name Matching) وتتبع الأدوات

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local followLoop = nil
local followActive = false

-- ==============================
-- البحث عن لاعب بالاسم الجزئي
-- Partial Name Matching
-- ==============================
function Targeting.findPlayer(partialName)
	if not partialName or partialName == "" then return nil end
	partialName = partialName:lower()

	local allPlayers = Players:GetPlayers()
	local bestMatch = nil
	local bestScore = math.huge

	for _, player in allPlayers do
		local name = player.Name:lower()
		local displayName = player.DisplayName:lower()

		-- تطابق أول N حروف
		if name:sub(1, #partialName) == partialName or
		   displayName:sub(1, #partialName) == partialName then
			local score = #name
			if score < bestScore then
				bestScore = score
				bestMatch = player
			end
		end

		-- تطابق جزئي في أي مكان
		if name:find(partialName, 1, true) or displayName:find(partialName, 1, true) then
			if not bestMatch then bestMatch = player end
		end
	end

	return bestMatch
end

-- ==============================
-- الحصول على قائمة اللاعبين
-- ==============================
function Targeting.getPlayerList()
	local list = {}
	for _, p in Players:GetPlayers() do
		table.insert(list, {
			name        = p.Name,
			displayName = p.DisplayName,
			userId      = p.UserId,
		})
	end
	return list
end

-- ==============================
-- الحصول على HumanoidRootPart لاعب
-- ==============================
local function getPlayerRoot(player)
	local char = player.Character
	if char then
		return char:FindFirstChild("HumanoidRootPart")
	end
	return nil
end

-- ==============================
-- البحث عن أداة (Tool) في Workspace أو Backpack
-- ==============================
local function findTool(toolName)
	toolName = toolName:lower()

	-- البحث في Workspace
	for _, v in workspace:GetDescendants() do
		if v:IsA("Tool") and v.Name:lower():find(toolName, 1, true) then
			return v
		end
	end

	-- البحث في Backpack جميع اللاعبين
	for _, player in Players:GetPlayers() do
		local backpack = player:FindFirstChild("Backpack")
		if backpack then
			for _, v in backpack:GetChildren() do
				if v:IsA("Tool") and v.Name:lower():find(toolName, 1, true) then
					return v
				end
			end
		end
	end

	return nil
end

-- ==============================
-- نظام تتبع الأداة (Smart Tool AI)
-- يجعل الأداة تلحق لاعب محدد باستخدام BodyPosition
-- ==============================
function Targeting.startToolFollow(partialPlayerName, toolName, onStatus)
	if followActive then Targeting.stopToolFollow() end

	local targetPlayer = Targeting.findPlayer(partialPlayerName)
	if not targetPlayer then
		if onStatus then onStatus("لاعب غير موجود: " .. partialPlayerName, "danger") end
		return false
	end

	local tool = findTool(toolName or "")
	if not tool then
		if onStatus then onStatus("أداة غير موجودة: " .. (toolName or ""), "danger") end
		return false
	end

	-- نحتاج BasePart جذر الأداة
	local toolHandle = tool:FindFirstChild("Handle")
	if not toolHandle then
		if onStatus then onStatus("الأداة لا تحتوي على Handle", "warning") end
		return false
	end

	-- إضافة BodyPosition
	local bp = toolHandle:FindFirstChild("_FollowBP")
	if bp then bp:Destroy() end
	bp = Instance.new("BodyPosition")
	bp.Name = "_FollowBP"
	bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
	bp.P = 5000
	bp.D = 500
	bp.Parent = toolHandle

	followActive = true

	if onStatus then
		onStatus("تتبع: " .. targetPlayer.Name .. " ← " .. tool.Name, "success")
	end

	followLoop = RunService.Heartbeat:Connect(function()
		if not followActive then return end
		local root = getPlayerRoot(targetPlayer)
		if root then
			-- تتبع سلس عبر Lerp
			local targetPos = root.Position + Vector3.new(0, 3, 0)
			bp.Position = bp.Position:Lerp(targetPos, 0.15)
		end
	end)

	return true
end

function Targeting.stopToolFollow()
	followActive = false
	if followLoop then
		followLoop:Disconnect()
		followLoop = nil
	end

	-- حذف BodyPosition من أي أداة
	for _, v in workspace:GetDescendants() do
		if v.Name == "_FollowBP" and v:IsA("BodyPosition") then
			v:Destroy()
		end
	end
end

function Targeting.isFollowActive()
	return followActive
end

-- ==============================
-- قفز فوري إلى لاعب (Teleport To Player)
-- ==============================
function Targeting.teleportToPlayer(partialName, selfPlayer)
	local target = Targeting.findPlayer(partialName)
	if not target then return false, "لاعب غير موجود" end

	local targetRoot = getPlayerRoot(target)
	local selfChar = selfPlayer.Character
	local selfRoot = selfChar and selfChar:FindFirstChild("HumanoidRootPart")

	if targetRoot and selfRoot then
		selfRoot.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
		return true, "تم الانتقال إلى " .. target.Name
	end

	return false, "تعذّر الانتقال"
end

-- ==============================
-- جلب إحداثيات لاعب (Get Position Info)
-- ==============================
function Targeting.getPlayerPosition(partialName)
	local player = Targeting.findPlayer(partialName)
	if not player then return nil end

	local root = getPlayerRoot(player)
	if root then
		local pos = root.Position
		return {
			player = player.Name,
			x = math.round(pos.X),
			y = math.round(pos.Y),
			z = math.round(pos.Z),
		}
	end
	return nil
end
end

-- ==============================
-- Loader.lua
-- ==============================
-- Loader.lua
-- المحرك الأساسي: يربط جميع الوحدات ويبني الواجهة الكاملة
-- ضعه في StarterPlayerScripts كـ LocalScript

-- ==============================
-- التحقق من بيئة العميل فقط
-- ==============================
if not game:GetService("RunService"):IsClient() then
	error("Loader.lua يجب تشغيله كـ LocalScript فقط")
end

-- ==============================
-- تحميل الوحدات
-- ==============================
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local LocalPlayer     = Players.LocalPlayer

-- ==============================
-- انتظار تحميل الشخصية
-- ==============================
if not LocalPlayer.Character then
	LocalPlayer.CharacterAdded:Wait()
end

task.wait(1.5) -- انتظار اكتمال التحميل

-- ==============================
-- إنشاء الواجهة الرئيسية
-- ==============================
local existingGui = CoreGui:FindFirstChild("AdvancedAdminDashboard")
if existingGui then
	existingGui:Destroy()
end

local screenGui = UI.createScreenGui("AdvancedAdminDashboard")
local mainPanel = UI.createMainPanel(screenGui)
mainPanel.Visible = false

local sidebar     = UI.createSidebar(mainPanel)
local contentArea = UI.createContentArea(mainPanel)

-- ==============================
-- حالة التبويب النشط
-- ==============================
local activeTab = nil
local tabButtons = {}
local pages = {}

local function setActiveTab(tabName, btn, iconLbl, textLbl)
	-- إعادة ضبط جميع الأزرار
	for name, data in tabButtons do
		TweenService:Create(data.btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(data.icon, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextSecondary}):Play()
		TweenService:Create(data.lbl,  TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextSecondary}):Play()
		if pages[name] then pages[name].Visible = false end
	end

	-- تفعيل التبويب المختار
	activeTab = tabName
	TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
	TweenService:Create(iconLbl, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.AccentGlow}):Play()
	TweenService:Create(textLbl, TweenInfo.new(0.15), {TextColor3 = Theme.Colors.TextPrimary}):Play()
	if pages[tabName] then pages[tabName].Visible = true end
end

local function registerTab(name, icon, label)
	local btn, textLbl, iconLbl = UI.createTabButton(sidebar, label, icon)
	tabButtons[name] = {btn = btn, icon = iconLbl, lbl = textLbl}

	local page = Instance.new("Frame")
	page.Name = "Page_" .. name
	page.Size = UDim2.new(1, 0, 0, 0)
	page.AutomaticSize = Enum.AutomaticSize.Y
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = contentArea

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.Parent = page

	pages[name] = page

	btn.MouseButton1Click:Connect(function()
		setActiveTab(name, btn, iconLbl, textLbl)
	end)

	return page
end

-- ==============================
-- تعريف التبويبات
-- ==============================
local movePage    = registerTab("move",    "🏃", "حركة")
local ghostPage   = registerTab("ghost",   "👻", "شبح")
local checkPage   = registerTab("check",   "📍", "مواقع")
local targetPage  = registerTab("target",  "🎯", "تتبع")

-- ==============================
-- صفحة الحركة (Movement & Physics)
-- ==============================
do
	local card = UI.createCard(movePage, nil)

	UI.createSectionHeader(card, "السرعة والقفز")

	local _, getSpeed = UI.createSlider(card, "سرعة المشي (WalkSpeed)", 0, 250, 16, function(v)
		Physics.setWalkSpeed(v)
	end)

	local _, getJump = UI.createSlider(card, "قوة القفز (JumpPower)", 0, 250, 50, function(v)
		Physics.setJumpPower(v)
	end)

	local resetBtn = UI.createButton(card, "إعادة ضبط القيم", "danger")
	resetBtn.MouseButton1Click:Connect(function()
		Physics.setWalkSpeed(16)
		Physics.setJumpPower(50)
		UI.showToast(screenGui, "تم إعادة الضبط", "info")
	end)

	-- نظام الطيران
	local flightCard = UI.createCard(movePage, nil)
	UI.createSectionHeader(flightCard, "معاينة حرة (الطيران)")

	local flightToggle, getFlightState = UI.createToggle(flightCard, "تفعيل وضع المعاينة الحرة", false)
	flightToggle.MouseButton1Click:Connect(function()
		local active = Physics.toggleFlight()
		UI.showToast(screenGui, active and "✈ وضع الطيران: مفعّل" or "وضع الطيران: إيقاف", active and "success" or "info")
	end)

	local note = Instance.new("TextLabel")
	note.Size = UDim2.new(1, 0, 0, 30)
	note.BackgroundTransparency = 1
	note.Text = "WASD للحركة | Space للصعود | Ctrl للهبوط | Shift للتسريع"
	note.TextColor3 = Theme.Colors.TextMuted
	note.TextSize = Theme.Size.SmallText
	note.Font = Theme.Font.Body
	note.TextWrapped = true
	note.TextXAlignment = Enum.TextXAlignment.Left
	note.Parent = flightCard
end

-- ==============================
-- صفحة الشبح (Ghost Mode)
-- ==============================
do
	local card = UI.createCard(ghostPage, nil)
	UI.createSectionHeader(card, "وضعية الشبح للمطورين")

	local ghostToggle, _ = UI.createToggle(card, "اختراق الجدران (Ghost Mode)", false)
	ghostToggle.MouseButton1Click:Connect(function()
		local active = Physics.toggleGhost()
		UI.showToast(screenGui, active and "👻 وضع الشبح: مفعّل" or "وضع الشبح: إيقاف", active and "warning" or "info")
	end)

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1, 0, 0, 50)
	desc.BackgroundTransparency = 1
	desc.Text = "يتيح لك المرور عبر الجدران والأسطح لاختبار المناطق المغلقة. يُعطّل CanCollide دورياً على أجزاء الشخصية."
	desc.TextColor3 = Theme.Colors.TextMuted
	desc.TextSize = Theme.Size.SmallText
	desc.Font = Theme.Font.Body
	desc.TextWrapped = true
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = card

	local resetAll = UI.createButton(card, "إعادة ضبط الكل", "danger")
	resetAll.MouseButton1Click:Connect(function()
		Physics.resetAll()
		UI.showToast(screenGui, "تم إعادة ضبط جميع الأنظمة", "info")
	end)
end

-- ==============================
-- صفحة المواقع (Checkpoints)
-- ==============================
do
	local card = UI.createCard(checkPage, nil)
	UI.createSectionHeader(card, "نقاط الإحداثيات (3 مواقع)")

	for i = 1, 3 do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 38)
		row.BackgroundTransparency = 1
		row.Parent = card

		local labelLayout = Instance.new("UIListLayout")
		labelLayout.FillDirection = Enum.FillDirection.Horizontal
		labelLayout.Padding = UDim.new(0, 8)
		labelLayout.Parent = row

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(0, 60, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = "موقع " .. i
		lbl.TextColor3 = Theme.Colors.TextPrimary
		lbl.TextSize = Theme.Size.BodyText
		lbl.Font = Theme.Font.Body
		lbl.Parent = row

		local saveBtn = UI.createButton(row, "حفظ", "primary")
		saveBtn.Size = UDim2.new(0, 80, 1, -4)
		saveBtn.MouseButton1Click:Connect(function()
			local ok = Physics.saveCheckpoint(i)
			UI.showToast(screenGui, ok and ("✅ حُفظ الموقع " .. i) or "خطأ في الحفظ", ok and "success" or "danger")
		end)

		local loadBtn = UI.createButton(row, "انتقل", "success")
		loadBtn.Size = UDim2.new(0, 80, 1, -4)
		loadBtn.MouseButton1Click:Connect(function()
			local ok = Physics.loadCheckpoint(i)
			UI.showToast(screenGui, ok and ("🚀 انتقلت للموقع " .. i) or "لا يوجد موقع محفوظ", ok and "success" or "warning")
		end)

		local clearBtn = UI.createButton(row, "مسح", "danger")
		clearBtn.Size = UDim2.new(0, 70, 1, -4)
		clearBtn.MouseButton1Click:Connect(function()
			Physics.clearCheckpoint(i)
			UI.showToast(screenGui, "تم مسح الموقع " .. i, "info")
		end)
	end
end

-- ==============================
-- صفحة التتبع (Targeting)
-- ==============================
do
	local card = UI.createCard(targetPage, nil)
	UI.createSectionHeader(card, "نظام تتبع الأدوات")

	local playerInput = UI.createInput(card, "اسم اللاعب (أول 3 حروف كافية)")
	local toolInput   = UI.createInput(card, "اسم الأداة (جزئي)")

	local startBtn = UI.createButton(card, "بدء التتبع", "primary")
	startBtn.MouseButton1Click:Connect(function()
		local pName = playerInput.Text
		local tName = toolInput.Text
		if pName == "" then
			UI.showToast(screenGui, "أدخل اسم اللاعب", "warning")
			return
		end
		Targeting.startToolFollow(pName, tName, function(msg, style)
			UI.showToast(screenGui, msg, style)
		end)
	end)

	local stopBtn = UI.createButton(card, "إيقاف التتبع", "danger")
	stopBtn.MouseButton1Click:Connect(function()
		Targeting.stopToolFollow()
		UI.showToast(screenGui, "توقّف التتبع", "info")
	end)

	-- نقل سريع إلى لاعب
	local teleCard = UI.createCard(targetPage, nil)
	UI.createSectionHeader(teleCard, "انتقال سريع للاعب")

	local teleInput = UI.createInput(teleCard, "اسم اللاعب للانتقال إليه")
	local teleBtn = UI.createButton(teleCard, "انتقل الآن", "success")
	teleBtn.MouseButton1Click:Connect(function()
		local name = teleInput.Text
		if name == "" then
			UI.showToast(screenGui, "أدخل اسم اللاعب", "warning")
			return
		end
		local ok, msg = Targeting.teleportToPlayer(name, LocalPlayer)
		UI.showToast(screenGui, msg, ok and "success" or "danger")
	end)

	-- عرض قائمة اللاعبين
	local listCard = UI.createCard(targetPage, nil)
	UI.createSectionHeader(listCard, "اللاعبون في السيرفر")

	local refreshBtn = UI.createButton(listCard, "تحديث القائمة", "primary")
	local playerListFrame = Instance.new("Frame")
	playerListFrame.Size = UDim2.new(1, 0, 0, 0)
	playerListFrame.AutomaticSize = Enum.AutomaticSize.Y
	playerListFrame.BackgroundTransparency = 1
	playerListFrame.Parent = listCard

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = playerListFrame

	local function refreshPlayerList()
		for _, v in playerListFrame:GetChildren() do
			if not v:IsA("UIListLayout") then v:Destroy() end
		end
		local list = Targeting.getPlayerList()
		for _, info in list do
			local row = Instance.new("TextLabel")
			row.Size = UDim2.new(1, 0, 0, 24)
			row.BackgroundColor3 = Theme.Colors.SurfaceAlt
			row.BackgroundTransparency = 0.5
			row.Text = ("  %s  (%s)"):format(info.name, info.displayName)
			row.TextColor3 = Theme.Colors.TextPrimary
			row.TextSize = Theme.Size.SmallText
			row.Font = Theme.Font.Mono
			row.TextXAlignment = Enum.TextXAlignment.Left
			row.BorderSizePixel = 0
			row.Parent = playerListFrame
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 6)
			c.Parent = row
		end
	end

	refreshBtn.MouseButton1Click:Connect(refreshPlayerList)
	refreshPlayerList() -- تحديث أولي
end

-- ==============================
-- تفعيل التبويب الأول
-- ==============================
do
	local first = tabButtons["move"]
	setActiveTab("move", first.btn, first.icon, first.lbl)
end

-- ==============================
-- زر الإغلاق (X)
-- ==============================
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Theme.Colors.Danger
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Theme.Font.Label
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 10
closeBtn.Parent = mainPanel
local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 8)
cc.Parent = closeBtn

-- ==============================
-- الأيقونة العائمة (Floating HUD Icon)
-- مع toggle لإظهار / إخفاء اللوحة
-- ==============================
local panelVisible = false

local function togglePanel()
	panelVisible = not panelVisible
	if panelVisible then
		mainPanel.Visible = true
		mainPanel.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 360, 0, 520)
		}):Play()
	else
		TweenService:Create(mainPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 0, 0, 0)
		}):Play()
		task.delay(0.22, function()
			mainPanel.Visible = false
		end)
	end
end

local floatIcon = UI.createFloatingIcon(screenGui, togglePanel)
closeBtn.MouseButton1Click:Connect(togglePanel)

-- عنوان اللوحة
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 0, 30)
titleLabel.Position = UDim2.new(0, 96, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Advanced Admin Panel"
titleLabel.TextColor3 = Theme.Colors.TextPrimary
titleLabel.TextSize = Theme.Size.TitleText
titleLabel.Font = Theme.Font.Title
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 5
titleLabel.Parent = mainPanel

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 60, 0, 30)
versionLabel.Position = UDim2.new(0, 96, 0, 22)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.0 • Luau"
versionLabel.TextColor3 = Theme.Colors.TextMuted
versionLabel.TextSize = Theme.Size.SmallText
versionLabel.Font = Theme.Font.Mono
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.ZIndex = 5
versionLabel.Parent = mainPanel

-- ==============================
-- حذف اللوحة عند إعادة بعث الشخصية
-- ==============================
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(2)
	Physics.resetAll()
end)

print("[AdminPanel] تم تحميل النظام بنجاح ✔")
