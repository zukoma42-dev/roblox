# Roblox StudioとMCP接続ガイド

## 現在の接続状態

### ✅ Rojo接続（既に確立済み）
- **Rojoサーバー**: 起動中（ポート34872）
- **Roblox Studio**: 接続済み
- **接続URL**: `rojo://localhost:34872`

RojoはRoblox開発で標準的に使用されるツールで、ローカルファイルシステムとRoblox Studioを同期します。

## MCP（Model Context Protocol）について

MCPはAIアプリケーションと外部ツールを接続するためのプロトコルです。Roblox Studio用の公式MCPサーバーは現在存在しませんが、以下の方法で連携できます：

### 方法1: Rojo経由での連携（推奨・現在使用中）

Rojoを使用することで、以下の連携が可能です：

1. **ファイル同期**
   - ローカルの`.luau`ファイルが自動的にRoblox Studioに同期
   - ファイルを編集すると、Roblox Studioで自動的に反映

2. **開発フロー**
   - 外部エディタ（VS Code、Cursorなど）でコードを編集
   - Rojoが自動的にRoblox Studioに同期
   - Roblox Studioでテスト・デバッグ

### 方法2: CursorのMCP機能を使用（将来の拡張）

CursorのMCP機能を使ってRoblox Studioと連携する場合、カスタムMCPサーバーの開発が必要です。現在は公式サポートがありません。

## 現在の接続確認方法

### 1. Roblox Studioでの確認

1. Roblox Studioを開く
2. **Explorer**ウィンドウで以下の構造を確認：
   ```
   ReplicatedStorage
     └── Shared
         ├── Types.luau
         ├── Constants.luau
         ├── Config.luau
         └── Utils/
   ServerScriptService
     └── Server
         └── init.server.luau
   StarterPlayer
     └── StarterPlayerScripts
         └── Client
             └── init.client.luau
   ```

### 2. 接続状態の確認

ターミナルで以下のコマンドを実行：
```bash
lsof -i :34872
```

以下のような出力が表示されれば接続中：
```
rojo      [PID]  ...  TCP localhost:34872 (LISTEN)
RobloxStu [PID]  ...  TCP localhost:34872->localhost:61107 (ESTABLISHED)
```

## トラブルシューティング

### Rojo接続が切れた場合

1. **Rojoサーバーを再起動**：
   ```bash
   cd /Users/kazushikojima/Desktop/roblox/venomous-creatures-experience
   rojo serve
   ```

2. **Roblox Studioで再接続**：
   - Rojoプラグインを開く
   - 「Connect」ボタンをクリック

### ファイルが同期されない場合

1. `default.project.json`のパスが正しいか確認
2. Rojoサーバーを再起動
3. Roblox Studioで再接続

## 次のステップ

現在のRojo接続で開発を進められます：

1. ✅ ファイル編集 → 自動的にRoblox Studioに同期
2. ✅ Roblox Studioでテスト・デバッグ
3. ✅ コード変更がリアルタイムで反映

## 参考リンク

- [Rojo公式ドキュメント](https://rojo.space/docs)
- [MCP公式ドキュメント](https://modelcontextprotocol.io/)
- [Roblox Developer Hub](https://create.roblox.com/)

