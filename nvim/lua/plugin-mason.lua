return function()
	require("mason").setup()

	local mason_lspconfig = require("mason-lspconfig")
	local lspconfig = require("lspconfig")

	-- on_attach = function(client, bufnr)
	-- 	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	--
	-- 	client.server_capabilities.document_formatting = false
	-- 	client.server_capabilities.document_range_formatting = false
	-- end
	-- capabilities = require("cmp_nvim_lsp").default_capabilities()

	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		-- Mappings.
		local opts = { buffer = bufnr, noremap = true, silent = true }
		local vks = function(mode, keys, cmd)
			vim.keymap.set(mode, keys, cmd, opts)
		end
		vks("n", "ge", "<cmd>lua vim.lsp.buf.declaration<cr>")
		vks("n", "gd", "<cmd>lua vim.lsp.buf.definition<cr>")
		vks("n", "<leader>h", "<cmd>lua vim.lsp.buf.hover<cr>")
		vks("n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation<cr>")
		vks("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help<cr>")
		vks("n", "<leader>d", "<cmd>lua vim.lsp.buf.type_definition<cr>")
		vks("n", "<leader>R", "<cmd>lua vim.lsp.buf.rename<cr>")
		vks("n", "gr", "<cmd>lua vim.lsp.buf.references<cr>")
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

	mason_lspconfig.setup({
		ensure_installed = { "lua_ls", "pyright", "bashls" },
		automatic_installation = true,
	})

	mason_lspconfig.setup_handlers({
		function(server_name) -- Default handler (optional)
			require("lspconfig")[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				settings = {
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
			})
		end,
		["pyright"] = function()
			lspconfig.pyright.setup({
				settings = {
					python = {
						analysis = {
							-- Disable strict type checking
							typeCheckingMode = "off",
						},
					},
				},
			})
		end,
		["bashls"] = function()
			lspconfig.bashls.setup({})
		end,
	})

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
