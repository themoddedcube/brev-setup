# Brev Dev Environment Setup

## Quickstart

```bash
curl -fsSL https://raw.githubusercontent.com/themoddedcube/brev-setup/main/setup-dev.sh | bash
```

One-command setup script for bootstrapping a new [Brev](https://www.brev.dev/) instance with everything needed for development.

## What It Does

- Updates system packages
- Generates an SSH key for GitHub (ed25519) and prints the public key for you to add
- Installs Node.js 20
- Installs [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Enables tmux mouse support
- Configures Git identity

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/themoddedcube/brev-setup/main/setup-dev.sh | bash
```

Or clone and run manually:

```bash
git clone git@github.com:themoddedcube/brev-setup.git
cd brev-setup
chmod +x setup-dev.sh
./setup-dev.sh
```

## After Running

1. Copy the SSH public key printed by the script
2. Add it to [GitHub SSH keys](https://github.com/settings/keys)
3. Verify with `ssh -T git@github.com`
4. Start Claude Code with `claude`
