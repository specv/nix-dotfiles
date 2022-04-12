{ config, pkgs, lib, ... }:

let

  fzf = self: super: {
    fzf = super.fzf.overrideAttrs (oldAttrs: rec {
      src = super.fetchFromGitHub {
        owner = "specv";
        repo = "fzf";
        rev = "7c888563b8be44cbccfb9a0ba8b187a263286afa";
        sha256 = "sha256-gedt3dK7YkyBB4UvqzVHaFUCzC+9KKu35cmmNqALFE0=";
      };
    });
  };

  # python3Packages.ipython is failing on x86_64-darwin
  # https://github.com/NixOS/nixpkgs/issues/160133#issuecomment-1041327492
  # This should be fixed in #159516, which is currently in staging
  ipythonFix = self: super: {
    python3 = super.python3.override {
      packageOverrides = pySelf: pySuper: {
        ipython = pySuper.ipython.overridePythonAttrs (old: {
          preCheck = old.preCheck + super.lib.optionalString super.stdenv.isDarwin ''
            echo '#!${pkgs.stdenv.shell}' > pbcopy
            chmod a+x pbcopy
            cp pbcopy pbpaste
            export PATH="$(pwd)''${PATH:+":$PATH"}"
          '';
        });
      };
      self = self.python3;
    };
  };

  # Comma runs software without installing it.
  comma = import ( pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
    sha256 = "sha256-IT7zlcM1Oh4sWeCJ1m4NkteuajPxTnNo1tbitG0eqlg=";
  }) {};

  vimPlugin = repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = "HEAD";
    };
  };

  pkgsUnstable = import <nixpkgs-unstable> {};

in

{
  nixpkgs.overlays = [
    fzf
    ipythonFix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.packages = with pkgs; [
    elixir
    erlang
    ripgrep
    dust
    caddy
    htop
    python3
    # darwin not supoort yet
    #conda
    socat
    lsd
    exa
    bat
    pet
    ranger
    vagrant
    tmuxinator
    nodejs
    yarn
    sshuttle
    telnet
    comma
    mitmproxy
    doit
    shellcheck
    asciinema
    imagemagick
    jq
    graphviz
    # https://nixos.wiki/wiki/Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    pkgsUnstable.just
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

  home.file = {
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/ideavimrc;
  };

  xdg.configFile = {
    "nvim/lua/init.lua".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/nvim/init.lua;
    "yabai/yabairc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/yabairc;
    "skhd/skhdrc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/skhdrc;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showFileTree = false;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
      os = {
        editCommand = "$EDITOR";
        # specify a line number you are currently at when in the line-by-line mode.
        editCommandTemplate = "{{editor}} +{{line}} {{filename}}";
      };
    };
  };

  programs.z-lua = {
    enable = true;
    options = [ "enhanced" "once" "fzf" "echo" ];
    enableAliases = true;
  };

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
      EDITOR = "nvim";
      VISUAL = "nvim";

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

      # fzf-tab
      ## accept suggestion
      zstyle ':fzf-tab:*' fzf-bindings 'ctrl-f:accept'
      ## run suggestion
      zstyle ':fzf-tab:*' accept-line 'ctrl-g'
      ## unable to bind multiple keys
      #zstyle ':fzf-tab:*' accept-line 'enter'
      ## set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'
      ## switch over different groups, `tab` for next, `btab` for previous
      zstyle ':fzf-tab:*' switch-group 'btab' 'tab'
      ## preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
      ## disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      ## continuous completion (accept the result and start another completion immediately)
      zstyle ':fzf-tab:*' continuous-trigger 'space'
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
      g    = "git";
      ga   = "git commit --amend";
      gb   = "git branch";
      gd   = "git diff";
      gl   = "git log";
      gp   = "git pull";
      gs   = "git status";

      # etc
      lg   = "lazygit";
      cat  = "bat";
    };
    plugins = [
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
       {
         name = "fzf-tab";
         src = pkgs.fetchFromGitHub {
           owner = "Aloxaf";
           repo = "fzf-tab";
           rev = "8769fcbf2150fe5dad605da022036ed23c81368d";
           sha256 = "sha256-/9An/C9rDLx1WsC/yYcYPVzA6fjsddMQaBT1DMAxYSI=";
         };
       }
    ];
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

  # location: ~/.config/git
  programs.git = {
    enable = true;
    delta.enable = true;
    aliases = {
      a   = "commit --amend";
      b   = "branch";
      c   = "commit";
      d   = "diff";
      l   = "log";
      p   = "pull";
      s   = "status";
      sh  = "show";
    };
    ignores = [
      # ide
      ".idea" ".vs" ".vsc" ".vscode"
      # python
      "*.pyc" "__pycache__" ".ipynb_checkpoints"
      # mac
      ".DS_Store"
      # direnv
      ".envrc"
    ];
    extraConfig = {
      delta = {
        line-numbers = true;
      };
      diff = {
        tool = "bcomp";
      };
      difftool = {
        prompt = false;
      };
      "difftool \"bcomp\"" = {
        cmd = "/usr/local/bin/bcomp $LOCAL $REMOTE";
        trustExitCode = true;
      };
      merge = {
        tool = "bcomp";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
      };
      "mergetool \"bcomp\"" = {
        cmd = "/usr/local/bin/bcomp $LOCAL $REMOTE $BASE $MERGED";
        trustExitCode = true;
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # vim configuration files for Nix
      vim-nix
      # delete/change/add parentheses/quotes/XML-tags
      vim-surround
      # multiple cursors plugin for vim/neovim
      vim-visual-multi
      # make the yanked region apparent
      vim-highlightedyank
      # provides support for expanding abbreviations similar to emmet
      emmet-vim
      # nvim treesitter configurations and abstraction layer
      nvim-treesitter
      # rainbow parentheses using tree-sitter
      nvim-ts-rainbow
      # onedark color scheme
      onedark-nvim
      # blazing fast and easy to configure Neovim statusline written in Lua
      lualine-nvim
      # smart and powerful comment plugin for neovim
      comment-nvim
      # adds indentation guides to all lines (including empty lines)
      indent-blankline-nvim
      # cutting-edge motion plugin
      (vimPlugin "ggandor/lightspeed.nvim")
      # syntax highlighting for Justfiles
      (vimPlugin "NoahTheDuke/vim-just")
    ];
    extraConfig = ''
      " load ~/.config/nvim/lua/init.lua
      lua require('init')
    '';
  };
}
