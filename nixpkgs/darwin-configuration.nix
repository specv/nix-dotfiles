{ config, pkgs, ... }:

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # See also: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
  # Note that some of these changes require a logout/restart to take effect.
  system.defaults = {
    spaces = {
      # Displays have separate Spaces
      # false = each physical display has a separate space (Mac default)
      # true = one space spans across all physical displays
      # System Preferences > Mission Control > Displays have seperate Spaces
      spans-displays = false;
    };
    dock = {
      # Automatically hide and show the Dock
      autohide = true;
      # Remove the auto-hiding Dock delay
      autohide-delay = 0.0;
      # Remove the animation when hiding/showing the Dock
      autohide-time-modifier = 0.00;
      # Sets the speed of the Mission Control animations
      expose-animation-duration = 0.0;
      # Don’t automatically rearrange Spaces based on most recent use
      # System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use
      mru-spaces = false;
      # Don’t show recent applications in Dock
      show-recents = false;
      # Change minimize/maximize window effect
      mineffect = "scale";
    };
    finder = {
      # Allow quitting of the Finder
      QuitMenuItem = true;
      # Show path bar
      ShowPathbar = true;
      # Show status bar
      ShowStatusBar = false;
      # Show hidden files by default
      AppleShowAllFiles = true;
      # Show all filename extensions
      AppleShowAllExtensions = true;
      # Disable the warning when changing a file extension
      FXEnableExtensionChangeWarning = false;
      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
      FXPreferredViewStyle = "Nlsv";
      # When performing a search, search the current folder by default
      FXDefaultSearchScope = "SCcf";
      # Display full POSIX path as Finder window title
      _FXShowPosixPathInTitle = true;
    };
    NSGlobalDomain = {
      # Sets the speed speed of window resizing.
      NSWindowResizeTime = 0.001;
    };
  };

  system.activationScripts.extraUserActivation.text = ''
    # change `Preferences...` menu default shortcut from `cmd-,` to `cmd+shift-,`
    # add entry to "Keyboard => Shortcuts => App Shortcuts"
    #defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "NSGlobalDomain"
    defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Settings..." "@$,"
    defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Preferences..." "@$,"

    # Speed up Mission Control animations
    # System Preferences > Accessibility > Display > Reduce Motion
    defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
    # Not working, permission denied: Could not write domain com.apple.universalaccess; exiting
    # Should add terminal app to Privacy & Security => Full Disk Access
    #defaults write com.apple.universalaccess reduceMotion -int 1

    # disable mouse acceleration
    defaults write NSGlobalDomain com.apple.mouse.linear -bool "true"
    # set mouse movement scale factor
    defaults write NSGlobalDomain com.apple.mouse.scaling -float "1"

    # Disable "Use the Caps Lock key to switch to and from ABC"
    # Keyboard => Input Sources => Edit
    defaults write NSGlobalDomain TISRomanSwitchState -int 0

    # Keyboard => Keyboard Shortcuts => Input sources
    ## Select the previous input source
    ## {enabled = 1; value = { parameters = (32, 49, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"

    # Keyboard => Keyboard Shortcuts => Mission Control
    ## Move left a space
    ## {enabled = 1; value = { parameters = (104, 4, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>104</integer><integer>4</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Move right a space
    ## {enabled = 1; value = { parameters = (108, 37, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>108</integer><integer>37</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 1
    ## {enabled = 1; value = { parameters = (49, 18, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>49</integer><integer>18</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 2
    #{enabled = 1; value = { parameters = (50, 19, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>50</integer><integer>19</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 3
    ## {enabled = 1; value = { parameters = (51, 20, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>51</integer><integer>20</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 4
    ## {enabled = 1; value = { parameters = (52, 21, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 121 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>52</integer><integer>21</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 5
    ## {enabled = 1; value = { parameters = (53, 23, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 122 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>53</integer><integer>23</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 6
    ## {enabled = 1; value = { parameters = (54, 22, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 123 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>54</integer><integer>22</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 7
    ## {enabled = 1; value = { parameters = (55, 26, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 124 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>55</integer><integer>26</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 8
    ## {enabled = 1; value = { parameters = (56, 28, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 125 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>56</integer><integer>28</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 9
    ## {enabled = 1; value = { parameters = (57, 25, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 126 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>57</integer><integer>25</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Switch to Desktop 10
    ## {enabled = 1; value = { parameters = (48, 29, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 127 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>48</integer><integer>29</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Mission Control
    ## {enabled = 1; value = { parameters = (107, 40, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>107</integer><integer>40</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Application windows
    ## {enabled = 1; value = { parameters = (106, 38, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>106</integer><integer>38</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"
    ## Show Nitification Center
    ## {enabled = 1; value = { parameters = (110, 45, 1835008); type = 'standard'; }; }
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 163 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>110</integer><integer>45</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>"

    # Run reactivateSettings to apply the updated settings
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    #pkgs.vim
    pkgs.skhd
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Auto upgrade nix package and the daemon service.
  # Nix daemon, which is a required component in multi-user Nix installations. 
  # It runs build tasks and other operations on the Nix store on behalf of non-root users.
  # Usually you don't run the daemon directly; instead it's managed by a service management 
  # framework such as systemd on Linux, or launchctl on Darwin.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    # enable yabai's scripting-addition. SIP must be disabled for this to work.
    enableScriptingAddition = true;
    # `builtins.readFile` can't handle symbolic link, `.` == `~/.nixpkgs`
    # `.yabairc` generated from `home-manager` via `mkOutOfStoreSymlink`
    extraConfig = builtins.readFile ../config/yabairc;
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Shortcut
      ## alacritty
      lcmd + ctrl - t : alacritty msg create-window || open -n ${pkgs.alacritty}/Applications/Alacritty.app &> /dev/null
      ## iterm
      # lcmd + ctrl - t : open -n /Applications/iTerm.app
      ## kitty
      # lcmd + ctrl - t : ${pkgs.kitty}/Applications/kitty.app/Contents/MacOS/kitty --single-instance --directory ~ &> /dev/null

      ${builtins.readFile ../config/skhdrc}
    '';
  };

  services.spacebar = {
    enable = false;
    package = pkgs.spacebar;
    extraConfig = builtins.readFile ../config/spacebarrc;
  };

  # homebrew
  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    taps = [
      "homebrew/bundle"
      # Tapping homebrew/cask is no longer typically necessary.
      # "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      # Homebrew Bundle failed! 2 Brewfile dependencies failed to install.
      # "homebrew/core"
      "homebrew/services"
      # JankyBorders
      "FelixKratz/formulae"
    ];
    extraConfig = ''
    '';
    brews = [
      "redis"
      "postgresql@14"
      # JankyBorders: A lightweight window border system for macOS
      "borders"
      # daemonless container engine for developing, managing, and running OCI Containers
      #"podman"
    ];
    casks = [
      # note taking app (`Notational Velocit` alternative)
      #"nvalt"
      # desktop automation app
      "hammerspoon" 
      # an archive unpacker program
      "the-unarchiver"
      # git interface focused on visual interaction
      #"gitup"
      # translate & OCR
      #"bob"
      # E-books management software
      #"calibre"
      # rime input method engine
      #"squirrel"
      # pack, ship and run any application as a lightweight container 
      # use `colima` instead until [issue](https://github.com/abiosoft/colima/issues/83) resovled
      #"docker"
      # controls and monitors all fans on Apple computers
      #"macs-fan-control"
      # web browser focusing on security
      #"tor-browser"
      # a new command line scriptable shell for MySQL
      #"mysql-shell"
      # fast, light, powerful way to run containers
      "orbstack"
      "raycast"
    ];
  };
}
