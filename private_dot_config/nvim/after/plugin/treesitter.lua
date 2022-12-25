local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

treesitter.setup {
    -- ensure_installed = 'all',
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    autotag = {
        enable = true,
    }
}

