-- MINIMIZE SYSTEM

local Minimize = Instance.new("TextButton")
Minimize.Name = "MinimizeButton"
Minimize.Size = UDim2.new(0,35,0,30)
Minimize.Position = UDim2.new(1,-45,0,7)
Minimize.BackgroundColor3 = Color3.fromRGB(133,75,255)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.TextSize = 22
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Main

Corner(Minimize,8)

-- FLOATING RESTORE BUTTON

local Restore = Instance.new("TextButton")
Restore.Name = "RestoreButton"
Restore.Size = UDim2.new(0,65,0,45)
Restore.Position = UDim2.new(0,15,0.5,0)
Restore.BackgroundColor3 = Color3.fromRGB(133,75,255)
Restore.Text = "CEBOL"
Restore.TextColor3 = Color3.new(1,1,1)
Restore.TextSize = 14
Restore.Font = Enum.Font.GothamBold
Restore.Visible = false
Restore.Parent = GUI

Corner(Restore,12)

-- MINIMIZE

Minimize.Activated:Connect(function()
    Main.Visible = false
    Restore.Visible = true
end)

-- RESTORE

Restore.Activated:Connect(function()
    Main.Visible = true
    Restore.Visible = false
end)
