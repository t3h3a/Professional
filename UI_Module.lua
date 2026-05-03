-- UI_Module.lua
local Dependencies = ...
Dependencies = Dependencies or {}

local Theme = assert(Dependencies.Theme, "UI_Module.lua requires Dependencies.Theme")
local CoreGui = Dependencies.CoreGui or game:GetService("CoreGui")
local UI = {}

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

return UI
