local status_ok, mason, mason_lspconfig

status_ok, mason = pcall(require, 'mason')
if not status_ok then
    return
end

status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok then
    return
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
