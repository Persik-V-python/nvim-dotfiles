require("codock").setup({
    width = 80,
    codock_cmd = "crush",
    copy_to_clipboard = true,
    actions = {},
})

vim.keymap.set({ "n", "v" }, "<leader>CC", "<cmd>Codock<cr>", { desc = "Открыть/закрыть Crush" })
vim.keymap.set({ "n", "v" }, "<leader>CY", ":'<,'>CodockFilePosYank<cr>", { desc = "Копировать позицию файла" })
vim.keymap.set({ "n", "v" }, "<leader>CP", ":'<,'>CodockFilePosPaste<cr>", { desc = "Копировать и вставить позицию" })
vim.keymap.set({ "n", "v" }, "<leader>CA", ":'<,'>CodockActions<cr>", { desc = "Запустить Codock действия" })
