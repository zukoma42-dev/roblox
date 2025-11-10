# 構造の修正手順

## 🐛 現在の構造（問題あり）

```
SnakeBody (MeshPart) ← 最上位
  └── SnakeModel (Model)
      └── Mesh
```

## ✅ 正しい構造

```
SnakeModel (Model) ← 最上位
  └── SnakeBody (MeshPart)
      └── Mesh (オプション)
```

## 🔍 なぜこの構造が問題なのか？

### 1. コードがSnakeModelを探す

現在のコードは以下のようにSnakeModelを探します：

```lua
local modelTemplate = ServerStorage:FindFirstChild("SnakeModel")
```

**問題**: 現在の構造では、SnakeModelがSnakeBodyの子になっているため、ServerStorage直下にSnakeModelが見つかりません。

### 2. モデルの階層が逆

- **正しい**: Model > MeshPart > Mesh
- **現在**: MeshPart > Model > Mesh

これはRobloxの標準的な構造ではありません。

## 🔧 修正手順

### ステップ1: SnakeModelを最上位に移動

1. **SnakeBodyを選択**
2. **SnakeModelを確認**
   - SnakeBodyの子としてSnakeModelがあることを確認

3. **SnakeModelをServerStorage直下に移動**
   - SnakeModelを選択
   - ドラッグ&ドロップでServerStorage直下に移動
   - または、Cut → ServerStorageを選択 → Paste

### ステップ2: SnakeBodyをSnakeModelの子に移動

1. **SnakeBodyを選択**
2. **SnakeModelの子として移動**
   - SnakeBodyをドラッグ&ドロップでSnakeModelの中に移動
   - または、Cut → SnakeModelを選択 → Paste

### ステップ3: MeshをSnakeBodyの子に移動（まだの場合）

1. **Meshを確認**
   - 現在の位置を確認

2. **SnakeBodyの子として移動**
   - Meshをドラッグ&ドロップでSnakeBodyの中に移動

### ステップ4: 最終的な構造の確認

修正後、以下の構造になるはずです：

```
ServerStorage
  └── SnakeModel (Model) ← 最上位
      └── SnakeBody (MeshPart)
          └── Mesh (オプション)
```

## 📋 修正後の確認事項

1. **SnakeModelがServerStorage直下にある**
   - Explorerパネルで確認

2. **SnakeBodyがSnakeModelの子にある**
   - SnakeModelを展開して確認

3. **MeshがSnakeBodyの子にある**（オプション）
   - SnakeBodyを展開して確認

4. **SnakeBodyのMeshIdが設定されている**
   - SnakeBodyを選択
   - PropertiesパネルでMeshIdを確認

## 🧪 動作確認

修正後、以下を確認してください：

1. **ファイルを保存**
   - 変更がRojoで自動的に同期されることを確認

2. **ゲームを実行**
   - 「Play」ボタンをクリック
   - Outputウィンドウでエラーがないことを確認

3. **プレイヤーを確認**
   - プレイヤーが毒ヘビに変身していることを確認

## 💡 なぜこの構造が正しいのか？

### Robloxの標準的な構造

```
Model (コンテナ)
  └── BasePart (物理的な存在)
      └── Components (オプション)
```

### 今回のケース

```
SnakeModel (Model - コンテナ)
  └── SnakeBody (MeshPart - 物理的な存在)
      └── Mesh (Component - 形状データ)
```

### コードの動作

1. **ServerStorageからSnakeModelを取得**
   ```lua
   local modelTemplate = ServerStorage:FindFirstChild("SnakeModel")
   ```

2. **SnakeModel内のBasePartを検出**
   ```lua
   for _, descendant in ipairs(creatureModel:GetDescendants()) do
       if descendant:IsA("BasePart") then
           -- SnakeBodyが見つかる
       end
   end
   ```

3. **SnakeBodyをプレイヤーの位置に配置**

## 🎯 まとめ

- **SnakeModel = コンテナ（最上位）**
- **SnakeBody = 物理的な存在（SnakeModelの子）**
- **Mesh = 形状データ（SnakeBodyの子、オプション）**

この構造に修正すれば、コードが正しく動作します！

