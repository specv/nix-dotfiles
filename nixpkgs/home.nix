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
    # Language
    ## a high-level dynamically-typed programming language
    python3
    ## a functional, meta-programming aware language built on top of the Erlang VM
    elixir
    ## programming language used for massively scalable soft real-time systems
    erlang
    ## event-driven I/O framework for the V8 JavaScript engine
    nodejs

    # Terminal
    ## a modern, hackable, featureful, OpenGL based terminal emulator
    kitty

    # Package Manager
    ## Fast, reliable, and secure dependency management for javascript
    yarn

    # File Manager
    ## a VIM-inspired filemanager for the console
    ranger
    ## the unorthodox terminal file manager
    nnn

    # VM / Ccontainer
    ## a tool for building complete development environments
    vagrant

    # Font
    ## Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts
    ## https://nixos.wiki/wiki/Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ## a typeface made for developers
    jetbrains-mono

    # Networking
    ## Utility for bidirectional data transfer between two independent data channels
    socat
    ## transparent proxy server that works as a poor man's VPN
    sshuttle
    ## interactive communication with another host using the TELNET protocol
    telnet
    ## a CLI utility for displaying current network utilization
    bandwhich
    ## man-in-the-middle proxy
    pkgsUnstable.mitmproxy

    # Command Runner
    ## a command runner and partial replacement for `make`
    pkgsUnstable.just
    ## task management & automation tool
    doit

    # Theme
    ## a minimal, blazing fast, and extremely customizable prompt for any shell
    starship 
    ## colorize paths using LS_COLORS
    lscolors
    ## a themeable LS_COLORS generator
    vivid

    # Doc
    ## a very fast implementation of `tldr` in rust
    tealdeer
    ## an interactive cheatsheet tool for the command-line and application launchers
    navi

    # graphic
    ## terminal session recorder and the best companion of asciinema.org
    asciinema
    ## a software suite to create, edit, compose, or convert bitmap images
    imagemagick
    ## graph visualization tools
    graphviz

    # Utility
    ## a utility that combines the usability of The Silver Searcher with the raw speed of `grep`
    ripgrep
    ## ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc
    ripgrep-all
    ## a program that allows you to count your code, quickly
    tokei
    ## command-line benchmarking tool
    hyperfine
    ## a better 'df' alternative
    duf
    ## a more intuitive version of `du` in rust
    dust
    ## cat clone
    bat
    ## a modern replacement for `ls`.
    exa
    ## the next gen `ls` command
    lsd
    ## an interactive process viewer for Linux
    htop
    ## vidir, sponge, ts, parallel, see also:
    ##   https://joeyh.name/code/moreutils/ 
    ##   https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    moreutils
    ## tool for monitoring the progress of data through a pipeline
    pv
    ## the Ultimate Plumber
    up
    ## autocorrect command line errors
    thefuck
    ## slice and dice logs on the command line
    angle-grinder
    ## a new cd command that helps you navigate faster by learning your habits
    z-lua
    ## a command-line fuzzy finder written in Go
    fzf
    ## a shell extension that manages your environment
    direnv
    ## Bourne-Again Shell
    bash
    ## The Z shell
    zsh
    ## distributed version control system
    git
    ## vim text editor fork focused on extensibility and agility
    neovim
    ## a lightweight and flexible command-line JSON processor
    jq
    ## simple terminal UI for git commands
    lazygit 
    ## fast, cross-platform HTTP/2 web server with automatic HTTPS
    caddy
    ## darwin not supoort yet
    #conda
    ## simple command-line snippet manager
    pet
    ## manage complex tmux sessions easily
    tmuxinator
    ## comma runs software without installing it
    comma
    ## shell script analysis tool
    shellcheck
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
    "spacebar/spacebarrc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/spacebarrc;
    "git/alias".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/git/alias;
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

  programs.bash = {
    enable = false;
    initExtra = builtins.concatStringsSep "\n" [
      (builtins.readFile ../etc/git-alias)
    ];
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

      # vivid is a themeable LS_COLORS generator
      LS_COLORS = "$(vivid generate molokai)";
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
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
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
      status = {
        disabled = true;
        format = "[$int]($style) ";
      };
      sudo = {
        disabled = false;
        style = "bold green";
        symbol = "🧙 ";
      };
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
      l   = "!bash --rcfile ~/.config/git/alias -ic fzf-log";
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

  programs.kitty = {
    enable = true;
    # file location: `~/.config/kitty/macos-launch-services-cmdline`
    darwinLaunchOptions = [
      "--single-instance"
      "--directory ~"
    ];
    environment = {
    };
    settings = {
      # font
      font_size        = 12;
      ## List available fonts: `kitty +list-fonts --psnames`
      font_family      = "JetBrains Mono Medium";
      bold_font        = "JetBrains Mono Bold";
      italic_font      = "JetBrains Mono Italic";
      bold_italic_font = "JetBrains Mono Bold Italic";

      # shell
      shell_integration enabled

      # window
      ## with Shell integration enabled, using negative values means windows sitting at a shell prompt are not counted
      confirm_os_window_close = -1;
      hide_window_decorations = true;

      # cursor
      cursor_blink_interval = 0;
    };
    keybindings = {
      # [Scrollback search](https://github.com/kovidgoyal/kitty/issues/893)
      "cmd+f" = "show_scrollback";
    };
  };
}
