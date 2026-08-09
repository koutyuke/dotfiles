# AGENTS.md

## このファイルの目的

このリポジトリは、`nix-darwin` と Home Manager で macOS の環境を宣言的に管理する dotfiles です。ここでは、エージェントが変更を安全に行うためのプロジェクト固有の規約だけを定めます。

- 対象システムは `aarch64-darwin`
- Flake のホストは `koutyuke` と `cybozu`
- ユーザー名はどちらも `koutyuke`
- 作業対象は原則としてこのリポジトリ内に限定する
- 既存のユーザー変更、未追跡ファイル、生成物を勝手に戻したり削除したりしない

より詳しい利用手順は `README.md`、Neovim は `docs/neovim-usage.md`、Karabiner は `karabiner/README.md` を参照する。サブディレクトリに別の `AGENTS.md` がある場合は、その適用範囲ではそちらを優先する。

## 作業開始時の確認

変更前に次を実行する。

```bash
git status --short
```

既存変更があれば内容を確認し、今回の変更と混ぜない。対象ホストと変更範囲を先に特定し、関連する既存モジュール、`README.md`、該当ドキュメントを読んでから編集する。

設定を編集する前に、次のどれに該当するかを決める。

1. macOS 全体に共通する設定
2. ユーザー環境に共通する設定
3. 特定ホストだけの設定
4. 特定ユーザーだけの設定
5. リポジトリ内の Neovim、Karabiner、AI エージェント設定

## 構成と責務

設定の合成は次の流れで行われる。

```text
flake.nix
└── nix/flakes/default.nix
    ├── nix/flakes/hosts.nix
    │   └── nix/lib/mk-darwin-system.nix
    │       └── nix/hosts/<host>/configuration.nix
    │           ├── nix/modules/darwin/
    │           └── nix/hosts/<host>/users/koutyuke/home.nix
    │               └── nix/modules/home/
    ├── nix/flakes/apps.nix
    └── nix/flakes/treefmt.nix
```

| 場所                           | 責務                                                    |
| ------------------------------ | ------------------------------------------------------- |
| `flake.nix`                    | Flake の入力、対応システム、モジュールの入口            |
| `flake.lock`                   | 入力の固定。タスクに更新が含まれない限り編集しない      |
| `nix/flakes/`                  | `darwinConfigurations`、更新用アプリ、フォーマット設定  |
| `nix/lib/mk-darwin-system.nix` | nix-darwin、Determinate Nix、Home Manager の共通 wiring |
| `nix/modules/darwin/`          | 全ホスト共通の macOS、Homebrew、システムパッケージ設定  |
| `nix/modules/home/`            | 全ホスト共通の Home Manager、シェル、CLI、dotfiles 設定 |
| `nix/hosts/koutyuke/`          | 個人用ホスト固有の設定                                  |
| `nix/hosts/cybozu/`            | 業務用ホスト固有の設定                                  |
| `nix/overlays/`                | nixpkgs の既存パッケージをやむを得ず補正する場所        |
| `nvim/`                        | Neovim の Lua 設定と `lazy-lock.json`                   |
| `karabiner/`                   | Karabiner の設定本体                                    |
| `agents/`                      | エージェント設定とローカル Skill                        |

ホスト名と主な差分は次のとおり。

| Flake target | 用途     | プロジェクトルート |
| ------------ | -------- | ------------------ |
| `.#koutyuke` | 個人環境 | `~/Developer`      |
| `.#cybozu`   | 業務環境 | `~/workspace`      |

## 設定の配置ルール

### macOS とシステム設定

- 全ホスト共通の設定は `nix/modules/darwin/` に置く。
- ホスト固有の設定は対象ホストの `configuration.nix` に置く。
- macOS の設定値は `nix/modules/darwin/system.nix`、Homebrew は `homebrew.nix`、システムパッケージは `packages.nix` を優先する。
- `nix-darwin` の Nix 設定は Determinate Nix が管理する。`nix.settings` ではなく `determinateNix.customSettings` を使う。

### Home Manager とユーザー設定

- 全ホスト共通のユーザー設定は `nix/modules/home/` に置く。
- ホスト固有のユーザーパッケージ、Git identity、プロジェクトルートは対象ホストの `users/koutyuke/home.nix` に置く。
- Home Manager に `programs.<tool>` モジュールがある場合はそれを使う。同じツールを `home.packages` に重複追加しない。
- 共通 CLI は `nix/modules/home/packages.nix`、プログラムごとの設定は `nix/modules/home/programs/` に置く。
- 新しい Home Manager モジュールを追加したら、対応する `default.nix` の `imports` に登録する。

### GUI アプリとパッケージ

- Homebrew Cask の GUI アプリは `homebrew.casks` に置く。
- Cask のバージョンは Flake で固定しない。GUI アプリの更新は Homebrew または `nix run .#update-gui` で行う。
- Mac App Store でしか扱えないアプリだけ `homebrew.masApps` に置く。
- CLI は nixpkgs を優先し、nixpkgs が適さない場合だけ Homebrew formula を検討する。
- 新しい依存関係を追加する前に、標準ライブラリ、既存依存、既存モジュールで解決できないか確認する。追加する場合は用途、代替案、影響範囲、lockfile 変更の有無を報告する。

### リポジトリ内の設定ファイル

- Neovim の設定は `nvim/` に置き、`nix/modules/home/programs/neovim/default.nix` が `~/.config/nvim` へリンクする。
- Neovim の activation は、既存の `~/.config/nvim` が実ディレクトリの場合に削除してからリンクする。反映前に必要な設定をリポジトリへ移すか、明示的に退避する。
- Karabiner の変更は `karabiner/karabiner.json` に置く。Home Manager の activation が `~/.config/karabiner` 全体をリポジトリへリンクする。
- Karabiner の activation は既存の実ディレクトリを削除せずエラーにする。手動で退避してから再実行する。
- `agents/skills/` の Skill は `nix/modules/home/programs/agent-skills.nix` から宣言的に配布される。Skill の追加・削除時は対象ディレクトリの `SKILL.md` と有効化条件を確認する。
- 設定ファイルに秘密情報、トークン、認証情報を追加しない。個人用の無視対象ファイルは `.koutyuke/` を使う。

## 変更と検証の手順

1. `git status --short` で作業ツリーを確認する。
2. 対象ホストと設定境界を決める。
3. 既存の import、option、package 配置を確認して最小限の変更を行う。
4. Nix を変更した場合はリポジトリルートで `nix fmt` を実行する。
5. 対象ホストをビルドして評価する。

```bash
nix build .#darwinConfigurations.koutyuke.system
nix build .#darwinConfigurations.cybozu.system
```

変更対象が一方のホストだけでも、共通モジュールや入力、overlay を変更した場合は影響するホストを両方確認する。ビルドで生成した `result` などの一時生成物は、今回作成したものに限って作業終了前に削除する。元からある生成物やユーザーのファイルは削除しない。

Nix 以外の変更では、対象に応じて次を行う。

- Neovim のプラグイン変更: `nvim --headless "+Lazy! sync" +qa`。生成された `nvim/lazy-lock.json` の差分を確認する。
- シェルスクリプト変更: `shellcheck` が利用できる場合は対象スクリプトを検査する。
- ドキュメント変更: リンク、パス、コマンド、コード例を実ファイルと照合し、`git diff --check` を実行する。

検証できない場合は、理由と残るリスクを最終報告に明記する。

## システムへ反映する操作

ビルドとシステム反映を混同しない。`darwin-rebuild switch` は外部状態を変更するため、ユーザーが反映を求めた場合だけ実行する。

```bash
darwin-rebuild switch --flake .#koutyuke
darwin-rebuild switch --flake .#cybozu
```

activation が要求する権限はその場で確認し、必要な場合だけ `sudo` を使う。

次のコマンドは更新、外部サービス変更、または世代削除を伴うため、確認や通常の検証には使わない。

```bash
nix run .#update       # flake input 更新、switch、nix-collect-garbage -d
nix run .#update-gui   # brew / Cask / MAS 更新、switch、GC
nix run .#update-ai    # llm-agents input 更新、switch、GC
```

Homebrew 自体はこのリポジトリでインストールしない。初回セットアップでは公式 Homebrew と Determinate Nix が必要で、Nix のバイナリキャッシュ設定は `docs/nix.custom.conf.bootstrap.tmpl` の手順に従う。

## ドキュメントとコミュニケーション

- ドキュメント、コメント、PR の説明は日本語で書く。コミットメッセージと PR タイトルは英語で書く。
- `README.md`、`AGENTS.md`、`docs/` を実質的に新規作成・更新する場合は `write-effective-docs` スキルを使う。
- 実装とドキュメントが食い違う場合は、現在の実装を正本として確認し、変更範囲内ならドキュメントも更新する。編集履歴や古い状態を本文に残さない。
- 読者が判断・行動・安全性を改善する情報だけを残し、コードから自明な内容や重複説明を増やさない。

## 完了条件

最終報告では、次を日本語で簡潔に示す。

- 変更したファイルと変更内容
- 実行した検証と結果
- 実行できなかった検証と理由
- 残るリスク、未確定事項、ユーザーが次に行う操作

テストやビルドが失敗した状態、または既存変更を壊した状態で完了扱いにしない。
