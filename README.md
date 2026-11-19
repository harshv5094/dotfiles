# 🔨 My Dotfiles

> [!WARNING]
> Don't blindly use my setup unless you know what it is. Use it at your own risk!
> Also some of my `hyprland` folders is tightly integrated with my dotfiles.

>[!IMPORTANT]
> Since I own only one laptop, I've gone back to windows for my job requirements, So my hyprland setup will be locked to `v0.55` changes, After that I don't know it'll support that or not. It'll be a while that I'll return to linux. Currently I'm using `wsl` archlinux for my terminal needs (I hate powershell, it's very rigid).

## Font Dependency

Some configuration needs nerd fonts to properly show icons. You can download the font from [here](https://www.nerdfonts.com/font-downloads). I am using `JetBrainsMono Nerd Font` in my setup.

## CI & Local Checks

Every push and pull request runs two workflows:

- **`gitleaks`** — scans commits for secrets, plus a weekly full-history scan.
- **`ci`** — Lua syntax, shell syntax, `shellcheck`, YAML lint, and a `stow` dry run.

To block secrets before they reach git history, install the local hook once:

```bash
sudo pacman -S pre-commit gitleaks
pre-commit install
```

The CI checks can also be run locally:

```bash
luac -p $(git ls-files '*.lua')        # or luac5.1 if you have lua51
yamllint .
stow -nv -t "$(mktemp -d)" .
```

## FAQ

### My `bat` configuration is not working properly?

Sometimes, `bat` forgets to cache themes. Run the command below to fix it:

```bash
bat cache --build
```
