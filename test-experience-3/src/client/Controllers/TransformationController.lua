local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TransformationController = Knit.CreateController({
	Name = "TransformationController",
})

function TransformationController:KnitStart()
	local TransformationService = Knit.GetService("TransformationService")

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.T then
			print("Requesting transformation...")
			TransformationService:RequestTransform("Warrior")
		elseif input.KeyCode == Enum.KeyCode.Y then
			print("Requesting transformation...")
			TransformationService:RequestTransform("Mage")
		end
	end)
end

function TransformationController:KnitInit()
	print("TransformationController initialized")
end

return TransformationController
