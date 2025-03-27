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
        haskellPackages = pkgs.haskellPackages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust dependencies
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer
            protobuf

            # Haskell dependencies
            haskellPackages.ghc
            haskellPackages.cabal-install
            haskellPackages.hlint
            haskellPackages.ormolu
            haskellPackages.stack
            # CI/CD
            jenkins
          ];

          shellHook = ''
            echo "Welcome to the development shell!"
          '';
        };
      }
    );
}
