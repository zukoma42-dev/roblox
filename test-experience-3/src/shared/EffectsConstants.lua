local EffectsConstants = {
	SOUNDS = {
		DISCOVERY = "rbxassetid://4612375233", -- "Sparkle" sound
		TRANSFORMATION_POOF = "rbxassetid://5696557721", -- "Poof" sound (User requested)
		COIN_PICKUP = "rbxassetid://187093228", -- Classic Coin Sound
	},
	PARTICLES = {
		POOF = {
			Texture = "rbxassetid://243661804", -- Smoke texture
			Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.5),
				NumberSequenceKeypoint.new(1, 3),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.2),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Lifetime = NumberRange.new(0.5, 1.0),
			Rate = 0, -- Burst only
			Speed = NumberRange.new(5, 10),
			SpreadAngle = Vector2.new(180, 180),
		}
	}
}

return EffectsConstants
