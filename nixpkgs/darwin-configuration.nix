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
    NSGlobalDomain = {
      # Sets the speed speed of window resizing.
      NSWindowResizeTime = "0.001";
    };
  };

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

  services.redis.enable = true;

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
    skhdConfig = builtins.readFile ~/.config/skhd/skhdrc;
  };

  # homebrew
  homebrew = {
    enable = true;
    autoUpdate = false;
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
    casks = [
      "hammerspoon" 
    ];
  };
}
