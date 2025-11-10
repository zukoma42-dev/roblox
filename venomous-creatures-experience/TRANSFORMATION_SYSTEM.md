# 変身システムの仕組み

## 🎯 システム全体の流れ

```
ゲーム開始
  ↓
プレイヤー参加 (PlayerManager)
  ↓
VenomousCharacter作成
  ↓
キャラクタースポーン
  ↓
変身処理 (transformToCreature)
  ↓
サイズ設定 (setSize)
  ↓
完了
```

## 📋 主要コンポーネント

### 1. PlayerManager（プレイヤー管理サービス）

**役割**: プレイヤーの参加・退出を監視し、変身システムを初期化

**処理の流れ**:
1. プレイヤーが参加すると`onPlayerAdded`が呼ばれる
2. `VenomousCharacter.new(player)`で変身コンポーネントを作成
3. キャラクターがスポーンしたら`character:initialize()`を呼ぶ
4. キャラクターが再スポーンしたときも自動的に初期化

**コードの場所**: `src/server/Services/PlayerManager.luau`

### 2. VenomousCharacter（変身コンポーネント）

**役割**: プレイヤーを毒生物に変身させ、サイズを管理

**主な機能**:
- 変身処理 (`transformToCreature`)
- サイズ管理 (`setSize`)
- 成長処理 (`growFromItem`, `growFromPlayer`)

**コードの場所**: `src/server/Components/VenomousCharacter.luau`

## 🔄 変身処理の詳細な流れ

### ステップ1: 初期化 (`initialize`)

```lua
function VenomousCharacter:initialize()
    -- 1. キャラクターを取得
    local character = self.player.Character
    
    -- 2. Humanoidを取得
    self.humanoid = character:WaitForChild("Humanoid")
    
    -- 3. 変身処理
    self:transformToCreature()
    
    -- 4. サイズ設定
    self:setSize(self.size)
end
```

### ステップ2: 変身処理 (`transformToCreature`)

#### 2-1. モデルの取得

```lua
-- ServerStorageからモデルを取得
local ServerStorage = game:GetService("ServerStorage")
local modelName = self.creatureType .. "Model" -- "SnakeModel"
local modelTemplate = ServerStorage:FindFirstChild(modelName)
```

**処理内容**:
- ServerStorageから「SnakeModel」を探す
- 見つからない場合は警告を表示

#### 2-2. 既存のキャラクターパーツを非表示

```lua
-- 既存のキャラクターパーツを非表示
for _, part in ipairs(self.character:GetChildren()) do
    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
        part.Transparency = 1  -- 完全に透明にする
        part.CanCollide = false  -- 衝突を無効にする
    end
end

-- アクセサリーも削除
for _, accessory in ipairs(self.character:GetChildren()) do
    if accessory:IsA("Accessory") then
        accessory:Destroy()
    end
end
```

**処理内容**:
- プレイヤーのアバター（頭、体、手足など）を非表示
- HumanoidRootPartは残す（移動に必要）
- アクセサリー（帽子、装飾品など）を削除

#### 2-3. モデルの複製と配置

```lua
-- モデルを複製
local creatureModel = modelTemplate:Clone()

-- モデル内のHumanoidを削除
for _, child in ipairs(creatureModel:GetDescendants()) do
    if child:IsA("Humanoid") then
        child:Destroy()
    end
end

-- キャラクターの子として配置
creatureModel.Parent = self.character
```

**処理内容**:
- ServerStorageのモデルを複製
- モデル内のHumanoidを削除（プレイヤーの既存のHumanoidを使用）
- キャラクターの子として配置

#### 2-4. パーツの検出

```lua
-- モデル内のすべてのBasePartを取得
local modelParts = {}
for _, descendant in ipairs(creatureModel:GetDescendants()) do
    if descendant:IsA("BasePart") then
        table.insert(modelParts, descendant)
    end
end
```

**処理内容**:
- モデル内のすべてのBasePart（Part、MeshPartなど）を検出
- 配列に格納

#### 2-5. 位置の調整

```lua
-- モデルのPrimaryPartを設定
if creatureModel:IsA("Model") then
    creatureModel.PrimaryPart = primaryPart
end

-- モデル全体の位置を調整
creatureModel:SetPrimaryPartCFrame(humanoidRootPart.CFrame)
```

**処理内容**:
- 最初のパーツをPrimaryPartに設定
- HumanoidRootPartの位置に合わせてモデル全体を移動

#### 2-6. Motor6Dによる接続（重要）

```lua
-- すべてのMeshPartをHumanoidRootPartに接続
for _, part in ipairs(modelParts) do
    -- Motor6Dを作成
    local motor = Instance.new("Motor6D")
    motor.Part0 = humanoidRootPart  -- 基準となるパーツ
    motor.Part1 = part  -- 接続されるパーツ
    
    -- 相対位置を計算
    local relativeCFrame = humanoidRootPart.CFrame:ToObjectSpace(part.CFrame)
    motor.C0 = CFrame.new()  -- HumanoidRootPartの位置
    motor.C1 = relativeCFrame  -- パーツの相対位置
    
    motor.Parent = humanoidRootPart
end
```

**Motor6Dとは？**
- Robloxの標準的なパーツ接続方法
- Part0が移動すると、Part1も自動的に追従
- Characterのパーツ（頭、体など）もMotor6Dで接続されている

**処理内容**:
- 各MeshPartを個別にHumanoidRootPartに接続
- 相対位置を計算して設定
- これにより、プレイヤーが移動するとヘビも一緒に動く

### ステップ3: サイズ設定 (`setSize`)

#### 3-1. 初期サイズの保存

```lua
-- 各パーツの初期サイズを保存（初回のみ）
if not part:GetAttribute("InitialSizeX") then
    part:SetAttribute("InitialSizeX", part.Size.X)
    part:SetAttribute("InitialSizeY", part.Size.Y)
    part:SetAttribute("InitialSizeZ", part.Size.Z)
end
```

**処理内容**:
- 各パーツの初期サイズをAttributeに保存
- X、Y、Z軸を個別に保存（形状の比率を保持するため）

#### 3-2. サイズの調整

```lua
-- サイズを調整（各軸の比率を保持）
local initialSizeX = part:GetAttribute("InitialSizeX") or 1
local initialSizeY = part:GetAttribute("InitialSizeY") or 1
local initialSizeZ = part:GetAttribute("InitialSizeZ") or 1
part.Size = Vector3.new(
    initialSizeX * self.size,
    initialSizeY * self.size,
    initialSizeZ * self.size
)
```

**処理内容**:
- 保存した初期サイズを取得
- 各軸に同じスケール係数（`self.size`）を適用
- 形状の比率を保持しながらサイズを変更

#### 3-3. 移動速度の調整

```lua
-- 移動速度を調整
if self.humanoid then
    local speed = GrowthSystem.calculateSpeed(self.size)
    self.humanoid.WalkSpeed = speed
end
```

**処理内容**:
- サイズに応じて移動速度を計算
- HumanoidのWalkSpeedを設定

## 🔗 データの流れ

### プレイヤー参加時

```
PlayerManager.start()
  ↓
Players.PlayerAdded イベント
  ↓
onPlayerAdded(player)
  ↓
VenomousCharacter.new(player)
  ↓
player.CharacterAdded イベント
  ↓
character:initialize()
  ↓
transformToCreature()
  ↓
setSize()
```

### 変身処理の詳細

```
transformToCreature()
  ↓
1. ServerStorageからモデル取得
  ↓
2. 既存パーツを非表示
  ↓
3. モデルを複製
  ↓
4. Humanoidを削除
  ↓
5. パーツを検出
  ↓
6. 位置を調整
  ↓
7. Motor6Dで接続
  ↓
完了
```

## 🎨 視覚的な構造

### 変身前

```
Character
  ├── HumanoidRootPart
  ├── Head
  ├── Torso
  ├── LeftArm
  ├── RightArm
  ├── LeftLeg
  └── RightLeg
```

### 変身後

```
Character
  ├── HumanoidRootPart
  │   ├── Motor6D → MeshPart1
  │   ├── Motor6D → MeshPart2
  │   └── Motor6D → MeshPart3
  ├── Head (Transparency = 1)
  ├── Torso (Transparency = 1)
  └── ...
  └── SnakeModel
      ├── MeshPart1 (表示)
      ├── MeshPart2 (表示)
      └── MeshPart3 (表示)
```

## 💡 重要なポイント

### 1. Motor6Dによる接続

**なぜMotor6Dが必要なのか？**
- HumanoidRootPartが移動すると、Motor6Dで接続されたパーツも自動的に追従
- これにより、プレイヤーが移動するとヘビも一緒に動く

### 2. 既存パーツの非表示

**なぜ削除しないのか？**
- HumanoidRootPartは移動に必要
- 他のパーツも削除すると問題が発生する可能性がある
- Transparency = 1で非表示にする方が安全

### 3. サイズ管理

**なぜ各軸を個別に保存するのか？**
- 細長い形状（8, 1, 1）を保持するため
- すべての軸に同じ値を適用すると正方形になってしまう

### 4. モデルの複製

**なぜClone()を使うのか？**
- ServerStorageのモデルはテンプレート
- 各プレイヤーに個別のインスタンスが必要
- Clone()で複製して使用

## 🔄 再スポーン時の処理

プレイヤーが死亡して再スポーンした場合：

1. `player.CharacterAdded`イベントが発火
2. `character:initialize()`が再度呼ばれる
3. 変身処理が再度実行される
4. サイズが初期値（1.0）にリセットされる

## 📊 システムの特徴

### メリット

1. **柔軟性**
   - シンプルなPartにも対応
   - 複数のMeshPartにも対応
   - モデルの構造に依存しない

2. **パフォーマンス**
   - 必要な処理のみを実行
   - 効率的な接続方法

3. **拡張性**
   - 将来的に複数の毒生物タイプに対応可能
   - 進化システムにも対応可能

### 制限事項

1. **ServerStorageにモデルが必要**
   - モデルが存在しない場合は警告のみ

2. **BasePartが必要**
   - Meshだけでは動作しない

3. **サーバー側でのみ動作**
   - クライアント側では動作しない（セキュリティのため）

## 🎯 まとめ

現在の変身システムは以下のような仕組みで動作しています：

1. **プレイヤー管理**: PlayerManagerがプレイヤーの参加を監視
2. **変身処理**: VenomousCharacterが変身を実行
3. **接続**: Motor6Dでヘビをプレイヤーに接続
4. **サイズ管理**: 各軸の比率を保持しながらサイズ調整

この仕組みにより、プレイヤーが毒生物に変身し、移動とサイズ調整が正しく動作します。

