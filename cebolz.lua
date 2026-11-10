-- CEBOLZ HUB | GROWBLOX
-- GUI VERSION 1.0

if game.CoreGui:FindFirstChild("CebolzHub") then
    game.CoreGui.CebolzHub:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "CebolzHub"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0,320,0,390)
main.Position = UDim2.new(0.5,-160,0.5,-195)
main.BackgroundColor3 = Color3.fromRGB(20,20,28)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner",main)
corner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-80,0,40)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "CEBOLZ HUB | GROWBLOX"
title.TextColor3 = Color3.fromRGB(0,255,170)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = main

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,35,0,30)
minimize.Position = UDim2.new(1,-40,0,5)
minimize.Text = "-"
minimize.TextSize = 22
minimize.BackgroundColor3 = Color3.fromRGB(50,50,65)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-45)
content.Position = UDim2.new(0,0,0,45)
content.BackgroundTransparency = 1
content.Parent = main

local gridTitle = Instance.new("TextLabel")
gridTitle.Size = UDim2.new(1,0,0,25)
gridTitle.Text = "SELECT TILE 5 x 5"
gridTitle.TextColor3 = Color
