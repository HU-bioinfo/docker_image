# HU Bioinfo Container

## 概要

HU Bioinfo Containerは、[HU Bioinfo Launcher](https://marketplace.visualstudio.com/items?itemName=hu-bioinfo-workshop.bioinfo-launcher)のために作成されたコンテナ環境です。

## 使用方法
[HU Bioinfo Launcher](https://marketplace.visualstudio.com/items?itemName=hu-bioinfo-workshop.bioinfo-launcher)を参照してください。

## コンテナ環境の概要
### USER
- user:user (1000:1000)
- 管理者権限なし
- パスワード:無し

### hu_bioinfo_lite.Dockerfile
- R
    - radian
    - renv
    - httpgd
- Python
    - uv

### hu_bioinfo_full.Dockerfile
- R
    - radian
    - renv
    - httpgd
- Python
    - uv
- LaTeX
    - TinyTeX
- Quarto
- Typst

## コンテナ専用コマンド
### prem
- `prem {directory}`コマンドによりrenvおよびvenvプロジェクトを作成します。
- fullにはLaTeX, Quarto, Typstのtemplateもコピーされます。

