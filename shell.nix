{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python39
    pkgs.python39Packages.pip
    pkgs.python39Packages.virtualenv
    pkgs.jupyter
  ];

  shellHook = ''
    export PYTHONPATH=${pkgs.python39.sitePackages}:$PYTHONPATH
    if [ ! -d .venv ]; then
      python -m venv .venv
      source .venv/bin/activate
      pip install ipykernel
      python -m ipykernel install --user --name=my-nix-project-kernel
      pip install dyalog-jupyter-kernel
      python -m 'dyalog_kernel' install
    else
      source .venv/bin/activate
    fi
    echo "Python and Jupyter are ready to use. Use 'jupyter notebook' to start."
  '';
}

