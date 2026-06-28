#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# Configurable values. Override before running, e.g.:
#   GIT_NAME="Your Name" EMAIL="you@example.com" ./setup-dev.sh
# ----------------------------------------------------------------------
GIT_NAME="${GIT_NAME:-themoddedcube}"
EMAIL="${EMAIL:-themoddedcube@gmail.com}"
NODE_MAJOR="${NODE_MAJOR:-22}"   # Node.js LTS major version to install

echo "== Updating packages =="
sudo apt-get update
sudo apt-get install -y curl git tmux openssh-client ca-certificates

echo "== Setting Git identity =="
git config --global user.name "$GIT_NAME"
git config --global user.email "$EMAIL"

echo "== Generating GitHub SSH key =="
mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N ""
else
  echo "SSH key already exists, skipping."
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519 || true

echo
echo "== COPY THIS SSH KEY TO GITHUB =="
cat ~/.ssh/id_ed25519.pub
echo
echo "Go to:"
echo "GitHub -> Settings -> SSH and GPG keys -> New SSH key"
echo

echo "== Installing Node.js ${NODE_MAJOR} (LTS) =="
# Remove any older / distro-provided Node that conflicts with the NodeSource
# package (the classic "dpkg: error processing" / unmet-dependency failure).
sudo apt-get remove -y nodejs npm libnode-dev 2>/dev/null || true
sudo apt-get autoremove -y 2>/dev/null || true
curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
sudo apt-get install -y nodejs
echo "Installed Node $(node -v) / npm $(npm -v)"

echo "== Installing Claude Code (native installer) =="
# The native installer ships a self-contained binary in ~/.local/bin and
# auto-updates itself. It does NOT need Node.js or npm, which avoids the
# npm global-permission (EACCES) errors the old npm install hit.
curl -fsSL https://claude.ai/install.sh | bash

# Make sure the native install dir is on PATH for future shells.
if ! grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.local/bin:$PATH"

echo "== Adding 'claude dsp' shortcut =="
# Lets you type:   claude dsp
# instead of:      claude --dangerously-skip-permissions
# Any extra args after "dsp" are passed straight through.
if ! grep -qF "claude dsp shortcut" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

# claude dsp shortcut -> claude --dangerously-skip-permissions
claude() {
  if [ "${1:-}" = "dsp" ]; then
    shift
    command claude --dangerously-skip-permissions "$@"
  else
    command claude "$@"
  fi
}
EOF
fi

echo "== Enabling tmux mouse support =="
touch "$HOME/.tmux.conf"

if ! grep -qxF "set -g mouse on" "$HOME/.tmux.conf"; then
  echo "set -g mouse on" >> "$HOME/.tmux.conf"
fi

if [ -n "${TMUX:-}" ]; then
  tmux source-file "$HOME/.tmux.conf"
fi

echo
echo "== Setup Complete =="
echo
echo "GitHub SSH key:"
cat "$HOME/.ssh/id_ed25519.pub"
echo
echo "Test GitHub SSH with:"
echo "  ssh -T git@github.com"
echo
echo "Reload shell with:"
echo "  source ~/.bashrc"
echo
echo "Start Claude with:"
echo "  claude"
echo
echo "Or skip permission prompts with:"
echo "  claude dsp"
echo
