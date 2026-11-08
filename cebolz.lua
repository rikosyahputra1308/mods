-- GrowBlox Auto Plant - Server Script
-- Place in ServerScriptService as AutoPlantServer.server.lua
-- Required:
-- ReplicatedStorage/SeedModels (Folder containing plant Models)
-- Workspace/PlantSpots (Folder containing BaseParts)
-- Each PlantSpot needs OwnerUserId (Number) attribute.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local seedModels = ReplicatedStorage:WaitForChild("SeedModels")
local plantSpots = workspace:WaitForChild("PlantSpots")

local remotes = ReplicatedStorage:FindFirstChild("AutoPlantRemotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "AutoPlantRemotes"
    remotes.Parent = ReplicatedStorage
end

local plantEvent = remotes:FindFirstChild("PlantRequest")
if not plantEvent then
    plantEvent = Instance.new("RemoteEvent")
    plantEvent.Name = "PlantRequest"
    plantEvent.Parent = remotes
end

local getSeeds = remotes:FindFirstChild("GetSeeds")
if not getSeeds then
    getSeeds = Instance.new("RemoteFunction")
    getSeeds.Name = "GetSeeds"
    getSeeds.Parent = remotes
end

local lastRequest = {}
local REQUEST_COOLDOWN = 0.35

local function getSeedNames()
    local names = {}
    for _, seed in ipairs(seedModels:GetChildren()) do
        if seed:IsA("Model") then
            table.insert(names, seed.Name)
        end
    end
    table.sort(names)
    return names
end

getSeeds.OnServerInvoke = function(_player)
    return getSeedNames()
end

local function sendResult(player, success, message)
    plantEvent:FireClient(player, "Result", success, message)
end

plantEvent.OnServerEvent:Connect(function(player, action, seedName, spotName)
    if action ~= "Plant" then
        return
    end

    if typeof(seedName) ~= "string" or typeof(spotName) ~= "string" then
        return
    end

    -- Rate-limit requests per player.
    local now = os.clock()
    if lastRequest[player] and now - lastRequest[player] < REQUEST_COOLDOWN then
        return
    end
    lastRequest[player] = now

    local seedTemplate = seedModels:FindFirstChild(seedName)
    local spot = plantSpots:FindFirstChild(spotName)

    if not seedTemplate or not seedTemplate:IsA("Model") then
        sendResult(player, false, "Seed tidak ditemukan")
        return
    end

    if not spot or not spot:IsA("BasePart") then
        sendResult(player, false, "Plant spot tidak ditemukan")
        return
    end

    if spot:GetAttribute("OwnerUserId") ~= player.UserId then
        sendResult(player, false, "Spot bukan milikmu")
        return
    end

    if spot:GetAttribute("Planted") == true then
        sendResult(player, false, "Spot sudah ditanami")
        return
    end

    local inventoryAttribute = "Seed_" .. seedName
    local amount = player:GetAttribute(inventoryAttribute) or 0
    if typeof(amount) ~= "number" or amount < 1 then
        sendResult(player, false, "Seed habis")
        return
    end

    local plant = seedTemplate:Clone()
    plant.Name = seedName .. "_Plant"

    local ok, err = pcall(function()
        plant:PivotTo(spot.CFrame * CFrame.new(0, spot.Size.Y / 2, 0))
        plant.Parent = workspace
    end)

    if not ok then
        plant:Destroy()
        warn("AutoPlant placement error:", err)
        sendResult(player, false, "Gagal meletakkan tanaman")
        return
    end

    -- Commit state only after successful placement.
    spot:SetAttribute("Planted", true)
    player:SetAttribute(inventoryAttribute, amount - 1)
    sendResult(player, true, "Berhasil menanam " .. seedName)
end)

Players.PlayerRemoving:Connect(function(player)
    lastRequest[player] = nil
end)
