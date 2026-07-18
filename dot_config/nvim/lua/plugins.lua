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
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        config = {
          header = {
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
          },
          shortcut = {
            { icon = "󰏕  ", desc = "Update", icon_hl = "@property", action = "Lazy update", key = "u" },
            {
              icon = "  ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              icon = "  ",
              desc = "Old Files",
              action = "Telescope oldfiles",
              key = "o",
            },
            {
              icon = "󰮗  ",
              desc = "Live Grep",
              action = "Telescope live_grep",
              key = "g",
            },
            {
              icon = "󰈆  ",
              desc = "Exit",
              action = "exit",
              key = "q",
            },
          },
          footer = {},
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
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

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>F",  "<cmd>Telescope<cr>",                                     desc = "find_files" },
      { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find_files" },
      { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>",  desc = "live_grep" },
      { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>",  desc = "help_tags" },
      { "<leader>fe", "<cmd>lua require('telescope.builtin').keymaps()<cr>",    desc = "keymappings" },
      {
        "<leader>s",
        "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
        desc = "search symbols",
      },
      {
        "<leader>fs",
        "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>",
        desc = "search all symbols",
      },
    },
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
    branch = 'master',
    event = "BufReadPre",
    opts = {
      ensure_installed = { "lua", "python", "toml", "bash", "json" },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      -- for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
      --   config.install_info.url = config.install_info.url:gsub("https://github.com/", "https://ghproxy.net/https://github.com/")
      -- end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "\\", ":Neotree float reveal<CR>", desc = "NeoTree reveal", silent = true },
    },
    config = function()
      require("neo-tree").setup({
        popup_border_style = "rounded",
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            { source = "filesystem" },
            { source = "buffers" },
            { source = "git_status" },
            { source = "document_symbols" },
          },
        },
        filesystem = {
          check_gitignore_in_search = true, -- Check gitignore status for files/directories when searching.
          find_by_full_path_words = false,
          follow_current_file = {
            enabled = true,
          },
        },
        buffers = {
          leave_dirs_open = false,
          follow_current_file = {
            enabled = true,
          },
        },
        git_status = {},
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
          javascript = { "deno" },
          rust = { "rustfmt" },
          bash = { "shfmt" },
          markdown = { "deno" },
          toml = { "taplo" },
          json = { "deno" },
          jsonc = { "deno" },
          nix = { "alejandra" },
          html = { "deno" },

          ["_"] = { "trim_whitespace" },
        },
      })
    end,
  },

  -- comment
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      require("Comment").setup()
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
    keys = { { "<leader>ft", "<cmd> TodoTelescope <cr>", desc = "TodoTelescope" } },
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

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    enabled = true,
    lazy = false,
    opts = {
      servers = {
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
      },
    },

    config = function(_, opts)
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities()
        vim.lsp.config[server] = config
        vim.lsp.enable(server)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then
            return
          end

          if vim.bo.filetype == "lua" then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          end
        end,
      })
    end,
  },
}

local opts = {
  spec = plugins,
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
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
