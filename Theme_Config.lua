-- Theme_Config.lua
local Theme = {}

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

return Theme
