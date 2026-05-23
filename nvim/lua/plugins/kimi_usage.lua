local M = {}

-- ═══════════════════════════════════════════════════════════════
-- Конфигурация
-- ═══════════════════════════════════════════════════════════════
M.config = {
    api_token = vim.g.kimi_api_token or vim.env.KIMI_API_TOKEN,
    interval  = 120000,          -- 2 минуты в мс
    position  = "bottom_right",  -- bottom_right | bottom_left | top_right | top_left
    bar_width = 18,
}

-- ═══════════════════════════════════════════════════════════════
-- Состояние
-- ═══════════════════════════════════════════════════════════════
local state = {
    data  = nil,
    timer = nil,
    win   = nil,
    buf   = nil,
}

-- ═══════════════════════════════════════════════════════════════
-- ASCII прогресс-бар
-- ═══════════════════════════════════════════════════════════════
local function make_bar(label, current, limit, width)
    if not current or not limit or tonumber(limit) == 0 then
        return string.format(" %s: н/д", label)
    end

    width = width or M.config.bar_width
    local cur   = tonumber(current) or 0
    local lim   = tonumber(limit)   or 1
    local ratio = cur / lim
    if ratio > 1 then ratio = 1 end

    local filled = math.floor(ratio * width)
    local empty  = width - filled
    local bar    = string.rep("█", filled) .. string.rep("░", empty)

    return string.format(" %s: [%s] %s/%s", label, bar, cur, lim)
end

-- ═══════════════════════════════════════════════════════════════
-- Запрос к API
-- ═══════════════════════════════════════════════════════════════
function M.fetch()
    local token = M.config.api_token
    if not token or token == "" then
        state.data = { error = "Токен не настроен (см. README → KIMI_API_TOKEN)" }
        return
    end

    local cmd = string.format(
        'curl -s -m 10 -H "Authorization: Bearer %s" https://api.kimi.com/coding/v1/usages',
        token
    )

    local handle = io.popen(cmd)
    if not handle then
        state.data = { error = "Ошибка запуска curl" }
        return
    end

    local result = handle:read("*a")
    handle:close()

    if result == "" then
        state.data = { error = "Пустой ответ от API" }
        return
    end

    local ok, data = pcall(vim.fn.json_decode, result)
    if not ok then
        state.data = { error = "Ошибка парсинга JSON" }
        return
    end

    state.data = data
end

-- ═══════════════════════════════════════════════════════════════
-- Обновление буфера
-- ═══════════════════════════════════════════════════════════════
function M.update_buffer()
    if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
        return
    end

    local lines = {}

    if state.data and state.data.error then
        table.insert(lines, " ⚠️  Kimi Usage")
        table.insert(lines, "─────────────────────────────────")
        table.insert(lines, " " .. state.data.error)
    elseif state.data then
        local u  = state.data.usage   or {}
        local l  = (state.data.limits and state.data.limits[1] and state.data.limits[1].detail) or {}
        local tq = state.data.totalQuota or {}

        table.insert(lines, " 🤖 Kimi Usage")
        table.insert(lines, "─────────────────────────────────")
        table.insert(lines, make_bar("Неделя ", u.used,   u.limit, M.config.bar_width))
        table.insert(lines, make_bar("5 мин  ", l.used,   l.limit, M.config.bar_width))
        table.insert(lines, make_bar("Квота  ", tq.remaining, tq.limit, M.config.bar_width))
        table.insert(lines, " Обновлено: " .. os.date("%H:%M:%S"))
    else
        table.insert(lines, " 🤖 Kimi Usage")
        table.insert(lines, "─────────────────────────────────")
        table.insert(lines, " Загрузка…")
    end

    vim.api.nvim_set_option_value("modifiable", true, { buf = state.buf })
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = state.buf })
end

-- ═══════════════════════════════════════════════════════════════
-- Показать окно
-- ═══════════════════════════════════════════════════════════════
function M.show()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        M.update_buffer()
        return
    end

    if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
        state.buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_option_value("bufhidden", "hide", { buf = state.buf })
        vim.api.nvim_set_option_value("filetype", "kimiusage", { buf = state.buf })
    end

    local width  = 52
    local height = 7
    local row, col

    if M.config.position == "bottom_right" then
        row = vim.o.lines - height - 3
        col = vim.o.columns - width - 3
    elseif M.config.position == "bottom_left" then
        row = vim.o.lines - height - 3
        col = 3
    elseif M.config.position == "top_right" then
        row = 2
        col = vim.o.columns - width - 3
    else
        row = 2
        col = 3
    end

    local win_opts = {
        relative  = "editor",
        width     = width,
        height    = height,
        row       = row,
        col       = col,
        style     = "minimal",
        border    = "rounded",
        title     = " Kimi ",
        title_pos = "center",
        zindex    = 50,
    }

    state.win = vim.api.nvim_open_win(state.buf, false, win_opts)
    vim.api.nvim_set_option_value("winblend", 10, { win = state.win })

    M.update_buffer()
end

-- ═══════════════════════════════════════════════════════════════
-- Скрыть окно
-- ═══════════════════════════════════════════════════════════════
function M.hide()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, false)
        state.win = nil
    end
end

-- ═══════════════════════════════════════════════════════════════
-- Переключить видимость
-- ═══════════════════════════════════════════════════════════════
function M.toggle()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        M.hide()
    else
        M.show()
    end
end

-- ═══════════════════════════════════════════════════════════════
-- Запуск авто-обновления
-- ═══════════════════════════════════════════════════════════════
function M.start()
    M.fetch()
    M.show()

    if state.timer then
        vim.fn.timer_stop(state.timer)
    end

    state.timer = vim.fn.timer_start(M.config.interval, function()
        vim.schedule(function()
            M.fetch()
            M.update_buffer()
        end)
    end, { ["repeat"] = -1 })
end

-- ═══════════════════════════════════════════════════════════════
-- Остановка
-- ═══════════════════════════════════════════════════════════════
function M.stop()
    if state.timer then
        vim.fn.timer_stop(state.timer)
        state.timer = nil
    end
    M.hide()
end

-- ═══════════════════════════════════════════════════════════════
-- Команды
-- ═══════════════════════════════════════════════════════════════
vim.api.nvim_create_user_command("KimiUsage", M.toggle, {
    desc = "Показать/скрыть окно Kimi Usage",
})

vim.api.nvim_create_user_command("KimiUsageStart", M.start, {
    desc = "Запустить мониторинг Kimi",
})

vim.api.nvim_create_user_command("KimiUsageStop", M.stop, {
    desc = "Остановить мониторинг Kimi",
})

vim.api.nvim_create_user_command("KimiUsageFetch", function()
    M.fetch()
    M.update_buffer()
    vim.notify("Данные Kimi обновлены", vim.log.levels.INFO)
end, {
    desc = "Обновить данные Kimi вручную",
})

-- Горячая клавиша
vim.keymap.set("n", "<leader>ku", M.toggle, { desc = "Показать/скрыть Kimi Usage" })

return M
