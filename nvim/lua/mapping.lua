-- n, v, i, t = mode names

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap -- 复用 opt 参数
local opt = { noremap = true, silent = true }


-- ESC
map("i", "jk", "<ESC>", opt)
-- windows 分屏快捷键
map("n", "<leader>v", ":vsp<CR>", opt)
map("n", "<leader>h", ":sp<CR>", opt)
-- 关闭当前
map("n", "<leader>x", "<C-w>c", opt)

-- Save file
map("n", "<C-s>", "<cmd> w <CR>", opt)
-- exit
map("n", "<C-q>", "<cmd> wqall! <CR>", opt)
-- update packer
map("n", "<leader>uu", "<cmd> PackerSync <CR>", opt)

-- 比例控制
map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
map("n", "<C-Down>", ":resize +2<CR>", opt)
map("n", "<C-Up>", ":resize -2<CR>", opt)

-- Terminal相关
map("n", "<leader>tt", ":sp | terminal<CR>", opt)
map("n", "<leader>vt", ":vsp | terminal<CR>", opt)
map("t", "<Esc>", "<C-\\><C-n>", opt)
map("t", "<A-h>", [[ <C-\><C-N><C-w>h ]], opt)
map("t", "<A-j>", [[ <C-\><C-N><C-w>j ]], opt)
map("t", "<A-k>", [[ <C-\><C-N><C-w>k ]], opt)
map("t", "<A-l>", [[ <C-\><C-N><C-w>l ]], opt)

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

-- nvim-tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", opt)
map("n", "<leader>i", "gg=G", opt)


-- bufferline
map("n", "ge", ":BufferLineCycleNext<cr>", opt)
map("n", "gq", ":BufferLineCyclePrev<cr>", opt)


map("n", "<leader>1", '<cmd>lua require("bufferline").go_to_buffer(1, true)<cr>', opt)
map("n", "<leader>2", '<cmd>lua require("bufferline").go_to_buffer(2, true)<cr>', opt)
map("n", "<leader>3", '<cmd>lua require("bufferline").go_to_buffer(3, true)<cr>', opt)
map("n", "<leader>4", '<cmd>lua require("bufferline").go_to_buffer(4, true)<cr>', opt)
map("n", "<leader>5", '<cmd>lua require("bufferline").go_to_buffer(5, true)<cr>', opt)
map("n", "<leader>6", '<cmd>lua require("bufferline").go_to_buffer(6, true)<cr>', opt)
map("n", "<leader>7", '<cmd>lua require("bufferline").go_to_buffer(7, true)<cr>', opt)
map("n", "<leader>8", '<cmd>lua require("bufferline").go_to_buffer(8, true)<cr>', opt)
map("n", "<leader>9", '<cmd>lua require("bufferline").go_to_buffer(9, true)<cr>', opt)
map("n", "<leader>$", '<cmd>lua require("bufferline").go_to_buffer(-1, true)<cr>', opt)
