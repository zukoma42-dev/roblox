local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)
local EffectsConstants = require(ReplicatedStorage.Shared.EffectsConstants)

local CoinService = Knit.CreateService {
	Name = "CoinService",
	Client = {},
}

local COIN_VALUE = 10
local COIN_TAG = "Collectable"
local SPAWN_RATE = 5 -- Seconds between spawns
local MAX_COINS = 20

function CoinService:KnitStart()
	self.EconomyService = Knit.GetService("EconomyService")
	self.EffectsService = Knit.GetService("EffectsService")
	
	-- Setup existing coins
	for _, coin in ipairs(CollectionService:GetTagged(COIN_TAG)) do
		self:SetupCoin(coin)
	end
	
	-- Setup future coins
	CollectionService:GetInstanceAddedSignal(COIN_TAG):Connect(function(coin)
		self:SetupCoin(coin)
	end)
	
	-- Start Spawner
	task.spawn(function()
		while true do
			task.wait(SPAWN_RATE)
			self:SpawnCoin()
		end
	end)
end

function CoinService:SpawnCoin()
	local spawnArea = workspace:FindFirstChild("SpawnArea")
	local coinTemplate = ServerStorage:FindFirstChild("Coin")
	
	if not spawnArea or not coinTemplate then return end
	
	-- Check current coin count to prevent overflow
	local currentCoins = CollectionService:GetTagged(COIN_TAG)
	if #currentCoins >= MAX_COINS then return end
	
	-- Calculate random position within SpawnArea
	local size = spawnArea.Size
	local cframe = spawnArea.CFrame
	
	local randomX = math.random() - 0.5 -- -0.5 to 0.5
	local randomZ = math.random() - 0.5 -- -0.5 to 0.5
	
	local spawnPos = cframe * CFrame.new(randomX * size.X, size.Y / 2 + 2, randomZ * size.Z)
	
	-- Clone and place coin
	local newCoin = coinTemplate:Clone()
	newCoin.CFrame = spawnPos
	newCoin.Parent = workspace
	
	-- Ensure tag is present (if template doesn't have it)
	if not CollectionService:HasTag(newCoin, COIN_TAG) then
		CollectionService:AddTag(newCoin, COIN_TAG)
	end
end

function CoinService:KnitInit()
	
end

function CoinService:SetupCoin(coin)
	if not coin:IsA("BasePart") then return end
	
	local db = false
	coin.Touched:Connect(function(hit)
		if db then return end
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			db = true
			self:CollectCoin(player, coin)
		end
	end)
end

function CoinService:CollectCoin(player, coin)
	-- Add Money
	self.EconomyService:AddMoney(player, COIN_VALUE)
	
	-- Play Sound (Broadcast to all or just local? Let's broadcast for now as it's an event)
	-- Or better, play sound at coin location
	if self.EffectsService then
		-- We can use a generic "PlaySound" effect or just reuse PlayEffect if we defined a Coin effect
		-- For now, let's just play the sound via EffectsService if we add a Coin effect type, 
		-- OR we can just play it locally on the client who picked it up?
		-- Let's keep it simple: Server plays sound via EffectsService (everyone hears it nearby)
		self.EffectsService:PlayEffect("CoinPickup", coin.Position)
	end
	
	-- Destroy Coin
	coin:Destroy()
end

return CoinService
