return function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format" }
				else
					return { "isort", "black" }
				end
			end,
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
