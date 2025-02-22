#!/bin/bash
# This script configures your terminal prompt with colors and Git repository status.
# It writes the configuration to ~/.bash_terminal and ensures that it’s sourced in your ~/.bashrc.
# After running this script, please restart your terminal or run "source ~/.bashrc" for changes to take effect.

PROMPT_FILE=~/.bash_terminal

cat << 'EOF' > "$PROMPT_FILE"
# Terminal prompt configuration with colors and Git repository info

# Define ANSI color codes using ANSI-C quoting so escape sequences are interpreted.
RED=$'\e[0;31m'
GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
BLUE=$'\e[0;34m'
PURPLE=$'\e[0;35m'
CYAN=$'\e[0;36m'
WHITE=$'\e[0;37m'
NC=$'\e[0m'

# Function to display Git repository info:
# - Shows the current branch and the number of commits ahead of the upstream branch.
git_info() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if git rev-parse --abbrev-ref @{u} > /dev/null 2>&1; then
      ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    else
      ahead=0
    fi
    # Wrap escape sequences in \[ and \] so bash knows they are non-printing.
    echo "${PURPLE}[${branch}|${ahead}]${NC} "
  fi
}

# Set the prompt.
# The username@hostname is in green, the working directory in blue,
# and Git info (if any) in purple.
export PS1="\[${GREEN}\]\u@\h\[${NC}\]:\[${CYAN}\]\w\[${NC}\] \$(git_info)> "
EOF

echo "Terminal prompt configuration written to $PROMPT_FILE."

# Ensure that the prompt configuration is sourced in ~/.bashrc
if ! grep -q "source ~/.bash_terminal" ~/.bashrc; then
  cat << 'EOF' >> ~/.bashrc

# Source custom terminal prompt configuration if available
if [ -f ~/.bash_terminal ]; then
    source ~/.bash_terminal
fi
EOF
  echo "Added terminal prompt sourcing block to ~/.bashrc."
else
  echo "Terminal prompt sourcing already configured in ~/.bashrc."
fi

echo "Configuration complete. Please restart your terminal or run 'source ~/.bashrc' to apply changes."
