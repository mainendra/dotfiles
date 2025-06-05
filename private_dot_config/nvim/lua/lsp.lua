local status_ok, mason, mason_lspconfig

status_ok, mason = pcall(require, 'mason')
if not status_ok then
    return
end

status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok then
    return
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- diagnostic config
    vim.diagnostic.config({
        virtual_text = {
            severity = { min = vim.diagnostic.severity.INFO, },
        },
        severity_sort = true,
        float = true,
    })

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<Leader>hd', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<Leader>sh', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
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
        })

        vim.lsp.config('*', {
            on_attach = on_attach,
        })
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME,
                            '${3rd}/luv/library',
                            '${3rd}/busted/library',
                        },
                    },
                },
            }
        })
        vim.lsp.config('ts_ls', {
            root_markers = { 'package.json' },
            workspace_required = true,
        })
        vim.lsp.config('denols', {
            root_markers = { 'deno.json', 'deno.jsonc' },
            workspace_required = true,
        })
    end
}
