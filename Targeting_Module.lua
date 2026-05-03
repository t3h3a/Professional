-- Targeting_Module.lua
local Targeting = {}

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

return Targeting
