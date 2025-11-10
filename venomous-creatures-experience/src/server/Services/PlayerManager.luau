-- プレイヤー管理サービス
-- このファイルはServerScriptService.Server.Servicesに配置されます

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Server = script.Parent.Parent
local Components = Server:WaitForChild("Components")
local VenomousCharacter = require(Components:WaitForChild("VenomousCharacter"))

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local PlayerManager = {}

-- プレイヤーデータを保存
local playerCharacters: {[Player]: VenomousCharacter.VenomousCharacter} = {}

-- プレイヤーが参加したときの処理
local function onPlayerAdded(player: Player)
	print("Player joined:", player.Name)
	
	-- 毒生物キャラクターを作成
	local character = VenomousCharacter.new(player)
	playerCharacters[player] = character
	
	-- キャラクターがスポーンしたときに初期化
	if player.Character then
		character:initialize()
	end
	
	-- キャラクターが再スポーンしたときの処理
	player.CharacterAdded:Connect(function()
		character:initialize()
	end)
end

-- プレイヤーが退出したときの処理
local function onPlayerRemoving(player: Player)
	print("Player left:", player.Name)
	
	local character = playerCharacters[player]
	if character then
		character:destroy()
		playerCharacters[player] = nil
	end
end

-- サービスを開始
function PlayerManager:start()
	print("PlayerManager started")
	
	-- 既存のプレイヤーに対して処理
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	
	-- 新しいプレイヤーの参加を監視
	Players.PlayerAdded:Connect(onPlayerAdded)
	
	-- プレイヤーの退出を監視
	Players.PlayerRemoving:Connect(onPlayerRemoving)
end

-- プレイヤーのキャラクターを取得
function PlayerManager:getCharacter(player: Player): VenomousCharacter.VenomousCharacter?
	return playerCharacters[player]
end

return PlayerManager

