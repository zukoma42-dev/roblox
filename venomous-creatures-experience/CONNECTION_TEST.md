# Rojo接続テストガイド

## ✅ 現在の状態

- ✅ Rojoサーバーが起動中（ポート34872）
- ✅ `default.project.json`が存在
- ✅ プロジェクト構造が準備済み

## 🔌 Roblox Studioとの接続手順

### ステップ1: Roblox Studioを開く

1. Roblox Studioを起動
2. **新しいプレースを作成**するか、既存のプレースを開く
   - 「新規バーチャル空間」をクリック
   - または、既存のプレースを開く

### ステップ2: Rojoプラグインで接続

1. **Rojoプラグインのアイコンを探す**
   - Roblox Studioの上部ツールバーにRojoのアイコンがあるはずです
   - パズルピースのアイコンを探してください

2. **プラグインを開く**
   - Rojoアイコンをクリック
   - または、Pluginsタブから「Rojo」を選択

3. **接続**
   - プラグインウィンドウに接続URLが表示されます
   - 通常は `rojo://localhost:34872` と表示されます
   - 「Connect」ボタンをクリック

### ステップ3: 接続確認

接続が成功すると、以下の構造がRoblox StudioのExplorerに表示されます：

```
ReplicatedStorage
  └── Shared
      ├── Types.luau
      ├── Constants.luau
      ├── Config.luau
      └── Utils
          └── GrowthSystem.luau

ServerScriptService
  └── Server
      └── init.server.luau

StarterPlayer
  └── StarterPlayerScripts
      └── Client
          └── init.client.luau
```

### ステップ4: 動作確認

1. **Roblox Studioで「Play」をクリック**
2. **Outputウィンドウを開く**（View > Output）
3. **以下のメッセージが表示されることを確認**：
   ```
   Venomous Creatures Experience - Server initialized
   Venomous Creatures Experience - Client initialized
   ```

## 🧪 テスト手順

### テスト1: ファイルの同期確認

1. `src/server/init.server.luau`を開く
2. 以下のように編集：
   ```lua
   print("Venomous Creatures Experience - Server initialized")
   print("TEST: Rojo接続成功！")
   ```
3. ファイルを保存
4. Roblox Studioで自動的に反映されることを確認
5. 「Play」をクリックして、Outputに「TEST: Rojo接続成功！」が表示されることを確認

### テスト2: 新しいファイルの追加

1. `src/shared/Test.luau`という新しいファイルを作成：
   ```lua
   return {
       message = "これはテストです"
   }
   ```
2. ファイルを保存
3. Roblox StudioのExplorerで`ReplicatedStorage.Shared.Test`が表示されることを確認

## 🐛 トラブルシューティング

### 接続できない場合

1. **Rojoサーバーが起動しているか確認**
   ```bash
   lsof -i :34872
   ```
   何も表示されない場合は、Rojoサーバーを再起動：
   ```bash
   cd /Users/kazushikojima/Desktop/roblox/venomous-creatures-experience
   rojo serve
   ```

2. **Roblox Studioの設定を確認**
   - File > Advanced > Studio Settings
   - 「Allow HTTP Requests」が有効になっているか確認

3. **ファイアウォールの確認**
   - macOSのセキュリティ設定で、Roblox Studioがネットワークアクセスを許可されているか確認

### ファイルが同期されない場合

1. **Rojoサーバーを再起動**
2. **Roblox Studioで再接続**
3. **`default.project.json`のパスを確認**
   - プロジェクトルートに`default.project.json`があることを確認

### エラーメッセージが表示される場合

- Outputウィンドウでエラーの詳細を確認
- Rojoサーバーのターミナル出力を確認
- `default.project.json`の構文が正しいか確認

## 📝 次のステップ

接続が成功したら、以下の開発を進められます：

1. ✅ タスク1: プロジェクト初期化（完了）
2. ✅ タスク2: 共有モジュールの作成（完了）
3. ⏳ タスク3: キャラクターシステムの実装（次）

## 💡 便利なコマンド

### Rojoサーバーの起動
```bash
cd /Users/kazushikojima/Desktop/roblox/venomous-creatures-experience
rojo serve
```

### Rojoサーバーの停止
- ターミナルで `Ctrl + C` を押す

### プロジェクトのビルド（テスト用）
```bash
rojo build -o test.rbxlx
```

