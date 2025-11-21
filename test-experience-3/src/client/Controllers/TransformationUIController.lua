local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TransformationConstants = require(ReplicatedStorage.Shared.TransformationConstants)

local TransformationUIController = Knit.CreateController({
	Name = "TransformationUIController",
})

function TransformationUIController:KnitStart()
	local TransformationService = Knit.GetService("TransformationService")
	local DiscoveryService = Knit.GetService("DiscoveryService")
	
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TransformationUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Create Main Frame (Hidden by default)
	local frame = Instance.new("ScrollingFrame")
	frame.Name = "TransformationList"
	frame.Size = UDim2.new(0, 200, 0, 300)
	frame.Position = UDim2.new(0, 20, 0.5, -150)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.BorderSizePixel = 0
	frame.Visible = false -- Hidden initially
	frame.Parent = screenGui
	
	-- Create Toggle Button
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ToggleDiscovery"
	toggleBtn.Size = UDim2.new(0, 100, 0, 40)
	toggleBtn.Position = UDim2.new(0, 20, 1, -60) -- Bottom Left
	toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	toggleBtn.Text = "Discovery"
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.Parent = screenGui
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = toggleBtn
	
	toggleBtn.MouseButton1Click:Connect(function()
		frame.Visible = not frame.Visible
	end)
	
	-- Add UIListLayout
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

	-- Store buttons for updates
	self.buttons = {}

	-- Initial Fetch
	DiscoveryService:GetDiscoveredItems():andThen(function(discoveredItems)
		self:GenerateButtons(frame, TransformationService, discoveredItems)
	end)
	
	-- Listen for new discoveries
	DiscoveryService.ItemDiscovered:Connect(function(itemId)
		self:UpdateDiscoveryStatus(itemId)
	end)
end

function TransformationUIController:GenerateButtons(parent, service, discoveredItems)
	local sortedTransformations = {}
	for _, config in pairs(TransformationConstants.TRANSFORMATIONS) do
		table.insert(sortedTransformations, config)
	end
	
	table.sort(sortedTransformations, function(a, b)
		return a.DisplayName < b.DisplayName
	end)

	for _, config in ipairs(sortedTransformations) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 40)
		btn.Parent = parent
		
		btn.MouseButton1Click:Connect(function()
			if self.buttons[config.Id].IsDiscovered then
				service:RequestTransform(config.Id)
			end
		end)
		
		self.buttons[config.Id] = {
			Instance = btn,
			Config = config,
			IsDiscovered = false
		}
		
		-- Initial State Update
		local isDiscovered = discoveredItems[config.Id] == true
		self:SetButtonState(config.Id, isDiscovered)
	end
end

function TransformationUIController:UpdateDiscoveryStatus(itemId)
	if self.buttons[itemId] then
		self:SetButtonState(itemId, true)
	end
end

function TransformationUIController:SetButtonState(itemId, isDiscovered)
	local btnData = self.buttons[itemId]
	if not btnData then return end
	
	btnData.IsDiscovered = isDiscovered
	local btn = btnData.Instance
	local config = btnData.Config
	
	if isDiscovered then
		btn.Text = "Transform: " .. config.DisplayName
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		btn.AutoButtonColor = true
	else
		btn.Text = "???"
		btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		btn.AutoButtonColor = false
	end
end

function TransformationUIController:KnitInit()
	
end

return TransformationUIController
