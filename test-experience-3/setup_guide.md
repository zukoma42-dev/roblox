# Roblox Studio セットアップ & Rojo同期ガイド

Roblox開発の第一歩として、手元のコード（VS Code）とRoblox Studioを接続（同期）します。
これにより、VS Codeで書いたプログラムが自動的にRoblox Studioに反映されるようになります。

## 手順 1: Rojoプラグインのインストール

1. **Roblox Studio** を起動し、**新規ファイル (Baseplateなど)** を開きます。
2. 上部メニューの **[Plugins]** タブをクリックします。
3. **[Manage Plugins]** をクリックし、プラグイン管理画面を開きます（またはToolboxのPluginsタブから検索）。
4. 検索バーに `Rojo` と入力し、**Rojo 7** (by Rojo) を探してインストールします。
   - ※ 見つからない場合は、こちらのリンクからブラウザでインストールボタンを押すとStudioが開きます: [Rojo Plugin](https://create.roblox.com/store/asset/4048317704/Rojo-7)

## 手順 2: Rojoサーバーの起動 (VS Code側)

VS Codeのターミナルで、以下のコマンドが実行されていることを確認します。
もし止まっていれば、再度実行してください。

```bash
rojo serve
```

出力に `Listening on 127.0.0.1:34872` のようなメッセージが出ていればOKです。これは「Studioからの接続を待っています」という意味です。

## 手順 3: 同期 (Connect)

1. Roblox Studioに戻ります。
2. **[Plugins]** タブにある **[Rojo]** アイコンをクリックして、Rojoパネルを開きます。
3. パネル内の **[Connect]** ボタンをクリックします。
4. 成功すると、Studio内の `ServerScriptService` や `ReplicatedStorage` に、VS Codeにあるフォルダ（`src/server`, `src/shared` など）が生成されます。

> [!IMPORTANT]
> **確認ポイント**:
> Explorerウィンドウ（表示されていない場合は [View] -> [Explorer]）を見て、
> `ServerScriptService` の中に `Server` -> `Services` -> `TransformationService` があるか確認してください。
> これがあれば同期成功です！

## 手順 4: 動作確認 (Play Test)

1. Studio上部の **[Home]** タブにある **[Play]** ボタンを押します。
2. ゲームが始まり、キャラクターがスポーンします。
3. キーボードの **`T`** キーを押します。
4. 画面下の **Output** ウィンドウ（[View] -> [Output]）に `Requesting transformation...` や `transforming into...` という文字が出れば成功です！
   - 現時点ではキャラクターが半透明になるだけですが、これでシステムが動いていることが確認できます。

---

## トラブルシューティング

- **Connectできない**: `rojo serve` が実行されているか確認してください。
- **スクリプトが見当たらない**: `default.project.json` の設定が正しいか確認しますが、今回は自動生成しているので問題ないはずです。Rojoパネルの接続先アドレスが `127.0.0.1` ポート `34872` になっているか確認してください。
