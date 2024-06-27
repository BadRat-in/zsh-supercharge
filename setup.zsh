#!/usr/bin/env zsh
#
# Copyright 2024-2025 Ravindra Singh
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

_zsc_exit_with_error() {
    echo "Faild to supercharge your terminal some error has been occure" && exit 1
}

# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..." &&
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi &&

# Check for Git and install if not found
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing Git..." &&
    brew install git
else
    echo "Git is already installed."
fi &&

# Install fzf for command-line fuzzy finder if not already installed
if ! brew list fzf &> /dev/null; then
    echo "fzf not found. Installing fzf..." &&
    brew install fzf
else
    echo "fzf is already installed."
fi &&

# Clone or update Zsh plugins to enhance Zsh shell experience
# Zsh Completions: Additional completion definitions for Zsh
if [ -d "$HOME/.zsh/zsh-completions" ]; then
    echo "Updating zsh-completions..." &&
    rm -rf $HOME/.zsh/zsh-completions || _zsc_exit_with_error
else
    echo "Cloning zsh-completions..."
fi &&
git clone https://github.com/zsh-users/zsh-completions.git $HOME/.zsh/zsh-completions &&

# Zsh Syntax Highlighting: Highlights commands as you type
if [ -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    echo "Updating zsh-syntax-highlighting..." &&
    rm -rf $HOME/.zsh/zsh-syntax-highlighting || _zsc_exit_with_error
else
    echo "Cloning zsh-syntax-highlighting..."
fi &&
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting &&

# Zsh Autosuggestions: Suggests commands as you type based on history
if [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "Updating zsh-autosuggestions..." &&
    rm -rf $HOME/.zsh/zsh-autosuggestions || _zsc_exit_with_error
else
    echo "Cloning zsh-autosuggestions..."
fi &&
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions &&

# Zsh History Substring Search: Search command history with substring match
if [ -d "$HOME/.zsh/zsh-history-substring-search" ]; then
    echo "Updating zsh-history-substring-search..." &&
    rm -rf $HOME/.zsh/zsh-history-substring-search || _zsc_exit_with_error
else
    echo "Cloning zsh-history-substring-search..."
fi &&
git clone https://github.com/zsh-users/zsh-history-substring-search.git $HOME/.zsh/zsh-history-substring-search &&

# Zsh Interactive CD: Enhanced 'cd' command with interactive features
if [ -d "$HOME/.zsh/zsh-interactive-cd" ]; then
    echo "Updating zsh-interactive-cd..." &&
    rm -rf $HOME/.zsh/zsh-interactive-cd || _zsc_exit_with_error
else
    echo "Cloning zsh-interactive-cd..."
fi &&
git clone https://github.com/BadRat-in/zsh-interactive-cd.git $HOME/.zsh/zsh-interactive-cd &&

# Zsh You Should Use: Reminds you to use Zsh plugins and built-in features
if [ -d "$HOME/.zsh/zsh-you-should-use" ]; then
    echo "Updating zsh-you-should-use..." &&
    rm -rf $HOME/.zsh/zsh-you-should-use || _zsc_exit_with_error
else
    echo "Cloning zsh-you-should-use..."
fi &&
git clone https://github.com/BadRat-in/zsh-you-should-use.git $HOME/.zsh/zsh-you-should-use &&

# Append configuration to .zshrc file
echo """

# Configuring Zsh plugins to supercharge the macOS Terminal app
# Add zsh-completions to the fpath
fpath=($HOME/.zsh/zsh-completions/src $fpath)

# Initialize completion system
autoload -Uz compinit && compinit

# Enable zsh-syntax-highlighting for command syntax highlighting
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable zsh-autosuggestions for command history suggestions
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable zsh-history-substring-search for searching command history
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Enable zsh-interactive-cd for an enhanced 'cd' command experience
source $HOME/.zsh/zsh-interactive-cd/zsh-interactive-cd.zsh

# Enable zsh-you-should-use to remind you to use Zsh features and plugins
source $HOME/.zsh/zsh-you-should-use/you-should-use.zsh
""" >> $HOME/.zshrc &&

# Reload the .zshrc to apply changes
source $HOME/.zshrc