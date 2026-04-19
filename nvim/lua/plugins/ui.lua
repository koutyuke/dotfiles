return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = {
          "",
          "    █  █  ███           █  █          ",
          "    ██ ██ ███          ██ ██         ",
          "    ███████ ████  ████  ███ ",
          "    ███████████████ ████████████ ",
          "    ███████████████████████████ ",
          "    ███████████████████████████  ",
          "    ███████████████████████████ ",
          "     ████████████████████████████",
          "",
        },
        center = {
          {
            icon = "  ",
            desc = "Find File",
            key = "f",
            keymap = "SPC f f",
            action = "Telescope find_files",
          },
          {
            icon = "  ",
            desc = "Live Grep",
            key = "g",
            keymap = "SPC f g",
            action = "Telescope live_grep",
          },
          {
            icon = "  ",
            desc = "File Explorer",
            key = "e",
            keymap = "SPC e",
            action = "Neotree filesystem toggle left",
          },
          {
            icon = "  ",
            desc = "Lazy",
            key = "l",
            keymap = ":Lazy",
            action = "Lazy",
          },
          {
            icon = "󰈆  ",
            desc = "Recent Files",
            key = "r",
            keymap = "SPC f b",
            action = "Telescope oldfiles",
          },
          {
            icon = "󰅚  ",
            desc = "Quit",
            key = "q",
            keymap = "SPC Q",
            action = "qa",
          },
        },
        footer = {
          "Catppuccin mocha + Neo-tree workspace",
        },
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")

          if vim.bo[buf].buftype == "terminal" then
            return {
              sources.terminal,
            }
          end

          return {
            sources.path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
        enable = function(buf, win, _)
          local ft = vim.bo[buf].filetype
          local bt = vim.bo[buf].buftype

          if bt == "nofile" or bt == "prompt" then
            return false
          end

          if vim.tbl_contains({ "dashboard", "lazy", "neo-tree" }, ft) then
            return false
          end

          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = false,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = {
          {
            "filetype",
            icon_only = false,
          },
          "encoding",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "neo-tree", "quickfix" },
    },
  },
}
