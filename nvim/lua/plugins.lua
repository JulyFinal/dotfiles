-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {
	"nvim-lua/plenary.nvim",

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	"nvim-treesitter/nvim-treesitter",
	"kyazdani42/nvim-web-devicons",
	"kyazdani42/nvim-tree.lua",

	-- nvim-cmp
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",

	-- cmp configs
	"onsails/lspkind-nvim",

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	"shaunsingh/moonlight.nvim",

	{ "akinsho/bufferline.nvim", version = "v3.*" },
	-- outline
	"simrat39/symbols-outline.nvim",
	-- easymotion
	{ "phaazon/hop.nvim", branch = "v2" },
	-- todo
	"folke/todo-comments.nvim",

	-- line
	{
		"NTBBloodbath/galaxyline.nvim",
		config = function()
			require("galaxyline.themes.eviline")
		end,
	},
	-- terminal
	"akinsho/toggleterm.nvim",
}

require("lazy").setup(plugins)
