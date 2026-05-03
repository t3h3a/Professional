-- Physics_Module.lua
local Physics = {}

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
local flightGyro     = nil
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

	Physics.disableGhost() -- منع التداخل
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

	flightGyro = Instance.new("BodyGyro")
	flightGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	flightGyro.P = 1e4
	flightGyro.Parent = root

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
		flightGyro.CFrame = camCF
	end)
end

function Physics.disableFlight()
	if not flightActive then return end
	flightActive = false

	if flightConn then flightConn:Disconnect(); flightConn = nil end
	if flightVelocity then flightVelocity:Destroy(); flightVelocity = nil end
	if flightGyro then flightGyro:Destroy(); flightGyro = nil end

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

	local parts = {}
	local char = LocalPlayer.Character
	if char then
		for _, v in char:GetDescendants() do if v:IsA("BasePart") then table.insert(parts, v) end end
	end
	
	if #parts == 0 then ghostActive = false return end

	Physics.disableFlight() -- منع التداخل
	ghostLoop = RunService.Stepped:Connect(function()
		for _, part in ipairs(parts) do
			if part.Parent and part.CanCollide then
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

return Physics
