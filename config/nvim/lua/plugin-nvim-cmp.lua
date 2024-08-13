return function()
	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local luasnip = require("luasnip")

	local present, cmp = pcall(require, "cmp")
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")

	if not present then
		return
	end

	-- require("luasnip.loaders.from_snipmate").lazy_load()
	-- set python 智能选择
	local compare = require("cmp.config.compare")
	compare.python_var = function(entry1, entry2)
		if vim.o.filetype ~= "python" then
			return
		end
		-- needed because cmp sometimes gives you the same entry and you must return nil in that case
		if entry1:get_completion_item().label == entry2:get_completion_item().label then
			return
		end
		if entry1:get_completion_item().label:match("%w*=") then
			-- return true to pick entry1 over entry2
			return true
		end
	end

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

		formatting = {
			-- changing the order of fields so the icon is the first
			fields = { "menu", "abbr", "kind" },

			-- here is where the change happens
			format = function(entry, item)
				local menu_icon = {
					nvim_lsp = "λ",
					luasnip = "⋗",
					buffer = "Ω",
					path = "🖫",
					nvim_lua = "Π",
				}

				item.menu = menu_icon[entry.source.name]
				return item
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

		sorting = {
			comparators = compare,
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
