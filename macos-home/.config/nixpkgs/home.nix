{ config, pkgs, ... }:
let
  # Handly shell command to view the dependency tree of Nix packages
  depends = pkgs.writeScriptBin "depends" ''
    dep=$1
    nix-store --query --requisites $(which $dep)
  '';

  run = pkgs.writeScriptBin "run" ''
    nix-shell --pure --run "$@"
  '';

  # Collect garbage, optimize store, repair paths
  nix-cleanup-store = pkgs.writeShellScriptBin "nix-cleanup-store" ''
    nix-collect-garbage -d
    nix optimise-store 2>&1 | sed -E 's/.*'\'''(\/nix\/store\/[^\/]*).*'\'''/\1/g' | uniq | sudo -E ${pkgs.parallel}/bin/parallel 'nix-store --repair-path {}'
  '';

  # Symlink macOS apps installed via Nix into ~/Applications
  nix-symlink-apps-macos = pkgs.writeShellScriptBin "nix-symlink-apps-macos" ''
    for app in $(find ~/Applications -name '*.app')
    do
      if test -L $app && [[ $(readlink -f $app) == /nix/store/* ]]; then
        rm $app
      fi
    done
    for app in $(find ~/.nix-profile/Applications/ -name '*.app' -exec readlink -f '{}' \;)
    do
      ln -s $app ~/Applications/$(basename $app)
    done
  '';

  # Update Homebrew pagkages/apps
  brew-bundle-update = pkgs.writeShellScriptBin "brew-bundle-update" ''
    brew update
    brew bundle --file=~/.config/nixpkgs/Brewfile
  '';

  # Remove Homebrew pakages/apps not in Brewfile
  brew-bundle-cleanup = pkgs.writeShellScriptBin "brew-bundle-cleanup" ''
    brew bundle cleanup --zap --force --file=~/.config/nixpkgs/Brewfile
  '';

  scripts = [
    depends
    run
    nix-cleanup-store
    nix-symlink-apps-macos
    brew-bundle-update
    brew-bundle-cleanup
  ];

in
{
  imports = [ ./modules/core.nix ];

  fonts.fontconfig.enable = true;

  news.display = "silent";

  home = {
    # only need these if not managed by nix-darwin
    # username = "alam";
    # homeDirectory = "/Users/alam";
    stateVersion = "20.09";
    packages = with pkgs; [
      # essential utils
      coreutils # replace tools `du` so that `ranger` can call
      curl
      findutils
      git
      gnupg
      gnutls
      tree
      stow

      # shells
      bash
      fish
      zsh

      # productivity boost
      autojump
      bat
      fasd
      fd
      fzf
      ranger
      ripgrep
      silver-searcher

      # alphabet sorted
      ansible
      asciinema
      aspell
      aspellDicts.en
      awscli
      bfg-repo-cleaner
      borgbackup
      direnv
      docker
      dotnet-sdk_5
      emacs-all-the-icons-fonts
      emacsMacport
      gcc10
      gdb
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
      pandoc
      perl
      pinentry_mac
      powershell
      python39
      rclone
      restic
      ruby
      speedtest-cli
      sqlite
      tasksh
      taskwarrior
      terraform_0_14
      tldr
      tmux
      tmuxinator
      unzip
      vagrant
      wget
      wireguard-go
      wireguard-tools
      xquartz
      yarn
      youtube-dl

      # trying new
      # cachix  # this requires to add an cachix.org item
      cmake
      exa
      httpie
      lorri     # Easy Nix shell
      rsync
      xsv       # CSV file parsing utility

      # source-code-pro

      # tiling windows manager
      # yabai
      # skhd
      # spacebar
    ] ++ scripts;
  };
}
