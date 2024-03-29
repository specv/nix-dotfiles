{ config, pkgs, ... }:

{
  nixpkgs.overlays = [

    (final: prev: {
      # yabai 4.0
      # see also: https://github.com/DieracDelta/flakes/blob/flakes/flake.nix#L343
      yabai =
        let
          buildSymlinks = prev.runCommand "build-symlinks" { } ''
            mkdir -p $out/bin
            ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
          '';
        in
        prev.yabai.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "koekeishiya";
            repo = "yabai";
            rev = "v4.0.0";
            sha256 = "sha256-rllgvj9JxyYar/DTtMn5QNeBTdGkfwqDr7WT3MvHBGI=";
          };
          buildInputs = with prev.darwin.apple_sdk.frameworks; [ Carbon Cocoa ScriptingBridge prev.xxd SkyLight ];
          nativeBuildInputs = [ buildSymlinks ];
        });

    })

  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # See also: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
  # Note that some of these changes require a logout/restart to take effect.
  system.defaults = {
    spaces = {
      # Displays have separate Spaces
      # false = each physical display has a separate space (Mac default)
      # true = one space spans across all physical displays
      # System Preferences > Mission Control > Displays have seperate Spaces
      spans-displays = false;
    };
    dock = {
      # Automatically hide and show the Dock
      autohide = true;
      # Remove the auto-hiding Dock delay
      autohide-delay = "0";
      # Remove the animation when hiding/showing the Dock
      autohide-time-modifier = "0";
      # Don’t automatically rearrange Spaces based on most recent use
      # System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use
      mru-spaces = false;
      # Don’t show recent applications in Dock
      show-recents = false;
      # Sets the speed of the Mission Control animations
      expose-animation-duration = "0.1";
      # Change minimize/maximize window effect
      mineffect = "scale";
      # Speed up Mission Control animations
      # System Preferences > Accessibility > Display > Reduce Motion
      # TODO
    };
    finder = {
      # Allow quitting of the Finder
      QuitMenuItem = true;
      # Show path bar
      ShowPathbar = true;
      # Show status bar
      ShowStatusBar = false;
      # Show hidden files by default
      AppleShowAllFiles = true;
      # Show all filename extensions
      AppleShowAllExtensions = true;
      # Disable the warning when changing a file extension
      FXEnableExtensionChangeWarning = false;
      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
      FXPreferredViewStyle = "Nlsv";
      # When performing a search, search the current folder by default
      FXDefaultSearchScope = "SCcf";
      # Display full POSIX path as Finder window title
      _FXShowPosixPathInTitle = true;
    };
    NSGlobalDomain = {
      # Sets the speed speed of window resizing.
      NSWindowResizeTime = "0.001";
    };
  };

  system.activationScripts.extraUserActivation.text = ''
    # change `Preferences...` menu default shortcut from `cmd-,` to `cmd+shift-,`
    # add entry to "Keyboard => Shortcuts => App Shortcuts"
    defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "NSGlobalDomain"
    defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Preferences..." "@$,"
  '';

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  services.nix-daemon.enable = true;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    # enable yabai's scripting-addition. SIP must be disabled for this to work.
    enableScriptingAddition = true;
    # `builtins.readFile` can't handle symbolic link, `.` == `~/.nixpkgs`
    # `.yabairc` generated from `home-manager` via `mkOutOfStoreSymlink`
    extraConfig = builtins.readFile ~/.config/yabai/yabairc;
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Shortcut
      ## alacritty
      lcmd + ctrl - t : alacritty msg create-window || open -n ${pkgs.alacritty}/Applications/Alacritty.app &> /dev/null
      ## iterm
      # lcmd + ctrl - t : open -n /Applications/iTerm.app
      ## kitty
      # lcmd + ctrl - t : ${pkgs.kitty}/Applications/kitty.app/Contents/MacOS/kitty --single-instance --directory ~ &> /dev/null

      ${builtins.readFile ~/.config/skhd/skhdrc}
    '';
  };

  services.spacebar = {
    enable = false;
    package = pkgs.spacebar;
    extraConfig = builtins.readFile ~/.config/spacebar/spacebarrc;
  };

  # homebrew
  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];
    extraConfig = ''
    '';
    brews = [
      "redis"
      "postgresql"
      # daemonless container engine for developing, managing, and running OCI Containers
      "podman"
    ];
    casks = [
      # note taking app (`Notational Velocit` alternative)
      "nvalt"
      # desktop automation app
      "hammerspoon" 
      # an archive unpacker program
      "the-unarchiver"
      # git interface focused on visual interaction
      "gitup"
      # translate & OCR
      "bob"
      # E-books management software
      "calibre"
      # rime input method engine
      "squirrel"
      # pack, ship and run any application as a lightweight container 
      # use `colima` instead until [issue](https://github.com/abiosoft/colima/issues/83) resovled
      "docker"
      # controls and monitors all fans on Apple computers
      "macs-fan-control"
      # web browser focusing on security
      "tor-browser"
      # a new command line scriptable shell for MySQL
      "mysql-shell"
    ];
  };
}
