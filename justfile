symlink:
    ln -sfn {{ absolute_path("nixpkgs") }} ~/.nixpkgs

switch-home:
    home-manager switch

switch-darwin:
    darwin-rebuild switch

switch-all: switch-home switch-darwin
