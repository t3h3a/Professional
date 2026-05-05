-- ============================================================
--   THAER X100 | v2.0.0 | Professional Admin Panel
--   Single LocalScript — All features included
--   Features: Fly, NoClip, Invisibility, CopyOutfit,
--             ESP, Music, Checkpoints, Player Tools,
--             Time Warp (local + global attempt),
--             Aura Zone Time Boost, Anti-AFK
--   Mobile-optimized | AR/EN dual language
-- ============================================================

-- ============================================================
-- SERVICES
-- ============================================================
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local HttpService     = game:GetService("HttpService")
local SoundService    = game:GetService("SoundService")
local Lighting        = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser     = game:GetService("VirtualUser")
local Workspace       = game:GetService("Workspace")

local LocalPlayer     = Players.LocalPlayer
local Camera          = Workspace.CurrentCamera
local IsMobile        = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- ============================================================
-- REMOTE EVENT (للوقت العالمي — يحتاج سيرفر سكريبت)
-- ============================================================
-- ملاحظة: أضف Script في ServerScriptService باسم ThaerServer
-- وضع فيه الكود في نهاية هذا الملف تحت تعليق SERVER SCRIPT
local TimeRemote = nil
pcall(function()
	TimeRemote = ReplicatedStorage:FindFirstChild("ThaerTimeWarp")
end)
if not TimeRemote then
	pcall(function()
		local re = Instance.new("RemoteEvent")
		re.Name   = "ThaerTimeWarp"
		re.Parent = ReplicatedStorage
		TimeRemote = re
	end)
end

-- ============================================================
-- LANGUAGE SYSTEM
-- ============================================================
local CurrentLanguage = "AR"

local Lang = {
	EN = {
		Home="Home", Movement="Movement", Checkpoints="Checkpoints",
		Players="Players", ESP="ESP / Music", Extras="Extras",
		TimeControl="Time Control", Settings="Settings",
		WelcomeTitle="THAER X100 Admin Panel",
		WelcomeMsg="Welcome! Use the sidebar to navigate.\nAll features are active and ready.",
		MovementTitle="Movement Tools", MovementSub="Fly · NoClip · Speed · Jump",
		SectionFlight="Flight", SectionCharacter="Character",
		FlyMode="✈  Fly Mode", NoClip="🧱  NoClip",
		FlySpeed="Fly Speed", WalkSpeed="Walk Speed", JumpPower="Jump Power",
		ResetCharacter="💀  Reset Character",
		CheckpointsTitle="Checkpoints", CheckpointsSub="Save & teleport to positions",
		Slot="Slot", Save="💾  Save", Teleport="📍  Teleport",
		PlayersTitle="Player Tools", PlayersSub="Manage and interact with players",
		TargetPlayer="Target Player", PlayerNameHint="Player name...",
		TeleportTo="🔍  Teleport To", FollowPlayer="👣  Follow",
		SpectatePlayer="🎥  Spectate", StopFollowSpec="⏹  Stop All",
		CopyOutfit="👕  Copy Outfit", PlayerList="Player List",
		ESPTitle="ESP & Music", ESPSub="Overlay · Music Player",
		PlayerOverlay="Player ESP Overlay", ShowNamesDist="👁  Show Names & Distance",
		ESPInfo="Shows player names and distance as floating labels.",
		MusicPlayer="Music Player", SoundIDHint="Sound ID (numbers only)...",
		Volume="Volume", PlayMusic="▶  Play", StopMusic="⏹  Stop",
		ExtrasTitle="Extras", ExtrasSub="Invisibility · Outfit Tools",
		SectionInvis="Invisibility", Invisibility="👻  Invisible Mode",
		InvisInfo="Hides your character and removes your name tag completely.",
		SectionOutfit="Outfit Tools", CopyOutfitInfo="Select a player then press Copy Outfit.",
		TimeTitle="Time Control", TimeSub="Warp time for yourself or everyone",
		SectionLocalTime="Local Time Warp",
		LocalTimeWarp="🌀  Local Time Warp (visual only)",
		LocalTimeSpeed="Local Speed",
		SectionGlobalTime="Global Time (all players)",
		GlobalTimeWarp="🌍  Global Time Warp",
		GlobalTimeSpeed="Global Speed",
		AuraZoneTitle="⚡  Aura Zone Boost",
		AuraZoneName="Aura Zone Part Name",
		AuraZoneHint="AuraZone",
		AuraZoneInfo="When YOU enter the zone, time speeds up 10x for ALL players.",
		AuraStatus="Aura: Inactive",
		SettingsTitle="Settings", SettingsSub="Panel configuration",
		General="General", AntiAFK="💤  Anti-AFK",
		Data="Data", SaveSettings="💾  Save Settings",
		ResetDefaults="🔄  Reset Defaults",
		UI="Interface", HidePanel="🙈  Hide Panel",
		Language="Language", LangToggle="🌐  عربي / Arabic",
		Version="THAER X100 | v2.0.0",
		StatFly="Fly", StatNoClip="NoClip", StatESP="ESP", StatAntiAFK="AntiAFK",
		StatInvis="Invis", StatTime="Time",
		BringAll="📥  Bring All Players",
	},
	AR = {
		Home="الرئيسية", Movement="الحركة", Checkpoints="نقاط الحفظ",
		Players="اللاعبين", ESP="رادار / موسيقى", Extras="إضافات",
		TimeControl="التحكم بالوقت", Settings="الإعدادات",
		WelcomeTitle="لوحة إدارة THAER X100",
		WelcomeMsg="مرحباً! استخدم الشريط الجانبي للتنقل.\nكل الميزات جاهزة ونشطة.",
		MovementTitle="أدوات الحركة", MovementSub="طيران · اختراق · سرعة · قفز",
		SectionFlight="الطيران", SectionCharacter="الشخصية",
		FlyMode="✈  وضع الطيران", NoClip="🧱  اختراق الجدران",
		FlySpeed="سرعة الطيران", WalkSpeed="سرعة المشي", JumpPower="قوة القفز",
		ResetCharacter="💀  إعادة تعيين الشخصية",
		CheckpointsTitle="نقاط الحفظ", CheckpointsSub="احفظ وانتقل إلى المواقع",
		Slot="خانة", Save="💾  حفظ", Teleport="📍  انتقال",
		PlayersTitle="أدوات اللاعبين", PlayersSub="إدارة والتفاعل مع اللاعبين",
		TargetPlayer="اللاعب المستهدف", PlayerNameHint="اسم اللاعب...",
		TeleportTo="🔍  انتقل إليه", FollowPlayer="👣  تتبع",
		SpectatePlayer="🎥  مشاهدة", StopFollowSpec="⏹  أوقف الكل",
		CopyOutfit="👕  نسخ المظهر", PlayerList="قائمة اللاعبين",
		ESPTitle="رادار وموسيقى", ESPSub="تراكب · مشغل الموسيقى",
		PlayerOverlay="تراكب اللاعبين", ShowNamesDist="👁  عرض الأسماء والمسافة",
		ESPInfo="يعرض أسماء اللاعبين ومسافتهم عنك كعلامات عائمة.",
		MusicPlayer="مشغل الموسيقى", SoundIDHint="معرف الصوت (أرقام فقط)...",
		Volume="الصوت", PlayMusic="▶  تشغيل", StopMusic="⏹  إيقاف",
		ExtrasTitle="إضافات", ExtrasSub="الاختفاء · أدوات المظهر",
		SectionInvis="الاختفاء", Invisibility="👻  وضع الاختفاء",
		InvisInfo="يخفي شخصيتك ويزيل اسمك من فوق رأسك تماماً.",
		SectionOutfit="أدوات المظهر", CopyOutfitInfo="اختر لاعباً من القائمة ثم اضغط نسخ المظهر.",
		TimeTitle="التحكم بالوقت", TimeSub="غير الوقت لك أو لجميع اللاعبين",
		SectionLocalTime="تسريع الوقت المحلي",
		LocalTimeWarp="🌀  وقت محلي (مرئي فقط)",
		LocalTimeSpeed="السرعة المحلية",
		SectionGlobalTime="الوقت العالمي (كل اللاعبين)",
		GlobalTimeWarp="🌍  الوقت العالمي",
		GlobalTimeSpeed="السرعة العالمية",
		AuraZoneTitle="⚡  منطقة الأورا",
		AuraZoneName="اسم جزء منطقة الأورا",
		AuraZoneHint="AuraZone",
		AuraZoneInfo="عندما تدخل المنطقة، يتسارع الوقت 10x لجميع اللاعبين.",
		AuraStatus="الأورا: غير نشطة",
		SettingsTitle="الإعدادات", SettingsSub="إعدادات لوحة الإدارة",
		General="عام", AntiAFK="💤  مكافحة الخمول",
		Data="البيانات", SaveSettings="💾  حفظ الإعدادات",
		ResetDefaults="🔄  إعادة للافتراضي",
		UI="الواجهة", HidePanel="🙈  إخفاء اللوحة",
		Language="اللغة", LangToggle="🌐  English / إنجليزي",
		Version="THAER X100 | v2.0.0",
		StatFly="طيران", StatNoClip="اختراق", StatESP="رادار", StatAntiAFK="خمول",
		StatInvis="اختفاء", StatTime="وقت",
		BringAll="📥  جلب جميع اللاعبين",
	},
}

local function T(k) return (Lang[CurrentLanguage] and Lang[CurrentLanguage][k]) or k end
local function IsArabic() return CurrentLanguage == "AR" end
local function GetAlign() return IsArabic() and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left end

-- ============================================================
-- CONFIG & STATE
-- ============================================================
local Config = {
	FlySpeed=50, WalkSpeed=16, JumpPower=50,
	FlyEnabled=false, NoClipEnabled=false, ESPEnabled=false,
	AntiAFKEnabled=true, MusicVolume=0.5,
	InvisEnabled=false, LocalTimeEnabled=false, GlobalTimeEnabled=false,
	LocalTimeSpeed=5, GlobalTimeSpeed=3,
	CurrentPage="Home",
}

local Checkpoints  = {nil,nil,nil}
local FollowTarget = nil
local SpectateTarget=nil
local SpectateConn = nil
local FollowConn   = nil
local FlyConn      = nil
local NoClipConn   = nil
local LocalTimeConn= nil
local ESPObjects   = {}
local ActiveMusic  = nil
local AuraActive   = false
local AuraZoneConn = nil
local SelectedPlayerName = ""

-- ============================================================
-- SAVE / LOAD
-- ============================================================
local function SaveSettings()
	local ok, data = pcall(HttpService.JSONEncode, HttpService, {
		FlySpeed=Config.FlySpeed, WalkSpeed=Config.WalkSpeed,
		JumpPower=Config.JumpPower, MusicVolume=Config.MusicVolume,
	})
	if ok and writefile then pcall(writefile,"thaer_v2_settings.json",data) end
end
local function LoadSettings()
	if readfile then
		local ok, raw = pcall(readfile,"thaer_v2_settings.json")
		if ok and raw then
			local ok2, t = pcall(HttpService.JSONDecode, HttpService, raw)
			if ok2 and t then for k,v in pairs(t) do Config[k]=v end end
		end
	end
end
LoadSettings()

-- ============================================================
-- HELPERS
-- ============================================================
local function GetChar()   return LocalPlayer.Character end
local function GetHum()    local c=GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function GetHRP()    local c=GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end

local function SafeGetParts()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp  = char:WaitForChild("HumanoidRootPart",5)
	local hum  = char:WaitForChild("Humanoid",5)
	return char, hrp, hum
end

local function Tw(obj, props, t, style, dir)
	style = style or Enum.EasingStyle.Quart
	dir   = dir   or Enum.EasingDirection.Out
	TweenService:Create(obj, TweenInfo.new(t or 0.3, style, dir), props):Play()
end

-- ============================================================
-- ANTI-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
	if Config.AntiAFKEnabled then
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end
end)

-- ============================================================
-- FLY SYSTEM
-- ============================================================
local function StopFly()
	Config.FlyEnabled = false
	if FlyConn then FlyConn:Disconnect(); FlyConn=nil end
	local c = GetChar()
	if c then
		for _,v in pairs(c:GetDescendants()) do
			if v.Name=="FlyVelocity" or v.Name=="FlyGyro" then
				pcall(function() v:Destroy() end)
			end
		end
	end
	local h = GetHum()
	if h then
		pcall(function() h.PlatformStand = false end)
		h:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
	local hrp = GetHRP()
	if hrp then pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0,-1,0) end) end
end

local function StartFly()
	StopFly()
	local char, hrp, hum
	local ok = pcall(function() char,hrp,hum = SafeGetParts() end)
	if not ok or not hrp or not hum then return end
	Config.FlyEnabled = true

	for _,v in pairs(char:GetDescendants()) do
		if v.Name=="FlyVelocity" or v.Name=="FlyGyro" then pcall(function()v:Destroy()end) end
	end

	local bv = Instance.new("BodyVelocity")
	bv.Name="FlyVelocity"; bv.Velocity=Vector3.zero
	bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge); bv.Parent=hrp

	local bg = Instance.new("BodyGyro")
	bg.Name="FlyGyro"; bg.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
	bg.P=9000; bg.D=500; bg.CFrame=hrp.CFrame; bg.Parent=hrp

	-- لأجهزة الهاتف: متغيرات الاتجاه عبر الشاشة
	local touchMoveDir = Vector3.zero

	FlyConn = RunService.Heartbeat:Connect(function()
		local cHRP = GetHRP(); local cHum = GetHum()
		if not Config.FlyEnabled or not cHRP or not cHum then StopFly(); return end
		if not bv.Parent or not bg.Parent then StopFly(); return end
		if cHRP.Anchored then cHRP.Anchored=false end
		if cHum:GetState()~=Enum.HumanoidStateType.Swimming then
			cHum:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		cHum.PlatformStand = false

		local speed = Config.FlySpeed
		local cf    = Camera.CFrame
		local dir   = Vector3.zero

		-- keyboard / mobile joystick direction from camera
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end

		-- على الهاتف: استخدم اتجاه الحركة من thumbstick
		if IsMobile and cHum.MoveDirection.Magnitude > 0.1 then
			local md = cHum.MoveDirection
			dir = dir + Vector3.new(md.X, 0, md.Z)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed=speed*2 end

		if dir.Magnitude > 0 then bv.Velocity=dir.Unit*speed else bv.Velocity=Vector3.zero end

		local flat = Vector3.new(cf.LookVector.X,0,cf.LookVector.Z)
		if flat.Magnitude>0.01 then bg.CFrame=CFrame.new(Vector3.zero,flat) end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	local wasFlying  = Config.FlyEnabled
	local wasNoClip  = Config.NoClipEnabled
	local wasInvis   = Config.InvisEnabled
	Config.FlyEnabled=false; Config.NoClipEnabled=false; Config.InvisEnabled=false
	FlyConn=nil; NoClipConn=nil
	task.wait(0.6)
	if wasFlying  then StartFly()   end
	if wasNoClip  then StartNoClip()end
	if wasInvis   then SetInvisible(true) end
end)

-- ============================================================
-- NOCLIP SYSTEM
-- ============================================================
local function StopNoClip()
	Config.NoClipEnabled=false
	if NoClipConn then NoClipConn:Disconnect(); NoClipConn=nil end
	local c=GetChar()
	if c then for _,p in pairs(c:GetDescendants()) do
		if p:IsA("BasePart") then pcall(function()p.CanCollide=true end) end
	end end
end

function StartNoClip()
	Config.NoClipEnabled=true
	NoClipConn=RunService.Stepped:Connect(function()
		if not Config.NoClipEnabled then StopNoClip(); return end
		local c=GetChar()
		if c then for _,p in pairs(c:GetDescendants()) do
			if p:IsA("BasePart") then pcall(function()p.CanCollide=false end) end
		end end
	end)
end

-- ============================================================
-- INVISIBILITY SYSTEM
-- ============================================================
function SetInvisible(state)
	Config.InvisEnabled=state
	local c=GetChar()
	if not c then return end
	pcall(function()
		local hum = c:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.DisplayDistanceType = state and Enum.HumanoidDisplayDistanceType.None
				or Enum.HumanoidDisplayDistanceType.Viewer
		end
		for _,v in pairs(c:GetDescendants()) do
			if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
				v.LocalTransparencyModifier = state and 1 or 0
			end
			if v:IsA("Decal") then v.Transparency = state and 1 or 0 end
			if v:IsA("SpecialMesh") then end
		end
		-- إخفاء الـ HRP بشكل بصري فقط
		local hrp = c:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.LocalTransparencyModifier = 1 end
	end)
end

-- ============================================================
-- COPY OUTFIT SYSTEM
-- ============================================================
local function CopyOutfit(targetName)
	local target = Players:FindFirstChild(targetName)
	if not target then return end
	local tc = target.Character
	if not tc then return end
	pcall(function()
		local hum     = tc:FindFirstChildOfClass("Humanoid")
		local myHum   = GetHum()
		if not hum or not myHum then return end
		local desc = hum:GetAppliedDescription()
		task.wait(0.1)
		pcall(function() myHum:ApplyDescription(desc) end)
	end)
end

-- ============================================================
-- TIME WARP — LOCAL (يغير وقت الإضاءة محلياً)
-- ============================================================
local function StopLocalTime()
	Config.LocalTimeEnabled=false
	if LocalTimeConn then LocalTimeConn:Disconnect(); LocalTimeConn=nil end
end

local function StartLocalTime()
	StopLocalTime()
	Config.LocalTimeEnabled=true
	LocalTimeConn = RunService.Heartbeat:Connect(function(dt)
		if not Config.LocalTimeEnabled then StopLocalTime(); return end
		pcall(function()
			Lighting.ClockTime = (Lighting.ClockTime + dt * Config.LocalTimeSpeed) % 24
		end)
	end)
end

-- ============================================================
-- TIME WARP — GLOBAL (يرسل للسيرفر)
-- ============================================================
local function SetGlobalTime(enabled, speed)
	pcall(function()
		if TimeRemote then
			TimeRemote:FireServer(enabled, speed or Config.GlobalTimeSpeed)
		end
	end)
end

-- ============================================================
-- AURA ZONE SYSTEM
-- ============================================================
local AuraStatusLabel = nil

local function StopAuraZone()
	AuraActive = false
	if AuraZoneConn then AuraZoneConn:Disconnect(); AuraZoneConn=nil end
	if AuraStatusLabel then
		pcall(function()
			AuraStatusLabel.Text = T("AuraStatus")
			AuraStatusLabel.TextColor3 = Color3.fromRGB(120,110,170)
		end)
	end
	SetGlobalTime(false, 1)
end

local function StartAuraZone(zoneName)
	StopAuraZone()
	zoneName = zoneName ~= "" and zoneName or "AuraZone"
	local hrp = GetHRP()
	if not hrp then return end

	AuraZoneConn = RunService.Heartbeat:Connect(function()
		local curHRP = GetHRP()
		if not curHRP then return end
		local zone = Workspace:FindFirstChild(zoneName, true)
		if not zone or not zone:IsA("BasePart") then
			if AuraStatusLabel then
				pcall(function()
					AuraStatusLabel.Text = "⚡ Zone '"..zoneName.."' not found"
					AuraStatusLabel.TextColor3 = Color3.fromRGB(230,70,90)
				end)
			end
			return
		end

		-- فحص إذا اللاعب داخل المنطقة
		local zonePos  = zone.Position
		local zoneSize = zone.Size / 2
		local playerPos= curHRP.Position
		local inside   = math.abs(playerPos.X - zonePos.X) < zoneSize.X
			and math.abs(playerPos.Y - zonePos.Y) < zoneSize.Y + 5
			and math.abs(playerPos.Z - zonePos.Z) < zoneSize.Z

		if inside and not AuraActive then
			AuraActive = true
			SetGlobalTime(true, 10) -- 10x للجميع
			if AuraStatusLabel then
				pcall(function()
					AuraStatusLabel.Text = "⚡ الأورا نشطة! 10x"
					AuraStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
				end)
			end
		elseif not inside and AuraActive then
			AuraActive = false
			SetGlobalTime(false, 1)
			if AuraStatusLabel then
				pcall(function()
					AuraStatusLabel.Text = T("AuraStatus")
					AuraStatusLabel.TextColor3 = Color3.fromRGB(120,110,170)
				end)
			end
		end
	end)
end

-- ============================================================
-- CHECKPOINTS
-- ============================================================
local function SaveCP(slot)
	local hrp=GetHRP(); if hrp then Checkpoints[slot]=hrp.CFrame end
end
local function LoadCP(slot)
	local cf=Checkpoints[slot]; local hrp=GetHRP()
	if cf and hrp then pcall(function() hrp.CFrame=cf end) end
end

-- ============================================================
-- PLAYER TOOLS
-- ============================================================
local function GetPlayerByName(name)
	name=name:lower()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(name,1,true) then return p end
	end
end

local function TeleportToPlayer(t)
	local hrp=GetHRP(); local tc=t.Character
	local thrp=tc and tc:FindFirstChild("HumanoidRootPart")
	if hrp and thrp then hrp.CFrame=thrp.CFrame+Vector3.new(3,0,0) end
end

local function StopFollow()
	if FollowConn then FollowConn:Disconnect(); FollowConn=nil end; FollowTarget=nil
end
local function StartFollow(t)
	StopFollow(); FollowTarget=t
	FollowConn=RunService.Heartbeat:Connect(function()
		local hrp=GetHRP(); local tc=FollowTarget and FollowTarget.Character
		local thrp=tc and tc:FindFirstChild("HumanoidRootPart")
		if hrp and thrp then hrp.CFrame=thrp.CFrame+thrp.CFrame.LookVector*-3 end
	end)
end

local function StopSpectate()
	if SpectateConn then SpectateConn:Disconnect(); SpectateConn=nil end
	SpectateTarget=nil
	Camera.CameraType=Enum.CameraType.Custom
	Camera.CameraSubject=GetHum()
end
local function StartSpectate(t)
	StopSpectate(); SpectateTarget=t
	Camera.CameraType=Enum.CameraType.Custom
	SpectateConn=RunService.RenderStepped:Connect(function()
		local tc=SpectateTarget and SpectateTarget.Character
		local th=tc and tc:FindFirstChildOfClass("Humanoid")
		if th then Camera.CameraSubject=th end
	end)
end

local function BringAllPlayers()
	local hrp=GetHRP(); if not hrp then return end
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			pcall(function()
				local tc=p.Character
				local thrp=tc and tc:FindFirstChild("HumanoidRootPart")
				if thrp then thrp.CFrame=hrp.CFrame+Vector3.new(math.random(-4,4),0,math.random(-4,4)) end
			end)
		end
	end
end

-- ============================================================
-- ESP SYSTEM
-- ============================================================
local function ClearESP()
	for _,v in pairs(ESPObjects) do pcall(function()
		if type(v)=="table" then v:Disconnect() else v:Destroy() end
	end) end
	ESPObjects={}
end

local function BuildESP()
	ClearESP()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			local bb=Instance.new("BillboardGui")
			bb.Name="ThaerESP"; bb.AlwaysOnTop=true
			bb.Size=UDim2.new(0,120,0,40); bb.StudsOffset=Vector3.new(0,3.2,0)

			local bg2=Instance.new("Frame")
			bg2.Size=UDim2.fromScale(1,1); bg2.BackgroundColor3=Color3.fromRGB(8,6,24)
			bg2.BackgroundTransparency=0.25; bg2.Parent=bb
			local c2=Instance.new("UICorner"); c2.CornerRadius=UDim.new(0,8); c2.Parent=bg2
			local stroke2=Instance.new("UIStroke")
			stroke2.Color=Color3.fromRGB(110,60,240); stroke2.Thickness=1.5; stroke2.Parent=bg2

			local lbl=Instance.new("TextLabel")
			lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
			lbl.Font=Enum.Font.GothamBold; lbl.TextColor3=Color3.fromRGB(180,140,255)
			lbl.TextSize=13; lbl.Parent=bg2

			local function Upd()
				local c3=p.Character; local hr=c3 and c3:FindFirstChild("HumanoidRootPart")
				local lh=GetHRP()
				if hr and lh then
					lbl.Text=p.Name.."\n"..math.floor((hr.Position-lh.Position).Magnitude).."m"
					bb.Adornee=hr; bb.Parent=Workspace
				else bb.Parent=nil end
			end
			local conn=RunService.Heartbeat:Connect(Upd)
			table.insert(ESPObjects,bb)
			table.insert(ESPObjects,{Disconnect=function()conn:Disconnect()end})
		end
	end
end

local function UpdateESP()
	if Config.ESPEnabled then BuildESP() else ClearESP() end
end

-- ============================================================
-- MUSIC
-- ============================================================
local function PlayMusic(id,vol)
	if ActiveMusic then ActiveMusic:Destroy(); ActiveMusic=nil end
	local s=Instance.new("Sound")
	s.SoundId="rbxassetid://"..tostring(id)
	s.Volume=vol or Config.MusicVolume; s.Looped=true; s.Parent=SoundService
	s:Play(); ActiveMusic=s
end
local function StopMusic()
	if ActiveMusic then ActiveMusic:Stop(); ActiveMusic:Destroy(); ActiveMusic=nil end
end

-- ============================================================
-- GUI CONSTANTS
-- ============================================================
local old=LocalPlayer.PlayerGui:FindFirstChild("ThaerX100_v2")
if old then old:Destroy() end

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="ThaerX100_v2"; ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset=true; ScreenGui.Parent=LocalPlayer.PlayerGui

-- Color palette
local C={
	BG       = Color3.fromRGB(7,  8, 20),
	Panel    = Color3.fromRGB(12, 13, 30),
	Sidebar  = Color3.fromRGB(9,  10, 24),
	Card     = Color3.fromRGB(16, 18, 42),
	CardHov  = Color3.fromRGB(22, 25, 58),
	Accent   = Color3.fromRGB(120, 60, 255),
	AccentB  = Color3.fromRGB(60, 130, 255),
	AccentC  = Color3.fromRGB(200, 80, 255),
	Neon     = Color3.fromRGB(150, 80, 255),
	Text     = Color3.fromRGB(225, 220, 255),
	SubText  = Color3.fromRGB(120, 110, 170),
	Success  = Color3.fromRGB(50, 220, 140),
	Danger   = Color3.fromRGB(235, 65, 85),
	Warning  = Color3.fromRGB(255, 185, 0),
	TOn      = Color3.fromRGB(120, 60, 255),
	TOff     = Color3.fromRGB(35, 35, 60),
	White    = Color3.fromRGB(255,255,255),
	Black    = Color3.fromRGB(0,0,0),
}

-- ============================================================
-- UI HELPERS
-- ============================================================
local function Corner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c end
local function Stroke(p,col,th) local s=Instance.new("UIStroke"); s.Color=col or C.Accent; s.Thickness=th or 1.2; s.Parent=p; return s end
local function Gradient(p,c0,c1,rot)
	local g=Instance.new("UIGradient")
	g.Color=ColorSequence.new(c0,c1); g.Rotation=rot or 90; g.Parent=p; return g
end
local function ListLayout(p,pad,dir,ha,va)
	local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,pad or 6)
	l.FillDirection=dir or Enum.FillDirection.Vertical
	l.HorizontalAlignment=ha or Enum.HorizontalAlignment.Center
	l.VerticalAlignment=va or Enum.VerticalAlignment.Top
	l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p; return l
end
local function Pad(p,t,b,l,r)
	local pd=Instance.new("UIPadding")
	pd.PaddingTop=UDim.new(0,t or 6); pd.PaddingBottom=UDim.new(0,b or 6)
	pd.PaddingLeft=UDim.new(0,l or 6); pd.PaddingRight=UDim.new(0,r or 6)
	pd.Parent=p; return pd
end

local function MakeLabel(p,text,size,color,bold,xalign,order)
	local l=Instance.new("TextLabel")
	l.BackgroundTransparency=1; l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
	l.Text=text; l.TextSize=size or 12; l.TextColor3=color or C.Text
	l.TextXAlignment=xalign or Enum.TextXAlignment.Left
	l.TextWrapped=true; l.Size=UDim2.new(1,0,0,size and size+4 or 16)
	l.LayoutOrder=order or 0; l.Parent=p; return l
end

local function SectionHeader(p,text,order)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,22); f.BackgroundTransparency=1
	f.LayoutOrder=order or 0; f.Parent=p

	local line=Instance.new("Frame")
	line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,1,-1)
	line.BackgroundColor3=C.Accent; line.BackgroundTransparency=0.7; line.BorderSizePixel=0
	line.Parent=f
	Gradient(line,C.Accent,Color3.fromRGB(7,8,20),0)

	local lbl=Instance.new("TextLabel")
	lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
	lbl.Font=Enum.Font.GothamBold
	lbl.Text="▸  "..text:upper()
	lbl.TextColor3=C.Accent; lbl.TextSize=10
	lbl.TextXAlignment=GetAlign(); lbl.Parent=f
	return f,lbl
end

local function PageHeader(p,titleKey,subKey,order)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,54); f.BackgroundColor3=C.Card
	f.LayoutOrder=order or 0; f.Parent=p
	Corner(f,12)
	Gradient(f, Color3.fromRGB(28,12,75), Color3.fromRGB(8,22,70), 135)
	Stroke(f,C.Accent,1)

	local glow=Instance.new("ImageLabel")
	glow.Size=UDim2.new(0,40,0,40); glow.Position=UDim2.new(1,-50,0.5,-20)
	glow.BackgroundTransparency=1; glow.ImageTransparency=0.7
	glow.Image="rbxassetid://6401143206" -- glow image
	glow.ImageColor3=C.Accent; glow.Parent=f

	local t=Instance.new("TextLabel")
	t.Position=UDim2.new(0,14,0,8); t.Size=UDim2.new(0.9,0,0,22)
	t.BackgroundTransparency=1; t.Font=Enum.Font.GothamBold
	t.Text=T(titleKey); t.TextColor3=C.White; t.TextSize=15
	t.TextXAlignment=GetAlign(); t.Parent=f

	local s=Instance.new("TextLabel")
	s.Position=UDim2.new(0,14,0,31); s.Size=UDim2.new(0.9,0,0,14)
	s.BackgroundTransparency=1; s.Font=Enum.Font.Gotham
	s.Text=T(subKey); s.TextColor3=C.SubText; s.TextSize=10
	s.TextXAlignment=GetAlign(); s.Parent=f
	return f,t,s
end

local BTN_H = IsMobile and 44 or 36

local function MakeBtn(p, text, color, order, cb, fullText)
	color = color or C.Accent
	local btn=Instance.new("TextButton")
	btn.Size=UDim2.new(1,0,0,BTN_H); btn.BackgroundColor3=color
	btn.Font=Enum.Font.GothamBold
	btn.Text = fullText and text or T(text)
	btn.TextColor3=C.White; btn.TextSize=IsMobile and 13 or 12
	btn.AutoButtonColor=false; btn.LayoutOrder=order or 0; btn.Parent=p
	Corner(btn,8)

	-- Glow effect
	local glow=Instance.new("UIStroke")
	glow.Color=color; glow.Thickness=0; glow.Parent=btn

	btn.MouseEnter:Connect(function()
		Tw(btn,{BackgroundColor3=color:Lerp(C.White,0.18)},0.15)
		Tw(glow,{Thickness=2},0.15)
	end)
	btn.MouseLeave:Connect(function()
		Tw(btn,{BackgroundColor3=color},0.15)
		Tw(glow,{Thickness=0},0.15)
	end)
	btn.MouseButton1Click:Connect(function()
		Tw(btn,{Size=UDim2.new(0.96,0,0,BTN_H-3)},0.07)
		task.delay(0.07,function() Tw(btn,{Size=UDim2.new(1,0,0,BTN_H)},0.12) end)
		if cb then cb() end
	end)
	-- Touch support
	btn.TouchTap:Connect(function()
		if cb then cb() end
	end)
	return btn
end

local TOGGLE_H = IsMobile and 46 or 36

local function MakeToggle(p, textKey, state, order, cb)
	local frame=Instance.new("Frame")
	frame.Size=UDim2.new(1,0,0,TOGGLE_H); frame.BackgroundColor3=C.Card
	frame.LayoutOrder=order or 0; frame.Parent=p
	Corner(frame,8); Stroke(frame,C.Accent,1)

	local lbl=Instance.new("TextLabel")
	lbl.Position=UDim2.new(0,12,0,0); lbl.Size=UDim2.new(1,-64,1,0)
	lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.Gotham
	lbl.Text=T(textKey); lbl.TextColor3=C.Text; lbl.TextSize=IsMobile and 13 or 12
	lbl.TextXAlignment=GetAlign(); lbl.Parent=frame

	local track=Instance.new("Frame")
	track.Position=UDim2.new(1,-52,0.5,-11); track.Size=UDim2.new(0,42,0,22)
	track.BackgroundColor3=state and C.TOn or C.TOff; track.Parent=frame; Corner(track,11)
	Stroke(track, state and C.Accent or C.SubText, 1)

	local knob=Instance.new("Frame")
	knob.Position=state and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,2,0.5,-8)
	knob.Size=UDim2.new(0,18,0,18); knob.BackgroundColor3=C.White; knob.Parent=track
	Corner(knob,9)

	local cur=state or false
	local hitbox=Instance.new("TextButton")
	hitbox.Size=UDim2.fromScale(1,1); hitbox.BackgroundTransparency=1; hitbox.Text=""; hitbox.Parent=frame

	local function SetState(v)
		cur=v
		Tw(track,{BackgroundColor3=v and C.TOn or C.TOff},0.2)
		Tw(knob,{Position=v and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,2,0.5,-8)},0.2)
		Stroke(track, v and C.Accent or C.SubText, 1)
	end

	hitbox.MouseButton1Click:Connect(function()
		SetState(not cur); if cb then cb(cur) end
	end)
	return frame, SetState, lbl
end

local SLIDER_H = IsMobile and 62 or 52

local function MakeSlider(p, textKey, minV, maxV, val, order, cb)
	local frame=Instance.new("Frame")
	frame.Size=UDim2.new(1,0,0,SLIDER_H); frame.BackgroundColor3=C.Card
	frame.LayoutOrder=order or 0; frame.Parent=p; Corner(frame,8); Stroke(frame,C.Accent,1)

	local lbl=Instance.new("TextLabel")
	lbl.Position=UDim2.new(0,12,0,6); lbl.Size=UDim2.new(0.6,0,0,18)
	lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.Gotham
	lbl.Text=T(textKey); lbl.TextColor3=C.Text; lbl.TextSize=IsMobile and 13 or 12
	lbl.TextXAlignment=GetAlign(); lbl.Parent=frame

	local valLbl=Instance.new("TextLabel")
	valLbl.Position=UDim2.new(0.62,0,0,6); valLbl.Size=UDim2.new(0.35,0,0,18)
	valLbl.BackgroundTransparency=1; valLbl.Font=Enum.Font.GothamBold
	valLbl.Text=tostring(val); valLbl.TextColor3=C.Accent; valLbl.TextSize=IsMobile and 13 or 12
	valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.Parent=frame

	local track=Instance.new("Frame")
	track.Position=UDim2.new(0,12,0,SLIDER_H-18); track.Size=UDim2.new(1,-24,0,6)
	track.BackgroundColor3=C.Sidebar; track.Parent=frame; Corner(track,3)

	local fill=Instance.new("Frame")
	fill.Size=UDim2.new((val-minV)/(maxV-minV),0,1,0)
	fill.BackgroundColor3=C.Accent; fill.Parent=track; Corner(fill,3)
	Gradient(fill,C.AccentB,C.AccentC,0)

	local knob=Instance.new("Frame")
	knob.AnchorPoint=Vector2.new(0.5,0.5)
	knob.Position=UDim2.new((val-minV)/(maxV-minV),0,0.5,0)
	knob.Size=UDim2.new(0,IsMobile and 20 or 14,0,IsMobile and 20 or 14)
	knob.BackgroundColor3=C.White; knob.Parent=track; Corner(knob,10)
	Stroke(knob,C.Accent,1.5)

	local drag=false
	local function Update(x)
		local abs=track.AbsolutePosition.X; local wid=track.AbsoluteSize.X
		local pct=math.clamp((x-abs)/wid,0,1)
		local v=math.floor(minV+pct*(maxV-minV))
		Tw(fill,{Size=UDim2.new(pct,0,1,0)},0.05)
		Tw(knob,{Position=UDim2.new(pct,0,0.5,0)},0.05)
		valLbl.Text=tostring(v); if cb then cb(v) end
	end
	track.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			drag=true; Update(i.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			Update(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			drag=false
		end
	end)
	return frame, lbl
end

local INPUT_H = IsMobile and 42 or 34

local function MakeInput(p, phKey, order, cb)
	local frame=Instance.new("Frame")
	frame.Size=UDim2.new(1,0,0,INPUT_H); frame.BackgroundColor3=C.Card
	frame.LayoutOrder=order or 0; frame.Parent=p; Corner(frame,8); Stroke(frame,C.Accent,1)

	local tb=Instance.new("TextBox")
	tb.Size=UDim2.new(1,-20,1,0); tb.Position=UDim2.new(0,10,0,0)
	tb.BackgroundTransparency=1; tb.Font=Enum.Font.Gotham
	tb.PlaceholderText=T(phKey); tb.Text=""; tb.TextColor3=C.Text
	tb.PlaceholderColor3=C.SubText; tb.TextSize=IsMobile and 13 or 11
	tb.TextXAlignment=GetAlign(); tb.ClearTextOnFocus=false; tb.Parent=frame
	return frame, tb
end

-- ============================================================
-- MAIN PANEL LAYOUT
-- ============================================================
local PanelW = IsMobile and 310 or 330
local PanelH = IsMobile and 520 or 480
local SideW  = IsMobile and 96 or 82

-- Floating open button (mobile-first)
local FloatBtn=Instance.new("TextButton")
FloatBtn.Size=UDim2.new(0,IsMobile and 52 or 44,0,IsMobile and 52 or 44)
FloatBtn.Position=UDim2.new(0,10,0.5,-26)
FloatBtn.BackgroundColor3=C.Accent; FloatBtn.Text="⚡"
FloatBtn.Font=Enum.Font.GothamBold; FloatBtn.TextSize=IsMobile and 22 or 18
FloatBtn.TextColor3=C.White; FloatBtn.AutoButtonColor=false
FloatBtn.ZIndex=10; FloatBtn.Parent=ScreenGui
Corner(FloatBtn,IsMobile and 26 or 22)
Stroke(FloatBtn,C.AccentB,2)

-- Pulsing glow on float button
local floatGlow=Stroke(FloatBtn,C.AccentC,0)
task.spawn(function()
	while FloatBtn.Parent do
		Tw(floatGlow,{Thickness=3},0.8)
		task.wait(0.85)
		Tw(floatGlow,{Thickness=0},0.8)
		task.wait(0.85)
	end
end)

-- Make float button draggable
local fbDragging,fbDragStart,fbStartPos=false,nil,nil
FloatBtn.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		fbDragging=true; fbDragStart=i.Position
		fbStartPos=FloatBtn.Position
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if fbDragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local delta=i.Position-fbDragStart
		local newX=fbStartPos.X.Offset+delta.X
		local newY=fbStartPos.Y.Offset+delta.Y
		FloatBtn.Position=UDim2.new(0,newX,0,newY)
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		fbDragging=false
	end
end)

-- Main Panel
local MainPanel=Instance.new("Frame")
MainPanel.Name="MainPanel"
MainPanel.Size=UDim2.new(0,PanelW,0,PanelH)
MainPanel.Position=UDim2.new(0.5,-PanelW/2,0.5,-PanelH/2)
MainPanel.BackgroundColor3=C.Panel; MainPanel.ZIndex=5; MainPanel.Parent=ScreenGui
Corner(MainPanel,14)
Stroke(MainPanel,C.Accent,1.5)

-- Panel background gradient
Gradient(MainPanel, Color3.fromRGB(10,11,28), Color3.fromRGB(7,8,20), 145)

-- Drag panel
local panDrag,panStart,panStartPos=false,nil,nil
local TitleBar=Instance.new("TextButton")
TitleBar.Size=UDim2.new(1,-30,0,32); TitleBar.Position=UDim2.new(0,0,0,0)
TitleBar.BackgroundTransparency=1; TitleBar.Text=""; TitleBar.ZIndex=20; TitleBar.Parent=MainPanel

TitleBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		panDrag=true; panStart=i.Position; panStartPos=MainPanel.Position
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if panDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-panStart
		MainPanel.Position=UDim2.new(panStartPos.X.Scale,panStartPos.X.Offset+d.X,
			panStartPos.Y.Scale,panStartPos.Y.Offset+d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then panDrag=false end
end)

-- Top bar
local TopBar=Instance.new("Frame")
TopBar.Size=UDim2.new(1,0,0,36); TopBar.BackgroundColor3=C.Sidebar
TopBar.Parent=MainPanel; Corner(TopBar,14)
Gradient(TopBar, Color3.fromRGB(20,8,60), Color3.fromRGB(8,16,55), 90)
Stroke(TopBar, C.Accent, 0)

-- Bottom rounded fix for top bar
local TopBarFix=Instance.new("Frame")
TopBarFix.Size=UDim2.new(1,0,0,14); TopBarFix.Position=UDim2.new(0,0,1,-14)
TopBarFix.BackgroundColor3=C.Sidebar; TopBarFix.BorderSizePixel=0; TopBarFix.Parent=TopBar

local TitleLbl=Instance.new("TextLabel")
TitleLbl.Size=UDim2.new(1,-70,1,0); TitleLbl.Position=UDim2.new(0,14,0,0)
TitleLbl.BackgroundTransparency=1; TitleLbl.Font=Enum.Font.GothamBold
TitleLbl.Text="⚡ THAER X100"; TitleLbl.TextColor3=C.White; TitleLbl.TextSize=13
TitleLbl.TextXAlignment=Enum.TextXAlignment.Left; TitleLbl.Parent=TopBar
Gradient(TitleLbl, C.AccentB, C.AccentC, 0) -- purely visual note: TextLabel gradients need UIGradient on text which isn't directly supported, so we just color the label

-- Badge
local Badge=Instance.new("TextLabel")
Badge.Size=UDim2.new(0,36,0,16); Badge.Position=UDim2.new(1,-100,0.5,-8)
Badge.BackgroundColor3=C.Accent; Badge.Font=Enum.Font.GothamBold
Badge.Text="v2.0"; Badge.TextColor3=C.White; Badge.TextSize=9; Badge.Parent=TopBar
Corner(Badge,4)

-- Close button
local CloseBtn=Instance.new("TextButton")
CloseBtn.Size=UDim2.new(0,26,0,26); CloseBtn.Position=UDim2.new(1,-32,0.5,-13)
CloseBtn.BackgroundColor3=C.Danger; CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.Text="✕"; CloseBtn.TextColor3=C.White; CloseBtn.TextSize=12
CloseBtn.AutoButtonColor=false; CloseBtn.ZIndex=20; CloseBtn.Parent=TopBar
Corner(CloseBtn,5)
CloseBtn.MouseButton1Click:Connect(function()
	Tw(MainPanel,{Position=UDim2.new(0.5,-PanelW/2,1.5,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	task.delay(0.35,function() MainPanel.Visible=false end)
end)

-- Float button toggles panel
FloatBtn.MouseButton1Click:Connect(function()
	if not fbDragging then
		MainPanel.Visible=true
		MainPanel.Position=UDim2.new(0.5,-PanelW/2,1.5,0)
		Tw(MainPanel,{Position=UDim2.new(0.5,-PanelW/2,0.5,-PanelH/2)},0.35,Enum.EasingStyle.Back)
	end
end)

-- Body (sidebar + content)
local Body=Instance.new("Frame")
Body.Size=UDim2.new(1,0,1,-36); Body.Position=UDim2.new(0,0,0,36)
Body.BackgroundTransparency=1; Body.Parent=MainPanel

-- Sidebar
local Sidebar=Instance.new("ScrollingFrame")
Sidebar.Size=UDim2.new(0,SideW,1,0); Sidebar.BackgroundColor3=C.Sidebar
Sidebar.BorderSizePixel=0; Sidebar.ScrollBarThickness=0
Sidebar.CanvasSize=UDim2.new(0,0,0,0); Sidebar.AutomaticCanvasSize=Enum.AutomaticSize.Y
Sidebar.Parent=Body

-- Sidebar right border
local SBorder=Instance.new("Frame")
SBorder.Size=UDim2.new(0,1,1,0); SBorder.Position=UDim2.new(1,-1,0,0)
SBorder.BackgroundColor3=C.Accent; SBorder.BackgroundTransparency=0.7
SBorder.BorderSizePixel=0; SBorder.Parent=Sidebar

ListLayout(Sidebar, 2)
Pad(Sidebar, 8, 8, 4, 4)

-- Content area
local ContentArea=Instance.new("Frame")
ContentArea.Size=UDim2.new(1,-SideW,1,0); ContentArea.Position=UDim2.new(0,SideW,0,0)
ContentArea.BackgroundTransparency=1; ContentArea.Parent=Body

-- Page maker
local Pages={}
local function MakePage(name)
	local sf=Instance.new("ScrollingFrame")
	sf.Name=name; sf.Size=UDim2.fromScale(1,1)
	sf.BackgroundTransparency=1; sf.BorderSizePixel=0
	sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=C.Accent
	sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
	sf.Visible=false; sf.Parent=ContentArea
	ListLayout(sf, 6)
	Pad(sf, 8, 16, 8, 8)
	Pages[name]=sf
	return sf
end

local PageHome        = MakePage("Home")
local PageMovement    = MakePage("Movement")
local PageCheckpoints = MakePage("Checkpoints")
local PagePlayers     = MakePage("Players")
local PageESP         = MakePage("ESP")
local PageExtras      = MakePage("Extras")
local PageTime        = MakePage("TimeControl")
local PageSettings    = MakePage("Settings")

-- Page transition
local function ShowPage(name)
	local prev=Config.CurrentPage
	if Pages[prev] then Tw(Pages[prev],{GroupTransparency=1},0.15) end
	task.wait(0.12)
	for n,pg in pairs(Pages) do pg.Visible=(n==name) end
	Config.CurrentPage=name
	if Pages[name] then
		Pages[name].GroupTransparency=1
		Tw(Pages[name],{GroupTransparency=0},0.2)
	end
end

-- ============================================================
-- SIDEBAR NAVIGATION
-- ============================================================
local navDefs={
	{icon="🏠",labelKey="Home",     page="Home"},
	{icon="✈",labelKey="Movement",  page="Movement"},
	{icon="📍",labelKey="Checkpoints",page="Checkpoints"},
	{icon="👥",labelKey="Players",  page="Players"},
	{icon="👁",labelKey="ESP",       page="ESP"},
	{icon="✨",labelKey="Extras",    page="Extras"},
	{icon="⏱",labelKey="TimeControl",page="TimeControl"},
	{icon="⚙",labelKey="Settings",  page="Settings"},
}

local navBtns={}
for _,def in ipairs(navDefs) do
	local btn=Instance.new("TextButton")
	btn.Size=UDim2.new(1,-8,0,IsMobile and 54 or 46); btn.BackgroundTransparency=1
	btn.AutoButtonColor=false; btn.Text=""; btn.Parent=Sidebar

	Corner(btn,8)
	local highlight=Instance.new("Frame")
	highlight.Size=UDim2.new(0,2,0.7,0); highlight.AnchorPoint=Vector2.new(0,0.5)
	highlight.Position=UDim2.new(0,0,0.5,0); highlight.BackgroundColor3=C.Accent
	highlight.BackgroundTransparency=1; highlight.BorderSizePixel=0; highlight.Parent=btn

	local iconLbl=Instance.new("TextLabel")
	iconLbl.Size=UDim2.new(1,0,0,20); iconLbl.Position=UDim2.new(0,0,0,6)
	iconLbl.BackgroundTransparency=1; iconLbl.Font=Enum.Font.GothamBold
	iconLbl.Text=def.icon; iconLbl.TextSize=IsMobile and 17 or 15
	iconLbl.TextColor3=C.SubText; iconLbl.Parent=btn

	local textLbl=Instance.new("TextLabel")
	textLbl.Size=UDim2.new(1,-4,0,14); textLbl.Position=UDim2.new(0,2,0,28)
	textLbl.BackgroundTransparency=1; textLbl.Font=Enum.Font.Gotham
	textLbl.Text=T(def.labelKey); textLbl.TextSize=8
	textLbl.TextColor3=C.SubText; textLbl.TextWrapped=true; textLbl.Parent=btn

	table.insert(navBtns,{btn=btn,icon=iconLbl,lbl=textLbl,highlight=highlight,page=def.page,labelKey=def.labelKey})

	local function SetActive(active)
		if active then
			Tw(btn,{BackgroundTransparency=0.85},0.2)
			btn.BackgroundColor3=C.Accent
			Tw(iconLbl,{TextColor3=C.White},0.2)
			Tw(textLbl,{TextColor3=C.Accent},0.2)
			Tw(highlight,{BackgroundTransparency=0},0.2)
		else
			Tw(btn,{BackgroundTransparency=1},0.2)
			Tw(iconLbl,{TextColor3=C.SubText},0.2)
			Tw(textLbl,{TextColor3=C.SubText},0.2)
			Tw(highlight,{BackgroundTransparency=1},0.2)
		end
	end
	navBtns[#navBtns].SetActive=SetActive

	btn.MouseButton1Click:Connect(function()
		for _,nb in ipairs(navBtns) do nb.SetActive(nb.page==def.page) end
		ShowPage(def.page)
	end)
end

-- ============================================================
-- PAGE: HOME
-- ============================================================
-- Hero card
local heroCard=Instance.new("Frame")
heroCard.Size=UDim2.new(1,0,0,90); heroCard.BackgroundColor3=C.Card
heroCard.LayoutOrder=1; heroCard.Parent=PageHome; Corner(heroCard,12)
Stroke(heroCard,C.Accent,1.5)
Gradient(heroCard, Color3.fromRGB(28,10,80), Color3.fromRGB(6,20,70), 135)

-- Animated top shimmer line
local shimmer=Instance.new("Frame")
shimmer.Size=UDim2.new(0,60,0,2); shimmer.Position=UDim2.new(0,0,0,0)
shimmer.BackgroundColor3=C.AccentC; shimmer.BorderSizePixel=0; shimmer.Parent=heroCard
Corner(shimmer,1)

task.spawn(function()
	while heroCard.Parent do
		Tw(shimmer,{Size=UDim2.new(1,0,0,2)},0.8,Enum.EasingStyle.Quad)
		task.wait(0.9)
		shimmer.Size=UDim2.new(0,60,0,2)
		task.wait(0.3)
	end
end)

local heroTitle=Instance.new("TextLabel")
heroTitle.Size=UDim2.new(1,-20,0,26); heroTitle.Position=UDim2.new(0,14,0,12)
heroTitle.BackgroundTransparency=1; heroTitle.Font=Enum.Font.GothamBold
heroTitle.Text="⚡ "..T("WelcomeTitle"); heroTitle.TextColor3=C.White
heroTitle.TextSize=IsMobile and 14 or 13; heroTitle.TextXAlignment=Enum.TextXAlignment.Left
heroTitle.Parent=heroCard

local heroSub=Instance.new("TextLabel")
heroSub.Size=UDim2.new(1,-20,0,20); heroSub.Position=UDim2.new(0,14,0,40)
heroSub.BackgroundTransparency=1; heroSub.Font=Enum.Font.Gotham
heroSub.Text=T("WelcomeMsg"); heroSub.TextColor3=C.SubText
heroSub.TextSize=9; heroSub.TextXAlignment=Enum.TextXAlignment.Left
heroSub.TextWrapped=true; heroSub.Parent=heroCard

local playerName=Instance.new("TextLabel")
playerName.Size=UDim2.new(1,-20,0,16); playerName.Position=UDim2.new(0,14,0,70)
playerName.BackgroundTransparency=1; playerName.Font=Enum.Font.GothamBold
playerName.Text="👤 "..LocalPlayer.Name; playerName.TextColor3=C.AccentB
playerName.TextSize=9; playerName.TextXAlignment=Enum.TextXAlignment.Left
playerName.Parent=heroCard

-- Status grid
local statGrid=Instance.new("Frame")
statGrid.Size=UDim2.new(1,0,0,64); statGrid.BackgroundColor3=C.Card
statGrid.LayoutOrder=2; statGrid.Parent=PageHome; Corner(statGrid,10); Stroke(statGrid,C.AccentB,1)

local statHorizLayout=Instance.new("UIListLayout")
statHorizLayout.FillDirection=Enum.FillDirection.Horizontal
statHorizLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
statHorizLayout.VerticalAlignment=Enum.VerticalAlignment.Center
statHorizLayout.Padding=UDim.new(0,0); statHorizLayout.Parent=statGrid

local statDefs={
	{key="StatFly",    get=function() return Config.FlyEnabled end},
	{key="StatNoClip", get=function() return Config.NoClipEnabled end},
	{key="StatESP",    get=function() return Config.ESPEnabled end},
	{key="StatInvis",  get=function() return Config.InvisEnabled end},
	{key="StatTime",   get=function() return Config.LocalTimeEnabled or Config.GlobalTimeEnabled end},
	{key="StatAntiAFK",get=function() return Config.AntiAFKEnabled end},
}
local statValueLbls={}
for _,sd in ipairs(statDefs) do
	local col=Instance.new("Frame")
	col.Size=UDim2.new(1/#statDefs,0,1,0); col.BackgroundTransparency=1; col.Parent=statGrid

	local dot=Instance.new("Frame")
	dot.Size=UDim2.new(0,6,0,6); dot.AnchorPoint=Vector2.new(0.5,0)
	dot.Position=UDim2.new(0.5,0,0,8); dot.BackgroundColor3=C.SubText
	dot.BorderSizePixel=0; dot.Parent=col; Corner(dot,3)

	local vl=Instance.new("TextLabel")
	vl.Size=UDim2.new(1,0,0,18); vl.Position=UDim2.new(0,0,0,18)
	vl.BackgroundTransparency=1; vl.Font=Enum.Font.GothamBold
	vl.Text="OFF"; vl.TextColor3=C.SubText; vl.TextSize=10; vl.Parent=col

	local ll=Instance.new("TextLabel")
	ll.Size=UDim2.new(1,0,0,14); ll.Position=UDim2.new(0,0,0,36)
	ll.BackgroundTransparency=1; ll.Font=Enum.Font.Gotham
	ll.Text=T(sd.key); ll.TextColor3=C.SubText; ll.TextSize=8; ll.Parent=col

	table.insert(statValueLbls,{vl=vl,ll=ll,dot=dot,sd=sd})
end

RunService.Heartbeat:Connect(function()
	for _,sv in pairs(statValueLbls) do
		local on=sv.sd.get()
		sv.vl.Text= on and "ON" or "OFF"
		sv.vl.TextColor3= on and C.Success or C.SubText
		sv.dot.BackgroundColor3= on and C.Success or C.SubText
		sv.ll.Text=T(sv.sd.key)
	end
end)

-- ============================================================
-- PAGE: MOVEMENT
-- ============================================================
local movH,movHT,movHS = PageHeader(PageMovement,"MovementTitle","MovementSub",1)
local _,flyToggleSet,flyToggleLbl = MakeToggle(PageMovement,"FlyMode",false,3,function(v)
	if v then StartFly() else StopFly() end
end)
local flySlide,flySliderLbl = MakeSlider(PageMovement,"FlySpeed",5,250,Config.FlySpeed,4,function(v)
	Config.FlySpeed=v
end)
SectionHeader(PageMovement,T("SectionCharacter"),5)
local _,ncTogSet,ncTogLbl = MakeToggle(PageMovement,"NoClip",false,6,function(v)
	if v then StartNoClip() else StopNoClip() end
end)
local wsSlide,wsLbl = MakeSlider(PageMovement,"WalkSpeed",1,250,Config.WalkSpeed,7,function(v)
	Config.WalkSpeed=v; local h=GetHum(); if h then h.WalkSpeed=v end
end)
local jpSlide,jpLbl = MakeSlider(PageMovement,"JumpPower",1,250,Config.JumpPower,8,function(v)
	Config.JumpPower=v; local h=GetHum(); if h then h.JumpPower=v end
end)
MakeBtn(PageMovement,"ResetCharacter",C.Danger,9,function()
	local h=GetHum(); if h then h.Health=0 end
end)

-- ============================================================
-- PAGE: CHECKPOINTS
-- ============================================================
local cpH,cpHT,cpHS = PageHeader(PageCheckpoints,"CheckpointsTitle","CheckpointsSub",1)
local cpSaveBtns,cpLoadBtns={},{}
for i=1,3 do
	SectionHeader(PageCheckpoints,T("Slot").." "..i,(i-1)*3+2)
	local row=Instance.new("Frame")
	row.Size=UDim2.new(1,0,0,BTN_H); row.BackgroundTransparency=1
	row.LayoutOrder=(i-1)*3+3; row.Parent=PageCheckpoints
	ListLayout(row,6,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Center)

	local sb=Instance.new("TextButton")
	sb.Size=UDim2.new(0.48,0,0,BTN_H); sb.BackgroundColor3=C.AccentB
	sb.Font=Enum.Font.GothamBold; sb.Text=T("Save"); sb.TextColor3=C.White
	sb.TextSize=12; sb.AutoButtonColor=false; sb.Parent=row; Corner(sb,8)
	table.insert(cpSaveBtns,sb)

	local lb=Instance.new("TextButton")
	lb.Size=UDim2.new(0.48,0,0,BTN_H); lb.BackgroundColor3=C.Accent
	lb.Font=Enum.Font.GothamBold; lb.Text=T("Teleport"); lb.TextColor3=C.White
	lb.TextSize=12; lb.AutoButtonColor=false; lb.Parent=row; Corner(lb,8)
	table.insert(cpLoadBtns,lb)

	local slot=i
	sb.MouseButton1Click:Connect(function()
		SaveCP(slot); Tw(sb,{BackgroundColor3=C.Success},0.15)
		task.delay(0.6,function() Tw(sb,{BackgroundColor3=C.AccentB},0.3) end)
	end)
	lb.MouseButton1Click:Connect(function() LoadCP(slot) end)
end

-- ============================================================
-- PAGE: PLAYERS
-- ============================================================
local plH,plHT,plHS = PageHeader(PagePlayers,"PlayersTitle","PlayersSub",1)
SectionHeader(PagePlayers,T("TargetPlayer"),2)
local _,playerInputTB = MakeInput(PagePlayers,"PlayerNameHint",3)

MakeBtn(PagePlayers,"TeleportTo",C.Accent,4,function()
	local t=GetPlayerByName(playerInputTB.Text); if t then TeleportToPlayer(t) end
end)
MakeBtn(PagePlayers,"FollowPlayer",C.AccentB,5,function()
	local t=GetPlayerByName(playerInputTB.Text)
	if t then StartFollow(t) else StopFollow() end
end)
MakeBtn(PagePlayers,"SpectatePlayer",Color3.fromRGB(30,150,100),6,function()
	local t=GetPlayerByName(playerInputTB.Text)
	if t then StartSpectate(t) else StopSpectate() end
end)
MakeBtn(PagePlayers,"CopyOutfit",Color3.fromRGB(150,80,200),7,function()
	local name=SelectedPlayerName~="" and SelectedPlayerName or playerInputTB.Text
	CopyOutfit(name)
end)
MakeBtn(PagePlayers,"StopFollowSpec",Color3.fromRGB(80,80,110),8,function()
	StopFollow(); StopSpectate()
end)
SectionHeader(PagePlayers,T("PlayerList"),9)

local playerListFr=Instance.new("Frame")
playerListFr.Size=UDim2.new(1,0,0,110); playerListFr.BackgroundColor3=C.Card
playerListFr.LayoutOrder=10; playerListFr.Parent=PagePlayers; Corner(playerListFr,8); Stroke(playerListFr,C.Accent,1)

local playerScroll=Instance.new("ScrollingFrame")
playerScroll.Size=UDim2.fromScale(1,1); playerScroll.BackgroundTransparency=1
playerScroll.ScrollBarThickness=3; playerScroll.ScrollBarImageColor3=C.Accent
playerScroll.CanvasSize=UDim2.new(0,0,0,0); playerScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
playerScroll.Parent=playerListFr
ListLayout(playerScroll,3); Pad(playerScroll,5,5,6,6)

local function RefreshPlayerList()
	for _,c in pairs(playerScroll:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
	for _,p in pairs(Players:GetPlayers()) do
		local row=Instance.new("TextButton")
		row.Size=UDim2.new(1,0,0,IsMobile and 32 or 26)
		row.BackgroundColor3=C.Sidebar; row.Font=Enum.Font.Gotham
		row.Text=(p==LocalPlayer and "⭐ " or "")..p.Name
		row.TextColor3=p==LocalPlayer and C.Accent or C.Text
		row.TextSize=11; row.TextXAlignment=Enum.TextXAlignment.Left
		Corner(row,5); Pad(row,0,0,8,8); row.Parent=playerScroll
		row.MouseButton1Click:Connect(function()
			playerInputTB.Text=p.Name; SelectedPlayerName=p.Name
			Tw(row,{BackgroundColor3=C.Card},0.1)
			task.delay(0.3,function() Tw(row,{BackgroundColor3=C.Sidebar},0.2) end)
		end)
	end
end

RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function() task.wait(0.1); RefreshPlayerList() end)

MakeBtn(PagePlayers,"BringAll",C.Danger,11,function() BringAllPlayers() end)

-- ============================================================
-- PAGE: ESP & MUSIC
-- ============================================================
local espH,espHT,espHS = PageHeader(PageESP,"ESPTitle","ESPSub",1)
SectionHeader(PageESP,T("PlayerOverlay"),2)
local _,espTogSet,espTogLbl = MakeToggle(PageESP,"ShowNamesDist",false,3,function(v)
	Config.ESPEnabled=v; UpdateESP()
end)

local espInfoLbl=Instance.new("TextLabel")
espInfoLbl.Size=UDim2.new(1,0,0,32); espInfoLbl.BackgroundTransparency=1
espInfoLbl.Font=Enum.Font.Gotham; espInfoLbl.Text=T("ESPInfo")
espInfoLbl.TextColor3=C.SubText; espInfoLbl.TextSize=10; espInfoLbl.TextWrapped=true
espInfoLbl.LayoutOrder=4; espInfoLbl.TextXAlignment=GetAlign(); espInfoLbl.Parent=PageESP

SectionHeader(PageESP,T("MusicPlayer"),5)
local _,musicInputTB = MakeInput(PageESP,"SoundIDHint",6)
local volSlide,volLbl = MakeSlider(PageESP,"Volume",0,100,math.floor(Config.MusicVolume*100),7,function(v)
	Config.MusicVolume=v/100; if ActiveMusic then ActiveMusic.Volume=Config.MusicVolume end
end)
MakeBtn(PageESP,"PlayMusic",C.Success,8,function()
	local id=tonumber(musicInputTB.Text); if id then PlayMusic(id,Config.MusicVolume) end
end)
MakeBtn(PageESP,"StopMusic",C.Danger,9,function() StopMusic() end)

-- ============================================================
-- PAGE: EXTRAS (Invisibility + Outfit)
-- ============================================================
local extH,extHT,extHS = PageHeader(PageExtras,"ExtrasTitle","ExtrasSub",1)
SectionHeader(PageExtras,T("SectionInvis"),2)
local _,invisTogSet,invisTogLbl = MakeToggle(PageExtras,"Invisibility",false,3,function(v)
	SetInvisible(v)
end)

local invisInfoLbl=Instance.new("TextLabel")
invisInfoLbl.Size=UDim2.new(1,0,0,36); invisInfoLbl.BackgroundTransparency=1
invisInfoLbl.Font=Enum.Font.Gotham; invisInfoLbl.Text=T("InvisInfo")
invisInfoLbl.TextColor3=C.SubText; invisInfoLbl.TextSize=10; invisInfoLbl.TextWrapped=true
invisInfoLbl.LayoutOrder=4; invisInfoLbl.TextXAlignment=GetAlign(); invisInfoLbl.Parent=PageExtras

SectionHeader(PageExtras,T("SectionOutfit"),5)

local copytInfoLbl=Instance.new("TextLabel")
copytInfoLbl.Size=UDim2.new(1,0,0,36); copytInfoLbl.BackgroundTransparency=1
copytInfoLbl.Font=Enum.Font.Gotham; copytInfoLbl.Text=T("CopyOutfitInfo")
copytInfoLbl.TextColor3=C.SubText; copytInfoLbl.TextSize=10; copytInfoLbl.TextWrapped=true
copytInfoLbl.LayoutOrder=6; copytInfoLbl.TextXAlignment=GetAlign(); copytInfoLbl.Parent=PageExtras

local _,copyNameTB = MakeInput(PageExtras,"PlayerNameHint",7)
MakeBtn(PageExtras,"CopyOutfit",Color3.fromRGB(150,80,220),8,function()
	local n=copyNameTB.Text~="" and copyNameTB.Text or SelectedPlayerName
	CopyOutfit(n)
end)

-- ============================================================
-- PAGE: TIME CONTROL
-- ============================================================
local timeH,timeHT,timeHS = PageHeader(PageTime,"TimeTitle","TimeSub",1)

SectionHeader(PageTime,T("SectionLocalTime"),2)
local _,localTimeTogSet,localTimeLbl = MakeToggle(PageTime,"LocalTimeWarp",false,3,function(v)
	if v then StartLocalTime() else StopLocalTime() end
end)
local ltSlide,ltLbl = MakeSlider(PageTime,"LocalTimeSpeed",1,20,Config.LocalTimeSpeed,4,function(v)
	Config.LocalTimeSpeed=v
end)

SectionHeader(PageTime,T("SectionGlobalTime"),5)

local globalTimeInfo=Instance.new("TextLabel")
globalTimeInfo.Size=UDim2.new(1,0,0,40); globalTimeInfo.BackgroundTransparency=1
globalTimeInfo.Font=Enum.Font.Gotham
globalTimeInfo.Text="ℹ يتطلب سيرفر سكريبت — راجع تعليمات الملف\nRequires server script — see file instructions"
globalTimeInfo.TextColor3=C.Warning; globalTimeInfo.TextSize=10; globalTimeInfo.TextWrapped=true
globalTimeInfo.LayoutOrder=6; globalTimeInfo.TextXAlignment=GetAlign(); globalTimeInfo.Parent=PageTime

local _,globalTimeTogSet,globalTimeLbl = MakeToggle(PageTime,"GlobalTimeWarp",false,7,function(v)
	Config.GlobalTimeEnabled=v; SetGlobalTime(v,Config.GlobalTimeSpeed)
end)
local gtSlide,gtLbl = MakeSlider(PageTime,"GlobalTimeSpeed",1,20,Config.GlobalTimeSpeed,8,function(v)
	Config.GlobalTimeSpeed=v
	if Config.GlobalTimeEnabled then SetGlobalTime(true,v) end
end)

SectionHeader(PageTime,T("AuraZoneTitle"),9)

local auraInfoLbl=Instance.new("TextLabel")
auraInfoLbl.Size=UDim2.new(1,0,0,40); auraInfoLbl.BackgroundTransparency=1
auraInfoLbl.Font=Enum.Font.Gotham; auraInfoLbl.Text=T("AuraZoneInfo")
auraInfoLbl.TextColor3=C.SubText; auraInfoLbl.TextSize=10; auraInfoLbl.TextWrapped=true
auraInfoLbl.LayoutOrder=10; auraInfoLbl.TextXAlignment=GetAlign(); auraInfoLbl.Parent=PageTime

local _,auraZoneNameTB = MakeInput(PageTime,"AuraZoneHint",11)
auraZoneNameTB.Text="AuraZone"

-- Aura status display
local auraStatusFr=Instance.new("Frame")
auraStatusFr.Size=UDim2.new(1,0,0,36); auraStatusFr.BackgroundColor3=C.Card
auraStatusFr.LayoutOrder=12; auraStatusFr.Parent=PageTime; Corner(auraStatusFr,8); Stroke(auraStatusFr,C.Accent,1)

AuraStatusLabel=Instance.new("TextLabel")
AuraStatusLabel.Size=UDim2.fromScale(1,1); AuraStatusLabel.BackgroundTransparency=1
AuraStatusLabel.Font=Enum.Font.GothamBold; AuraStatusLabel.Text=T("AuraStatus")
AuraStatusLabel.TextColor3=C.SubText; AuraStatusLabel.TextSize=12; AuraStatusLabel.Parent=auraStatusFr

-- Toggle aura zone detection
local _,auraTogSet,auraTogLbl = MakeToggle(PageTime,"AuraZoneTitle",false,13,function(v)
	if v then
		StartAuraZone(auraZoneNameTB.Text)
	else
		StopAuraZone()
	end
end)

-- ============================================================
-- PAGE: SETTINGS
-- ============================================================
local setH,setHT,setHS = PageHeader(PageSettings,"SettingsTitle","SettingsSub",1)
SectionHeader(PageSettings,T("General"),2)
local _,antiAfkSet,antiAfkLbl = MakeToggle(PageSettings,"AntiAFK",Config.AntiAFKEnabled,3,function(v)
	Config.AntiAFKEnabled=v
end)
SectionHeader(PageSettings,T("Data"),4)
MakeBtn(PageSettings,"SaveSettings",C.Accent,5,function() SaveSettings() end)
MakeBtn(PageSettings,"ResetDefaults",C.Danger,6,function()
	Config.FlySpeed=50; Config.WalkSpeed=16; Config.JumpPower=50; Config.MusicVolume=0.5
end)
SectionHeader(PageSettings,T("UI"),7)
MakeBtn(PageSettings,"HidePanel",Color3.fromRGB(55,55,80),8,function()
	Tw(MainPanel,{Position=UDim2.new(0.5,-PanelW/2,1.5,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	task.delay(0.35,function() MainPanel.Visible=false end)
end)
SectionHeader(PageSettings,T("Language"),9)

local langBtn=Instance.new("TextButton")
langBtn.Size=UDim2.new(1,0,0,BTN_H); langBtn.BackgroundColor3=Color3.fromRGB(35,80,160)
langBtn.Font=Enum.Font.GothamBold; langBtn.Text=T("LangToggle")
langBtn.TextColor3=C.White; langBtn.TextSize=12; langBtn.AutoButtonColor=false
langBtn.LayoutOrder=10; langBtn.Parent=PageSettings; Corner(langBtn,8)

local verLbl=Instance.new("TextLabel")
verLbl.Size=UDim2.new(1,0,0,20); verLbl.BackgroundTransparency=1
verLbl.Font=Enum.Font.Gotham; verLbl.Text=T("Version")
verLbl.TextColor3=C.SubText; verLbl.TextSize=9
verLbl.LayoutOrder=11; verLbl.Parent=PageSettings

-- ============================================================
-- LANGUAGE REFRESH
-- ============================================================
local function ApplyLanguage()
	local al=GetAlign()
	for _,nb in ipairs(navBtns) do nb.lbl.Text=T(nb.labelKey) end
	heroTitle.Text="⚡ "..T("WelcomeTitle")
	heroSub.Text=T("WelcomeMsg")
	for _,sv in ipairs(statValueLbls) do sv.ll.Text=T(sv.sd.key) end
	-- movement
	movHT.Text=T("MovementTitle"); movHT.TextXAlignment=al
	movHS.Text=T("MovementSub");   movHS.TextXAlignment=al
	if flyToggleLbl then flyToggleLbl.Text=T("FlyMode"); flyToggleLbl.TextXAlignment=al end
	if flySliderLbl then flySliderLbl.Text=T("FlySpeed"); flySliderLbl.TextXAlignment=al end
	if ncTogLbl     then ncTogLbl.Text=T("NoClip"); ncTogLbl.TextXAlignment=al end
	if wsLbl        then wsLbl.Text=T("WalkSpeed"); wsLbl.TextXAlignment=al end
	if jpLbl        then jpLbl.Text=T("JumpPower"); jpLbl.TextXAlignment=al end
	-- players
	plHT.Text=T("PlayersTitle"); plHT.TextXAlignment=al
	plHS.Text=T("PlayersSub");   plHS.TextXAlignment=al
	playerInputTB.PlaceholderText=T("PlayerNameHint")
	-- esp
	espHT.Text=T("ESPTitle"); espHT.TextXAlignment=al
	espHS.Text=T("ESPSub");   espHS.TextXAlignment=al
	if espTogLbl   then espTogLbl.Text=T("ShowNamesDist"); espTogLbl.TextXAlignment=al end
	espInfoLbl.Text=T("ESPInfo"); espInfoLbl.TextXAlignment=al
	musicInputTB.PlaceholderText=T("SoundIDHint")
	if volLbl      then volLbl.Text=T("Volume"); volLbl.TextXAlignment=al end
	-- extras
	extHT.Text=T("ExtrasTitle"); extHT.TextXAlignment=al
	extHS.Text=T("ExtrasSub");   extHS.TextXAlignment=al
	if invisTogLbl then invisTogLbl.Text=T("Invisibility"); invisTogLbl.TextXAlignment=al end
	invisInfoLbl.Text=T("InvisInfo"); invisInfoLbl.TextXAlignment=al
	copytInfoLbl.Text=T("CopyOutfitInfo"); copytInfoLbl.TextXAlignment=al
	-- time
	timeHT.Text=T("TimeTitle"); timeHT.TextXAlignment=al
	timeHS.Text=T("TimeSub");   timeHS.TextXAlignment=al
	if localTimeLbl then localTimeLbl.Text=T("LocalTimeWarp"); localTimeLbl.TextXAlignment=al end
	if globalTimeLbl then globalTimeLbl.Text=T("GlobalTimeWarp"); globalTimeLbl.TextXAlignment=al end
	auraInfoLbl.Text=T("AuraZoneInfo"); auraInfoLbl.TextXAlignment=al
	-- settings
	setHT.Text=T("SettingsTitle"); setHT.TextXAlignment=al
	setHS.Text=T("SettingsSub");   setHS.TextXAlignment=al
	if antiAfkLbl  then antiAfkLbl.Text=T("AntiAFK"); antiAfkLbl.TextXAlignment=al end
	langBtn.Text=T("LangToggle")
	verLbl.Text=T("Version")
end

langBtn.MouseButton1Click:Connect(function()
	CurrentLanguage = IsArabic() and "EN" or "AR"
	ApplyLanguage()
	Tw(langBtn,{Size=UDim2.new(0.96,0,0,BTN_H-3)},0.07)
	task.delay(0.07,function() Tw(langBtn,{Size=UDim2.new(1,0,0,BTN_H)},0.12) end)
end)

-- ============================================================
-- INITIAL STATE
-- ============================================================
ApplyLanguage()
ShowPage("Home")
navBtns[1].SetActive(true)

-- Entrance animation
MainPanel.Position=UDim2.new(0.5,-PanelW/2,1.5,0)
Tw(MainPanel,{Position=UDim2.new(0.5,-PanelW/2,0.5,-PanelH/2)},0.45,Enum.EasingStyle.Back)

-- ============================================================
-- SERVER SCRIPT (انسخ هذا في Script داخل ServerScriptService)
-- ============================================================
--[[
========================= SERVER SCRIPT =========================
-- اسمه: ThaerServer | ضعه في ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- أنشئ أو ابحث عن RemoteEvent
local TimeRemote = ReplicatedStorage:FindFirstChild("ThaerTimeWarp")
if not TimeRemote then
    TimeRemote = Instance.new("RemoteEvent")
    TimeRemote.Name = "ThaerTimeWarp"
    TimeRemote.Parent = ReplicatedStorage
end

local globalTimeEnabled = false
local globalTimeSpeed = 1

-- استقبل الأوامر من اللاعب
TimeRemote.OnServerEvent:Connect(function(player, enabled, speed)
    globalTimeEnabled = enabled
    globalTimeSpeed = speed or 1
end)

-- حلقة تغيير الوقت
RunService.Heartbeat:Connect(function(dt)
    if globalTimeEnabled then
        Lighting.ClockTime = (Lighting.ClockTime + dt * globalTimeSpeed) % 24
    end
end)
=================================================================
--]]

-- ============================================================
-- END OF THAER X100 v2.0 LOCALSCRIPT
-- ============================================================
