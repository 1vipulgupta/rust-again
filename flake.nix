{
    description = "Rust server";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        systems.url = "github:nix-systems/default";
        flake-parts = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixpkgs"; };
        flake-utils = { url = "github:numtide/flake-utils"; };
    };
    outputs = inputs@{self, nixpkgs, flake-utils, flake-parts, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            flake = {
            # Put your original flake attributes here.
            };
            imports = [
                ./.
                ./nodejs
            ];
            systems = import inputs.systems;#[
            # systems for which you want to build the `perSystem` attributes
            #"x86_64-linux"
            # ...
            #];
            perSystem = { self', pkgs, config, lib, ... }: {
                devShells.default = pkgs.mkShell {
                    inputsFrom = [
                        # import each value and make all pkgs in default.nix available to terminal
                        self'.devShells.rust
                        self'.devShells.node
                    ];
                };
            };
        };
}