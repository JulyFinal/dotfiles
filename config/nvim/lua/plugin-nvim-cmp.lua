return function()
	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local luasnip = require("luasnip")
	require("luasnip.loaders.from_vscode").lazy_load()

	local present, cmp = pcall(require, "cmp")
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")

	if not present then
		return
	end

	-- set hover style
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, cmp.config.window.bordered())

	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

	cmp.setup({
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		-- 指定 snippet 引擎
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},

		mapping = {
			["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},

		-- 来源
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
		}, {
			{ name = "buffer" },
			{ name = "path" },
		}),

		preselect = "item",
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
	})
end
