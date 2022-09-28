local api = vim.api

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "sumneko_lua", "pyright" },
  automatic_installation = true,
})

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.completion.spell,
  },
})

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', { 
      pattern = 'LspAttached',
      -- desc = 'Acciones LSP',
      callback = function()
        -- Mappings.
        local opts = { buffer = bufnr, noremap = true, silent = true }
        local vks = function(mode, keys, cmd)
          vim.keymap.set(mode, keys, cmd, opts)
        end
        vks('n', 'gD', vim.lsp.buf.declaration)
        vks('n', 'gd', vim.lsp.buf.definition)
        vks('n', 'K', vim.lsp.buf.hover)
        vks('n', 'gi', vim.lsp.buf.implementation)
        vks('n', '<C-k>', vim.lsp.buf.signature_help)
        vks('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
        vks('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
        vks('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end)
        vks('n', '<space>D', vim.lsp.buf.type_definition)
        vks('n', '<space>rn', vim.lsp.buf.rename)
        vks('n', 'gr', vim.lsp.buf.references)
        vks('n', '<space>e', vim.diagnostic.open_float)
        vks('n', '[d', vim.diagnostic.goto_prev)
        vks('n', ']d', vim.diagnostic.goto_next)
        vks('n', '<space>q', vim.diagnostic.setloclist)
        vks("n", "<leader>f", vim.lsp.buf.formatting())
      end
    })
  end
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

lspconfig.sumneko_lua.setup({})
lspconfig.pyright.setup({})


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
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})
