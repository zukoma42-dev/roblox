local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local DiscoveryConstants = require(game:GetService("ReplicatedStorage").Shared.DiscoveryConstants)

local DiscoveryService = Knit.CreateService {
    Name = "DiscoveryService",
    Client = {},
}

function DiscoveryService:KnitInit()
    -- Temporary in-memory storage: PlayerUserId -> { [ItemId] = true }
    self._discoveredData = {}
end

function DiscoveryService:KnitStart()
    print("DiscoveryService Started")
end

-- Helper to get unique ID from item (using Name for now, ideally Attribute or GUID)
function DiscoveryService:_getItemId(itemInstance)
    return itemInstance.Name
end

function DiscoveryService.Client:AttemptDiscover(player, itemInstance)
    return self.Server:AttemptDiscover(player, itemInstance)
end

function DiscoveryService.Client:GetDiscoveredItems(player)
    return self.Server:GetDiscoveredItems(player)
end

function DiscoveryService:AttemptDiscover(player, itemInstance)
    if not itemInstance then return false, "Invalid Item" end
    
    local userId = player.UserId
    if not self._discoveredData[userId] then
        self._discoveredData[userId] = {}
    end

    local itemId = self:_getItemId(itemInstance)
    
    if self._discoveredData[userId][itemId] then
        return false, "Already Discovered"
    end

    -- Register discovery
    self._discoveredData[userId][itemId] = true
    print(player.Name .. " discovered: " .. itemId)
    
    return true, "Discovered!"
end

function DiscoveryService:GetDiscoveredItems(player)
    local userId = player.UserId
    return self._discoveredData[userId] or {}
end

return DiscoveryService
