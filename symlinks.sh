#!/bin/bash

sudo pacman -S --noconfirm hyprlock hyprpaper

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

# Execute functions
check_and_install_packages
setup_dotfiles

HYPR_HOME="$HOME/.config/hypr"
HYPR_DOT="$HOME/.dotfiles/hypr"

if [ -d "$HYPR_HOME" ]; then
    for DOT_FILE in "$HYPR_DOT"/*; do 
        if [ -f "$DOT_FILE" ]; then
            HOME_FILE=$(basename "$DOT_FILE")
            if [ -f "$HYPR_HOME/$HOME_FILE" ]; then
                echo "File $HOME_FILE is in both $HYPR_DOT and $HYPR_HOME"
                mv $HYPR_HOME/$HOME_FILE $HYPR_HOME/$HOME_FILE.old
                ln -s $HYPR_DOT/$DOT_FILE $HYPR_HOME/$HOME_FILE
            fi
        fi
    done
else
    echo "Directory $HYPR_HOME does not exist."
fi