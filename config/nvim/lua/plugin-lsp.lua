return function()
	local lspconfig = require("lspconfig")

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

		vks("n", "gr", ":Telescope lsp_references<cr>")
		vks("n", "gd", ":Telescope lsp_definitions<cr>")
		vks("n", "gm", ":Telescope lsp_implementations<cr>")
		vks("n", "gt", ":Telescope lsp_type_definitions<cr>")

		vks("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
		vks("n", "K", ":lua vim.lsp.buf.hover()<CR>")
		vks("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>")
		vks("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>")
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
end
