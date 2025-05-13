#!/bin/zsh
#
# Copyright 2024-2025 Ravindra Singh
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Set keymap
if ! grep -qF "bindkey -e" "$HOME/.zshrc"; then
  echo "Setting up keymap..."
  echo '\n\n# Setting up keybinding to support edit shortcuts
bindkey -e' >> "$HOME/.zshrc"
fi

# FN + OPTION + DELETE (kill word)
if ! grep -qF "'[w;f' kill-word" "$HOME/.zshrc"; then
  echo "
# FN + OPTION + DELETE (kill word)
# This keybinding will delete the word after the cursor.
bindkey '\033[w;f' kill-word" >> "$HOME/.zshrc"
fi


# OPTION + DELETE (delete word before cursor)
if ! grep -qF "'[w~' backward-kill-word" "$HOME/.zshrc"; then
  echo "
# OPTION + DELETE (delete word before cursor)
# This keybinding will delete the word before the cursor.
bindkey '\033[w~' backward-kill-word" >> "$HOME/.zshrc"
fi


# FN + CTRL + DELETE (Delete whole line)
if ! grep -qF "'[l;f' kill-line" "$HOME/.zshrc"; then
  echo "
# FN + CTRL + DELETE (Delete whole line)
# This keybinding will delete the whole line after the cursor.
bindkey '\033[l;f' kill-line" >> "$HOME/.zshrc"
fi

# CTRL + DELETE (Delete whole line)
if ! grep -qF "'[l~' backward-kill-line" "$HOME/.zshrc"; then
  echo "
# CTRL + DELETE (Delete whole line)
# This keybinding will delete the whole line before the cursor.
bindkey '\033[l~' backward-kill-line" >> "$HOME/.zshrc"
fi

# Reload the .zshrc file to apply changes
source $HOME/.zshrc > /dev/null 2>&1

border=$(printf '%*s' "$COLUMNS" '' | tr ' ' '=')

# Banner and instructions for the user to set up the keybindings in their terminal app keyboard settings
cat << EOF
${border}
Keybindings for macOS Terminal

To set up these keybindings, please follow these steps:
1. Open your Terminal app.
2. Go to Terminal > Preferences > Profiles > Keyboard.
3. Click on the "+" button to add a new keybinding.
4. For each keybinding, set the "Keyboard Shortcut" to the desired key combination.
5. Set the "Action" to "Send Text" and enter the corresponding escape sequence.
6. Save the changes.

Here are the keybindings you need to set up:

1. FN + OPTION + DELETE (kill word)
  - Keyboard Shortcut: FN + OPTION + DELETE
  - Action: Send Text
  - Text: \033[w;f
  - Description: This keybinding will delete the word after the cursor.

2. OPTION + DELETE (delete word before cursor)
  - Keyboard Shortcut: OPTION + DELETE
  - Action: Send Text
  - Text: \033[w~
  - Description: This keybinding will delete the word before the cursor.

3. FN + CTRL + DELETE (Delete whole line)
  - Keyboard Shortcut: FN + CTRL + DELETE
  - Action: Send Text
  - Text: \033[l;f
  - Description: This keybinding will delete the whole line after the cursor.

4. CTRL + DELETE (Delete whole line)
  - Keyboard Shortcut: CTRL + DELETE
  - Action: Send Text
  - Text: \033[l~
  - Description: This keybinding will delete the whole line before the cursor.

${border}
EOF
