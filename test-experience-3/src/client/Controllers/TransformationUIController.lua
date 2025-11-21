local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TransformationConstants = require(ReplicatedStorage.Shared.TransformationConstants)

local TransformationUIController = Knit.CreateController({
	Name = "TransformationUIController",
})

function TransformationUIController:KnitStart()
	local TransformationService = Knit.GetService("TransformationService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TransformationUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Create Frame
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 220, 0, 300) -- Increased height for list
	frame.Position = UDim2.new(0, 20, 0.5, -150)
	frame.BackgroundTransparency = 0.5
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.Parent = screenGui
	
	-- Add UIListLayout for automatic arrangement
	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = frame
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	
	-- Add Padding
	local padding = Instance.new("UIPadding")
	padding.Parent = frame
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)

	-- Generate Buttons dynamically
	local sortedTransformations = {}
	for _, config in pairs(TransformationConstants.TRANSFORMATIONS) do
		table.insert(sortedTransformations, config)
	end
	
	-- Sort by DisplayName or Id to ensure consistent order
	table.sort(sortedTransformations, function(a, b)
		return a.DisplayName < b.DisplayName
	end)

	for _, config in ipairs(sortedTransformations) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 40) -- Fixed height per button
		btn.Text = "Transform: " .. config.DisplayName
		btn.Parent = frame
		
		btn.MouseButton1Click:Connect(function()
			TransformationService:RequestTransform(config.Id)
		end)
	end
end

function TransformationUIController:KnitInit()
	
end

return TransformationUIController
