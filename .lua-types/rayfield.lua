---@meta

---@class RayfieldKeySettings
---@field Title string?
---@field Subtitle string?
---@field Note string?
---@field FileName string?
---@field SaveKey boolean?
---@field GrabKeyFromSite boolean?
---@field Key string|string[]?

---@class RayfieldWindowConfig
---@field Name string
---@field LoadingTitle string?
---@field LoadingSubtitle string?
---@field ConfigurationSaving table?
---@field Discord table?
---@field KeySystem boolean?
---@field KeySettings RayfieldKeySettings?

---@class RayfieldNotifyOptions
---@field Title string
---@field Content string
---@field Duration number?
---@field Image string|number?
---@field Icon string|number?
---@field Actions table?

---@class RayfieldButtonOptions
---@field Name string
---@field Callback fun()?

---@class RayfieldSliderOptions
---@field Name string
---@field Range number[]
---@field Increment number?
---@field Suffix string?
---@field CurrentValue number?
---@field Flag string?
---@field Callback fun(value: number)?

---@class RayfieldKeybindOptions
---@field Name string
---@field CurrentKeybind string|EnumItem|string[]?
---@field HoldToInteract boolean?
---@field Flag string?
---@field Callback fun(key: string|EnumItem)?

---@class RayfieldInputOptions
---@field Name string
---@field PlaceholderText string?
---@field RemoveTextAfterFocusLost boolean?
---@field Flag string?
---@field Callback fun(text: string)?

---@class RayfieldParagraphOptions
---@field Title string
---@field Content string

---@class RayfieldToggleOptions
---@field Name string
---@field CurrentValue boolean?
---@field Flag string?
---@field Callback fun(value: boolean)?

---@class RayfieldDropdownOptions
---@field Name string
---@field Options string[]
---@field CurrentOption string|string[]?
---@field MultipleOptions boolean?
---@field Flag string?
---@field Callback fun(option: string|string[])?

---@class RayfieldWindow
local RayfieldWindow = {}

---@param name string
---@param image string|number?
---@return RayfieldTab
function RayfieldWindow:CreateTab(name, image) end

---@class RayfieldTab
local RayfieldTab = {}

---@param name string
---@return any
function RayfieldTab:CreateSection(name) end

---@param options RayfieldButtonOptions
---@return any
function RayfieldTab:CreateButton(options) end

---@param options RayfieldSliderOptions
---@return any
function RayfieldTab:CreateSlider(options) end

---@param options RayfieldKeybindOptions
---@return any
function RayfieldTab:CreateKeybind(options) end

---@param options RayfieldInputOptions
---@return any
function RayfieldTab:CreateInput(options) end

---@param options RayfieldParagraphOptions
---@return any
function RayfieldTab:CreateParagraph(options) end

---@param options RayfieldToggleOptions
---@return any
function RayfieldTab:CreateToggle(options) end

---@param options RayfieldDropdownOptions
---@return any
function RayfieldTab:CreateDropdown(options) end

---@class Rayfield
local RayfieldClass = {}

---@param options RayfieldWindowConfig
---@return RayfieldWindow
function RayfieldClass:CreateWindow(options) end

---@return RayfieldWindow
function RayfieldClass:GetWindow() end

---@param options RayfieldNotifyOptions
function RayfieldClass:Notify(options) end

function RayfieldClass:LoadConfiguration() end

---@type Rayfield
Rayfield = {}
