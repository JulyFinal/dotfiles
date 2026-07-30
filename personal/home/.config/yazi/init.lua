require("bunny"):setup({
  hops = {
    { key = "h", path = "~/",               desc = "Home" },
    { key = "w", path = "~/ws",             desc = "workspaces" },
    { key = "c", path = "~/Documents",      desc = "Local Documents Dir" },
    { key = "d", path = "~/Downloads",      desc = "Local Downloads Dir" },
    { key = "m", path = "~/dotfiles",       desc = "dotfiles" },
    { key = "p", path = "~/Pictures",       desc = "Local Pictures" },
    { key = "u", path = "/run/media/final", desc = "U disk mount dir" },
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true,       -- Enable ephemeral hops, default is true
  tabs = true,            -- Enable tab hops, default is true
  notify = false,         -- Notify after hopping, default is false
  fuzzy_cmd = "fzf",      -- Fuzzy searching command, default is "fzf"
})
