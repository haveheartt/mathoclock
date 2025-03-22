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
 FFROM jenkins/jenkins:lts

USER root

# Install base tools (Git, SSH client, Curl, Rust)
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    curl \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/*

# Ensure PATH includes Cargo for jenkins user
ENV PATH="/root/.cargo/bin:${PATH}"
RUN echo ". $HOME/.cargo/env" >> /home/jenkins/.bashrc

USER jenkinsROM jenkins/jenkins:lts

USER root

# Install base tools (Git, SSH client, Curl, Rust)
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    curl \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/*

# Ensure PATH includes Cargo for jenkins user
ENV PATH="/root/.cargo/bin:${PATH}"
RUN echo ". $HOME/.cargo/env" >> /home/jenkins/.bashrc

USER jenkins         ];

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
