local toggleterm = require("toggleterm")

toggleterm.setup({
  open_mapping = [[<c-\>]],
  direction = 'float',
})

local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  hidden = true,
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
