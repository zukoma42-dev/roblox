# Rojoセットアップガイド

このガイドは、[Zennの記事](https://zenn.dev/ambr_inc/articles/15bef38a830a2e)を参考にしたRojoのセットアップ手順です。

## ✅ 完了した作業

1. ✅ Rokitのインストール（完了）
2. ✅ `rokit.toml`の作成（完了）

## 🔄 次のステップ

### ステップ1: Rojoの追加とインストール

ターミナルで以下のコマンドを実行してください：

```bash
cd /Users/kazushikojima/Desktop/roblox/venomous-creatures-experience
rokit add rojo-rbx/rojo
```

このコマンドを実行すると、ツールの信頼を確認するプロンプトが表示される可能性があります。その場合は、`y`または`yes`を入力して承認してください。

その後、以下のコマンドでRojoをインストールします：

```bash
rokit install
```

### ステップ2: Visual Studio Codeの拡張機能をインストール

1. Visual Studio Codeを開く
2. 拡張機能タブ（Cmd+Shift+X）を開く
3. 「Rojo - Roblox Studio Sync」を検索してインストール
   - または、[VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo)からインストール

### ステップ3: Roblox Studioのプラグインをインストール

1. [Rojoプラグインのページ](https://create.roblox.com/marketplace/asset/15390241826/Rojo)にアクセス
2. 「Try in Studio」をクリック
3. Roblox Studioが起動し、プラグインがインストールされます

### ステップ4: Rojoサーバーの起動

ターミナルで以下のコマンドを実行：

```bash
cd /Users/kazushikojima/Desktop/roblox/venomous-creatures-experience
rokit run rojo serve
```

または、Rokitを使わずに直接Rojoを実行する場合：

```bash
rojo serve
```

サーバーが起動すると、以下のようなメッセージが表示されます：

```
Rojo is running. Connect to it from Roblox Studio using:
rojo://localhost:34872
```

### ステップ5: Roblox Studioとの接続

1. Roblox Studioを開く
2. 新しいプレースを作成（または既存のプレースを開く）
3. Rojoプラグインのアイコンをクリック
4. 表示されたURL（例: `rojo://localhost:34872`）に接続
5. 接続が成功すると、プロジェクトのファイルがRoblox Studioに同期されます

### ステップ6: 動作確認

1. Roblox Studioで「Play」をクリック
2. Outputウィンドウで以下を確認：
   - 「Venomous Creatures Experience - Server initialized」
   - 「Venomous Creatures Experience - Client initialized」

## 📝 注意事項

- Rojoでの同期は外部エディタ → Roblox Studioへの一方通行です
- Roblox Studioでスクリプトを編集しないように注意してください
- ファイルを編集したら、Roblox Studioで自動的に反映されます（Rojoサーバーが起動している場合）

## 🐛 トラブルシューティング

### Rokitでツールが信頼されない

`rokit add`コマンドを実行する際に、対話的な承認が必要な場合があります。プロンプトが表示されたら、`y`を入力して承認してください。

### Rojoサーバーが起動しない

- `rokit.toml`にRojoが正しく追加されているか確認
- `rokit install`が正常に完了したか確認
- `rokit run rojo serve`で実行してみる

### Roblox Studioに接続できない

- Rojoサーバーが起動しているか確認
- ファイアウォールの設定を確認
- Roblox Studioの「Allow HTTP Requests」が有効か確認

## 📚 参考リンク

- [Rojo公式サイト](https://rojo.space/)
- [Rokit公式リポジトリ](https://github.com/rojo-rbx/rokit)
- [Zennの記事（元のガイド）](https://zenn.dev/ambr_inc/articles/15bef38a830a2e)

