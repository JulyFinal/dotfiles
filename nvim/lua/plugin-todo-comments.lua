local tc = require("todo-comments")

tc.setup({})

local map = vim.keymap.set -- 复用 opt 参数

map('n', 'ft', "<cmd> TodoTelescope <cr>", {})
