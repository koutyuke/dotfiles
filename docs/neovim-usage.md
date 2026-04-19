# Neovim の使い方

このドキュメントは、この dotfiles に導入した Neovim 構成の使い方を日本語でまとめたものです。

設計方針は次の 4 点です。

- Neovim 本体と editor 専用ツールは Nix で管理する
- 設定本体は repo 直下の `nvim/` に Lua で置く
- plugin は `lazy.nvim` で管理する
- LSP / formatter は `mason.nvim` ではなく Nix で入れる

導入方針そのものは
[`docs/introduce-nvim-for-dotfiles.md`](./introduce-nvim-for-dotfiles.md)
を参照してください。ここでは、導入後の普段の使い方に絞って説明します。

## どこに何があるか

この構成では、役割を次のように分けています。

- [`nix/modules/home/programs/neovim/default.nix`](../nix/modules/home/programs/neovim/default.nix)
  - Neovim 本体のインストール
  - `~/.config/nvim` への symlink
  - Neovim の中だけで使う LSP / formatter の配布
- [`nvim/init.lua`](../nvim/init.lua)
  - エントリポイント
- [`nvim/lua/config/`](../nvim/lua/config/init.lua)
  - option, keymap, lazy.nvim の初期化
- [`nvim/lua/plugins/`](../nvim/lua/plugins)
  - plugin ごとの設定
- [`nvim/lazy-lock.json`](../nvim/lazy-lock.json)
  - plugin バージョンの lockfile

つまり、

- Nix は「配るもの」
- Lua は「動かし方」
- `lazy-lock.json` は「plugin の固定」

を担当しています。

## 初回セットアップ後にやること

Neovim を初めて起動したあと、plugin を lockfile ベースで揃えたいときは次を実行します。

```bash
nvim --headless "+Lazy! sync" +qa
```

または Neovim の中で次を実行してもかまいません。

```vim
:Lazy sync
```

今の構成では、plugin restore を `darwin-rebuild switch` の成功条件にしていません。
理由は、plugin ダウンロード失敗で system switch 全体まで巻き添えにしたくないからです。

## 基本のキー操作

leader key は `Space` です。

よく使うものだけ覚えれば十分です。

- `<leader>w`
  - 保存
- `<leader>q`
  - 現在の window を閉じる
- `<leader>Q`
  - すべて閉じる
- `<leader>E`
  - `neo-tree.nvim` の左 sidebar を toggle
- `<leader>e`
  - 現在の file を `neo-tree.nvim` で reveal
- `<leader>ff`
  - file search
- `<leader>fg`
  - `live_grep`
- `<leader>fb`
  - buffer 一覧
- `<leader>fh`
  - help tag search
- `<leader>;`
  - `dropbar.nvim` で breadcrumb から symbol を選ぶ
- `gd`
  - definition に移動
- `gr`
  - references を開く
- `K`
  - hover を表示
- `<leader>ca`
  - code action
- `<leader>cr`
  - rename
- `<leader>f`
  - format

## 今入れているおすすめ設定

最初から重すぎる構成にはしていません。まずは、日常利用で効くものだけを入れています。

### UI と編集

- `catppuccin`
  - `mocha` flavour を使った dark theme
- `which-key.nvim`
  - leader key 中心の discoverability を担当
- `mini.pairs`
  - 括弧や quote の自動補完
- `Comment.nvim`
  - コメント操作
- `hlchunk.nvim`
  - indent line と current chunk の視認性を上げる
- `nvim-treesitter-context`
  - 現在位置の context を上に固定表示する
- `dropbar.nvim`
  - winbar に breadcrumb を出す
- `lualine.nvim`
  - statusline を整理する
- `nvim-scrollbar`
  - diagnostics と git 差分が乗る scrollbar を表示する
- `dashboard-nvim`
  - 起動時の start screen

### ファイル操作と検索

- `neo-tree.nvim`
  - VSCode に近い左 sidebar 型の file explorer
- `telescope.nvim`
  - file search, grep, buffer 切り替えの中心

### Git

- `gitsigns.nvim`
  - 差分表示
  - current line blame

### LSP / completion / format

- `nvim-lspconfig`
  - LSP 接続
- `nvim-cmp`
  - completion
- `LuaSnip`
  - snippet 展開
- `conform.nvim`
  - format 実行

### Syntax

- `nvim-treesitter`
  - syntax highlight
  - indent
  - parser 管理の土台

## Nix で管理しているツール

この構成では `mason.nvim` を使っていません。
LSP / formatter は Nix 側で入れています。

現時点では次のものを Neovim module で配布しています。

- `lua-language-server`
- `nixd`
- `shellcheck`
- `shfmt`
- `stylua`

意図は明確です。

- `mason.nvim` のように `~/.local/share/nvim` 配下に外部 binary を増やさない
- machine 間で揃いやすくする
- Neovim の設定と外部ツールの責務を分ける

もし今後追加するなら、次のルールで判断してください。

- Neovim の中でだけ使うもの
  - `programs.neovim.extraPackages`
- shell や CI でも使うもの
  - [`nix/modules/home/packages.nix`](../nix/modules/home/packages.nix)

## よくある作業

### plugin を追加したい

`nvim/lua/plugins/` に新しい Lua ファイルを追加します。

例:

```lua
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },
}
```

追加後に次を実行します。

```bash
nvim --headless "+Lazy! sync" +qa
```

その結果 `lazy-lock.json` が更新されたら、一緒に commit します。

### keymap を変えたい

[`nvim/lua/config/keymaps.lua`](../nvim/lua/config/keymaps.lua)
を編集します。

### option を変えたい

[`nvim/lua/config/options.lua`](../nvim/lua/config/options.lua)
を編集します。

### colorscheme を変えたい

[`nvim/lua/plugins/colorscheme.lua`](../nvim/lua/plugins/colorscheme.lua)
を編集します。

### LSP を追加したい

やることは 2 つあります。

1. Nix 側で binary を入れる
2. Lua 側で `lspconfig` を設定する

たとえば `yaml-language-server` を追加したいなら、
[`nix/modules/home/programs/neovim/default.nix`](../nix/modules/home/programs/neovim/default.nix)
の `extraPackages` に追加し、
[`nvim/lua/plugins/lsp.lua`](../nvim/lua/plugins/lsp.lua)
で `yamlls` を設定します。

Lua 側だけ足しても binary がなければ動きません。
逆に Nix 側だけ足しても LSP の設定がなければ attach しません。

## トラブルシュート

### `nvim` が見つからない

まず次を確認します。

```bash
which nvim
```

darwin configuration がまだ適用されていない場合は、switch が必要です。

### `~/.config/nvim` が repo を指していない

次を確認します。

```bash
ls -ld ~/.config/nvim
```

期待する状態は、この repo の `nvim/` への symlink です。

### plugin が入らない

次を確認します。

```vim
:Lazy
:checkhealth
```

ネットワークや GitHub 側の一時エラーでも失敗します。
その場合は `:Lazy sync` を再実行してください。

### LSP が attach しない

次を確認します。

- binary が Nix 側に入っているか
- `nvim/lua/plugins/lsp.lua` に設定があるか
- `:checkhealth lsp` にエラーが出ていないか

## この構成で意図的にやっていないこと

今は次のことをわざとやっていません。

- `mason.nvim` の採用
- plugin restore の activation hook 自動化
- 大量 plugin の一括導入
- Tree-sitter grammar の Nix prebuild

理由は、最初の導入で複雑さを持ち込みすぎないためです。
必要になった時点で追加すれば十分です。

## 更新フロー

普段の更新はだいたいこの順で進めれば大丈夫です。

1. Lua config か Nix config を編集する
2. 必要なら `nvim --headless "+Lazy! sync" +qa` を実行する
3. `nix fmt` を実行する
4. `nix build .#darwinConfigurations.koutyuke.system` を実行する
5. 問題なければ switch する

Neovim 設定の変更だけでも、最終的には build が通ることを確認した方が安全です。
