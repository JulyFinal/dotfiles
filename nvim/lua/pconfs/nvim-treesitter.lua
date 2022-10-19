require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "toml", "bash" },
  sync_install = true,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}
