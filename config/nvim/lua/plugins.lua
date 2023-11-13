local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
local plugins = {
	-- theme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufEnter",
		main = "ibl",
		config = function()
			require("ibl").setup({
				scope = {
					enabled = true,
					show_start = false,
					show_end = false,
					include = {
						node_type = { ["*"] = { "*" } },
					},
				},
			})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "BufEnter",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{ "nvim-treesitter/nvim-treesitter", config = require("plugin-nvim-treesitter") },

	{
		"kyazdani42/nvim-tree.lua",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" } },
		config = require("plugin-nvim-tree"),
	},

	{
		"neovim/nvim-lspconfig",
		-- lazy = false,
		-- priority = 2000,
		event = "BufEnter",
		dependencies = {
			"williamboman/mason.nvim",
			"folke/neodev.nvim",
		},
		config = require("plugin-lsp"),
	},

	{ "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" }, config = require("plugin-format") },

	{
		"L3MON4D3/LuaSnip",
		version = "2.*",
	},
	-- cmp configs
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"onsails/lspkind-nvim",

			-- For luasnip users.
			"L3MON4D3/LuaSnip", -- { name = 'luasnip' }

			-- "hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
			"hrsh7th/cmp-buffer", -- { name = 'buffer' }
			"hrsh7th/cmp-path", -- { name = 'path' }
			"hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
		},
		config = require("plugin-nvim-cmp"),
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		config = require("plugin-gitsigns"),
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find_files" },
			{ "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "live_grep" },
			{ "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "buffers" },
			{ "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "help_tags" },
			{ "<leader>fe", "<cmd>lua require('telescope.builtin').keymaps()<cr>", desc = "keymappings" },
		},
	},

	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"akinsho/bufferline.nvim",
		version = "v3.*",
		event = "BufEnter",
		config = require("plugin-bufferline"),
	},
	-- outline
	{
		"simrat39/symbols-outline.nvim",
		keys = { { "<leader>l", "<cmd>SymbolsOutline<CR>", desc = "SymbolsOutline" } },
		opts = { width = 20, autofold_depth = 0 },
	},

	-- easymotion
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			label = {
				rainbow = {
					enabled = true,
				},
			},
			modes = {
				char = { enabled = false },
			},
		},
		keys = {
			{
				"B",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"gl",
				mode = { "n", "o", "x" },
				function()
					require("flash").jump({
						search = { mode = "search", max_length = 0 },
						label = { after = { 0, 0 } },
						pattern = "^",
					})
				end,
				desc = "Jump to a line",
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- todo
	{
		"folke/todo-comments.nvim",
		event = "BufReadPre",
		keys = { { "<leader>ft", "<cmd> TodoTelescope <cr>", desc = "TodoTelescope" } },
		config = function()
			require("todo-comments").setup()
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",

		-- lazy = false,
		-- priority = 1000,
		event = "BufEnter",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = require("plugin-lualine"),
	},
}

local opts = {
	defaults = { lazy = true },
	install = { colorscheme = { "tokyonight-moon" } },
	-- checker = { enabled = true },
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	git = {
		log = { "-10" }, -- show the last 10 commits
		timeout = 120, -- kill processes that take more than 2 minutes
		-- url_format = "https://github.com/%s.git",
		url_format = "git@github.com:%s",
		-- url_format = "https://hub.fastgit.xyz/%s",
		-- url_format = "https://ghproxy.com/https://github.com/%s",
	},
}

require("lazy").setup(plugins, opts)
