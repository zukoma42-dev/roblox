-- ゲーム設定
-- このファイルはReplicatedStorage.Sharedに配置されます

local Config = {}

-- MVPでは1種類の毒生物のみ
Config.DEFAULT_CREATURE_TYPE = "Snake" -- 毒ヘビ

-- ゲームモード設定
Config.MAX_PLAYERS = 50

-- デバッグ設定
Config.DEBUG_MODE = false
Config.SHOW_DEBUG_INFO = false

return Config

