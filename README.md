# dotfiles
This is my personal dotfiles, it's not much but it's mine.

This is how I reproduce my [NixOS](https://nixos.org/) workstation.

```sh
cd .config
git clone https://github.com/dvudd/dotfiles.git
```

```sh
sudo rm -rf /etc/nixos/configuration.nix
sudo ln -s /home/david/.config/dotfiles/configuration.nix /etc/nixos/configuration.nix
```

```sh
sudo nixos-rebuild switch
```
