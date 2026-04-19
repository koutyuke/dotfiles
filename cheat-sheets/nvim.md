# Neovim Cheat Sheet

| Item | Value |
| --- | --- |
| `leader` key | `Space` |
| theme | `Catppuccin mocha` |
| file explorer | `neo-tree.nvim` |
| search | `telescope.nvim` |

## Start / Quit

| Command | Meaning |
| --- | --- |
| `nvim` | Neovim を起動 |
| `:q` | 現在の window を閉じる |
| `:qa` | すべて閉じる |
| `<leader>q` | 現在の window を閉じる |
| `<leader>Q` | すべて閉じる |
| `<leader>w` | 保存 |

## Basic Movement

| Command | Meaning |
| --- | --- |
| `h` `j` `k` `l` | 左 下 上 右 |
| `w` | 次の word の先頭へ |
| `b` | 前の word の先頭へ |
| `0` | 行頭へ |
| `$` | 行末へ |
| `gg` | ファイル先頭へ |
| `G` | ファイル末尾へ |
| `%` | 対応する括弧へ移動 |

## Insert / Edit

| Command | Meaning |
| --- | --- |
| `i` | cursor の前で insert |
| `a` | cursor の後で insert |
| `o` | 下に新しい行を作って insert |
| `O` | 上に新しい行を作って insert |
| `Esc` | normal mode に戻る |
| `u` | undo |
| `<C-r>` | redo |
| `yy` | 1 行 copy |
| `dd` | 1 行 cut |
| `p` | paste |

## Explorer

| Command | Meaning |
| --- | --- |
| `<leader>e` | 左 sidebar の `neo-tree` を toggle |
| `<leader>E` | 現在の file を `neo-tree` で reveal |

`neo-tree` を開いた状態でよく使うもの:

| Command | Meaning |
| --- | --- |
| `Enter` | file / directory を開く |
| `a` | file / directory を追加 |
| `d` | 削除 |
| `r` | rename |
| `y` | copy |
| `x` | cut |
| `p` | paste |
| `R` | refresh |
| `q` | 閉じる |

## Search

| Command | Meaning |
| --- | --- |
| `<leader>ff` | file search |
| `<leader>fg` | `live_grep` |
| `<leader>fb` | buffer 一覧 |
| `<leader>fh` | help tag search |

Telescope 内の基本操作:

| Command | Meaning |
| --- | --- |
| `<C-n>` | 下へ移動 |
| `<C-p>` | 上へ移動 |
| `Enter` | 開く |
| `Esc` | 閉じる |

## LSP

| Command | Meaning |
| --- | --- |
| `gd` | definition に移動 |
| `gr` | references を開く |
| `K` | hover を表示 |
| `<leader>ca` | code action |
| `<leader>cr` | rename |

## Format / Comment / Completion

| Command | Meaning |
| --- | --- |
| `<leader>f` | `conform.nvim` で format |
| `gcc` | current line を comment toggle |
| `gc` | visual selection を comment toggle |
| `<C-Space>` | completion を開く |
| `<C-n>` | completion の次候補 |
| `<C-p>` | completion の前候補 |
| `<CR>` | completion を確定 |

## UI Helpers

| Command / Item | Meaning |
| --- | --- |
| `<leader>;` | `dropbar.nvim` で breadcrumb から symbol を選ぶ |
| `dashboard-nvim` | 起動直後の dashboard |
| `lualine.nvim` | 下部 statusline |
| `nvim-scrollbar` | 右端 scrollbar に diagnostics / git diff を表示 |
| `nvim-treesitter-context` | 上部に current context を固定表示 |
| `hlchunk.nvim` | indent と current code block を見やすくする |

## Windows / Tabs

| Command | Meaning |
| --- | --- |
| `<C-w>v` | vertical split |
| `<C-w>s` | horizontal split |
| `<C-w>h` | 左の window へ |
| `<C-w>j` | 下の window へ |
| `<C-w>k` | 上の window へ |
| `<C-w>l` | 右の window へ |
| `:tabnew` | 新しい tab |
| `gt` | 次の tab |
| `gT` | 前の tab |

## Useful Commands

| Command | Meaning |
| --- | --- |
| `:Lazy` | plugin manager を開く |
| `:checkhealth` | health check |
| `:LspInfo` | LSP の attach 状況を確認 |
| `:ConformInfo` | formatter の状態を確認 |

## Troubleshooting

| Command | Meaning |
| --- | --- |
| `nvim --headless "+Lazy! sync" +qa` | plugin を lockfile ベースで同期 |
| `which nvim` | どの `nvim` が使われているか確認 |
| `ls -ld ~/.config/nvim` | repo の `nvim/` に symlink されているか確認 |

詳しい説明は [`docs/neovim-usage.md`](../docs/neovim-usage.md) を参照。
