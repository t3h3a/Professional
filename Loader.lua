-- Universal Cloud Loader (Modified for Remote Execution)
local BaseURL = "https://raw.githubusercontent.com/t3h3a/Professional/refs/heads/main/"

local RunService = game:GetService("RunService")
if not RunService:IsClient() then
	error("Loader.lua must run on the client.")
end

local CoreGui = game:GetService("CoreGui")

local function CloudRequire(fileName, dependencies)
	local url = BaseURL .. fileName
	local success, content = pcall(function()
		return game:HttpGet(url)
	end)

	if not success or type(content) ~= "string" or content == "" then
		error(("Failed to fetch %s from %s"):format(fileName, url))
	end

	local chunk, parseError = loadstring(content)
	if not chunk then
		error(("Error parsing %s: %s"):format(fileName, tostring(parseError)))
	end

	local runSuccess, result = pcall(chunk, dependencies)
	if not runSuccess then
		error(("Error executing %s: %s"):format(fileName, tostring(result)))
	end

	if result == nil then
		error(("Module %s returned nil"):format(fileName))
	end

	return result
end

local Theme = CloudRequire("Theme_Config.lua")
local Physics = CloudRequire("Physics_Module.lua")
local Targeting = CloudRequire("Targeting_Module.lua")
local UI = CloudRequire("UI_Module.lua", {
	Theme = Theme,
	CoreGui = CoreGui,
})

print("Professional System modules loaded via cloud.")

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
