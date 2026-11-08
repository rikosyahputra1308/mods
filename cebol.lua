--================================
-- CEBOL MOD V3
-- GROWBLOX GUI
--================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- HAPUS GUI LAMA
local Old = PlayerGui:FindFirstChild("CEBOL_MOD")
if Old then
    Old:Destroy()
end

-- WARNA
local Purple = Color3.fromRGB(140, 75, 255)
local Dark = Color3.fromRGB(23, 22, 32)
local Panel = Color3.fromRGB(38, 35, 49)
local White = Color3.fromRGB(255,255,255)

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "CEBOL_MOD"
GUI.ResetOnSpawn = false
GUI.Parent = PlayerGui

-- FUNGSI
local function Create(class, parent, props)
    local obj = Instance.new(class)

    for k,v in pairs(props) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = obj
end

-- MAIN
local Main = Create("Frame",GUI,{
    Name = "Main",
    Size = UDim2.new(0,850,0,460),
    Position = UDim2.new(0.5,-425,0.5,-230),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0
})

Corner(Main,15)

-- HEADER
local Header = Create("Frame",Main,{
    Size = UDim2.new(1,0,0,42),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0
})

-- TITLE
Create("TextLabel",Header,{
    Size = UDim2.new(0,250,1,0),
    Position = UDim2.new(0,15,
