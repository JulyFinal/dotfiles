return function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			javascript = { "deno" },
			rust = { "rustfmt" },
			bash = { "shfmt" },
			markdown = { "deno" },
			toml = { "taplo" },
			json = { "deno" },
			jsonc = { "deno" },
			nix = { "alejandra" },
			html = { "deno" },

			["_"] = { "trim_whitespace" },
		},
	})
end
