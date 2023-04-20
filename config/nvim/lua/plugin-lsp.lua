return function()
	require("mason").setup()

	local lspconfig = require("lspconfig")

	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		-- Mappings.
		local opts = { noremap = true, silent = true, buffer = bufnr }
		local vks = function(mode, keys, cmd)
			vim.keymap.set(mode, keys, cmd, opts)
		end

    vks('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    vks('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    vks('n', 'gr', '<cmd>Telescope lsp_references<CR>')
    vks('n', 'gd', '<cmd>Telescope lsp_definitions<CR>')
    vks('n', 'gi', '<cmd>Telescope lsp_implementations<CR>')
    vks('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>')
    vks('n', '<leader>rn', vim.lsp.buf.rename)
    vks('n', '<leader>ca', vim.lsp.buf.code_action)

    vks('n', '[d', vim.diagnostic.goto_prev)
    vks('n', ']d', vim.diagnostic.goto_next)
    vks('n', '[e', vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }))
    vks('n', ']e', vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }))
	end

	-- Set up lspconfig.
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities.textDocument.completion.completionItem = {
		documentationFormat = { "markdown", "plaintext", "python", "lua", "sh" },
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
				analysis = {
					-- Disable strict type checking
					typeCheckingMode = "basic",
				},
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
