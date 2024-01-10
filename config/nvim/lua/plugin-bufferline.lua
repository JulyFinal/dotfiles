return function()
	local setup_opts = {
		options = {
			-- close_command = "bdelete! %d",
			-- right_mouse_command = "bdelete! %d",
			diagnostics = "nvim_lsp",
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	}
	require("bufferline").setup(setup_opts)
end
