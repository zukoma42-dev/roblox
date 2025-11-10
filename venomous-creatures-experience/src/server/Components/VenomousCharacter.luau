-- 毒生物キャラクターコンポーネント
-- このファイルはServerScriptService.Server.Componentsに配置されます

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local Config = require(Shared:WaitForChild("Config"))
local GrowthSystem = require(Shared:WaitForChild("Utils"):WaitForChild("GrowthSystem"))
local CreatureTypes = require(Shared:WaitForChild("Utils"):WaitForChild("CreatureTypes"))
local CreatureConfig = require(Shared:WaitForChild("CreatureConfig"))

local VenomousCharacter = {}
VenomousCharacter.__index = VenomousCharacter

-- 新しい毒生物キャラクターを作成
function VenomousCharacter.new(player: Player)
	local self = setmetatable({}, VenomousCharacter)
	
	self.player = player
	self.character = nil
	self.humanoid = nil
	self.creatureModel = nil
	self.size = Constants.INITIAL_SIZE
	self.creatureType = Config.DEFAULT_CREATURE_TYPE
	
	return self
end

-- キャラクターを初期化（プレイヤーがスポーンしたときに呼ばれる）
function VenomousCharacter:initialize()
	local character = self.player.Character or self.player.CharacterAdded:Wait()
	self.character = character
	self.humanoid = character:WaitForChild("Humanoid")
	
	-- 毒生物に変身
	self:transformToCreature()
	
	-- サイズを設定
	self:setSize(self.size)
end

-- 毒生物に変身
-- アセットの元の配置・向きをそのまま利用する汎用的なシステム
function VenomousCharacter:transformToCreature()
	if not self.character then
		warn("Character is not initialized")
		return
	end
	
	-- アセット設定を取得
	local assetConfig = CreatureConfig.getConfig(self.creatureType)
	local modelName = assetConfig.modelName
	
	-- ServerStorageからモデルまたはPartを取得
	local ServerStorage = game:GetService("ServerStorage")
	local modelTemplate = ServerStorage:FindFirstChild(modelName)
	
	if not modelTemplate then
		warn("Model/Part not found in ServerStorage:", modelName)
		warn("Please add a Model or Part to ServerStorage with the name:", modelName)
		return
	end
	
	-- 既存のキャラクターパーツを非表示
	-- 注意: HumanoidRootPartは残す必要がある
	for _, part in ipairs(self.character:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = 1
			part.CanCollide = false
		end
	end
	
	-- アクセサリーや装飾品も非表示
	for _, accessory in ipairs(self.character:GetChildren()) do
		if accessory:IsA("Accessory") then
			accessory:Destroy()
		end
	end
	
	-- モデルまたはPartを複製（元の状態を保持するため、先に複製）
	local creatureModel = modelTemplate:Clone()
	
	-- HumanoidRootPartを取得
	local humanoidRootPart = self.character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		warn("HumanoidRootPart not found")
		return
	end
	
	-- モデル内のHumanoidを削除（既存のHumanoidを使用）
	for _, child in ipairs(creatureModel:GetDescendants()) do
		if child:IsA("Humanoid") then
			child:Destroy()
		end
	end
	
	-- アセット内の既存の接続を確認・保存
	-- 注意: パーツ間の接続（Weld、WeldConstraint）は保持し、Motor6Dのみ削除
	-- これにより、アセットの元の構造が保持されます
	local existingWelds = {}
	for _, descendant in ipairs(creatureModel:GetDescendants()) do
		if descendant:IsA("Motor6D") then
			-- Motor6Dは削除（新しい接続を作成するため）
			descendant:Destroy()
		elseif descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
			-- WeldとWeldConstraintは保持（アセットの元の構造を維持）
			-- ただし、HumanoidRootPartへの接続は削除
			if descendant.Part0 and descendant.Part0.Name == "HumanoidRootPart" then
				descendant:Destroy()
			elseif descendant.Part1 and descendant.Part1.Name == "HumanoidRootPart" then
				descendant:Destroy()
			else
				-- パーツ間の接続は保持
				table.insert(existingWelds, descendant)
			end
		end
	end
	
	-- すべてのパーツのAnchoredをfalseに設定（念のため）
	for _, descendant in ipairs(creatureModel:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = false
		end
	end
	
	-- モデルまたはPartが直接BasePartの場合（シンプルなPartの場合）
	if creatureModel:IsA("BasePart") then
		-- アセットの元のCFrameを保存（位置・向きを保持）
		local originalCFrame = creatureModel.CFrame
		
		-- モデルをキャラクターの子として配置
		creatureModel.Parent = self.character
		creatureModel.Anchored = false
		creatureModel.CanCollide = false
		
		-- アセットの元の向きを保持しながら、HumanoidRootPartの位置に配置
		-- アセットのForward方向をそのまま利用
		local targetPosition = humanoidRootPart.Position + assetConfig.positionOffset
		local targetRotation = originalCFrame.Rotation
		
		-- 回転オフセットを適用
		targetRotation = targetRotation * assetConfig.rotationOffset.Rotation
		
		creatureModel.CFrame = CFrame.new(targetPosition) * targetRotation
		
		-- Motor6Dを作成してHumanoidRootPartに接続
		local motor = Instance.new("Motor6D")
		motor.Part0 = humanoidRootPart
		motor.Part1 = creatureModel
		
		-- 相対位置を計算（アセットの元の位置関係を保持）
		local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(creatureModel.CFrame)
		motor.C0 = CFrame.new()
		motor.C1 = relativeCFrame
		motor.Parent = humanoidRootPart
		
		creatureModel.Name = "CreaturePart"
		self.creatureModel = creatureModel
		return
	end
	
	-- モデル内のすべてのBasePartを取得
	local modelParts = {}
	for _, descendant in ipairs(creatureModel:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(modelParts, descendant)
		end
	end
	
	if #modelParts == 0 then
		warn("No BasePart found in model:", modelName)
		warn("Model structure:", creatureModel:GetChildren())
		return
	end
	
	-- デバッグ: アセットの構造を出力
	print("Found", #modelParts, "BasePart(s) in model:", modelName)
	for i, part in ipairs(modelParts) do
		print("  Part", i, ":", part.Name, "at", part.Position)
	end
	
	-- PrimaryPartを検出
	local primaryPart = nil
	if assetConfig.primaryPartName then
		-- 設定で指定されている場合はそれを使用
		for _, part in ipairs(modelParts) do
			if part.Name == assetConfig.primaryPartName then
				primaryPart = part
				break
			end
		end
		if not primaryPart then
			warn("PrimaryPart not found:", assetConfig.primaryPartName, "Using first part instead")
		end
	end
	
	-- PrimaryPartが未指定の場合は最初のパーツを使用
	if not primaryPart then
		primaryPart = modelParts[1]
	end
	
	-- モデルのPrimaryPartを設定
	if creatureModel:IsA("Model") then
		creatureModel.PrimaryPart = primaryPart
	end
	
	-- 重要: アセットの元のCFrameを保存（位置・向きを保持）
	-- アセットがServerStorageにある時点での状態を保存
	local originalPrimaryCFrame = primaryPart.CFrame
	
	-- モデル内のパーツ間の相対位置を保存（PrimaryPartを基準に）
	-- これにより、アセットの元の構造を完全に保持
	local relativePositions = {}
	for _, part in ipairs(modelParts) do
		local relativeCFrame = originalPrimaryCFrame:ToObjectSpace(part.CFrame)
		relativePositions[part] = relativeCFrame
	end
	
	-- モデルをキャラクターの子として配置
	creatureModel.Parent = self.character
	
	-- アセットの配置方法を決定
	if assetConfig.alignHumanoidRootPartToAsset then
		-- オプション1: HumanoidRootPartをアセットの位置に合わせる
		-- アセットの元の位置をそのまま保持
		local targetPosition = originalPrimaryCFrame.Position + assetConfig.positionOffset
		local targetRotation = originalPrimaryCFrame.Rotation * assetConfig.rotationOffset.Rotation
		
		-- HumanoidRootPartをアセットの位置・向きに移動
		humanoidRootPart.CFrame = CFrame.new(targetPosition) * targetRotation
		
		-- PrimaryPartを元の位置に配置（アセットの元の位置を保持）
		primaryPart.CFrame = originalPrimaryCFrame * CFrame.new(assetConfig.positionOffset) * assetConfig.rotationOffset
		
		-- 他のパーツをPrimaryPartからの相対位置で配置（元の構成を保持）
		for part, relativeCFrame in pairs(relativePositions) do
			if part ~= primaryPart then
				part.CFrame = primaryPart.CFrame:ToWorldSpace(relativeCFrame)
			end
		end
	else
		-- オプション2: アセットをHumanoidRootPartの位置に合わせる（デフォルト）
		-- ただし、アセットの元の向きは保持
		local targetPosition = humanoidRootPart.Position + assetConfig.positionOffset
		local targetRotation = originalPrimaryCFrame.Rotation * assetConfig.rotationOffset.Rotation
		
		-- PrimaryPartをHumanoidRootPartの位置に配置（アセットの元の向きを保持）
		primaryPart.CFrame = CFrame.new(targetPosition) * targetRotation
		
		-- 他のパーツをPrimaryPartからの相対位置で配置（元の構成を保持）
		for part, relativeCFrame in pairs(relativePositions) do
			if part ~= primaryPart then
				part.CFrame = primaryPart.CFrame:ToWorldSpace(relativeCFrame)
			end
		end
	end
	
	-- 接続方法を決定
	-- アセット内に既存の接続（Weld、WeldConstraint）がある場合は、それらを保持
	-- PrimaryPartだけをHumanoidRootPartに接続し、他のパーツはアセットの元の構造を保持
	
	if #existingWelds > 0 then
		-- アセット内に既存の接続がある場合：PrimaryPartだけをHumanoidRootPartに接続
		-- 他のパーツは既存の接続（Weld、WeldConstraint）で接続されているため、そのまま保持
		
		-- PrimaryPartをHumanoidRootPartに接続
		local motor = Instance.new("Motor6D")
		motor.Part0 = humanoidRootPart
		motor.Part1 = primaryPart
		
		-- 相対位置を計算
		local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(primaryPart.CFrame)
		motor.C0 = CFrame.new()
		motor.C1 = relativeCFrame
		motor.Parent = humanoidRootPart
		
		-- すべてのパーツの物理演算を無効にする
		for _, part in ipairs(modelParts) do
			part.Anchored = false
			part.CanCollide = false
		end
		
		print("Using existing welds for", #existingWelds, "connections. PrimaryPart connected to HumanoidRootPart.")
	else
		-- アセット内に既存の接続がない場合：すべてのパーツをHumanoidRootPartに接続
		-- または、PrimaryPartを基準に階層的に接続
		
		-- PrimaryPartをHumanoidRootPartに接続
		local primaryMotor = Instance.new("Motor6D")
		primaryMotor.Part0 = humanoidRootPart
		primaryMotor.Part1 = primaryPart
		
		local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(primaryPart.CFrame)
		primaryMotor.C0 = CFrame.new()
		primaryMotor.C1 = relativeCFrame
		primaryMotor.Parent = humanoidRootPart
		
		-- 他のパーツをPrimaryPartに接続（アセットの元の構造を保持）
		for _, part in ipairs(modelParts) do
			if part ~= primaryPart then
				-- PrimaryPartを基準とした相対位置を計算
				local relativeCFrame = primaryPart.CFrame:ToObjectSpace(part.CFrame)
				
				-- Motor6Dを作成してPrimaryPartに接続
				local motor = Instance.new("Motor6D")
				motor.Part0 = primaryPart
				motor.Part1 = part
				motor.C0 = CFrame.new()
				motor.C1 = relativeCFrame
				motor.Parent = primaryPart
			end
			
			-- 物理演算を無効にする
			part.Anchored = false
			part.CanCollide = false
		end
		
		print("Created hierarchical connections. PrimaryPart connected to HumanoidRootPart, other parts connected to PrimaryPart.")
	end
	
	-- モデル内にHumanoidRootPartがある場合は削除（既存のものを使用）
	local modelRootPart = creatureModel:FindFirstChild("HumanoidRootPart")
	if modelRootPart then
		modelRootPart:Destroy()
	end
	
	self.creatureModel = creatureModel
end

-- サイズを設定
function VenomousCharacter:setSize(newSize: number)
	self.size = math.clamp(newSize, Constants.MIN_SIZE, Constants.MAX_SIZE)
	
	if not self.character then
		return
	end
	
	-- キャラクター全体をスケール
	local scale = GrowthSystem.calculateScale(self.size)
	
	-- HumanoidRootPartのサイズを調整
	local humanoidRootPart = self.character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart then
		humanoidRootPart.Size = Vector3.new(2, 2, 1) * self.size
	end
	
	-- 各パーツのサイズを調整（creatureModel内のパーツも含む）
	for _, part in ipairs(self.character:GetDescendants()) do
		if part:IsA("BasePart") and part ~= humanoidRootPart then
			-- 初期サイズを保存（初回のみ）- 各軸のサイズを個別に保存
			if not part:GetAttribute("InitialSizeX") then
				part:SetAttribute("InitialSizeX", part.Size.X)
				part:SetAttribute("InitialSizeY", part.Size.Y)
				part:SetAttribute("InitialSizeZ", part.Size.Z)
			end
			
			-- サイズを調整（各軸の比率を保持）
			local initialSizeX = part:GetAttribute("InitialSizeX") or 1
			local initialSizeY = part:GetAttribute("InitialSizeY") or 1
			local initialSizeZ = part:GetAttribute("InitialSizeZ") or 1
			part.Size = Vector3.new(
				initialSizeX * self.size,
				initialSizeY * self.size,
				initialSizeZ * self.size
			)
		end
	end
	
	-- creatureModel内のパーツもサイズ調整
	if self.creatureModel then
		for _, part in ipairs(self.creatureModel:GetDescendants()) do
			if part:IsA("BasePart") then
				-- 初期サイズを保存（初回のみ）- 各軸のサイズを個別に保存
				if not part:GetAttribute("InitialSizeX") then
					part:SetAttribute("InitialSizeX", part.Size.X)
					part:SetAttribute("InitialSizeY", part.Size.Y)
					part:SetAttribute("InitialSizeZ", part.Size.Z)
				end
				
				-- サイズを調整（各軸の比率を保持）
				local initialSizeX = part:GetAttribute("InitialSizeX") or 1
				local initialSizeY = part:GetAttribute("InitialSizeY") or 1
				local initialSizeZ = part:GetAttribute("InitialSizeZ") or 1
				part.Size = Vector3.new(
					initialSizeX * self.size,
					initialSizeY * self.size,
					initialSizeZ * self.size
				)
			end
		end
	end
	
	-- 移動速度を調整
	if self.humanoid then
		local speed = GrowthSystem.calculateSpeed(self.size)
		self.humanoid.WalkSpeed = speed
	end
end

-- サイズを取得
function VenomousCharacter:getSize(): number
	return self.size
end

-- 成長（アイテム取得時）
function VenomousCharacter:growFromItem()
	local newSize = GrowthSystem.growFromItem(self.size)
	self:setSize(newSize)
end

-- 成長（プレイヤー捕食時）
function VenomousCharacter:growFromPlayer()
	local newSize = GrowthSystem.growFromPlayer(self.size)
	self:setSize(newSize)
end

-- クリーンアップ
function VenomousCharacter:destroy()
	-- リソースのクリーンアップ
	self.character = nil
	self.humanoid = nil
	self.creatureModel = nil
end

return VenomousCharacter

