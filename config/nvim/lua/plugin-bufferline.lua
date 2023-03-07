return function()
  local setup_opts = {
    options = {
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  }
  require("bufferline").setup(setup_opts)
end
