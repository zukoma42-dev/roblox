-- 毒生物タイプの定義
-- このファイルはReplicatedStorage.Shared.Utilsに配置されます

local Types = require(script.Parent.Parent.Types)

local CreatureTypes = {}

-- 毒生物のモデルID（ツールボックスから取得したモデルのID）
-- 注意: 実際のモデルIDはRoblox Studioで取得した後に更新してください
CreatureTypes.MODEL_IDS = {
	Snake = nil, -- ここに毒ヘビのモデルIDを設定
	Frog = nil,
	Scorpion = nil,
	Mushroom = nil,
	Jellyfish = nil,
	Salamander = nil,
}

-- 毒生物の基本情報
CreatureTypes.INFO = {
	Snake = {
		name = "毒ヘビ",
		description = "基本的な毒生物",
	},
	Frog = {
		name = "毒ガエル",
		description = "跳躍力が高い",
	},
	Scorpion = {
		name = "毒サソリ",
		description = "攻撃力が高い",
	},
	Mushroom = {
		name = "毒キノコ",
		description = "隠れ身が得意",
	},
	Jellyfish = {
		name = "毒クラゲ",
		description = "水中で有利",
	},
	Salamander = {
		name = "毒イモリ",
		description = "バランス型",
	},
}

-- モデルIDを設定する関数
function CreatureTypes.setModelId(creatureType: Types.CreatureType, modelId: number)
	CreatureTypes.MODEL_IDS[creatureType] = modelId
end

-- モデルIDを取得する関数
function CreatureTypes.getModelId(creatureType: Types.CreatureType): number?
	return CreatureTypes.MODEL_IDS[creatureType]
end

return CreatureTypes

