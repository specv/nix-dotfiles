{ config, pkgs, lib, ... }:

let

  fzf = self: super: {
    fzf = super.fzf.overrideAttrs (oldAttrs: rec {
      src = super.fetchFromGitHub {
        owner = "specv";
        repo = "fzf";
        rev = "9e766ecc22a96da50cf6f9bba2b0acbaba2f4341";
        sha256 = "sha256-tI5s4tq4O6j0NZjECpZQSVqYsGzA2Yzz7MQz9yXdws8=";
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
    python2
    ## a functional, meta-programming aware language built on top of the Erlang VM
    elixir
    ## programming language used for massively scalable soft real-time systems
    erlang
    ## event-driven I/O framework for the V8 JavaScript engine
    nodejs

    # Terminal
    ## a modern, hackable, featureful, OpenGL based terminal emulator
    #kitty
    ## a cross-platform, GPU-accelerated terminal emulator
    #alacritty

    # Package Manager
    ## Fast, reliable, and secure dependency management for javascript
    yarn
    ## Install and Run Python Applications in Isolated Environments
    python39Packages.pipx

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
    (nerdfonts.override { fonts = [ "JetBrainsMono"]; })

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
    ## proxifier for SOCKS proxies
    #pkgsUnstable.proxychains-ng

    # Command Runner
    ## a command runner and partial replacement for `make`
    pkgsUnstable.just
    ## task management & automation tool
    doit

    # Theme
    ## a minimal, blazing fast, and extremely customizable prompt for any shell
    #starship 
    ## colorize paths using LS_COLORS
    lscolors
    ## a themeable LS_COLORS generator
    vivid

    # Editor / Text Proceesor
    ## vim text editor fork focused on extensibility and agility
    #neovim
    ## the extensible, customizable GNU text editor
    emacs
    ## a utility that combines the usability of The Silver Searcher with the raw speed of `grep`
    ripgrep
    ## a simple, fast and user-friendly alternative to `find`
    fd
    ## ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc
    ripgrep-all
    ## a program that allows you to count your code, quickly
    tokei
    ## cat clone
    bat
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batwatch
    bat-extras.batdiff
    bat-extras.prettybat
    #bat-extras.batpipe

    # vcs
    ## distributed version control system
    #git
    ## simple terminal UI for git commands
    lazygit 
    ## a syntax-highlighting pager for git
    delta
    ## a diff that understands syntax
    difftastic

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
    ## command-line benchmarking tool
    hyperfine
    ## a better 'df' alternative
    duf
    ## a more intuitive version of `du` in rust
    dust
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
    #z-lua
    ## a command-line fuzzy finder written in Go
    #fzf
    ## a shell extension that manages your environment
    direnv
    ## Bourne-Again Shell
    #bash
    ## The Z shell
    #zsh
    ## a lightweight and flexible command-line JSON processor
    jq
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
    ## command line version of The Unarchiver
    unar
    ## Web app for Calibre
    calibre-web
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
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/.ideavimrc;
    ".config" = {
      source = ../dotfiles/.config;
      recursive = true;
    };
    ".emacs.d" = {
      source = pkgs.fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "b3e67aafe2451ca91e2d310d29879616e10981d0";
        sha256 = "sha256-q+LYBpHyiqe1kmLUlgewjxys94O1okfnhrcYYFHCB8Q=";
      };
      recursive = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        scrollHeight = 10;
        showFileTree = false;
        expandFocusedSidePanel = false;
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
      rl  = "reflog --pretty='%Cred%h%Creset -%C(auto)%d%Creset %gs %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      s   = "status";
      sh  = "show";
    };
    ignores = [
      # git
      ".git"
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
        # use `n` and `N` to move between diff sections
        navigate = true;
      };
      diff = {
        tool = "bcomp";
        colorMoved = "default";
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
    enableSyntaxHighlighting = true;
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

      # like `batman`, used in case like `git checkout --help`
      MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'";
    };
    initExtra = ''
      # profile
      source ~/.bash_profile

      # bindkey
      bindkey          '^K'  up-line-or-search
      bindkey          '^J'  down-line-or-search
      bindkey          '^F'  autosuggest-accept
      bindkey          '^G'  autosuggest-execute

      bindkey -M vicmd '\ef' emacs-forward-word
      bindkey -M viins '\ef' emacs-forward-word
      bindkey -M vicmd '\e.' insert-last-word
      bindkey -M viins '\e.' insert-last-word

      ## user contrib widgets
      ## https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-edit_002dcommand_002dline
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd '^x^e' edit-command-line
      bindkey -M viins '^x^e' edit-command-line

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
      ls   = "lsd -F --group-dirs first";
      la   = "l -lA";
      ll   = "l -l";
      tree = "l --tree";

      # bat
      cat     = "bat";
      man     = "batman";
      diff    = "batdiff";

      # etc
      g       = "git";
      lg      = "lazygit";
      calibre-web = "calibre-web -p ~/Documents/Calibre\\ Library/cw.db -g ~/Documents/Calibre\\ Library/gd.db";
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
      command_timeout = 100;
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
      # a file explorer tree for neovim written in lua
      nvim-tree-lua
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
      # `vidir` alternative
      # a file manager for Neovim which lets you edit your filesystem like you edit text
      (vimPlugin "elihunter173/dirbuf.nvim")
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
      font_family      = "JetBrainsMono Nerd Font Bold";
      bold_font        = "JetBrainsMono Nerd Font Extra Bold";
      italic_font      = "JetBrainsMono Nerd Font Bold Italic";
      bold_italic_font = "JetBrainsMono Nerd Font Extra Bold Italic";

      # shell
      shell_integration = "enabled";
      macos_quit_when_last_window_closed = true;
      copy_on_select = true;

      # window
      ## with Shell integration enabled, using negative values means windows sitting at a shell prompt are not counted
      confirm_os_window_close = -1;
      hide_window_decorations = true;

      # cursor
      cursor_blink_interval = 0;
    };
    keybindings = {
      # [Scrollback search](https://github.com/kovidgoyal/kitty/issues/893)
      "cmd+f"            = "show_scrollback";
      "shift+cmd+n"      = "new_os_window_with_cwd";
      "shift+ctrl+cmd+n" = "new_window_with_cwd";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      # base on Smoooooth (iTerm 2) color theme
      # https://github.com/eendroroy/alacritty-theme/blob/master/themes/smoooooth.yml
      colors = {
        primary = {
          foreground = "0xdbdbdb";
          background = "0x000000";
        };
        normal = {
          black      = "0x14191e";
          red        = "0xf92672";
          green      = "0x00c200";
          yellow     = "0xc7c400";
          blue       = "0x2743c7";
          magenta    = "0xbf3fbd";
          cyan       = "0x00c5c7";
          white      = "0xc7c7c7";
        };
        bright = {
          black      = "0x676767";
          red        = "0xfc92b8";
          green      = "0x57e690";
          yellow     = "0xece100";
          blue       = "0xa6aaf1";
          magenta    = "0xe07de0";
          cyan       = "0x5ffdff";
          white      = "0xfeffff";
        };
        cursor = {
          text       = "0x000000";
          cursor     = "0xfefffe";
        };
        selection = {
          text       = "0x000000";
          background = "0xb3d7ff";
        };
      };
      # not support ligatures yet
      ## [Support for ligatures](https://github.com/alacritty/alacritty/issues/50)
      # not support fallback fonts list yet
      ## [Font Configuration](https://github.com/alacritty/alacritty/issues/957)
      font = {
        size               = 12;
        normal.family      = "JetBrainsMono Nerd Font";
        normal.style       = "Regular";
        bold.family        = "JetBrainsMono Nerd Font";
        bold.style         = "Bold";
        italic.family      = "JetBrainsMono Nerd Font";
        italic.style       = "Italic";
        bold_italic.family = "JetBrainsMono Nerd Font";
        bold_italic.style  = "Bold Italic";
      };
      window = {
        decorations        = "None";
      };
      # see also:
      # https://github.com/alacritty/alacritty/issues/62
      key_bindings = [
        {
          key   = "F";
          mods  = "Alt";
          chars = "\\x1bf";
        }
        {
          key   = "B";
          mods  = "Alt";
          chars = "\\x1bb";
        }
        {
          key   = "Period";
          mods  = "Alt";
          chars = "\\x1b.";
        }
      ];
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens
      asvetliakov.vscode-neovim
      zhuangtongfa.material-theme  # one dark pro
      pkief.material-icon-theme
      bbenoist.nix
      jakebecker.elixir-ls
      yzhang.markdown-all-in-one
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "path-intellisense";
        publisher = "christian-kohler";
        version = "2.8.0";
        sha256 = "sha256-VPzy9o0DeYRkNwTGphC51vzBTNgQwqKg+t7MpGPLahM=";
      }
      {
        name = "intellij-idea-keybindings";
        publisher = "k--kato";
        version = "1.5.1";
        sha256 = "sha256-X+q43p455J9SHBEvin1Umr4UfQVCI8vnIkoH5/vUUJs=";
      }
    ];
    userSettings = {
      workbench.colorTheme                       = "One Dark Pro";
      workbench.iconTheme                        = "material-icon-theme";

      terminal.integrated.fontFamily             = "JetBrains Mono, Menlo, Monaco, 'Courier New', monospace";
      editor.fontFamily                          = "JetBrains Mono, Menlo, Monaco, 'Courier New', monospace";
      editor.fontSize                            = 12;
      editor.fontLigatures                       = true;
      editor.bracketPairColorization.enabled     = true;

      vscode-neovim.neovimExecutablePaths.darwin = "${pkgs.neovim}/bin/nvim";
      vscode-neovim.neovimInitPath               = "~/.config/nvim/init.vim";
    };
  };
}
