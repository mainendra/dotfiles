local status_ok, mason, mason_lspconfig, lspconfig

status_ok, mason = pcall(require, 'mason')
if not status_ok then
  return
end

status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok then
  return
end

status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  return
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    require('twoslash-queries').attach(client, bufnr)
  end

  -- always load telescope ui extension
  require('telescope').load_extension('ui-select')

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<Leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

mason.setup()
mason_lspconfig.setup({
  ensure_installed = { 'sumneko_lua' },
  automatic_installation = true
})
mason_lspconfig.setup_handlers({
  function (server_name)
    lspconfig[server_name].setup {
      on_attach = on_attach
    }
  end,
  ['tsserver'] = function ()
    lspconfig['tsserver'].setup {
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("package.json"),
      single_file_support = false,
    }
  end,
  ['denols'] = function ()
    lspconfig['denols'].setup {
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    }
  end,
  ['sumneko_lua'] = function ()
    lspconfig.sumneko_lua.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }
  end,
  ['tailwindcss'] = function ()
    lspconfig.tailwindcss.setup {
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              "cva\\(([^)]*)\\)",
              "[\"'`]([^\"'`]*).*?[\"'`]",
            },
          },
        },
      },
    }
  end,
})
