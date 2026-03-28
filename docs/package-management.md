# パッケージ管理ルール

## 構成の全体像

このdotfilesでは **nix-darwin / home-manager / brew-nix** の3つを組み合わせてパッケージを管理している。
管理の軸は「**スコープ（Host か User か）**」と「**インストール方法**」の2つである。

---

## スコープ：Host と User の使い分け

### 判断フロー

```text
1. 複数マシン（個人PC・仕事PC等）で共通して使うか？
   → Yes: modules/ に書く（共通モジュール）
   → No:  hosts/<hostname>/ に書く（ホスト固有）

2. システム全体（全ユーザー）への適用 または /Applications への配置・システム統合が必要か？
   → Yes: nix-darwin スコープ（darwin/）
   → No:  home-manager スコープ（home/）
```

### 具体的な判断基準

**hosts/ に書く（ホスト固有）の例:**

- 業務PCでのみ使うアプリ・ツール（`microsoft-teams`, `nordlayer`, `awscli2` 等）
- Git のユーザー名・メールアドレス・GPG 署名鍵などの個人情報
- ホスト名・ネットワーク設定

**modules/ に書く（共通）の例:**

- どのマシンでも必ず使う個人ツール（`fzf`, `ripgrep`, `ghq` 等）
- macOS 全般の設定（Dock, Finder, トラックパッド 等）
- フォント・タイムゾーン・セキュリティ設定

**darwin/ スコープ（nix-darwin）を使う条件:**

- `/Applications` への配置・システム統合が必要な GUI アプリ
- システム全体（全ユーザー）で使う CLI ツール

**home/ スコープ（home-manager）を使う条件:**

- 個人の CLI ツール・GUI アプリ
- CLI ツールの詳細設定（`programs.<tool>`）

---

## ファイル構成と役割

```text
modules/
  darwin/
    default.nix       imports をまとめるだけ
    homebrew.nix      homebrew.enable / taps / onActivation / casks / masApps
    packages.nix      environment.systemPackages（nixpkgs システムCLI）
    programs.nix      programs.<tool>（nix-darwin レベル）
    system.nix        macOS defaults, fonts, security, timezone

  home/
    default.nix       imports をまとめるだけ
    packages.nix      home.packages（nixpkgs CLI + brew-nix GUI）
    programs/
      default.nix     imports をまとめるだけ
      <tool>.nix      programs.<tool>（home-manager レベル）

hosts/
  <hostname>/
    configuration.nix   ホスト固有のシステム設定（ホスト名・ユーザー定義・ホスト固有 casks 等）
    users/
      <username>/
        home.nix        ユーザー固有の設定（個人情報・業務ツール）
```

---

## インストール方法とファイルの対応

| インストール方法            | Nix の書き方                          | ファイル                           |
| --------------------------- | ------------------------------------- | ---------------------------------- |
| nixpkgs（システム全体）     | `environment.systemPackages`          | `modules/darwin/packages.nix`      |
| nixpkgs（ユーザー共通）     | `home.packages = with pkgs`           | `modules/home/packages.nix`        |
| nixpkgs（ユーザー固有）     | `home.packages = with pkgs`           | `hosts/.../home.nix`               |
| brew-nix（ユーザー共通）    | `home.packages = with pkgs.brewCasks` | `modules/home/packages.nix`        |
| brew-nix（ユーザー固有）    | `home.packages = with pkgs.brewCasks` | `hosts/.../home.nix`               |
| Homebrew Cask（共通）       | `homebrew.casks`                      | `modules/darwin/homebrew.nix`      |
| Homebrew Cask（ホスト固有） | `homebrew.casks`                      | `hosts/.../configuration.nix`      |
| Mac App Store               | `homebrew.masApps`                    | `modules/darwin/homebrew.nix`      |
| Homebrew Formula            | `homebrew.brews`                      | `modules/darwin/homebrew.nix`      |
| Homebrew tap                | `homebrew.taps`                       | `modules/darwin/homebrew.nix`      |
| nix-darwin programs         | `programs.<tool>`                     | `modules/darwin/programs.nix`      |
| home-manager programs       | `programs.<tool>`                     | `modules/home/programs/<tool>.nix` |

---

## GUIアプリのインストール方法の選び方

**基本方針: brew-nix を優先し、システム統合が必要な場合に限り homebrew.casks を使う。**

### Step 1: brew-nix（pkgs.brewCasks）を試みる

以下をすべて満たす場合 → brew-nix を使う

- カスタム tap を必要としない
- brew-nix の展開に問題がない（ハッシュ不一致等がない）※回避策あり（後述）
- 以下のシステム統合を必要としない
  - ブラウザ（デフォルトブラウザ登録・URI スキーム）
  - カーネル拡張・システム機能拡張（VPN、キーボードリマッパー等）
  - 特権ヘルパー（バッテリー管理、システムモニタリング等）
  - ブラウザ拡張との連携（1Password 等）

brew-nix で入れると判断した場合、次は **Host か User か** を決める:

```text
全マシン共通？  → modules/home/packages.nix（home.packages = with pkgs.brewCasks）
このホスト固有？ → hosts/<hostname>/users/<username>/home.nix（home.packages = with pkgs.brewCasks）
```

### Step 2: homebrew.casks にフォールバック

以下のいずれかに該当する場合 → `homebrew.casks` を使う（`/Applications` に配置される）

| 該当ケース                         | 具体例                           |
| ---------------------------------- | -------------------------------- |
| ブラウザ（URI スキーム・拡張連携） | Arc, Chrome, Firefox             |
| カーネル拡張・システム機能拡張     | Karabiner Elements, OrbStack     |
| VPN クライアント                   | NordLayer, AWS VPN Client        |
| 特権ヘルパーが必要                 | AlDente, iStat Menus, CleanMyMac |
| カスタム tap が必要                | arto-app/tap/arto 等             |
| brew-nix で展開エラーが解決しない  | —                                |

`homebrew.casks` に入れると判断した場合、次は **Host か User か** を決める:

```text
全マシン共通？  → modules/darwin/homebrew.nix（homebrew.casks）
このホスト固有？ → hosts/<hostname>/configuration.nix（homebrew.casks）
```

### Step 3: homebrew.masApps にフォールバック

Homebrew Cask にも存在しない場合 → `homebrew.masApps` を使う

```text
modules/darwin/homebrew.nix または hosts/<hostname>/configuration.nix
```

### brew-nix でハッシュ不一致が起きる場合

`overrideAttrs` で回避できる。これが解決できない場合に限り homebrew.casks へ移行する。

```nix
(pkgs.brewCasks.example-app.overrideAttrs (oldAttrs: {
  src = pkgs.fetchurl {
    url = builtins.head oldAttrs.src.urls;
    hash = "sha256-...";
  };
}))
```

---

## CLIツールのインストール方法の選び方

### インストール + 設定を一緒に管理したい場合

`packages.nix` には書かず、`programs/<tool>.nix` を使う（後述）。

### パッケージのみインストールする場合

```text
1. nixpkgs にある？
   → Yes
     全マシン共通？  → modules/home/packages.nix（home.packages = with pkgs）
     このホスト固有？ → hosts/.../home.nix（home.packages = with pkgs）

2. nixpkgs にない & Homebrew Formula にある？
   → modules/darwin/homebrew.nix または hosts/.../configuration.nix（homebrew.brews）
```

---

## `programs/<tool>.nix` について

`programs.<tool>` はインストールと設定を兼ねるため、`packages.nix` には書かない。

**設定量の目安：**

- シンプル（5行程度）→ `programs/<tool>.nix`（単一ファイル）
- 複雑（`extraConfig` が長い等）→ `programs/<tool>/default.nix`（ディレクトリ化）

```nix
# NG: packages.nix に書いてはいけない
home.packages = with pkgs; [ fzf ];

# OK: programs/fzf.nix に書く
programs.fzf = {
  enable = true;
  enableZshIntegration = true;
};
```
