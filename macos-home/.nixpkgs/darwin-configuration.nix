{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      # source-code-pro
      ansible
      asciinema
      aspell
      aspellDicts.en
      autojump
      awscli
      bash
      bat
      bfg-repo-cleaner
      borgbackup
      coreutils
      curl
      direnv
      docker
      dotnet-sdk_5
      emacs-all-the-icons-fonts
      emacsMacport
      fasd
      fd
      fish
      fzf
      gcc10
      gdb
      git
      gnupg
      gnutls
      go
      google-cloud-sdk
      htop
      jq
      kubectl
      links
      lua
      lynx
      macvim
      man-db
      minio
      ncdu
      neofetch
      neovim
      nmap
      nodejs
      nox
      openssh
      openssl
      packer
      perl
      pinentry_mac
      powershell
      python39
      ranger
      rclone
      restic
      ripgrep
      ruby
      silver-searcher
      speedtest-cli
      sqlite
      stow
      terraform
      tasksh
      taskwarrior
      tmux
      tmuxinator
      tldr
      tree
      unzip
      vagrant
      wget
      wireguard-go
      wireguard-tools
      xquartz
      yarn
      youtube-dl
      zsh

      # tiling windows manager
      # yabai
      # skhd
      # spacebar
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
