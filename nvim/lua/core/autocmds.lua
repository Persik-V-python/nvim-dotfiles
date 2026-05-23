local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Основная группа
local general = augroup("General", { clear = true })

-- Подсветка при копировании
autocmd("TextYankPost", {
    group = general,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Автоматическая перезагрузка файла при внешних изменениях
autocmd({ "FocusGained", "BufEnter" }, {
    group = general,
    command = "checktime",
})

-- Возврат к последней позиции при открытии файлов
autocmd("BufReadPost", {
    group = general,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Автоматическое создание директорий при сохранении
autocmd("BufWritePre", {
    group = general,
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":h"), "p")
    end,
})

-- Закрытие некоторых типов файлов по <q>
autocmd("FileType", {
    group = general,
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Отключение авто-комментария на новой строке
autocmd("BufEnter", {
    group = general,
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Установка типа файла для конфигов
autocmd({ "BufRead", "BufNewFile" }, {
    group = general,
    pattern = { ".env*", "*.env" },
    callback = function()
        vim.bo.filetype = "sh"
    end,
})

-- Оптимизация для больших файлов
autocmd("BufReadPre", {
    group = general,
    callback = function(args)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > 1024 * 1024 then -- 1MB
            vim.opt_local.undolevels = -1
            vim.opt_local.swapfile = false
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.eventignore:append("FileType")
            vim.notify("Обнаружен большой файл, включена оптимизация производительности", vim.log.levels.WARN)
        end
    end,
})

-- Настройки терминала
autocmd("TermOpen", {
    group = general,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd("startinsert")
    end,
})
