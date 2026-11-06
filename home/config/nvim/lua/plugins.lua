-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
local lazy_module = lazypath .. "/lua/lazy/init.lua"

if not uv.fs_stat(lazy_module) then
  local partial = uv.fs_lstat(lazypath)
  if partial then
    if partial.type ~= "directory" then
      error("Cannot install lazy.nvim: " .. lazypath .. " exists and is not a directory")
    end
    -- A cancelled clone can leave a .git-only directory behind. It is a
    -- rebuildable dependency cache, so remove the incomplete checkout first.
    vim.fn.delete(lazypath, "rf")
  end

  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  -- local lazyrepo = "https://github.moeyy.xyz/https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 or not uv.fs_stat(lazy_module) then
    vim.fn.delete(lazypath, "rf")
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

local dashboard_header = table.concat({
  "",
  "",
  "        ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀  ",
  "      ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷ ",
  "     ⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿ ",
  "    ⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿ ",
  "  ⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿ ",
  " ⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿ ",
  " ⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟ ",
  " ⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣ ",
  " ⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾ ",
  " ⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿ ",
  " ⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿ ",
  " ⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿ ",
  " ⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿ ",
  "  ⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋  ⣾⡌⢠⣿⡿⠃ ",
  " ⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉            ",
  "",
  "",
}, "\n")

-- install plugins
local plugins = {
  -- theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      style = "night",
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      picker = { enabled = true },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      dashboard = {
        enabled = true,
        preset = {
          header = dashboard_header,
          keys = {
            { icon = "󰏕 ", key = "u", desc = "Update", action = ":Lazy update" },
            { icon = " ", key = "f", desc = "Files", action = function() Snacks.picker.files() end },
            { icon = " ", key = "o", desc = "Old Files", action = function() Snacks.picker.recent() end },
            { icon = "󰮗 ", key = "g", desc = "Live Grep", action = function() Snacks.picker.grep() end },
            { icon = "󰈆 ", key = "q", desc = "Exit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      { "<leader>F", function() Snacks.picker() end, desc = "Pickers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      { "<leader>fe", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>s", function() Snacks.picker.lsp_symbols() end, desc = "Search symbols" },
      { "<leader>fs", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Search all symbols" },
      { "\\", function() Snacks.explorer.reveal() end, desc = "Explorer reveal" },
    },
  },

  -- chunk
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      -- The former master branch installed parsers inside the plugin checkout.
      -- On main they live under stdpath("data")/site; remove the legacy
      -- directory so stale binaries cannot shadow Neovim's bundled parsers.
      local legacy_parser_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"
      if vim.uv.fs_stat(legacy_parser_dir) then
        vim.fn.delete(legacy_parser_dir, "rf")
      end
      treesitter.setup({})
      treesitter.install({ "lua", "python", "toml", "bash", "json" })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- code format
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>m",
        function()
          require("conform").format()
        end,
        desc = "format current file",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format" },
          javascript = { "deno_fmt" },
          rust = { "rustfmt" },
          bash = { "shfmt" },
          markdown = { "deno_fmt" },
          toml = { "taplo" },
          json = { "deno_fmt" },
          jsonc = { "deno_fmt" },
          html = { "deno_fmt" },

          ["_"] = { "trim_whitespace" },
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("bufferline").setup()
    end,
  },

  -- easymotion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      label = {
        rainbow = {
          enabled = true,
        },
      },
      modes = {
        char = { enabled = false },
      },
    },
    keys = {
      {
        "B",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "gl",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
          })
        end,
        desc = "Jump to a line",
      },
      {
        ";",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- todo
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    keys = {
      { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo comments" },
    },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  },

  -- lua
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- complete
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
    },
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "default" },

      ---@module 'blink.cmp.config.appearance'
      ---@type blink.cmp.Config
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      cmdline = { completion = { ghost_text = { enabled = true } } },

      ---@module 'blink.cmp.config.completion'
      ---@type blink.cmp.Config
      completion = {
        menu = {
          border = "rounded",
        },
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true },
      },

      ---@module 'blink.cmp.config.sources'
      ---@type blink.cmp.Config
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          ripgrep = {
            name = "Ripgrep",
            module = "blink-ripgrep",
            opts = {
              prefix_min_len = 3,
              context_size = 5,
              max_filesize = "1M",
              additional_rg_options = {},
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },

      ---@module 'blink.cmp.config.signature'
      ---@type blink.cmp.Config
      signature = { enabled = true, window = { border = "rounded" } },
    },
    opts_extend = { "sources.default" },
  },

}

local opts = {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
  rocks = { enabled = false },
  change_detection = {
    notify = false,
  },
  git = {
    log = { "-10" }, -- show the last 10 commits
    timeout = 120,   -- kill processes that take more than 2 minutes
    -- url_format = "https://github.com/%s.git",
    -- url_format = "git@github.com:%s",
    -- url_format = "https://hub.fastgit.xyz/%s",
    -- url_format = "https://mirror.ghproxy.com/https://github.com/%s",
    -- url_format = "https://github.moeyy.xyz/https://github.com/%s",
    -- url_format = "https://ghproxy.net/https://github.com/%s",
  },
}
require("lazy").setup(plugins, opts)

local lsp_servers = {
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", ".git" },
  },

  ty = {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "ty.toml", "pyproject.toml" },
  },

  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", "lazy-lock.json" },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
      },
    },
  },
}

for server, config in pairs(lsp_servers) do
  config.capabilities = require("blink.cmp").get_lsp_capabilities()
  vim.lsp.config[server] = config
  vim.lsp.enable(server)
end

local lsp_group = vim.api.nvim_create_augroup("user_lsp_config", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if vim.bo[args.buf].filetype == "lua" then
      -- Format the current buffer on save.
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = lsp_group,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})
