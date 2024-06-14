return function()
	require("mason").setup()

	local lspconfig = require("lspconfig")

	local neodev = require("neodev")

	neodev.setup({
		library = {
			enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
			-- these settings will be used for your Neovim config directory
			runtime = true, -- runtime path
			types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
			plugins = true, -- installed opt or start plugins in packpath
			-- you can also specify the list of plugins to make available as a workspace library
			-- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
		},
		setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
		-- for your Neovim config directory, the config.library settings will be used as is
		-- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
		-- for any other directory, config.library.enabled will be set to false
		-- override = function(root_dir, options) end,
		-- With lspconfig, Neodev will automatically setup your lua-language-server
		-- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
		-- in your lsp start options
		lspconfig = true,
		-- much faster, but needs a recent built of lua-language-server
		-- needs lua-language-server >= 3.6.0
		pathStrict = true,
	})

	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		-- Mappings.
		local opts = { noremap = true, silent = true, buffer = bufnr }
		local vks = function(mode, keys, cmd)
			vim.keymap.set(mode, keys, cmd, opts)
		end

		vks("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
		vks("n", "K", ":lua vim.lsp.buf.hover()<CR>")

		vks("n", "gr", ":Telescope lsp_references<cr>")
		vks("n", "gd", ":Telescope lsp_definitions<cr>")
		vks("n", "gm", ":Telescope lsp_implementations<cr>")
		vks("n", "gt", ":Telescope lsp_type_definitions<cr>")

		vks("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>")
		vks("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>")
	end

	-- Set up lspconfig.
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities.textDocument.completion.completionItem = {
		documentationFormat = { "markdown", "plaintext", "python", "lua", "sh", "html", "json", "nix", "rust" },
		snippetSupport = true,
		preselectSupport = true,
		insertReplaceSupport = true,
		labelDetailsSupport = true,
		deprecatedSupport = true,
		commitCharactersSupport = true,
		tagSupport = { valueSet = { 1 } },
		resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		},
	}

	local servers = {
		["pyright"] = {
			python = {
				filetypes = { "python" },
				analysis = {
					-- Disable strict type checking
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					typeCheckingMode = "basic",
					useLibraryCodeForTypes = true,
				},
				single_file_support = true,
			},
		},
		["bashls"] = {
			filetypes = { "sh", "zsh" },
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

	for lsp, settings in pairs(servers) do
		lspconfig[lsp].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = settings,
		})
	end

	local sign = function(opts)
		vim.fn.sign_define(opts.name, {
			texthl = opts.name,
			text = opts.text,
			numhl = "",
		})
	end

	sign({ name = "DiagnosticSignError", text = "✘" })
	sign({ name = "DiagnosticSignWarn", text = "▲" })
	sign({ name = "DiagnosticSignHint", text = "⚑" })
	sign({ name = "DiagnosticSignInfo", text = "" })

	vim.diagnostic.config({
		underline = false,
		virtual_text = true,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})
end
