local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TransformationConstants = require(ReplicatedStorage.Shared.TransformationConstants)

local ModelGenerator = require(ReplicatedStorage.Shared.ModelGenerator)

local TransformationService = Knit.CreateService({
	Name = "TransformationService",
	Client = {},
})

function TransformationService:KnitStart()
	print("TransformationService Started")
end

function TransformationService:KnitInit()
	print("TransformationService initialized")
	self.ActiveTransformations = {}
end

function TransformationService:Transform(player, transformationId)
	local config = TransformationConstants.TRANSFORMATIONS[transformationId]
	if not config then
		warn("Invalid transformation ID:", transformationId)
		return
	end

	if self.ActiveTransformations[player] then
		warn("Player already transformed")
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChild("Humanoid")
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	
	if not humanoid or not rootPart then return end

	print(player.Name .. " transforming into " .. config.DisplayName)
	
	self.ActiveTransformations[player] = {
		Id = transformationId,
		StartTime = os.time(),
		OriginalAssets = {} -- Store original clothing/colors
	}

	-- 1. Handle Clothing & BodyColors (Save & Remove original, Apply new)
	-- Only for Character type transformations
	if config.Type ~= "Object" then
		local assetTypes = {"Shirt", "Pants", "ShirtGraphic", "BodyColors"}
		
		-- Save and remove original assets
		for _, child in ipairs(character:GetChildren()) do
			for _, assetType in ipairs(assetTypes) do
				if child:IsA(assetType) then
					table.insert(self.ActiveTransformations[player].OriginalAssets, child:Clone())
					child:Destroy()
				end
			end
		end
	else
		-- For Objects, we still might want to hide original accessories/clothing if they clip, 
		-- but for now let's just rely on transparency. 
		-- Actually, transparency doesn't hide clothing textures on mesh parts in some cases.
		-- Let's remove them temporarily for objects too to be safe, but NOT apply new ones.
		local assetTypes = {"Shirt", "Pants", "ShirtGraphic", "BodyColors", "Accessory"}
		for _, child in ipairs(character:GetChildren()) do
			for _, assetType in ipairs(assetTypes) do
				if child:IsA(assetType) then
					table.insert(self.ActiveTransformations[player].OriginalAssets, child:Clone())
					child:Destroy()
				end
			end
		end
	end

	-- 2. Make character invisible (parts only)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = 1
		elseif part:IsA("Decal") then -- Face
			part.Transparency = 1
		end
	end

	-- 3. Generate and Weld new model
	local newModel
	
	-- Try to find real asset first
	local assetsFolder = ReplicatedStorage:FindFirstChild("Assets")
	local modelsFolder = assetsFolder and assetsFolder:FindFirstChild("Models")
	local realModel = modelsFolder and modelsFolder:FindFirstChild(transformationId)
	
	if realModel then
		print("[TransformationService] Found real asset for: " .. transformationId)
		newModel = realModel:Clone()
		
		-- Apply new Clothing & BodyColors from model to character (Only for Character type)
		if config.Type ~= "Object" then
			local assetTypes = {"Shirt", "Pants", "ShirtGraphic", "BodyColors"}
			for _, child in ipairs(newModel:GetChildren()) do
				for _, assetType in ipairs(assetTypes) do
					if child:IsA(assetType) then
						local newAsset = child:Clone()
						newAsset.Parent = character
						print("[TransformationService] Applied " .. assetType .. " from model")
					end
				end
			end
		end
	else
		warn("[TransformationService] Real asset not found for: " .. transformationId .. ". Using fallback generator.")
		newModel = ModelGenerator.Create(transformationId)
	end

	newModel.Name = "TransformationModel"
	
	-- Fix: Remove Humanoid to prevent physics conflicts (slow movement)
	local modelHumanoid = newModel:FindFirstChild("Humanoid")
	if modelHumanoid then
		modelHumanoid:Destroy()
	end
	
	-- Ensure PrimaryPart exists (for fallback)
	if not newModel.PrimaryPart then
		if newModel:FindFirstChild("HumanoidRootPart") then
			newModel.PrimaryPart = newModel.HumanoidRootPart
		else
			-- Fallback to first part found
			for _, part in ipairs(newModel:GetChildren()) do
				if part:IsA("BasePart") then
					newModel.PrimaryPart = part
					break
				end
			end
		end
	end

	newModel.Parent = character
	
	-- Weld Logic
	local welded = false
	
	-- If Character type, try animation welding first
	if config.Type ~= "Object" then
		-- R6 to R15 Mapping Table
		local R6_TO_R15_MAP = {
			["Torso"] = "UpperTorso",
			["Left Arm"] = "LeftUpperArm",
			["Right Arm"] = "RightUpperArm",
			["Left Leg"] = "LeftUpperLeg",
			["Right Leg"] = "RightUpperLeg",
			["Head"] = "Head"
		}
		
		-- Attempt to weld individual parts for animation support
		local weldedCount = 0
		
		for _, part in ipairs(newModel:GetDescendants()) do
			if part:IsA("BasePart") then
				-- Setup physics properties
				part.Massless = true
				part.CanCollide = false
				part.Anchored = false
				
				-- Find matching part in character
				local targetPart = character:FindFirstChild(part.Name)
				
				-- Try mapping if direct match fails
				if not targetPart then
					local mappedName = R6_TO_R15_MAP[part.Name]
					if mappedName then
						targetPart = character:FindFirstChild(mappedName)
						if targetPart then
							print("[TransformationService] Mapped " .. part.Name .. " -> " .. mappedName)
						end
					end
				end

				if targetPart and targetPart:IsA("BasePart") then
					-- Align and Weld
					part.CFrame = targetPart.CFrame
					
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = targetPart
					weld.Part1 = part
					weld.Parent = part
					
					weldedCount = weldedCount + 1
				end
			end
		end
		
		if weldedCount > 0 then
			print("[TransformationService] Successfully welded " .. weldedCount .. " parts for animation.")
			welded = true
		else
			warn("[TransformationService] No matching parts found for animation. Falling back to static weld.")
		end
	end
	
	-- Fallback or Object type: Static Weld
	if not welded then
		if newModel.PrimaryPart then
			print("[TransformationService] Performing static weld for " .. transformationId)
			
			-- Ensure physics properties for static objects (fix for "stuck" issue)
			for _, part in ipairs(newModel:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = false
					part.CanCollide = false
					part.Massless = true
					part.CanQuery = false -- Ignore raycasts
					part.CanTouch = false -- Ignore touch events
					
					-- Auto-weld to PrimaryPart if not already welded (fix for "falling apart" issue)
					if part ~= newModel.PrimaryPart then
						local internalWeld = Instance.new("WeldConstraint")
						internalWeld.Part0 = newModel.PrimaryPart
						internalWeld.Part1 = part
						internalWeld.Parent = part
					end
				end
			end
			
			-- Apply Offset and Rotation if defined
			local offset = config.Offset or Vector3.new(0, 0, 0)
			
			-- Auto-Ground Logic
			if config.AutoGround and humanoid then
				-- 1. Calculate distance from RootPart center to ground
				-- HipHeight is distance from bottom of RootPart to ground.
				-- RootPart center is HipHeight + (Size.Y / 2) above ground.
				local distToGround = humanoid.HipHeight + (rootPart.Size.Y / 2)
				
				-- 2. Calculate distance from Model PrimaryPart to Model bottom
				local orientation, size = newModel:GetBoundingBox()
				local primaryPartY = newModel.PrimaryPart.Position.Y
				local bottomY = orientation.Position.Y - (size.Y / 2)
				local distToBottom = primaryPartY - bottomY
				
				-- 3. Calculate required offset Y
				-- We want Model Bottom to be at Ground Level (0 relative to ground)
				-- Currently Model Center is at RootPart Center (distToGround above ground)
				-- So we need to move down by (distToGround - distToBottom) ? 
				-- Wait, let's think relative to RootPart.
				-- RootPart Y = Ground + distToGround
				-- We want Model Bottom Y = Ground
				-- Model PrimaryPart Y = Model Bottom Y + distToBottom = Ground + distToBottom
				-- So Target PrimaryPart Y = (RootPart Y - distToGround) + distToBottom
				-- Offset Y = Target PrimaryPart Y - RootPart Y
				-- Offset Y = -distToGround + distToBottom
				
				local autoOffsetY = -distToGround + distToBottom
				
				-- Add a small buffer to avoid clipping or floating due to precision
				autoOffsetY = autoOffsetY - 0.1 
				
				offset = offset + Vector3.new(0, autoOffsetY, 0)
				print("[TransformationService] AutoGround calculated offset: " .. autoOffsetY)
			end

			local rotation = config.Rotation or Vector3.new(0, 0, 0)
			
			local rotationCFrame = CFrame.Angles(
				math.rad(rotation.X),
				math.rad(rotation.Y),
				math.rad(rotation.Z)
			)
			
			newModel:SetPrimaryPartCFrame(rootPart.CFrame * CFrame.new(offset) * rotationCFrame)
			
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = rootPart
			weld.Part1 = newModel.PrimaryPart
			weld.Parent = newModel.PrimaryPart
		else
			warn("[TransformationService] CRITICAL: Failed to weld model. No PrimaryPart found.")
			newModel:Destroy()
		end
	end

	-- Schedule restore
	task.delay(config.Duration, function()
		self:Restore(player)
	end)
end

function TransformationService:Restore(player)
	local data = self.ActiveTransformations[player]
	if not data then return end
	
	print(player.Name .. " restoring to normal")
	
	local character = player.Character
	
	if character then
		-- 1. Remove new model
		local transformationModel = character:FindFirstChild("TransformationModel")
		if transformationModel then
			transformationModel:Destroy()
		end
		
		-- 2. Remove temporary assets (Clothing/Colors)
		local assetTypes = {"Shirt", "Pants", "ShirtGraphic", "BodyColors", "Accessory"}
		for _, child in ipairs(character:GetChildren()) do
			for _, assetType in ipairs(assetTypes) do
				if child:IsA(assetType) then
					child:Destroy()
				end
			end
		end

		-- 3. Restore original assets
		if data.OriginalAssets then
			for _, asset in ipairs(data.OriginalAssets) do
				asset.Parent = character
			end
		end

		-- 4. Restore visibility
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.Transparency = 0
			elseif part:IsA("Decal") then
				part.Transparency = 0
			end
		end
	end
	
	self.ActiveTransformations[player] = nil
end

function TransformationService.Client:RequestTransform(player, transformationId)
	return self.Server:Transform(player, transformationId)
end

return TransformationService
