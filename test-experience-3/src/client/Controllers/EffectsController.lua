local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Knit = require(ReplicatedStorage.Packages.Knit)
local EffectsConstants = require(ReplicatedStorage.Shared.EffectsConstants)

local EffectsController = Knit.CreateController {
	Name = "EffectsController",
}

function EffectsController:KnitStart()
	local EffectsService = Knit.GetService("EffectsService")
	local DiscoveryService = Knit.GetService("DiscoveryService")
	
	-- Listen for global effects
	EffectsService.PlayEffect:Connect(function(effectName, position, data)
		self:PlayEffect(effectName, position, data)
	end)
	
	-- Listen for local discovery
	DiscoveryService.ItemDiscovered:Connect(function(itemId)
		self:PlaySound(EffectsConstants.SOUNDS.DISCOVERY)
	end)
end

function EffectsController:PlayEffect(effectName, position, data)
	if effectName == "TransformationPoof" then
		self:SpawnPoof(position)
		self:PlaySound(EffectsConstants.SOUNDS.TRANSFORMATION_POOF, position)
	elseif effectName == "CoinPickup" then
		self:PlaySound(EffectsConstants.SOUNDS.COIN_PICKUP, position)
	end
end

function EffectsController:PlaySound(soundId, position)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = 1
	
	if position then
		local part = Instance.new("Part")
		part.Transparency = 1
		part.CanCollide = false
		part.Anchored = true
		part.Position = position
		part.Parent = workspace
		sound.Parent = part
		Debris:AddItem(part, 5)
	else
		sound.Parent = workspace
	end
	
	sound:Play()
	Debris:AddItem(sound, 5)
end

function EffectsController:SpawnPoof(position)
	local part = Instance.new("Part")
	part.Transparency = 1
	part.CanCollide = false
	part.Anchored = true
	part.Position = position
	part.Parent = workspace
	Debris:AddItem(part, 2)
	
	local attachment = Instance.new("Attachment")
	attachment.Parent = part
	
	local particle = Instance.new("ParticleEmitter")
	local settings = EffectsConstants.PARTICLES.POOF
	
	particle.Texture = settings.Texture
	particle.Color = settings.Color
	particle.Size = settings.Size
	particle.Transparency = settings.Transparency
	particle.Lifetime = settings.Lifetime
	particle.Speed = settings.Speed
	particle.SpreadAngle = settings.SpreadAngle
	particle.Parent = attachment
	
	particle:Emit(20)
end

return EffectsController
