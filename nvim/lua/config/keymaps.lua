local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>quitall<cr>", { desc = "Quit all" })
map(
  "n",
  "<leader>e",
  "<cmd>Neotree filesystem toggle left<cr>",
  { desc = "Toggle explorer" }
)
map(
  "n",
  "<leader>E",
  "<cmd>Neotree filesystem reveal left<cr>",
  { desc = "Reveal file in explorer" }
)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>;", function()
  require("dropbar.api").pick()
end, { desc = "Pick breadcrumbs" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
