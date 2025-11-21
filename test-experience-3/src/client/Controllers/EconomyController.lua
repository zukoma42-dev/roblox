local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

local EconomyController = Knit.CreateController {
	Name = "EconomyController",
}

function EconomyController:KnitStart()
	local EconomyService = Knit.GetService("EconomyService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Create HUD
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EconomyHUD"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 50)
	frame.Position = UDim2.new(1, -220, 0, 20) -- Top Right
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold color
	label.TextSize = 24
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Right
	label.Text = "$ 0"
	label.Parent = frame
	
	-- Initial Fetch
	EconomyService:GetMoney():andThen(function(money)
		label.Text = "$ " .. tostring(money)
	end)
	
	-- Listen for updates
	EconomyService.MoneyChanged:Connect(function(newBalance)
		label.Text = "$ " .. tostring(newBalance)
	end)
end

return EconomyController
