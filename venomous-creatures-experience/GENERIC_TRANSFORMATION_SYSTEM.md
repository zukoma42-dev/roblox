# 汎用的な変身システム - 設計思想と実装意図

## 🎯 設計の目的

このシステムは、**どのようなアセットも汎用的に利用できる**変身システムを実現することを目的としています。

### 主な目標

1. **アセットの元の配置・向きをそのまま利用**
   - アセットをServerStorageに配置した時点での位置・向きを保持
   - アセットごとに手動で位置指定する必要を最小限に
   - アセットの進行方向（Forward方向）をそのまま利用

2. **設定ファイルによる柔軟な調整**
   - 基本的には設定不要で動作
   - 必要に応じて微調整可能（位置オフセット、回転オフセット）

3. **様々なアセット構造に対応**
   - シンプルなPart（単一パーツ）
   - 複数のMeshPartを含むModel
   - 任意の階層構造

## 📋 システムの仕組み

### 1. アセットの元の状態を保持

```lua
-- アセットがServerStorageにある時点でのCFrameを保存
local originalPrimaryCFrame = primaryPart.CFrame

-- パーツ間の相対位置を保存（PrimaryPartを基準に）
local relativePositions = {}
for _, part in ipairs(modelParts) do
    local relativeCFrame = originalPrimaryCFrame:ToObjectSpace(part.CFrame)
    relativePositions[part] = relativeCFrame
end
```

**なぜこれが重要か？**
- アセットの元の構造（パーツ間の相対位置・向き）を完全に保持
- アセットを配置した時点での状態をそのまま利用
- アセットごとに手動で位置調整する必要がない

### 2. アセットの向きを保持

```lua
-- アセットの元の回転を保持
local targetRotation = originalPrimaryCFrame.Rotation * assetConfig.rotationOffset.Rotation

-- PrimaryPartを配置（元の向きを保持）
primaryPart.CFrame = CFrame.new(targetPosition) * targetRotation
```

**なぜこれが重要か？**
- アセットの進行方向（Forward方向）をそのまま利用
- アセットが前を向いている場合、そのまま前を向いたまま変身
- アセットごとに手動で回転調整する必要がない

### 3. 2つの配置モード

#### モード1: アセットをHumanoidRootPartの位置に合わせる（デフォルト）

```lua
if not assetConfig.alignHumanoidRootPartToAsset then
    -- アセットをHumanoidRootPartの位置に移動
    -- ただし、アセットの元の向きは保持
    local targetPosition = humanoidRootPart.Position + assetConfig.positionOffset
    local targetRotation = originalPrimaryCFrame.Rotation * assetConfig.rotationOffset.Rotation
    
    primaryPart.CFrame = CFrame.new(targetPosition) * targetRotation
end
```

**使用例:**
- 通常のキャラクター変身
- プレイヤーの位置にアセットを配置したい場合

#### モード2: HumanoidRootPartをアセットの位置に合わせる

```lua
if assetConfig.alignHumanoidRootPartToAsset then
    -- HumanoidRootPartをアセットの位置に移動
    -- アセットの元の位置をそのまま保持
    local targetPosition = originalPrimaryCFrame.Position + assetConfig.positionOffset
    local targetRotation = originalPrimaryCFrame.Rotation * assetConfig.rotationOffset.Rotation
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition) * targetRotation
    primaryPart.CFrame = originalPrimaryCFrame * CFrame.new(assetConfig.positionOffset) * assetConfig.rotationOffset
end
```

**使用例:**
- アセットの元の位置を厳密に保持したい場合
- 特定の位置にアセットを配置したい場合

### 4. Motor6Dによる接続

```lua
-- すべてのパーツをHumanoidRootPartに接続
for _, part in ipairs(modelParts) do
    local motor = Instance.new("Motor6D")
    motor.Part0 = humanoidRootPart
    motor.Part1 = part
    
    -- 相対位置を計算（現在の位置関係を保持）
    local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(part.CFrame)
    motor.C0 = CFrame.new()
    motor.C1 = relativeCFrame
    motor.Parent = humanoidRootPart
end
```

**なぜMotor6Dを使うか？**
- Robloxの標準的なパーツ接続方法
- HumanoidRootPartが移動すると、接続されたパーツも自動的に追従
- アセットの元の構造をそのまま保持

## 🔧 設定ファイル（CreatureConfig.luau）

### 基本的な使い方

```lua
Snake = {
    modelName = "SnakeModel",  -- ServerStorage内の名前
    -- その他の設定はすべてオプション
}
```

**ほとんどの場合、これだけで動作します！**

### オプション設定

```lua
Snake = {
    modelName = "SnakeModel",
    
    -- PrimaryPartの名前を指定（nilの場合は自動検出）
    primaryPartName = "Body",
    
    -- 位置オフセット（微調整用）
    positionOffset = Vector3.new(0, -1, 0),  -- Y軸を-1下げる
    
    -- 回転オフセット（微調整用）
    rotationOffset = CFrame.Angles(0, math.rad(90), 0),  -- Y軸を90度回転
    
    -- HumanoidRootPartをアセットの位置に合わせるかどうか
    alignHumanoidRootPartToAsset = false,  -- デフォルトはfalse
}
```

## 💡 設計の意図

### 1. なぜアセットの元の状態を保持するのか？

**問題点（旧システム）:**
- アセットをHumanoidRootPartの位置に合わせる際、アセットの元の向きが失われる
- アセットごとに手動で位置・回転を調整する必要がある
- アセットの進行方向が考慮されていない

**解決策（新システム）:**
- アセットの元のCFrameを保存し、その向きを保持
- アセットの進行方向（Forward方向）をそのまま利用
- 基本的には設定不要で動作

### 2. なぜ設定ファイルを導入したのか？

**問題点（旧システム）:**
- コード内にハードコードされた設定
- 新しいアセットを追加する際にコードを変更する必要がある

**解決策（新システム）:**
- 設定ファイルでアセットごとの設定を管理
- コードを変更せずに新しいアセットを追加可能
- デフォルト値により、基本的には設定不要

### 3. なぜ2つの配置モードを用意したのか？

**柔軟性のため:**
- 通常の変身: アセットをHumanoidRootPartの位置に配置（デフォルト）
- 特殊なケース: HumanoidRootPartをアセットの位置に移動（オプション）

**使用例:**
- 通常の変身: `alignHumanoidRootPartToAsset = false`（デフォルト）
- 特定の位置にアセットを配置したい場合: `alignHumanoidRootPartToAsset = true`

## 📊 システムの特徴

### メリット

1. **汎用性**
   - どのようなアセット構造にも対応
   - シンプルなPartから複雑なModelまで
   - アセットごとに手動で位置調整する必要がない

2. **柔軟性**
   - 設定ファイルで微調整可能
   - 2つの配置モードを選択可能
   - オフセット設定で細かい調整が可能

3. **保守性**
   - コードを変更せずに新しいアセットを追加可能
   - 設定ファイルで一元管理
   - デフォルト値により、基本的には設定不要

### 制限事項

1. **ServerStorageにモデルが必要**
   - モデルが存在しない場合は警告のみ

2. **BasePartが必要**
   - Meshだけでは動作しない

3. **サーバー側でのみ動作**
   - クライアント側では動作しない（セキュリティのため）

## 🎯 使用例

### 例1: 基本的な使用（設定不要）

```lua
-- CreatureConfig.luau
Snake = {
    modelName = "SnakeModel",
    -- その他の設定はすべてデフォルト値を使用
}
```

**これだけで動作します！**
- アセットの元の位置・向きがそのまま使用されます
- アセットをServerStorageに配置するだけでOK

### 例2: 位置を微調整したい場合

```lua
-- CreatureConfig.luau
Snake = {
    modelName = "SnakeModel",
    positionOffset = Vector3.new(0, -1, 0),  -- Y軸を-1下げる
}
```

**使用例:**
- ヘビが地面に這うようにしたい場合
- アセットの位置を少し調整したい場合

### 例3: 向きを微調整したい場合

```lua
-- CreatureConfig.luau
Snake = {
    modelName = "SnakeModel",
    rotationOffset = CFrame.Angles(0, math.rad(90), 0),  -- Y軸を90度回転
}
```

**使用例:**
- アセットの向きを少し調整したい場合
- アセットが横向きになっている場合

### 例4: アセットの元の位置を保持したい場合

```lua
-- CreatureConfig.luau
Snake = {
    modelName = "SnakeModel",
    alignHumanoidRootPartToAsset = true,  -- HumanoidRootPartをアセットの位置に移動
}
```

**使用例:**
- アセットの元の位置を厳密に保持したい場合
- 特定の位置にアセットを配置したい場合

## 🔄 旧システムとの比較

### 旧システムの問題点

1. **アセットの元の向きが失われる**
   - PrimaryPartをHumanoidRootPartの位置に合わせる際、アセットの元の向きが考慮されない
   - アセットごとに手動で回転調整する必要がある

2. **位置調整が複雑**
   - アセットごとに手動で位置を調整する必要がある
   - コード内にハードコードされた設定

3. **進行方向が考慮されていない**
   - アセットの進行方向（Forward方向）が考慮されない
   - アセットが前を向いている場合でも、変身後は別の方向を向く可能性がある

### 新システムの改善点

1. **アセットの元の向きを保持**
   - アセットの元のCFrameを保存し、その向きを保持
   - アセットの進行方向（Forward方向）をそのまま利用

2. **設定ファイルによる柔軟な調整**
   - 基本的には設定不要で動作
   - 必要に応じて微調整可能（位置オフセット、回転オフセット）

3. **汎用性の向上**
   - どのようなアセット構造にも対応
   - アセットごとに手動で位置調整する必要がない

## 📝 まとめ

この汎用的な変身システムは、以下の設計思想に基づいて実装されています：

1. **アセットの元の状態を保持**
   - アセットを配置した時点での位置・向きをそのまま利用
   - アセットごとに手動で位置調整する必要を最小限に

2. **設定ファイルによる柔軟な調整**
   - 基本的には設定不要で動作
   - 必要に応じて微調整可能

3. **様々なアセット構造に対応**
   - シンプルなPartから複雑なModelまで
   - 任意の階層構造に対応

これにより、**どのようなアセットも汎用的に利用できる**変身システムを実現しています。

