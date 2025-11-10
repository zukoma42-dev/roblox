# Roblox Project

## 概要

このプロジェクトはRoblox関連の開発プロジェクトです。モノレポ構造で複数のエクスペリエンスを管理します。

## セットアップ

### 必要なツール

- **Wally** - Roblox用パッケージマネージャー
- **Rojo** - ローカルファイルシステムとRoblox Studioを同期するツール

### インストール済みライブラリ

以下のライブラリがWallyで管理されています：

#### Sharedパッケージ（クライアント・サーバー両方で使用可能）
- **Fusion** - 状態管理とUI構築
- **Replica** - サーバーとクライアント間のデータ同期
- **Promise** - 非同期処理のチェーン化
- **FastSignal** - イベントパラメータの参照渡しと高速化
- **RbxUtils** - 各種ユーティリティ関数
- **ZonePlus** - 空間範囲の管理と検出
- **Janitor** - リソース管理とクリーンアップ
- **Trove** - リソース管理とクリーンアップ

#### Serverパッケージ（サーバー側のみ）
- **ProfileStore** - プレイヤーのセーブデータ管理

### 新しいエクスペリエンスの作成

1. エクスペリエンスフォルダを作成：
   ```bash
   mkdir -p your-experience-name/src/{shared,server,client}
   ```

2. エクスペリエンスフォルダでRojoプロジェクトを初期化：
   ```bash
   cd your-experience-name
   rojo init
   ```

3. `default.project.json`を編集して、ルートの`Packages/`と`ServerPackages/`を参照するように設定：
   ```json
   {
     "name": "your-experience-name",
     "tree": {
       "$className": "DataModel",
       "ReplicatedStorage": {
         "$className": "ReplicatedStorage",
         "Packages": {
           "$path": "../Packages"
         },
         "Shared": {
           "$path": "src/shared"
         }
       },
       "ServerStorage": {
         "$className": "ServerStorage",
         "Packages": {
           "$path": "../ServerPackages"
         }
       },
       "ServerScriptService": {
         "Server": {
           "$path": "src/server"
         }
       },
       "StarterPlayer": {
         "StarterPlayerScripts": {
           "Client": {
             "$path": "src/client"
           }
         }
       }
     }
   }
   ```

## 使用方法

### Rojoサーバーの起動

各エクスペリエンスフォルダでRojoサーバーを起動：

```bash
cd your-experience-name
rojo serve
```

### Roblox Studioとの接続

1. Roblox Studioを開く
2. **File** > **Advanced** > **Studio Settings** から **Allow HTTP Requests** を有効にする
3. Roblox StudioのToolboxから「Rojo」プラグインをインストール
4. Rojoプラグインを開き、表示されたURLに接続

### ライブラリの使用

インストール済みのライブラリは以下のように使用できます：

```lua
-- Sharedパッケージ（ReplicatedStorage.Packagesから）
local Fusion = require(game.ReplicatedStorage.Packages.fusion)
local Promise = require(game.ReplicatedStorage.Packages.promise)
local Replica = require(game.ReplicatedStorage.Packages.replica)

-- Serverパッケージ（ServerStorage.Packagesから）
local ProfileStore = require(game.ServerStorage.Packages.profilestore)
```

## プロジェクト構造

```
roblox/
├── Packages/              # Wallyで管理されたSharedパッケージ
├── ServerPackages/        # Wallyで管理されたServerパッケージ
├── wally.toml            # Wallyの設定ファイル
├── wally.lock            # パッケージのバージョン固定ファイル
├── example-experience/    # サンプルエクスペリエンス
│   ├── default.project.json
│   └── src/
│       ├── shared/
│       ├── server/
│       └── client/
└── your-experience-name/  # 新しいエクスペリエンス
    ├── default.project.json
    └── src/
        ├── shared/
        ├── server/
        └── client/
```

## ライセンス

ライセンス情報をここに記載します。

