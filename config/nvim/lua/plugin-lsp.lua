return function()
  require("mason").setup()

  local lspconfig = require("lspconfig")

  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- Mappings.
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local vks = function(mode, keys, cmd)
      vim.keymap.set(mode, keys, cmd, opts)
    end
    vks("n", "ge", vim.lsp.buf.declaration)
    vks("n", "gd", vim.lsp.buf.definition)
    vks("n", "gh", vim.lsp.buf.hover)
    -- vks("n", "<leader>i", vim.lsp.buf.implementation)
    -- vks("n", "<leader>k", vim.lsp.buf.signature_help)
    -- vks("n", "<leader>d", vim.lsp.buf.type_definition)
    vks("n", "gr", vim.lsp.buf.rename)
    vks("n", "gq", vim.lsp.buf.references)
  end

  -- Set up lspconfig.
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext", "python", "lua", "sh" },
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

  local servers = {
    ["pyright"] = {
      python = {
        analysis = {
          -- Disable strict type checking
          typeCheckingMode = "off",
        },
      },
    },
    ["bashls"] = {},
    ["lua_ls"] = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }

  for lsp, settings in pairs(servers) do
    lspconfig[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = settings,
    })
  end

  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = "",
    })
  end

  sign({ name = "DiagnosticSignError", text = "✘" })
  sign({ name = "DiagnosticSignWarn", text = "▲" })
  sign({ name = "DiagnosticSignHint", text = "⚑" })
  sign({ name = "DiagnosticSignInfo", text = "" })

  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
end
