-- Файловый менеджер
require("nvim-tree").setup({
    view = { width = 35, side = "left" },
    renderer = {
        indent_markers = { enable = true },
        icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
    },
    actions = { open_file = { quit_on_open = true } },
    filters = { dotfiles = false, custom = { "^.git$", "node_modules", ".idea" } },
    git = { enable = true, ignore = false },
    update_focused_file = { enable = true, update_cwd = true },
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Файловый менеджер" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Найти файл в проводнике" })

-- Вкладки буферов
require("bufferline").setup({
    options = {
        mode = "buffers",
        numbers = "ordinal",
        close_command = "bdelete! %d",
        diagnostics = "nvim_lsp",
        offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
        separator_style = "thin",
        always_show_bufferline = true,
    },
})

-- Статусная строка
require("lualine").setup({
    options = {
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})

-- Стартовый экран
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
}
dashboard.section.buttons.val = {
    dashboard.button("f", "  Найти файл", "<cmd>Telescope find_files<CR>"),
    dashboard.button("e", "  Новый файл", "<cmd>ene <BAR> startinsert<CR>"),
    dashboard.button("r", "  Недавние файлы", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("g", "  Поиск текста", "<cmd>Telescope live_grep<CR>"),
    dashboard.button("c", "  Конфиг", "<cmd>e $MYVIMRC<CR>"),
    dashboard.button("q", "  Выйти", "<cmd>qa<CR>"),
}
require("alpha").setup(dashboard.opts)

-- Уведомления
vim.notify = require("notify")
require("notify").setup({
    timeout = 3000,
    max_width = 80,
    stages = "fade_in_slide_out",
    render = "compact",
})

-- Подсказки по клавишам
require("which-key").setup({
    win = { border = "rounded", padding = { 2, 2, 2, 2 } },
})

-- Линии отступов
require("ibl").setup({
    indent = { char = "│" },
    scope = { enabled = true },
})

-- Подсветка цветов
require("colorizer").setup({
    user_default_options = { names = false, rgb_fn = true, hsl_fn = true, css = true, css_fn = true },
})
