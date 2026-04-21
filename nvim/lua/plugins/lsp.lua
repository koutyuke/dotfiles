return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        css = { "oxfmt" },
        html = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "oxfmt" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        lua = { "stylua" },
        markdown = { "oxfmt" },
        nix = { "nixfmt" },
        scss = { "oxfmt" },
        sh = { "shfmt" },
        toml = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        yaml = { "oxfmt" },
        zsh = { "shfmt" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_lsp.default_capabilities()
      local tsdk = vim.env.NVIM_TSDK ~= "" and vim.env.NVIM_TSDK or nil

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      vim.lsp.config("nixd", {
        capabilities = capabilities,
      })
      vim.lsp.enable("nixd")

      vim.lsp.config("bashls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("bashls")

      vim.lsp.config("jsonls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("jsonls")

      vim.lsp.config("yamlls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("yamlls")

      vim.lsp.config("taplo", {
        capabilities = capabilities,
      })
      vim.lsp.enable("taplo")

      vim.lsp.config("marksman", {
        capabilities = capabilities,
      })
      vim.lsp.enable("marksman")

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("ts_ls")

      -- vim.lsp.config("astro", {
      --   capabilities = capabilities,
      --   init_options = {
      --     typescript = tsdk and { tsdk = tsdk } or {},
      --   },
      -- })
      -- vim.lsp.enable("astro")
    end,
  },
}
