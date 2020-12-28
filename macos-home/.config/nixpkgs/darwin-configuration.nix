{ inputs, config, pkgs, ... }:
{
  imports = [
    # ./modules/darwin_modules
    ./modules/common.nix
  ];

  # environment setup
  environment = {
    # loginShell = pkgs.fish;
    pathsToLink = [ "/Applications" ];
    etc = {
      darwin.source = "${inputs.darwin}";
    };
    # systemPackages = [ ];
    extraInit = ''
      # install homebrew
      command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    '';
    variables = {
      EDITOR = "vim";
    };

  };

  # LamT: home-manager package a bit too old
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
    coreutils       # replace tools `du` so that `ranger` can call
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

  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];

  # Overlay for temporary fixes to broken packages on nixos-unstable
  nixpkgs.overlays = [
    (self: super:
      let
        # Import nixpkgs at a specified commit
        importNixpkgsRev = { rev, sha256 }:
          import (builtins.fetchTarball {
            name = "nixpkgs-src-" + rev;
            url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
            inherit sha256;
          }) {
            system = "x86_64-darwin";
            inherit (config.nixpkgs) config;
            overlays = [ ];
          };

        stable = import inputs.stable {
          system = "x86_64-darwin";
          inherit (config.nixpkgs) config;
          overlays = [ ];
        };
      in { })
  ];

  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.bash.enable = true;

  programs.nix-index.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
