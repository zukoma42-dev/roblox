# Venomous Creatures Experience

毒生物をモチーフにしたRobloxエクスペリエンス。プレイヤーが毒生物のキャラクターに変身し、マップ上で成長・進化しながら他のプレイヤーと競争するマルチプレイヤーゲームです。

## 概要

このエクスペリエンスでは、プレイヤーは以下の体験ができます：

- 🐍 様々な毒生物タイプから選択
- 📈 毒アイテムを取得して成長・進化
- 🎮 他のプレイヤーと競争・捕食
- 🗺️ 広大なマップを探索

## プロジェクト構造

```
venomous-creatures-experience/
├── default.project.json    # Rojoプロジェクト設定
├── REQUIREMENTS.md         # 詳細な要件定義書
├── README.md              # このファイル
└── src/
    ├── shared/            # 共有コード
    │   ├── Types.luau
    │   ├── Constants.luau
    │   ├── Config.luau
    │   └── Utils/
    ├── server/            # サーバー側コード
    │   ├── init.server.luau
    │   ├── Services/
    │   └── Components/
    └── client/            # クライアント側コード
        ├── init.client.luau
        ├── Controllers/
        ├── UI/
        └── Effects/
```

## セットアップ

### 前提条件

- Roblox Studio
- Rojo（最新版）
- Wally（パッケージ管理）

### 開発開始

1. **Rojoサーバーの起動**
   ```bash
   cd venomous-creatures-experience
   rojo serve
   ```

2. **Roblox Studioで接続**
   - Roblox Studioを開く
   - Rojoプラグインをインストール
   - プラグインから接続

3. **開発開始**
   - `src/` フォルダ内のファイルを編集
   - 変更は自動的にRoblox Studioに反映されます

## 開発フェーズ

詳細な開発計画は `REQUIREMENTS.md` を参照してください。

### フェーズ1: プロトタイプ（MVP）
- 基本的な毒生物キャラクターシステム
- 移動と毒アイテム取得
- 成長システム

### フェーズ2: コア機能実装
- 複数の毒生物タイプ
- 進化システム
- データ保存

### フェーズ3: 拡張機能
- 特殊能力
- 特別なエリア
- 統計システム

### フェーズ4: ポリッシュ
- バグ修正
- パフォーマンス最適化
- UI/UX改善

## 使用ライブラリ

このプロジェクトでは以下のライブラリを使用します：

- **Fusion** - UI構築と状態管理
- **Replica** - サーバー・クライアント間のデータ同期
- **Promise** - 非同期処理
- **FastSignal** - イベント処理
- **ZonePlus** - エリア検出
- **Janitor/Trove** - リソース管理
- **ProfileStore** - データ永続化
- **RbxUtils** - ユーティリティ関数

## 開発ガイドライン

### コーディング規約

- Luauの型アノテーションを使用
- モジュールは明確な責任を持つ
- エラーハンドリングを適切に実装
- コメントは日本語で記述

### ファイル命名規則

- PascalCase: クラス、モジュール（例: `GameService.luau`）
- camelCase: 変数、関数（例: `playerData`）
- UPPER_CASE: 定数（例: `MAX_SIZE`）

## ライセンス

[ライセンス情報を記載]

## 貢献

[貢献ガイドラインを記載]

---

詳細な要件定義については `REQUIREMENTS.md` を参照してください。

