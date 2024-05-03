{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # VCS
    ## distributed version control system
    ## git
    ## simple terminal UI for git commands
    ## lazygit 
    ## a syntax-highlighting pager for git
    delta

    # Terminal
    ## a cross-platform, GPU-accelerated terminal emulator
    ## alacritty
    ## The Z shell
    ## zsh
    ## a modern, maintained replacement for `ls`.
    eza
    ## the next gen `ls` command
    lsd
    ## a new cd command that helps you navigate faster by learning your habits
    ## z-lua
    ## a command-line fuzzy finder written in Go
    ## fzf
    ## a shell extension that manages your environment
    ## direnv

    # Theme
    ## a minimal, blazing fast, and extremely customizable prompt for any shell
    ## starship 
    ## a themeable LS_COLORS generator
    vivid
    ## colorize paths using LS_COLORS
    lscolors

    # Editor / Text Processor
    ## vim text editor fork focused on extensibility and agility
    ## neovim
    ## cat clone
    bat
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batwatch
    bat-extras.batdiff
    bat-extras.prettybat
    #bat-extras.batpipe
    ## a lightweight and flexible command-line JSON processor
    jq

    # Package Manager
    ## version manager with support for Ruby, Node.js, Erlang
    asdf-vm

    # Command Runner
    ## a command runner and partial replacement for `make`
    just
    ## task management & automation tool
    doit

    # Font
    ## Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts
    ## https://nixos.wiki/wiki/Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono"]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink ../../.ideavimrc;
    ".config" = {
      source = ../../.config;
      recursive = true;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mz/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
        edit = "$EDITOR";
        # specify a line number you are currently at when in the line-by-line mode.
        editAtLine = "{{editor}} +{{line}} {{filename}}";
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
      # nvim-ts-rainbow
      # onedark color scheme
      onedark-nvim
      # blazing fast and easy to configure Neovim statusline written in Lua
      lualine-nvim
      # smart and powerful comment plugin for neovim
      comment-nvim
      # adds indentation guides to all lines (including empty lines)
      indent-blankline-nvim
    ];
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
      mouse = {
        # the cursor is temporarily hidden when typing
        hide_when_typing   = true;
      };
      env = {
        TERM = "xterm-256color";
      };
      keyboard.bindings = [
        # workaround for inline input method, remove this after https://github.com/alacritty/alacritty/pull/5790 merged
        # see also: [macOS: unexpected characters get deleted when using backspace in Pinyin input method](https://github.com/alacritty/alacritty/issues/1606#issuecomment-579754834)
        {
          key   = "Back";
          action = "ReceiveChar";
        }
        # emacs readline key bindings
        # see also: [Allow remapping modifier keys in the config](https://github.com/alacritty/alacritty/issues/62#issuecomment-347552058)
        {
          key   = "F";
          mods  = "Alt";
          chars = "\\u001bf";
        }
        {
          key   = "B";
          mods  = "Alt";
          chars = "\\u001bb";
        }
        {
          key   = "Period";
          mods  = "Alt";
          chars = "\\u001b.";
        }
        {
          key   = "J";
          mods  = "Alt";
          chars = "\\u001bj";
        }
      ];
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";

      # locale
      # make sure check iTerm2's "Set locale variables automatically" off also
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";

      # vivid is a themeable LS_COLORS generator
      LS_COLORS = "$(~/.nix-profile/bin/vivid generate molokai)";

      # like `batman`, used in case like `git checkout --help`
      MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'";
    };
    initExtra = ''
      function portgrep() {
          {
              echo "Port,Process ID,Process Name"
              for port in "$@"; do
                  pids=$(lsof -i:$port -t)
                  for pid in $pids; do
                      name=$(ps -p $pid -o comm=)
                      echo "$port,$pid,$name"
                  done
              done
          } | column -t -s ','
      }

      function portkill() {
          {
              echo "Port,Process ID,Process Name"
              for port in "$@"; do
                  pids=$(lsof -i:$port -t)
                  for pid in $pids; do
                      name=$(ps -p $pid -o comm=)
                      echo "$port,$pid,$name"
                      kill -15 "$pid"
                  done
              done
          } | column -t -s ','
      }

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
      ## preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
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
}
