# ヘビの位置と構成を保持する修正

## 🐛 問題の原因

### 現象
- ヘビが浮いている
- MeshPartの位置がバラバラになっている
- 元の構成が失われている

### 原因

1. **SetPrimaryPartCFrameによる移動**
   - モデル全体を移動する際に、パーツ間の相対位置が失われる
   - すべてのパーツが同じ位置に移動してしまう

2. **相対位置の計算タイミング**
   - Motor6Dの接続前に位置を調整しているため、相対位置が正しく計算されない

3. **元の構成の保持不足**
   - モデル内のパーツ間の相対位置を保存していない

## ✅ 修正内容

### 1. パーツ間の相対位置を保存

```lua
-- モデル内のパーツ間の相対位置を保存（PrimaryPartを基準に）
local relativePositions = {}
for _, part in ipairs(modelParts) do
    -- PrimaryPartを基準とした相対位置を計算
    local relativeCFrame = primaryPart.CFrame:ToObjectSpace(part.CFrame)
    relativePositions[part] = relativeCFrame
end
```

**処理内容**:
- PrimaryPartを基準に、各パーツの相対位置を計算
- 相対位置を保存（元の構成を保持）

### 2. PrimaryPartを配置

```lua
-- PrimaryPartをHumanoidRootPartの位置に配置
primaryPart.CFrame = humanoidRootPart.CFrame
```

**処理内容**:
- PrimaryPartをHumanoidRootPartの位置に配置
- 地面に這うようにするため、必要に応じてY軸を調整可能

### 3. 他のパーツを相対位置で配置

```lua
-- 他のパーツをPrimaryPartからの相対位置で配置（元の構成を保持）
for part, relativeCFrame in pairs(relativePositions) do
    if part ~= primaryPart then
        -- PrimaryPartの現在の位置を基準に、相対位置を適用
        part.CFrame = primaryPart.CFrame:ToWorldSpace(relativeCFrame)
    end
end
```

**処理内容**:
- 保存した相対位置を使用して、各パーツを配置
- 元の構成（パーツ間の位置関係）を保持

### 4. Motor6Dで接続

```lua
-- 相対位置を計算（現在の位置関係を保持）
local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(part.CFrame)
motor.C0 = CFrame.new()
motor.C1 = relativeCFrame  -- 元の構成を保持した相対位置
```

**処理内容**:
- 配置後の位置関係を基に、Motor6Dの相対位置を計算
- 元の構成が保持された状態で接続

## 🎯 修正のポイント

### 重要な変更

1. **相対位置の保存**
   - モデルを移動する前に、パーツ間の相対位置を保存
   - PrimaryPartを基準に計算

2. **段階的な配置**
   - PrimaryPartを先に配置
   - その後、他のパーツを相対位置で配置

3. **構成の保持**
   - 元のMeshPartの構成（位置関係）を完全に保持
   - パーツ間の距離や角度が維持される

## 🧪 動作確認

修正後、以下を確認してください：

1. **ファイルを保存**
   - 変更がRojoで自動的に同期されることを確認

2. **ゲームを実行**
   - 「Play」ボタンをクリック
   - Outputウィンドウでエラーがないことを確認

3. **ヘビの状態を確認**
   - ヘビが地面に這うように配置されていることを確認
   - MeshPartの位置関係が元の構成を保持していることを確認
   - プレイヤーが移動すると、ヘビも一緒に動くことを確認

## 💡 地面に這うようにする調整（オプション）

必要に応じて、Y軸の位置を調整できます：

```lua
-- ヘビが地面に這うように、Y軸を少し下げる
local targetCFrame = humanoidRootPart.CFrame * CFrame.new(0, -1, 0)
primaryPart.CFrame = targetCFrame
```

**調整方法**:
- `-1`の値を変更して、地面との距離を調整
- ヘビのサイズに応じて調整が必要な場合がある

## 📝 まとめ

### 修正のポイント

1. ✅ パーツ間の相対位置を保存
2. ✅ PrimaryPartを先に配置
3. ✅ 他のパーツを相対位置で配置
4. ✅ 元の構成を完全に保持

### 期待される動作

1. ✅ ヘビが地面に這うように配置される
2. ✅ MeshPartの位置関係が元の構成を保持する
3. ✅ プレイヤーが移動すると、ヘビも一緒に動く

この修正により、ヘビが正しい位置に配置され、元の構成が保持されます！

