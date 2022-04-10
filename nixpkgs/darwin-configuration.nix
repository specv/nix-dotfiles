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
