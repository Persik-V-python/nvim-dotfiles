require("gitsigns").setup({
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]g", gs.next_hunk, "Следующий hunk")
        map("n", "[g", gs.prev_hunk, "Предыдущий hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage буфер")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Отменить stage")
        map("n", "<leader>gR", gs.reset_buffer, "Reset буфера")
        map("n", "<leader>gp", gs.preview_hunk, "Предпросмотр hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame строки")
        map("n", "<leader>gd", gs.diffthis, "Diff")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Выделить hunk")
    end,
})
