" ============================================================
" Конфиг Neovim с vim-plug
" ============================================================

" Клавиши лидера
let g:mapleader = ' '
let g:maplocalleader = ' '

" Основные настройки
lua require('core.options')
lua require('core.keymaps')
lua require('core.autocmds')

" ============================================================
" Плагины
" ============================================================
call plug#begin(stdpath('data') . '/plugged')

" Тема
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" Иконки
Plug 'nvim-tree/nvim-web-devicons'

" Файловый менеджер
Plug 'nvim-tree/nvim-tree.lua'

" Вкладки буферов
Plug 'akinsho/bufferline.nvim'

" Статусная строка
Plug 'nvim-lualine/lualine.nvim'

" Нечёткий поиск
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Парсер синтаксиса
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" Улучшения редактора
Plug 'windwp/nvim-autopairs'
Plug 'kylechui/nvim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/flash.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'folke/trouble.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'mrjones2014/smart-splits.nvim'
Plug 'NvChad/nvim-colorizer.lua'

" Улучшения интерфейса
Plug 'folke/which-key.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'goolord/alpha-nvim'
Plug 'folke/persistence.nvim'

" Git интеграция
Plug 'lewis6991/gitsigns.nvim'

" LSP серверы
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Автодополнение
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Форматирование и линтинг
Plug 'nvimtools/none-ls.nvim'

" AI терминал (Codock)
Plug 'gitsang/codock.nvim'

call plug#end()

" ============================================================
" Конфигурации плагинов
" ============================================================
lua require('plugins.theme')
lua require('plugins.ui')
lua require('plugins.finder')
lua require('plugins.treesitter')
lua require('plugins.editor')
lua require('plugins.lsp')
lua require('plugins.git')
lua require('plugins.codock')
lua require('plugins.persistence')
lua require('plugins.kimi_usage').start()
