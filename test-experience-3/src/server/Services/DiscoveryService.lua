local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local DiscoveryConstants = require(ReplicatedStorage.Shared.DiscoveryConstants)

local DiscoveryService = Knit.CreateService {
    Name = "DiscoveryService",
    Client = {
        ItemDiscovered = Knit.CreateSignal(),
    },
}

function DiscoveryService:KnitInit()
    -- Setup existing discoverables
    for _, instance in ipairs(CollectionService:GetTagged(DiscoveryConstants.TAG_NAME)) do
        self:SetupDiscoverable(instance)
    end
    
    -- Setup future discoverables
    CollectionService:GetInstanceAddedSignal(DiscoveryConstants.TAG_NAME):Connect(function(instance)
        self:SetupDiscoverable(instance)
    end)
end

function DiscoveryService:KnitStart()
    self.DataService = Knit.GetService("DataService")
    print("DiscoveryService Started")
end

function DiscoveryService:SetupDiscoverable(instance)
    if not instance:IsA("BasePart") and not instance:IsA("Model") then return end
    
    -- Check if it already has a prompt
    if instance:FindFirstChild("DiscoveryPrompt") then return end
    
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "DiscoveryPrompt"
    prompt.ActionText = DiscoveryConstants.PROMPT.ACTION_TEXT
    prompt.ObjectText = DiscoveryConstants.PROMPT.OBJECT_TEXT
    prompt.HoldDuration = DiscoveryConstants.PROMPT.HOLD_DURATION
    prompt.MaxActivationDistance = DiscoveryConstants.PROMPT.MAX_DISTANCE
    prompt.RequiresLineOfSight = false
    prompt.Parent = instance
    
    prompt.Triggered:Connect(function(player)
        self:OnPromptTriggered(player, instance)
    end)
end

function DiscoveryService:OnPromptTriggered(player, instance)
    local transformationId = instance:GetAttribute(DiscoveryConstants.ATTRIBUTE_ID)
    
    if not transformationId then
        warn("Discoverable item missing TransformationId attribute:", instance:GetFullName())
        return
    end
    
    local success, message = self:AttemptDiscover(player, transformationId)
    if success then
        -- Optional: Visual feedback could be triggered here or on client via signal
    end
end

function DiscoveryService.Client:AttemptDiscover(player, itemId)
    return self.Server:AttemptDiscover(player, itemId)
end

function DiscoveryService.Client:GetDiscoveredItems(player)
    return self.Server:GetDiscoveredItems(player)
end

function DiscoveryService:AttemptDiscover(player, itemId)
    if not itemId then return false, "Invalid Item" end
    
    -- Use DataService to check and save
    local alreadyDiscovered = self.DataService:GetDiscoveredItems(player)[itemId]
    
    if alreadyDiscovered then
        return false, "Already Discovered"
    end

    -- Register discovery via DataService
    local success = self.DataService:AddDiscoveredItem(player, itemId)
    
    if success then
        print(player.Name .. " discovered: " .. itemId)
        -- Notify Client
        self.Client.ItemDiscovered:Fire(player, itemId)
        return true, "Discovered!"
    end
    
    return false, "Failed to save"
end

function DiscoveryService:GetDiscoveredItems(player)
    return self.DataService:GetDiscoveredItems(player)
end

return DiscoveryService
