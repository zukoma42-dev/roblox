# 開発チュートリアル

このドキュメントは、Venomous Creatures ExperienceのMVP開発を段階的に進めるためのガイドです。

## 📋 タスクリスト

### ✅ タスク1: プロジェクト初期化（完了）
- [x] Rojoプロジェクト設定の確認
- [x] 初期ファイル（init.server.luau, init.client.luau）の作成
- [x] 基本構造のセットアップ

### 🔄 タスク2: 共有モジュールの作成（進行中）
- [x] Types.luau（型定義）
- [x] Constants.luau（定数）
- [x] Config.luau（ゲーム設定）
- [ ] Utils/GrowthSystem.luau（成長計算）

### ⏳ タスク3: キャラクターシステム
- [ ] 毒生物への変身機能
- [ ] サイズ管理システム
- [ ] 基本的なアニメーション

### ⏳ タスク4: 移動システム
- [ ] WASD移動
- [ ] ジャンプ機能
- [ ] サイズに応じた速度調整
- [ ] カメラ制御

### ⏳ タスク5: アイテムシステム
- [ ] 毒アイテムの生成
- [ ] 取得判定
- [ ] 成長処理

### ⏳ タスク6: 捕食システム
- [ ] プレイヤー間のサイズ比較
- [ ] 接触判定
- [ ] 捕食処理

### ⏳ タスク7: リスポーンシステム
- [ ] リスポーン地点
- [ ] サイズリセット
- [ ] 無敵時間

### ⏳ タスク8: UIシステム
- [ ] HUD（サイズ表示、アイテム数表示）

### ⏳ タスク9: ネットワーキング
- [ ] プレイヤー状態の同期
- [ ] アイテムの同期

### ⏳ タスク10: テストとデバッグ
- [ ] 動作確認
- [ ] バグ修正
- [ ] パフォーマンス調整

---

## 🚀 セットアップ手順

### ステップ1: Rojoサーバーの起動

1. ターミナルでプロジェクトディレクトリに移動：
   ```bash
   cd /Users/kazushikojima/Desktop/roblox/venomous-creatures-experience
   ```

2. Rojoサーバーを起動：
   ```bash
   rojo serve
   ```

3. サーバーが起動すると、以下のようなメッセージが表示されます：
   ```
   Rojo is running. Connect to it from Roblox Studio using:
   rojo://localhost:34872
   ```

### ステップ2: Roblox Studioとの接続

1. **Roblox Studioを開く**
   - 新しいプレースを作成するか、既存のプレースを開く

2. **Rojoプラグインのインストール**
   - Roblox StudioのToolboxから「Rojo」プラグインを検索してインストール
   - または、[Rojoプラグインのページ](https://www.roblox.com/library/1234567890)からインストール

3. **接続**
   - Rojoプラグインを開く
   - 表示されたURL（例: `rojo://localhost:34872`）に接続
   - 接続が成功すると、プロジェクトのファイルがRoblox Studioに同期されます

4. **確認**
   - ReplicatedStorage.Shared に `Types.luau`, `Constants.luau`, `Config.luau` が表示される
   - ServerScriptService.Server に `init.server.luau` が表示される
   - StarterPlayer.StarterPlayerScripts.Client に `init.client.luau` が表示される

### ステップ3: 動作確認

1. **サーバー側の確認**
   - Roblox Studioで「Play」をクリック
   - Outputウィンドウに「Venomous Creatures Experience - Server initialized」が表示されることを確認

2. **クライアント側の確認**
   - ゲーム内でOutputウィンドウを確認
   - 「Venomous Creatures Experience - Client initialized」が表示されることを確認

---

## 📝 開発の進め方

### 各タスクの実装順序

1. **共有モジュール（タスク2）** ← 現在ここ
   - すべてのモジュールで使用する型定義と定数を先に作成
   - これにより、他のモジュールで型チェックが効く

2. **キャラクターシステム（タスク3）**
   - プレイヤーが毒生物に変身する基本機能
   - サイズ管理の基盤

3. **移動システム（タスク4）**
   - 基本的な操作感を確立
   - カメラの設定

4. **アイテムシステム（タスク5）**
   - ゲームの核心となる成長システム

5. **捕食システム（タスク6）**
   - プレイヤー間のインタラクション

6. **リスポーンシステム（タスク7）**
   - ゲームループの完成

7. **UIシステム（タスク8）**
   - プレイヤーへの情報提供

8. **ネットワーキング（タスク9）**
   - マルチプレイヤー機能の完成

9. **テストとデバッグ（タスク10）**
   - 最終調整

---

## 🛠️ 開発のベストプラクティス

### ファイル構造
- 各モジュールは単一の責任を持つ
- ファイル名はPascalCase（例: `GameService.luau`）
- 関数名はcamelCase（例: `calculateSpeed`）

### コーディング規約
- 型アノテーションを必ず使用する
- エラーハンドリングを適切に実装する
- コメントは日本語で記述する

### テスト方法
- 各機能を実装したら、すぐにRoblox Studioでテストする
- バグを見つけたら、すぐに修正する
- 定期的に動作確認を行う

---

## 📚 参考リソース

- [Roblox Developer Hub](https://create.roblox.com/)
- [Luau Documentation](https://luau-lang.org/)
- [Rojo Documentation](https://rojo.space/docs)
- [Fusion Documentation](https://elttob.uk/fusion/)

---

## 🐛 トラブルシューティング

### Rojoが接続できない
- Rojoサーバーが起動しているか確認
- ファイアウォールの設定を確認
- Roblox Studioの「Allow HTTP Requests」が有効か確認

### ファイルが同期されない
- Rojoサーバーを再起動
- Roblox Studioを再起動
- `default.project.json`のパスを確認

### エラーが発生する
- Outputウィンドウでエラーメッセージを確認
- 型アノテーションが正しいか確認
- モジュールのパスが正しいか確認

---

**次のステップ**: タスク2の残り（GrowthSystem.luau）を実装するか、タスク3（キャラクターシステム）に進みましょう。

