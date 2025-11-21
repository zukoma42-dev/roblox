local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local EffectsService = Knit.CreateService {
	Name = "EffectsService",
	Client = {
		PlayEffect = Knit.CreateSignal(),
	},
}

function EffectsService:KnitStart()
	
end

function EffectsService:KnitInit()
	
end

function EffectsService:PlayEffect(effectName, position, data)
	-- Broadcast to all clients
	self.Client.PlayEffect:FireAll(effectName, position, data)
end

return EffectsService
