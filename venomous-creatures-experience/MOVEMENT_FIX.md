# ヘビアセットが動かない問題の修正

## 🐛 問題の原因

### 現象
- プレイヤーを移動させても、ヘビのアセットが動かない
- 視線（カメラ）だけが移動する

### 原因

1. **Motor6Dの接続が不適切**
   - 複数のMeshPartがある場合、それぞれをHumanoidRootPartに接続する必要がある
   - 以前のコードでは、モデル全体の位置調整のみで、個別の接続が不十分だった

2. **相対位置の計算が不正確**
   - Motor6DのC0とC1の設定が不適切
   - パーツの相対位置が正しく計算されていない

3. **PrimaryPartの設定が不適切**
   - モデルのPrimaryPartが設定されていない
   - 位置調整が正しく機能しない

## ✅ 修正内容

### 1. すべてのMeshPartをHumanoidRootPartに接続

```lua
-- すべてのMeshPartをHumanoidRootPartに接続
for _, part in ipairs(modelParts) do
    -- Motor6Dを作成してHumanoidRootPartに接続
    local motor = Instance.new("Motor6D")
    motor.Part0 = humanoidRootPart
    motor.Part1 = part
    
    -- 相対位置を計算
    local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(part.CFrame)
    motor.C0 = CFrame.new() -- HumanoidRootPartの位置
    motor.C1 = relativeCFrame -- パーツの相対位置
    
    motor.Parent = humanoidRootPart
end
```

**重要なポイント**:
- 各MeshPartを個別にHumanoidRootPartに接続
- 相対位置を正確に計算
- Motor6Dで接続することで、プレイヤーの移動に追従

### 2. PrimaryPartの設定

```lua
-- モデルのPrimaryPartを設定
if creatureModel:IsA("Model") then
    creatureModel.PrimaryPart = primaryPart
end
```

**目的**:
- モデル全体の位置調整を正確にする
- SetPrimaryPartCFrameを使用可能にする

### 3. 位置調整の改善

```lua
-- モデル全体の位置を調整
local modelCFrame = creatureModel:GetPrimaryPartCFrame()
creatureModel:SetPrimaryPartCFrame(humanoidRootPart.CFrame)
```

**改善点**:
- CFrameを使用して位置と回転を同時に調整
- PrimaryPartを基準に正確に配置

## 🧪 動作確認

修正後、以下を確認してください：

1. **ファイルを保存**
   - 変更がRojoで自動的に同期されることを確認

2. **ゲームを実行**
   - 「Play」ボタンをクリック
   - Outputウィンドウでエラーがないことを確認

3. **プレイヤーを移動**
   - WASDキーで移動
   - ヘビのアセットがプレイヤーと一緒に動くことを確認

## 💡 Motor6Dの仕組み

### Motor6Dとは？

Motor6Dは、2つのパーツを接続するRobloxの標準的な方法です。

```
Motor6D
  ├── Part0: HumanoidRootPart (基準となるパーツ)
  ├── Part1: MeshPart (接続されるパーツ)
  ├── C0: Part0の相対位置（通常はCFrame.new()）
  └── C1: Part1の相対位置（計算された相対位置）
```

### 動作原理

1. **Part0（HumanoidRootPart）が移動**
2. **Motor6DがPart1（MeshPart）の位置を自動調整**
3. **C1で指定された相対位置を維持**

### 複数のMeshPartがある場合

各MeshPartを個別にHumanoidRootPartに接続する必要があります：

```
HumanoidRootPart
  ├── Motor6D → MeshPart1
  ├── Motor6D → MeshPart2
  └── Motor6D → MeshPart3
```

これにより、すべてのMeshPartがプレイヤーの移動に追従します。

## 🐛 トラブルシューティング

### まだ動かない場合

1. **Outputウィンドウを確認**
   - エラーメッセージがないか確認
   - 警告メッセージを確認

2. **Motor6Dの接続を確認**
   - ExplorerパネルでHumanoidRootPartを展開
   - Motor6Dが存在するか確認
   - Motor6DのPart0とPart1が正しく設定されているか確認

3. **パーツのAnchoredを確認**
   - 各MeshPartのAnchoredがfalseになっているか確認
   - Anchoredがtrueの場合、動かない

### 位置がずれる場合

1. **相対位置の計算を確認**
   - C1の値が正しく計算されているか確認
   - 必要に応じて、オフセットを調整

2. **PrimaryPartの設定を確認**
   - モデルのPrimaryPartが正しく設定されているか確認

## 📝 まとめ

### 修正のポイント

1. ✅ すべてのMeshPartを個別にHumanoidRootPartに接続
2. ✅ 相対位置を正確に計算
3. ✅ PrimaryPartを設定して位置調整を改善

### 期待される動作

1. ✅ ヘビのアセットがプレイヤーと一緒に動く
2. ✅ すべてのMeshPartが正しく接続される
3. ✅ 移動時に位置がずれない

この修正により、ヘビのアセットがプレイヤーの移動に正しく追従するようになります！

