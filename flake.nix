{
  description = "BITEHack project";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mach-nix.url = "github:DavHau/mach-nix";

  outputs = inputs@{ self, nixpkgs, flake-utils, mach-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = "python39";
        mach-nix-wrapper = import mach-nix { inherit pkgs python; };
        requirements = ''
          ${builtins.readFile ./requirements.txt}
          pip
          black
          pyflakes
          isort
        '';
        pythonBuild = mach-nix-wrapper.mkPython { inherit requirements; };
      in {
        packages.venv = pythonBuild;
        defaultPackage = self.packages.x86_64-linux.venv;
        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.${python}.withPackages
              (ps: with ps; [ pip black pyflakes isort ]))
            pkgs.nodePackages.pyright
            pkgs.glpk

            pythonBuild
          ];
        };
      });
}
