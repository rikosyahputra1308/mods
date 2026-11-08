--==================================
-- CEBOL MOD | GROWBLOX
-- UI DESIGN V1.0
--==================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Parent = game:GetService("CoreGui")

local GUI = Instance.new("ScreenGui")
GUI.Name = "CEBOL_MOD"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    GUI.Parent = Parent
end)

if not GUI.Parent then
    GUI.Parent = Player.PlayerGui
end

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function Create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local Purple = Color3.fromRGB(133, 75, 255)
local Dark = Color3.fromRGB(27, 25, 38)
local Panel = Color3.fromRGB(35, 32, 47)
local White = Color3.fromRGB(245,245,255)

-- MAIN WINDOW

local Main = Create("Frame", {
    Size = UDim2.new(0, 850, 0, 460),
    Position = UDim2.new(0.5,-425,0.5,-230),
    BackgroundColor3 = Color3.fromRGB(18,17,27),
    BorderSizePixel = 0
}, GUI)

Corner(Main,18)

-- DRAG WINDOW

local dragging = false
local dragStart, startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- SIDEBAR

local Side = Create("Frame", {
    Size = UDim2.new(0,65,1,0),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0
},Main)

Corner(Side,15)

local function SideButton(icon,y)
    local b = Create("TextButton",{
        Size = UDim2.new(0,48,0,42),
        Position = UDim2.new(0,8,0,y),
        BackgroundColor3 = Dark,
        Text = icon,
        TextSize = 21,
        TextColor3 = White,
        BorderSizePixel = 0
    },Side)

    Corner(b,12)
    return b
end

local tabs = {
    "⌘",
    "⟳",
    "◉",
    "◈",
    "⚙",
    "☷",
    "▤"
}

for i,v in ipairs(tabs) do
    SideButton(v,15+(i-1)*55)
end

-- CENTER PANEL

local Center = Create("Frame",{
    Size = UDim2.new(0,245,1,0),
    Position = UDim2.new(0,72,0,0),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0
},Main)

Corner(Center,18)

Create("TextLabel",{
    Size = UDim2.new(1,0,0,45),
    BackgroundTransparency = 1,
    Text = "Automation",
    TextColor3 = White,
    TextSize = 19,
    Font = Enum.Font.GothamBold
},Center)

local function MenuItem(name,desc,y)
    local b = Create("TextButton",{
        Size = UDim2.new(1,-18,0,65),
        Position = UDim2.new(0,9,0,y),
        BackgroundColor3 = Panel,
        Text = "",
        BorderSizePixel = 0
    },Center)

    Corner(b,14)

    Create("TextLabel",{
        Size = UDim2.new(1,-20,0,25),
        Position = UDim2.new(0,12,0,7),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = White,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    },b)

    Create("TextLabel",{
        Size = UDim2.new(1,-20,0,25),
        Position = UDim2.new(0,12,0,32),
        BackgroundTransparency = 1,
        Text = desc,
        TextColor3 = Color3.fromRGB(165,160,180),
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    },b)

    return b
end

MenuItem("Spammer","Automatically send chat",55)
MenuItem("Autofarm","Automatically farming",126)
MenuItem("Automation","Auto plant and harvest",197)
MenuItem("Collect","Automatically collect items",268)
MenuItem("Fishing","Automatically pull fish",339)

-- RIGHT PANEL

local Right = Create("Frame",{
    Size = UDim2.new(0,235,1,-16),
    Position = UDim2.new(1,-243,0,8),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0
},Main)

Corner(Right,18)

Create("TextLabel",{
    Size = UDim2.new(1,0,0,48),
    BackgroundTransparency = 1,
    Text = "🤖  Autofarm",
    TextColor3 = White,
    TextSize = 19,
    Font = Enum.Font.GothamBold
},Right)

-- BLOCK SELECT

local Block = Create("TextButton",{
    Size = UDim2.new(1,-20,0,52),
    Position = UDim2.new(0,10,0,55),
    BackgroundColor3 = Panel,
    Text = "Block to break     ✎\nRose",
    TextColor3 = White,
    TextSize = 13,
    Font = Enum.Font.GothamBold
},Right)

Corner(Block,12)

-- GRID TITLE

Create("TextLabel",{
    Size = UDim2.new(1,-20,0,28),
    Position = UDim2.new(0,10,0,115),
    BackgroundTransparency = 1,
    Text = "Select tile to break",
    TextColor3 = White,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold
},Right)

-- GRID 5x5

local selected = {}

local Grid = Create("Frame",{
    Size = UDim2.new(1,-20,0,210),
    Position = UDim2.new(0,10,0,145),
    BackgroundTransparency = 1
},Right)

local layout = Create("UIGridLayout",{
    CellSize = UDim2.new(0,40,0,40),
    CellPadding = UDim2.new(0,5,0,5),
    SortOrder = Enum.SortOrder.LayoutOrder
},Grid)

for i = 1,25 do
    local tile = Create("TextButton",{
        BackgroundColor3 = Panel,
        Text = "",
        BorderSizePixel = 0,
        LayoutOrder = i
    },Grid)

    Corner(tile,7)

    tile.MouseButton1Click:Connect(function()
        selected[i] = not selected[i]

        tile.BackgroundColor3 = selected[i]
            and Color3.fromRGB(220,65,245)
            or Panel
    end)
end

-- START
