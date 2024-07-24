services-list:
    brew services list

switch-home:
    ln -sfn {{ absolute_path("nixpkgs/home.nix") }} ~/.config/home-manager/home.nix
    #NIXPKGS_ALLOW_UNFREE=1 home-manager switch
    home-manager switch

switch-home-debug:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --debug --show-trace

install-darwin:
    ln -sfn {{ absolute_path("nixpkgs/darwin-configuration.nix") }} ~/.nixpkgs/darwin-configuration.nix
    if [ ! -d "/tmp/nix-darwin/result" ]; then \
      mkdir -p /tmp/nix-darwin && cd /tmp/nix-darwin && nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer; \
    fi
    yes | /tmp/nix-darwin/result/bin/darwin-installer

switch-darwin:
    ln -sfn {{ absolute_path("nixpkgs/darwin-configuration.nix") }} ~/.nixpkgs/darwin-configuration.nix
    darwin-rebuild switch

switch-all: switch-home switch-darwin

update-channel-home: 
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
    nix-channel --update home-manager

rollback-home step="1":
    #!/usr/bin/env bash
    gen=$(home-manager generations | head -n $(( {{ step }} + 1 )) | tail -n 1 | awk '{print $7"/activate"}')
    echo Switch to $gen && ${gen}

nix-gc:
    nix-collect-garbage -d

yabai-start:
    launchctl load ~/Library/LaunchAgents/org.nixos.yabai.plist
    @ echo -n "Started pid..."
    @ pgrep -f bin/yabai

yabai-stop:
    @# Suppressing of Failing Commands with `-` Prefix
    @# https://github.com/casey/just/issues/660
    @- echo -n "Stopping pid..." && pgrep -f bin/yabai
    launchctl unload ~/Library/LaunchAgents/org.nixos.yabai.plist

yabai-restart: yabai-stop yabai-start

skhd-start:
    launchctl load ~/Library/LaunchAgents/org.nixos.skhd.plist
    echo -n "Started pid..." && pgrep -f bin/skhd

skhd-stop:
    @- echo -n "Stopping pid..." && pgrep -f bin/skhd
    - launchctl unload ~/Library/LaunchAgents/org.nixos.skhd.plist

skhd-restart: skhd-stop skhd-start

fetch-repos:
    git clone https://github.com/specv/lazyvim "~/.config/lazyvim" 2>/dev/null
    git clone https://github.com/specv/clash "~/.config/clash" 2>/dev/null
    git clone https://github.com/specv/logseq "~/Dev/github/logseq" 2>/dev/null
    git clone https://github.com/specv/Anki2 "~/Library/Application Support/Anki2" 2>/dev/null
