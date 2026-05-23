# Agent Guide: nvim-dotfiles

## What This Repo Is

Personal Neovim configuration targeting developers migrating from VS Code. Uses **vim-plug** as the plugin manager (not lazy.nvim or packer). Config is a hybrid of Vimscript (`init.vim`) and Lua (`lua/`).

## Architecture & Loading Order

```
init.vim ──→ core.options ──→ core.keymaps ──→ core.autocmds
    │
    └──→ vim-plug loads plugins ──→ lua/plugins/*.lua (one per plugin/group)
```

1. `init.vim` sets leader keys, loads core modules, declares all plugins via `plug#begin()`/`plug#end()`
2. Plugin configs in `lua/plugins/` are loaded **after** `plug#end()` — they assume the plugin is already available
3. `kimi_usage` is special: `require('plugins.kimi_usage').start()` launches a background timer

## Directory Layout

| Path | Purpose |
|------|---------|
| `nvim/init.vim` | Entry point, plugin declarations with vim-plug |
| `nvim/lua/core/` | Core config: options, keymaps, autocmds |
| `nvim/lua/plugins/` | Per-plugin or per-group configuration |
| `docs/keymaps.md` | Human-readable keymap reference |
| `docs/plugins.md` | Plugin descriptions and purposes |
| `vim-cheatsheet.html` | Printable HTML cheat sheet |

## Critical Conventions

### Leader & Language
- **Leader = Space** (`<leader>`). Also set as `maplocalleader`.
- **All UI text is in Russian**: keymap descriptions, comments, notification messages, dashboard buttons, etc. Keep it consistent.

### Hybrid Vimscript/Lua Boundary
- `init.vim` is Vimscript. Inside it, `lua require('...')` calls bridge to Lua.
- Plugin declarations use Vimscript `Plug 'user/repo'` syntax.
- `do` callbacks in Plug declarations (e.g., `{ 'do': 'make' }`) run at install time.

### Options Are Set Twice (Intentionally)
- `g.mapleader` and `g.maplocalleader` are set in **both** `init.vim` and `lua/core/options.lua`
- This is defensive: `init.vim` sets them before any plugin loads, and `options.lua` sets them again for standalone Lua contexts

### vim-plug Specifics
- Plugins install to `stdpath('data') . '/plugged'` (usually `~/.local/share/nvim/plugged/`)
- First launch auto-downloads `autoload/plug.vim` if missing
- After adding a new `Plug` line, user must run `:PlugInstall` inside Neovim
- No lockfile or lazy-loading — all plugins load at startup

## Custom Plugin: `kimi_usage`

**Location**: `nvim/lua/plugins/kimi_usage.lua`

A floating-window dashboard that polls `api.kimi.com/coding/v1/usages` every 2 minutes and shows ASCII progress bars for API quota usage.

- **Requires** `KIMI_API_TOKEN` env var or `g:kimi_api_token`
- Uses `vim.fn.timer_start()` with `vim.schedule()` for async UI updates
- Window management uses `nvim_open_win`/`nvim_create_buf` with `style = "minimal"`
- Returns a module `M` with exported functions: `start()`, `stop()`, `toggle()`, `fetch()`, `show()`, `hide()`
- If modifying: ensure `state.buf`/`state.win` validity checks use `nvim_buf_is_valid` / `nvim_win_is_valid`

## Keymaps to Know

| Prefix | Domain |
|--------|--------|
| `<leader>e` / `<leader>E` | NvimTree (file explorer) |
| `<leader>f*` | Telescope (finder) |
| `<leader>b*` | Buffers |
| `<leader>s*` | Splits |
| `<leader>t*` | Tabs |
| `<leader>g*` | Git (gitsigns) |
| `<leader>x*` | Trouble (diagnostics) |
| `<leader>C*` | Codock (Crush AI CLI) |
| `<leader>q*` | Session (persistence) |
| `gd`, `gr`, `K`, `<leader>rn` | LSP |
| `s` / `S` | Flash (jump / treesitter) |

**Notable gotcha**: Arrow keys are **disabled** in normal and insert mode (`<Nop>`). This is intentional for Vim muscle-memory training.

## LSP & Tooling Setup

- **Mason** (`:Mason`) installs LSP servers, linters, formatters
- **mason-lspconfig** bridges Mason installs to `lspconfig`
- **Pre-configured LSP servers**: `lua_ls`, `tsserver`, `html`, `cssls`, `jsonls`, `pyright`, `gopls`, `rust_analyzer`
- **null-ls** provides formatting/linting: prettier, stylua, black, gofmt, rustfmt, eslint_d
- **Completion**: nvim-cmp with sources LSP → LuaSnip → buffer → path
- **Lua LSP** has special settings: `diagnostics.globals = { "vim" }`, `checkThirdParty = false`

## Autocommands (autocmds.lua)

Worth knowing before adding new ones:

- `TextYankPost` → highlight yanked text for 200ms
- `FocusGained`/`BufEnter` → `checktime` (auto-reload external changes)
- `BufReadPost` → restore cursor to last position
- `BufWritePre` → auto-create parent directories
- `FileType` for qf/help/man/etc → map `q` to close, unlist buffer
- `BufEnter` → remove `cro` from `formatoptions` (disable auto-comment on new line)
- `BufReadPre` → **big file optimization** (>1MB): disable undo, swapfile, foldmethod=manual
- `TermOpen` → disable line numbers, enter insert mode

## Style & Indentation

- **Indent**: 4 spaces (`tabstop=4`, `shiftwidth=4`, `expandtab`)
- **Colorcolumn**: 100
- **Theme**: catppuccin/mocha with transparent_background=false
- **Icons**: nvim-web-devicons; use nerdfont-compatible terminal
- **Comments**: Russian, `--` for Lua, `"` for Vimscript

## Docs & HTML Cheat Sheet

- `docs/keymaps.md` and `docs/plugins.md` are **hand-maintained** — they do not auto-generate from config
- `vim-cheatsheet.html` is a standalone printable page; if you add major keymaps, update the HTML too
- The HTML footer incorrectly says "lazy.nvim" — should say "vim-plug" if you edit it

## Installation Workflow

The repo includes `install.sh` at the root. It symlinks `~/.config/nvim` to the `nvim/` subdirectory inside the repo, keeping docs, HTML cheat sheet, and repo metadata outside the Neovim config path.

- `install.sh` is executable and interactive — asks before backing up an existing `~/.config/nvim`
- **Auto-installs system deps** on Ubuntu/Debian (`apt`) and Arch-based distros including CachyOS (`pacman`)
- Installs: neovim, git, curl, build tools, ripgrep, fd, nodejs/npm, python3/pip, unzip, wget
- On Debian/Ubuntu creates `/usr/local/bin/fd` symlink because the package binary is named `fdfind`
- Verifies Neovim ≥ 0.9 via version comparison
- Backups get a `.bak.<timestamp>` suffix
- If the symlink already points to the correct path, it exits gracefully

## No Build/Test System

This is a pure configuration repo. There is no `package.json`, `Makefile`, CI, or test suite. "Testing" means opening Neovim and verifying:

1. No errors on startup (`:messages`)
2. `:checkhealth` passes for relevant providers
3. `:PlugInstall` / `:PlugUpdate` succeed
4. `:TSUpdate` installs parsers
5. `:Mason` shows installed LSP servers
