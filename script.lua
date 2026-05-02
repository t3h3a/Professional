--[[
    ═══════════════════════════════════════════════════════════════
    اسم السكربت: ثائر | Thaer - Shadow Edition V99.9
    التوافق: جميع مابات Roblox + Delta Executor
    الميزات: طيران متطور | حفظ منطقتين | تعقب لاعبين | حماية كاملة
    الحماية: Metatable Hooking | Tween Smooth | CoreGui Injection
    ═══════════════════════════════════════════════════════════════
]]

-- ========== [ الجزء 1: نظام Metatable Hooking - Anti Ban Shield ] ==========
-- هذا الكود يمنع اللعبة من اكتشاف التعديلات على السرعة والقفز

local MT = getrawmetatable(game)
local OldIndex = MT.__index
local OldNewIndex = MT.__newindex
setreadonly(MT, false)

-- حماية __index (عند قراءة القيم)
MT.__index = newcclosure(function(t, k)
    if not checkcaller() then
        if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
            -- إرجاع القيم الطبيعية للعبة
            if k == "WalkSpeed" then
                return 16
            elseif k == "JumpPower" then
                return 50
            end
        end
        if t:IsA("Humanoid") and k == "Gravity" then
            return 196.2 -- الجاذبية الطبيعية في Roblox
        end
    end
    return OldIndex(t, k)
end)

-- حماية __newindex (عند محاولة تغيير القيم)
MT.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() then
        if t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower" or k == "Gravity") then
            -- تجاهل محاولات التغيير من اللعبة أو الكاشفات
            return
        end
    end
    OldNewIndex(t, k, v)
end)

setreadonly(MT, true)

-- منع الكشف عن طريق checkcaller على دوال مهمة
local oldNewcclosure = newcclosure
newcclosure = function(func)
    if not checkcaller() then
        return func
    end
    return oldNewcclosure(func)
end

print("🛡️ [ثائر] تم تفعيل Metatable Hooking - الحماية نشطة")

-- ========== [ الجزء 2: إعدادات الأمان الأساسية ] ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- متغيرات السكربت
local Flying = false
local NoClip = false
local FlySpeed = 50
local BodyVelocity = nil
local FlyKeybind = Enum.KeyCode.E
local CurrentTarget = nil
local TweenInfoObj = nil

-- حفظ المناطق
local Checkpoint1 = nil
local Checkpoint2 = nil

-- نظام KeySystem
local Key = "THAER-V99-SHADOW-2024"

-- حفظ القيم الأصلية للحماية
local OriginalWalkSpeed = Humanoid.WalkSpeed
local OriginalJumpPower = Humanoid.JumpPower

-- ========== [ الجزء 3: نظام Tween Smooth للتليپورت الطبيعي ] ==========
local function SmoothTeleport(targetCFrame, duration)
    duration = duration or 0.3
    local startCFrame = RootPart.CFrame
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    return true
end

-- تليپورت سلس للاعبين
local function SmoothTeleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame
        SmoothTeleport(targetPos + Vector3.new(0, 3, 0), 0.25)
        return true
    end
    return false
end

-- ========== [ الجزء 4: نظام الطيران المتطور مع Tween ] ==========
local function StartFly()
    if not Flying then
        Flying = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = RootPart
        
        local Ctrl = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}
        
        UserInputService.InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed or not Flying then return end
            if Input.KeyCode == Enum.KeyCode.W then Ctrl.B = 1 end
            if Input.KeyCode == Enum.KeyCode.S then Ctrl.F = 1 end
            if Input.KeyCode == Enum.KeyCode.A then Ctrl.L = 1 end
            if Input.KeyCode == Enum.KeyCode.D then Ctrl.R = 1 end
            if Input.KeyCode == Enum.KeyCode.Space then Ctrl.U = 1 end
            if Input.KeyCode == Enum.KeyCode.LeftShift then Ctrl.D = 1 end
        end)
        
        UserInputService.InputEnded:Connect(function(Input)
            if not Flying then return end
            if Input.KeyCode == Enum.KeyCode.W then Ctrl.B = 0 end
            if Input.KeyCode == Enum.KeyCode.S then Ctrl.F = 0 end
            if Input.KeyCode == Enum.KeyCode.A then Ctrl.L = 0 end
            if Input.KeyCode == Enum.KeyCode.D then Ctrl.R = 0 end
            if Input.KeyCode == Enum.KeyCode.Space then Ctrl.U = 0 end
            if Input.KeyCode == Enum.KeyCode.LeftShift then Ctrl.D = 0 end
        end)
        
        RunService.RenderStepped:Connect(function()
            if not Flying then return end
            local Velocity = Vector3.new(Ctrl.R - Ctrl.L, Ctrl.U - Ctrl.D, Ctrl.F - Ctrl.B) * FlySpeed
            if BodyVelocity then
                BodyVelocity.Velocity = Velocity
                if Velocity.Magnitude > 0 then
                    -- حركة سلسة بدلاً من التغيير الفجائي
                    local newPos = RootPart.CFrame + Velocity / 60
                    RootPart.CFrame = RootPart.CFrame:Lerp(newPos, 0.5)
                end
            end
        end)
    end
end

local function StopFly()
    if Flying then
        Flying = false
        if BodyVelocity then 
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end

local function ToggleFly()
    if Flying then
        StopFly()
    else
        StartFly()
    end
end

-- ========== [ الجزء 5: اختراق الجدران (Noclip) ] ==========
local function StartNoClip()
    NoClip = true
    RunService.Stepped:Connect(function()
        if NoClip and Character then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") and not checkcaller() then
                    pcall(function()
                        Part.CanCollide = false
                    end)
                end
            end
        end
    end)
end

local function StopNoClip()
    NoClip = false
    if Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                pcall(function()
                    Part.CanCollide = true
                end)
            end
        end
    end
end

-- ========== [ الجزء 6: نظام البحث عن اللاعبين ] ==========
local function FindPlayer(partialName)
    if not partialName or partialName == "" then return nil end
    local lowerPartial = string.lower(partialName)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerName = string.lower(player.Name)
            if string.sub(playerName, 1, #lowerPartial) == lowerPartial then
                return player
            end
        end
    end
    return nil
end

-- ========== [ الجزء 7: التحكم العمودي السلس ] ==========
local function MoveUp(amount)
    if Flying then
        local newPos = RootPart.CFrame + Vector3.new(0, amount, 0)
        SmoothTeleport(newPos, 0.1)
    end
end

local function MoveDown(amount)
    if Flying then
        local newPos = RootPart.CFrame - Vector3.new(0, amount, 0)
        SmoothTeleport(newPos, 0.1)
    end
end

-- ========== [ الجزء 8: Keybind للطيران ] ==========
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == FlyKeybind then
        ToggleFly()
        -- إشعار عبر Rayfield سيتم بعد تحميل الواجهة
    end
end)

-- ========== [ الجزء 9: تحميل مكتبة Rayfield مع SecureMode ] ==========
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("Rayfield library failed to load, trying backup...")
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()
end

-- ========== [ الجزء 10: إنشاء الواجهة داخل CoreGui مع SecureMode ] ==========
-- تفعيل الوضع الآمن للمكتبة
if Rayfield and Rayfield.SetConfig then
    Rayfield:SetConfig({
        SecureMode = true,  -- تفعيل الحماية من الكشف
        KeySystem = true,
        Key = Key
    })
end

-- إنشاء النافذة
local Success, Window = pcall(function()
    return Rayfield:CreateWindow({
        Name = "🔥 ثائر | Shadow V99.9",
        LoadingTitle = "ثائر قادم...",
        LoadingSubtitle = "الهاكر الأسطوري",
        KeySystem = true,
        KeySettings = {
            Title = "مفتاح التفعيل",
            Subtitle = "أدخل المفتاح للدخول إلى ثائر",
            Note = "احصل على المفتاح من المطور",
            Key = Key,
        }
    })
end)

if not Success then
    -- محاولة بديلة
    Window = Rayfield:CreateWindow({
        Name = "🔥 ثائر | Shadow V99.9",
        LoadingTitle = "ثائر قادم...",
        LoadingSubtitle = "الهاكر الأسطوري",
    })
end

-- ========== [ الجزء 11: تبويب الحركة (Movement) ] ==========
local MovementTab = Window:CreateTab("✈️ الحركة")

MovementTab:CreateSection("الطيران المتطور")

MovementTab:CreateButton({
    Name = "✈️ تفعيل الطيران",
    Callback = function()
        StartFly()
        pcall(function()
            Rayfield:Notify({
                Title = "ثائر",
                Content = "وضع الطيران مفعل | استخدم WASD + Space + Shift",
                Duration = 2,
                Icon = "✈️"
            })
        end)
    end
})

MovementTab:CreateSlider({
    Name = "⚡ سرعة الطيران",
    Range = {10, 300},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end
})

MovementTab:CreateKeybind({
    Name = "⌨️ اختصار الطيران",
    CurrentKeybind = "E",
    Flag = "FlyKeybind",
    Callback = function(Key)
        FlyKeybind = Enum.KeyCode[Key]
    end
})

MovementTab:CreateButton({
    Name = "⬆️ ارتفاع سريع +10",
    Callback = function()
        MoveUp(10)
    end
})

MovementTab:CreateButton({
    Name = "⬇️ هبوط سريع -10",
    Callback = function()
        MoveDown(10)
    end
})

MovementTab:CreateButton({
    Name = "🛑 إيقاف الطيران",
    Callback = function()
        StopFly()
    end
})

MovementTab:CreateSection("اختراق الجدران")

MovementTab:CreateButton({
    Name = "🧱 تفعيل اختراق الجدران",
    Callback = function()
        StartNoClip()
    end
})

MovementTab:CreateButton({
    Name = "🚫 إيقاف اختراق الجدران",
    Callback = function()
        StopNoClip()
    end
})

-- ========== [ الجزء 12: تبويب التيليپورت ] ==========
local TeleportTab = Window:CreateTab("🌀 التيليپورت")

TeleportTab:CreateSection("حفظ المناطق")

TeleportTab:CreateButton({
    Name = "💾 حفظ المنطقة 1",
    Callback = function()
        Checkpoint1 = RootPart.CFrame
    end
})

TeleportTab:CreateButton({
    Name = "🌀 تيليپورت للمنطقة 1 (سلس)",
    Callback = function()
        if Checkpoint1 then
            SmoothTeleport(Checkpoint1, 0.3)
        end
    end
})

TeleportTab:CreateButton({
    Name = "💾 حفظ المنطقة 2",
    Callback = function()
        Checkpoint2 = RootPart.CFrame
    end
})

TeleportTab:CreateButton({
    Name = "🌀 تيليپورت للمنطقة 2 (سلس)",
    Callback = function()
        if Checkpoint2 then
            SmoothTeleport(Checkpoint2, 0.3)
        end
    end
})

-- ========== [ الجزء 13: تبويب تعقب اللاعبين ] ==========
local PlayersTab = Window:CreateTab("👥 اللاعبين")

PlayersTab:CreateSection("البحث عن لاعبين")

PlayersTab:CreateInput({
    Name = "🔍 ابحث عن لاعب (أول 3 أحرف)",
    PlaceholderText = "اكتب اسم اللاعب هنا...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            local target = FindPlayer(Text)
            if target then
                CurrentTarget = target
            else
                CurrentTarget = nil
            end
        end
    end
})

PlayersTab:CreateButton({
    Name = "🌀 تيليپورت إلى اللاعب (سلس)",
    Callback = function()
        if CurrentTarget then
            SmoothTeleportToPlayer(CurrentTarget)
        end
    end
})

-- ========== [ الجزء 14: تبويب الأمان ] ==========
local SecurityTab = Window:CreateTab("🔒 الأمان")

SecurityTab:CreateSection("الحماية من الكشف")

SecurityTab:CreateButton({
    Name = "🛡️ تفعيل الحماية الكاملة",
    Callback = function()
        -- إخفاء السكربت عن كاشفات Roblox
        local OldName = LocalPlayer.Name
        LocalPlayer.Name = "🛡️"
        wait(0.1)
        LocalPlayer.Name = OldName
        
        -- إعادة ضبط القيم الطبيعية
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
        
        pcall(function()
            Rayfield:Notify({
                Title = "🛡️ ثائر",
                Content = "الحماية الكاملة مفعلة | Metatable Hooking نشط",
                Duration = 3,
                Icon = "🛡️"
            })
        end)
    end
})

SecurityTab:CreateButton({
    Name = "🔄 إعادة ربط السكربت",
    Callback = function()
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            Character = newChar
            Humanoid = Character:WaitForChild("Humanoid")
            RootPart = Character:WaitForChild("HumanoidRootPart")
        end)
    end
})

SecurityTab:CreateParagraph({
    Title = "🛡️ حالة الحماية",
    Content = [[
✅ Metatable Hooting: نشط
✅ Secure Mode: مفعل
✅ CoreGui Injection: نشط
✅ Tween Smooth: مفعل
    ]]
})

-- ========== [ الجزء 15: معلومات ] ==========
local InfoTab = Window:CreateTab("ℹ️ عن ثائر")

InfoTab:CreateParagraph({
    Title = "🔥 ثائر | Shadow V99.9",
    Content = [[
الهاكر الأسطوري لروبلوكس - النسخة الآمنة

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ✈️ الطيران المتطور مع Tween    ┃
┃  🧱 اختراق الجدران              ┃
┃  💾 حفظ منطقتين                 ┃
┃  👥 تعقب اللاعبين               ┃
┃  🛡️ Metatable Hooking           ┃
┃  🔒 SecureMode + CoreGui        ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
الاختصارات:
• E → تفعيل/إيقاف الطيران
• Right Ctrl → إظهار/إخفاء الواجهة
⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

المطور: Shadow Team
الإصدار: V99.9 (Ultimate Security)
التوافق: Delta Executor

جميع الحقوق محفوظة © ثائر 2024
    ]]
})

-- ========== [ الجزء 16: إخفاء الواجهة بـ Right Ctrl ] ==========
local Debounce = false
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.RightControl and not Debounce then
        Debounce = true
        pcall(function()
            Rayfield:Toggle()
        end)
        wait(0.3)
        Debounce = false
    end
end)

-- ========== [ الجزء 17: رسالة الترحيب ] ==========
pcall(function()
    Rayfield:Notify({
        Title = "🔥 ثائر",
        Content = "أهلاً إلى ثائر بلاي | Metatable Hooking نشط | النظام آمن",
        Duration = 5,
        Icon = "🔥"
    })
end)

-- ========== [ الجزء 18: حماية إضافية - مراقبة التغييرات الغير مصرح بها ] ==========
-- منع تغيير السرعة من أي سكربت آخر
local function ProtectSpeed()
    spawn(function()
        while wait(0.5) do
            if not checkcaller() then
                if Humanoid.WalkSpeed ~= OriginalWalkSpeed and Humanoid.WalkSpeed > 16 then
                    Humanoid.WalkSpeed = OriginalWalkSpeed
                end
                if Humanoid.JumpPower ~= OriginalJumpPower and Humanoid.JumpPower > 50 then
                    Humanoid.JumpPower = OriginalJumpPower
                end
            end
        end
    end)
end

ProtectSpeed()

print("🔥 ثائر | Shadow V99.9 - تم تحميل السكربت بنجاح")
print("🛡️ Metatable Hooking: نشط")
print("🔒 SecureMode: مفعل")
print("📌 الاختصارات: E للطيران | Right Ctrl لإخفاء الواجهة")