-- LSP server configuration via Mason
-- Must be called after mason, mason-lspconfig and nvim-lspconfig are added.

return {
  setup = function()
    local ok_mason, mason = pcall(require, 'mason')
    local ok_mlsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
    if not (ok_mason and ok_mlsp) then
      vim.notify('mason / mason-lspconfig not available; LSP disabled', vim.log.levels.WARN)
      return
    end

    mason.setup()
    mason_lspconfig.setup({
      automatic_enable = true,
      ensure_installed = {
        'lua_ls',
        'cssls',
        'cssmodules_ls',
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
        'yamlls',
      },
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = {
              vim.env.VIMRUNTIME,
              vim.fn.stdpath('config') .. '/lua',
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            },
            checkThirdParty = false,
          },
        },
      },
    })
    vim.lsp.config('vtsls', {
      root_markers = { 'tsconfig.json', 'package.json' },
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
  end,
}
