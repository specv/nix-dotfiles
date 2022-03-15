{ config, pkgs, ... }:

let
  comma = import ( pkgs.fetchFromGitHub {
      owner = "nix-community";
      repo = "comma";
      rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
      sha256 = "sha256-IT7zlcM1Oh4sWeCJ1m4NkteuajPxTnNo1tbitG0eqlg=";
  }) {};

in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.packages = with pkgs; [
    elixir
    neovim
    ripgrep
    dust
    caddy
    python3
    socat
    lsd
    bat
    pet
    ranger
    vagrant
    tmuxinator
    nodejs
    sshuttle
    yarn
    telnet
    comma
    # https://nixos.wiki/wiki/Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
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

  nixpkgs.overlays = [
    (self: super:
    {
      fzf = super.fzf.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "specv";
          repo = "fzf";
          rev = "08f0c8132ed900e19e9071ea6e2e74ad6c023715";
          sha256 = "sha256-WrBMTZ7g6Baaic86M0BRCoY18v7PUUkg3yjSsdwUrCw=";
        };
      });
    })
  ];
  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    #enableSyntaxHighlighting = true;
    sessionVariables = {
      EDITOR = "vi";
      VISUAL = "vi";

      # tmux
      TERM = "xterm-256color";

      # locale
      # make sure check iTerm2's "Set locale variables automatically" off also
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
    };
    initExtra = ''
      # profile
      source ~/.bash_profile

      # bindkey
      bindkey          '^K'  up-line-or-search
      bindkey          '^J'  down-line-or-search
      bindkey          '^F'  autosuggest-accept
      bindkey          '^G'  autosuggest-execute
    '';
    history = {
      size = 10000000;
      save = 10000000;
      ignoreDups = true;
      ignoreSpace = false;
      expireDuplicatesFirst = true;
      share = true;
      extended = true;
    };
    shellAliases = {
      # ls
      l    = "ls";
      ls   = "lsd";
      la   = "l -a";
      ll   = "l -la";
      tree = "l --tree";
      
      # git
      ga   = "git commit --amend";
      gb   = "git branch";
      gl   = "git log";
      gp   = "git pull";
      gs   = "git status";

      # etc
      vi   = "nvim";
      lg   = "lazygit";
      cat  = "bat";
    };
    #plugins = [
    #  {
    #    # will source zsh-autosuggestions.plugin.zsh
    #    name = "zsh-autosuggestions";
    #    src = pkgs.fetchFromGitHub {
    #      owner = "zsh-users";
    #      repo = "zsh-autosuggestions";
    #      rev = "v0.7.0";
    #      sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
    #    };
    #  }
    #];
    #oh-my-zsh = {
    #  enable = true;
    #  plugins = [
    #    "git"
    #    "ssh-agent"
    #  ];
    #};
    #prezto = {
    #  enable = true;
    #  caseSensitive = false;
    #  utility.safeOps = true;
    #  editor = {
    #    dotExpansion = true;
    #    keymap = "vi";
    #  };
    #  pmodules = [
    #    "autosuggestions"
    #    "completion"
    #    "directory"
    #    "editor"
    #    "git"
    #    "terminal"
    #  ];
    #};
  };

  # The conda module shows the current Conda (opens new window)environment, if $CONDA_DEFAULT_ENV is set.
  # This does not suppress conda's own prompt modifier, you may want to run conda config --set changeps1 False.
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      scan_timeout = 50;
      command_timeout = 500;
    };
  };
}
