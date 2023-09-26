return function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "black" },
			-- Use a sub-list to run only the first available formatter
			-- javascript = { { "prettierd", "prettier" } },
			bash = { "shfmt" },
			markdown = { "markdownlint" },
			html = { "htmlbeautifier" },
			json = { "jq" },
			["*"] = { "codespell" },
		},
		-- format_on_save = {
		--   -- These options will be passed to conform.format()
		--   timeout_ms = 500,
		--   lsp_fallback = true,
		-- },
	})
end
