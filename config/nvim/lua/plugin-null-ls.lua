return function()
	local null_ls = require("null-ls")
	require("mason-null-ls").setup({
		ensure_installed = { "stylua", "black", "beautysh" },
		automatic_installation = true,
		automatic_setup = true, -- Recommended, but optional
    handlers = {
      function() end, -- disables automatic setup of all null-ls sources
      stylua = function(source_name, methods)
        null_ls.register(null_ls.builtins.formatting.stylua)
      end,
      black = function(source_name, methods)
        null_ls.register(null_ls.builtins.formatting.black)
      end,
      beautysh = function(source_name, methods)
        null_ls.register(null_ls.builtins.formatting.beautysh)
      end,
    },
	})

	-- will setup any installed and configured sources above
	null_ls.setup()

	-- when save , format code
	vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
end
