local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

local on_attach = function(_, bufnr)
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end
    map("gd", vim.lsp.buf.definition, "Перейти к определению")
    map("gD", vim.lsp.buf.declaration, "Перейти к объявлению")
    map("gr", vim.lsp.buf.references, "Найти ссылки")
    map("gi", vim.lsp.buf.implementation, "Перейти к реализации")
    map("K", vim.lsp.buf.hover, "Документация")
    map("<leader>rn", vim.lsp.buf.rename, "Переименовать")
    map("<leader>ca", vim.lsp.buf.code_action, "Быстрое действие")
    map("<leader>D", vim.lsp.buf.type_definition, "Определение типа")
    map("<leader>ds", vim.lsp.buf.document_symbol, "Символы документа")
    map("<leader>ws", vim.lsp.buf.workspace_symbol, "Символы рабочей области")
    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Добавить папку")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Удалить папку")
    map("<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "Список папок")
    map("<leader>F", function() vim.lsp.buf.format({ async = true }) end, "Форматировать")

    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Подпись функции" })
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Подпись функции" })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "tsserver", "html", "cssls", "jsonls", "pyright", "gopls", "rust_analyzer" },
})

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        })
    end,
})

-- Diagnostics
vim.diagnostic.config({
    virtual_text = { prefix = "●" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Интерфейс Mason
require("mason").setup({
    ui = { border = "rounded", icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
})

-- Автодополнение
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- Форматирование и линтинг (null-ls)
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "typescript", "json", "yaml", "markdown", "html", "css" },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.diagnostics.eslint_d,
    },
})
