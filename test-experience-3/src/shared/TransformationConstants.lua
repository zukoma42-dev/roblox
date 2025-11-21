local TransformationConstants = {
	TRANSFORMATIONS = {
		Warrior = {
			Id = "Warrior",
			Type = "Character", -- Character or Object
			Duration = 30,
			Cooldown = 60,
			DisplayName = "Warrior",
			-- HumanoidDescription properties
			Description = {
				HeadColor = Color3.fromRGB(255, 100, 100),
				TorsoColor = Color3.fromRGB(200, 50, 50),
				LeftArmColor = Color3.fromRGB(200, 50, 50),
				RightArmColor = Color3.fromRGB(200, 50, 50),
				LeftLegColor = Color3.fromRGB(100, 25, 25),
				RightLegColor = Color3.fromRGB(100, 25, 25),
				HeightScale = 1.2,
				WidthScale = 1.2,
				HeadScale = 1.0,
			},
		},
		Mage = {
			Id = "Mage",
			Type = "Character",
			Duration = 25,
			Cooldown = 50,
			DisplayName = "Mage",
			-- HumanoidDescription properties
			Description = {
				HeadColor = Color3.fromRGB(100, 100, 255),
				TorsoColor = Color3.fromRGB(50, 50, 200),
				LeftArmColor = Color3.fromRGB(50, 50, 200),
				RightArmColor = Color3.fromRGB(50, 50, 200),
				LeftLegColor = Color3.fromRGB(25, 25, 100),
				RightLegColor = Color3.fromRGB(25, 25, 100),
				HeightScale = 0.9,
				WidthScale = 0.8,
				HeadScale = 1.1,
			},
		},
		Chair = {
			Id = "Chair",
			Type = "Object",
			Duration = 60,
			Cooldown = 10,
			DisplayName = "Chair",
			Description = {}, -- No humanoid description needed
			-- Offset = Vector3.new(0, -2.5, 0), -- Manual offset (disabled for AutoGround)
			AutoGround = true, -- Automatically calculate offset to touch ground
			Rotation = Vector3.new(0, 0, 0), -- Adjust rotation (e.g., Vector3.new(0, 90, 0))
		},
		Apple = {
			Id = "Apple",
			Type = "Object",
			Duration = 60,
			Cooldown = 10,
			DisplayName = "Apple",
			Description = {},
			AutoGround = true,
			Rotation = Vector3.new(0, 0, 0),
		},
		Cat = {
			Id = "Cat",
			Type = "Object", -- Assuming Object for now, unless user has a rigged character
			Duration = 60,
			Cooldown = 10,
			DisplayName = "Cat",
			Description = {},
			AutoGround = true,
			Rotation = Vector3.new(0, 0, 0),
		},
	},
}

return TransformationConstants
