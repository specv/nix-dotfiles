{ config, pkgs, lib, ... }:

let

  vimPlugin = repo: pkgs.vimUtils.buildVimPlugin {
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

    # Font
    ## Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts
    ## https://nixos.wiki/wiki/Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode"]; })

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
    ## A modern, hackable, featureful, OpenGL based terminal emulator
    ## kitty
    ## The Z shell
    ## zsh
    # a terminal workspace with batteries included
    zellij
    ## a modern, maintained replacement for `ls`, formerly known as `exa`
    eza
    ## the next gen `ls` command
    lsd
    ## a new cd command that helps you navigate faster by learning your habits
    ## z-lua
    ## a smarter cd command.
    ## zoxide
    ## a command-line fuzzy finder written in Go
    ## fzf
    ## a shell extension that manages your environment
    ## direnv
    ## draw images on terminals
    ueberzugpp

    # Theme
    ## a minimal, blazing fast, and extremely customizable prompt for any shell
    ## starship 
    ## a themeable LS_COLORS generator
    vivid
    ## colorize paths using LS_COLORS
    lscolors
    ## source code highlighting tool
    highlight

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
    ## a utility that combines the usability of The Silver Searcher with the raw speed of `grep`
    ripgrep
    ## ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc
    ripgrep-all
    ## a simple, fast and user-friendly alternative to `find`
    fd
    ## a lightweight and flexible command-line JSON processor
    jq
    ## serializes the output of popular command line tools and filetypes to structured JSON output
    jc
    ## terminal JSON viewer
    fx

    # Multi-media (for `yazi` previewer)
    ## a complete, cross-platform solution to record, convert and stream audio and video
    ffmpeg
    ## a software suite to create, edit, compose, or convert bitmap images
    imagemagick
    ## a tool to read, write and edit EXIF meta information
    exiftool
    ## render markdown on the CLI, with pizzazz!
    glow
    ## sort for data formats such as CSV, TSV, JSON, JSON Lines
    miller # mlr
    ## conversion between documentation formats
    pandoc
    ## convert xlsx to csv
    xlsx2csv
    ## converting jupyter notebooks
    python312Packages.nbconvert
    ## a fast, easy and free BitTorrent client
    transmission_4

    # File Manager
    ## the unorthodox terminal file manager
    ## nnn
    ## blazing fast terminal file manager written in Rust, based on async I/O
    ## yazi 

    # Package Manager
    ## version manager with support for Ruby, Node.js, Erlang
    asdf-vm

    # Command Runner
    ## a command runner and partial replacement for `make`
    just
    ## task management & automation tool
    doit
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
    #".vimrc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/.vimrc;
    #".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/.ideavimrc;
    ".config" = {
      source = ../dotfiles/.config;
      recursive = true;
    };
    ".bash_profile".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/.bash_profile;
    ".condarc".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/.condarc;
    ".vimrc".source = ../dotfiles/.vimrc;
    ".ideavimrc".source = ../dotfiles/.ideavimrc;
    ".hammerspoon/init.lua".source = ../dotfiles/.hammerspoon/init.lua;
    ".hammerspoon/stackline" = {
      source = pkgs.fetchFromGitHub {
        owner = "AdamWagner";
        repo = "stackline";
        rev = "main";
        sha256 = "sha256-x7SIgKR6rwkoVVbaAvjFr1N7wTF3atni/d6xGLBBRN4=";
      };
      recursive = true;
    };
    ".fzf" = {
      source = pkgs.fetchFromGitHub {
        owner = "specv";
        repo = "fzf";
        rev = "master";
        sha256 = "sha256-tpM+ogeIVFF6oEgXLh20hhjMxqWRZa0gQoaC4kS2cNY=";
      };
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

  # ~/Library/Application\ Support/lazygit/config.yml
  programs.lazygit = {
    enable = true;
    settings = {
      # [Skip "press enter to return to lazygit"](https://github.com/jesseduffield/lazygit/discussions/1462)
      promptToReturnFromSubprocess = false;
      gui = {
        theme.selectedLineBgColor = [ "reverse" ];
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
        edit = "$EDITOR {{filename}}";
        # specify a line number you are currently at when in the line-by-line mode.
        editAtLine = "$EDITOR +{{line}} {{filename}}";
      };
    };
  };

  programs.zoxide = {
    # database path at ~/Library/Application\ Support/zoxide/db.zo
    enable = true;
  };

  programs.z-lua = {
    enable = false;
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
      # [Change position of the Time module](https://github.com/starship/starship/issues/1660)
      format = "$all$status$time$line_break$jobs$battery$os$container$shell$character";
      status = {
        disabled = false;
        format = "[$symbol$common_meaning$signal_name$maybe_int]($style) ";
        style = "bold yellow";
        symbol = "🚨";
        map_symbol = true;
      };
      sudo = {
        disabled = false;
        style = "bold green";
        symbol = "🧙 ";
      };
      time = {
        disabled = false;
        format = "at [$time]($style) ";
        style = "dimmed bold green";
      };
      line_break = {
        disabled = false;
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimdiffAlias = true;
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
      nvim-treesitter.withAllGrammars
      # adds indentation guides to all lines (including empty lines)
      indent-blankline-nvim
      # rainbow delimiters for Neovim with Tree-sitter
      rainbow-delimiters-nvim
      # onedark color scheme
      onedark-nvim
      # blazing fast and easy to configure Neovim statusline written in Lua
      lualine-nvim
      # smart and powerful comment plugin for neovim
      comment-nvim
      # neovim's answer to the mouse
      leap-nvim
      # `vidir` alternative
      # a file manager for Neovim which lets you edit your filesystem like you edit text
      dirbuf-nvim
      # syntax highlighting for Justfiles
      vim-just
      # automatically adjusts indent ('shiftwidth' and 'expandtab')
      vim-sleuth
      # auto insert matching brackets, parens, quotes
      nvim-autopairs
      # highlight colors
      nvim-highlight-colors
      # Earthfile syntax highlighting for vim
      (vimPlugin "earthly/earthly.vim")
      # open your Kitty scrollback buffer with Neovim
      (vimPlugin "mikesmithgh/kitty-scrollback.nvim")
    ];
    extraConfig = ''
      " load ~/.config/nvim/lua/init.lua
      lua require('init')
    '';
  };

  programs.nnn = {
    enable = false;
    bookmarks = {
      b = "~/.config/nnn/bookmarks";
      d = "~/Downloads";
      f = "~/Documents";
    };
    plugins = {
      src = pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "master";
        sha256 = "sha256-Jj5HWW/0zC+DRDX1JfILHhKTBm0DjxNnSS+pMkT6aw0=";
      } + "/plugins";
      mappings = {
        o = "fzcd";
        s = "finder";
        p = "preview-tui";
        z = "autojump";
        c = "cbcopy-mac";
        v = "cbpaste-mac";
      };
    };
    extraPackages = with pkgs; [
      coreutils            # for `tac`
      glow                 # render markdown
      tree                 # tree structure for directory
      mediainfo            # tag information for media file
      ffmpegthumbnailer    # video thumbnailer
      poppler              # pdf rendering library
    ];
  };

  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        linemode = "none";
        sort_dir_first = true;
      };
      preview = {
        max_width = 2000;
        max_height = 2000;
      };
      plugin = {
        prepend_previewers = [
          { name = "*/";         run = "eza-preview"; }
          { name = "*.mp3";      run = "preview"; }
          { name = "*.flac";     run = "preview"; }
          { name = "*.wav";      run = "preview"; }
          { name = "*.m4a";      run = "preview"; }
          { name = "*.json";     run = "preview"; }
          { name = "*.md";       run = "preview"; }
          { name = "*.ipynb";    run = "preview"; }
          { name = "*.dex";      run = "preview"; }
          { name = "*.apk";      run = "preview"; }
          { name = "*.csv";      run = "preview"; }
          { name = "*.tsv";      run = "preview"; }
          { name = "*.sqlite3";  run = "preview"; }
          { name = "*.sqlite";   run = "preview"; }
          { name = "*.so";       run = "preview"; }
          { name = "*.dylib";    run = "preview"; }
          { name = "*.torrent";  run = "preview"; }
          { name = "*.doc";      run = "preview"; }
          { name = "*.docx";     run = "preview"; }
          { name = "*.htm";      run = "preview"; }
          { name = "*.html";     run = "preview"; }
          { name = "*.xhtml";    run = "preview"; }
          { name = "*.rtf";      run = "preview"; }
          { name = "*.xlsx";     run = "preview"; }
          { name = "*.svg";      run = "preview"; }
          { name = "*.epub";     run = "preview"; }
          { name = "*.plist";    run = "preview"; }
          { name = "*.icns";     run = "preview"; }
          { name = "*.ipa";      run = "preview"; }
          { name = "*.dmg";      run = "preview"; }
          { name = "*.ttf";      run = "preview"; }
          { name = "*.ttc";      run = "preview"; }
          { name = "*.otf";      run = "preview"; }
          { name = "*.woff";     run = "preview"; }
          { name = "*.woff2";    run = "preview"; }
          { name = "*.cast";     run = "preview"; }
        ];
      };
    };
    keymap = {
      manager.prepend_keymap = [
        # builtins
        { on = [ "<C-c>" ]; run = "close"; desc = "Close the current tab, or quit if it is last tab"; }
        { on = [ "<C-j>" ]; run = "seek 5"; desc = "Seek up 5 units in the preview"; }
        { on = [ "<C-k>" ]; run = "seek -5"; desc = "Seek down 5 units in the preview"; }

        { on = [ "!" ]; run = ''shell "$SHELL" --block --confirm''; desc = "Open shell here"; }

        # plugins
        { on = [ "1" ]; run = "plugin --sync auto-tab --args=0"; }
        { on = [ "2" ]; run = "plugin --sync auto-tab --args=1"; }
        { on = [ "3" ]; run = "plugin --sync auto-tab --args=2"; }
        { on = [ "4" ]; run = "plugin --sync auto-tab --args=3"; }
        { on = [ "5" ]; run = "plugin --sync auto-tab --args=4"; }
        { on = [ "6" ]; run = "plugin --sync auto-tab --args=5"; }
        { on = [ "7" ]; run = "plugin --sync auto-tab --args=6"; }
        { on = [ "8" ]; run = "plugin --sync auto-tab --args=7"; }
        { on = [ "9" ]; run = "plugin --sync auto-tab --args=8"; }
        { on = [ "l" ]; run = "plugin --sync smart-enter"; desc = "Enter the child directory, or open the file"; }
        { on = [ "k" ]; run = "plugin --sync arrow --args=-1"; desc = "File navigation wraparound"; }
        { on = [ "j" ]; run = "plugin --sync arrow --args=1"; desc = "File navigation wraparound"; }
        { on = [ "K" ]; run = "plugin --sync parent-arrow --args=-1"; desc = "Navigation in the parent directory without leaving the CWD"; }
        { on = [ "J" ]; run = "plugin --sync parent-arrow --args=1"; desc = "Navigation in the parent directory without leaving the CWD"; }
        { on = [ "p" ]; run = "plugin --sync smart-paste"; desc = "Paste into the hovered directory or CWD"; }
        { on = [ "i" ]; run = "plugin searchjump"; desc = "Search jump mode"; }
        { on = [ "I" ]; run = "plugin keyjump --args='global once'"; desc = "Keyjump (Once Global Mode)"; }
        { on = [ "<C-t>" ]; run = "plugin fg --args='rg'"; desc = "Find file by content (ripgrep match)"; }
        { on = [ "<C-o>" ]; run = "plugin fg --args='fzf'"; desc = "Find file by filename"; }
        { on = [ "<C-s>" ]; run = "plugin fg"; desc = "Find file by filename"; }
        { on = [ "t" "t" ]; run = "plugin eza-preview"; desc = "Toggle tree/list dir preview"; }
        { on = [ "t" "m" ]; run = "plugin --sync max-preview"; desc = "Maximize preview pane"; }
        { on = [ "t" "p" ]; run = "plugin --sync hide-preview"; desc = "Hide preview pane"; }
        { on = [ "t" "." ]; run = "hidden toggle"; desc = "Toggle the visibility of hidden files"; }
      ];
    };
    flavors = {
      "catppuccin-mocha.yazi" = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "flavors";
        rev = "main";
        sha256 = "sha256-gT3aMiBspYypkMdx1TDVwElK7aotolE1JJuJtkC9RRc";
      } + "/catppuccin-mocha.yazi";
      "onedark.yazi" = pkgs.fetchFromGitHub {
        owner = "BennyOe";
        repo = "onedark.yazi";
        rev = "main";
        sha256 = "sha256-SJdkLjF2i5/G0H/x9kTPXv/ozzMO1WhddWMjZi6+x3A=";
      };
      "tokyo-night.yazi" = pkgs.fetchFromGitHub {
        owner = "BennyOe";
        repo = "tokyo-night.yazi";
        rev = "main";
        sha256 = "sha256-IhCwP5v0qbuanjfMRbk/Uatu31rPNVChJn5Y9c5KWYQ";
      };
    };

    plugins = {
      "keyjump.yazi" = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "keyjump.yazi";
        rev = "main";
        sha256 = "sha256-WAjNhpGman9qRe52iXb0lDF37FEs4IFqobV6SJT9WCs=";
      };
      "searchjump.yazi" = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "searchjump.yazi";
        rev = "main";
        sha256 = "sha256-XH7DQMl0TjzIS90H3jP0q56cPjXy+umDiAHR0zVjGRY=";
      };
      "fg.yazi" = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "fg.yazi";
        rev = "main";
        sha256 = "sha256-6LpnyXB7mri6aVEfnv6aG2mWlzpvaD8SiMqwUS+jJr0=";
      };
      "eza-preview.yazi" = pkgs.fetchFromGitHub {
        owner = "sharklasers996";
        repo = "eza-preview.yazi";
        rev = "master";
        sha256 = "sha256-Ue58aT37FW7kRIUhbkt41J4wTYcYFQaRmdJgbthbSDA=";
      };
      "preview.yazi" = pkgs.fetchFromGitHub {
        owner = "Urie96";
        repo = "preview.yazi";
        rev = "main";
        sha256 = "sha256-WhAZyME8IVEmGQTAIxUSMDXPf0xqqAHixYfT8lXBtIQ=";
      };
    };
  };

  programs.kitty = {
    enable = true;
    # file location: `~/.config/kitty/macos-launch-services-cmdline`
    darwinLaunchOptions = [
      "--single-instance"
      "--directory ~/Dev"
    ];
    environment = {
      TERM = "xterm-256color";
    };
    theme = "One Dark";
    settings = {
      # font
      font_size        = 16;
      ## List available fonts: `kitty +list-fonts --psnames`
      font_family      = "CaskaydiaCove Nerd Font Mono Regular";
      bold_font        = "CaskaydiaCove Nerd Font Mono Bold";
      italic_font      = "CaskaydiaCove Nerd Font Mono Italic";
      bold_italic_font = "CaskaydiaCove Nerd Font Mono Bold Italic";

      # shell
      shell_integration = "enabled";
      macos_quit_when_last_window_closed = true;
      copy_on_select = true;

      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      # window
      ## with Shell integration enabled, using negative values means windows sitting at a shell prompt are not counted
      confirm_os_window_close = -1;
      hide_window_decorations = true;
      macos_option_as_alt = "both";
      startup_session = builtins.toString(pkgs.writeText "startup_session" ''
        new_tab
        launch zsh --login
        launch zsh --login
        launch zsh --login
        launch zsh --login
      '');
      enabled_layouts = "grid, tall, fat, stack";
      scrollback_pager_history_size = 100;
    };
    extraConfig = ''
      # kitty-scrollback.nvim Kitten alias
      action_alias kitty_scrollback_nvim kitten ${ vimPlugin "mikesmithgh/kitty-scrollback.nvim" }/python/kitty_scrollback_nvim.py
    '';
    keybindings = {
      "ctrl+shift+v"     = "kitty_scrollback_nvim";
      "cmd+t"            = "new_os_window_with_cwd";

      "alt+n"            = "new_window_with_cwd";
      "alt+f"            = "toggle_layout stack";
      "alt+v"            = "focus_visible_window";
      "alt+h"            = "neighboring_window left";
      "alt+l"            = "neighboring_window right";
      "alt+j"            = "neighboring_window down";
      "alt+k"            = "neighboring_window up";
      "alt+shift+h"      = "start_resizing_window";
      "alt+shift+l"      = "start_resizing_window";
      "alt+shift+j"      = "start_resizing_window";
      "alt+shift+k"      = "start_resizing_window";
      "alt+left"         = "move_window left";
      "alt+right"        = "move_window right";
      "alt+down"         = "move_window down";
      "alt+up"           = "move_window up";

      "alt+t"            = "new_tab";
      "alt+1"            = "goto_tab 1";
      "alt+2"            = "goto_tab 2";
      "alt+3"            = "goto_tab 3";
      "alt+4"            = "goto_tab 4";
      "alt+5"            = "goto_tab 5";
      "alt+6"            = "goto_tab 6";
      "alt+7"            = "goto_tab 7";
      "alt+8"            = "goto_tab 8";
      "alt+9"            = "goto_tab 9";
      "alt+0"            = "goto_tab -1";
      "alt+,"            = "previous_tab";
      "alt+."            = "next_tab";

      "alt+["            = "last_used_layout";
      "alt+]"            = "next_layout";
      "alt+r"            = "nth_window -1";
      "alt+o"            = "toggle_maximized";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      # One Dark: https://github.com/alacritty/alacritty-theme/blob/master/themes/one_dark.toml
      colors = {
        primary = {
          foreground = "#abb2bf";
          background = "#282c34";
        };
        normal = {
          black      = "#1e2127";
          red        = "#e06c75";
          green      = "#98c379";
          yellow     = "#d19a66";
          blue       = "#61afef";
          magenta    = "#c678dd";
          cyan       = "#56b6c2";
          white      = "#abb2bf";
        };
        bright = {
          black      = "#5c6370";
          red        = "#e06c75";
          green      = "#98c379";
          yellow     = "#d19a66";
          blue       = "#61afef";
          magenta    = "#c678dd";
          cyan       = "#56b6c2";
          white      = "#ffffff";
        };
      };
      # not support ligatures yet
      ## [Support for ligatures](https://github.com/alacritty/alacritty/issues/50)
      # not support fallback fonts list yet
      ## [Font Configuration](https://github.com/alacritty/alacritty/issues/957)
      font = {
        size               = 16;
        normal.family      = "CaskaydiaCove Nerd Font Mono";
        normal.style       = "Regular";
        bold.family        = "CaskaydiaCove Nerd Font Mono";
        bold.style         = "Bold";
        italic.family      = "CaskaydiaCove Nerd Font Mono";
        italic.style       = "Italic";
        bold_italic.family = "CaskaydiaCove Nerd Font Mono";
        bold_italic.style  = "Bold Italic";
      };
      window = {
        option_as_alt      = "Both";
        decorations        = "None";
        startup_mode       = "Maximized";
      };
      mouse = {
        # the cursor is temporarily hidden when typing
        hide_when_typing   = true;
      };
      env = {
        TERM = "xterm-256color";
      };
      selection = {
        save_to_clipboard = true;
      };
      keyboard.bindings = [
        # https://alacritty.org/config-alacritty-bindings.html
        {
          action = "ToggleViMode";
          key = "V";
          mods = "Shift|Control";
          mode = "~Search";
        }
        {
          action = "ScrollToBottom";
          key = "V";
          mods = "Shift|Control";
          mode = "Vi|~Search";
        }
        # emacs readline key bindings
        # see also: [Allow remapping modifier keys in the config](https://github.com/alacritty/alacritty/issues/62#issuecomment-347552058)
        #{
        #  key   = "F";
        #  mods  = "Alt";
        #  chars = "\\u001bf";
        #}
        #{
        #  key   = "B";
        #  mods  = "Alt";
        #  chars = "\\u001bb";
        #}
        #{
        #  key   = "Period";
        #  mods  = "Alt";
        #  chars = "\\u001b.";
        #}
        #{
        #  key   = "J";
        #  mods  = "Alt";
        #  chars = "\\u001bj";
        #}
      ];
      hints = {
        enabled = [
          # open [u]rl
          {
            command = "open";       # On macOS
            # command = "xdg-open"; # On Linux/BSD
            # command = { program = "cmd", args = [ "/c", "start", "" ] }; # On Windows
            hyperlinks = true;
            post_processing = true;
            persist = false;
            mouse.enabled = true;
            binding = { 
              mods = "Control|Shift";
              key = "U";
            };
            regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
          }
          # move cursor to [w]ord. like vim-easymotion
          {
            action = "MoveViModeCursor";
            hyperlinks = false;
            post_processing = false;
            persist = false;
            mouse.enabled = false;
            binding = {
              key = "W";
              mods = "Control|Shift";
            };
            regex = ''[\\w'-]+'';
          }
          # paste [r]ow
          {
            action = "Paste";
            hyperlinks = false;
            post_processing = false;
            persist = false;
            mouse.enabled = false;
            binding = {
              key = "Y";
              mods = "Control|Shift";
            };
            regex = ".*";
          }
          # copy [s]ymbol
          {
            action = "Copy";
            hyperlinks = false;
            post_processing = false;
            persist = false;
            mouse.enabled = false;
            binding = {
              key = "S";
              mods = "Control|Shift";
            };
            # `(?-u:\b)`: for ASCII word boundary in Rust. otherwise we get an error:
            #        could not compile hint regex: unsupported regex feature for DFAs: cannot build lazy DFAs for regexes with Unicode word boundaries; 
            #        switch to ASCII word boundaries, or heuristically enable Unicode word boundaries or use a different regex engine
            # `''`: this style string in nix will not do escape, but we still need extra slash in the generated toml file
            regex = lib.strings.concatStringsSep "|" [
              # email
              ''((?-u:\\b)[^@]+@[^@]+\\.[^@](?-u:\\b))''
              # git short hash
              # rust: error: look-around, including look-ahead and look-behind, is not supported
              # ''((?-u:\\b)(?=[a-f])([a-f0-9]{7,8})(?-u:\\b))''
              ''((?-u:\\b)[a-f0-9]{7,8}(?-u:\\b))''
              # git long hash
              ''((?-u:\\b)[a-f0-9]{40}(?-u:\\b))''
              # sha256
              ''((?-u:\\b)[a-fA-F0-9]{64}(?-u:\\b))''
              # md5
              ''((?-u:\\b)[a-fA-F0-9]{32}(?-u:\\b))''
              # uuid
              ''((?-u:\\b)[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}(?-u:\\b))''
              # mac address
              ''((?-u:\\b)[a-fA-F0-9]{2}(:[a-fA-F0-9]{2}){5}(?-u:\\b))''
              # ipv4
              ''((?-u:\\b)(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}(?-u:\\b))''
              # path
              ''/[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+''
            ];
          }
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    #defaultKeymap = "viins";
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      # use vim for quick editing tasks as it opens faster
      VISUAL = "vim";

      # locale
      # make sure check iTerm2's "Set locale variables automatically" off also
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";

      # like `batman`, used in case like `git checkout --help`
      MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'";
    };
    envExtra = ''
      # skhd doesn't use an interactive shell to execute commands, so we put helper functions in .zshenv
      ${builtins.readFile ../config/skhd.zsh}
    '';
    initExtra = ''
      # $${builtins.readFile ../config/nnn.zsh}
      ${builtins.readFile ../config/yazi.zsh}
      ${builtins.readFile ../config/helpers.zsh}

      # vivid is a themeable LS_COLORS generator
      # export LS_COLORS="$(~/.nix-profile/bin/vivid generate one-dark)";

      # use the same LS_COLORS as the yazi theme: https://github.com/Mellbourn/ls-colors.yazi
      # LS_COLORS by trapd00r contains unique colors from over 300 different file types
      source ${pkgs.fetchFromGitHub {
        owner = "trapd00r";
        repo = "LS_COLORS";
        rev = "master";
        sha256 = "sha256-DT9WmtyJ/wngoiOTXMcnstVbGh3BaFWrr8Zxm4g4b6U=";
      } + "/lscolors.sh"}

      source ~/.bash_profile

      # fzf keybindings
      source ~/.fzf/shell/key-bindings.zsh

      # bindkey
      ## disable terminal flow control (aka ctrl-s ctrl-q shortcuts)
      stty -ixon

      bindkey '^K'  up-line-or-search
      bindkey '^J'  down-line-or-search
      bindkey '^F'  autosuggest-accept
      bindkey '^G'  autosuggest-execute
      bindkey '^U'  backward-kill-line

      bindkey '^A' vi-beginning-of-line
      bindkey '^E' vi-end-of-line

      bindkey '\ef' emacs-forward-word
      bindkey '\eb' emacs-backward-word
      bindkey '\e.' insert-last-word


      ## Three ways to stash current command, see also: https://stackoverflow.com/questions/11670935/comments-in-command-line-zsh
      ## 1. allow comments in command line or use `: ` instead of `#`
      setopt interactivecomments
      ## 2. commands buffer stack
      bindkey '^Q' push-input
      ## 3. ctrl-u ctrl-y

      ## user contrib widgets
      ## https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-edit_002dcommand_002dline
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^X^E' edit-command-line
      bindkey '^V' edit-command-line

      ## stop backward-kill-word on directory delimiter
      autoload -U select-word-style
      select-word-style bash

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
    plugins = with pkgs; [
      #{
      #  # will source zsh-autosuggestions.plugin.zsh
      #  name = "zsh-autosuggestions";
      #  src = pkgs.fetchFromGitHub {
      #    owner = "zsh-users";
      #    repo = "zsh-autosuggestions";
      #    rev = "v0.7.0";
      #    sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      #  };
      #}
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "c7fb028ec0bbc1056c51508602dbd61b0f475ac3";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
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
