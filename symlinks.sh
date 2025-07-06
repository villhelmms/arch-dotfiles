#!/bin/bash

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
else
    echo "Directory $HYPR_HOME does not exist."
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
else
    echo "Directory $KITTY_HOME does not exist."
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"

    echo "Default shell changed to zsh. Please log out and log back in for the changes to take effect."
else
    echo "The default shell is already set to zsh."
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete