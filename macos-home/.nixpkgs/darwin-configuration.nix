{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.macvim
      pkgs.ansible
      pkgs.asciinema
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.autojump
      pkgs.awscli
      pkgs.bash
      pkgs.bat
      pkgs.bfg-repo-cleaner
      pkgs.curl
      pkgs.docker
      pkgs.emacs-all-the-icons-fonts
      pkgs.emacsMacport
      pkgs.fd
      pkgs.fzf
      pkgs.gcc10
      pkgs.gdb
      pkgs.git
      pkgs.gnupg
      pkgs.gnutls
      pkgs.go
      pkgs.htop
      pkgs.jq
      pkgs.lua
      pkgs.lynx
      pkgs.man-db
      pkgs.minio
      pkgs.ncdu
      pkgs.neofetch
      pkgs.neovim
      pkgs.nodejs
      pkgs.nmap
      pkgs.nox
      pkgs.openssh
      pkgs.openssl
      pkgs.packer
      pkgs.perl
      pkgs.pinentry_mac
      pkgs.powershell
      pkgs.python39
      pkgs.ranger
      pkgs.rclone
      pkgs.restic
      pkgs.ripgrep
      pkgs.ruby
      pkgs.silver-searcher
      pkgs.skhd
      pkgs.source-code-pro
      pkgs.spacebar
      pkgs.sqlite
      pkgs.stow
      pkgs.terraform
      pkgs.tmux
      pkgs.tmuxinator
      pkgs.tree
      pkgs.vagrant
      pkgs.wget
      pkgs.wireguard-go
      pkgs.wireguard-tools
      pkgs.xquartz
      pkgs.yabai
      pkgs.yarn
      pkgs.youtube-dl
      pkgs.unzip
      pkgs.zsh
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # LamT: for xquartz
  nixpkgs.config.allowUnfree = true;
}
