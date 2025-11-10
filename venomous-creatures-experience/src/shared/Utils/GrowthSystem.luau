-- 成長システムの計算ユーティリティ
-- このファイルはReplicatedStorage.Shared.Utilsに配置されます

local Constants = require(script.Parent.Parent.Constants)

local GrowthSystem = {}

-- サイズに応じた移動速度を計算
-- @param size: 現在のサイズ
-- @return: 計算された移動速度（studs/s）
function GrowthSystem.calculateSpeed(size: number): number
	local speed = Constants.BASE_SPEED * (1 / math.pow(size, Constants.SPEED_SCALE_POWER))
	return math.max(speed, 2) -- 最低速度を2 studs/sに設定
end

-- アイテム取得時の成長後のサイズを計算
-- @param currentSize: 現在のサイズ
-- @return: 成長後のサイズ
function GrowthSystem.growFromItem(currentSize: number): number
	local newSize = currentSize + Constants.ITEM_GROWTH_AMOUNT
	return math.min(newSize, Constants.MAX_SIZE)
end

-- プレイヤー捕食時の成長後のサイズを計算
-- @param currentSize: 現在のサイズ
-- @return: 成長後のサイズ
function GrowthSystem.growFromPlayer(currentSize: number): number
	local newSize = currentSize + Constants.PLAYER_EAT_GROWTH_AMOUNT
	return math.min(newSize, Constants.MAX_SIZE)
end

-- 捕食可能かどうかを判定
-- @param predatorSize: 捕食者のサイズ
-- @param preySize: 被食者のサイズ
-- @return: 捕食可能な場合true
function GrowthSystem.canPredate(predatorSize: number, preySize: number): boolean
	if predatorSize <= preySize then
		return false
	end
	local ratio = predatorSize / preySize
	return ratio >= Constants.PREDATION_SIZE_RATIO
end

-- サイズからスケール値を計算（モデルのスケール用）
-- @param size: 現在のサイズ
-- @return: Vector3のスケール値
function GrowthSystem.calculateScale(size: number): Vector3
	return Vector3.new(size, size, size)
end

return GrowthSystem

