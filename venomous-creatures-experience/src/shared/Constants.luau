-- 定数定義
-- このファイルはReplicatedStorage.Sharedに配置されます

local Constants = {}

-- サイズ設定
Constants.INITIAL_SIZE = 1.0
Constants.MAX_SIZE = 10.0
Constants.MIN_SIZE = 0.5

-- 成長設定
Constants.ITEM_GROWTH_AMOUNT = 0.1
Constants.PLAYER_EAT_GROWTH_AMOUNT = 0.5
Constants.PREDATION_SIZE_RATIO = 1.5 -- この倍率以上のサイズ差で捕食可能

-- 移動設定
Constants.BASE_SPEED = 16 -- studs/s
Constants.SPEED_SCALE_POWER = 0.3 -- 速度計算式で使用

-- アイテム設定
Constants.ITEM_SPAWN_INTERVAL_MIN = 5 -- 秒
Constants.ITEM_SPAWN_INTERVAL_MAX = 10 -- 秒
Constants.MAX_ITEMS_ON_MAP = 30
Constants.MIN_ITEMS_ON_MAP = 20

-- リスポーン設定
Constants.RESPAWN_POSITION = Vector3.new(0, 5, 0) -- マップ中心
Constants.INVINCIBILITY_DURATION = 3 -- 秒

-- マップ設定
Constants.MAP_SIZE = 512 -- studs
Constants.MAP_HEIGHT = 20 -- studs

return Constants

