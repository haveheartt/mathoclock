{
  description = "Development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # rust dependencies
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer

            # agda dependencies
            agda
    
            # ci/cd
            jenkins
          ];

          shellHook = ''
            export JUPYTER_CONFIG_DIR="$HOME/.jupyter"
            export JUPYTER_DATA_DIR="$HOME/.local/share/jupyter"
            mkdir -p "$JUPYTER_CONFIG_DIR"
            mkdir -p "$JUPYTER_DATA_DIR"
            echo "Welcome to the development environment!"
          '';
        };
      });
}
