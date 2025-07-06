#!/bin/bash

sudo pacman -S --noconfirm hyprlock hyprpaper kitty
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
    for DOT_FILE_HYPR in "$HYPR_DOT"/*; do
        if [ -f "$DOT_FILE_HYPR" ]; then
            HOME_FILE_HYPR="$HYPR_HOME/$(basename "$DOT_FILE_HYPR")"

            if [ -f "$HOME_FILE_HYPR" ]; then
                echo "Backing up existing file: $HOME_FILE_HYPR"
                mv "$HOME_FILE_HYPR" "$HOME_FILE_HYPR.old"
            fi

            echo "Creating symlink for: $(basename "$DOT_FILE_HYPR")"
            ln -s "$DOT_FILE_HYPR" "$HOME_FILE_HYPR"
        fi
    done
else
    echo "Directory $HYPR_HOME does not exist."
fi

KITTY_HOME="$HOME/.config/hypr"
KITTY_DOT="$HOME/.dotfiles/hypr"

if [ -d "$KITTY_HOME" ]; then
    for DOT_FILE_KITTY in "$KITTY_DOT"/*; do
        if [ -f "$DOT_FILE_KITTY" ]; then
            HOME_FILE_KITTY="$KITTY_HOME/$(basename "$DOT_FILE_KITTY")"

            if [ -f "$HOME_FILE_KITTY" ]; then
                echo "Backing up existing file: $HOME_FILE_KITTY"
                mv "$HOME_FILE_KITTY" "$HOME_FILE_KITTY.old"
            fi

            echo "Creating symlink for: $(basename "$DOT_FILE_KITTY")"
            ln -s "$DOT_FILE_KITTY" "$HOME_FILE_KITTY"
        fi
    done
else
    echo "Directory $KITTY_HOME does not exist."
fi