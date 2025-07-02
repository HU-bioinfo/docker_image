# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 言語設定
- **重要**: すべてのやり取りは日本語で行う
- ユーザーとのコミュニケーションは日本語で回答する
- コードコメントや説明も日本語で記述する

## プロジェクト概要
このリポジトリは、`hubioinfows/full_env`と`hubioinfows/lite_env`という2つのDockerイメージを管理するためのリポジトリです。[HU Bioinfo Launcher](https://marketplace.visualstudio.com/items?itemName=hu-bioinfo-workshop.bioinfo-launcher)のためのバイオインフォマティクス解析用統合開発環境を提供します。

厳密にはdocker-composeとdevcontainer.jsonはイメージの管理に必要ありませんが、このイメージを実際に利用する際の環境を再現してテストするために同じリポジトリ内に格納しています。

## アーキテクチャ

### ディレクトリ構造
```
Dockerfile_space/
├── base_env/                    # メインのコンテナ環境設定
│   ├── .devcontainer/          # DevContainer設定
│   │   ├── hu_bioinfo_lite.Dockerfile
│   │   ├── hu_bioinfo_full.Dockerfile
│   │   ├── docker-compose.yml
│   │   └── devcontainer.json
│   └── projects/               # プロジェクトテンプレート（テスト用）
├── testspace/                  # テスト環境
│   └── .devcontainer/         # テスト用DevContainer設定
└── cache/                      # キャッシュディレクトリ
    ├── TinyTeX/               # LaTeXキャッシュ
    ├── renv/                  # Rパッケージキャッシュ
    └── uv/                    # Pythonパッケージキャッシュ
```

### Dockerイメージの構成

#### 1. hubioinfows/lite_env (軽量版)
- **ベースイメージ**: rocker/r-ver:4.4.3
- **含まれるツール**:
  - R環境: radian, renv, httpgd
  - Python環境: Python 3, uv
  - 基本的な開発ツール

#### 2. hubioinfows/full_env (フル版)
- **ベースイメージ**: hubioinfows/lite_env:latest
- **追加ツール**:
  - LaTeX: TinyTeX
  - Quarto
  - Typst
  - Node.js
  - Claude Code

## イメージのメンテナンスルール

### 1. バージョン管理
- **タグ付けルール**: 
  - `latest`: 最新の安定版
  - `vX.Y.Z`: セマンティックバージョニング
  - 重大な変更時はメジャーバージョンを上げる

### 2. ビルドとテスト
```bash
# ローカルでのビルド（base_envディレクトリで実行）
cd base_env/.devcontainer

# lite版のビルド
docker build -f hu_bioinfo_lite.Dockerfile -t hubioinfows/lite_env:test .

# full版のビルド（lite版が必要）
docker build -f hu_bioinfo_full.Dockerfile -t hubioinfows/full_env:test .

# docker-composeでのテスト
docker-compose up -d
```

### 3. イメージの更新手順
1. **依存関係の更新**:
   - Rバージョン: rocker/r-ver のタグを更新
   - Pythonパッケージ: install_py.sh を確認
   - システムパッケージ: install_deps.sh を確認

2. **スクリプトの配置**:
   - すべてのビルドスクリプトは `/scripts/` ディレクトリに配置
   - インストーラーは `/scripts/installer/` に配置

3. **テスト項目**:
   - `prem` コマンドでプロジェクト作成が成功すること
   - R環境: radianが起動し、renvが動作すること
   - Python環境: uvコマンドが使用できること
   - (full版) LaTeX、Quarto、Typstが正常に動作すること

### 4. セキュリティとベストプラクティス

#### ユーザー権限
- **実行ユーザー**: user:user (1000:1000)
- root権限は最小限に
- パスワードは設定しない

#### ビルド時の注意
- 不要なファイルは削除 (`apt-get autoremove`, `rm -rf /var/lib/apt/lists/*`)
- レイヤーを適切に分割（キャッシュ効率を考慮）
- センシティブな情報をイメージに含めない

#### 環境変数
- `CACHE_DIR`: /home/user/cache
- `PROJ_DIR`: /home/user/proj
- `GITHUB_PAT`: 必要に応じて設定

### 5. デバッグとトラブルシューティング

#### ビルドエラー時の確認事項
1. スクリプトのパーミッション (`chmod +x`)
2. パスの確認（COPYコマンドの相対パス）
3. 依存関係の順序（Node.jsは他のツールより先にインストール）

#### コンテナ内での確認
```bash
# コンテナに入る
docker exec -it dev-hubioinfows-full-container bash

# インストール状況の確認
which radian
which uv
which quarto
which typst
```

### 6. リリース前のチェックリスト
- [ ] すべてのスクリプトが正常に実行されること
- [ ] `prem` コマンドでプロジェクトが作成できること
- [ ] VSCode拡張機能が正しくインストールされること
- [ ] キャッシュディレクトリが適切にマウントされること
- [ ] ドキュメント（README.md）の更新

### 7. 継続的なメンテナンス
- 月次でベースイメージの更新を確認
- セキュリティパッチの適用
- ユーザーからのフィードバックの反映
- 新しいツールの追加検討

## 重要な注意事項
- このプロジェクトにはCI/CDパイプラインは設定されていません
- イメージのプッシュは手動で行います: `docker push hubioinfows/[lite_env|full_env]:tag`
- テストはローカル環境で実施してください