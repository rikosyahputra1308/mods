-- GrowBlox Auto Plant - Client GUI
-- Place in StarterPlayer > StarterPlayerScripts as AutoPlantGUI.client.lua
-- Requires the server script AutoPlantServer.server.lua.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("AutoPlantRemotes")
local plantEvent = remotes:WaitForChild("PlantRequest")
local getSeeds = remotes:WaitForChild("GetSeeds")
local plantSpots = workspace:WaitForChild("PlantSpots")

local seeds = {}
local selectedSeedIndex = 1
local running = false
local plantedCount = 0
local runToken = 0

local ok, result = pcall(function()
    return getSeeds:InvokeServer()
end)
if ok and typeof(result) == "table" then
    seeds = result
end

local gui = Instance.new("ScreenGui")
gui.Name = "GrowBloxPremium"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
end

local function makeLabel(parent, text, position, size, textSize, alignment)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.Text = text
    label.TextColor3 = Color3.fromRGB(245, 247, 255)
    label.TextSize = textSize
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = alignment or Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local openButton = Instance.new("TextButton")
openButton.Name = "OpenMenu"
openButton.Size = UDim2.fromOffset(104, 42)
openButton.Position = UDim2.new(0, 16, 0.35, 0)
openButton.BackgroundColor3 = Color3.fromRGB(45, 105, 210)
openButton.Text = "GROWBLOX"
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.TextSize = 14
openButton.Font = Enum.Font.GothamBold
openButton.Parent = gui
addCorner(openButton, 10)

local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.fromOffset(300, 350)
main.Position = UDim2.new(0.5, -150, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(24, 29, 43)
main.Visible = true
main.Active = true
main.Parent = gui
addCorner(main, 14)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 105, 180)
stroke.Thickness = 1.5
stroke.Parent = main

-- Drag panel using the header; works with mouse and touch.
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(34, 43, 63)
header.Active = true
header.Parent = main
addCorner(header, 14)

makeLabel(header, "GROWBLOX AUTO PLANT", UDim2.fromOffset(14, 0),
    UDim2.new(1, -55, 1, 0), 17)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(34, 30)
closeButton.Position = UDim2.new(1, -42, 0, 9)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 70)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = header
addCorner(closeButton, 8)

local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

local function makeButton(text, y, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -28, 0, 40)
    button.Position = UDim2.fromOffset(14, y)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = main
    addCorner(button, 8)
    return button
end

makeLabel(main, "SEED TYPE", UDim2.fromOffset(15, 58),
    UDim2.new(1, -30, 0, 20), 12)

local seedButton = makeButton("Loading seeds...", 82,
    Color3.fromRGB(48, 88, 155))

makeLabel(main, "PLANT DELAY (SECONDS)", UDim2.fromOffset(15, 132),
    UDim2.new(1, -30, 0, 20), 12)

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, -28, 0, 38)
delayBox.Position = UDim2.fromOffset(14, 156)
delayBox.BackgroundColor3 = Color3.fromRGB(43, 51, 70)
delayBox.Text = "1"
delayBox.PlaceholderText = "Example: 1"
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.PlaceholderColor3 = Color3.fromRGB(170, 175, 190)
delayBox.TextSize = 14
delayBox.Font = Enum.Font.Gotham
delayBox.ClearTextOnFocus = false
delayBox.Parent = main
addCorner(delayBox, 8)

local statusLabel = makeLabel(main, "STATUS: READY",
    UDim2.fromOffset(15, 204), UDim2.new(1, -30, 0, 22), 12)

local countLabel = makeLabel(main, "PLANTED: 0",
    UDim2.fromOffset(15, 226), UDim2.new(1, -30, 0, 22), 12)

local startButton = makeButton("START AUTO PLANT", 258,
    Color3.fromRGB(30, 145, 85))
local stopButton = makeButton("STOP", 304,
    Color3.fromRGB(185, 58, 68))

local function refreshSeedText()
    if #seeds == 0 then
        seedButton.Text = "No seed models found"
        return
    end
    selectedSeedIndex = math.clamp(selectedSeedIndex, 1, #seeds)
    seedButton.Text = "SEED: " .. seeds[selectedSeedIndex] .. "  >"
end
refreshSeedText()

seedButton.MouseButton1Click:Connect(function()
    if #seeds == 0 then
        statusLabel.Text = "STATUS: ADD MODELS TO SeedModels"
        return
    end
    selectedSeedIndex = selectedSeedIndex % #seeds + 1
    refreshSeedText()
end)

local function getAvailableSpots()
    local list = {}
    for _, spot in ipairs(plantSpots:GetChildren()) do
        if spot:IsA("BasePart")
            and spot:GetAttribute("OwnerUserId") == player.UserId
            and spot:GetAttribute("Planted") ~= true then
            table.insert(list, spot)
        end
    end
    table.sort(list, function(a, b)
        return a.Name < b.Name
    end)
    return list
end

plantEvent.OnClientEvent:Connect(function(action, success, message)
    if action == "Result" then
        statusLabel.Text = "STATUS: " .. tostring(message)
        if success then
            plantedCount += 1
            countLabel.Text = "PLANTED: " .. plantedCount
        end
    end
end)

startButton.MouseButton1Click:Connect(function()
    if running then return end
    if #seeds == 0 then
        statusLabel.Text = "STATUS: NO SEEDS"
        return
    end

    local delaySeconds = tonumber(delayBox.Text)
    if not delaySeconds then
        statusLabel.Text = "STATUS: INVALID DELAY"
        return
    end
    delaySeconds = math.clamp(delaySeconds, 0.5, 30)

    running = true
    runToken += 1
    local thisRun = runToken
    statusLabel.Text = "STATUS: RUNNING"

    task.spawn(function()
        while running and runToken == thisRun do
            local available = getAvailableSpots()
            if #available == 0 then
                statusLabel.Text = "STATUS: NO EMPTY SPOTS"
                break
            end

            for _, spot in ipairs(available) do
                if not running or runToken ~= thisRun then break end

                plantEvent:FireServer(
                    "Plant",
                    seeds[selectedSeedIndex],
                    spot.Name
                )
                task.wait(delaySeconds)
            end
        end

        if runToken == thisRun then
            running = false
            if statusLabel.Text == "STATUS: RUNNING" then
                statusLabel.Text = "STATUS: STOPPED"
            end
        end
    end)
end)

stopButton.MouseButton1Click:Connect(function()
    running = false
    runToken += 1
    statusLabel.Text = "STATUS: STOPPED"
end)

openButton.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    main.Visible = false
end)
