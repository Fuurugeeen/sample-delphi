# テスト実行方法

## 自動実行

### PowerShell（推奨）
```powershell
.\run_tests.ps1
```

### Batch
```batch
run_tests.bat
```

## 手動実行

### 1. RAD Studio IDEを使用
1. `CalculatorTests.dproj`をRAD Studioで開く
2. プロジェクトをビルド（Ctrl+F9）
3. 実行（F9）

### 2. コマンドラインでビルド
```batch
# Delphiがインストールされている場合
dcc32 CalculatorTests.dpr

# または特定のパスを指定
"C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\dcc32.exe" CalculatorTests.dpr
```

### 3. テスト実行
```batch
Win32\Debug\CalculatorTests.exe --format=console
```

## トラブルシューティング

### Delphiコンパイラが見つからない場合

1. **RAD Studioがインストールされているか確認**
   - 通常のインストールパス: `C:\Program Files (x86)\Embarcadero\Studio\`

2. **BDS環境変数を設定**
   ```batch
   set BDS=C:\Program Files (x86)\Embarcadero\Studio\22.0
   ```

3. **PATHにdcc32.exeを追加**
   - システム環境変数のPATHに以下を追加:
   - `C:\Program Files (x86)\Embarcadero\Studio\22.0\bin`

### DUnitXが見つからない場合

RAD Studio 10.1以降であれば、DUnitXは標準でインストールされています。
古いバージョンの場合は、DUnitXを別途インストールしてください。

### 実行時エラーが発生する場合

1. **必要なDLLの確認**
   - VCLアプリケーションの場合、適切なVCLライブラリが必要

2. **権限の確認**
   - 管理者権限でコマンドプロンプトを実行

3. **依存関係の確認**
   - `Unit1.dfm`ファイルが存在するか確認
   - `CalculatorEngine.pas`ファイルが存在するか確認

## テスト結果の確認

成功した場合の出力例:
```
[PASS] Test_Create_ShouldInitializeCorrectly
[PASS] Test_Addition_ShouldCalculateCorrectly
...
Tests run: 24, Passed: 24, Failed: 0
```

失敗した場合の出力例:
```
[FAIL] Test_Addition_ShouldCalculateCorrectly
  Expected: 8 but was: 7
Tests run: 24, Passed: 23, Failed: 1
```