--====================================
-- CEBOL MOD V2
-- Growblox | Delta Executor
--====================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- CLEAN OLD GUI
pcall(function()
    local old = CoreGui:FindFirstChild("CEBOL_MOD")
    if old then old:Destroy() end
end)

pcall(function()
    local old = Player.PlayerGui:FindFirstChild("CEBOL_MOD")
    if old then old:Destroy() end
end)

-- COLORS
local PURPLE = Color3.fromRGB(135,75,255)
local DARK = Color3.fromRGB(24,22,34)
local PANEL = Color3.fromRGB(37,34,49)
local WHITE = Color3.fromRGB(255,255,255)

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "CEBOL_MOD"
GUI.ResetOnSpawn = false
GUI.DisplayOrder = 999
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loaded = pcall(function()
    GUI.Parent = CoreGui
end)

if not loaded or not GUI.Parent then
    GUI.Parent = Player:WaitForChild("PlayerGui")
end

-- RESPONSIVE SCALE
local Scale = Instance.new("UIScale")
Scale.Parent = GUI

local camera = workspace.CurrentCamera

local function UpdateScale()
    if camera then
        local size = camera.ViewportSize
        Scale.Scale = math.clamp(
            math.min(size.X/900,size.Y/500),
            0.55,
            1
        )
    end
end

UpdateScale()

-- HELPER
local function New(class,props,parent)
    local obj = Instance.new(class)

    for k,v in pairs(props) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function Round(obj,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end

-- MAIN
local Main = New("Frame",{
    Name = "Main",
    Size = UDim2.fromOffset(850,460),
    Position = UDim2.new(0.5,-425,0.5,-230),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0
},GUI)

Round(Main,20)

-- HEADER
local Header = New("Frame",{
    Size = UDim2.new(1,0,0,42),
    BackgroundTransparency = 1
},Main)

-- TITLE
New("TextLabel",{
    Size = UDim2.new(0,200,1,0),
    Position = UDim2.fromOffset(75,0),
    BackgroundTransparency = 1,
    Text = "CEBOL MOD V2",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
