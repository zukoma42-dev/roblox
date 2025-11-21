# アセットセットアップガイド

実際のキャラクターモデルを変身システムで使用するための手順です。
この作業は **Roblox Studio** 上で行う必要があります。

## 1. フォルダ構造の作成

`ReplicatedStorage` 内に以下のフォルダを作成してください：

1. `ReplicatedStorage` を右クリック > **Insert Object** > **Folder**
2. 名前を `Assets` に変更
3. `Assets` フォルダの中に、さらに **Folder** を作成し、名前を `Models` に変更

最終的な構造:
```
ReplicatedStorage
└── Assets
    └── Models
```

## 2. モデルの配置

使用したいキャラクターモデルを `Models` フォルダの中に配置します。

### 重要なルール
- **モデル名**: 変身IDと完全に一致させる必要があります。
    - 戦士のモデル: `Warrior`
    - 魔法使いのモデル: `Mage`
    - **家具・物体**: `Chair` など（`TransformationConstants.lua` で定義したID）
- **PrimaryPartの設定**:
    1. モデルを選択します。
    2. プロパティウィンドウの **PrimaryPart** をクリックします。
    3. モデル内の中心となるパーツをクリックして設定します。
    - **注意**: これが設定されていないと、モデルが正しく表示されません。

### オブジェクト（家具など）の場合
- 人型ではないモデル（椅子、食べ物など）も配置可能です。
- この場合、アニメーションはせず、プレイヤーの足元に固定されて移動します。

### 位置と向きの調整（高度な設定）
変身したモデルが浮いていたり、向きがずれている場合は `TransformationConstants.lua` で調整します。

#### 基準について
- **位置（Offset）**: プレイヤーの腰（`HumanoidRootPart`）が基準（0,0,0）です。
    - 腰の高さは地面から約 **3スタッド** です。
    - 地面に置くには、Yを **-2.5 〜 -3.0** 程度に設定します（例: `Vector3.new(0, -2.5, 0)`）。
- **向き（Rotation）**: プレイヤーの正面が基準（0,0,0）です。
    - モデルが横を向いている場合は、Y軸を90度回転させます（例: `Vector3.new(0, 90, 0)`）。

#### Roblox Studioでの確認方法
数値の目安を知るために、以下の手順でシミュレーションできます。

1. **ダミー人形を出す**:
    - [Plugins] タブ -> [Build Rig] -> [R15] -> [Block Rig] を選択してダミーを出します。
2. **モデルを合わせる**:
    - 作成したモデル（Chairなど）をダミーの場所まで移動させます。
    - モデルの `PrimaryPart` を、ダミーの `HumanoidRootPart`（胴体の中心）と同じ位置に重ねてみます。
3. **ズレを確認する**:
    - その状態で、モデルが地面からどれくらい浮いているか、向きが合っているかを目視で確認します。
    - 浮いている分だけ `Offset` のYをマイナスにします。

### モデルの準備（テスト用）
手元にモデルがない場合は、Toolboxから適当なモデル（"Dummy" や "NPC" など）を探して配置するか、簡単なパーツをグループ化(`Ctrl + G`)してモデルにしてください。

## 3. アニメーション対応のための設定（重要）

変身後のモデルがプレイヤーの動きに合わせて手足を動かすためには、**モデル内のパーツ名がRobloxの標準的な名前と一致している必要があります**。

### 必要なパーツ名の例（R15の場合）
- `LeftUpperLeg`, `LeftLowerLeg`, `LeftFoot`
- `RightUpperLeg`, `RightLowerLeg`, `RightFoot`
- `LeftUpperArm`, `LeftLowerArm`, `LeftHand`
- `RightUpperArm`, `RightLowerArm`, `RightHand`
- `UpperTorso`, `LowerTorso`, `Head`

> [!NOTE]
> **自動対応機能**:
> モデルが古い形式（R6: `Left Arm`, `Right Leg`, `Torso` など）の場合でも、システムが自動的に判断して適切な場所に接続します。
> そのため、パーツ名の変更は不要です。

## 4. 設定の確認

モデル内のパーツ設定を確認してください：
- **Anchored**: すべてのパーツの `Anchored` プロパティが **オフ (チェックなし)** であること。
    - オンになっていると、キャラクターが動けなくなります。
- **CanCollide**: 移動の邪魔にならないよう、必要に応じてオフにしてください（特にHumanoidRootPartと重なる部分）。

## 4. テスト

1. Roblox Studioで **Play** を押します。
2. `T` キー（Warrior）または `Y` キー（Mage）を押して変身します。
3. ログ（Output）を確認します：
    - 成功: `[TransformationService] Found real asset for: Warrior`
    - 失敗: `[TransformationService] Real asset not found...` （この場合、モデル名や場所を確認してください）
