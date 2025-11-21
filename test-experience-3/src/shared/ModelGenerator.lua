local ModelGenerator = {}

function ModelGenerator.Create(modelId)
	local model = Instance.new("Model")
	model.Name = "TransformationModel_" .. modelId

	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Transparency = 1
	rootPart.CanCollide = false
	rootPart.Massless = true
	rootPart.Parent = model
	model.PrimaryPart = rootPart

	-- Visual Part (The "Skin")
	local visual = Instance.new("Part")
	visual.Name = "Visual"
	visual.Size = Vector3.new(4, 5, 2)
	visual.CanCollide = false
	visual.Massless = true
	visual.Material = Enum.Material.Neon
	visual.Parent = model

	if modelId == "Warrior" then
		visual.Color = Color3.fromRGB(255, 50, 50) -- Red Warrior
		visual.Shape = Enum.PartType.Block
	elseif modelId == "Mage" then
		visual.Color = Color3.fromRGB(50, 50, 255) -- Blue Mage
		visual.Shape = Enum.PartType.Cylinder
		visual.Size = Vector3.new(5, 3, 3) -- Cylinder uses X as length
		visual.Rotation = Vector3.new(0, 0, 90) -- Rotate cylinder to stand up
	end

	-- Weld Visual to Root
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = rootPart
	weld.Part1 = visual
	weld.Parent = rootPart

	return model
end

return ModelGenerator
