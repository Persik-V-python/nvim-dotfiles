#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# Определение дистрибутива
# ═══════════════════════════════════════════════════════════════
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif command -v lsb_release &>/dev/null; then
        lsb_release -is | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

# ═══════════════════════════════════════════════════════════════
# Установка зависимостей
# ═══════════════════════════════════════════════════════════════
install_deps() {
    echo "🔧 Установка системных зависимостей ($DISTRO)..."

    case "$DISTRO" in
        ubuntu|debian|pop)
            sudo apt-get update
            sudo apt-get install -y \
                neovim git curl \
                build-essential \
                ripgrep \
                fd-find \
                nodejs npm \
                python3 python3-pip \
                unzip wget
            # fd-find на Debian/Ubuntu ставится как fdfind, делаем symlink
            if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
                sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
            fi
            ;;

        arch|manjaro|endeavouros|cachyos)
            sudo pacman -Syu --noconfirm
            sudo pacman -S --needed --noconfirm \
                neovim git curl base-devel \
                ripgrep fd \
                nodejs npm \
                python python-pip \
                unzip wget
            ;;

        *)
            echo "⚠️  Неизвестный дистрибутив: $DISTRO"
            echo "   Установите зависимости вручную:"
            echo "   - neovim (0.9+), git, curl"
            echo "   - make, gcc, g++ (build tools)"
            echo "   - ripgrep, fd"
            echo "   - nodejs, npm"
            echo "   - python3, pip"
            echo "   - unzip, wget"
            read -rp "   Продолжить без установки зависимостей? [y/N]: " answer
            [[ "$answer" =~ ^[Yy]$ ]] || exit 1
            ;;
    esac

    echo "✅ Зависимости установлены"
}

# ═══════════════════════════════════════════════════════════════
# Проверка версии Neovim
# ═══════════════════════════════════════════════════════════════
check_nvim_version() {
    if ! command -v nvim &>/dev/null; then
        echo "❌ Neovim не найден после установки"
        exit 1
    fi

    local version
    version=$(nvim --version | head -n1 | grep -oP '\d+\.\d+' | head -n1)
    # Сравнение версий через sort -V
    if printf '%s\n%s\n' "0.9" "$version" | sort -V -C; then
        echo "✅ Neovim $version — OK"
    else
        echo "⚠️  Neovim $version слишком старый, нужен 0.9+"
        echo "   Обновите вручную: https://github.com/neovim/neovim/releases"
        exit 1
    fi
}

# ═══════════════════════════════════════════════════════════════
# Символическая ссылка ~/.config/nvim
# ═══════════════════════════════════════════════════════════════
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
NVIM_SRC="$REPO_DIR/nvim"
NVIM_DST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

link_config() {
    if [[ ! -d "$NVIM_SRC" ]]; then
        echo "❌ Ошибка: папка nvim/ не найдена в $REPO_DIR"
        exit 1
    fi

    mkdir -p "$(dirname "$NVIM_DST")"

    if [[ -e "$NVIM_DST" || -L "$NVIM_DST" ]]; then
        if [[ -L "$NVIM_DST" && "$(readlink "$NVIM_DST")" == "$NVIM_SRC" ]]; then
            echo "✅ Символическая ссылка уже настроена: $NVIM_DST -> $NVIM_SRC"
            return 0
        fi

        echo "⚠️  Обнаружен существующий ~/.config/nvim"
        read -rp "Создать резервную копию (.bak) и заменить символической ссылкой? [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            mv "$NVIM_DST" "$NVIM_DST.bak.$(date +%s)"
            echo "📦 Резервная копия создана"
        else
            echo "❌ Установка отменена"
            exit 1
        fi
    fi

    ln -s "$NVIM_SRC" "$NVIM_DST"
    echo "✅ Конфигурация: $NVIM_DST -> $NVIM_SRC"
}

# ═══════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════
echo "═══════════════════════════════════════════════════════════════"
echo "  Установщик Neovim конфигурации"
echo "  Дистрибутив: $DISTRO"
echo "═══════════════════════════════════════════════════════════════"
echo ""

read -rp "Установить системные зависимости? [Y/n]: " deps_answer
if [[ ! "$deps_answer" =~ ^[Nn]$ ]]; then
    install_deps
    check_nvim_version
fi

link_config

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  ✅ Установка завершена"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Следующие шаги:"
echo "  1. Запустите Neovim — vim-plug установится автоматически"
echo "  2. Выполните :PlugInstall"
echo "  3. Выполните :Mason и установите нужные LSP-серверы"
echo "  4. Выполните :TSUpdate"
echo ""
echo "Опционально (языковые серверы):"
echo "  - Rust:  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
echo "  - Go:    sudo pacman -S go  (Arch)  или  sudo apt install golang-go  (Ubuntu)"
echo ""
