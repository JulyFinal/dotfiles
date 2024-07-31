return function()
	for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
		config.install_info.url =
			config.install_info.url:gsub("https://github.com/", "https://mirror.ghproxy.com/https://github.com/")
	end
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
