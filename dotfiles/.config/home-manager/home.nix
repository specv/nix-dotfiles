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

    # Terminal
    ## a cross-platform, GPU-accelerated terminal emulator
    alacritty

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
}
