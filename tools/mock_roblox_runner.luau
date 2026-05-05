local fs = require("@lune/fs")
local process = require("@lune/process")

-- Local smoke runner for Roblox LocalScripts.
-- This does not emulate rendering or networking; it only provides enough Roblox-like APIs
-- to load the admin panel outside Roblox and catch early runtime errors.

local function makeSignal()
    local signal = {
        _connections = {},
    }

    function signal:Connect(callback)
        table.insert(self._connections, callback)
        return {
            Disconnect = function()
            end,
        }
    end

    function signal:Wait()
        return nil
    end

    function signal:Fire(...)
        for _, callback in ipairs(self._connections) do
            callback(...)
        end
    end

    return signal
end

local function enumGroup(groupName)
    return setmetatable({}, {
        __index = function(_, itemName)
            return groupName .. "." .. tostring(itemName)
        end,
    })
end

Enum = setmetatable({}, {
    __index = function(_, groupName)
        return enumGroup(tostring(groupName))
    end,
})

local Vector3Meta = {}
Vector3Meta.__index = function(value, key)
    if key == "Magnitude" then
        return math.sqrt(value.X * value.X + value.Y * value.Y + value.Z * value.Z)
    end
    if key == "Unit" then
        local mag = value.Magnitude
        if mag <= 0 then
            return Vector3.new(0, 0, 0)
        end
        return Vector3.new(value.X / mag, value.Y / mag, value.Z / mag)
    end
    if key == "Lerp" then
        return function(self, goal, alpha)
            return self + (goal - self) * alpha
        end
    end
    return rawget(Vector3Meta, key)
end
Vector3Meta.__add = function(a, b)
    return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
Vector3Meta.__sub = function(a, b)
    return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
Vector3Meta.__mul = function(a, b)
    if type(a) == "number" then
        return Vector3.new(a * b.X, a * b.Y, a * b.Z)
    end
    return Vector3.new(a.X * b, a.Y * b, a.Z * b)
end
Vector3Meta.__div = function(a, b)
    return Vector3.new(a.X / b, a.Y / b, a.Z / b)
end

Vector3 = {}
function Vector3.new(x, y, z)
    return setmetatable({ X = x or 0, Y = y or 0, Z = z or 0 }, Vector3Meta)
end
Vector3.zero = Vector3.new(0, 0, 0)

local Vector2Meta = {}
Vector2Meta.__sub = function(a, b)
    return Vector2.new(a.X - b.X, a.Y - b.Y)
end

Vector2 = {}
function Vector2.new(x, y)
    return setmetatable({ X = x or 0, Y = y or 0 }, Vector2Meta)
end

local CFrameMeta = {}
CFrameMeta.__index = function(value, key)
    if key == "LookVector" then
        return value._look or Vector3.new(0, 0, -1)
    end
    if key == "RightVector" then
        return Vector3.new(1, 0, 0)
    end
    if key == "Lerp" then
        return function(self, goal, alpha)
            return CFrame.new(self.Position:Lerp(goal.Position, alpha))
        end
    end
    return rawget(CFrameMeta, key)
end
CFrameMeta.__add = function(cf, vec)
    return CFrame.new(cf.Position + vec)
end

CFrame = {}
function CFrame.new(a, b, c)
    local position
    if type(a) == "table" and a.X then
        position = a
    else
        position = Vector3.new(a or 0, b or 0, c or 0)
    end
    return setmetatable({
        Position = position,
        _look = Vector3.new(0, 0, -1),
    }, CFrameMeta)
end

UDim = {}
function UDim.new(scale, offset)
    return { Scale = scale or 0, Offset = offset or 0 }
end

UDim2 = {}
function UDim2.new(xScale, xOffset, yScale, yOffset)
    return {
        X = UDim.new(xScale, xOffset),
        Y = UDim.new(yScale, yOffset),
    }
end
function UDim2.fromScale(x, y)
    return UDim2.new(x, 0, y, 0)
end

local Color3Meta = {}
function Color3Meta:Lerp(goal, alpha)
    return Color3.new(
        self.R + (goal.R - self.R) * alpha,
        self.G + (goal.G - self.G) * alpha,
        self.B + (goal.B - self.B) * alpha
    )
end
Color3Meta.__index = Color3Meta

Color3 = {}
function Color3.new(r, g, b)
    return setmetatable({ R = r or 0, G = g or 0, B = b or 0 }, Color3Meta)
end
function Color3.fromRGB(r, g, b)
    return Color3.new((r or 0) / 255, (g or 0) / 255, (b or 0) / 255)
end

ColorSequence = {}
function ColorSequence.new(...)
    return { ... }
end

ColorSequenceKeypoint = {}
function ColorSequenceKeypoint.new(time, color)
    return { Time = time, Value = color }
end

TweenInfo = {}
function TweenInfo.new(...)
    return { ... }
end

local eventNames = {
    MouseButton1Click = true,
    MouseEnter = true,
    MouseLeave = true,
    InputBegan = true,
    InputChanged = true,
    InputEnded = true,
    Focused = true,
    FocusLost = true,
    Changed = true,
}

local objectMethods = {}

local ObjectMeta = {}
ObjectMeta.__index = function(self, key)
    local method = objectMethods[key]
    if method then
        return method
    end
    if eventNames[key] then
        local signal = makeSignal()
        rawset(self, key, signal)
        return signal
    end
    if key == "AbsolutePosition" then
        return Vector2.new(0, 0)
    end
    if key == "AbsoluteSize" then
        return Vector2.new(100, 20)
    end
    return rawget(self, key)
end

ObjectMeta.__newindex = function(self, key, value)
    if key == "Parent" then
        local oldParent = rawget(self, "Parent")
        if oldParent and oldParent._children then
            for index, child in ipairs(oldParent._children) do
                if child == self then
                    table.remove(oldParent._children, index)
                    break
                end
            end
        end
        rawset(self, key, value)
        if value and value._children then
            table.insert(value._children, self)
        end
        return
    end
    rawset(self, key, value)
end

local function newObject(className, name)
    local object = setmetatable({
        ClassName = className,
        Name = name or className,
        _children = {},
    }, ObjectMeta)

    if className == "Part" or className == "BasePart" then
        object.Size = Vector3.new(2, 2, 1)
        object.CFrame = CFrame.new(0, 5, 0)
        object.Position = object.CFrame.Position
        object.AssemblyLinearVelocity = Vector3.zero
        object.Anchored = false
    end

    return object
end

function objectMethods:IsA(className)
    if self.ClassName == className then
        return true
    end
    if className == "BasePart" and (self.ClassName == "Part" or self.Name == "HumanoidRootPart") then
        return true
    end
    return false
end

function objectMethods:GetChildren()
    return self._children
end

function objectMethods:GetDescendants()
    local descendants = {}
    local function visit(node)
        for _, child in ipairs(node._children or {}) do
            table.insert(descendants, child)
            visit(child)
        end
    end
    visit(self)
    return descendants
end

function objectMethods:FindFirstChild(name)
    for _, child in ipairs(self._children or {}) do
        if child.Name == name then
            return child
        end
    end
    return nil
end

function objectMethods:FindFirstChildOfClass(className)
    for _, child in ipairs(self._children or {}) do
        if child:IsA(className) then
            return child
        end
    end
    return nil
end

function objectMethods:WaitForChild(name)
    return self:FindFirstChild(name)
end

function objectMethods:Destroy()
    self.Parent = nil
    self._destroyed = true
end

function objectMethods:Clone()
    local clone = newObject(self.ClassName, self.Name)
    for key, value in pairs(self) do
        if key ~= "_children" and key ~= "Parent" then
            clone[key] = value
        end
    end
    for _, child in ipairs(self._children or {}) do
        local childClone = child:Clone()
        childClone.Parent = clone
    end
    return clone
end

function objectMethods:GetAppliedDescription()
    return { Source = "mock" }
end

function objectMethods:ApplyDescription()
end

function objectMethods:BuildRigFromAttachments()
end

function objectMethods:ChangeState(state)
    self.State = state
end

function objectMethods:Play()
end

function objectMethods:Stop()
end

function objectMethods:CaptureController()
end

function objectMethods:ClickButton2()
end

Instance = {}
function Instance.new(className)
    return newObject(className)
end

local playerGui = newObject("PlayerGui", "PlayerGui")
local character = newObject("Model", "Character")
local hrp = newObject("Part", "HumanoidRootPart")
hrp.Parent = character
local humanoid = newObject("Humanoid", "Humanoid")
humanoid.Health = 100
humanoid.WalkSpeed = 16
humanoid.JumpPower = 50
humanoid.Parent = character

local localPlayer = newObject("Player", "LocalPlayer")
localPlayer.Name = "LocalPlayer"
localPlayer.DisplayName = "LocalPlayer"
localPlayer.UserId = 1
localPlayer.Character = character
localPlayer.PlayerGui = playerGui
localPlayer.Idled = makeSignal()
localPlayer.CharacterAdded = makeSignal()

local services = {}

services.Players = {
    LocalPlayer = localPlayer,
    PlayerAdded = makeSignal(),
    PlayerRemoving = makeSignal(),
    GetPlayers = function()
        return { localPlayer }
    end,
    GetHumanoidDescriptionFromUserId = function()
        return { Source = "mock-user" }
    end,
}

services.RunService = {
    Heartbeat = makeSignal(),
    Stepped = makeSignal(),
    RenderStepped = makeSignal(),
}

services.TweenService = {
    Create = function(_, object, _, props)
        return {
            Play = function()
                for key, value in pairs(props) do
                    object[key] = value
                end
            end,
        }
    end,
}

services.UserInputService = {
    InputBegan = makeSignal(),
    InputChanged = makeSignal(),
    InputEnded = makeSignal(),
    IsKeyDown = function()
        return false
    end,
}

services.HttpService = {
    JSONEncode = function()
        return "{}"
    end,
    JSONDecode = function()
        return {}
    end,
}

services.SoundService = newObject("SoundService", "SoundService")

local camera = newObject("Camera", "Camera")
camera.CFrame = CFrame.new(0, 5, 10)
camera.CameraType = Enum.CameraType.Custom
services.Workspace = newObject("Workspace", "Workspace")
services.Workspace.CurrentCamera = camera

services.Lighting = {
    ClockTime = 12,
}

services.GuiService = {
    OpenBrowserWindow = function()
    end,
}

services.Chat = {}
services.VirtualUser = newObject("VirtualUser", "VirtualUser")
services.TextChatService = {
    MessageReceived = makeSignal(),
}

game = {
    GetService = function(_, serviceName)
        local service = services[serviceName]
        if not service then
            service = {}
            services[serviceName] = service
        end
        return service
    end,
    HttpGet = function()
        return ""
    end,
}

workspace = services.Workspace

local deferred = {}
task = {
    spawn = function(callback, ...)
        local args = { ... }
        local ok, err = pcall(function()
            callback(table.unpack(args))
        end)
        if not ok then
            error(err, 2)
        end
    end,
    defer = function(callback, ...)
        table.insert(deferred, { callback, { ... } })
    end,
    delay = function()
    end,
    wait = function()
        return 0
    end,
}

local scriptSource = fs.readFile("script.lua")
local scriptChunk, loadErr = loadstring(scriptSource, "script.lua")

if not scriptChunk then
    print("[mock-runner] script.lua could not be compiled:")
    print(tostring(loadErr))
    process.exit(1)
end

local ok, err = pcall(scriptChunk)

if not ok then
    print("[mock-runner] script.lua failed:")
    print(tostring(err))
    process.exit(1)
end

for _, item in ipairs(deferred) do
    item[1](table.unpack(item[2]))
end

print("[mock-runner] script.lua loaded successfully outside Roblox")
