local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local seedsFolder = ServerStorage:WaitForChild("SeedModels")
local spotsFolder = workspace:WaitForChild("PlantSpots")

local remotes = Instance.new("Folder")
remotes.Name = "AutoPlantRemotes"
remotes.Parent = ReplicatedStorage

local plantEvent = Instance.new("RemoteEvent")
plantEvent.Name = "PlantRequest"
plantEvent.Parent = remotes

local getSeeds = Instance.new("RemoteFunction")
getSeeds.Name = "GetSeeds"
getSeeds.Parent = remotes

local plantedFolder = Instance.new("Folder")
plantedFolder.Name = "PlantedCrops"
plantedFolder.Parent = workspace

local lastPlant = {}

-- Daftar benih
getSeeds.OnServerInvoke = function(player)
    local list = {}

    for _, seed in ipairs(seedsFolder:GetChildren()) do
        if seed:IsA("Model") or seed:IsA("BasePart") then
            table.insert(list, seed.Name)
        end
    end

    table.sort(list)

    return list
end

-- Pemilik lahan untuk prototype single-player
Players.PlayerAdded:Connect(function(player)
    for _, spot in ipairs(spotsFolder:GetChildren()) do
        if spot:IsA("BasePart") then
            spot:SetAttribute("OwnerUserId", player.UserId)
            spot:SetAttribute("Planted", false)
        end
    end
end)

-- Sistem penanaman
plantEvent.OnServerEvent:Connect(function(player, action, seedName, spotName)

    if action ~= "Plant" then return end

    local now = os.clock()

    if lastPlant[player] and now - lastPlant[player] < 0.4 then
        return
    end

    lastPlant[player] = now

    if typeof(seedName) ~= "string" or typeof(spotName) ~= "string" then
        return
    end

    local seed = seedsFolder:FindFirstChild(seedName)
    local spot = spotsFolder:FindFirstChild(spotName)

    if not seed or not spot then return end

    if not (seed:IsA("Model") or seed:IsA("BasePart")) then
        return
    end

    if not spot:IsA("BasePart") then return end

    if spot:GetAttribute("OwnerUserId") ~= player.UserId then
        return
    end

    if spot:GetAttribute("Planted") == true then
        return
    end

    local crop = seed:Clone()

    crop.Parent = plantedFolder

    if crop:IsA("Model") then
        crop:PivotTo(spot.CFrame)
    else
        crop.CFrame = spot.CFrame
    end

    for _, object in ipairs(crop:GetDescendants()) do
        if object:IsA("BasePart") then
            object.Anchored = true
        end
    end

    if crop:IsA("BasePart") then
        crop.Anchored = true
    end

    spot:SetAttribute("Planted", true)

    plantEvent:FireClient(
        player,
        "Result",
        true,
        "PLANT SUCCESS"
    )
end)

Players.PlayerRemoving:Connect(function(player)
    lastPlant[player] = nil
end)
