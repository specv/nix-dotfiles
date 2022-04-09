{ config, pkgs, ... }:

{
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
    # `builtins.readFile` can't handle symbolic link, `.` == `~/.nixpkgs`
    # `.yabairc` generated from `home-manager` via `mkOutOfStoreSymlink`
    extraConfig = builtins.readFile ../.yabairc;
  };

  services.skhd.enable = true;

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
