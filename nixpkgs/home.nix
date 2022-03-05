{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.packages = with pkgs; [
    elixir
    lazygit
    neovim
    ripgrep
    z-lua
    fzf
    zsh
    python3
    socat
    tree
    vagrant
    tmuxinator
    nodejs
    yarn
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showFileTree = false;
      };
    };
  };
  programs.z-lua = {
    enable = true;
    options = [ "enhanced" "once" "fzf" "echo" ];
    enableAliases = true;
  };
  programs.zsh = {
    enable = true;
  };
}
