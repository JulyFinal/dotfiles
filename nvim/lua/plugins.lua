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
  use 'hrsh7th/cmp-nvim-lsp' -- { name = nvim_lsp }
  use 'hrsh7th/cmp-buffer' -- { name = 'buffer' },
  use 'hrsh7th/cmp-path' -- { name = 'path' }
  use 'hrsh7th/cmp-cmdline' -- { name = 'cmdline' }
  use {'hrsh7th/nvim-cmp'}
  -- lspkind
  use 'onsails/lspkind-nvim'
  use { 'rafamadriz/friendly-snippets', module = { "cmp", "cmp_nvim_lsp" }, event = "InsertEnter", }

  -- For luasnip users.
  use 'L3MON4D3/LuaSnip'
  use { 'saadparwaiz1/cmp_luasnip', after = "LuaSnip" }


  use 'nvim-treesitter/nvim-treesitter'

  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  use "jose-elias-alvarez/null-ls.nvim"

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
    display = {
      open_fn = require('packer.util').float,
    }
  }
})
