-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local lazyrepo = "https://github.moeyy.xyz/https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
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
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	{
		"shellRaining/hlchunk.nvim",
		event = { "UIEnter" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true,
				},
				indent = {
					enable = true,
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
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		priority = 500,
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},

		keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neotree" } },
		config = function()
			require("neo-tree").setup({
				filesystem = {
					follow_current_file = {
						enabled = true,
					},
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		-- lazy = false,
		-- priority = 2000,
		event = "BufEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
		},
		config = require("plugin-lsp"),
	},

	{ "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" }, config = require("plugin-format") },

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"onsails/lspkind.nvim",

			"hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
			"hrsh7th/cmp-buffer", -- { name = 'buffer' }
			"hrsh7th/cmp-path", -- { name = 'path' }
			"hrsh7th/cmp-cmdline", -- { name = 'cmdline' }

			-- for luasnip
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			"saadparwaiz1/cmp_luasnip",
		},

		config = require("plugin-nvim-cmp"),
	},

	-- rust
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		ft = { "rust" },
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "BufEnter",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>F", "<cmd>Telescope<cr>", desc = "find_files" },
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find_files" },
			{ "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "live_grep" },
			{ "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "buffers" },
			{ "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "help_tags" },
			{ "<leader>fe", "<cmd>lua require('telescope.builtin').keymaps()<cr>", desc = "keymappings" },
			{
				"<leader>s",
				"<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
				desc = "search symbols",
			},
			{
				"<leader>fs",
				"<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>",
				desc = "search all symbols",
			},
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
		version = "*",
		event = "BufEnter",
		config = function()
			require("bufferline").setup({
				options = {
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							text_align = "left",
						},
					},
				},
			})
		end,
	},

	-- easymotion
	{
		"folke/flash.nvim",
		event = "VeryLazy",
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
			{
				";",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
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

	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		config = require("plugin-lualine"),
	},
}

local opts = {
	spec = plugins,
	defaults = { lazy = true },
	install = { colorscheme = { "tokyonight" } },
	-- checker = { enabled = true },
	change_detection = {
		notify = false,
	},
	git = {
		log = { "-10" }, -- show the last 10 commits
		timeout = 120, -- kill processes that take more than 2 minutes
		-- url_format = "https://github.com/%s.git",
		url_format = "git@github.com:%s",
		-- url_format = "https://hub.fastgit.xyz/%s",
		-- url_format = "https://mirror.ghproxy.com/https://github.com/%s",
		-- url_format = "https://github.moeyy.xyz/https://github.com/%s",
	},
}

require("lazy").setup(plugins, opts)
