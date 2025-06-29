# IDE テスト実行手順

## Delphi Community Edition での制限

Delphi Community Edition ではコマンドライン コンパイラ（dcc32.exe）が使用できません。
テストの実行にはRAD Studio IDEを使用する必要があります。

## テスト実行手順

### 1. テストプロジェクトを開く
1. RAD Studio を起動
2. `File` → `Open Project...` をクリック
3. `tests\CalculatorTests.dproj` を選択して開く

### 2. プロジェクトをビルド
1. `Project` → `Build CalculatorTests` をクリック
   または `Ctrl + F9` を押す
2. ビルドエラーがないことを確認

### 3. テストを実行
1. `Run` → `Run` をクリック
   または `F9` を押す
2. コンソールウィンドウが開きテスト結果が表示される

### 4. テスト結果の確認
- `[PASS]` マークが付いたテストは成功
- `[FAIL]` マークが付いたテストは失敗
- 最終行に全体の結果が表示される

## 代替手法: Test Insight を使用

RAD Studio には Test Insight という統合テスト実行環境があります。

### Test Insight の使用方法
1. テストプロジェクトを開いた状態で
2. `View` → `Test Explorer` をクリック
3. Test Explorer パネルが表示される
4. テストを右クリックして `Run` または `Run All` を選択

### Test Insight の利点
- GUI でテスト結果を確認できる
- 個別テストの実行が可能
- 失敗したテストの詳細情報を表示
- テストカバレッジの確認（Professional以上）

## トラブルシューティング

### よくあるエラー

#### 1. "Unit 'DUnitX.TestFramework' not found"
**解決方法:**
- DUnitX は RAD Studio 10.1 以降に標準搭載
- 古いバージョンの場合は Get It Package Manager からインストール

#### 2. "Unit 'CalculatorEngine' not found"
**解決方法:**
1. `Project` → `Options` をクリック
2. `Delphi Compiler` → `Search path` を選択
3. `..` ボタンをクリックして以下のパスを追加:
   - `..\src\engines`
   - `..`

#### 3. "Form file 'Unit1.dfm' not found"
**解決方法:**
- `Unit1.dfm` ファイルが存在することを確認
- プロジェクトのルートディレクトリに配置されているか確認

## 開発者向けTips

### 1. テストの追加
新しいテストを追加する場合:
```pascal
[Test]
procedure Test_新機能_期待する動作;
```

### 2. テストデータの準備
複雑なテストデータが必要な場合:
```pascal
[Setup]
procedure Setup;
begin
  // テスト前の準備処理
end;

[TearDown] 
procedure TearDown;
begin
  // テスト後のクリーンアップ
end;
```

### 3. デバッグ
テストにブレークポイントを設定してデバッグ実行が可能です。