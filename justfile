symlink:
    ln -s {{ absolute_path("nixpkgs/home.nix") }} ~/.nixpkgs/home.nix
    ln -s {{ absolute_path("nixpkgs/darwin-configuration.nix") }} ~/.nixpkgs/darwin-configuration.nix
