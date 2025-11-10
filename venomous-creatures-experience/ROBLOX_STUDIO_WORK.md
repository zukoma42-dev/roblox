# Roblox Studioでの作業手順

## 🎯 目標

ツールボックスから毒ヘビのモデルを取得し、プレイヤーがゲーム開始時に毒ヘビに変身する機能を実装します。

## 📋 作業手順

### ステップ1: 毒ヘビのモデルをツールボックスから取得

1. **Roblox Studioを開く**
   - Rojoサーバーが起動していることを確認
   - プロジェクトが接続されていることを確認

2. **ツールボックスを開く**
   - 左側のパネルから「ツールボックス」タブをクリック
   - または、`View > Toolbox` を選択

3. **毒ヘビのモデルを検索**
   - 検索バーに以下のキーワードで検索：
     - `snake`
     - `ヘビ`
     - `poison snake`
     - `venomous snake`
   - 適切なモデルを探す
   - **推奨**: シンプルで、パーツが少ないモデルを選ぶ（パフォーマンスと実装の容易さのため）

4. **モデルを取得**
   - 気に入ったモデルをクリック
   - モデルがWorkspaceに配置されます

5. **モデルの構造を確認**
   - モデルを選択
   - Explorerパネルでモデルの構造を確認
   - 以下の点を確認：
     - パーツの数（少ない方が良い）
     - Humanoidが含まれているか
     - アニメーションが含まれているか

### ステップ2: モデルをServerStorageに移動

1. **ServerStorageを確認**
   - Explorerパネルで`ServerStorage`を確認
   - まだ存在しない場合は、`Insert > Object > Folder`で作成（通常は既に存在）

2. **モデルを移動**
   - Workspaceにあるモデルを選択
   - ドラッグ&ドロップで`ServerStorage`に移動
   - または、右クリック > `Cut` → `ServerStorage`を選択 → 右クリック > `Paste`

3. **モデル名を変更**
   - モデルを選択
   - Propertiesパネルで「Name」を「SnakeModel」に変更
   - **重要**: この名前はコードで参照されるため、正確に「SnakeModel」にする

### ステップ3: モデルの調整（必要に応じて）

1. **Humanoidの削除**
   - モデル内にHumanoidがある場合、削除する
   - 理由: プレイヤーの既存のHumanoidを使用するため

2. **アニメーションの削除（オプション）**
   - モデル内にアニメーションがある場合、削除するか保持するか検討
   - MVPでは削除することを推奨（シンプルにするため）

3. **パーツの調整**
   - 必要に応じて、パーツの色やマテリアルを調整
   - コリジョンの設定を確認

### ステップ4: 動作確認

1. **ファイルの保存を確認**
   - すべてのファイルがRojoで同期されていることを確認
   - Explorerパネルで以下の構造が表示されていることを確認：
     ```
     ServerScriptService
       └── Server
           ├── Services
           │   └── PlayerManager.luau
           └── Components
               └── VenomousCharacter.luau
     ```

2. **ゲームを実行**
   - 「Play」ボタンをクリック
   - Outputウィンドウでエラーがないことを確認

3. **プレイヤーを確認**
   - ゲーム内でプレイヤーを確認
   - プレイヤーが毒ヘビに変身しているか確認
   - サイズが正しく設定されているか確認

## 🐛 トラブルシューティング

### モデルが表示されない

**原因**: モデルがServerStorageに正しく配置されていない、または名前が間違っている

**解決方法**:
1. ServerStorageに「SnakeModel」という名前のモデルがあるか確認
2. モデル名が正確に「SnakeModel」になっているか確認
3. モデルが正しくロードされているか確認（Outputウィンドウでエラーメッセージを確認）

### エラーが発生する

**原因**: モデルの構造が想定と異なる

**解決方法**:
1. Outputウィンドウでエラーメッセージを確認
2. モデルの構造を確認
3. 必要に応じて、`VenomousCharacter.luau`の`transformToCreature`関数を調整

### サイズが正しく設定されない

**原因**: サイズ設定の処理が正しく動作していない

**解決方法**:
1. Outputウィンドウでエラーメッセージを確認
2. 開発者コンソール（F9）でサイズを確認：
   ```lua
   local Players = game:GetService("Players")
   local Server = game.ServerScriptService.Server
   local Services = Server.Services
   local PlayerManager = require(Services.PlayerManager)
   
   local player = Players.LocalPlayer
   local character = PlayerManager:getCharacter(player)
   if character then
       print("Current size:", character:getSize())
   end
   ```

## 📝 次のステップ

モデルの取得と設定が完了したら：

1. ✅ モデルが正しく表示されることを確認
2. ✅ サイズが正しく設定されることを確認
3. ⏳ 移動システムの実装に進む

## 💡 ヒント

### モデル選びのコツ

- **シンプルなモデルを選ぶ**: パーツが少ない方がパフォーマンスが良い
- **Riggedモデルを避ける**: Humanoidが含まれていると実装が複雑になる
- **アニメーションなし**: MVPでは不要な複雑さを避ける

### モデルの調整

- モデルが大きすぎる/小さすぎる場合は、モデル全体をスケール
- 色やマテリアルは後で調整可能
- コリジョンは必要に応じて調整

