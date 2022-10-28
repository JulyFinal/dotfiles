require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require 'lspconfig'

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>w', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  local opts = { buffer = bufnr, noremap = true, silent = true }
  local vks = function(mode, keys, cmd)
    vim.keymap.set(mode, keys, cmd, opts)
  end
  vks('n', 'gD', "<cmd>lua vim.lsp.buf.declaration<cr>")
  vks('n', 'gd', "<cmd>lua vim.lsp.buf.definition<cr>")
  vks('n', 'K', "<cmd>lua vim.lsp.buf.hover<cr>")
  vks('n', 'gi', "<cmd>lua vim.lsp.buf.implementation<cr>")
  vks('n', '<C-k>', "<cmd>lua vim.lsp.buf.signature_help<cr>")
  vks('n', '<space>wa', "<cmd>lua vim.lsp.buf.add_workspace_folder<cr>")
  vks('n', '<space>wr', "<cmd>lua vim.lsp.buf.remove_workspace_folder<cr>")
  vks('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  vks('n', '<space>D', "<cmd>lua vim.lsp.buf.type_definition<cr>")
  vks('n', '<space>rn', "<cmd>lua vim.lsp.buf.rename<cr>")
  vks('n', 'gr', "<cmd>lua vim.lsp.buf.references<cr>")
end

-- Set up lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()


capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext", "python", "lua" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

mason_lspconfig.setup({
  ensure_installed = { "sumneko_lua", "pyright" },
  automatic_installation = true,
})



mason_lspconfig.setup_handlers({
  function(server_name) -- Default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,

  ["pyright"] = function()
    lspconfig.pyright.setup({
      settings = {
        python = {
          analysis = {
            -- Disable strict type checking
            typeCheckingMode = "off"
          }
        }
      },
    })
  end,
})


local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '✘' })
sign({ name = 'DiagnosticSignWarn', text = '▲' })
sign({ name = 'DiagnosticSignHint', text = '⚑' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})
-- when save , format code
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
