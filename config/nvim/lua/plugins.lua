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
						" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
						" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
						" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
						" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
						" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
						" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
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
							icon = "  ",
							desc = "New File",
							action = "DashboardNewFile",
							key = "n",
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

	--- 自动括号
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
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
		config = function()
			for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
				config.install_info.url = config.install_info.url:gsub(
					"https://github.com/",
					"https://mirror.ghproxy.com/https://github.com/"
				)
			end
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "python", "toml", "bash", "markdown", "json" },
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
			})
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
			-- { "<leader>e", ":Neotree float reveal<CR>", desc = "NeoTree [E]xplore" },
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
		config = require("plugin-lualine"),
	},

	-- lsp dev
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		keys = {
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
			"hrsh7th/cmp-nvim-lsp",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
				if client.name == "ruff_lsp" then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end

			local servers = {
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
			}

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for lsp, settings in pairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = settings,
				})
			end

			-- set diagnostic style and icon
			local x = vim.diagnostic.severity
			vim.diagnostic.config({
				virtual_text = { prefix = "" },
				signs = { text = { [x.ERROR] = "✘", [x.WARN] = "▲", [x.INFO] = "⚑", [x.HINT] = "" } },
				underline = true,
			})
		end,
	},

	-- complete
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

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },

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
