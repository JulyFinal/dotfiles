return function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			-- javascript = { { "prettierd", "prettier" } },
			rust = { "rustfmt" },
			bash = { "shfmt" },
			markdown = { "markdownlint" },
			toml = { "taplo" },
			html = { "htmlbeautifier" },
			json = { "jq" },
			nix = { "alejandra" },

			["_"] = { "trim_whitespace" },
		},
		-- format_on_save = {
		--   -- These options will be passed to conform.format()
		--   timeout_ms = 500,
		--   lsp_fallback = true,
		-- },
	})
end
