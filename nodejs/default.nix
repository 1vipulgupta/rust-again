{
    perSystem = { self', pkgs, ... }:
    {
    devShells.node = pkgs.mkShell {
        buildInputs = [ pkgs.nodejs ];
        inputsFrom = [ ];
        packages = [];
      };
    };
}