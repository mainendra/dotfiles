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
local on_attach = function(_, bufnr)
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
    vim.keymap.set('n', '<Leader>gd', '<cmd>Lspsaga peek_definition<CR>', bufopts)
    vim.keymap.set('n', '<Leader>gt', '<cmd>Lspsaga peek_type_definition<CR>', bufopts)
    vim.keymap.set('n', '<Leader>hd', '<cmd>Lspsaga hover_doc<CR>', bufopts)
    vim.keymap.set('n', '<Leader>ls', '<cmd>Lspsaga signature_help<CR>', bufopts)
    vim.keymap.set('n', '<Leader>ld', '<cmd>Lspsaga show_line_diagnostics<CR>', bufopts)
    vim.keymap.set('n', '<Leader>rn', '<cmd>Lspsaga rename<CR>', bufopts)
    vim.keymap.set('n', '<Leader>ca', '<cmd>Lspsaga code_action<CR>', bufopts)
    vim.keymap.set('n', '<Leader>lf', '<cmd>Lspsaga finder<CR>', bufopts)
    vim.keymap.set('n', '<Leader>tt', '<cmd>Lspsaga term_toggle<CR>', bufopts)
    vim.keymap.set('n', '<Leader>ic', '<cmd>Lspsaga incoming_calls<CR>', bufopts)
    vim.keymap.set('n', '<Leader>oc', '<cmd>Lspsaga outgoing_calls<CR>', bufopts)
    vim.keymap.set('n', '<Leader>=', function() vim.lsp.buf.format { async = true } end, bufopts)
end

return {
    setup = function()
        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = {
                'lua_ls',
                'cssls',
                'cssmodules_ls',
                'denols',
                'emmet_language_server',
                'html',
                'jsonls',
                'marksman',
                'svelte',
                'tailwindcss',
                'ts_ls',
                'vimls',
                'yamlls'
            },
            automatic_installation = true
        })
        mason_lspconfig.setup_handlers({
            function (server_name)
                lspconfig[server_name].setup {
                    on_attach = on_attach
                }
            end,
            ['ts_ls'] = function ()
                lspconfig['ts_ls'].setup {
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
                    on_attach = on_attach,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' }
                            }
                        }
                    }
                }
            end,
        })
    end
}
