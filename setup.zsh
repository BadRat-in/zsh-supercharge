#!/bin/zsh
#
# Copyright 2024-2025 Ravindra Singh
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Default values
ADD_SHORTCUTS=false

show_help() {
    cat << EOF
Usage: $(basename "$0") [options]

zsh-supercharge: Supercharge your Zsh with plugins, themes, and shortcuts.
Repository: https://github.com/badrat-in/zsh-supercharge

Options:
  -h            Show this help message and exit
  -s            Add shortcut key mappings (from keybinding.zsh) to your Zsh setup
EOF
}

while getopts "hs" opt; do
  case $opt in
    h)
      show_help
      exit 0
      ;;
    s)
      ADD_SHORTCUTS=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
  esac
done

shift $((OPTIND-1)) # Remove parsed options from argument list


# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Array to track installed components for rollback
installed_components=()

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Function to perform rollback if installation fails
rollback() {
    print_warning "Installation failed. Rolling back changes..."
    
    for component in "${installed_components[@]}"; do
        print_info "Rolling back: $component"
        case "$component" in
            "homebrew")
                print_info "Homebrew rollback requires manual uninstallation"
                ;;
            "git")
                brew uninstall git &>/dev/null
                ;;
            "fzf")
                brew uninstall fzf &>/dev/null
                ;;
            *)
                # For plugins, remove the directory
                if [[ -d "$component" ]]; then
                    rm -rf "$component"
                fi
                ;;
        esac
    done

    # Re-write the .zshrc file to remove added lines if both files exist
    if [ -f "$HOME/.zshrc" ] && [ -f "$zshrc_backup" ]; then
        cp "$zshrc_backup" "$HOME/.zshrc" 2>/dev/null
        rm -f "$zshrc_backup"
        print_success "Restored original .zshrc from backup."
    fi
    
    print_warning "Rollback completed. Please check the error and try again."
    exit 1
}

# Function to handle errors
_zsc_exit_with_error() {
    print_error "Failed to supercharge your terminal. An error has occurred."
    rollback
}

# Create .zsh directory if it doesn't exist
if [ ! -d "$HOME/.zsh" ]; then
    print_step "Creating .zsh directory..."
    mkdir -p "$HOME/.zsh" || _zsc_exit_with_error
fi

# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
    print_step "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || _zsc_exit_with_error

    echo >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

    installed_components+=("homebrew")
    print_success "Homebrew installed successfully."
else
    print_info "Homebrew is already installed."
fi

# Check for Git and install if not found
if ! command -v git &> /dev/null; then
    print_step "Git not found. Installing Git..."
    brew install git || _zsc_exit_with_error
    installed_components+=("git")
    print_success "Git installed successfully."
else
    print_info "Git is already installed."
fi

# Install fzf for command-line fuzzy finder if not already installed
if ! brew list fzf &> /dev/null; then
    print_step "fzf not found. Installing fzf..."
    brew install fzf || _zsc_exit_with_error
    installed_components+=("fzf")
    print_success "fzf installed successfully."
else
    print_info "fzf is already installed."
fi

# Function to clone or update a repository
clone_or_update_repo() {
    local repo_url=$1
    local target_dir=$2
    local repo_name=$(basename "$target_dir")
    
    if [ -d "$target_dir" ]; then
        print_step "Updating $repo_name..."
        rm -rf "$target_dir" || { print_error "Failed to remove existing $repo_name directory"; return 1; }
    else
        print_step "Cloning $repo_name..."
    fi

    git clone "$repo_url" "$target_dir"

    # TODO: Add spinner for better user experience and find a solution for run the progress in background
    # without displaying the pid and background task status process without blocking the terminal
    # local pid=$!

    # # Show a simple spinner while cloning
    # local spin='-\|/'
    # local i=0

    # # Wait for the clone to finish
    # wait $pid || { print_error "Failed to clone $repo_name"; return 1; }

    # while kill -0 $pid 2>/dev/null; do
    #     i=$(( (i+1) % 4 ))
    #     printf "\r${BLUE}[WORKING]${NC} %c " "${spin:$i:1}"
    #     sleep .1
    # done

    if [ $? -eq 0 ]; then
        printf "\r${GREEN}[SUCCESS]${NC} $repo_name installed successfully.\n"
        installed_components+=("$target_dir")
        return 0
    else
        printf "\r${RED}[ERROR]${NC} Failed to clone $repo_name.\n"
        print_error "Error details:"
        return 1
    fi
}

# Clone or update Zsh plugins
print_step "Setting up Zsh plugins..."

# Zsh Completions: Additional completion definitions for Zsh
clone_or_update_repo "https://github.com/zsh-users/zsh-completions.git" "$HOME/.zsh/zsh-completions" || _zsc_exit_with_error

# Zsh Syntax Highlighting: Highlights commands as you type
clone_or_update_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.zsh/zsh-syntax-highlighting" || _zsc_exit_with_error

# Zsh Autosuggestions: Suggests commands as you type based on history
clone_or_update_repo "https://github.com/zsh-users/zsh-autosuggestions.git" "$HOME/.zsh/zsh-autosuggestions" || _zsc_exit_with_error

# Zsh History Substring Search: Search command history with substring match
clone_or_update_repo "https://github.com/zsh-users/zsh-history-substring-search.git" "$HOME/.zsh/zsh-history-substring-search" || _zsc_exit_with_error

# Zsh Interactive CD: Enhanced 'cd' command with interactive features
clone_or_update_repo "https://github.com/BadRat-in/zsh-interactive-cd.git" "$HOME/.zsh/zsh-interactive-cd" || _zsc_exit_with_error

# Zsh You Should Use: Reminds you to use Zsh plugins and built-in features
clone_or_update_repo "https://github.com/BadRat-in/zsh-you-should-use.git" "$HOME/.zsh/zsh-you-should-use" || _zsc_exit_with_error

# Zsh modern theme: A modern Zsh theme with Git status and command duration
clone_or_update_repo "https://github.com/BadRat-in/zsh-modern-theme.git" "$HOME/.zsh/zsh-modern-theme" || _zsc_exit_with_error

# Create backup of .zshrc before modifications
zshrc_backup="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
cp "$HOME/.zshrc" "$zshrc_backup" 2>/dev/null
installed_components+=("zshrc_backup:$zshrc_backup")
print_info "Created backup of .zshrc at $zshrc_backup"

# Append configuration to .zshrc file
print_step "Updating .zshrc configuration..."

# Check and add zsh-completions if not present
if ! grep -q ".zsh/zsh-completions/src" "$HOME/.zshrc"; then
  print_info "Adding zsh-completions to .zshrc..."
  echo "
# Add zsh-completions to the fpath
fpath=(\$HOME/.zsh/zsh-completions/src \$fpath)" >> $HOME/.zshrc
fi

# Check and add compinit if not present
if ! grep -q "compinit" "$HOME/.zshrc"; then
  print_info "Adding completion system to .zshrc..."
  echo "
# Initialize completion system
autoload -Uz compinit && compinit" >> $HOME/.zshrc
fi

# Check and add zsh-syntax-highlighting if not present
if ! grep -q ".zsh/zsh-syntax-highlighting.zsh" "$HOME/.zshrc"; then
  print_info "Adding zsh-syntax-highlighting to .zshrc..."
  echo "
# Enable zsh-syntax-highlighting for command syntax highlighting
source \$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
fi

# Check and add zsh-modern-theme if not present
if ! grep -q ".zsh/zsh-modern-theme/modern-theme.zsh" "$HOME/.zshrc"; then
  print_info "Adding zsh-modern-theme to .zshrc..."
  echo "
# Enable zsh-modern-theme for a modern Zsh theme with Git status and command duration
source \$HOME/.zsh/zsh-modern-theme/modern-theme.zsh" >> $HOME/.zshrc
fi

# Check and add zsh-autosuggestions if not present
if ! grep -q ".zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
  print_info "Adding zsh-autosuggestions to .zshrc..."
  echo "
# Enable zsh-autosuggestions for command history suggestions
source \$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc
fi

# Check and add zsh-history-substring-search if not present
if ! grep -q ".zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" "$HOME/.zshrc"; then
  print_info "Adding zsh-history-substring-search to .zshrc..."
  echo "
# Enable zsh-history-substring-search for searching command history
source \$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" >> $HOME/.zshrc
fi

# Check and add zsh-interactive-cd if not present
if ! grep -q ".zsh/zsh-interactive-cd/zsh-interactive-cd.zsh" "$HOME/.zshrc"; then
  print_info "Adding zsh-interactive-cd to .zshrc..."
  echo "
# Enable zsh-interactive-cd for an enhanced 'cd' command experience
source \$HOME/.zsh/zsh-interactive-cd/zsh-interactive-cd.zsh" >> $HOME/.zshrc
fi

# Check and add zsh-you-should-use if not present
if ! grep -q ".zsh/zsh-you-should-use/you-should-use.zsh" "$HOME/.zshrc"; then
  print_info "Adding zsh-you-should-use to .zshrc..."
  echo "
# Enable zsh-you-should-use to remind you to use Zsh features
source \$HOME/.zsh/zsh-you-should-use/you-should-use.zsh" >> $HOME/.zshrc
fi

print_success "Your terminal has been successfully supercharged!"
print_info "Reloading .zshrc to apply changes..."

# Reload the .zshrc to apply changes
source $HOME/.zshrc > /dev/null 2>&1

# On successful reload, delete the backup file
if [ -f "$zshrc_backup" ]; then
    rm -f "$zshrc_backup"
    print_success "Backup file $zshrc_backup deleted."
else
    print_warning "Backup file $zshrc_backup not found."
fi

# Activate keyboard shortcuts if enabled
if [ "$ADD_SHORTCUTS" = true ]; then
    print_info "Applying shortcut key mappings..."
    source ./keybinding.zsh
    print_success "Shortcut mappings applied."
else
    print_info "Skipping shortcut mappings (use -s to enable)."
fi

