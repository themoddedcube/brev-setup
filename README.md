# Brev Dev Environment Setup

## Quickstart

```bash
curl -fsSL https://raw.githubusercontent.com/themoddedcube/brev-setup/main/setup-dev.sh | bash
```

One-command setup script for bootstrapping a new [Brev](https://www.brev.dev/) instance with everything needed for development.

## What It Does

- Updates system packages
- Configures Git identity
- Generates an SSH key for GitHub (ed25519) and prints the public key for you to add
- Installs Node.js 22 (current LTS), removing any conflicting older Node first
- Installs [Claude Code](https://docs.anthropic.com/en/docs/claude-code) via the native installer (no npm permission headaches)
- Adds a `claude dsp` shortcut for `claude --dangerously-skip-permissions`
- Enables tmux mouse support

## Configuration

The script uses sensible defaults but you can override them with environment variables:

```bash
GIT_NAME="Your Name" EMAIL="you@example.com" NODE_MAJOR=24 ./setup-dev.sh
```

| Variable     | Default                  | Description                       |
| ------------ | ------------------------ | --------------------------------- |
| `GIT_NAME`   | `themoddedcube`          | Git `user.name`                   |
| `EMAIL`      | `themoddedcube@gmail.com`| Git `user.email` + SSH key label  |
| `NODE_MAJOR` | `22`                     | Node.js LTS major version         |

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
4. Reload your shell: `source ~/.bashrc`
5. Start Claude Code with `claude` — or `claude dsp` to skip permission prompts

## The `claude dsp` shortcut

The script adds a small shell function to `~/.bashrc` so you can type:

```bash
claude dsp
```

instead of:

```bash
claude --dangerously-skip-permissions
```

Any extra arguments after `dsp` are passed straight through, e.g. `claude dsp -p "fix the build"`.
