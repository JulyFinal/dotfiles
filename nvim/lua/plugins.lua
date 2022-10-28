local packer = require('packer')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return packer.startup({ function()
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require("indent_blankline").setup {} end
  }

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {}
    end
  })

  -- nvim-cmp
  -- lspkind

  use 'nvim-treesitter/nvim-treesitter'

  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use "jose-elias-alvarez/null-ls.nvim"

  -- cmp configs
  use 'onsails/lspkind-nvim'
  use { 'rafamadriz/friendly-snippets', module = { "cmp", "cmp_nvim_lsp" }, event = "InsertEnter" }
  use { "hrsh7th/nvim-cmp" }
  use { "L3MON4D3/LuaSnip" }
  use { "saadparwaiz1/cmp_luasnip" }
  use { "hrsh7th/cmp-nvim-lua" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use 'shaunsingh/moonlight.nvim'

  -- using packer.nvim
  use { 'akinsho/bufferline.nvim', tag = "v2.*", }
  -- outline
  use "simrat39/symbols-outline.nvim"
  -- easymotion
  use { 'phaazon/hop.nvim', branch = 'v2' }
  -- todo
  use { 'folke/todo-comments.nvim' }

  -- line
  use({
    "NTBBloodbath/galaxyline.nvim",
    config = function()
      require("galaxyline.themes.eviline")
    end,
  })

  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    max_jobs = 30,
    git = {
      clone_timeout = 240,
      default_url_format = "git@github.com:%s",
      -- default_url_format = "https://hub.fastgit.xyz/%s",
      -- default_url_format = "https://mirror.ghproxy.com/https://github.com/%s",
    },
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" }) -- single rounded
      end,
      prompt_border = 'rounded'
    },
    auto_clean = true,
    compile_on_sync = true,
  }
})
