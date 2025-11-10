# アセットの準備手順

## 🎯 問題の原因

アセット側で以下の問題があると、変身システムが正しく動作しません：

1. **既存の接続（Motor6D、Weld、WeldConstraint）**
   - アセット内のパーツが既に接続されている
   - これらが残っていると、新しい接続と競合する

2. **Anchored状態**
   - パーツがAnchored = trueになっている
   - これにより、Motor6Dが正しく動作しない

3. **HumanoidRootPartの存在**
   - アセット内にHumanoidRootPartがある
   - プレイヤーのHumanoidRootPartと競合する

4. **パーツの階層構造**
   - パーツが適切な階層に配置されていない

## ✅ アセットの準備手順（Roblox Studioで実行）

### ステップ1: ServerStorageでSnakeModelを開く

1. **Roblox Studioを開く**
2. **ServerStorageを開く**
   - 左側のExplorerウィンドウで`ServerStorage`を展開
3. **SnakeModelを選択**
   - `SnakeModel`をクリックして選択

### ステップ2: 既存の接続を削除

1. **すべての接続を確認**
   - `SnakeModel`を展開して、すべての子要素を確認
   - 各MeshPartを展開して、以下の要素を探す：
     - `Motor6D`
     - `Weld`
     - `WeldConstraint`
     - `Attachment`

2. **接続を削除**
   - 見つかった接続をすべて削除（Deleteキー）
   - **重要**: パーツ間の接続はすべて削除してください

### ステップ3: パーツのAnchored状態を確認

1. **各MeshPartを選択**
   - `SnakeModel`内の各MeshPartを選択

2. **Propertiesウィンドウで確認**
   - `Anchored`プロパティを確認
   - `Anchored = false`に設定（コード側で設定しますが、念のため）

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

### ステップ6: 構造の確認

**理想的な構造**:
```
SnakeModel (Model)
├── MeshPart1 (MeshPart)
│   └── Mesh (Mesh)
├── MeshPart2 (MeshPart)
│   └── Mesh (Mesh)
└── ... (その他のMeshPart)
```

**確認ポイント**:
- すべてのMeshPartが`SnakeModel`の直接の子である必要はない（子孫であればOK）
- 各MeshPartに`Mesh`コンポーネントがあることを確認
- パーツ間の接続がないことを確認

## 🔧 コード側の改善

アセット内の既存の接続を確実に削除するため、コードを改善します。

### 改善点

1. **すべての接続タイプを削除**
   - Motor6D
   - Weld
   - WeldConstraint
   - Attachment（必要に応じて）

2. **Anchored状態の確認**
   - すべてのパーツのAnchoredをfalseに設定

3. **デバッグ情報の追加**
   - アセットの構造を出力して確認

## 📝 チェックリスト

アセットの準備が完了したら、以下を確認してください：

- [ ] すべてのMotor6Dが削除されている
- [ ] すべてのWeldが削除されている
- [ ] すべてのWeldConstraintが削除されている
- [ ] HumanoidRootPartが削除されている
- [ ] Humanoidが削除されている
- [ ] すべてのMeshPartが存在する
- [ ] 各MeshPartにMeshコンポーネントがある

## 🧪 テスト方法

1. **アセットを準備**
   - 上記の手順を実行

2. **ゲームを実行**
   - 「Play」ボタンをクリック

3. **確認**
   - ヘビが地面に這うように配置されている
   - MeshPartの位置関係が元の構成を保持している
   - プレイヤーが移動すると、ヘビも一緒に動く

## 💡 トラブルシューティング

### 問題: まだ浮いている

**原因**: アセット内の接続が残っている可能性

**解決策**:
1. ServerStorageでSnakeModelを再度確認
2. すべての接続を確実に削除
3. ゲームを再実行

### 問題: パーツがバラバラになっている

**原因**: 相対位置の計算が正しくない可能性

**解決策**:
1. アセットの構造を確認
2. 各MeshPartの位置を確認
3. コード側のデバッグ情報を確認

### 問題: 動かない

**原因**: Motor6Dの接続が正しくない可能性

**解決策**:
1. アセット内の既存の接続を確認
2. コード側のMotor6D作成部分を確認
3. Outputウィンドウでエラーを確認

