return function()
	local hop = require("hop")

	hop.setup({ keys = "etovxqpdygfblzhckisuran" })

	local directions = require("hop.hint").HintDirection

	vim.keymap.set("", "f", "<cmd>HopChar1CurrentLineAC<cr>", { remap = true })
	vim.keymap.set("", "F", "<cmd>HopChar1CurrentLineBC<cr>", { remap = true })
	vim.keymap.set("", "t", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
	end, { remap = true })
	vim.keymap.set("", "T", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
	end, { remap = true })

	vim.keymap.set("n", ";", "<cmd>HopChar2<cr>", { remap = true })
end
