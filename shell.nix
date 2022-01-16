let
  pkgs = import <nixpkgs> { };
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    ref = "master";
  }) { python = "python38"; };
  customPython = mach-nix.mkPython rec {
    providers._default = "wheel,conda,sdist";
    requirements = builtins.readFile ./requirements.txt;
  };
in pkgs.mkShell {
  buildInputs = [ customPython ];
  venvDir = "venv38";
  src = null;
  shellHook = ''
  virtualenv --no-setuptools venv
  export PATH=$PWD/venv/bin:$PATH
  export PYTHONPATH=venv/lib/python3.8/site-packages/:$PYTHONPATH
  '';
  postShellHook = ''
    ln -sf ${customPython}/lib/python3.8/site-packages/* ./venv/lib/python3
    .8/site-packages
  '';
}
