local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://ghproxy.com/https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
local plugins = {
  -- theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("indent_blankline").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "kylechui/nvim-surround",
    lazy = false,
    config = function()
      require("nvim-surround").setup()
    end,
  },

  { "nvim-treesitter/nvim-treesitter", config = require("plugin-nvim-treesitter") },

  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" } },
    config = require("plugin-nvim-tree"),
  },

  {
    "neovim/nvim-lspconfig",
    event = "InsertEnter",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = require("plugin-lsp"),
  },

  {
    "jayp0521/mason-null-ls.nvim",
    dependencies = { "jose-elias-alvarez/null-ls.nvim" },
    event = "InsertEnter",
    config = require("plugin-null-ls"),
  },

  -- cmp configs
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind-nvim",

      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
      "hrsh7th/cmp-buffer", -- { name = 'buffer' },
      "hrsh7th/cmp-path",  -- { name = 'path' }
      "hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
      "rafamadriz/friendly-snippets",
    },
    config = require("plugin-nvim-cmp"),
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "InsertEnter",
    config = require("plugin-gitsigns"),
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "find_files" },
      { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>",  desc = "live_grep" },
      { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>",    desc = "buffers" },
      { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>",  desc = "help_tags" },
    },
  },

  {
    "numToStr/Comment.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "v3.*",
    lazy = false,
    priority = 100,
    config = require("plugin-bufferline"),
  },
  -- outline
  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>l", "<cmd>SymbolsOutline<CR>", desc = "SymbolsOutline" } },
    config = function()
      require("symbols-outline").setup({ { width = 10 } })
    end,
  },
  -- easymotion
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = {
      { "f", "<cmd>HopChar1CurrentLineAC<cr>", desc = "Find Char1 AC" },
      { "F", "<cmd>HopChar1CurrentLineBC<cr>", desc = "Find Char1 BC" },
      {
        "t",
        "<cmd>lua require'hop'.hint_char1({direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1})<cr>",
        desc = "Find Char1 AC",
      },
      {
        "T",
        "<cmd>lua require'hop'.hint_char1({direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1})<cr>",
        desc = "Find Char1 BC",
      },
      { ";", "<cmd>HopChar2<cr>", desc = "easymotion" },
    },
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  },

  -- todo
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = { { "<leader>ft", "<cmd> TodoTelescope <cr>", desc = "TodoTelescope" } },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = require("plugin-lualine"),
  },
}

local opts = {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight-moon" } },
  -- checker = { enabled = true },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  git = {
    log = { "-10" }, -- show the last 10 commits
    timeout = 120, -- kill processes that take more than 2 minutes
    -- url_format = "https://github.com/%s.git",
    -- url_format = "git@github.com:%s",
    -- url_format = "https://hub.fastgit.xyz/%s",
    url_format = "https://ghproxy.com/https://github.com/%s",
  },
}

require("lazy").setup(plugins, opts)
