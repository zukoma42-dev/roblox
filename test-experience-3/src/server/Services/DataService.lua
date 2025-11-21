local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)

local PROFILE_KEY = "PlayerData_v1"
local PROFILE_TEMPLATE = {
	DiscoveredItems = {},
}

local DataService = Knit.CreateService {
	Name = "DataService",
	Client = {},
}

function DataService:KnitInit()
	self.ProfileStore = ProfileService.GetProfileStore(PROFILE_KEY, PROFILE_TEMPLATE)
	self.Profiles = {}
end

function DataService:KnitStart()
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			self:LoadProfile(player)
		end)
	end

	Players.PlayerAdded:Connect(function(player)
		self:LoadProfile(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		local profile = self.Profiles[player]
		if profile then
			profile:Release()
		end
	end)
end

function DataService:LoadProfile(player)
	local profile = self.ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		
		profile:ListenToRelease(function()
			self.Profiles[player] = nil
			player:Kick("Profile released")
		end)
		
		if player:IsDescendantOf(Players) then
			self.Profiles[player] = profile
			print("Profile loaded for " .. player.Name)
		else
			profile:Release()
		end
	else
		player:Kick("Could not load profile")
	end
end

function DataService:GetProfile(player)
	local profile = self.Profiles[player]
	while not profile and player:IsDescendantOf(Players) do
		task.wait(0.1)
		profile = self.Profiles[player]
	end
	return profile
end

function DataService:GetDiscoveredItems(player)
	local profile = self:GetProfile(player)
	if profile then
		return profile.Data.DiscoveredItems
	end
	return {}
end

function DataService:AddDiscoveredItem(player, itemId)
	local profile = self:GetProfile(player)
	if profile then
		if not profile.Data.DiscoveredItems[itemId] then
			profile.Data.DiscoveredItems[itemId] = true
			return true
		end
	end
	return false
end

return DataService
