-- CebolX HUB V1
-- Growblox GUI
-- Mobile Friendly

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PG = Player:WaitForChild("PlayerGui")

pcall(function()
    PG:FindFirstChild("CebolXHub"):Destroy()
end)

local GUI = Instance.new("ScreenGui")
GUI.Name = "CebolXHub"
GUI.ResetOnSpawn = false
GUI.Parent = PG

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.fromOffset(560, 390)
Main.Position = UDim2.new(0.5,-280,0.5,-195)
Main.BackgroundColor3 = Color3.fromRGB(19,20,27)
Main.BorderSizePixel = 0

Instance.new("UICorner",Main).CornerRadius =
    UDim.new(0,12)

local Top = Instance.new("Frame",Main)
Top.Size = UDim2.new(1,0,0,42)
Top.BackgroundColor3 = Color3.fromRGB(29,31,42)
Top.BorderSizePixel = 0

local Title = Instance.new("TextLabel",Top)
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.fromOffset(14,0)
Title.BackgroundTransparency = 1
Title.Text = "CEBOLX HUB  |  V1.0"
Title.TextColor3 = Color3.fromRGB(0,220,170)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local Min = Instance.new("TextButton",Top)
Min.Size = UDim2.fromOffset(35,30)
Min.Position = UDim2.new(1,-43,0,6)
Min.Text = "—"
Min.TextColor3 = Color3.new(1,1,1)
Min.BackgroundColor3 = Color3.fromRGB(55,58,75)
Min.Font = Enum.Font.GothamBold
Instance.new("UICorner",Min)

-- DRAG MOBILE

local dragging = false
local dragStart, startPos

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
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
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- SIDEBAR

local Side = Instance.new("ScrollingFrame",Main)
Side.Position = UDim2.fromOffset(0,48)
Side.Size = UDim2.new(0,145,1,-48)
Side.BackgroundColor3 = Color3.fromRGB(24,26,35)
Side.BorderSizePixel = 0
Side.ScrollBarThickness = 2
Side.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SideList = Instance.new("UIListLayout",Side)
SideList.Padding = UDim.new(0,5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Padding = Instance.new("UIPadding",Side)
Padding.PaddingTop = UDim.new(0,8)

-- CONTENT

local Content = Instance.new("ScrollingFrame",Main)
Content.Position = UDim2.fromOffset(155,52)
Content.Size = UDim2.new(1,-165,1,-62)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentList = Instance.new("UIListLayout",Content)
ContentList.Padding = UDim.new(0,8)

local CP = Instance.new("UIPadding",Content)
CP.PaddingTop = UDim.new(0,8)
CP.PaddingLeft = UDim.new(0,5)
CP.PaddingRight = UDim.new(0,8)

-- MINIMIZE

local minimized = false

Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    Side.Visible = not minimized
    Content.Visible = not minimized
    Main.Size = minimized
        and UDim2.fromOffset(220,42)
        or UDim2.fromOffset(560,390)
    Min.Text = minimized and "+" or "—"
end)

-- GUI BUILDER

local function clearContent()
    for _,v in pairs(Content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= ContentList
        and v ~= CP then
            v:Destroy()
        end
    end
end

local function heading(text)
    local L = Instance.new("TextLabel",Content)
    L.Size = UDim2.new(1,-5,0,30)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(0,220,170)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 16
    L.TextXAlignment = Enum.TextXAlignment.Left
end

local function button(text,callback)
    local B = Instance.new("TextButton",Content)
    B.Size = UDim2.new(1,-5,0,36)
    B.BackgroundColor3 = Color3.fromRGB(38,42,55)
    B.Text = text
    B.TextColor3 = Color3.new(1,1,1)
    B.Font = Enum.Font.Gotham
    B.TextSize = 12
    Instance.new("UICorner",B).CornerRadius = UDim.new(0,7)
    B.MouseButton1Click:Connect(callback or function() end)
    return B
end

local function toggle(text)
    local enabled = false

    local B = button(text.." : OFF")

    B.MouseButton1Click:Connect(function()
        enabled = not enabled
        B.Text = text..(enabled and " : ON" or " : OFF")
        B.BackgroundColor3 = enabled
            and Color3.fromRGB(0,125,95)
            or Color3.fromRGB(38,42,55)
    end)

    return function()
        return enabled
    end
end

local function slider(text,default)
    local value = default or 1

    local B = button(text.." : "..value)

    B.MouseButton1Click:Connect(function()
        value = value + 1
        if value > 10 then value = 1 end
        B.Text = text.." : "..value
    end)

    return function()
        return value
    end
end

-- TABS

local Tabs = {
    "Dashboard",
    "Auto Farm",
    "Clear World",
    "Farmer",
    "Lahan",
    "Pabrik",
    "PNB",
    "Vending",
    "Titik Drop",
    "Auto Chat",
    "Growscan",
    "Statistik",
    "Tas",
    "Rotasi",
    "Penjaga",
    "Settings"
}

local function openTab(tab)
    clearContent()

    heading("CEBOLX HUB / "..tab)

    if tab == "Dashboard" then
        button("Growblox Assistant")
        button("GUI Status : ACTIVE")
        button("Version : 1.0")
        button("Executor : Delta")
        button("Made for Mobile")

    elseif tab == "Auto Farm" then
        toggle("Auto Farm")
        toggle("Auto Place")
        toggle("Auto Break")
        toggle("Multi Target")
        slider("Break Delay",1)
        slider("Place Delay",1)
        slider("Target Count",1)
        button("START")
        button("STOP")

    elseif tab == "Clear World" then
        toggle("Auto Clear")
        toggle("Select Block")
        button("START CLEAR")
        button("STOP CLEAR")

    elseif tab == "Farmer" then
        toggle("Auto Plant")
        toggle("Auto Harvest")
        toggle("Auto Collect")
        button("START FARMER")
        button("STOP FARMER")

    elseif tab == "Lahan" then
        toggle("Enable Grid 5x5")
        heading("PILIH TILE")

        for i=1,25 do
            local B = button("TILE "..i)
            B.MouseButton1Click:Connect(function()
                B.BackgroundColor3 =
                    Color3.fromRGB(0,125,95)
            end)
        end

    elseif tab == "Pabrik" then
        toggle("Auto Production")
        toggle("Auto Collect")
        toggle("Auto Drop")

    elseif tab == "PNB" then
        toggle("PNB Mode")
        slider("PNB Delay",1)

    elseif tab == "Vending" then
        toggle("Auto Vending")
        toggle("
