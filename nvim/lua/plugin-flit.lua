return function()
	local flit = require("flit")

	local leap = require("leap")

	leap.add_default_mappings()
	leap.opts.highlight_unlabeled_phase_one_targets = true
	leap.init_highlight(true)

	flit.setup({
		keys = { f = "f", F = "F", t = "t", T = "T" },
		labeled_modes = "v",
		multiline = true,
		opts = {},
	})
end
