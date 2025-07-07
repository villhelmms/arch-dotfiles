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

if [ ! -d "$KITTY_HOME" ]; then
    echo "Directory $KITTY_HOME does not exist. Creating it now."
    mkdir -p "$KITTY_HOME"
fi

KITTY_HOME="$HOME/.config/kitty"
KITTY_DOT="$HOME/.dotfiles/kitty"

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

# if [ "$SHELL" != "$(which zsh)" ]; then
#     echo "Changing default shell to zsh..."
#     chsh -s "$(which zsh)"

#     echo "Default shell changed to zsh. Please log out and log back in for the changes to take effect."
# else
#     echo "The default shell is already set to zsh."
# fi

kitty --hold -c "sh -c '$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'"

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
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