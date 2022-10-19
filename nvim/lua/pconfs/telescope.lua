local builtin = require('telescope.builtin')

local map = vim.keymap.set -- 复用 opt 参数

map('n', 'ff', builtin.find_files, {})
map('n', 'fg', builtin.live_grep, {})
map('n', 'fb', builtin.buffers, {})
map('n', 'fh', builtin.help_tags, {})
