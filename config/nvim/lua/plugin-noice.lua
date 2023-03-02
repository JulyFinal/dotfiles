return function()
	require("noice").setup({
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			format = {
				cmdline = { icon = ">" },
				search_down = { icon = "🔍⌄" },
				search_up = { icon = "🔍⌃" },
				filter = { icon = "$" },
				lua = { icon = "☾" },
				help = { icon = "?" },
			},
		},
		messages = { enabled = true },
		notify = {
			-- Noice can be used as `vim.notify` so you can route any notification like other messages
			-- Notification messages have their level and other properties set.
			-- event is always "notify" and kind can be any log level as a string
			-- The default routes will forward notifications to nvim-notify
			-- Benefit of using Noice for this is the routing and consistent history view
			enabled = true,
			view = "notify",
		},
	})
end
