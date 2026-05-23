require("persistence").setup({})
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Восстановить сессию" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Восстановить последнюю сессию" })
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Не сохранять сессию" })
