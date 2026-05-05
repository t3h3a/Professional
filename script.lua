-- ============================================================
--   THAER X100  |  v2.0  |  Single LocalScript
--   لوحة إدارة ماب "اختبار الهكر"
--   كل الميزات في سكريبت واحد — لا ملفات إضافية
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local SoundService     = game:GetService("SoundService")
local Lighting         = game:GetService("Lighting")
local VirtualUser      = game:GetService("VirtualUser")
local Workspace        = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local IsMobile    = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================================
-- اللغة
-- ============================================================
local Lang = "AR"
local L = {
	AR = {
		PanelTitle    = "⚡ THAER X100",
		Home          = "🏠 رئيسية",
		Movement      = "✈ حركة",
		Checkpoints   = "📍 حفظ",
		Players       = "👥 لاعبين",
		Radar         = "👁 رادار",
		Extras        = "✨ إضافات",
		Time          = "⏱ وقت",
		Settings      = "⚙ إعدادات",
		WelcomeMsg    = "مرحباً في لوحة تحكم ماب اختبار الهكر",
		StatusCard    = "حالة الميزات",
		-- حركة
		MovTitle      = "أدوات الحركة",
		MovSub        = "طيران · اختراق · سرعة · قفز",
		FlySection    = "الطيران",
		FlyToggle     = "✈ وضع الطيران",
		FlySpeed      = "سرعة الطيران",
		CharSection   = "الشخصية",
		NoClip        = "🧱 اختراق الجدران",
		WalkSpeed     = "سرعة المشي",
		JumpPower     = "قوة القفز",
		ResetChar     = "💀 إعادة تعيين",
		-- نقاط حفظ
		CpTitle       = "نقاط الحفظ",
		CpSub         = "احفظ وانتقل إلى المواقع",
		Slot          = "خانة",
		Save          = "💾 حفظ",
		Teleport      = "📍 انتقال",
		-- لاعبين
		PlTitle       = "أدوات اللاعبين",
		PlSub         = "إدارة اللاعبين والتحكم بهم",
		TargetSec     = "اللاعب المستهدف",
		PlHint        = "اكتب اسم اللاعب...",
		TpTo          = "🔍 انتقل إليه",
		Follow        = "👣 تتبع",
		Spectate      = "🎥 مشاهدة",
		StopAll       = "⏹ أوقف الكل",
		CopyOutfit    = "👕 نسخ المظهر",
		PlList        = "قائمة اللاعبين",
		BringAll      = "📥 جلب الكل",
		-- رادار
		RadTitle      = "الرادار والموسيقى",
		RadSub        = "تراكب · مشغل موسيقى",
		ESPToggle     = "👁 رادار الأسماء والمسافة",
		ESPInfo       = "يعرض اسم كل لاعب ومسافته عنك.",
		MusicSec      = "مشغل الموسيقى",
		SoundHint     = "معرف الصوت (أرقام فقط)...",
		Volume        = "الصوت",
		PlayMusic     = "▶ تشغيل",
		StopMusic     = "⏹ إيقاف",
		-- إضافات
		ExtTitle      = "إضافات",
		ExtSub        = "اختفاء · نسخ مظهر",
		InvisSec      = "الاختفاء",
		InvisToggle   = "👻 وضع الاختفاء",
		InvisInfo     = "يخفي شخصيتك ويحذف اسمك من فوق رأسك.",
		OutfitSec     = "نسخ المظهر",
		OutfitInfo    = "اختر لاعباً من قائمة اللاعبين ثم اضغط نسخ.",
		CopyBtn       = "👕 نسخ مظهر اللاعب المحدد",
		-- وقت
		TimeTitle     = "التحكم بالوقت",
		TimeSub       = "تسريع الوقت وتأثير الأورا",
		LocalTimeSec  = "تسريع الوقت",
		TimeToggle    = "🌀 تسريع وقت السماء",
		TimeSpeed     = "سرعة الوقت",
		AuraSec       = "منطقة الأورا ⚡",
		AuraInfo      = "ضع اسم الـ Part في الماب. لمّا تدخل المنطقة يتسارع الوقت 10x.",
		AuraPartName  = "اسم Part المنطقة",
		AuraHint      = "AuraZone",
		AuraToggle    = "⚡ تفعيل كشف منطقة الأورا",
		AuraOff       = "⚡ الأورا: غير نشطة",
		AuraOn        = "⚡ الأورا نشطة! × 10",
		-- إعدادات
		SetTitle      = "الإعدادات",
		SetSub        = "إعدادات اللوحة",
		GeneralSec    = "عام",
		AntiAFK       = "💤 مكافحة الخمول",
		DataSec       = "البيانات",
		SaveSet       = "💾 حفظ الإعدادات",
		ResetDef      = "🔄 إعادة للافتراضي",
		UISec         = "الواجهة",
		HidePanel     = "🙈 إخفاء اللوحة",
		LangSec       = "اللغة",
		LangBtn       = "🌐 English",
		Version       = "THAER X100  v2.0",
		-- حالات
		FlyOn="طيران", NcOn="اختراق", ESPOn="رادار",
		InvOn="اختفاء", TimeOn="وقت", AtkOn="خمول",
	},
	EN = {
		PanelTitle    = "⚡ THAER X100",
		Home          = "🏠 Home",
		Movement      = "✈ Move",
		Checkpoints   = "📍 Saves",
		Players       = "👥 Players",
		Radar         = "👁 Radar",
		Extras        = "✨ Extras",
		Time          = "⏱ Time",
		Settings      = "⚙ Settings",
		WelcomeMsg    = "Welcome to the Hacker Test Map Admin Panel",
		StatusCard    = "Feature Status",
		MovTitle      = "Movement Tools",
		MovSub        = "Fly · NoClip · Speed · Jump",
		FlySection    = "Flight",
		FlyToggle     = "✈ Fly Mode",
		FlySpeed      = "Fly Speed",
		CharSection   = "Character",
		NoClip        = "🧱 NoClip",
		WalkSpeed     = "Walk Speed",
		JumpPower     = "Jump Power",
		ResetChar     = "💀 Reset Character",
		CpTitle       = "Checkpoints",
		CpSub         = "Save and teleport to positions",
		Slot          = "Slot",
		Save          = "💾 Save",
		Teleport      = "📍 Teleport",
		PlTitle       = "Player Tools",
		PlSub         = "Manage and interact with players",
		TargetSec     = "Target Player",
		PlHint        = "Player name...",
		TpTo          = "🔍 Teleport To",
		Follow        = "👣 Follow",
		Spectate      = "🎥 Spectate",
		StopAll       = "⏹ Stop All",
		CopyOutfit    = "👕 Copy Outfit",
		PlList        = "Player List",
		BringAll      = "📥 Bring All",
		RadTitle      = "Radar & Music",
		RadSub        = "Overlay · Music Player",
		ESPToggle     = "👁 Show Names & Distance",
		ESPInfo       = "Displays player names and distance.",
		MusicSec      = "Music Player",
		SoundHint     = "Sound ID (numbers only)...",
		Volume        = "Volume",
		PlayMusic     = "▶ Play",
		StopMusic     = "⏹ Stop",
		ExtTitle      = "Extras",
		ExtSub        = "Invisibility · Outfit Copy",
		InvisSec      = "Invisibility",
		InvisToggle   = "👻 Invisible Mode",
		InvisInfo     = "Hides your character and removes your nametag.",
		OutfitSec     = "Copy Outfit",
		OutfitInfo    = "Select a player from the list then press Copy.",
		CopyBtn       = "👕 Copy Selected Player's Outfit",
		TimeTitle     = "Time Control",
		TimeSub       = "Speed up time & Aura Zone",
		LocalTimeSec  = "Time Warp",
		TimeToggle    = "🌀 Speed Up Sky Time",
		TimeSpeed     = "Time Speed",
		AuraSec       = "Aura Zone ⚡",
		AuraInfo      = "Enter a Part name in the map. When inside, time speeds up 10x.",
		AuraPartName  = "Zone Part Name",
		AuraHint      = "AuraZone",
		AuraToggle    = "⚡ Enable Aura Zone Detection",
		AuraOff       = "⚡ Aura: Inactive",
		AuraOn        = "⚡ Aura Active! × 10",
		SetTitle      = "Settings",
		SetSub        = "Panel configuration",
		GeneralSec    = "General",
		AntiAFK       = "💤 Anti-AFK",
		DataSec       = "Data",
		SaveSet       = "💾 Save Settings",
		ResetDef      = "🔄 Reset Defaults",
		UISec         = "Interface",
		HidePanel     = "🙈 Hide Panel",
		LangSec       = "Language",
		LangBtn       = "🌐 عربي",
		Version       = "THAER X100  v2.0",
		FlyOn="Fly", NcOn="NoClip", ESPOn="ESP",
		InvOn="Invis", TimeOn="Time", AtkOn="AFK",
	},
}
local function T(k) return (L[Lang] and L[Lang][k]) or k end

-- ============================================================
-- الإعدادات والحالة
-- ============================================================
local Cfg = {
	FlySpeed=50, WalkSpeed=16, JumpPower=50,
	FlyOn=false, NcOn=false, ESPOn=false,
	AntiAFK=true, MusicVol=0.5,
	InvisOn=false, TimeOn=false, TimeSpeed=5,
	AuraOn=false, Page="Home",
}
local Checkpoints   = {}
local FollowConn    = nil
local SpectateConn  = nil
local FlyConn       = nil
local NcConn        = nil
local TimeConn      = nil
local AuraConn      = nil
local AuraActive    = false
local ESPObjs       = {}
local ActiveMusic   = nil
local SelPlayer     = ""
local AuraLabelRef  = nil
local BaseTimeSpeed = 0

-- ============================================================
-- حفظ/تحميل
-- ============================================================
local function SaveCfg()
	local ok,d = pcall(HttpService.JSONEncode,HttpService,{
		FlySpeed=Cfg.FlySpeed,WalkSpeed=Cfg.WalkSpeed,
		JumpPower=Cfg.JumpPower,MusicVol=Cfg.MusicVol,
	})
	if ok and writefile then pcall(writefile,"thaer_cfg.json",d) end
end
local function LoadCfg()
	if not readfile then return end
	local ok,r = pcall(readfile,"thaer_cfg.json")
	if ok and r then
		local ok2,t = pcall(HttpService.JSONDecode,HttpService,r)
		if ok2 and t then for k,v in pairs(t) do Cfg[k]=v end end
	end
end
LoadCfg()

-- ============================================================
-- مساعدات
-- ============================================================
local function Char()  return LocalPlayer.Character end
local function Hum()   local c=Char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function HRP()   local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function SafeParts()
	local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return c, c:WaitForChild("HumanoidRootPart",5), c:WaitForChild("Humanoid",5)
end
local function Tw(o,p,t,s,d)
	TweenService:Create(o,TweenInfo.new(t or .25,s or Enum.EasingStyle.Quart,d or Enum.EasingDirection.Out),p):Play()
end

-- ============================================================
-- Anti-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
	if Cfg.AntiAFK then
		pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
	end
end)

-- ============================================================
-- الطيران
-- ============================================================
local function StopFly()
	Cfg.FlyOn=false
	if FlyConn then FlyConn:Disconnect(); FlyConn=nil end
	local c=Char()
	if c then
		for _,v in pairs(c:GetDescendants()) do
			if v.Name=="ThrBV" or v.Name=="ThrBG" then pcall(function()v:Destroy()end) end
		end
	end
	local h=Hum(); if h then pcall(function() h.PlatformStand=false end); h:ChangeState(Enum.HumanoidStateType.GettingUp) end
	local hrp=HRP(); if hrp then pcall(function() hrp.AssemblyLinearVelocity=Vector3.new(0,-1,0) end) end
end

local function StartFly()
	StopFly()
	local char,hrp,hum; local ok=pcall(function() char,hrp,hum=SafeParts() end)
	if not ok or not hrp or not hum then return end
	Cfg.FlyOn=true
	for _,v in pairs(char:GetDescendants()) do
		if v.Name=="ThrBV" or v.Name=="ThrBG" then pcall(function()v:Destroy()end) end
	end
	local bv=Instance.new("BodyVelocity")
	bv.Name="ThrBV"; bv.Velocity=Vector3.zero; bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=hrp
	local bg=Instance.new("BodyGyro")
	bg.Name="ThrBG"; bg.MaxTorque=Vector3.new(1e9,1e9,1e9); bg.P=9000; bg.D=500; bg.CFrame=hrp.CFrame; bg.Parent=hrp
	FlyConn=RunService.Heartbeat:Connect(function()
		local ch=HRP(); local hm=Hum()
		if not Cfg.FlyOn or not ch or not hm then StopFly(); return end
		if not bv.Parent or not bg.Parent then StopFly(); return end
		if ch.Anchored then ch.Anchored=false end
		if hm:GetState()~=Enum.HumanoidStateType.Swimming then hm:ChangeState(Enum.HumanoidStateType.Swimming) end
		hm.PlatformStand=false
		local spd=Cfg.FlySpeed; local cf=Camera.CFrame; local dir=Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd=spd*2 end
		if IsMobile and hm.MoveDirection.Magnitude>.1 then
			local m=hm.MoveDirection; dir=dir+Vector3.new(m.X,0,m.Z) end
		bv.Velocity = dir.Magnitude>0 and dir.Unit*spd or Vector3.zero
		local fl=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z)
		if fl.Magnitude>.01 then bg.CFrame=CFrame.new(Vector3.zero,fl) end
	end)
end

-- ============================================================
-- NoClip
-- ============================================================
local function StopNc()
	Cfg.NcOn=false
	if NcConn then NcConn:Disconnect(); NcConn=nil end
	local c=Char(); if not c then return end
	for _,p in pairs(c:GetDescendants()) do
		if p:IsA("BasePart") then pcall(function()p.CanCollide=true end) end
	end
end
local function StartNc()
	Cfg.NcOn=true
	NcConn=RunService.Stepped:Connect(function()
		if not Cfg.NcOn then StopNc(); return end
		local c=Char(); if not c then return end
		for _,p in pairs(c:GetDescendants()) do
			if p:IsA("BasePart") then pcall(function()p.CanCollide=false end) end
		end
	end)
end

-- ============================================================
-- الاختفاء
-- ============================================================
local function SetInvis(state)
	Cfg.InvisOn=state
	local c=Char(); if not c then return end
	pcall(function()
		local h=c:FindFirstChildOfClass("Humanoid")
		if h then
			h.DisplayDistanceType = state
				and Enum.HumanoidDisplayDistanceType.None
				or  Enum.HumanoidDisplayDistanceType.Viewer
		end
		for _,v in pairs(c:GetDescendants()) do
			if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
				v.LocalTransparencyModifier = state and 1 or 0
			end
			if v:IsA("Decal") then v.Transparency = state and 1 or 0 end
		end
		local hrp=c:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.LocalTransparencyModifier=1 end
	end)
end

-- ============================================================
-- نسخ المظهر
-- ============================================================
local function CopyOutfit(name)
	local tp=Players:FindFirstChild(name); if not tp then return end
	local tc=tp.Character; if not tc then return end
	pcall(function()
		local th=tc:FindFirstChildOfClass("Humanoid")
		local mh=Hum()
		if th and mh then
			local desc=th:GetAppliedDescription()
			task.wait(0.1)
			pcall(function() mh:ApplyDescription(desc) end)
		end
	end)
end

-- ============================================================
-- تسريع الوقت (محلي — يغير السماء)
-- ============================================================
local function StopTime()
	Cfg.TimeOn=false
	if TimeConn then TimeConn:Disconnect(); TimeConn=nil end
end
local function StartTime(speed)
	StopTime(); Cfg.TimeOn=true
	TimeConn=RunService.Heartbeat:Connect(function(dt)
		if not Cfg.TimeOn then StopTime(); return end
		pcall(function() Lighting.ClockTime=(Lighting.ClockTime+dt*speed)%24 end)
	end)
end

-- ============================================================
-- منطقة الأورا
-- ============================================================
local function StopAura()
	Cfg.AuraOn=false; AuraActive=false
	if AuraConn then AuraConn:Disconnect(); AuraConn=nil end
	-- أعد الوقت لسرعته الأصلية إذا كان مفعلاً قبل الأورا
	if Cfg.TimeOn then StartTime(Cfg.TimeSpeed) end
	if AuraLabelRef then
		pcall(function()
			AuraLabelRef.Text      = T("AuraOff")
			AuraLabelRef.TextColor3= Color3.fromRGB(120,110,170)
		end)
	end
end

local function StartAura(partName)
	StopAura(); Cfg.AuraOn=true
	partName = (partName and partName~="") and partName or "AuraZone"
	AuraConn=RunService.Heartbeat:Connect(function()
		local hrp=HRP(); if not hrp then return end
		local zone=Workspace:FindFirstChild(partName,true)
		if not zone or not zone:IsA("BasePart") then
			if AuraLabelRef then
				pcall(function()
					AuraLabelRef.Text="⚠ Part '"..partName.."' غير موجود"
					AuraLabelRef.TextColor3=Color3.fromRGB(235,65,85)
				end)
			end
			return
		end
		local zp=zone.Position; local zs=zone.Size/2; local pp=hrp.Position
		local inside = math.abs(pp.X-zp.X)<zs.X
			and math.abs(pp.Y-zp.Y)<zs.Y+4
			and math.abs(pp.Z-zp.Z)<zs.Z
		if inside and not AuraActive then
			AuraActive=true
			StartTime(Cfg.TimeSpeed*10)
			if AuraLabelRef then
				pcall(function()
					AuraLabelRef.Text=T("AuraOn")
					AuraLabelRef.TextColor3=Color3.fromRGB(255,200,0)
				end)
			end
		elseif not inside and AuraActive then
			AuraActive=false
			StartTime(Cfg.TimeSpeed)
			if AuraLabelRef then
				pcall(function()
					AuraLabelRef.Text=T("AuraOff")
					AuraLabelRef.TextColor3=Color3.fromRGB(120,110,170)
				end)
			end
		end
	end)
end

-- ============================================================
-- نقاط الحفظ
-- ============================================================
local function SaveCP(i)
	local h=HRP(); if h then Checkpoints[i]=h.CFrame end
end
local function LoadCP(i)
	local cf=Checkpoints[i]; local h=HRP()
	if cf and h then pcall(function()h.CFrame=cf end) end
end

-- ============================================================
-- أدوات اللاعبين
-- ============================================================
local function FindPlayer(n)
	n=n:lower()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(n,1,true) then return p end
	end
end
local function TpTo(t)
	local h=HRP(); local tc=t.Character
	local th=tc and tc:FindFirstChild("HumanoidRootPart")
	if h and th then h.CFrame=th.CFrame+Vector3.new(3,0,0) end
end
local FollowTarget=nil
local function StopFollow()
	if FollowConn then FollowConn:Disconnect(); FollowConn=nil end; FollowTarget=nil
end
local function StartFollow(t)
	StopFollow(); FollowTarget=t
	FollowConn=RunService.Heartbeat:Connect(function()
		local h=HRP(); local tc=FollowTarget and FollowTarget.Character
		local th=tc and tc:FindFirstChild("HumanoidRootPart")
		if h and th then h.CFrame=th.CFrame+th.CFrame.LookVector*-3 end
	end)
end
local SpectateTarget=nil
local function StopSpec()
	if SpectateConn then SpectateConn:Disconnect(); SpectateConn=nil end
	SpectateTarget=nil; Camera.CameraType=Enum.CameraType.Custom; Camera.CameraSubject=Hum()
end
local function StartSpec(t)
	StopSpec(); SpectateTarget=t; Camera.CameraType=Enum.CameraType.Custom
	SpectateConn=RunService.RenderStepped:Connect(function()
		local tc=SpectateTarget and SpectateTarget.Character
		local th=tc and tc:FindFirstChildOfClass("Humanoid")
		if th then Camera.CameraSubject=th end
	end)
end
local function BringAll()
	local h=HRP(); if not h then return end
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			pcall(function()
				local tc=p.Character
				local th=tc and tc:FindFirstChild("HumanoidRootPart")
				if th then th.CFrame=h.CFrame+Vector3.new(math.random(-4,4),0,math.random(-4,4)) end
			end)
		end
	end
end

-- ============================================================
-- Respawn - إعادة تفعيل الميزات
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function()
	local wasF=Cfg.FlyOn; local wasN=Cfg.NcOn; local wasI=Cfg.InvisOn; local wasT=Cfg.TimeOn
	Cfg.FlyOn=false; Cfg.NcOn=false; Cfg.InvisOn=false; Cfg.TimeOn=false
	FlyConn=nil; NcConn=nil; TimeConn=nil
	task.wait(0.6)
	if wasF then StartFly() end
	if wasN then StartNc()  end
	if wasI then SetInvis(true) end
	if wasT then StartTime(Cfg.TimeSpeed) end
end)

-- ============================================================
-- ESP
-- ============================================================
local function ClearESP()
	for _,v in pairs(ESPObjs) do
		pcall(function() if type(v)=="table" then v:Disconnect() else v:Destroy() end end)
	end
	ESPObjs={}
end
local function BuildESP()
	ClearESP()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			local bb=Instance.new("BillboardGui")
			bb.Name="ThrESP"; bb.AlwaysOnTop=true
			bb.Size=UDim2.new(0,130,0,44); bb.StudsOffset=Vector3.new(0,3.2,0)
			local bg2=Instance.new("Frame")
			bg2.Size=UDim2.fromScale(1,1); bg2.BackgroundColor3=Color3.fromRGB(6,4,20)
			bg2.BackgroundTransparency=0.2; bg2.Parent=bb
			local c2=Instance.new("UICorner"); c2.CornerRadius=UDim.new(0,9); c2.Parent=bg2
			local s2=Instance.new("UIStroke"); s2.Color=Color3.fromRGB(120,60,255); s2.Thickness=1.5; s2.Parent=bg2
			local lbl=Instance.new("TextLabel")
			lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
			lbl.Font=Enum.Font.GothamBold; lbl.TextColor3=Color3.fromRGB(190,150,255)
			lbl.TextSize=13; lbl.Parent=bg2
			local conn=RunService.Heartbeat:Connect(function()
				local c3=p.Character; local hr=c3 and c3:FindFirstChild("HumanoidRootPart")
				local lh=HRP()
				if hr and lh then
					lbl.Text=p.Name.."\n"..math.floor((hr.Position-lh.Position).Magnitude).." m"
					bb.Adornee=hr; bb.Parent=Workspace
				else bb.Parent=nil end
			end)
			table.insert(ESPObjs,bb)
			table.insert(ESPObjs,{Disconnect=function()conn:Disconnect()end})
		end
	end
end
local function ToggleESP(v) Cfg.ESPOn=v; if v then BuildESP() else ClearESP() end end

-- ============================================================
-- موسيقى
-- ============================================================
local function PlayMusic(id,vol)
	if ActiveMusic then ActiveMusic:Destroy(); ActiveMusic=nil end
	local s=Instance.new("Sound")
	s.SoundId="rbxassetid://"..tostring(id); s.Volume=vol or Cfg.MusicVol
	s.Looped=true; s.Parent=SoundService; s:Play(); ActiveMusic=s
end
local function StopMus()
	if ActiveMusic then ActiveMusic:Stop(); ActiveMusic:Destroy(); ActiveMusic=nil end
end

-- ============================================================
-- ====  بناء الواجهة  ====
-- ============================================================
local old=LocalPlayer.PlayerGui:FindFirstChild("ThaerX100")
if old then old:Destroy() end
local SG=Instance.new("ScreenGui")
SG.Name="ThaerX100"; SG.ResetOnSpawn=false
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset=true; SG.Parent=LocalPlayer.PlayerGui

-- لوحة الألوان
local C={
	BG     = Color3.fromRGB(7,8,21),
	Panel  = Color3.fromRGB(11,12,30),
	Side   = Color3.fromRGB(8,9,24),
	Card   = Color3.fromRGB(15,17,42),
	Acc    = Color3.fromRGB(115,55,255),
	AccB   = Color3.fromRGB(55,125,255),
	AccC   = Color3.fromRGB(210,75,255),
	Neon   = Color3.fromRGB(160,90,255),
	Txt    = Color3.fromRGB(225,220,255),
	Sub    = Color3.fromRGB(115,105,165),
	OK     = Color3.fromRGB(45,215,135),
	Err    = Color3.fromRGB(235,60,80),
	Warn   = Color3.fromRGB(255,190,0),
	TOn    = Color3.fromRGB(115,55,255),
	TOff   = Color3.fromRGB(32,32,58),
	W      = Color3.fromRGB(255,255,255),
}

-- أحجام متوافقة مع الهاتف
local BH  = IsMobile and 46 or 36
local TGH = IsMobile and 48 or 37
local SLH = IsMobile and 64 or 52
local INH = IsMobile and 44 or 34
local FS  = IsMobile and 13 or 12
local PW  = IsMobile and 320 or 335
local PH  = IsMobile and 530 or 490
local SW  = IsMobile and 78  or 70

-- ============================================================
-- مكونات الواجهة
-- ============================================================
local function Cor(p,r)
	local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c
end
local function Str(p,col,th)
	local s=Instance.new("UIStroke"); s.Color=col or C.Acc; s.Thickness=th or 1.2; s.Parent=p; return s
end
local function Grad(p,c0,c1,rot)
	local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(c0,c1); g.Rotation=rot or 90; g.Parent=p; return g
end
local function LL(p,pad,dir,ha,va)
	local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,pad or 5)
	l.FillDirection=dir or Enum.FillDirection.Vertical
	l.HorizontalAlignment=ha or Enum.HorizontalAlignment.Center
	l.VerticalAlignment=va or Enum.VerticalAlignment.Top
	l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p; return l
end
local function Pd(p,t,b,l,r)
	local pd=Instance.new("UIPadding")
	pd.PaddingTop=UDim.new(0,t or 6); pd.PaddingBottom=UDim.new(0,b or 6)
	pd.PaddingLeft=UDim.new(0,l or 6); pd.PaddingRight=UDim.new(0,r or 6)
	pd.Parent=p; return pd
end

-- قسم فاصل مع خط متوهج
local function SecHdr(p,txt,ord)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,24); f.BackgroundTransparency=1; f.LayoutOrder=ord or 0; f.Parent=p
	local line=Instance.new("Frame")
	line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,1,-1)
	line.BackgroundColor3=C.Acc; line.BackgroundTransparency=0.6; line.BorderSizePixel=0; line.Parent=f
	Grad(line,C.Acc,Color3.fromRGB(7,8,21),0)
	local lbl=Instance.new("TextLabel")
	lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
	lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
	lbl.Text="▸  "..txt:upper(); lbl.TextColor3=C.Acc
	lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
	return f,lbl
end

-- رأس الصفحة
local function PgHdr(p,tk,sk,ord)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,56); f.BackgroundColor3=C.Card
	f.LayoutOrder=ord or 0; f.Parent=p; Cor(f,12); Str(f,C.Acc,1)
	Grad(f,Color3.fromRGB(26,10,72),Color3.fromRGB(7,20,65),140)
	local shimmer=Instance.new("Frame")
	shimmer.Size=UDim2.new(0,0,0,2); shimmer.BackgroundColor3=C.AccC
	shimmer.BackgroundTransparency=0.4; shimmer.BorderSizePixel=0; shimmer.Parent=f; Cor(shimmer,1)
	task.spawn(function()
		while f.Parent do
			Tw(shimmer,{Size=UDim2.new(1,0,0,2)},.7,Enum.EasingStyle.Sine)
			task.wait(.8); shimmer.Size=UDim2.new(0,0,0,2); task.wait(.4)
		end
	end)
	local t=Instance.new("TextLabel")
	t.Position=UDim2.new(0,14,0,10); t.Size=UDim2.new(.88,0,0,22)
	t.BackgroundTransparency=1; t.Font=Enum.Font.GothamBold
	t.Text=T(tk); t.TextColor3=C.W; t.TextSize=IsMobile and 15 or 14
	t.TextXAlignment=Enum.TextXAlignment.Left; t.Parent=f
	local s=Instance.new("TextLabel")
	s.Position=UDim2.new(0,14,0,33); s.Size=UDim2.new(.88,0,0,14)
	s.BackgroundTransparency=1; s.Font=Enum.Font.Gotham
	s.Text=T(sk); s.TextColor3=C.Sub; s.TextSize=10
	s.TextXAlignment=Enum.TextXAlignment.Left; s.Parent=f
	return f,t,s
end

-- زر
local function Btn(p,txt,col,ord,cb,rawTxt)
	col=col or C.Acc
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,0,0,BH); b.BackgroundColor3=col
	b.Font=Enum.Font.GothamBold; b.Text=rawTxt and txt or T(txt)
	b.TextColor3=C.W; b.TextSize=FS; b.AutoButtonColor=false
	b.LayoutOrder=ord or 0; b.Parent=p; Cor(b,8)
	local gs=Str(b,col,0)
	b.MouseEnter:Connect(function() Tw(b,{BackgroundColor3=col:Lerp(C.W,.18)},.12); Tw(gs,{Thickness=2},.12) end)
	b.MouseLeave:Connect(function() Tw(b,{BackgroundColor3=col},.12); Tw(gs,{Thickness=0},.12) end)
	local function fire() Tw(b,{Size=UDim2.new(.96,0,0,BH-3)},.07); task.delay(.07,function()Tw(b,{Size=UDim2.new(1,0,0,BH)},.1)end); if cb then cb() end end
	b.MouseButton1Click:Connect(fire); b.TouchTap:Connect(fire)
	return b
end

-- تبديل Toggle
local TogRefs={}
local function Tog(p,tk,state,ord,cb)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,TGH); f.BackgroundColor3=C.Card
	f.LayoutOrder=ord or 0; f.Parent=p; Cor(f,8); Str(f,C.Acc,1)
	local lbl=Instance.new("TextLabel")
	lbl.Position=UDim2.new(0,12,0,0); lbl.Size=UDim2.new(1,-60,1,0)
	lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.Gotham
	lbl.Text=T(tk); lbl.TextColor3=C.Txt; lbl.TextSize=FS
	lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
	local trk=Instance.new("Frame")
	trk.Position=UDim2.new(1,-52,0.5,-12); trk.Size=UDim2.new(0,44,0,24)
	trk.BackgroundColor3=state and C.TOn or C.TOff; trk.Parent=f; Cor(trk,12)
	local knob=Instance.new("Frame")
	knob.Position=state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
	knob.Size=UDim2.new(0,20,0,20); knob.BackgroundColor3=C.W; knob.Parent=trk; Cor(knob,10)
	local cur=state or false
	local function SetS(v)
		cur=v
		Tw(trk,{BackgroundColor3=v and C.TOn or C.TOff},.18)
		Tw(knob,{Position=v and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)},.18)
	end
	local hb=Instance.new("TextButton")
	hb.Size=UDim2.fromScale(1,1); hb.BackgroundTransparency=1; hb.Text=""; hb.Parent=f
	local function fire() SetS(not cur); if cb then cb(cur) end end
	hb.MouseButton1Click:Connect(fire); hb.TouchTap:Connect(fire)
	table.insert(TogRefs,{f=f,lbl=lbl,key=tk,set=SetS})
	return f,SetS,lbl
end

-- سلايدر
local function Sldr(p,tk,mn,mx,val,ord,cb)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,SLH); f.BackgroundColor3=C.Card
	f.LayoutOrder=ord or 0; f.Parent=p; Cor(f,8); Str(f,C.Acc,1)
	local lbl=Instance.new("TextLabel")
	lbl.Position=UDim2.new(0,12,0,7); lbl.Size=UDim2.new(.62,0,0,18)
	lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.Gotham
	lbl.Text=T(tk); lbl.TextColor3=C.Txt; lbl.TextSize=FS
	lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
	local vl=Instance.new("TextLabel")
	vl.Position=UDim2.new(.62,0,0,7); vl.Size=UDim2.new(.35,0,0,18)
	vl.BackgroundTransparency=1; vl.Font=Enum.Font.GothamBold
	vl.Text=tostring(val); vl.TextColor3=C.Acc; vl.TextSize=FS
	vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=f
	local trk=Instance.new("Frame")
	trk.Position=UDim2.new(0,12,0,SLH-20); trk.Size=UDim2.new(1,-24,0,7)
	trk.BackgroundColor3=C.Side; trk.Parent=f; Cor(trk,4)
	local fill=Instance.new("Frame")
	fill.Size=UDim2.new((val-mn)/(mx-mn),0,1,0)
	fill.BackgroundColor3=C.Acc; fill.Parent=trk; Cor(fill,4)
	Grad(fill,C.AccB,C.AccC,0)
	local knob=Instance.new("Frame")
	knob.AnchorPoint=Vector2.new(.5,.5)
	knob.Position=UDim2.new((val-mn)/(mx-mn),0,.5,0)
	knob.Size=UDim2.new(0,IsMobile and 22 or 15,0,IsMobile and 22 or 15)
	knob.BackgroundColor3=C.W; knob.Parent=trk; Cor(knob,11); Str(knob,C.Acc,1.5)
	local drag=false
	local function Upd(x)
		local a=trk.AbsolutePosition.X; local w=trk.AbsoluteSize.X
		local pct=math.clamp((x-a)/w,0,1)
		local v=math.floor(mn+pct*(mx-mn))
		Tw(fill,{Size=UDim2.new(pct,0,1,0)},.05)
		Tw(knob,{Position=UDim2.new(pct,0,.5,0)},.05)
		vl.Text=tostring(v); if cb then cb(v) end
	end
	trk.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			drag=true; Upd(i.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			Upd(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
	end)
	return f,lbl
end

-- حقل نص
local function Inp(p,phk,ord,rawPh)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,INH); f.BackgroundColor3=C.Card
	f.LayoutOrder=ord or 0; f.Parent=p; Cor(f,8); Str(f,C.Acc,1)
	local tb=Instance.new("TextBox")
	tb.Size=UDim2.new(1,-20,1,0); tb.Position=UDim2.new(0,10,0,0)
	tb.BackgroundTransparency=1; tb.Font=Enum.Font.Gotham
	tb.PlaceholderText=rawPh and phk or T(phk)
	tb.Text=""; tb.TextColor3=C.Txt; tb.PlaceholderColor3=C.Sub
	tb.TextSize=FS; tb.TextXAlignment=Enum.TextXAlignment.Left
	tb.ClearTextOnFocus=false; tb.Parent=f
	return f,tb
end

-- ============================================================
-- هيكل اللوحة
-- ============================================================

-- زر الفتح العائم
local FB=Instance.new("TextButton")
FB.Size=UDim2.new(0,IsMobile and 54 or 46,0,IsMobile and 54 or 46)
FB.Position=UDim2.new(0,10,0.5,-27)
FB.BackgroundColor3=C.Acc; FB.Text="⚡"; FB.Font=Enum.Font.GothamBold
FB.TextSize=IsMobile and 22 or 19; FB.TextColor3=C.W
FB.AutoButtonColor=false; FB.ZIndex=10; FB.Parent=SG
Cor(FB,IsMobile and 27 or 23); Str(FB,C.AccB,2)
-- نبضة متوهجة
local FBG=Str(FB,C.AccC,0)
task.spawn(function()
	while FB.Parent do
		Tw(FBG,{Thickness=3.5},.85); task.wait(.9)
		Tw(FBG,{Thickness=0},.85); task.wait(.9)
	end
end)
-- سحب الزر العائم
local fbD,fbS,fbP=false,nil,nil
FB.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		fbD=true; fbS=i.Position; fbP=FB.Position
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if fbD and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-fbS
		FB.Position=UDim2.new(0,fbP.X.Offset+d.X,0,fbP.Y.Offset+d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fbD=false end
end)

-- اللوحة الرئيسية
local MP=Instance.new("Frame")
MP.Name="MainPanel"; MP.Size=UDim2.new(0,PW,0,PH)
MP.Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)
MP.BackgroundColor3=C.Panel; MP.ZIndex=5; MP.Parent=SG
Cor(MP,14); Str(MP,C.Acc,1.5)
Grad(MP,Color3.fromRGB(9,10,27),Color3.fromRGB(6,7,19),150)

-- سحب اللوحة
local pD,pS,pP=false,nil,nil
local DragArea=Instance.new("TextButton")
DragArea.Size=UDim2.new(1,-36,0,34); DragArea.BackgroundTransparency=1
DragArea.Text=""; DragArea.ZIndex=20; DragArea.Parent=MP
DragArea.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		pD=true; pS=i.Position; pP=MP.Position
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if pD and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-pS
		MP.Position=UDim2.new(pP.X.Scale,pP.X.Offset+d.X,pP.Y.Scale,pP.Y.Offset+d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pD=false end
end)

-- شريط العنوان
local TopBar=Instance.new("Frame")
TopBar.Size=UDim2.new(1,0,0,36); TopBar.BackgroundColor3=C.Side
TopBar.Parent=MP; Cor(TopBar,14)
Grad(TopBar,Color3.fromRGB(18,7,58),Color3.fromRGB(7,14,54),95)
local TopFix=Instance.new("Frame")
TopFix.Size=UDim2.new(1,0,0,16); TopFix.Position=UDim2.new(0,0,1,-16)
TopFix.BackgroundColor3=C.Side; TopFix.BorderSizePixel=0; TopFix.Parent=TopBar

local TitleL=Instance.new("TextLabel")
TitleL.Size=UDim2.new(1,-80,1,0); TitleL.Position=UDim2.new(0,14,0,0)
TitleL.BackgroundTransparency=1; TitleL.Font=Enum.Font.GothamBold
TitleL.Text=T("PanelTitle"); TitleL.TextColor3=C.W; TitleL.TextSize=13
TitleL.TextXAlignment=Enum.TextXAlignment.Left; TitleL.Parent=TopBar

local BadgeL=Instance.new("TextLabel")
BadgeL.Size=UDim2.new(0,32,0,15); BadgeL.Position=UDim2.new(1,-72,0.5,-7)
BadgeL.BackgroundColor3=C.Acc; BadgeL.Font=Enum.Font.GothamBold
BadgeL.Text="v2.0"; BadgeL.TextColor3=C.W; BadgeL.TextSize=9; BadgeL.Parent=TopBar; Cor(BadgeL,4)

local XBtn=Instance.new("TextButton")
XBtn.Size=UDim2.new(0,27,0,27); XBtn.Position=UDim2.new(1,-33,0.5,-13)
XBtn.BackgroundColor3=C.Err; XBtn.Font=Enum.Font.GothamBold
XBtn.Text="✕"; XBtn.TextColor3=C.W; XBtn.TextSize=13
XBtn.AutoButtonColor=false; XBtn.ZIndex=25; XBtn.Parent=TopBar; Cor(XBtn,6)
XBtn.MouseButton1Click:Connect(function()
	Tw(MP,{Position=UDim2.new(0.5,-PW/2,1.5,0)},.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	task.delay(.35,function() MP.Visible=false end)
end)

FB.MouseButton1Click:Connect(function()
	if not fbD then
		MP.Visible=true
		MP.Position=UDim2.new(0.5,-PW/2,1.5,0)
		Tw(MP,{Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)},.4,Enum.EasingStyle.Back)
	end
end)

-- الجسم
local Body=Instance.new("Frame")
Body.Size=UDim2.new(1,0,1,-36); Body.Position=UDim2.new(0,0,0,36)
Body.BackgroundTransparency=1; Body.Parent=MP

-- شريط جانبي
local Side=Instance.new("ScrollingFrame")
Side.Size=UDim2.new(0,SW,1,0); Side.BackgroundColor3=C.Side
Side.BorderSizePixel=0; Side.ScrollBarThickness=0
Side.CanvasSize=UDim2.new(0,0,0,0); Side.AutomaticCanvasSize=Enum.AutomaticSize.Y
Side.Parent=Body
local SBLine=Instance.new("Frame")
SBLine.Size=UDim2.new(0,1,1,0); SBLine.Position=UDim2.new(1,-1,0,0)
SBLine.BackgroundColor3=C.Acc; SBLine.BackgroundTransparency=0.65
SBLine.BorderSizePixel=0; SBLine.Parent=Side
LL(Side,3); Pd(Side,8,8,3,3)

-- منطقة المحتوى
local CA=Instance.new("Frame")
CA.Size=UDim2.new(1,-SW,1,0); CA.Position=UDim2.new(0,SW,0,0)
CA.BackgroundTransparency=1; CA.Parent=Body

-- صانع الصفحات
local Pages={}
local function MkPage(n)
	local sf=Instance.new("ScrollingFrame")
	sf.Name=n; sf.Size=UDim2.fromScale(1,1)
	sf.BackgroundTransparency=1; sf.BorderSizePixel=0
	sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=C.Acc
	sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
	sf.Visible=false; sf.Parent=CA
	LL(sf,6); Pd(sf,8,18,8,8)
	Pages[n]=sf; return sf
end

local PHome = MkPage("Home")
local PMove = MkPage("Move")
local PCp   = MkPage("Cp")
local PPl   = MkPage("Pl")
local PEsp  = MkPage("Esp")
local PExt  = MkPage("Ext")
local PTime = MkPage("Time")
local PSet  = MkPage("Set")

local function ShowPage(n)
	local prev=Cfg.Page
	if Pages[prev] then Tw(Pages[prev],{GroupTransparency=1},.1) end
	task.wait(.08)
	for k,pg in pairs(Pages) do pg.Visible=(k==n) end
	Cfg.Page=n
	if Pages[n] then Pages[n].GroupTransparency=1; Tw(Pages[n],{GroupTransparency=0},.18) end
end

-- ============================================================
-- ناف سيدبار
-- ============================================================
local NavDefs={
	{icon="🏠",key="Home",  page="Home"},
	{icon="✈", key="Movement",page="Move"},
	{icon="📍",key="Checkpoints",page="Cp"},
	{icon="👥",key="Players",page="Pl"},
	{icon="👁", key="Radar", page="Esp"},
	{icon="✨",key="Extras", page="Ext"},
	{icon="⏱", key="Time",  page="Time"},
	{icon="⚙", key="Settings",page="Set"},
}
local NavBtns={}
for _,d in ipairs(NavDefs) do
	local btn=Instance.new("TextButton")
	btn.Size=UDim2.new(1,-6,0,IsMobile and 56 or 48)
	btn.BackgroundTransparency=1; btn.AutoButtonColor=false; btn.Text=""; btn.Parent=Side; Cor(btn,8)
	local hl=Instance.new("Frame")
	hl.Size=UDim2.new(0,3,0.65,0); hl.AnchorPoint=Vector2.new(0,.5)
	hl.Position=UDim2.new(0,0,.5,0); hl.BackgroundColor3=C.Acc
	hl.BackgroundTransparency=1; hl.BorderSizePixel=0; hl.Parent=btn; Cor(hl,2)
	local ic=Instance.new("TextLabel")
	ic.Size=UDim2.new(1,0,0,IsMobile and 22 or 18)
	ic.Position=UDim2.new(0,0,0,IsMobile and 7 or 5)
	ic.BackgroundTransparency=1; ic.Font=Enum.Font.GothamBold
	ic.Text=d.icon; ic.TextSize=IsMobile and 17 or 15; ic.TextColor3=C.Sub; ic.Parent=btn
	local tx=Instance.new("TextLabel")
	tx.Size=UDim2.new(1,-4,0,13); tx.Position=UDim2.new(0,2,0,IsMobile and 30 or 24)
	tx.BackgroundTransparency=1; tx.Font=Enum.Font.Gotham
	tx.Text=T(d.key):gsub("[🏠✈📍👥👁✨⏱⚙] ","")
	tx.TextSize=8; tx.TextColor3=C.Sub; tx.TextWrapped=true; tx.Parent=btn
	local function SetAct(on)
		if on then
			Tw(btn,{BackgroundTransparency=0.82},.18); btn.BackgroundColor3=C.Acc
			Tw(ic,{TextColor3=C.W},.18); Tw(tx,{TextColor3=C.Acc},.18)
			Tw(hl,{BackgroundTransparency=0},.18)
		else
			Tw(btn,{BackgroundTransparency=1},.18)
			Tw(ic,{TextColor3=C.Sub},.18); Tw(tx,{TextColor3=C.Sub},.18)
			Tw(hl,{BackgroundTransparency=1},.18)
		end
	end
	table.insert(NavBtns,{btn=btn,ic=ic,tx=tx,hl=hl,page=d.page,key=d.key,SetAct=SetAct})
	btn.MouseButton1Click:Connect(function()
		for _,nb in ipairs(NavBtns) do nb.SetAct(nb.page==d.page) end
		ShowPage(d.page)
	end)
end

-- ============================================================
-- صفحة الرئيسية
-- ============================================================
local heroF=Instance.new("Frame")
heroF.Size=UDim2.new(1,0,0,96); heroF.BackgroundColor3=C.Card
heroF.LayoutOrder=1; heroF.Parent=PHome; Cor(heroF,12); Str(heroF,C.Acc,1.5)
Grad(heroF,Color3.fromRGB(24,8,72),Color3.fromRGB(5,18,65),140)
local hShim=Instance.new("Frame")
hShim.Size=UDim2.new(0,0,0,2); hShim.BackgroundColor3=C.AccC
hShim.BackgroundTransparency=0.3; hShim.BorderSizePixel=0; hShim.Parent=heroF; Cor(hShim,1)
task.spawn(function()
	while heroF.Parent do
		Tw(hShim,{Size=UDim2.new(1,0,0,2)},.75,Enum.EasingStyle.Sine)
		task.wait(.85); hShim.Size=UDim2.new(0,0,0,2); task.wait(.35)
	end
end)
local hT=Instance.new("TextLabel")
hT.Position=UDim2.new(0,14,0,12); hT.Size=UDim2.new(.9,0,0,26)
hT.BackgroundTransparency=1; hT.Font=Enum.Font.GothamBold
hT.Text="⚡ THAER X100  |  Admin Panel"; hT.TextColor3=C.W
hT.TextSize=IsMobile and 14 or 13; hT.TextXAlignment=Enum.TextXAlignment.Left; hT.Parent=heroF

local hS=Instance.new("TextLabel")
hS.Position=UDim2.new(0,14,0,40); hS.Size=UDim2.new(.9,0,0,22)
hS.BackgroundTransparency=1; hS.Font=Enum.Font.Gotham
hS.Text=T("WelcomeMsg"); hS.TextColor3=C.Sub; hS.TextSize=10
hS.TextXAlignment=Enum.TextXAlignment.Left; hS.TextWrapped=true; hS.Parent=heroF

local hP=Instance.new("TextLabel")
hP.Position=UDim2.new(0,14,0,66); hP.Size=UDim2.new(.9,0,0,16)
hP.BackgroundTransparency=1; hP.Font=Enum.Font.GothamBold
hP.Text="👤 "..LocalPlayer.Name; hP.TextColor3=C.AccB; hP.TextSize=9
hP.TextXAlignment=Enum.TextXAlignment.Left; hP.Parent=heroF

-- شبكة الحالة
local statF=Instance.new("Frame")
statF.Size=UDim2.new(1,0,0,68); statF.BackgroundColor3=C.Card
statF.LayoutOrder=2; statF.Parent=PHome; Cor(statF,10); Str(statF,C.AccB,1)
local stHL=Instance.new("UIListLayout")
stHL.FillDirection=Enum.FillDirection.Horizontal
stHL.HorizontalAlignment=Enum.HorizontalAlignment.Center
stHL.VerticalAlignment=Enum.VerticalAlignment.Center
stHL.Padding=UDim.new(0,0); stHL.Parent=statF

local StatDefs={
	{k="FlyOn", lk="FlyOn", get=function()return Cfg.FlyOn end},
	{k="NcOn",  lk="NcOn",  get=function()return Cfg.NcOn end},
	{k="ESPOn", lk="ESPOn", get=function()return Cfg.ESPOn end},
	{k="InvisOn",lk="InvOn",get=function()return Cfg.InvisOn end},
	{k="TimeOn",lk="TimeOn",get=function()return Cfg.TimeOn end},
	{k="AFK",   lk="AtkOn", get=function()return Cfg.AntiAFK end},
}
local StatVLbls={}
for _,sd in ipairs(StatDefs) do
	local col=Instance.new("Frame")
	col.Size=UDim2.new(1/#StatDefs,0,1,0); col.BackgroundTransparency=1; col.Parent=statF
	local dot=Instance.new("Frame")
	dot.Size=UDim2.new(0,7,0,7); dot.AnchorPoint=Vector2.new(.5,0)
	dot.Position=UDim2.new(.5,0,0,8); dot.BackgroundColor3=C.Sub
	dot.BorderSizePixel=0; dot.Parent=col; Cor(dot,4)
	local vl=Instance.new("TextLabel")
	vl.Size=UDim2.new(1,0,0,18); vl.Position=UDim2.new(0,0,0,18)
	vl.BackgroundTransparency=1; vl.Font=Enum.Font.GothamBold
	vl.Text="OFF"; vl.TextColor3=C.Sub; vl.TextSize=10; vl.Parent=col
	local ll=Instance.new("TextLabel")
	ll.Size=UDim2.new(1,0,0,14); ll.Position=UDim2.new(0,0,0,38)
	ll.BackgroundTransparency=1; ll.Font=Enum.Font.Gotham
	ll.Text=T(sd.lk); ll.TextColor3=C.Sub; ll.TextSize=8; ll.Parent=col
	table.insert(StatVLbls,{vl=vl,ll=ll,dot=dot,sd=sd})
end
RunService.Heartbeat:Connect(function()
	for _,sv in pairs(StatVLbls) do
		local on=sv.sd.get()
		sv.vl.Text=on and "ON" or "OFF"; sv.vl.TextColor3=on and C.OK or C.Sub
		sv.dot.BackgroundColor3=on and C.OK or C.Sub; sv.ll.Text=T(sv.sd.lk)
	end
end)

-- ============================================================
-- صفحة الحركة
-- ============================================================
local mH,mHT,mHS = PgHdr(PMove,"MovTitle","MovSub",1)
SecHdr(PMove,T("FlySection"),2)
local _,flySet,flyLbl = Tog(PMove,"FlyToggle",false,3,function(v)
	if v then StartFly() else StopFly() end
end)
local fslF,fslL = Sldr(PMove,"FlySpeed",5,300,Cfg.FlySpeed,4,function(v) Cfg.FlySpeed=v end)
SecHdr(PMove,T("CharSection"),5)
local _,ncSet,ncLbl = Tog(PMove,"NoClip",false,6,function(v)
	if v then StartNc() else StopNc() end
end)
local wslF,wslL = Sldr(PMove,"WalkSpeed",1,300,Cfg.WalkSpeed,7,function(v)
	Cfg.WalkSpeed=v; local h=Hum(); if h then h.WalkSpeed=v end
end)
local jslF,jslL = Sldr(PMove,"JumpPower",1,300,Cfg.JumpPower,8,function(v)
	Cfg.JumpPower=v; local h=Hum(); if h then h.JumpPower=v end
end)
Btn(PMove,"ResetChar",C.Err,9,function() local h=Hum(); if h then h.Health=0 end end)

-- ============================================================
-- صفحة نقاط الحفظ
-- ============================================================
PgHdr(PCp,"CpTitle","CpSub",1)
local cpSB,cpLB={},{}
for i=1,3 do
	SecHdr(PCp,T("Slot").." "..i,(i-1)*3+2)
	local row=Instance.new("Frame")
	row.Size=UDim2.new(1,0,0,BH); row.BackgroundTransparency=1
	row.LayoutOrder=(i-1)*3+3; row.Parent=PCp
	LL(row,6,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Center)
	local sb=Instance.new("TextButton")
	sb.Size=UDim2.new(0.48,0,0,BH); sb.BackgroundColor3=C.AccB
	sb.Font=Enum.Font.GothamBold; sb.Text=T("Save"); sb.TextColor3=C.W
	sb.TextSize=FS; sb.AutoButtonColor=false; sb.Parent=row; Cor(sb,8)
	local lb=Instance.new("TextButton")
	lb.Size=UDim2.new(0.48,0,0,BH); lb.BackgroundColor3=C.Acc
	lb.Font=Enum.Font.GothamBold; lb.Text=T("Teleport"); lb.TextColor3=C.W
	lb.TextSize=FS; lb.AutoButtonColor=false; lb.Parent=row; Cor(lb,8)
	table.insert(cpSB,sb); table.insert(cpLB,lb)
	local sl=i
	sb.MouseButton1Click:Connect(function()
		SaveCP(sl); Tw(sb,{BackgroundColor3=C.OK},.15)
		task.delay(.6,function()Tw(sb,{BackgroundColor3=C.AccB},.3)end)
	end)
	lb.MouseButton1Click:Connect(function() LoadCP(sl) end)
end

-- ============================================================
-- صفحة اللاعبين
-- ============================================================
PgHdr(PPl,"PlTitle","PlSub",1)
SecHdr(PPl,T("TargetSec"),2)
local _,plTB = Inp(PPl,"PlHint",3)
Btn(PPl,"TpTo",C.Acc,4,function()
	local t=FindPlayer(plTB.Text); if t then TpTo(t) end
end)
Btn(PPl,"Follow",C.AccB,5,function()
	local t=FindPlayer(plTB.Text); if t then StartFollow(t) else StopFollow() end
end)
Btn(PPl,"Spectate",Color3.fromRGB(30,150,100),6,function()
	local t=FindPlayer(plTB.Text); if t then StartSpec(t) else StopSpec() end
end)
Btn(PPl,"CopyOutfit",Color3.fromRGB(145,75,215),7,function()
	local n=SelPlayer~="" and SelPlayer or plTB.Text; CopyOutfit(n)
end)
Btn(PPl,"StopAll",Color3.fromRGB(75,75,110),8,function() StopFollow(); StopSpec() end)
Btn(PPl,"BringAll",C.Err,9,function() BringAll() end)

SecHdr(PPl,T("PlList"),10)
local plFr=Instance.new("Frame")
plFr.Size=UDim2.new(1,0,0,115); plFr.BackgroundColor3=C.Card
plFr.LayoutOrder=11; plFr.Parent=PPl; Cor(plFr,8); Str(plFr,C.Acc,1)
local plSF=Instance.new("ScrollingFrame")
plSF.Size=UDim2.fromScale(1,1); plSF.BackgroundTransparency=1
plSF.ScrollBarThickness=3; plSF.ScrollBarImageColor3=C.Acc
plSF.CanvasSize=UDim2.new(0,0,0,0); plSF.AutomaticCanvasSize=Enum.AutomaticSize.Y
plSF.Parent=plFr; LL(plSF,3); Pd(plSF,5,5,6,6)

local function RefPL()
	for _,c in pairs(plSF:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
	for _,p in pairs(Players:GetPlayers()) do
		local r=Instance.new("TextButton")
		r.Size=UDim2.new(1,0,0,IsMobile and 34 or 27)
		r.BackgroundColor3=C.Side; r.Font=Enum.Font.Gotham
		r.Text=(p==LocalPlayer and "⭐ " or "")..p.Name
		r.TextColor3=p==LocalPlayer and C.Acc or C.Txt
		r.TextSize=11; r.TextXAlignment=Enum.TextXAlignment.Left
		Cor(r,5); Pd(r,0,0,8,8); r.Parent=plSF
		r.MouseButton1Click:Connect(function()
			plTB.Text=p.Name; SelPlayer=p.Name
			Tw(r,{BackgroundColor3=C.Card},.1)
			task.delay(.3,function()Tw(r,{BackgroundColor3=C.Side},.2)end)
		end)
	end
end
RefPL()
Players.PlayerAdded:Connect(RefPL)
Players.PlayerRemoving:Connect(function() task.wait(.1); RefPL() end)

-- ============================================================
-- صفحة الرادار والموسيقى
-- ============================================================
PgHdr(PEsp,"RadTitle","RadSub",1)
local _,espSet,espLbl = Tog(PEsp,"ESPToggle",false,3,function(v) ToggleESP(v) end)
local espIL=Instance.new("TextLabel")
espIL.Size=UDim2.new(1,0,0,28); espIL.BackgroundTransparency=1
espIL.Font=Enum.Font.Gotham; espIL.Text=T("ESPInfo")
espIL.TextColor3=C.Sub; espIL.TextSize=10; espIL.TextWrapped=true
espIL.LayoutOrder=4; espIL.Parent=PEsp
SecHdr(PEsp,T("MusicSec"),5)
local _,mInTB = Inp(PEsp,"SoundHint",6)
local volF,volL = Sldr(PEsp,"Volume",0,100,math.floor(Cfg.MusicVol*100),7,function(v)
	Cfg.MusicVol=v/100; if ActiveMusic then ActiveMusic.Volume=Cfg.MusicVol end
end)
Btn(PEsp,"PlayMusic",C.OK,8,function()
	local id=tonumber(mInTB.Text); if id then PlayMusic(id,Cfg.MusicVol) end
end)
Btn(PEsp,"StopMusic",C.Err,9,function() StopMus() end)

-- ============================================================
-- صفحة الإضافات
-- ============================================================
PgHdr(PExt,"ExtTitle","ExtSub",1)
SecHdr(PExt,T("InvisSec"),2)
local _,invisSet,invisLbl = Tog(PExt,"InvisToggle",false,3,function(v) SetInvis(v) end)
local invIL=Instance.new("TextLabel")
invIL.Size=UDim2.new(1,0,0,34); invIL.BackgroundTransparency=1
invIL.Font=Enum.Font.Gotham; invIL.Text=T("InvisInfo")
invIL.TextColor3=C.Sub; invIL.TextSize=10; invIL.TextWrapped=true
invIL.LayoutOrder=4; invIL.Parent=PExt
SecHdr(PExt,T("OutfitSec"),5)
local outIL=Instance.new("TextLabel")
outIL.Size=UDim2.new(1,0,0,30); outIL.BackgroundTransparency=1
outIL.Font=Enum.Font.Gotham; outIL.Text=T("OutfitInfo")
outIL.TextColor3=C.Sub; outIL.TextSize=10; outIL.TextWrapped=true
outIL.LayoutOrder=6; outIL.Parent=PExt
local _,cpNameTB = Inp(PExt,"PlHint",7)
Btn(PExt,"CopyBtn",Color3.fromRGB(148,72,220),8,function()
	local n=cpNameTB.Text~="" and cpNameTB.Text or SelPlayer; CopyOutfit(n)
end)

-- ============================================================
-- صفحة الوقت
-- ============================================================
PgHdr(PTime,"TimeTitle","TimeSub",1)
SecHdr(PTime,T("LocalTimeSec"),2)
local _,timeTogSet,timeLbl = Tog(PTime,"TimeToggle",false,3,function(v)
	if v then StartTime(Cfg.TimeSpeed) else StopTime() end
end)
local tslF,tslL = Sldr(PTime,"TimeSpeed",1,30,Cfg.TimeSpeed,4,function(v)
	Cfg.TimeSpeed=v; if Cfg.TimeOn and not AuraActive then StartTime(v) end
end)

SecHdr(PTime,T("AuraSec"),5)
local auraIL=Instance.new("TextLabel")
auraIL.Size=UDim2.new(1,0,0,40); auraIL.BackgroundTransparency=1
auraIL.Font=Enum.Font.Gotham; auraIL.Text=T("AuraInfo")
auraIL.TextColor3=C.Sub; auraIL.TextSize=10; auraIL.TextWrapped=true
auraIL.LayoutOrder=6; auraIL.Parent=PTime

local _,aZNameTB = Inp(PTime,"AuraHint",7,true)
aZNameTB.Text="AuraZone"

-- مؤشر حالة الأورا
local auraStF=Instance.new("Frame")
auraStF.Size=UDim2.new(1,0,0,40); auraStF.BackgroundColor3=C.Card
auraStF.LayoutOrder=8; auraStF.Parent=PTime; Cor(auraStF,8); Str(auraStF,C.Acc,1)
local pulseDot=Instance.new("Frame")
pulseDot.Size=UDim2.new(0,10,0,10); pulseDot.AnchorPoint=Vector2.new(.5,.5)
pulseDot.Position=UDim2.new(0,22,0.5,0); pulseDot.BackgroundColor3=C.Sub
pulseDot.BorderSizePixel=0; pulseDot.Parent=auraStF; Cor(pulseDot,5)
AuraLabelRef=Instance.new("TextLabel")
AuraLabelRef.Size=UDim2.new(1,-40,1,0); AuraLabelRef.Position=UDim2.new(0,36,0,0)
AuraLabelRef.BackgroundTransparency=1; AuraLabelRef.Font=Enum.Font.GothamBold
AuraLabelRef.Text=T("AuraOff"); AuraLabelRef.TextColor3=C.Sub
AuraLabelRef.TextSize=12; AuraLabelRef.TextXAlignment=Enum.TextXAlignment.Left
AuraLabelRef.Parent=auraStF

-- نبضة نقطة الأورا
RunService.Heartbeat:Connect(function()
	if AuraActive then
		pulseDot.BackgroundColor3=C.Warn
	else
		pulseDot.BackgroundColor3=C.Sub
	end
end)

local _,auraTogSet,auraTogLbl = Tog(PTime,"AuraToggle",false,9,function(v)
	if v then StartAura(aZNameTB.Text) else StopAura() end
end)

-- ============================================================
-- صفحة الإعدادات
-- ============================================================
PgHdr(PSet,"SetTitle","SetSub",1)
SecHdr(PSet,T("GeneralSec"),2)
local _,afkSet,afkLbl = Tog(PSet,"AntiAFK",Cfg.AntiAFK,3,function(v) Cfg.AntiAFK=v end)
SecHdr(PSet,T("DataSec"),4)
Btn(PSet,"SaveSet",C.Acc,5,function() SaveCfg() end)
Btn(PSet,"ResetDef",C.Err,6,function()
	Cfg.FlySpeed=50; Cfg.WalkSpeed=16; Cfg.JumpPower=50; Cfg.MusicVol=0.5
end)
SecHdr(PSet,T("UISec"),7)
Btn(PSet,"HidePanel",Color3.fromRGB(52,52,78),8,function()
	Tw(MP,{Position=UDim2.new(0.5,-PW/2,1.5,0)},.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	task.delay(.35,function()MP.Visible=false end)
end)
SecHdr(PSet,T("LangSec"),9)
local langB=Btn(PSet,"LangBtn",Color3.fromRGB(32,78,160),10,nil,true)
langB.Text=T("LangBtn")
local verL=Instance.new("TextLabel")
verL.Size=UDim2.new(1,0,0,20); verL.BackgroundTransparency=1
verL.Font=Enum.Font.Gotham; verL.Text=T("Version")
verL.TextColor3=C.Sub; verL.TextSize=9; verL.LayoutOrder=11; verL.Parent=PSet

-- ============================================================
-- تغيير اللغة
-- ============================================================
local function RefreshLang()
	TitleL.Text=T("PanelTitle")
	hS.Text=T("WelcomeMsg")
	for _,nb in ipairs(NavBtns) do
		nb.tx.Text=T(nb.key):gsub("[🏠✈📍👥👁✨⏱⚙%s]","")
	end
	for _,sv in pairs(StatVLbls) do sv.ll.Text=T(sv.sd.lk) end
	mHT.Text=T("MovTitle"); mHS.Text=T("MovSub")
	if flyLbl  then flyLbl.Text=T("FlyToggle") end
	if fslL    then fslL.Text=T("FlySpeed") end
	if ncLbl   then ncLbl.Text=T("NoClip") end
	if wslL    then wslL.Text=T("WalkSpeed") end
	if jslL    then jslL.Text=T("JumpPower") end
	if espLbl  then espLbl.Text=T("ESPToggle") end
	espIL.Text=T("ESPInfo")
	if volL    then volL.Text=T("Volume") end
	if invisLbl then invisLbl.Text=T("InvisToggle") end
	invIL.Text=T("InvisInfo"); outIL.Text=T("OutfitInfo")
	if timeLbl  then timeLbl.Text=T("TimeToggle") end
	if tslL     then tslL.Text=T("TimeSpeed") end
	auraIL.Text=T("AuraInfo")
	if auraTogLbl then auraTogLbl.Text=T("AuraToggle") end
	if afkLbl   then afkLbl.Text=T("AntiAFK") end
	langB.Text=T("LangBtn"); verL.Text=T("Version")
	if not AuraActive then AuraLabelRef.Text=T("AuraOff") end
end

langB.MouseButton1Click:Connect(function()
	Lang = Lang=="AR" and "EN" or "AR"
	RefreshLang()
	Tw(langB,{Size=UDim2.new(.96,0,0,BH-3)},.07)
	task.delay(.07,function()Tw(langB,{Size=UDim2.new(1,0,0,BH)},.1)end)
end)

-- ============================================================
-- تهيئة أولية
-- ============================================================
RefreshLang()
ShowPage("Home")
NavBtns[1].SetAct(true)
MP.Position=UDim2.new(0.5,-PW/2,1.5,0)
Tw(MP,{Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)},.45,Enum.EasingStyle.Back)

-- ============================================================
-- END  |  THAER X100 v2.0  |  Single LocalScript
-- ============================================================
