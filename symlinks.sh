#!/bin/bash

# sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm fastfetch hyprlock hyprpaper kitty rofi waybar zsh zoxide
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols

setup_dotfiles() {
    DOTFILES_DIR="$HOME/.dotfiles"
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    if [ -d "$DOTFILES_DIR" ]; then
        echo "Backing up existing .dotfiles directory..."
        mv "$DOTFILES_DIR" "${DOTFILES_DIR}-old"
    fi

    echo "Creating new .dotfiles directory..."
    mkdir -p "$DOTFILES_DIR"

    echo "Copying files and directories to .dotfiles..."
    cp -r "$SCRIPT_DIR"/* "$DOTFILES_DIR/"
}

setup_dotfiles

# ------------------------ #
# ------ HYPR FILES ------ #
# ------------------------ #

HYPR_HOME="$HOME/.config/hypr"
HYPR_DOT="$HOME/.dotfiles/hypr"

if [ ! -d "$HYPR_HOME" ]; then
    echo "Directory $HYPR_HOME does not exist. Creating it now."
    mkdir -p "$HYPR_HOME"
fi

if [ -d "$HYPR_HOME" ]; then
    for DOT_FILE in "$HYPR_DOT"/*; do
        if [ -f "$DOT_FILE" ]; then
            HOME_FILE="$HYPR_HOME/$(basename "$DOT_FILE")"

            if [ -f "$HOME_FILE" ]; then
                echo "Backing up existing file: $HOME_FILE"
                mv "$HOME_FILE" "$HOME_FILE.old"
            fi

            echo "Creating symlink for: $(basename "$DOT_FILE")"
            ln -s "$DOT_FILE" "$HOME_FILE"
        fi
    done
fi

# -------------------------- #
# ------ WAYBAR FILES ------ #
# -------------------------- #

WAYBAR_HOME="$HOME/.config/waybar"
WAYBAR_DOT="$HOME/.dotfiles/waybar"

if [ ! -d "$WAYBAR_HOME" ]; then
    echo "Directory $WAYBAR_HOME does not exist. Creating it now."
    mkdir -p "$WAYBAR_HOME"
fi

if [ -d "$WAYBAR_HOME" ]; then
    for DOT_FILE in "$WAYBAR_DOT"/*; do
        if [ -f "$DOT_FILE" ]; then
            HOME_FILE="$WAYBAR_HOME/$(basename "$DOT_FILE")"

            if [ -f "$HOME_FILE" ]; then
                echo "Backing up existing file: $HOME_FILE"
                mv "$HOME_FILE" "$HOME_FILE.old"
            fi

            echo "Creating symlink for: $(basename "$DOT_FILE")"
            ln -s "$DOT_FILE" "$HOME_FILE"
        fi
    done
fi

# ------------------------ #
# ------ ROFI FILES ------ #
# ------------------------ #

kitty --hold bash -c "git clone --depth=1 https://github.com/adi1090x/rofi.git && chmod +x rofi/setup.sh && ./rofi/setup.sh"

ROFI_HOME="$HOME/.config/rofi"
ROFI_DOT="$HOME/.dotfiles/rofi"

if [ ! -d "$ROFI_HOME" ]; then
    echo "Directory $ROFI_HOME does not exist. Creating it now."
    mkdir -p "$ROFI_HOME"
fi

create_symlink() {
    local src_file="$1"
    local dest_file="$2"

    if [ -f "$dest_file" ]; then
        echo "Backing up existing file: $dest_file"
        mv "$dest_file" "$dest_file.old"
    fi

    echo "Creating symlink for: $(basename "$src_file")"
    ln -s "$src_file" "$dest_file"
}

COLORS_DIR="$ROFI_DOT/colors"
if [ -d "$COLORS_DIR" ]; then
    mkdir -p "$ROFI_HOME/colors"
    mkdir -p "$ROFI_HOME/launchers/type-1/shared"
    mkdir -p "$ROFI_HOME/powermenu/type-1/shared"

    for color_file in "$COLORS_DIR"/*; do
        if [ -f "$color_file" ]; then
            if [[ "$(basename "$color_file")" == "ondark-custom.rasi" ]]; then
                create_symlink "$color_file" "$ROFI_HOME/colors/$(basename "$color_file")"
            elif [[ "$(basename "$color_file")" == "colors.rasi" ]]; then
                create_symlink "$color_file" "$ROFI_HOME/launchers/type-1/shared/$(basename "$color_file")"
                create_symlink "$color_file" "$ROFI_HOME/powermenu/type-1/shared/$(basename "$color_file")"
            fi
        fi
    done
fi

LAUNCHERS_DIR="$ROFI_DOT/launchers"
if [ -d "$LAUNCHERS_DIR" ]; then
    mkdir -p "$ROFI_HOME/launchers/type-1"

    for launcher_file in "$LAUNCHERS_DIR"/*; do
        if [ -f "$launcher_file" ]; then
            create_symlink "$launcher_file" "$ROFI_HOME/launchers/type-1/$(basename "$launcher_file")"
        fi
    done
fi

POWERMENU_DIR="$ROFI_DOT/powermenu"
if [ -d "$POWERMENU_DIR" ]; then
    mkdir -p "$ROFI_HOME/powermenu/type-1"

    for powermenu_file in "$POWERMENU_DIR"/*; do
        if [ -f "$powermenu_file" ]; then
            create_symlink "$powermenu_file" "$ROFI_HOME/powermenu/type-1/$(basename "$powermenu_file")"
        fi
    done
fi

# ------------------------------- #
# ------ KITTY / ZSH FILES ------ #
# ------------------------------- #

KITTY_HOME="$HOME/.config/kitty"
KITTY_DOT="$HOME/.dotfiles/kitty"

if [ ! -d "$KITTY_HOME" ]; then
    echo "Directory $KITTY_HOME does not exist. Creating it now."
    mkdir -p "$KITTY_HOME"
fi

if [ -d "$KITTY_HOME" ]; then
    for DOT_FILE in "$KITTY_DOT"/*; do
        if [ -f "$DOT_FILE" ]; then
            HOME_FILE="$KITTY_HOME/$(basename "$DOT_FILE")"

            if [ -f "$HOME_FILE" ]; then
                echo "Backing up existing file: $HOME_FILE"
                mv "$HOME_FILE" "$HOME_FILE.old"
            fi

            echo "Creating symlink for: $(basename "$DOT_FILE")"
            ln -s "$DOT_FILE" "$HOME_FILE"
        fi
    done
fi

kitty --hold bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

OH_ZSH_HOME="$HOME"
OH_ZSH_DOT="$HOME/.dotfiles/zsh"

declare -A files=(
    [".zshrc"]="$OH_ZSH_HOME"
    ["bira-custom.zsh-theme"]="$OH_ZSH_HOME/.oh-my-zsh/themes"
)

for FILE in "${!files[@]}"; do
    SOURCE_FILE="$OH_ZSH_DOT/$FILE"
    DEST_DIR="${files[$FILE]}"
    DEST_FILE="$DEST_DIR/$FILE"

    if [ -f "$SOURCE_FILE" ]; then
        if [ -d "$DEST_DIR" ]; then
            if [ -f "$DEST_FILE" ]; then
                echo "Backing up existing file: $DEST_FILE"
                mv "$DEST_FILE" "$DEST_FILE.old"
            fi

            echo "Creating symlink for: $FILE"
            ln -sf "$SOURCE_FILE" "$DEST_FILE"
        else
            echo "Destination directory $DEST_DIR does not exist."
        fi
    else
        echo "Source file $SOURCE_FILE does not exist."
    fi
done