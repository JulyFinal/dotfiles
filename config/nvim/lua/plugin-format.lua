return function()
	local ft = require("guard.filetype")

	ft("lua"):fmt("stylua")
	ft("python"):fmt("black")
	ft("sh"):fmt("shfmt")

	require("guard").setup({
		-- the only options for the setup function
		fmt_on_save = true,
		-- Use lsp if no formatter was defined for this filetype
		lsp_as_default_formatter = false,
	})
end
