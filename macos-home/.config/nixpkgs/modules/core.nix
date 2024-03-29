{ config, pkgs, ... }:
let
  homeDir = "/Users/alam";
in
{
  # imports = [
  #   ./shells
  #   ./kitty
  # ];

  programs = {
    home-manager = {
      enable = true;
      path = "../home.nix";
    };
    direnv = {
      enable = true;
      # enableFishIntegration = false;
    };
    fzf.enable = true;
    gpg.enable = true;
    htop = {
      enable = true;
      showProgramPath = true;
    };
    # emacs = {
    #   enable = true;
    #   package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
    # };
    # firefox = {
    #   enable = true;
    #   # package = pkgs.Firefox; # custom overlay
    #   extensions =
    #     with pkgs.nur.repos.rycee.firefox-addons; [
    #       ublock-origin
    #       # browserpass
    #       vimium
    #     ];
    #   profiles = {
    #     home = {
    #       id = 0;
    #       settings = {
    #           "app.update.auto" = false;
    #           # "browser.startup.homepage" = "https://lobste.rs";
    #           # "browser.search.region" = "GB";
    #           # "browser.search.countryCode" = "GB";
    #           "browser.search.isUS" = false;
    #           "browser.ctrlTab.recentlyUsedOrder" = false;
    #           "browser.newtabpage.enabled" = false;
    #           "browser.bookmarks.showMobileBookmarks" = true;
    #           "browser.uidensity" = 1;
    #           "browser.urlbar.placeholderName" = "DuckDuckGo";
    #           "browser.urlbar.update1" = true;
    #           "distribution.searchplugins.defaultLocale" = "en-GB";
    #           "general.useragent.locale" = "en-GB";
    #           # "identity.fxaccounts.account.device.name" = config.networking.hostName;
    #           "privacy.trackingprotection.enabled" = true;
    #           "privacy.trackingprotection.socialtracking.enabled" = true;
    #           "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
    #           "reader.color_scheme" = "sepia";
    #           "services.sync.declinedEngines" = "addons,passwords,prefs";
    #           "services.sync.engine.addons" = false;
    #           "services.sync.engineStatusChanged.addons" = true;
    #           "services.sync.engine.passwords" = false;
    #           "services.sync.engine.prefs" = false;
    #           "services.sync.engineStatusChanged.prefs" = true;
    #           "signon.rememberSignons" = false;
    #           "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #         };
    #       # userChrome = (builtins.readFile (pkgs.substituteAll {
    #       #   name = "homeUserChrome";
    #       #   src = ../conf.d/userChrome.css;
    #       #   tabLineColour = "#2aa198";
    #       # }));
    #     };
    #   };
    # };
  };

}
