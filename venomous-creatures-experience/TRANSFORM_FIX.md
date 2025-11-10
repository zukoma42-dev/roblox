# 変身機能の修正

## 🐛 問題の原因

### 現象
- プレイヤーが変身せず、緑のボックスを「持っている」ような状態
- プレイヤーのアバターが見えている

### 原因

1. **既存のキャラクターパーツが非表示になっていない**
   - プレイヤーのアバター（頭、体、手足など）が表示されたまま
   - 緑のボックスと一緒に表示されている

2. **Partの接続方法が不適切**
   - WeldConstraintだけでは不十分な場合がある
   - Motor6Dを使用する方が確実

3. **Partの位置が正しく設定されていない**
   - HumanoidRootPartの位置に正確に配置されていない

## ✅ 修正内容

### 1. 既存のキャラクターパーツを非表示

```lua
-- 既存のキャラクターパーツを非表示
for _, part in ipairs(self.character:GetChildren()) do
    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
        part.Transparency = 1  -- 完全に透明にする
        part.CanCollide = false  -- 衝突を無効にする
    end
end
```

**注意**: 
- HumanoidRootPartは残す必要がある（移動に必要）
- 削除（Destroy）ではなく、透明にする（Transparency = 1）

### 2. Motor6Dを使用した接続

```lua
-- Motor6Dを作成してHumanoidRootPartに接続
local motor = Instance.new("Motor6D")
motor.Part0 = humanoidRootPart
motor.Part1 = creatureModel
motor.C0 = CFrame.new()  -- 相対位置（オフセットなし）
motor.C1 = CFrame.new()  -- 相対回転（オフセットなし）
motor.Parent = humanoidRootPart
```

**Motor6Dとは？**
- Robloxの標準的なパーツ接続方法
- Characterのパーツ（頭、体など）もMotor6Dで接続されている
- WeldConstraintより確実に動作する

### 3. 位置の正確な設定

```lua
-- HumanoidRootPartの位置と回転に合わせる
creatureModel.CFrame = humanoidRootPart.CFrame
```

**CFrameとは？**
- 位置（Position）と回転（Rotation）を同時に設定
- 単純なPosition設定より確実

## 🧪 動作確認

修正後、以下を確認してください：

1. **ファイルを保存**
   - 変更がRojoで自動的に同期されることを確認

2. **ゲームを実行**
   - 「Play」ボタンをクリック
   - Outputウィンドウでエラーがないことを確認

3. **プレイヤーを確認**
   - プレイヤーのアバターが非表示になっていることを確認
   - 緑のボックスがプレイヤーの位置に正しく配置されていることを確認
   - 移動時にボックスがプレイヤーと一緒に動くことを確認

## 💡 補足説明

### なぜTransparency = 1なのか？

- **Transparency = 0**: 完全に不透明（見える）
- **Transparency = 1**: 完全に透明（見えない）
- **Destroy()との違い**: Destroy()は削除するため、後で復元できない。Transparency = 1は非表示にするだけなので、必要に応じて復元可能。

### Motor6D vs WeldConstraint

**Motor6D**:
- Robloxの標準的な接続方法
- Characterのパーツ接続に使用
- より確実に動作

**WeldConstraint**:
- 物理的な接続
- 一部のケースで動作しない場合がある

### CFrame vs Position

**CFrame**:
- 位置と回転を同時に設定
- より正確

**Position**:
- 位置のみ設定
- 回転が考慮されない

## 🎯 期待される動作

修正後、以下のようになるはずです：

1. ✅ プレイヤーのアバターが非表示になる
2. ✅ 緑のボックスがプレイヤーの位置に表示される
3. ✅ 移動時にボックスがプレイヤーと一緒に動く
4. ✅ サイズ調整が正しく動作する

