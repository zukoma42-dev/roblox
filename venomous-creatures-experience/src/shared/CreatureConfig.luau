-- 毒生物アセット設定
-- このファイルはReplicatedStorage.Sharedに配置されます
-- アセットごとの設定を管理し、汎用的な変身システムを実現します

local CreatureConfig = {}

-- 各毒生物タイプの設定
-- 注意: ほとんどの設定はオプションです。設定しない場合はデフォルト値が使用されます
CreatureConfig.CREATURES = {
	Snake = {
		-- モデル名（ServerStorage内の名前）
		modelName = "SnakeModel",
		
		-- オプション: PrimaryPartの名前（nilの場合は自動検出）
		primaryPartName = nil,
		
		-- オプション: 位置オフセット（HumanoidRootPartからの相対位置）
		-- アセットの位置を微調整したい場合に使用
		positionOffset = Vector3.new(0, 0, 0),
		
		-- オプション: 回転オフセット（アセットの向きを微調整したい場合に使用）
		-- デフォルトではアセットの元の向きがそのまま使用されます
		rotationOffset = CFrame.Angles(0, 0, 0),
		
		-- オプション: HumanoidRootPartをアセットの位置に合わせるかどうか
		-- true: HumanoidRootPartをアセットの位置に移動（アセットの元の位置を保持）
		-- false: アセットをHumanoidRootPartの位置に移動（デフォルト）
		alignHumanoidRootPartToAsset = false,
	},
	
	Frog = {
		modelName = "FrogModel",
		primaryPartName = nil,
		positionOffset = Vector3.new(0, 0, 0),
		rotationOffset = CFrame.Angles(0, 0, 0),
		alignHumanoidRootPartToAsset = false,
	},
	
	Scorpion = {
		modelName = "ScorpionModel",
		primaryPartName = nil,
		positionOffset = Vector3.new(0, 0, 0),
		rotationOffset = CFrame.Angles(0, 0, 0),
		alignHumanoidRootPartToAsset = false,
	},
	
	Mushroom = {
		modelName = "MushroomModel",
		primaryPartName = nil,
		positionOffset = Vector3.new(0, 0, 0),
		rotationOffset = CFrame.Angles(0, 0, 0),
		alignHumanoidRootPartToAsset = false,
	},
	
	Jellyfish = {
		modelName = "JellyfishModel",
		primaryPartName = nil,
		positionOffset = Vector3.new(0, 0, 0),
		rotationOffset = CFrame.Angles(0, 0, 0),
		alignHumanoidRootPartToAsset = false,
	},
	
	Salamander = {
		modelName = "SalamanderModel",
		primaryPartName = nil,
		positionOffset = Vector3.new(0, 0, 0),
		rotationOffset = CFrame.Angles(0, 0, 0),
		alignHumanoidRootPartToAsset = false,
	},
}

-- デフォルト設定（各アセットで設定されていない場合に使用）
CreatureConfig.DEFAULT = {
	primaryPartName = nil, -- nilの場合は最初のBasePartを使用
	positionOffset = Vector3.new(0, 0, 0),
	rotationOffset = CFrame.Angles(0, 0, 0),
	alignHumanoidRootPartToAsset = false, -- デフォルトではアセットをHumanoidRootPartの位置に移動
}

-- 設定を取得する関数（デフォルト値とマージ）
function CreatureConfig.getConfig(creatureType: string): {[string]: any}
	local config = CreatureConfig.CREATURES[creatureType] or {}
	local default = CreatureConfig.DEFAULT
	
	return {
		modelName = config.modelName or (creatureType .. "Model"),
		primaryPartName = config.primaryPartName or default.primaryPartName,
		positionOffset = config.positionOffset or default.positionOffset,
		rotationOffset = config.rotationOffset or default.rotationOffset,
		alignHumanoidRootPartToAsset = config.alignHumanoidRootPartToAsset ~= nil and config.alignHumanoidRootPartToAsset or default.alignHumanoidRootPartToAsset,
	}
end

return CreatureConfig

