# zsh-supercharge

## Overview

**zsh-supercharge** is a script designed to enhance the Zsh shell experience on macOS by installing and configuring a suite of powerful plugins. These plugins provide additional completion definitions, syntax highlighting, command history suggestions, interactive directory navigation, and reminders to use Zsh features.

## Features

- **Homebrew Installation**: Checks for Homebrew and installs it if not present.
- **Git Installation**: Checks for Git and installs it if not present.
- **fzf Installation**: Installs `fzf` for command-line fuzzy finding if not already installed.
- **Automatic Backup**: Creates a backup of your existing `.zshrc` file before making any changes.
- **Rollback Support**: Includes a rollback mechanism that can undo changes if installation fails.
- **Zsh Plugin Installation**: Clones and sets up the following Zsh plugins:
  - zsh-completions: Additional completion definitions.
  - zsh-syntax-highlighting: Highlights commands as you type.
  - zsh-autosuggestions: Suggests commands based on history.
  - zsh-history-substring-search: Search command history with substring match.
  - zsh-interactive-cd: Enhanced 'cd' command with interactive features.
  - zsh-you-should-use: Reminds you to use Zsh plugins and built-in features.
  - zsh-modern-theme: A modern Zsh theme with color support and prompt customization.

## Installation

1. Clone the repository:

```sh
git clone https://github.com/BadRat-in/zsh-supercharge.git
```

2. Navigate to the project directory:

```sh
cd zsh-supercharge
```

3. Run the setup script:

```sh
source ./setup.zsh
```

The script is already executable and should be run with `source` to ensure changes are applied to your current shell session.

## Plugin Descriptions

- **zsh-completions**: Adds thousands of additional completion definitions for various commands, improving the efficiency and convenience of command completion in Zsh.

- **zsh-syntax-highlighting**: Highlights commands as you type them in the terminal, helping you spot syntax errors and understand command structure better.

- **zsh-autosuggestions**: Suggests commands based on your command history as you type, speeding up your workflow and reducing the need to retype commonly used commands.

- **zsh-history-substring-search**: Allows you to search through your command history using substring matching, making it easier to find and reuse previous commands.

- **zsh-interactive-cd**: Enhances the 'cd' command with interactive features, making directory navigation faster and more intuitive.

- **zsh-you-should-use**: Reminds you to use Zsh plugins and built-in features, encouraging you to take full advantage of Zsh's capabilities.

- **zsh-modern-theme**: A modern Zsh theme with color support and prompt customization, making the terminal more visually appealing and user-friendly.

## Configuration

The script appends the necessary configuration to your `.zshrc` file to enable the plugins. Here's the configuration added by the script:

```sh
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

# Enable zsh-you-should-use to remind you to use Zsh features
source $HOME/.zsh/zsh-you-should-use/you-should-use.zsh

# Enable zsh-modern-theme for a modern Zsh theme with Git status and command duration
source $HOME/.zsh/zsh-modern-theme/modern-theme.zsh
```

The script checks if each plugin is already configured in your `.zshrc` file before adding it, ensuring no duplicate entries are created.

## Safety Features

### Automatic Backup

Before making any changes to your `.zshrc` file, the script automatically creates a timestamped backup. This backup is stored at `$HOME/.zshrc.backup.YYYYMMDDHHMMSS`, allowing you to restore your previous configuration if needed.

### Rollback Mechanism

The script includes a comprehensive rollback mechanism that activates if any part of the installation fails. This ensures your system remains in a consistent state even if errors occur during installation. The rollback process:

1. Tracks all installed components during the installation process
2. Automatically removes installed components if an error occurs
3. Provides clear error messages to help troubleshoot issues
4. Handles special cases like Homebrew, which requires manual uninstallation

## Usage

After installation, you can immediately enjoy the enhanced features and productivity benefits provided by the plugins. Your terminal will be automatically reloaded to apply the changes.

### Syntax Highlighting

![Syntax Highlighting](./demo/syntax_highlighting.gif)

### Command History Suggestions

![History Suggestions](./demo/history_suggestions.gif)

### Interactive CD

![Interactive CD](./demo/interactive_cd.gif)

### Zsh Modern Theme

![Zsh Modern Theme](./demo/zsh_modern_theme.png)

### Zsh You Should Use

![Zsh You Should Use](./demo/zsh_you_should_use.png)

## Contributing

### Current Development Focus

We're currently working on improving the user experience during installation. Specifically, we're looking to add:

- A progress spinner during repository cloning
- Better background process handling to avoid blocking the terminal
- Enhanced error reporting

If you'd like to contribute to these or other improvements, please feel free to submit a pull request!

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the Mozilla Public License 2.0. See the [LICENSE](LICENSE) file for details.
