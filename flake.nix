{
    description = "Rust server";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        flake-parts = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixpkgs"; };
        flake-utils = { url = "github:numtide/flake-utils"; };
    };
    outputs = {self, nixpkgs, flake-utils, ...}:
        flake-utils.lib.eachDefaultSystem (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        in
        {
            packages.default = pkgs.rustPlatform.buildRustPackage rec
                                    {
                                        pname = "rust-again";
                                        version = "0.0.0";
                                        buildInputs = [
                                            pkgs.cargo
                                            pkgs.rustc
                                            # Necessary for the openssl-sys crate:
                                            pkgs.openssl
                                            pkgs.pkg-config
                                        ];
                                        src = ./.;
                                        cargoLock = {
                                            lockFile = ./Cargo.lock;
                                        };
                                    };
        });
}