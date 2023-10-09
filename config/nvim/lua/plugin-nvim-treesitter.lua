return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "python", "toml", "bash", "html", "css", "markdown", "json", "nix" },
		sync_install = true,
		auto_install = true,
		ignore_install = {},
		highlight = {
			enable = true,
			disable = {},
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
	})
end
