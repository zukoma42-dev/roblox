# アセットの最適な準備方法

## 🎯 このガイドの目的

変身システムが正しく動作するために、アセット（SnakeModelなど）を適切に準備する方法を説明します。

## ✅ アセットの理想的な構造

### 基本構造

```
SnakeModel (Model)
├── MeshPart1 (MeshPart)  ← PrimaryPart（最初のパーツまたは指定したパーツ）
│   ├── Mesh (Mesh)
│   └── Weld (Weld) → MeshPart2に接続
├── MeshPart2 (MeshPart)
│   ├── Mesh (Mesh)
│   └── Weld (Weld) → MeshPart3に接続
└── MeshPart3 (MeshPart)
    └── Mesh (Mesh)
```

### 重要なポイント

1. **パーツ間の接続（Weld、WeldConstraint）を保持**
   - アセット内のパーツ間の接続は**保持**してください
   - これにより、アセットの元の構造が維持されます
   - システムは既存の接続を検出し、そのまま使用します

2. **Motor6Dは削除**
   - アセット内のMotor6Dは削除してください
   - システムが新しいMotor6Dを作成します

3. **HumanoidRootPartは削除**
   - アセット内にHumanoidRootPartがある場合は削除してください
   - プレイヤーのHumanoidRootPartを使用します

4. **Humanoidは削除**
   - アセット内にHumanoidがある場合は削除してください
   - プレイヤーのHumanoidを使用します

## 📋 アセット準備のステップバイステップ

### ステップ1: ServerStorageでSnakeModelを開く

1. **Roblox Studioを開く**
2. **ServerStorageを開く**
   - 左側のExplorerウィンドウで`ServerStorage`を展開
3. **SnakeModelを選択**
   - `SnakeModel`をクリックして選択

### ステップ2: パーツ間の接続（Weld、WeldConstraint）を確認・保持

1. **すべての接続を確認**
   - `SnakeModel`を展開して、すべての子要素を確認
   - 各MeshPartを展開して、以下の要素を探す：
     - `Weld` ← **保持してください**
     - `WeldConstraint` ← **保持してください**
     - `Motor6D` ← **削除してください**

2. **接続の確認方法**
   - 各Weld/WeldConstraintを選択
   - Propertiesウィンドウで`Part0`と`Part1`を確認
   - パーツ間の接続が正しく設定されていることを確認

### ステップ3: Motor6Dを削除

1. **Motor6Dを探す**
   - `SnakeModel`内のすべてのMotor6Dを探す
   - 各MeshPartの子要素を確認

2. **Motor6Dを削除**
   - 見つかったMotor6Dをすべて削除（Deleteキー）
   - **重要**: Motor6Dのみ削除し、Weld/WeldConstraintは保持してください

### ステップ4: HumanoidRootPartを削除

1. **HumanoidRootPartを探す**
   - `SnakeModel`内に`HumanoidRootPart`があるか確認

2. **削除**
   - 見つかった場合は削除（プレイヤーのHumanoidRootPartを使用するため）

### ステップ5: Humanoidを削除

1. **Humanoidを探す**
   - `SnakeModel`内に`Humanoid`があるか確認

2. **削除**
   - 見つかった場合は削除（プレイヤーのHumanoidを使用するため）

### ステップ6: パーツのAnchored状態を確認

1. **各MeshPartを選択**
   - `SnakeModel`内の各MeshPartを選択

2. **Propertiesウィンドウで確認**
   - `Anchored`プロパティを確認
   - `Anchored = false`に設定（システム側でも設定しますが、念のため）

### ステップ7: PrimaryPartの確認（オプション）

1. **PrimaryPartを確認**
   - `SnakeModel`を選択
   - Propertiesウィンドウで`PrimaryPart`を確認
   - 最初のMeshPartがPrimaryPartとして設定されていることを確認

2. **PrimaryPartを変更したい場合**
   - `CreatureConfig.luau`で`primaryPartName`を指定できます
   - 例: `primaryPartName = "Body"`

## 🔧 接続の種類と推奨事項

### Weld（推奨）

- **保持**: ✅ はい
- **理由**: アセットの元の構造を保持するため
- **使用例**: パーツ間の接続

### WeldConstraint（推奨）

- **保持**: ✅ はい
- **理由**: アセットの元の構造を保持するため
- **使用例**: パーツ間の接続

### Motor6D（削除）

- **保持**: ❌ いいえ
- **理由**: システムが新しいMotor6Dを作成するため
- **削除方法**: すべてのMotor6Dを削除

## 📊 システムの動作

### 既存の接続がある場合

1. システムが既存の接続（Weld、WeldConstraint）を検出
2. 既存の接続を保持
3. PrimaryPartだけをHumanoidRootPartに接続
4. 他のパーツは既存の接続で接続されているため、そのまま動作

### 既存の接続がない場合

1. システムが既存の接続を検出しない
2. PrimaryPartをHumanoidRootPartに接続
3. 他のパーツをPrimaryPartに接続（Motor6Dを使用）
4. アセットの元の構造を保持

## ✅ チェックリスト

アセットの準備が完了したら、以下を確認してください：

- [ ] すべてのMotor6Dが削除されている
- [ ] パーツ間の接続（Weld、WeldConstraint）が保持されている
- [ ] HumanoidRootPartが削除されている
- [ ] Humanoidが削除されている
- [ ] すべてのMeshPartが存在する
- [ ] 各MeshPartにMeshコンポーネントがある
- [ ] すべてのパーツのAnchoredがfalseに設定されている
- [ ] PrimaryPartが正しく設定されている（または最初のパーツが使用される）

## 🧪 テスト方法

1. **アセットを準備**
   - 上記の手順を実行

2. **ゲームを実行**
   - 「Play」ボタンをクリック

3. **確認**
   - ヘビが正しく表示されている
   - パーツが崩れていない
   - プレイヤーが移動すると、ヘビも一緒に動く
   - Outputウィンドウに「Using existing welds for X connections」と表示される

## 💡 トラブルシューティング

### 問題: パーツが崩れている

**原因**: パーツ間の接続（Weld、WeldConstraint）が不足している可能性

**解決策**:
1. ServerStorageでSnakeModelを確認
2. 各MeshPart間にWeldまたはWeldConstraintがあることを確認
3. 接続がない場合は、Roblox Studioで接続を作成

### 問題: アセットが表示されない

**原因**: モデルが見つからない、または接続が正しくない可能性

**解決策**:
1. ServerStorageに`SnakeModel`が存在することを確認
2. Outputウィンドウでエラーメッセージを確認
3. モデル名が正しいことを確認（`CreatureConfig.luau`の`modelName`と一致）

### 問題: プレイヤーのアバターが見える

**原因**: これは正常な動作ではありませんが、変身システムが正しく動作していない可能性

**解決策**:
1. Outputウィンドウでエラーメッセージを確認
2. モデルが正しく読み込まれていることを確認
3. 変身処理が実行されていることを確認

## 📝 まとめ

**最も重要なポイント**:

1. **パーツ間の接続（Weld、WeldConstraint）を保持**してください
   - これにより、アセットの元の構造が維持されます
   - システムが既存の接続を検出し、そのまま使用します

2. **Motor6Dは削除**してください
   - システムが新しいMotor6Dを作成します

3. **HumanoidRootPartとHumanoidは削除**してください
   - プレイヤーのHumanoidRootPartとHumanoidを使用します

この準備により、アセットが正しく動作し、パーツが崩れることなく変身システムが機能します。

