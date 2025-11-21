local ShopConstants = {
	ITEMS = {
		JumpPotion = {
			Id = "JumpPotion",
			Name = "Jump Potion",
			Price = 50,
			Description = "Increases Jump Power for 60 seconds!",
			EffectType = "JumpBoost",
			PowerAmount = 100, -- For UseJumpPower = true
			HeightAmount = 20, -- For UseJumpPower = false (Default ~7.2, so +20 is huge)
			Duration = 60,
		},
		SpeedPotion = {
			Id = "SpeedPotion",
			Name = "Speed Potion",
			Price = 30,
			Description = "Increases Walk Speed for 30 seconds!",
			EffectType = "StatBoost",
			Stat = "WalkSpeed",
			Amount = 16, -- Add to default
			Duration = 30,
		},
	},
}

return ShopConstants
