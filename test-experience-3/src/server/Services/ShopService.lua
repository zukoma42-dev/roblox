local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local ShopConstants = require(ReplicatedStorage.Shared.ShopConstants)

local ShopService = Knit.CreateService {
	Name = "ShopService",
	Client = {},
}

function ShopService:KnitStart()
	self.EconomyService = Knit.GetService("EconomyService")
end

function ShopService:KnitInit()
	
end

function ShopService:BuyItem(player, itemId)
	local item = ShopConstants.ITEMS[itemId]
	if not item then return false, "Item not found" end
	
	local price = item.Price
	
	-- Check Money
	if self.EconomyService:GetMoney(player) < price then
		return false, "Not enough money"
	end
	
	-- Deduct Money
	if self.EconomyService:RemoveMoney(player, price) then
		-- Apply Effect
		self:ApplyEffect(player, item)
		return true, "Purchased " .. item.Name
	else
		return false, "Transaction failed"
	end
end

function ShopService:ApplyEffect(player, item)
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end
	
	if item.EffectType == "StatBoost" then
		local originalValue = humanoid[item.Stat]
		humanoid[item.Stat] = originalValue + item.Amount
		
		-- Revert after duration
		if item.Duration and item.Duration > 0 then
			task.delay(item.Duration, function()
				if player.Character == character and humanoid.Parent then
					humanoid[item.Stat] = originalValue
				end
			end)
		end
	elseif item.EffectType == "JumpBoost" then
		local usePower = humanoid.UseJumpPower
		local statName = usePower and "JumpPower" or "JumpHeight"
		local amount = usePower and (item.PowerAmount or 50) or (item.HeightAmount or 15)
		
		local originalValue = humanoid[statName]
		humanoid[statName] = originalValue + amount
		
		-- Revert after duration
		if item.Duration and item.Duration > 0 then
			task.delay(item.Duration, function()
				if player.Character == character and humanoid.Parent then
					humanoid[statName] = originalValue
				end
			end)
		end
	end
end

function ShopService.Client:BuyItem(player, itemId)
	return self.Server:BuyItem(player, itemId)
end

return ShopService
