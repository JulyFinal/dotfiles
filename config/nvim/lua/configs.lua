-- mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- mouse mode
vim.opt.mouse = "a"

-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

vim.opt.clipboard = "unnamedplus"

-- Numbers
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.ruler = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.fillchars = { eob = " " }

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 200

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
-- vim.opt.title = true

-- -- fold
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
--
-- -- disable nvim intro
-- vim.opt.shortmess:append("sI")

vim.opt.termguicolors = true
--
-- -- go to previous/next line with h,l,left arrow and right arrow
-- -- when cursor reaches end/beginning of line
-- vim.opt.whichwrap:append("<>[]hl")
--
-- utf8
vim.g.encoding = "UTF-8"
vim.opt.fileencoding = "utf-8"
vim.opt.sidescrolloff = 10
--
-- -- 新行对齐当前行
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
-- 搜索不要高亮
vim.opt.hlsearch = false
-- 边输入边搜索
vim.opt.incsearch = true
-- 当文件被外部程序修改时，自动加载
vim.opt.autoread = true
-- -- 禁止折行
-- vim.opt.wrap = false
-- -- 允许隐藏被修改过的buffer
-- vim.opt.hidden = true
--
-- 禁止创建备份文件
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- split window 从下边和右边出现
vim.opt.splitbelow = true
vim.opt.splitright = true

-- -- 补全增强
-- vim.opt.wildmenu = true
-- -- 补全最多显示10行
-- vim.opt.pumheight = 10
-- -- 永远显示 tabline
-- vim.opt.showtabline = 1

vim.diagnostic.config({
	virtual_text = { prefix = "" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.INFO] = "⚑",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	underline = true,
})
