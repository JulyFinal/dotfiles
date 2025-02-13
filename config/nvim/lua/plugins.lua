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
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				config = {
					header = {
						"",
						"",
						"        ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀  ",
						"      ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷ ",
						"     ⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿ ",
						"    ⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿ ",
						"  ⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿ ",
						" ⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿ ",
						" ⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟ ",
						" ⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣ ",
						" ⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾ ",
						" ⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿ ",
						" ⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿ ",
						" ⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿ ",
						" ⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿ ",
						"  ⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋  ⣾⡌⢠⣿⡿⠃ ",
						" ⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉            ",
						"",
						"",
					},
					shortcut = {
						{ icon = "󰏕  ", desc = "Update", icon_hl = "@property", action = "Lazy update", key = "u" },
						{
							icon = "  ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
						{
							icon = "  ",
							desc = "Old Files",
							action = "Telescope oldfiles",
							key = "o",
						},
						{
							icon = "󰮗  ",
							desc = "Live Grep",
							action = "Telescope live_grep",
							key = "g",
						},
						{
							icon = "󰈆  ",
							desc = "Exit",
							action = "exit",
							key = "q",
						},
					},
					footer = {},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},

	-- chunk
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

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		event = "BufEnter",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>F", "<cmd>Telescope<cr>", desc = "find_files" },
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find_files" },
			{ "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "live_grep" },
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
		"kylechui/nvim-surround",
		event = "BufEnter",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPre",
		opts = {
			ensure_installed = { "lua", "python", "toml", "bash", "json" },
			sync_install = true,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				disable = {},
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
		},
		config = function(_, opts)
			for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
				config.install_info.url =
					config.install_info.url:gsub("https://github.com/", "https://ghproxy.net/https://github.com/")
			end
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "\\", ":Neotree float reveal<CR>", desc = "NeoTree reveal", silent = true },
		},
		config = function()
			require("neo-tree").setup({
				popup_border_style = "rounded",
				sources = { "filesystem", "buffers", "git_status", "document_symbols" },
				source_selector = {
					winbar = true,
					content_layout = "center",
					sources = {
						{ source = "filesystem" },
						{ source = "buffers" },
						{ source = "git_status" },
						{ source = "document_symbols" },
					},
				},
				filesystem = {
					check_gitignore_in_search = true, -- Check gitignore status for files/directories when searching.
					find_by_full_path_words = false,
					follow_current_file = {
						enabled = true,
					},
				},
				buffers = {
					leave_dirs_open = false,
					follow_current_file = {
						enabled = true,
					},
				},
				git_status = {},
			})
		end,
	},

	-- code format
	{
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>m",
				function()
					require("conform").format()
				end,
				desc = "format current file",
			},
		},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					javascript = { "deno" },
					rust = { "rustfmt" },
					bash = { "shfmt" },
					markdown = { "deno" },
					toml = { "taplo" },
					json = { "deno" },
					jsonc = { "deno" },
					nix = { "alejandra" },
					html = { "deno" },

					["_"] = { "trim_whitespace" },
				},
			})
		end,
	},

	-- comment
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
			require("bufferline").setup()
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
		event = "VimEnter",
		keys = { { "<leader>ft", "<cmd> TodoTelescope <cr>", desc = "TodoTelescope" } },
		config = function()
			require("todo-comments").setup()
		end,
	},

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
				},
			})
		end,
	},

	-- lsp dev
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		keys = {
			{ "<leader>p", ":LspStart<cr>", mode = { "n" } },

			{ "gr", ":Telescope lsp_references<cr>", mode = { "n" } },
			{ "gd", ":Telescope lsp_definitions<cr>", mode = { "n" } },
			{ "gm", ":Telescope lsp_implementations<cr>", mode = { "n" } },
			{ "gt", ":Telescope lsp_type_definitions<cr>", mode = { "n" } },

			{ "gD", ":lua vim.lsp.buf.declaration()<CR>", mode = { "n" } },
			{ "K", ":lua vim.lsp.buf.hover()<CR>", mode = { "n" } },
			{ "<leader>r", ":lua vim.lsp.buf.rename()<CR>", mode = { "n" } },
			{ "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", mode = { "n" } },
		},
		dependencies = {
			"saghen/blink.cmp",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			servers = {
				["ruff"] = {},
				["basedpyright"] = {
					basedpyright = {
						disableOrganizeImports = true,
						single_file_support = true,
					},
				},
				["lua_ls"] = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
				["nixd"] = {
					cmd = { "nixd" },
					settings = {
						nixd = {
							nixpkgs = {
								expr = "import <nixpkgs> { }",
							},
							formatting = {
								command = { "nixfmt" },
							},
							options = {
								nixos = {
									expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
								},
								home_manager = {
									expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
								},
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},

	-- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- complete
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = {
			"folke/lazydev.nvim",
			"rafamadriz/friendly-snippets",
			"mikavilpas/blink-ripgrep.nvim",
			"olimorris/codecompanion.nvim",
		},
		version = "v0.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<C-q>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				-- ["<Tab>"] = { "snippet_forward", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			---@module 'blink.cmp.config.appearance'
			---@type blink.cmp.Config
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			---@module 'blink.cmp.config.completion'
			---@type blink.cmp.Config
			completion = {
				menu = {
					border = "rounded",
				},
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = true },
			},

			---@module 'blink.cmp.config.sources'
			---@type blink.cmp.Config
			sources = {
				default = { "codecompanion", "lazydev", "ripgrep", "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = { fallbacks = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
					ripgrep = {
						name = "Ripgrep",
						module = "blink-ripgrep",
						opts = {
							prefix_min_len = 3,
							context_size = 5,
							max_filesize = "1M",
							additional_rg_options = {},
						},
					},
				},
			},

			---@module 'blink.cmp.config.signature'
			---@type blink.cmp.Config
			signature = { enabled = true, window = { border = "rounded" } },
		},
		opts_extend = { "sources.default" },
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					openai = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							schema = {
								model = { default = "Qwen/Qwen2.5-Coder-7B-Instruct" },
							},
							env = {
								url = "https://api.siliconflow.cn",
								api_key = "",
							},
						})
					end,
				},
				strategies = {
					chat = {
						adapter = "openai",
					},
					inline = {
						adapter = "openai",
					},
				},
			})
		end,
	},

	-- rust
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		ft = { "rust" },
	},

	-- diagnostic
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
}

local opts = {
	spec = plugins,
	defaults = { lazy = true },
	install = { colorscheme = { "tokyonight" } },
	change_detection = {
		notify = false,
	},
	git = {
		log = { "-10" }, -- show the last 10 commits
		timeout = 120, -- kill processes that take more than 2 minutes
		-- url_format = "https://github.com/%s.git",
		-- url_format = "git@github.com:%s",
		-- url_format = "https://hub.fastgit.xyz/%s",
		-- url_format = "https://mirror.ghproxy.com/https://github.com/%s",
		-- url_format = "https://github.moeyy.xyz/https://github.com/%s",
		url_format = "https://ghproxy.net/https://github.com/%s",
	},
}

require("lazy").setup(plugins, opts)
