return function()
	require("mason").setup()

	local lspconfig = require("lspconfig")

	local neodev = require("neodev")

	neodev.setup({
		library = {
			enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
			runtime = true, -- runtime path
			types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
			plugins = true, -- installed opt or start plugins in packpath
		},
		setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
		lspconfig = true,
		pathStrict = true,
	})

	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
		-- Mappings.
		local opts = { noremap = true, silent = true, buffer = bufnr }
		local vks = function(mode, keys, cmd)
			vim.keymap.set(mode, keys, cmd, opts)
		end

		if client.name == "ruff_lsp" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
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
		documentationFormat = { "markdown", "plaintext" },
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
		["ruff_lsp"] = {},
		["basedpyright"] = {
			basedpyright = {
				disableOrganizeImports = true,
				analysis = {
					typeCheckingMode = "basic",
					-- ignore = { "*" },
				},
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
end
