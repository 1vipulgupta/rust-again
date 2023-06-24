{
    perSystem = { self', pkgs, lib, ... }:
    let
    src = lib.sourceFilesBySuffices ./. [ ".rs" ".toml" "Cargo.lock" ];
    inherit (lib.importTOML (src + "/Cargo.toml")) package;
    in
    {
      packages = {
        ${package.name} = pkgs.rustPlatform.buildRustPackage {
                pname = package.name;
                inherit (package) version;
                inherit src;
                buildInputs = [
                                pkgs.cargo
                                pkgs.rustc
                                pkgs.rustfmt
                                # Necessary for the openssl-sys crate:
                                pkgs.openssl
                                pkgs.pkg-config
                            ];
                cargoLock.lockFile = (src + "/Cargo.lock");
            };
            default = self'.packages.${package.name};
        };

      devShells.rust = pkgs.mkShell {
        buildInputs = [ pkgs.cargo pkgs.rustc ];
        inputsFrom = [ self'.packages.${package.name}];
        packages = with pkgs; [
          rust-analyzer
          nil
        ];
      };
    };
}