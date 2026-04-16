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
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.buf.format({ async = true })'

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
    vim.keymap.set('n', '=', function() vim.lsp.buf.format({ async = true }) end, bufopts)
    vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<Leader>hd', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<Leader>sh', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
end

return {
    setup = function()
        mason.setup()
        mason_lspconfig.setup({
            automatic_enable = true,
            ensure_installed = {
                'lua_ls',
                'cssls',
                'cssmodules_ls',
                'denols',
                'oxlint',
                'eslint',
                'html',
                'jsonls',
                'marksman',
                'svelte',
                'tailwindcss',
                'vtsls',
                'typos_lsp',
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
        vim.lsp.config('vtsls', {
            root_markers = { 'tsconfig.json', 'package.json' },
            workspace_required = true,
        })
        vim.lsp.config('denols', {
            root_markers = { 'deno.json', 'deno.jsonc' },
            workspace_required = true,
        })
        vim.lsp.config('tailwindcss', {
            filetypes = { 'html', 'css', 'scss', 'less', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue', 'astro' },
        })
        vim.lsp.config('marksman', {
            filetypes = { 'markdown' },
        })
        vim.lsp.config('yamlls', {
            filetypes = { 'yaml' },
        })
    end
}
