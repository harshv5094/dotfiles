# 🔨 My Dotfiles

⚠️ Warning: Don't blindly use my setup unless you know what it is. Use it at your own risk!

## Font Dependency

Some configuration needs nerd fonts to properly show icons. You can download the font from [here](https://www.nerdfonts.com/font-downloads). I am using `JetBrainsMono Nerd Font` in my setup.

Hey, I've also created a script picker to execute some of my shell scripts. Don't worry it doesn't have any malicious code.
Just run the command below to see the magic. It also has script preview for your satisfaction.

> [!NOTE]
> This script only works in `archlinux`, I have a future plan to support it for other major distros.

```sh
curl -fsSL https://harshv5094.vercel.app/scripts.sh | sh
```

## FAQ

### My `bat` configuration is not working properly?

Sometimes, `bat` forgets to cache themes. Run the command below to fix it:

```sh
bat cache --build
```
