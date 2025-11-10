# モデルの修正手順

## 🐛 問題の原因

Outputウィンドウに以下のエラーが表示されています：
- `No BasePart found in model: SnakeModel`
- `Model structure: ▼ { [1] = Mesh }`

**原因**: SnakeModelにはMeshコンポーネントしかなく、PartやMeshPartなどのBasePartが含まれていません。Robloxでは、MeshはPartやMeshPartの子コンポーネントとして存在する必要があります。

## 🔧 解決方法

### 方法1: MeshPartを作成してMeshを配置（推奨）

1. **Roblox StudioでSnakeModelを開く**
   - ExplorerパネルでSnakeModelを選択

2. **MeshPartを作成**
   - SnakeModelを右クリック
   - `Insert Object > MeshPart` を選択
   - または、`Insert > Object > MeshPart` を選択

3. **MeshPartの名前を変更**
   - 作成されたMeshPartを選択
   - Propertiesパネルで「Name」を「SnakeBody」などに変更

4. **Meshコンポーネントを移動**
   - 現在のMeshコンポーネントを選択
   - ドラッグ&ドロップでMeshPartの中に移動
   - または、Cut → MeshPartを選択 → Paste

5. **MeshPartの設定**
   - MeshPartを選択
   - Propertiesパネルで以下を設定：
     - **Size**: 適切なサイズ（例: 4, 0.5, 4）
     - **Material**: 必要に応じて変更
     - **Color**: 必要に応じて変更

6. **Meshの設定を確認**
   - MeshPart内のMeshを選択
   - PropertiesパネルでMeshIdが正しく設定されているか確認

### 方法2: Partを作成してMeshを配置

1. **Partを作成**
   - SnakeModelを右クリック
   - `Insert Object > Part` を選択

2. **Partの名前を変更**
   - 作成されたPartを選択
   - Propertiesパネルで「Name」を「SnakeBody」などに変更

3. **Meshコンポーネントを移動**
   - 現在のMeshコンポーネントを選択
   - ドラッグ&ドロップでPartの中に移動

4. **Partの設定**
   - Partを選択
   - Propertiesパネルで以下を設定：
     - **Size**: 適切なサイズ
     - **Material**: 必要に応じて変更
     - **Color**: 必要に応じて変更

### 方法3: 別のモデルを使用

1. **ツールボックスで別のモデルを検索**
   - より完全な構造を持つモデルを探す
   - PartやMeshPartが含まれているモデルを選ぶ

2. **新しいモデルをServerStorageに配置**
   - モデル名を「SnakeModel」に変更

## 📋 修正後の構造

修正後、SnakeModelの構造は以下のようになるはずです：

```
SnakeModel (Model)
  └── MeshPart または Part
      └── Mesh
```

または：

```
SnakeModel (Model)
  └── Part
      └── Mesh
```

## 🧪 動作確認

修正後、以下を確認してください：

1. **ファイルを保存**
   - 変更がRojoで自動的に同期されることを確認

2. **ゲームを実行**
   - 「Play」ボタンをクリック
   - Outputウィンドウでエラーがないことを確認

3. **プレイヤーを確認**
   - プレイヤーが毒ヘビに変身していることを確認
   - サイズが正しく設定されていることを確認

## 💡 ヒント

### MeshPart vs Part

- **MeshPart**: Mesh専用のパーツ。メッシュの表示に最適化されている
- **Part**: 汎用的なパーツ。Meshも含めることができる

MVPでは、MeshPartを使用することを推奨します（パフォーマンスが良いため）。

### サイズの設定

- モデルのサイズは後でコードで調整されるため、基本的なサイズで問題ありません
- ただし、適切なサイズに設定すると、デバッグが容易になります

