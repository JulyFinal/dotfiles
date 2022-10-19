local outline = require("symbols-outline")

local opts = {
  width = 20,
}

outline.setup({
  opts
})


local map = vim.api.nvim_set_keymap -- 复用 opt 参数
local opt = {noremap = true, silent = true }

map("n", "<leader>l", "<cmd>SymbolsOutline<CR>", opt)
