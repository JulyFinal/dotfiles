-- n, v, i, t = mode names

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap -- 复用 opt 参数
local opt = { noremap = true, silent = true }

-- ESC
map("i", "jk", "<ESC>", opt)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- windows 分屏快捷键
map("n", "<leader>v", ":vsp<CR>", opt)
map("n", "<leader>h", ":sp<CR>", opt)
-- 关闭当前
map("n", "<leader>x", ":bdelete!<CR>", opt)

-- Save file
map("n", "<C-s>", "<cmd> w <CR>", opt)
map("n", "<leader>w", "<cmd> w <CR>", opt)
-- update packer
map("n", "<leader>uu", "<cmd> Lazy <CR>", opt)

-- 比例控制
map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
map("n", "<C-Down>", ":resize +2<CR>", opt)
map("n", "<C-Up>", ":resize -2<CR>", opt)

-- Terminal相关
map("t", "<Esc>", [[ <C-\><C-n> ]], opt)

-- visual模式下缩进代码
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

-- 在visual 模式里粘贴不要复制
map("v", "p", '"_dP', opt)

-- 模拟emacs基本键位
map("i", "<C-a>", "<ESC>I", opt)
map("i", "<C-e>", "<ESC>A", opt)
map("i", "<C-n>", "<ESC>ja", opt)
map("i", "<C-p>", "<ESC>ka", opt)
map("i", "<C-f>", "<ESC>la", opt)
map("i", "<C-b>", "<ESC>ha", opt)

-- buffers
map("n", "gn", ":bn<CR>", opt)
map("n", "gnn", ":bp<CR>", opt)
