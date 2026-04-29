#!/usr/bin/env bash
set -e

GIT_NAME="themoddedcube"
EMAIL="themoddedcube@gmail.com"

echo "== Updating packages =="
sudo apt-get update
sudo apt-get install -y curl git tmux openssh-client

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

echo "== Installing Node.js 20 =="
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "== Installing Claude Code =="
npm install -g @anthropic-ai/claude-code

echo "== Enabling tmux mouse support =="
touch ~/.tmux.conf

grep -qxF "set -g mouse on" ~/.tmux.conf || echo "set -g mouse on" >> ~/.tmux.conf

if [ -n "$TMUX" ]; then
  tmux source-file ~/.tmux.conf
fi

echo "== Setting Git identity =="
git config --global user.name "$GIT_NAME"
git config --global user.email "$EMAIL"

echo
echo "== Setup Complete =="
echo "Test GitHub SSH:"
echo "ssh -T git@github.com"
echo
echo "Start Claude:"
echo "claude"
