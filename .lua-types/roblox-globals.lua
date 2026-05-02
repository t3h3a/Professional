---@meta

---@class RBXScriptConnection
local RBXScriptConnection = {}

function RBXScriptConnection:Disconnect() end

---@class RBXScriptSignal
local RBXScriptSignal = {}

---@param callback fun(...: any)
---@return RBXScriptConnection
function RBXScriptSignal:Connect(callback) end

---@return any
function RBXScriptSignal:Wait() end

---@class EnumItem
---@field Name string
---@field Value number
local EnumItem = {}

---@class EnumKeyCode
---@field A EnumItem
---@field D EnumItem
---@field E EnumItem
---@field S EnumItem
---@field W EnumItem
---@field Space EnumItem
---@field LeftShift EnumItem
local EnumKeyCode = {}

---@type { KeyCode: EnumKeyCode }
Enum = {}

---@class Vector3
---@field X number
---@field Y number
---@field Z number
---@field Magnitude number
---@operator add(Vector3): Vector3
---@operator sub(Vector3): Vector3
---@operator mul(number): Vector3
---@operator div(number): Vector3
local Vector3Class = {}

---@type { new: fun(x: number, y: number, z: number): Vector3 }
Vector3 = {}

---@class CFrame
---@field Position Vector3
---@operator add(Vector3): CFrame
---@operator sub(Vector3): CFrame
local CFrameClass = {}

---@type { new: fun(...: any): CFrame }
CFrame = {}

---@class Instance
---@field Name string
---@field Parent Instance?
---@field CanCollide boolean
---@field CFrame CFrame
---@field Position Vector3
---@field Character Model?
---@field HumanoidRootPart BasePart?
local InstanceClass = {}

---@param name string
---@return Instance?
function InstanceClass:FindFirstChild(name) end

---@param name string
---@param timeout number?
---@return Instance
function InstanceClass:WaitForChild(name, timeout) end

---@return Instance[]
function InstanceClass:GetDescendants() end

---@param className string
---@return boolean
function InstanceClass:IsA(className) end

function InstanceClass:Destroy() end

---@class BasePart : Instance
---@field CanCollide boolean
---@field CFrame CFrame
---@field Position Vector3
local BasePart = {}

---@class Model : Instance
local Model = {}

---@class Humanoid : Instance
local Humanoid = {}

---@class BodyVelocity : Instance
---@field MaxForce Vector3
---@field Velocity Vector3
local BodyVelocity = {}

---@type { new: fun(className: string, parent?: Instance): Instance }
Instance = {}

---@class Player : Instance
---@field Character Model?
---@field CharacterAdded RBXScriptSignal
local Player = {}

---@class Players : Instance
---@field LocalPlayer Player
local Players = {}

---@return Player[]
function Players:GetPlayers() end

---@class HttpService : Instance
local HttpService = {}

---@param url string
---@param nocache boolean?
---@param headers table?
---@return string
function HttpService:GetAsync(url, nocache, headers) end

---@param url string
---@param data string
---@param contentType any?
---@param compress boolean?
---@param headers table?
---@return string
function HttpService:PostAsync(url, data, contentType, compress, headers) end

---@param value any
---@return string
function HttpService:JSONEncode(value) end

---@param json string
---@return any
function HttpService:JSONDecode(json) end

---@param wrapInCurlyBraces boolean?
---@return string
function HttpService:GenerateGUID(wrapInCurlyBraces) end

---@class RunService : Instance
---@field RenderStepped RBXScriptSignal
---@field Stepped RBXScriptSignal
---@field Heartbeat RBXScriptSignal
local RunService = {}

---@return boolean
function RunService:IsClient() end

---@return boolean
function RunService:IsServer() end

---@class UserInputService : Instance
---@field InputBegan RBXScriptSignal
---@field InputEnded RBXScriptSignal
local UserInputService = {}

---@class TweenService : Instance
local TweenService = {}

---@class VirtualUser : Instance
local VirtualUser = {}

---@class TeleportService : Instance
local TeleportService = {}

---@class Workspace : Instance
local Workspace = {}

---@class Script : Instance
local Script = {}

---@class DataModel : Instance
local DataModel = {}

---@overload fun(self: DataModel, serviceName: '"Players"'): Players
---@overload fun(self: DataModel, serviceName: '"HttpService"'): HttpService
---@overload fun(self: DataModel, serviceName: '"RunService"'): RunService
---@overload fun(self: DataModel, serviceName: '"UserInputService"'): UserInputService
---@overload fun(self: DataModel, serviceName: '"TweenService"'): TweenService
---@overload fun(self: DataModel, serviceName: '"VirtualUser"'): VirtualUser
---@overload fun(self: DataModel, serviceName: '"TeleportService"'): TeleportService
---@param serviceName string
---@return Instance
function DataModel:GetService(serviceName) end

---@param url string
---@param nocache boolean?
---@return string
function DataModel:HttpGet(url, nocache) end

---@param url string
---@param data string
---@return string
function DataModel:HttpPost(url, data) end

---@type DataModel
game = {}

---@type Workspace
workspace = {}

---@type Script
script = {}

---@param chunk string
---@param chunkname string?
---@return fun(...: any): any
function loadstring(chunk, chunkname) end

---@param message any
function warn(message) end

---@param seconds number?
---@return number
function wait(seconds) end

---@class task
task = {}

---@param callback fun()
function task.spawn(callback) end

---@param seconds number
function task.wait(seconds) end
