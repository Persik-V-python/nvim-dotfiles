-- Treesitter: парсер и подсветка синтаксиса
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua", "vim", "vimdoc", "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml", "markdown", "markdown_inline",
        "python", "go", "rust", "c", "cpp", "bash", "dockerfile",
    },
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    autotag = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
})

-- Автоскобки
require("nvim-autopairs").setup({
    check_ts = true,
    ts_config = { lua = { "string" }, javascript = { "template_string" } },
})
