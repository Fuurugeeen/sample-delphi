# CLAUDE.md

このファイルは、このリポジトリでコードを操作する際のClaude Code (claude.ai/code) へのガイダンスを提供します。

## プロジェクト概要

これはWin32/Win64プラットフォームを対象としたDelphi VCL電卓アプリケーションです。プロジェクトは、モデル・ビュー分離パターンを使用して基本的な算術演算を実装した標準的な電卓を実装しています。

## ビルドと開発

**ビルドコマンド:**
- 手動ビルド: RAD Studio IDEで`Project1.dproj`を開いてビルド (Ctrl+F9)
- コマンドラインビルド: `dcc32 Project1.dpr` (DelphiコンパイラがPATHに必要)

**テスト:**
- テスト実行: `.\tests\run_tests.bat` または `.\tests\run_tests.ps1`
- 手動テスト: RAD Studioで`tests/CalculatorTests.dproj`を開いて実行 (F9)
- テストはDUnitXフレームワークを使用

## アーキテクチャ

**コアコンポーネント:**
- `src/engines/CalculatorEngine.pas` - 計算、状態管理、エラーハンドリングを担当するビジネスロジックエンジン
- `src/forms/CalcForm.pas` - UIイベント処理を行うメイン電卓フォーム
- `Unit1.pas` - レガシーメインフォーム (CalcFormに置き換え中)

**主要な設計パターン:**
- **モデル・ビュー分離**: `TCalculatorEngine`が全てのビジネスロジックを担当し、`TCalculatorForm`がUIを管理
- **状態マシン**: エンジンが現在値、保存値、演算、入力状態を追跡
- **エラーハンドリング**: 日本語エラーメッセージによる集約エラー管理

**データフロー:**
1. ユーザー入力 → フォームイベントハンドラー → エンジンメソッド
2. エンジンが内部状態を更新し計算を実行
3. フォームが`GetDisplay()`経由でエンジンに表示更新を問い合わせ

**重要なクラス:**
- `TCalculatorEngine`: 演算機能（加算、減算、乗算、除算）を持つコア計算ロジック
- `TOperation`: 利用可能な演算を定義する列挙型
- フォームは表示用の`FCurrentInput`文字列を維持し、エンジンが数値状態を管理