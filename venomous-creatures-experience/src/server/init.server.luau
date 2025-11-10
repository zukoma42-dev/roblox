-- サーバー側の初期化スクリプト
-- このファイルはServerScriptService.Serverに配置されます

print("Venomous Creatures Experience - Server initialized")

-- サービスを初期化
local Services = script:WaitForChild("Services")
local PlayerManager = require(Services:WaitForChild("PlayerManager"))

-- アセット構造を確認（デバッグ用）
local AssetInspector = require(Services:WaitForChild("AssetInspector"))
AssetInspector:inspectModel("SnakeModel")

-- プレイヤー管理サービスを開始
PlayerManager:start()

