symlink:
    ln -sfn {{ absolute_path("nixpkgs") }} ~/.nixpkgs

switch-home:
    home-manager switch

switch-darwin:
    darwin-rebuild switch

switch-all: switch-home switch-darwin

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
