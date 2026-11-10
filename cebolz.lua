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
    Position = UDim2.new(0,15,0,0),
    BackgroundTransparency = 1,
    Text = "CEBOL MOD V3",
    TextColor3 = White,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- MINIMIZE
local Min = Create("TextButton",Header,{
    Size = UDim2.new(0,35,0,30),
    Position = UDim2.new(1,-80,0,6),
    BackgroundColor3 = Purple,
    Text = "—",
    TextColor3 = White,
    TextSize = 20
})

Corner(Min,8)

-- CLOSE
local Close = Create("TextButton",Header,{
    Size = UDim2.new(0,35,0,30),
    Position = UDim2.new(1,-40,0,6),
    BackgroundColor3 = Color3.fromRGB(190,50,60),
    Text = "X",
    TextColor3 = White,
    TextSize = 16
})

Corner(Close,8)

-- SIDEBAR
local Side = Create("Frame",Main,{
    Size = UDim2.new(0,65,1,-50),
    Position = UDim2.new(0,5,0,45),
    BackgroundColor3 = Panel
})

Corner(Side,12)

local Icons = {"⌂","⟳","◉","◈","⚙","☰"}

for i,v in ipairs(Icons) do
    local b = Create("TextButton",Side,{
        Size = UDim2.new(0,45,0,42),
        Position = UDim2.new(0,10,0,10+(i-1)*55),
        BackgroundColor3 = Dark,
        Text = v,
        TextColor3 = White,
        TextSize = 20
    })
    Corner(b,8)
end

-- MENU
local Center = Create("Frame",Main,{
    Size = UDim2.new(0,245,1,-50),
    Position = UDim2.new(0,75,0,45),
    BackgroundColor3 = Panel
})

Corner(Center,12)

Create("TextLabel",Center,{
    Size = UDim2.new(1,0,0,45),
    BackgroundTransparency = 1,
    Text = "Automation",
    TextColor3 = White,
    TextSize = 19,
    Font = Enum.Font.GothamBold
})

local function Menu(name,desc,y)
    local b = Create("TextButton",Center,{
        Size = UDim2.new(1,-18,0,62),
        Position = UDim2.new(0,9,0,y),
        BackgroundColor3 = Dark,
        Text = name.."\n"..desc,
        TextColor3 = White,
        TextSize = 13,
        Font = Enum.Font.GothamBold
    })
    Corner(b,10)
end

Menu("Spammer","Chat automation",50)
Menu("Autofarm","Automatic farming",118)
Menu("Automation","Plant and harvest",186)
Menu("Collect","Collect items",254)
Menu("Fishing","Fishing automation",322)

-- RIGHT PANEL
local Right = Create("Frame",Main,{
    Size = UDim2.new(0,235,1,-50),
    Position = UDim2.new(1,-240,0,45),
    BackgroundColor3 = Panel
})

Corner(Right,12)

Create("TextLabel",Right,{
    Size = UDim2.new(1,0,0,45),
    BackgroundTransparency = 1,
    Text = "AUTOFARM",
    TextColor3 = White,
    TextSize = 18,
    Font = Enum.Font.GothamBold
})

-- BLOCK
local Block = Create("TextButton",Right,{
    Size = UDim2.new(1,-20,0,45),
    Position = UDim2.new(0,10,0,50),
    BackgroundColor3 = Dark,
    Text = "Select Block",
    TextColor3 = White,
    TextSize = 14
})

Corner(Block,8)

-- GRID
Create("TextLabel",Right,{
    Size = UDim2.new(1,-20,0,25),
    Position = UDim2.new(0,10,0,103),
    BackgroundTransparency = 1,
    Text = "SELECT TILE 5x5",
    TextColor3 = White,
    TextSize = 13,
    Font = Enum.Font.GothamBold
})

local Grid = Create("Frame",Right,{
    Size = UDim2.new(1,-20,0,215),
    Position = UDim2.new(0,10,0,130),
    BackgroundTransparency = 1
})

Create("UIGridLayout",Grid,{
    CellSize = UDim2.new(0,37,0,38),
    CellPadding = UDim2.new(0,5,0,5)
})

local Selected = {}

for i=1,25 do
    local Tile = Create("TextButton",Grid,{
        BackgroundColor3 = Dark,
        Text = "",
        LayoutOrder = i
    })

    Corner(Tile,6)

    Tile.Activated:Connect(function()
        Selected[i] = not Selected[i]

        Tile.BackgroundColor3 = Selected[i]
            and Purple or Dark
    end)
end

-- START
local Running = false

local Start = Create("TextButton",Right,{
    Size = UDim2.new(1,-20,0,38),
    Position = UDim2.new(0,10,0,355),
    BackgroundColor3 = Purple,
    Text = "START",
    TextColor3 = White,
    TextSize = 14,
    Font = Enum.Font.GothamBold
})

Corner(Start,8)

Start.Activated:Connect(function()
    Running = not Running
    Start.Text = Running and "STOP" or "START"
end)

-- FLOATING BUTTON
local Restore = Create("TextButton",GUI,{
    Size = UDim2.new(0,75,0,45),
    Position = UDim2.new(0,15,0.5,0),
    BackgroundColor3 = Purple,
    Text = "CEBOL",
    TextColor3 = White,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    Visible = false
})

Corner(Restore,12)

-- MINIMIZE
Min.Activated:Connect(function()
    Main.Visible = false
    Restore.Visible = true
end)

-- RESTORE
Restore.Activated:Connect(function()
    Main.Visible = true
    Restore.Visible = false
end)

-- CLOSE
Close.Activated:Connect(function()
    GUI:Destroy()
end)

print("CEBOL MOD V3 SUCCESS")
