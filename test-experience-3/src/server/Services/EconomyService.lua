local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local EconomyService = Knit.CreateService {
	Name = "EconomyService",
	Client = {
		MoneyChanged = Knit.CreateSignal(),
	},
}

function EconomyService:KnitStart()
	self.DataService = Knit.GetService("DataService")
end

function EconomyService:KnitInit()
	
end

function EconomyService:GetMoney(player)
	return self.DataService:GetMoney(player)
end

function EconomyService:AddMoney(player, amount)
	if amount <= 0 then return end
	
	local newBalance = self.DataService:AddMoney(player, amount)
	if newBalance then
		self.Client.MoneyChanged:Fire(player, newBalance)
		return newBalance
	end
	return nil
end

function EconomyService:RemoveMoney(player, amount)
	if amount <= 0 then return false end
	
	local currentBalance = self.DataService:GetMoney(player)
	if currentBalance >= amount then
		local newBalance = self.DataService:AddMoney(player, -amount)
		if newBalance then
			self.Client.MoneyChanged:Fire(player, newBalance)
			return true
		end
	end
	return false
end

function EconomyService.Client:GetMoney(player)
	return self.Server:GetMoney(player)
end

return EconomyService
