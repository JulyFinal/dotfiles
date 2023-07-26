local opt = vim.opt
local g = vim.g

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.title = true
opt.clipboard = "unnamedplus"
opt.cursorline = true

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = ""

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.mapleader = " "

-- disable some builtin vim plugins
local default_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(default_plugins) do
	g["loaded_" .. plugin] = 1
end

local default_providers = {
	"node",
	"python3",
}

for _, provider in ipairs(default_providers) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- utf8
g.encoding = "UTF-8"
opt.fileencoding = "utf-8"
-- jkhl 移动时光标周围保留8行
opt.scrolloff = 8
opt.sidescrolloff = 8
-- 显示左侧图标指示列
-- vim.wo.signcolumn = "yes"

-- 新行对齐当前行
opt.autoindent = true
opt.smartindent = true
-- 搜索不要高亮
opt.hlsearch = false
-- 边输入边搜索
opt.incsearch = true
-- 当文件被外部程序修改时，自动加载
opt.autoread = true
-- 禁止折行
opt.wrap = false
-- 允许隐藏被修改过的buffer
opt.hidden = true

-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false
-- split window 从下边和右边出现
opt.splitbelow = true
opt.splitright = true
-- 自动补全不自动选中
g.completeopt = "menuone,noselect"
-- 样式
opt.background = "dark"

-- 补全增强
opt.wildmenu = true
-- 补全最多显示10行
opt.pumheight = 10
-- 永远显示 tabline
opt.showtabline = 1
-- 使用增强状态栏插件后不再需要 vim 的模式提示
opt.showmode = false

-- nvim-tree-config
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
