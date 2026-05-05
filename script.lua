-- ============================================================
--   THAER X100  |  v2.1  |  Professional Admin Panel
--   لوحة إدارة ماب "اختبار الهكر"
-- ============================================================
-- [[ تم التعديل والتحسين بواسطة Gemini Code Assist ]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- جلب الخدمات مع حماية (Safe Service Loading)
local function GetService(name)
    local ok, s = pcall(game.GetService, game, name)
    return ok and s or nil
end

local HttpService      = GetService("HttpService")
local SoundService     = GetService("SoundService")
local Workspace        = GetService("Workspace")
local Lighting         = GetService("Lighting")
local VirtualUser      = GetService("VirtualUser")
local TeleportService  = GetService("TeleportService")

local LP     = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local IsMob  = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================================
-- اللغة
-- ============================================================
local Lang = "AR"
local L = {
	AR={
		title="⚡ THAER X100",
		nav={[1]="🏠 رئيسية",[2]="✈ حركة",[3]="📍 حفظ",[4]="👥 لاعبين",[5]="👁 رادار",[6]="✨ إضافات",[7]="⏱ وقت",[8]="⚙ إعدادات"},
		welcome="مرحباً في لوحة تحكم ماب اختبار الهكر",
		movTitle="أدوات الحركة",movSub="طيران · اختراق · سرعة · قفز · عدم الموت",
		flySec="الطيران",flyTog="✈ وضع الطيران",flySpd="سرعة الطيران",
		charSec="الشخصية",ncTog="🧱 اختراق الجدران",walkSpd="سرعة المشي",jumpPow="قوة القفز",
		resetC="💀 إعادة تعيين",godTog="😇 وضع عدم الموت",infJump="🦘 قفز لا نهائي",
		cpTitle="نقاط الحفظ",cpSub="احفظ وانتقل للمواقع",slot="خانة",saveLbl="💾 حفظ",tpLbl="📍 انتقال",
		plTitle="اللاعبين",plSub="إدارة اللاعبين",targetSec="اللاعب المستهدف",plHint="اسم اللاعب...",
		tpTo="🔍 انتقال",follow="👣 تتبع",spec="🎥 مشاهدة",stopAll="⏹ إيقاف",
		copyOutfit="👕 نسخ المظهر",plList="قائمة اللاعبين",killAll="⚔ قتل الجميع",
		espTitle="الرادار والموسيقى",espSub="تراكب · موسيقى · ايمبوت",espTog="👁 رادار اللاعبين",
		espInfo="يعرض اسم كل لاعب ومسافته عنك.",musicSec="مشغل الموسيقى",
		aimTog="🎯 ايمبوت تلقائي",sndHint="معرف الصوت (أرقام)...",vol="الصوت",playM="▶ تشغيل",stopM="⏹ إيقاف",
		extTitle="إضافات",extSub="اختفاء · نسخ مظهر",invisSec="الاختفاء",
		outfitSec="نسخ المظهر",outfitInfo="اختر لاعباً ثم اضغط نسخ.",copyBtn="👕 نسخ مظهر اللاعب المختار",
		clickerSec="النقر التلقائي",clickerTog="🖱 تفعيل Auto Clicker",
		mouseTpInfo="اضغط مفتاح 'B' للانتقال لمكان الماوس",
		timeTitle="التحكم بالوقت",timeSub="تسريع الوقت · منطقة الأورا",
		timeSec="تسريع الوقت",timeTog="🌀 تسريع وقت السماء",timeSpd="سرعة الوقت",
		auraSec="منطقة الأورا ⚡",auraInfo="لما تدخل المنطقة يتسارع الوقت 10×.",
		auraHint="AuraZone",auraTog="⚡ تفعيل كشف الأورا",auraOff="⚡ الأورا: غير نشطة",auraOn="⚡ الأورا نشطة! ×10",
		setTitle="الإعدادات",setSub="إعدادات اللوحة",genSec="عام",afkTog="💤 مكافحة الخمول",
		dataSec="البيانات",saveCfg="💾 حفظ الإعدادات",resetDef="🔄 إعادة للافتراضي",
		uiSec="الواجهة",hidePanel="🙈 إخفاء اللوحة",langSec="اللغة",langBtn="🌐 English",
		ver="THAER X100  v2.0  |  للاستخدام الخاص",
		statF="طيران",statN="اختراق",statE="رادار",statI="اختفاء",statT="وقت",statA="خمول",
	},
	EN={
		title="⚡ THAER X100",
		nav={[1]="🏠 Home",[2]="✈ Move",[3]="📍 Saves",[4]="👥 Players",[5]="👁 Radar",[6]="✨ Extras",[7]="⏱ Time",[8]="⚙ Settings"},
		welcome="Welcome to the Hacker Test Map Admin Panel",
		movTitle="Movement Tools",movSub="Fly · NoClip · Speed · Jump · God",
		flySec="Flight",flyTog="✈ Fly Mode",flySpd="Fly Speed",
		charSec="Character",ncTog="🧱 NoClip",walkSpd="Walk Speed",jumpPow="Jump Power",
		resetC="💀 Reset Character",godTog="😇 God Mode",infJump="🦘 Infinite Jump",
		cpTitle="Checkpoints",cpSub="Save & teleport to positions",slot="Slot",saveLbl="💾 Save",tpLbl="📍 Teleport",
		plTitle="Players",plSub="Manage players",targetSec="Target Player",plHint="Player name...",
		tpTo="🔍 Teleport",follow="👣 Follow",spec="🎥 Spectate",stopAll="⏹ Stop All",
		copyOutfit="👕 Copy Outfit",plList="Player List",killAll="⚔ Kill All",
		espTitle="Radar & Music",espSub="Overlay · Music · Aimbot",espTog="👁 Player Radar",
		espInfo="Shows player names and distance.",musicSec="Music Player",
		aimTog="🎯 Auto Aimbot",sndHint="Sound ID (numbers)...",vol="Volume",playM="▶ Play",stopM="⏹ Stop",
		extTitle="Extras",extSub="Invisibility · Outfit",invisSec="Invisibility",
		outfitSec="Copy Outfit",outfitInfo="Select a player then press copy.",copyBtn="👕 Copy Selected Player's Outfit",
		clickerSec="Auto Clicker",clickerTog="🖱 Enable Auto Clicker",
		mouseTpInfo="Press 'B' key to teleport to mouse",
		timeTitle="Time Control",timeSub="Time Warp · Aura Zone",
		timeSec="Time Warp",timeTog="🌀 Speed Up Sky",timeSpd="Time Speed",
		auraSec="Aura Zone ⚡",auraInfo="Enter the zone to speed up time 10×.",
		auraHint="AuraZone",auraTog="⚡ Enable Aura Zone",auraOff="⚡ Aura: Inactive",auraOn="⚡ Aura Active! ×10",
		setTitle="Settings",setSub="Panel config",genSec="General",afkTog="💤 Anti-AFK",
		dataSec="Data",saveCfg="💾 Save Settings",resetDef="🔄 Reset Defaults",
		uiSec="Interface",hidePanel="🙈 Hide Panel",langSec="Language",langBtn="🌐 عربي",
		ver="THAER X100  v2.0  |  Authorized Use Only",
		statF="Fly",statN="NoClip",statE="ESP",statI="Invis",statT="Time",statA="AFK",
	},
}

-- دالة الترجمة المحسنة مع نظام البحث البديل (Improved Translation with Fallback)
local function T(k)
    local current = L[Lang][k]
    if current then return current end
    local alt = (Lang == "AR") and L.EN or L.AR
    return alt[k] or k
end

-- ============================================================
-- الإعدادات
-- ============================================================
local Cfg={FlySpeed=50,WalkSpeed=16,JumpPower=50,FlyOn=false,NcOn=false,ESPOn=false,AntiAFK=true,MusicVol=0.5,InvisOn=false,TimeOn=false,TimeSpeed=5,AuraOn=false,Page=1,GodMode=false,InfJump=false,AutoClicker=false,Aimbot=false}
local CP={} local ESPObjs={} local ActiveMusic=nil local SelPlayer="" local AuraLbl=nil; local AuraActive=false
local FlyConn,NcConn,TimeConn,AuraConn,FollowConn,SpectateConn,GodConn,InfJumpConn,AimbotConn=nil,nil,nil,nil,nil,nil,nil,nil,nil

local function SaveCfg()
    if not writefile then return end
    pcall(function()
        local d = HttpService:JSONEncode({FlySpeed=Cfg.FlySpeed,WalkSpeed=Cfg.WalkSpeed,JumpPower=Cfg.JumpPower,MusicVol=Cfg.MusicVol})
        writefile("thaer_cfg.json", d)
    end)
end

local function LoadCfg()
    if not readfile then return end
    pcall(function()
        local r = readfile("thaer_cfg.json")
        if r then 
            local t = HttpService:JSONDecode(r)
            for k,v in pairs(t) do Cfg[k]=v end 
        end
    end)
end
LoadCfg()

-- دوال جلب الأجزاء بسرعة (Fast Character Access)
local function Char() return LP.Character end
local function Hum()  local c=Char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function HRP()  local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end

local function Tw(o,p,t,s,d)
	TweenService:Create(o,TweenInfo.new(t or 0.22,s or Enum.EasingStyle.Quart,d or Enum.EasingDirection.Out),p):Play()
end

-- منع الخمول (Anti-AFK)
LP.Idled:Connect(function()
	if Cfg.AntiAFK then pcall(function()VirtualUser:CaptureController();VirtualUser:ClickButton2(Vector2.new())end) end
end)

-- ============================================================
-- FLY
-- ============================================================
local function StopFly()
    -- إيقاف الطيران وتنظيف المحركات الفيزيائية
    -- Stops flight and cleans up physics objects
	Cfg.FlyOn=false
	if FlyConn then FlyConn:Disconnect();FlyConn=nil end
	local c=Char();if c then for _,v in pairs(c:GetDescendants()) do if v.Name=="TBV"or v.Name=="TBG" then pcall(function()v:Destroy()end)end end end
	local h=Hum();if h then pcall(function()h.PlatformStand=false end);h:ChangeState(Enum.HumanoidStateType.GettingUp)end
	local hr=HRP();if hr then pcall(function()hr.AssemblyLinearVelocity=Vector3.new(0,-1,0)end)end
end

local function StartFly()
    -- تفعيل الطيران باستخدام BodyVelocity و BodyGyro
    -- Enables flight using BodyVelocity and BodyGyro
	StopFly();local char=Char(); local hrp=HRP(); local hum=Hum()
	if not char or not hrp or not hum then return end;Cfg.FlyOn=true
	for _,v in pairs(char:GetDescendants()) do if v.Name=="TBV"or v.Name=="TBG" then pcall(function()v:Destroy()end)end end
	local bv=Instance.new("BodyVelocity");bv.Name="TBV";bv.Velocity=Vector3.zero;bv.MaxForce=Vector3.new(1e9,1e9,1e9);bv.Parent=hrp
	local bg=Instance.new("BodyGyro");bg.Name="TBG";bg.MaxTorque=Vector3.new(1e9,1e9,1e9);bg.P=9000;bg.D=500;bg.CFrame=hrp.CFrame;bg.Parent=hrp
	FlyConn=RunService.Heartbeat:Connect(function()
		local ch=HRP();local hm=Hum()
		if not Cfg.FlyOn or not ch or not hm then StopFly();return end
		if not bv.Parent or not bg.Parent then StopFly();return end
		if ch.Anchored then ch.Anchored=false end
		if hm:GetState()~=Enum.HumanoidStateType.Swimming then hm:ChangeState(Enum.HumanoidStateType.Swimming)end
		hm.PlatformStand=false
		local spd=Cfg.FlySpeed;local cf=Camera.CFrame;local dir=Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cf.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cf.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd=spd*2 end
		if IsMob and hm.MoveDirection.Magnitude>.1 then local m=hm.MoveDirection;dir=dir+Vector3.new(m.X,0,m.Z)end
		bv.Velocity=dir.Magnitude>0 and dir.Unit*spd or Vector3.zero
		local fl=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z);if fl.Magnitude>.01 then bg.CFrame=CFrame.new(Vector3.zero,fl)end
	end)
end

-- ============================================================
-- NOCLIP
-- ============================================================
local function StopNc()
    -- إرجاع التصادم للأجزاء (Restores collision)
	Cfg.NcOn=false;if NcConn then NcConn:Disconnect();NcConn=nil end
	local c=Char();if not c then return end
	for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function()p.CanCollide=true end)end end
end

local function StartNc()
    -- تفعيل المشي عبر الجدران عبر Stepped (Enables NoClip via Stepped)
	Cfg.NcOn=true
	NcConn=RunService.Stepped:Connect(function()
		if not Cfg.NcOn then StopNc();return end
		local c=Char();if not c then return end
		for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function()p.CanCollide=false end)end end
	end)
end

-- ============================================================
-- NEW FEATURES (God Mode, Inf Jump, Auto Clicker, Aimbot)
-- ============================================================

-- وضع عدم الموت (God Mode)
local function ToggleGodMode(v)
    Cfg.GodMode = v
    if v then
        GodConn = RunService.Heartbeat:Connect(function()
            local h = Hum()
            if h then h.Health = 100 end
        end)
    else
        if GodConn then GodConn:Disconnect(); GodConn = nil end
    end
end

-- القفز اللانهائي (Infinite Jump)
local function ToggleInfJump(v)
    Cfg.InfJump = v
    if v then
        InfJumpConn = UserInputService.JumpRequest:Connect(function()
            local h = Hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if InfJumpConn then InfJumpConn:Disconnect(); InfJumpConn = nil end
    end
end

-- النقر التلقائي (Auto Clicker)
local function ToggleAutoClicker(v)
    Cfg.AutoClicker = v
    if v then
        task.spawn(function()
            while Cfg.AutoClicker do
                if VirtualUser then
                    VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                    task.wait()
                    VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
                end
                task.wait(0.1)
            end
        end)
    end
end

-- الانتقال لمكان الماوس (Teleport to Mouse)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.B then
        local mouse = LP:GetMouse()
        local hrp = HRP()
        if hrp and mouse.Hit then
            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
        end
    end
end)

-- ايمبوت تلقائي (Simple Aimbot)
local function ToggleAimbot(v)
    Cfg.Aimbot = v
    if v then
        AimbotConn = RunService.RenderStepped:Connect(function()
            local dist = 1000
            local target = nil
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (HRP().Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = p.Character.HumanoidRootPart
                    end
                end
            end
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end)
    else
        if AimbotConn then AimbotConn:Disconnect(); AimbotConn = nil end
    end
end

-- قتل الجميع (Kill All) - يعمل في الألعاب ذات الحماية الضعيفة أو Reset
local function KillAllPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h then 
                -- محاولة القتل (تعمل فقط إذا كانت اللعبة تسمح بالوصول لصحة الآخرين محلياً)
                pcall(function() h.Health = 0 end) 
            end
        end
    end
end

-- ============================================================
-- INVISIBILITY
-- ============================================================
local function SetInvis(v)
	Cfg.InvisOn=v;local c=Char();if not c then return end
	pcall(function()
		local h=c:FindFirstChildOfClass("Humanoid")
		if h then h.DisplayDistanceType=v and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer end
		for _,p in pairs(c:GetDescendants()) do
			if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.LocalTransparencyModifier=v and 1 or 0 end
			if p:IsA("Decal") then p.Transparency=v and 1 or 0 end
		end
		local hr=c:FindFirstChild("HumanoidRootPart");if hr then hr.LocalTransparencyModifier=1 end
	end)
end

-- ============================================================
-- COPY OUTFIT
-- ============================================================
local function CopyOutfit(name)
	local tp=Players:FindFirstChild(name);if not tp then return end
	local tc=tp.Character;if not tc then return end
	pcall(function()
		local th=tc:FindFirstChildOfClass("Humanoid");local mh=Hum()
		if th and mh then local desc=th:GetAppliedDescription();task.wait(0.1);pcall(function()mh:ApplyDescription(desc)end)end
	end)
end

-- ============================================================
-- TIME WARP
-- ============================================================
local function StopTime()
	Cfg.TimeOn=false;if TimeConn then TimeConn:Disconnect();TimeConn=nil end
end
local function StartTime(spd)
	StopTime();Cfg.TimeOn=true
	TimeConn=RunService.Heartbeat:Connect(function(dt)
		if not Cfg.TimeOn then StopTime();return end
		pcall(function()Lighting.ClockTime=(Lighting.ClockTime+dt*spd)%24 end)
	end)
end

-- ============================================================
-- AURA ZONE
-- ============================================================
local function StopAura()
	Cfg.AuraOn=false;AuraActive=false
	if AuraConn then AuraConn:Disconnect();AuraConn=nil end
	if Cfg.TimeOn then StartTime(Cfg.TimeSpeed) end
	if AuraLbl then pcall(function()AuraLbl.Text=T("auraOff");AuraLbl.TextColor3=Color3.fromRGB(115,105,165)end)end
end
local function StartAura(nm)
	StopAura();Cfg.AuraOn=true;nm=(nm and nm~="")and nm or "AuraZone"
	AuraConn=RunService.Heartbeat:Connect(function()
		local hr=HRP();if not hr then return end
		local z=Workspace:FindFirstChild(nm,true)
		if not z or not z:IsA("BasePart") then
			if AuraLbl then pcall(function()AuraLbl.Text="⚠ '"..nm.."' غير موجود";AuraLbl.TextColor3=Color3.fromRGB(235,60,80)end)end;return
		end
		local zp=z.Position;local zs=z.Size/2;local pp=hr.Position
		local inside=math.abs(pp.X-zp.X)<zs.X and math.abs(pp.Y-zp.Y)<zs.Y+4 and math.abs(pp.Z-zp.Z)<zs.Z
		if inside and not AuraActive then
			AuraActive=true;StartTime(Cfg.TimeSpeed*10)
			if AuraLbl then pcall(function()AuraLbl.Text=T("auraOn");AuraLbl.TextColor3=Color3.fromRGB(255,200,0)end)end
		elseif not inside and AuraActive then
			AuraActive=false;StartTime(Cfg.TimeSpeed)
			if AuraLbl then pcall(function()AuraLbl.Text=T("auraOff");AuraLbl.TextColor3=Color3.fromRGB(115,105,165)end)end
		end
	end)
end

-- CHECKPOINTS
local function SaveCP(i) local h=HRP();if h then CP[i]=h.CFrame end end
local function LoadCP(i) local cf=CP[i];local h=HRP();if cf and h then pcall(function()h.CFrame=cf end)end end

-- PLAYERS
local function FindP(n) n=n:lower();for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(n,1,true) then return p end end end
local function TpTo(t) local h=HRP();local tc=t.Character;local th=tc and tc:FindFirstChild("HumanoidRootPart");if h and th then h.CFrame=th.CFrame+Vector3.new(3,0,0)end end
local FollowTgt=nil
local function StopFollow() if FollowConn then FollowConn:Disconnect();FollowConn=nil end;FollowTgt=nil end
local function StartFollow(t)
	StopFollow();FollowTgt=t
	FollowConn=RunService.Heartbeat:Connect(function()
		local h=HRP();local tc=FollowTgt and FollowTgt.Character;local th=tc and tc:FindFirstChild("HumanoidRootPart")
		if h and th then h.CFrame=th.CFrame+th.CFrame.LookVector*-3 end
	end)
end
local SpecTgt=nil
local function StopSpec() if SpectateConn then SpectateConn:Disconnect();SpectateConn=nil end;SpecTgt=nil;Camera.CameraType=Enum.CameraType.Custom;Camera.CameraSubject=Hum() end
local function StartSpec(t)
    -- تتبع كاميرا اللاعب المختار (Spectates target player)
	StopSpec();SpecTgt=t;Camera.CameraType=Enum.CameraType.Custom
	SpectateConn=RunService.RenderStepped:Connect(function()
		local tc=SpecTgt and SpecTgt.Character;local th=tc and tc:FindFirstChildOfClass("Humanoid")
		if th then Camera.CameraSubject=th end
	end)
end

local function BuildESP()
	ClearESP()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP then
			local bb=Instance.new("BillboardGui");bb.Name="TESP";bb.AlwaysOnTop=true;bb.Size=UDim2.new(0,120,0,42);bb.StudsOffset=Vector3.new(0,3,0)
			local bg=Instance.new("Frame");bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=Color3.fromRGB(6,4,20);bg.BackgroundTransparency=0.25;bg.Parent=bb
			local uc=Instance.new("UICorner");uc.CornerRadius=UDim.new(0,8);uc.Parent=bg
			local us=Instance.new("UIStroke");us.Color=Color3.fromRGB(120,60,255);us.Thickness=1.5;us.Parent=bg
			local lbl=Instance.new("TextLabel");lbl.Size=UDim2.fromScale(1,1);lbl.BackgroundTransparency=1;lbl.Font=Enum.Font.GothamBold;lbl.TextColor3=Color3.fromRGB(190,150,255);lbl.TextSize=13;lbl.Parent=bg
			-- استخدام RenderStepped لجعل الرادار سلساً جداً
			local conn=RunService.RenderStepped:Connect(function()
				local c=p.Character;local hr=c and c:FindFirstChild("HumanoidRootPart");local lh=HRP()
				if hr and lh then lbl.Text=p.Name.."\n"..math.floor((hr.Position-lh.Position).Magnitude).."m";bb.Adornee=hr;bb.Parent=Workspace
				else bb.Parent=nil end
			end)
			table.insert(ESPObjs,bb);table.insert(ESPObjs,{Disconnect=function()conn:Disconnect()end})
		end
	end
end
local function TogESP(v) Cfg.ESPOn=v;if v then BuildESP()else ClearESP()end end

-- MUSIC
local function PlayM(id,vol) if ActiveMusic then ActiveMusic:Destroy();ActiveMusic=nil end;local s=Instance.new("Sound");s.SoundId="rbxassetid://"..tostring(id);s.Volume=vol or Cfg.MusicVol;s.Looped=true;s.Parent=SoundService;s:Play();ActiveMusic=s end
local function StopM() if ActiveMusic then ActiveMusic:Stop();ActiveMusic:Destroy();ActiveMusic=nil end end

-- Respawn
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Cfg.FlyOn then StartFly() end
    if Cfg.NcOn then StartNc() end
    if Cfg.InvisOn then SetInvis(true) end
    if Cfg.TimeOn then StartTime(Cfg.TimeSpeed) end
    if Cfg.GodMode then ToggleGodMode(true) end
    if Cfg.InfJump then ToggleInfJump(true) end
end)

-- ============================================================
-- ====  الواجهة  ====
-- ============================================================
local old=LP.PlayerGui:FindFirstChild("ThaerX100")
if old then old:Destroy() end
local SG=Instance.new("ScreenGui")
SG.Name="ThaerX100";SG.ResetOnSpawn=false;SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset=true;SG.Parent=LP.PlayerGui

-- ألوان الثيم الداكن (Dark Theme Colors)
local C={
	BG=Color3.fromRGB(8,9,22),Panel=Color3.fromRGB(12,13,32),
	Side=Color3.fromRGB(9,10,26),Card=Color3.fromRGB(16,18,44),
	Acc=Color3.fromRGB(115,55,252),AccB=Color3.fromRGB(55,125,255),AccC=Color3.fromRGB(205,75,255),
	Txt=Color3.fromRGB(225,220,255),Sub=Color3.fromRGB(115,105,165),
	OK=Color3.fromRGB(45,215,135),Err=Color3.fromRGB(235,60,80),Warn=Color3.fromRGB(255,190,0),
	TOn=Color3.fromRGB(115,55,252),TOff=Color3.fromRGB(32,32,60),W=Color3.fromRGB(255,255,255),
}

-- أبعاد متجاوبة مع الشاشة (Responsive UI Dimensions)
local Viewport = Camera.ViewportSize
local IsLandscape = Viewport.X > Viewport.Y

local PW, PH
if IsMob then
    -- إعدادات الهاتف: العرض والطول يتغيران بناءً على تدوير الجهاز
    if IsLandscape then
        PW = math.floor(Viewport.X * 0.65) -- عرض أقل في الوضع الأفقي لترك مساحة رؤية
        PH = math.floor(Viewport.Y * 0.85) -- استغلال أغلب الطول المتاح
    else
        PW = math.floor(Viewport.X * 0.85)
        PH = math.floor(Viewport.Y * 0.60)
    end
    BH=40;TH=40;SH=58;IH=38;FS=12
else
    PW = math.floor(Viewport.X * 0.8)
    PH = math.floor(Viewport.Y * 0.5)
    if PW > 650 then PW = 650 end
    if PH > 480 then PH = 480 end
end

local SW = 75   -- عرض الشريط الجانبي (Fixed Sidebar)
local BH = 34   -- ارتفاع الأزرار
local TH = 34   -- ارتفاع التبديل
local SH = 52   -- ارتفاع السلايدر
local IH = 32   -- ارتفاع حقل النص
local FS = 12   -- حجم الخط

-- helpers
local function Cor(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p;return c end
local function Str(p,col,th) local s=Instance.new("UIStroke");s.Color=col or C.Acc;s.Thickness=th or 1.2;s.Parent=p;return s end
local function Grd(p,c0,c1,rot) local g=Instance.new("UIGradient");g.Color=ColorSequence.new(c0,c1);g.Rotation=rot or 90;g.Parent=p;return g end
local function LL(p,pad,dir,ha,va)
	local l=Instance.new("UIListLayout");l.Padding=UDim.new(0,pad or 5)
	l.FillDirection=dir or Enum.FillDirection.Vertical
	l.HorizontalAlignment=ha or Enum.HorizontalAlignment.Center
	l.VerticalAlignment=va or Enum.VerticalAlignment.Top
	l.SortOrder=Enum.SortOrder.LayoutOrder;l.Parent=p;return l
end
local function Pd(p,t,b,l,r)
	local pd=Instance.new("UIPadding");pd.PaddingTop=UDim.new(0,t or 6);pd.PaddingBottom=UDim.new(0,b or 6)
	pd.PaddingLeft=UDim.new(0,l or 6);pd.PaddingRight=UDim.new(0,r or 6);pd.Parent=p;return pd
end

local function SecH(p,txt,ord)
	local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,20);f.BackgroundTransparency=1;f.LayoutOrder=ord or 0;f.Parent=p
	local line=Instance.new("Frame");line.Size=UDim2.new(1,0,0,1);line.Position=UDim2.new(0,0,1,-1);line.BackgroundColor3=C.Acc;line.BackgroundTransparency=0.65;line.BorderSizePixel=0;line.Parent=f
	Grd(line,C.Acc,Color3.fromRGB(8,9,22),0)
	local lbl=Instance.new("TextLabel");lbl.Size=UDim2.fromScale(1,1);lbl.BackgroundTransparency=1;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=9;lbl.Text="▸  "..txt:upper();lbl.TextColor3=C.Acc;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.Parent=f
	return f,lbl
end

local function PgH(p,tk,sk,ord)
	local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,50);f.BackgroundColor3=C.Card;f.LayoutOrder=ord or 0;f.Parent=p;Cor(f,10);Str(f,C.Acc,1)
	Grd(f,Color3.fromRGB(24,8,70),Color3.fromRGB(6,18,62),140)
	local t=Instance.new("TextLabel");t.Position=UDim2.new(0,12,0,8);t.Size=UDim2.new(.9,0,0,20);t.BackgroundTransparency=1;t.Font=Enum.Font.GothamBold;t.Text=T(tk);t.TextColor3=C.W;t.TextSize=14;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=f
	local s=Instance.new("TextLabel");s.Position=UDim2.new(0,12,0,29);s.Size=UDim2.new(.9,0,0,14);s.BackgroundTransparency=1;s.Font=Enum.Font.Gotham;s.Text=T(sk);s.TextColor3=C.Sub;s.TextSize=10;s.TextXAlignment=Enum.TextXAlignment.Left;s.Parent=f
	return f,t,s
end

local function Btn(p,key,col,ord,cb)
	col=col or C.Acc
	local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,BH);b.BackgroundColor3=col;b.Font=Enum.Font.GothamBold;b.Text=T(key);b.TextColor3=C.W;b.TextSize=FS;b.AutoButtonColor=false;b.LayoutOrder=ord or 0;b.Parent=p;Cor(b,7)
	local gs=Str(b,col,0)
	b.MouseEnter:Connect(function()Tw(b,{BackgroundColor3=col:Lerp(C.W,.18)},.12);Tw(gs,{Thickness=2},.12)end)
	b.MouseLeave:Connect(function()Tw(b,{BackgroundColor3=col},.12);Tw(gs,{Thickness=0},.12)end)
	local function fire()Tw(b,{Size=UDim2.new(.95,0,0,BH-2)},.07);task.delay(.07,function()Tw(b,{Size=UDim2.new(1,0,0,BH)},.1)end);if cb then cb()end end
	b.MouseButton1Click:Connect(fire);b.TouchTap:Connect(fire)
	return b
end

local function Tog(p,key,state,ord,cb)
	local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,TH);f.BackgroundColor3=C.Card;f.LayoutOrder=ord or 0;f.Parent=p;Cor(f,7);Str(f,C.Acc,1)
	local lbl=Instance.new("TextLabel");lbl.Position=UDim2.new(0,10,0,0);lbl.Size=UDim2.new(1,-58,1,0);lbl.BackgroundTransparency=1;lbl.Font=Enum.Font.Gotham;lbl.Text=T(key);lbl.TextColor3=C.Txt;lbl.TextSize=FS;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.Parent=f
	local trk=Instance.new("Frame");trk.Position=UDim2.new(1,-50,0.5,-10);trk.Size=UDim2.new(0,40,0,20);trk.BackgroundColor3=state and C.TOn or C.TOff;trk.Parent=f;Cor(trk,10)
	local knob=Instance.new("Frame");knob.Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,2,0.5,-8);knob.Size=UDim2.new(0,17,0,17);knob.BackgroundColor3=C.W;knob.Parent=trk;Cor(knob,9)
	local cur=state or false
	local function SetS(v)
		cur=v;Tw(trk,{BackgroundColor3=v and C.TOn or C.TOff},.18)
		Tw(knob,{Position=v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,2,0.5,-8)},.18)
	end
	local hb=Instance.new("TextButton");hb.Size=UDim2.fromScale(1,1);hb.BackgroundTransparency=1;hb.Text="";hb.Parent=f
	local function fire()SetS(not cur);if cb then cb(cur)end end
	hb.MouseButton1Click:Connect(fire);hb.TouchTap:Connect(fire)
	return f,SetS,lbl
end

local function Sldr(p,key,mn,mx,val,ord,cb)
	local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,SH);f.BackgroundColor3=C.Card;f.LayoutOrder=ord or 0;f.Parent=p;Cor(f,7);Str(f,C.Acc,1)
	local lbl=Instance.new("TextLabel");lbl.Position=UDim2.new(0,10,0,5);lbl.Size=UDim2.new(.6,0,0,16);lbl.BackgroundTransparency=1;lbl.Font=Enum.Font.Gotham;lbl.Text=T(key);lbl.TextColor3=C.Txt;lbl.TextSize=FS;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.Parent=f
	local vl=Instance.new("TextLabel");vl.Position=UDim2.new(.6,0,0,5);vl.Size=UDim2.new(.37,0,0,16);vl.BackgroundTransparency=1;vl.Font=Enum.Font.GothamBold;vl.Text=tostring(val);vl.TextColor3=C.Acc;vl.TextSize=FS;vl.TextXAlignment=Enum.TextXAlignment.Right;vl.Parent=f
	local trk=Instance.new("Frame");trk.Position=UDim2.new(0,10,0,SH-18);trk.Size=UDim2.new(1,-20,0,6);trk.BackgroundColor3=C.Side;trk.Parent=f;Cor(trk,3)
	local fill=Instance.new("Frame");fill.Size=UDim2.new((val-mn)/(mx-mn),0,1,0);fill.BackgroundColor3=C.Acc;fill.Parent=trk;Cor(fill,3);Grd(fill,C.AccB,C.AccC,0)
	local knob=Instance.new("Frame");knob.AnchorPoint=Vector2.new(.5,.5);knob.Position=UDim2.new((val-mn)/(mx-mn),0,.5,0);knob.Size=UDim2.new(0,IsMob and 18 or 13,0,IsMob and 18 or 13);knob.BackgroundColor3=C.W;knob.Parent=trk;Cor(knob,9);Str(knob,C.Acc,1.5)
	local drag=false
	local function Upd(x)
		local a=trk.AbsolutePosition.X;local w=trk.AbsoluteSize.X
		local pct=math.clamp((x-a)/w,0,1);local v=math.floor(mn+pct*(mx-mn))
		Tw(fill,{Size=UDim2.new(pct,0,1,0)},.05);Tw(knob,{Position=UDim2.new(pct,0,.5,0)},.05)
		vl.Text=tostring(v);if cb then cb(v)end
	end
	trk.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;Upd(i.Position.X)end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then Upd(i.Position.X)end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
	end)
	return f,lbl
end

local function Inp(p,ph,ord)
	local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,IH);f.BackgroundColor3=C.Card;f.LayoutOrder=ord or 0;f.Parent=p;Cor(f,7);Str(f,C.Acc,1)
	local tb=Instance.new("TextBox");tb.Size=UDim2.new(1,-18,1,0);tb.Position=UDim2.new(0,9,0,0);tb.BackgroundTransparency=1;tb.Font=Enum.Font.Gotham;tb.PlaceholderText=ph;tb.Text="";tb.TextColor3=C.Txt;tb.PlaceholderColor3=C.Sub;tb.TextSize=FS;tb.ClearTextOnFocus=false;tb.Parent=f
	return f,tb
end

-- ============================================================
-- هيكل اللوحة — أبعاد ثابتة بدون Scale
-- ============================================================

-- زر الفتح العائم
local FB=Instance.new("TextButton")
FB.Size=UDim2.new(0,40,0,40);FB.Position=UDim2.new(0,8,0.5,-20)
FB.BackgroundColor3=C.Acc;FB.Text="⚡";FB.Font=Enum.Font.GothamBold;FB.TextSize=18;FB.TextColor3=C.W
FB.AutoButtonColor=false;FB.ZIndex=10;FB.Parent=SG;Cor(FB,20);Str(FB,C.AccB,2)
local FBG=Str(FB,C.AccC,0)
task.spawn(function()while FB.Parent do Tw(FBG,{Thickness=3},.8);task.wait(.9);Tw(FBG,{Thickness=0},.8);task.wait(.9)end end)
-- سحب الزر
local fbd,fbs,fbp=false,nil,nil
FB.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fbd=true;fbs=i.Position;fbp=FB.Position end end)
UserInputService.InputChanged:Connect(function(i)if fbd and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-fbs;FB.Position=UDim2.new(0,fbp.X.Offset+d.X,0,fbp.Y.Offset+d.Y)end end)
UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fbd=false end end)

-- اللوحة الرئيسية — حجم ثابت
local MP=Instance.new("Frame")
MP.Name="MainPanel"
MP.Size=UDim2.new(0,PW,0,PH)   -- حجم ثابت بالبكسل
MP.Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)  -- وسط الشاشة
MP.BackgroundColor3=C.Panel;MP.ZIndex=5;MP.ClipsDescendants=true;MP.Parent=SG
Cor(MP,14);Str(MP,C.Acc,1.5)
Grd(MP,Color3.fromRGB(9,10,27),Color3.fromRGB(6,7,19),150)

-- سحب اللوحة
local pd,ps,pp=false,nil,nil
local DA=Instance.new("TextButton");DA.Size=UDim2.new(1,0,0,34);DA.BackgroundTransparency=1;DA.Text="";DA.ZIndex=20;DA.Parent=MP
DA.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pd=true;ps=i.Position;pp=MP.Position end end)
UserInputService.InputChanged:Connect(function(i)if pd and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-ps;MP.Position=UDim2.new(pp.X.Scale,pp.X.Offset+d.X,pp.Y.Scale,pp.Y.Offset+d.Y)end end)
UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pd=false end end)

-- شريط العنوان
local TB=Instance.new("Frame");TB.Size=UDim2.new(1,0,0,34);TB.BackgroundColor3=C.Side;TB.Parent=MP;Cor(TB,14)
Grd(TB,Color3.fromRGB(18,6,56),Color3.fromRGB(6,14,52),90)
local TBFix=Instance.new("Frame");TBFix.Size=UDim2.new(1,0,0,14);TBFix.Position=UDim2.new(0,0,1,-14);TBFix.BackgroundColor3=C.Side;TBFix.BorderSizePixel=0;TBFix.Parent=TB
local TL=Instance.new("TextLabel");TL.Size=UDim2.new(1,-75,1,0);TL.Position=UDim2.new(0,12,0,0);TL.BackgroundTransparency=1;TL.Font=Enum.Font.GothamBold;TL.Text=T("title");TL.TextColor3=C.W;TL.TextSize=12;TL.TextXAlignment=Enum.TextXAlignment.Left;TL.Parent=TB
local BDG=Instance.new("TextLabel");BDG.Size=UDim2.new(0,30,0,14);BDG.Position=UDim2.new(1,-68,0.5,-7);BDG.BackgroundColor3=C.Acc;BDG.Font=Enum.Font.GothamBold;BDG.Text="v2.0";BDG.TextColor3=C.W;BDG.TextSize=9;BDG.Parent=TB;Cor(BDG,4)
local XB=Instance.new("TextButton");XB.Size=UDim2.new(0,25,0,25);XB.Position=UDim2.new(1,-30,0.5,-12);XB.BackgroundColor3=C.Err;XB.Font=Enum.Font.GothamBold;XB.Text="✕";XB.TextColor3=C.W;XB.TextSize=12;XB.AutoButtonColor=false;XB.ZIndex=25;XB.Parent=TB;Cor(XB,5)
XB.MouseButton1Click:Connect(function()Tw(MP,{Position=UDim2.new(0.5,-PW/2,1.5,0)},.28,Enum.EasingStyle.Back,Enum.EasingDirection.In);task.delay(.32,function()MP.Visible=false end)end)
FB.MouseButton1Click:Connect(function()if not fbd then MP.Visible=true;MP.Position=UDim2.new(0.5,-PW/2,1.5,0);Tw(MP,{Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)},.38,Enum.EasingStyle.Back)end end)

-- الجسم
local Body=Instance.new("Frame");Body.Size=UDim2.new(1,0,1,-34);Body.Position=UDim2.new(0,0,0,34);Body.BackgroundTransparency=1;Body.Parent=MP

-- شريط جانبي — عرض ثابت
local Side=Instance.new("Frame");Side.Size=UDim2.new(0,SW,1,0);Side.BackgroundColor3=C.Side;Side.BorderSizePixel=0;Side.ClipsDescendants=true;Side.Parent=Body
local SL=Instance.new("Frame");SL.Size=UDim2.new(0,1,1,0);SL.Position=UDim2.new(1,-1,0,0);SL.BackgroundColor3=C.Acc;SL.BackgroundTransparency=0.65;SL.BorderSizePixel=0;SL.Parent=Side

-- منطقة المحتوى
local CA=Instance.new("Frame");CA.Size=UDim2.new(1,-SW,1,0);CA.Position=UDim2.new(0,SW,0,0);CA.BackgroundTransparency=1;CA.ClipsDescendants=true;CA.Parent=Body

-- صانع الصفحات
local Pages={}
local function MkPg(n)
	local sf=Instance.new("ScrollingFrame")
	sf.Name=n;sf.Size=UDim2.fromScale(1,1);sf.BackgroundTransparency=1;sf.BorderSizePixel=0
	sf.ScrollBarThickness=3;sf.ScrollBarImageColor3=C.Acc
	sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
	sf.Visible=false;sf.Parent=CA;LL(sf,6);Pd(sf,8,16,8,8)
	Pages[n]=sf;return sf
end

local PG={
	Home=MkPg("Home"),Move=MkPg("Move"),Cp=MkPg("Cp"),
	Pl=MkPg("Pl"),Esp=MkPg("Esp"),Ext=MkPg("Ext"),
	Time=MkPg("Time"),Set=MkPg("Set"),
}

local function ShowPage(n)
	for _,pg in pairs(PG) do pg.Visible=false end
	if PG[n] then PG[n].Visible=true end
	Cfg.Page=n
end

-- ============================================================
-- شريط التنقل الجانبي
-- ============================================================
local NavList=Instance.new("UIListLayout");NavList.Padding=UDim.new(0,2);NavList.HorizontalAlignment=Enum.HorizontalAlignment.Center;NavList.VerticalAlignment=Enum.VerticalAlignment.Top;NavList.SortOrder=Enum.SortOrder.LayoutOrder;NavList.Parent=Side
Pd(Side,6,6,2,2)

local NavPages={"Home","Move","Cp","Pl","Esp","Ext","Time","Set"}
local NavBtns={}
for i,pg in ipairs(NavPages) do
	local btn=Instance.new("TextButton")
    -- الأزرار كبيرة لتناسب اللمس (Touch Friendly)
	btn.Size=UDim2.new(1,0,0,IsMob and 55 or 48)
	btn.BackgroundTransparency=1;btn.AutoButtonColor=false;btn.Text="";btn.LayoutOrder=i;btn.Parent=Side;Cor(btn,7)
	local hl=Instance.new("Frame");hl.Size=UDim2.new(0,3,0.6,0);hl.AnchorPoint=Vector2.new(0,.5);hl.Position=UDim2.new(0,0,.5,0);hl.BackgroundColor3=C.Acc;hl.BackgroundTransparency=1;hl.BorderSizePixel=0;hl.Parent=btn;Cor(hl,2)
	local ic=Instance.new("TextLabel");ic.Size=UDim2.new(1,0,0,18);ic.Position=UDim2.new(0,0,0,IsMob and 6 or 4);ic.BackgroundTransparency=1;ic.Font=Enum.Font.GothamBold
	local icons={"🏠","✈","📍","👥","👁","✨","⏱","⚙"}
	ic.Text=icons[i];ic.TextSize=IsMob and 16 or 14;ic.TextColor3=C.Sub;ic.Parent=btn
	local tx=Instance.new("TextLabel");tx.Size=UDim2.new(1,-4,0,12);tx.Position=UDim2.new(0,2,0,IsMob and 26 or 22);tx.BackgroundTransparency=1;tx.Font=Enum.Font.Gotham
	local txts={"رئيسية","حركة","حفظ","لاعبين","رادار","إضافات","وقت","إعدادات"}
	tx.Text=txts[i];tx.TextSize=8;tx.TextColor3=C.Sub;tx.TextWrapped=true;tx.Parent=btn
	local function SetAct(on)
		if on then Tw(btn,{BackgroundTransparency=0.82},.15);btn.BackgroundColor3=C.Acc;Tw(ic,{TextColor3=C.W},.15);Tw(tx,{TextColor3=C.Acc},.15);Tw(hl,{BackgroundTransparency=0},.15)
		else Tw(btn,{BackgroundTransparency=1},.15);Tw(ic,{TextColor3=C.Sub},.15);Tw(tx,{TextColor3=C.Sub},.15);Tw(hl,{BackgroundTransparency=1},.15)end
	end
	table.insert(NavBtns,{btn=btn,ic=ic,tx=tx,txts=txts,set=SetAct,page=pg})
	btn.MouseButton1Click:Connect(function()
		for _,nb in ipairs(NavBtns) do nb.set(nb.page==pg)end;ShowPage(pg)
	end)
end

-- ============================================================
-- صفحة الرئيسية
-- ============================================================
-- بطاقة الترحيب
local heroF=Instance.new("Frame");heroF.Size=UDim2.new(1,0,0,82);heroF.BackgroundColor3=C.Card;heroF.LayoutOrder=1;heroF.Parent=PG.Home;Cor(heroF,10);Str(heroF,C.Acc,1)
Grd(heroF,Color3.fromRGB(22,7,68),Color3.fromRGB(5,16,60),140)
local hShim=Instance.new("Frame");hShim.Size=UDim2.new(0,0,0,2);hShim.BackgroundColor3=C.AccC;hShim.BackgroundTransparency=0.35;hShim.BorderSizePixel=0;hShim.Parent=heroF;Cor(hShim,1)
task.spawn(function()while heroF.Parent do Tw(hShim,{Size=UDim2.new(1,0,0,2)},.7,Enum.EasingStyle.Sine);task.wait(.8);hShim.Size=UDim2.new(0,0,0,2);task.wait(.35)end end)
local hT=Instance.new("TextLabel");hT.Position=UDim2.new(0,12,0,10);hT.Size=UDim2.new(.9,0,0,22);hT.BackgroundTransparency=1;hT.Font=Enum.Font.GothamBold;hT.Text="⚡ THAER X100  |  Admin Panel";hT.TextColor3=C.W;hT.TextSize=13;hT.TextXAlignment=Enum.TextXAlignment.Left;hT.Parent=heroF
local hS=Instance.new("TextLabel");hS.Position=UDim2.new(0,12,0,34);hS.Size=UDim2.new(.9,0,0,18);hS.BackgroundTransparency=1;hS.Font=Enum.Font.Gotham;hS.Text=T("welcome");hS.TextColor3=C.Sub;hS.TextSize=10;hS.TextXAlignment=Enum.TextXAlignment.Left;hS.TextWrapped=true;hS.Parent=heroF
local hP=Instance.new("TextLabel");hP.Position=UDim2.new(0,12,0,56);hP.Size=UDim2.new(.9,0,0,16);hP.BackgroundTransparency=1;hP.Font=Enum.Font.GothamBold;hP.Text="👤 "..LP.Name;hP.TextColor3=C.AccB;hP.TextSize=9;hP.TextXAlignment=Enum.TextXAlignment.Left;hP.Parent=heroF

-- شبكة الحالة
local stF=Instance.new("Frame");stF.Size=UDim2.new(1,0,0,58);stF.BackgroundColor3=C.Card;stF.LayoutOrder=2;stF.Parent=PG.Home;Cor(stF,8);Str(stF,C.AccB,1)
local stHL=Instance.new("UIListLayout");stHL.FillDirection=Enum.FillDirection.Horizontal;stHL.HorizontalAlignment=Enum.HorizontalAlignment.Center;stHL.VerticalAlignment=Enum.VerticalAlignment.Center;stHL.Padding=UDim.new(0,0);stHL.Parent=stF
local StDefs={{lk="statF",get=function()return Cfg.FlyOn end},{lk="statN",get=function()return Cfg.NcOn end},{lk="statE",get=function()return Cfg.ESPOn end},{lk="statI",get=function()return Cfg.InvisOn end},{lk="statT",get=function()return Cfg.TimeOn end},{lk="statA",get=function()return Cfg.AntiAFK end}}
local StLbls={}
for _,sd in ipairs(StDefs) do
	local col=Instance.new("Frame");col.Size=UDim2.new(1/#StDefs,0,1,0);col.BackgroundTransparency=1;col.Parent=stF
	local dot=Instance.new("Frame");dot.Size=UDim2.new(0,6,0,6);dot.AnchorPoint=Vector2.new(.5,0);dot.Position=UDim2.new(.5,0,0,6);dot.BackgroundColor3=C.Sub;dot.BorderSizePixel=0;dot.Parent=col;Cor(dot,3)
	local vl=Instance.new("TextLabel");vl.Size=UDim2.new(1,0,0,16);vl.Position=UDim2.new(0,0,0,16);vl.BackgroundTransparency=1;vl.Font=Enum.Font.GothamBold;vl.Text="OFF";vl.TextColor3=C.Sub;vl.TextSize=10;vl.Parent=col
	local ll=Instance.new("TextLabel");ll.Size=UDim2.new(1,0,0,13);ll.Position=UDim2.new(0,0,0,34);ll.BackgroundTransparency=1;ll.Font=Enum.Font.Gotham;ll.Text=T(sd.lk);ll.TextColor3=C.Sub;ll.TextSize=8;ll.Parent=col
	table.insert(StLbls,{vl=vl,ll=ll,dot=dot,sd=sd})
end
RunService.Heartbeat:Connect(function()
	for _,sv in pairs(StLbls) do
		local on=sv.sd.get();sv.vl.Text=on and"ON"or"OFF";sv.vl.TextColor3=on and C.OK or C.Sub;sv.dot.BackgroundColor3=on and C.OK or C.Sub;sv.ll.Text=T(sv.sd.lk)
	end
end)

-- ============================================================
-- صفحة الحركة
-- ============================================================
local mH,mHT,mHS=PgH(PG.Move,"movTitle","movSub",1)
SecH(PG.Move,T("flySec"),2)
local _,flySet,flyLbl=Tog(PG.Move,"flyTog",false,3,function(v)if v then StartFly()else StopFly()end end)
local fslF,fslL=Sldr(PG.Move,"flySpd",5,250,Cfg.FlySpeed,4,function(v)Cfg.FlySpeed=v end)
SecH(PG.Move,T("charSec"),5)
Tog(PG.Move,"ncTog",false,6,function(v)if v then StartNc()else StopNc()end end)
Tog(PG.Move,"godTog",false,7,function(v)ToggleGodMode(v)end)
Tog(PG.Move,"infJump",false,8,function(v)ToggleInfJump(v)end)
Sldr(PG.Move,"walkSpd",1,250,Cfg.WalkSpeed,9,function(v)Cfg.WalkSpeed=v;local h=Hum();if h then h.WalkSpeed=v end end)
Sldr(PG.Move,"jumpPow",1,250,Cfg.JumpPower,10,function(v)Cfg.JumpPower=v;local h=Hum();if h then h.JumpPower=v end end)
Btn(PG.Move,"resetC",C.Err,11,function()local h=Hum();if h then h.Health=0 end end)

-- ============================================================
-- صفحة نقاط الحفظ
-- ============================================================
PgH(PG.Cp,"cpTitle","cpSub",1)
for i=1,3 do
	SecH(PG.Cp,T("slot").." "..i,(i-1)*3+2)
	local row=Instance.new("Frame");row.Size=UDim2.new(1,0,0,BH);row.BackgroundTransparency=1;row.LayoutOrder=(i-1)*3+3;row.Parent=PG.Cp
	LL(row,6,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Center)
	local sb=Instance.new("TextButton");sb.Size=UDim2.new(0.48,0,0,BH);sb.BackgroundColor3=C.AccB;sb.Font=Enum.Font.GothamBold;sb.Text=T("saveLbl");sb.TextColor3=C.W;sb.TextSize=FS;sb.AutoButtonColor=false;sb.Parent=row;Cor(sb,7)
	local lb=Instance.new("TextButton");lb.Size=UDim2.new(0.48,0,0,BH);lb.BackgroundColor3=C.Acc;lb.Font=Enum.Font.GothamBold;lb.Text=T("tpLbl");lb.TextColor3=C.W;lb.TextSize=FS;lb.AutoButtonColor=false;lb.Parent=row;Cor(lb,7)
	local sl=i
	sb.MouseButton1Click:Connect(function()SaveCP(sl);Tw(sb,{BackgroundColor3=C.OK},.15);task.delay(.6,function()Tw(sb,{BackgroundColor3=C.AccB},.3)end)end)
	lb.MouseButton1Click:Connect(function()LoadCP(sl)end)
end

-- ============================================================
-- صفحة اللاعبين
-- ============================================================
PgH(PG.Pl,"plTitle","plSub",1)
SecH(PG.Pl,T("targetSec"),2)
local _,plTB=Inp(PG.Pl,T("plHint"),3)
Btn(PG.Pl,"tpTo",C.Acc,4,function()local t=FindP(plTB.Text);if t then TpTo(t)end end)
Btn(PG.Pl,"follow",C.AccB,5,function()local t=FindP(plTB.Text);if t then StartFollow(t)else StopFollow()end end)
Btn(PG.Pl,"spec",Color3.fromRGB(30,148,98),6,function()local t=FindP(plTB.Text);if t then StartSpec(t)else StopSpec()end end)
Btn(PG.Pl,"copyOutfit",Color3.fromRGB(142,72,215),7,function()local n=SelPlayer~=""and SelPlayer or plTB.Text;CopyOutfit(n)end)
Btn(PG.Pl,"killAll",C.Err,8,function()KillAllPlayers()end)
Btn(PG.Pl,"stopAll",Color3.fromRGB(72,72,105),9,function()StopFollow();StopSpec()end)
SecH(PG.Pl,T("plList"),9)
local plFr=Instance.new("Frame");plFr.Size=UDim2.new(1,0,0,108);plFr.BackgroundColor3=C.Card;plFr.LayoutOrder=11;plFr.Parent=PG.Pl;Cor(plFr,7);Str(plFr,C.Acc,1)
local plSF=Instance.new("ScrollingFrame");plSF.Size=UDim2.fromScale(1,1);plSF.BackgroundTransparency=1;plSF.ScrollBarThickness=3;plSF.ScrollBarImageColor3=C.Acc;plSF.CanvasSize=UDim2.new(0,0,0,0);plSF.AutomaticCanvasSize=Enum.AutomaticSize.Y;plSF.Parent=plFr;LL(plSF,3);Pd(plSF,4,4,5,5)
local function RefPL()
	for _,c in pairs(plSF:GetChildren()) do if not c:IsA("UIListLayout")and not c:IsA("UIPadding")then c:Destroy()end end
	for _,p in pairs(Players:GetPlayers()) do
		local r=Instance.new("TextButton");r.Size=UDim2.new(1,0,0,26);r.BackgroundColor3=C.Side;r.Font=Enum.Font.Gotham;r.Text=(p==LP and"⭐ "or"")..p.Name;r.TextColor3=p==LP and C.Acc or C.Txt;r.TextSize=11;r.TextXAlignment=Enum.TextXAlignment.Left;Cor(r,5);Pd(r,0,0,8,8);r.Parent=plSF
		r.MouseButton1Click:Connect(function()plTB.Text=p.Name;SelPlayer=p.Name;Tw(r,{BackgroundColor3=C.Card},.1);task.delay(.3,function()Tw(r,{BackgroundColor3=C.Side},.2)end)end)
	end
end
RefPL();Players.PlayerAdded:Connect(RefPL);Players.PlayerRemoving:Connect(function()task.wait(.1);RefPL()end)

-- ============================================================
-- صفحة الرادار والموسيقى
-- ============================================================
PgH(PG.Esp,"espTitle","espSub",1)
Tog(PG.Esp,"espTog",false,3,function(v)TogESP(v)end)
Tog(PG.Esp,"aimTog",false,4,function(v)ToggleAimbot(v)end)
local espIL=Instance.new("TextLabel");espIL.Size=UDim2.new(1,0,0,30);espIL.BackgroundTransparency=1;espIL.Font=Enum.Font.Gotham;espIL.Text=T("espInfo");espIL.TextColor3=C.Sub;espIL.TextSize=10;espIL.TextWrapped=true;espIL.LayoutOrder=4;espIL.Parent=PG.Esp
SecH(PG.Esp,T("musicSec"),5)
local _,mInTB=Inp(PG.Esp,T("sndHint"),6)
Sldr(PG.Esp,"vol",0,100,math.floor(Cfg.MusicVol*100),7,function(v)Cfg.MusicVol=v/100;if ActiveMusic then ActiveMusic.Volume=Cfg.MusicVol end end)
Btn(PG.Esp,"playM",C.OK,8,function()local id=tonumber(mInTB.Text);if id then PlayM(id,Cfg.MusicVol)end end)
Btn(PG.Esp,"stopM",C.Err,9,function()StopM()end)

-- ============================================================
-- صفحة الإضافات
-- ============================================================
PgH(PG.Ext,"extTitle","extSub",1)
Tog(PG.Ext,"invisTog",false,2,function(v)SetInvis(v)end)
local invIL=Instance.new("TextLabel");invIL.Size=UDim2.new(1,0,0,30);invIL.BackgroundTransparency=1;invIL.Font=Enum.Font.Gotham;invIL.Text=T("invisInfo");invIL.TextColor3=C.Sub;invIL.TextSize=10;invIL.TextWrapped=true;invIL.LayoutOrder=4;invIL.Parent=PG.Ext
SecH(PG.Ext,T("clickerSec"),4)
Tog(PG.Ext,"clickerTog",false,5,function(v)ToggleAutoClicker(v)end)
SecH(PG.Ext,T("outfitSec"),6)
local outIL=Instance.new("TextLabel");outIL.Size=UDim2.new(1,0,0,28);outIL.BackgroundTransparency=1;outIL.Font=Enum.Font.Gotham;outIL.Text=T("outfitInfo");outIL.TextColor3=C.Sub;outIL.TextSize=10;outIL.TextWrapped=true;outIL.LayoutOrder=6;outIL.Parent=PG.Ext
local _,cpNTB=Inp(PG.Ext,T("plHint"),8)
Btn(PG.Ext,"copyBtn",Color3.fromRGB(145,70,218),9,function()local n=cpNTB.Text~=""and cpNTB.Text or SelPlayer;CopyOutfit(n)end)
local mouseTpIL=Instance.new("TextLabel");mouseTpIL.Size=UDim2.new(1,0,0,25);mouseTpIL.BackgroundTransparency=1;mouseTpIL.Font=Enum.Font.Gotham;mouseTpIL.Text=T("mouseTpInfo");mouseTpIL.TextColor3=C.Warn;mouseTpIL.TextSize=10;mouseTpIL.LayoutOrder=10;mouseTpIL.Parent=PG.Ext

-- ============================================================
-- صفحة الوقت
-- ============================================================
PgH(PG.Time,"timeTitle","timeSub",1)
SecH(PG.Time,T("timeSec"),2)
Tog(PG.Time,"timeTog",false,3,function(v)if v then StartTime(Cfg.TimeSpeed)else StopTime()end end)
Sldr(PG.Time,"timeSpd",1,30,Cfg.TimeSpeed,4,function(v)Cfg.TimeSpeed=v;if Cfg.TimeOn and not AuraActive then StartTime(v)end end)
SecH(PG.Time,T("auraSec"),5)
local auraIL=Instance.new("TextLabel");auraIL.Size=UDim2.new(1,0,0,34);auraIL.BackgroundTransparency=1;auraIL.Font=Enum.Font.Gotham;auraIL.Text=T("auraInfo");auraIL.TextColor3=C.Sub;auraIL.TextSize=10;auraIL.TextWrapped=true;auraIL.LayoutOrder=6;auraIL.Parent=PG.Time
local _,aZTB=Inp(PG.Time,T("auraHint"),7);aZTB.Text="AuraZone"
-- مؤشر الأورا
local aStF=Instance.new("Frame");aStF.Size=UDim2.new(1,0,0,36);aStF.BackgroundColor3=C.Card;aStF.LayoutOrder=8;aStF.Parent=PG.Time;Cor(aStF,7);Str(aStF,C.Acc,1)
local aDot=Instance.new("Frame");aDot.Size=UDim2.new(0,9,0,9);aDot.AnchorPoint=Vector2.new(.5,.5);aDot.Position=UDim2.new(0,20,.5,0);aDot.BackgroundColor3=C.Sub;aDot.BorderSizePixel=0;aDot.Parent=aStF;Cor(aDot,5)
AuraLbl=Instance.new("TextLabel");AuraLbl.Size=UDim2.new(1,-38,1,0);AuraLbl.Position=UDim2.new(0,34,0,0);AuraLbl.BackgroundTransparency=1;AuraLbl.Font=Enum.Font.GothamBold;AuraLbl.Text=T("auraOff");AuraLbl.TextColor3=C.Sub;AuraLbl.TextSize=12;AuraLbl.TextXAlignment=Enum.TextXAlignment.Left;AuraLbl.Parent=aStF
RunService.Heartbeat:Connect(function()aDot.BackgroundColor3=AuraActive and C.Warn or C.Sub end)
local _,aTogSet,aTogLbl=Tog(PG.Time,T("auraTog"),false,9,function(v)if v then StartAura(aZTB.Text)else StopAura()end end)

-- ============================================================
-- صفحة الإعدادات
-- ============================================================
PgH(PG.Set,"setTitle","setSub",1)
SecH(PG.Set,T("genSec"),2)
local _,afkSet,afkLbl=Tog(PG.Set,T("afkTog"),Cfg.AntiAFK,3,function(v)Cfg.AntiAFK=v end)
SecH(PG.Set,T("dataSec"),4)
Btn(PG.Set,T("saveCfg"),C.Acc,5,function()SaveCfg()end)
Btn(PG.Set,T("resetDef"),C.Err,6,function()Cfg.FlySpeed=50;Cfg.WalkSpeed=16;Cfg.JumpPower=50;Cfg.MusicVol=0.5 end)
SecH(PG.Set,T("uiSec"),7)
Btn(PG.Set,T("hidePanel"),Color3.fromRGB(50,50,76),8,function()Tw(MP,{Position=UDim2.new(0.5,-PW/2,1.5,0)},.28,Enum.EasingStyle.Back,Enum.EasingDirection.In);task.delay(.32,function()MP.Visible=false end)end)
SecH(PG.Set,T("langSec"),9)
local langB=Btn(PG.Set,T("langBtn"),Color3.fromRGB(30,76,158),10,nil)
local verL=Instance.new("TextLabel");verL.Size=UDim2.new(1,0,0,18);verL.BackgroundTransparency=1;verL.Font=Enum.Font.Gotham;verL.Text=T("ver");verL.TextColor3=C.Sub;verL.TextSize=9;verL.LayoutOrder=11;verL.Parent=PG.Set

-- تغيير اللغة
langB.MouseButton1Click:Connect(function()
	Lang=Lang=="AR"and"EN"or"AR"
	-- تحديث النصوص
	TL.Text=T("title");hS.Text=T("welcome")
	local txts_ar={"رئيسية","حركة","حفظ","لاعبين","رادار","إضافات","وقت","إعدادات"}
	local txts_en={"Home","Move","Saves","Players","Radar","Extras","Time","Settings"}
	local txts=Lang=="AR"and txts_ar or txts_en
	for i,nb in ipairs(NavBtns) do nb.tx.Text=txts[i]end
	mHT.Text=T("movTitle");mHS.Text=T("movSub")
	if flyLbl then flyLbl.Text=T("flyTog")end
	if fslL then fslL.Text=T("flySpd")end
	if ncLbl then ncLbl.Text=T("ncTog")end
	if wslL then wslL.Text=T("walkSpd")end
	if jslL then jslL.Text=T("jumpPow")end
	if espLbl then espLbl.Text=T("espTog")end
	espIL.Text=T("espInfo");if volL then volL.Text=T("vol")end
	if invisLbl then invisLbl.Text=T("invisTog")end
	invIL.Text=T("invisInfo");outIL.Text=T("outfitInfo")
	if timeLbl then timeLbl.Text=T("timeTog")end
	if tslL then tslL.Text=T("timeSpd")end
	auraIL.Text=T("auraInfo");if aTogLbl then aTogLbl.Text=T("auraTog")end
	if afkLbl then afkLbl.Text=T("afkTog")end
	langB.Text=T("langBtn");verL.Text=T("ver")
	if not AuraActive then AuraLbl.Text=T("auraOff")end
	Tw(langB,{Size=UDim2.new(.95,0,0,BH-2)},.07);task.delay(.07,function()Tw(langB,{Size=UDim2.new(1,0,0,BH)},.1)end)
end)

-- ============================================================
-- تشغيل
-- ============================================================
ShowPage("Home")
NavBtns[1].set(true)
MP.Position=UDim2.new(0.5,-PW/2,1.5,0)
Tw(MP,{Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)},.42,Enum.EasingStyle.Back)

-- ============================================================
-- END  |  THAER X100 v2.0
-- ============================================================
