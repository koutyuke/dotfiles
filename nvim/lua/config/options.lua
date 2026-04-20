vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitbelow = true
opt.splitright = true
opt.title = true
opt.titlestring = "%{fnamemodify(getcwd(), ':t')} - neovim"
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.laststatus = 3
opt.showmode = false

vim.diagnostic.config({
  float = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    source = "if_many",
    spacing = 2,
    prefix = "●",
    virt_text_pos = "eol",
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
})
