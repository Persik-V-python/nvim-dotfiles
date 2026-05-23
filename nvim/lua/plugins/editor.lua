require("nvim-surround").setup({})

require("Comment").setup({
    toggler = { line = "gcc", block = "gbc" },
    opleader = { line = "gc", block = "gb" },
})

require("flash").setup({})
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Быстрый jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash по Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Удалённый Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Поиск Treesitter" })

require("todo-comments").setup({})
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "Найти TODO" })
vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "TODO в Trouble" })

require("trouble").setup({})
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Все ошибки (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Ошибки буфера (Trouble)" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Список локаций (Trouble)" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix (Trouble)" })

require("neoscroll").setup({})
require("smart-splits").setup({})
