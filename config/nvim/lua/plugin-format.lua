return function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			rust = { "rustfmt" },
			bash = { "shfmt" },
			markdown = { "prettierd" },
			toml = { "taplo" },
			html = { "prettierd", "prettier", stop_after_first = true },
			json = { "jq" },
			nix = { "alejandra" },

			["_"] = { "trim_whitespace" },
		},
	})
end
