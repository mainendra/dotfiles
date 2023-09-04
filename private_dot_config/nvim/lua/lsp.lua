local status_ok, mason_lspconfig, lspconfig

status_ok = pcall(require, 'mason')
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

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- diagnostic config
  vim.diagnostic.config({
    virtual_text = {
      source = "always",  -- Or "if_many"
    },
    severity_sort = true,
    float = {
      source = "always",  -- Or "if_many"
    },
  })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<Leader>do', vim.diagnostic.open_float , bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<Leader>=', function() vim.lsp.buf.format { async = true } end, bufopts)
end

return {
  setup = function()
    mason_lspconfig.setup({
      ensure_installed = { 'lua_ls' },
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
      ['lua_ls'] = function ()
        lspconfig.lua_ls.setup {
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
  end
}
