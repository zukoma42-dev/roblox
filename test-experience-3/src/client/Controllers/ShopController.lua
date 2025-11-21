local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)
local ShopConstants = require(ReplicatedStorage.Shared.ShopConstants)

local ShopController = Knit.CreateController {
	Name = "ShopController",
}

function ShopController:KnitStart()
	local ShopService = Knit.GetService("ShopService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Create Shop GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ShopGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 400)
	frame.Position = UDim2.new(0, 20, 0.5, -200) -- Left side
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.BorderSizePixel = 0
	frame.Visible = false -- Hidden initially
	frame.Parent = screenGui
	
	-- Create Toggle Button
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ToggleShop"
	toggleBtn.Size = UDim2.new(0, 100, 0, 40)
	toggleBtn.Position = UDim2.new(0, 130, 1, -60) -- Bottom Left (Next to Discovery)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	toggleBtn.Text = "Shop"
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.Parent = screenGui
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = toggleBtn
	
	toggleBtn.MouseButton1Click:Connect(function()
		frame.Visible = not frame.Visible
	end)
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "SHOP"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 24
	title.Parent = frame
	
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -50)
	scrollFrame.Position = UDim2.new(0, 10, 0, 45)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Parent = frame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = scrollFrame
	
	-- Create Item Buttons
	for itemId, item in pairs(ShopConstants.ITEMS) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(1, 0, 0, 60)
		itemFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		itemFrame.Parent = scrollFrame
		
		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 6)
		itemCorner.Parent = itemFrame
		
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -80, 0, 20)
		nameLabel.Position = UDim2.new(0, 10, 0, 5)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = item.Name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = itemFrame
		
		local descLabel = Instance.new("TextLabel")
		descLabel.Size = UDim2.new(1, -80, 0, 30)
		descLabel.Position = UDim2.new(0, 10, 0, 25)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = item.Description
		descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextSize = 12
		descLabel.TextWrapped = true
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Parent = itemFrame
		
		local buyButton = Instance.new("TextButton")
		buyButton.Size = UDim2.new(0, 60, 0, 40)
		buyButton.Position = UDim2.new(1, -70, 0, 10)
		buyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		buyButton.Text = "$" .. item.Price
		buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		buyButton.Font = Enum.Font.GothamBold
		buyButton.Parent = itemFrame
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = buyButton
		
		buyButton.MouseButton1Click:Connect(function()
			ShopService:BuyItem(itemId):andThen(function(success, message)
				if success then
					buyButton.Text = "Bought!"
					task.wait(1)
					buyButton.Text = "$" .. item.Price
				else
					local oldText = buyButton.Text
					buyButton.Text = "No Money"
					buyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
					task.wait(1)
					buyButton.Text = oldText
					buyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
				end
			end)
		end)
	end
	
	-- Update Canvas Size
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
	end)
end

return ShopController
