local opt = vim.opt
local g = vim.g

-- Клавиши лидера
g.mapleader = " "
g.maplocalleader = " "

-- Локализация
opt.lang = "ru_RU.UTF-8"
opt.helplang = "ru"

-- Кодировка
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Интерфейс
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.laststatus = 3
opt.showmode = false
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.completeopt = { "menuone", "noselect", "noinsert" }

-- Табуляция и отступы
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Поиск
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Файлы
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Производительность
opt.updatetime = 300
opt.timeoutlen = 500
opt.redrawtime = 10000

-- Буфер обмена
opt.clipboard = "unnamedplus"

-- Разделение окон
opt.splitright = true
opt.splitbelow = true

-- Символы заполнения
opt.fillchars = {
    foldopen = "\226\149\173",
    foldclose = "\226\150\184",
    fold = " ",
    foldsep = " ",
    diff = "\226\149\177",
    eob = " ",
}

-- Отключение встроенных плагинов
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end
