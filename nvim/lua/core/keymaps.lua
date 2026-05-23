local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Сохранение и выход
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Сохранить файл" })
map("i", "<C-s>", "<Esc><cmd>w<CR>a", { desc = "Сохранить файл" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Выйти" })

-- Навигация по окнам
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Изменение размера окон
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Сплиты
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Вертикальный сплит" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Горизонтальный сплит" })
map("n", "<leader>se", "<C-w>=", { desc = "Уравнять размеры окон" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Закрыть сплит" })

-- Буферы
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Закрыть буфер" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Переключиться на другой буфер" })

-- Табы
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Новый таб" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Закрыть таб" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Закрыть другие табы" })
map("n", "<leader>tl", "<cmd>tabnext<CR>", { desc = "Следующий таб" })
map("n", "<leader>th", "<cmd>tabprevious<CR>", { desc = "Предыдущий таб" })

-- Оставаться в режиме отступа
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Перемещение текста вверх/вниз
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("n", "<A-j>", "<cmd>m .+1<CR>==", opts)
map("n", "<A-k>", "<cmd>m .-2<CR>==", opts)
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", opts)
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", opts)

-- Центрировать курсор при прокрутке/поиске
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Улучшенная вставка (не перезаписывать регистр)
map("v", "p", '"_dP', opts)

-- Удаление без копирования
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Удалить без копирования" })

-- Копирование в системный буфер обмена
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Копировать в системный буфер" })
map("n", "<leader>Y", '"+Y', { desc = "Копировать строку в буфер" })

-- Очистить подсветку поиска
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Улучшенное поведение J
map("n", "J", "mzJ`z", opts)

-- Навигация по quickfix
map("n", "<leader>cn", "<cmd>cnext<CR>", { desc = "Следующий quickfix" })
map("n", "<leader>cp", "<cmd>cprev<CR>", { desc = "Предыдущий quickfix" })
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Открыть quickfix" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Закрыть quickfix" })

-- Быстрое редактирование конфига
map("n", "<leader>ev", "<cmd>e $MYVIMRC<CR>", { desc = "Редактировать конфиг" })
map("n", "<leader>sv", "<cmd>source $MYVIMRC<CR>", { desc = "Перезагрузить конфиг" })

-- Переключение номеров строк
map("n", "<leader>ln", "<cmd>set nu! rnu!<CR>", { desc = "Переключить номера строк" })

-- Форматирование
map("n", "<leader>fm", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Форматировать буфер" })

-- Терминал
map("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Открыть терминал" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Выйти из режима терминала" })

-- Без стрелок (учи vim!)
map({ "n", "i" }, "<Up>", "<Nop>", opts)
map({ "n", "i" }, "<Down>", "<Nop>", opts)
map({ "n", "i" }, "<Left>", "<Nop>", opts)
map({ "n", "i" }, "<Right>", "<Nop>", opts)
