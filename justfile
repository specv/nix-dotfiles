install:
    # homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

services-list:
    brew services list

symlink:
    ln -sfn {{ absolute_path("nixpkgs") }} ~/.nixpkgs

switch-home:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch

switch-home-debug:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --debug --show-trace

switch-darwin:
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

