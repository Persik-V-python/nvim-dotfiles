-- Тема оформления
require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    term_colors = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        bufferline = true,
        mason = true,
        notify = true,
        mini = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
    },
})
vim.cmd.colorscheme("catppuccin")
