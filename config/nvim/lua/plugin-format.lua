return function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			-- javascript = { { "prettierd", "prettier" } },
			bash = { "shfmt" },
			markdown = { "markdownlint" },
			html = { "htmlbeautifier" },
			json = { "jq" },
			nix = { "alejandra" },

			["_"] = { "codespell" },
			-- ["_"] = { "trim_whitespace" },
		},
		-- format_on_save = {
		--   -- These options will be passed to conform.format()
		--   timeout_ms = 500,
		--   lsp_fallback = true,
		-- },
	})
end
