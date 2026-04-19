# Agent Instructions

## プロジェクト概要

このリポジトリは `koutyuke` ホスト向けの宣言的な macOS dotfiles を管理しています。
構成の中心は `nix-darwin`、`home-manager`、`flake-parts`、`brew-nix`、
`treefmt-nix` です。

現在の flake target は次のとおりです。

```bash
.#darwinConfigurations.koutyuke
```

対象システムは `aarch64-darwin` です。

## リポジトリ構成

- `flake.nix`: flake のエントリポイントと input 定義
- `nix/flakes/`: host、app、treefmt 向けの flake-parts module
- `nix/lib/mk-darwin-system.nix`: darwin system 用の共通 constructor
- `nix/modules/darwin/`: macOS 全体と nix-darwin 用の共通 module
- `nix/modules/home/`: home-manager 用の共通 user module
- `nix/hosts/koutyuke/`: host 固有の設定
- `nix/hosts/koutyuke/users/kousuke/`: user 固有の設定
- `nix/overlays/`: package と brew-cask の overlay
- `karabiner/`: user 設定にリンクされる Karabiner 設定
- `docs/package-management.md`: package 配置ルールの詳細

## 変更方針

既存の module 境界を優先し、変更範囲は必要最小限に留めてください。

- macOS 全体または nix-darwin 共通の設定は `nix/modules/darwin/` に置く
- user 共通の package や home-manager 設定は `nix/modules/home/` に置く
- `koutyuke` 固有の設定は `nix/hosts/koutyuke/` に置く
- Git identity や個人用・業務用 package を含む `kousuke` 固有の設定は
  `nix/hosts/koutyuke/users/kousuke/` に置く
- home-manager または nix-darwin に `programs.<tool>` module がある場合は
  それを使い、ローカルの慣例で必要な場合を除いて同じ tool を package list に
  も重複して追加しない

package の配置は `docs/package-management.md` に従ってください。

- system integration が不要な GUI app は `pkgs.brewCasks` を優先する
- `/Applications` への配置、URI scheme 登録、browser extension integration、
  privileged helper、kernel または system extension、VPN client、custom tap
  が必要な app、または brew-nix では clean に build できない app は
  `homebrew.casks` を使う
- Mac App Store 配布で、他の手段で扱えない app のみ `homebrew.masApps` を使う
- CLI tool は nixpkgs に存在するならそれを使い、nixpkgs が適さない場合のみ
  Homebrew formula を使う

## コマンド

リポジトリを format する:

```bash
nix fmt
```

switch せずに build する:

```bash
nix build .#darwinConfigurations.koutyuke.system
```

対象マシンに設定を反映する:

```bash
darwin-rebuild switch --flake .#koutyuke
```

flake input を更新し、garbage collection を実行する:

```bash
nix run .#update
```

## 編集時の注意

- 周囲の file と整合する Nix module style を使う
- 無関係な format や lockfile の変更は行わない
- task が input 更新を明示的に含まない限り `flake.lock` は編集しない
- Karabiner の変更は `karabiner/karabiner.json` に入れる。これは Nix store に
  コピーされるのではなく、darwin dotfiles module から symlink される
- 検証中に生成された不要ファイルは、作業完了前に削除する。例: `nix build` の
  `result` symlink、一時 file、一時 directory
- commit 前には Nix 変更に対して `nix fmt` を実行する。変更が module wiring、
  package、overlay、flake input に及ぶ場合は build check も優先して行う
