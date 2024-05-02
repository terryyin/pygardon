{ pkgs ? import <nixpkgs> {} }:

with pkgs;

pkgs.mkShell {
  buildInputs = [
    # Defines a python + set of packages.
    (python3.withPackages (ps: with python3Packages; [
      jupyter
      ipython
      ipykernel

      setuptools
      virtualenv # run virtualenv .
      pip
      pyqt5 # avoid installing via pip

      pandas
      numpy
      matplotlib
      scipy
    ]))
  ];

  shellHook = ''
    export PYTHONPATH=${python3.sitePackages}:$PYTHONPATH
    if [ ! -d .venv ]; then
      python -m venv .venv
      pip install dyalog-jupyter-kernel
    fi
    source .venv/bin/activate
    export PYTHONPATH=$PWD/.venv/${python3Packages.python.sitePackages}/:$PYTHONPATH
    python -m ipykernel install --user --name=.venv
    python -m 'dyalog_kernel' install
    echo "Python and Jupyter are ready to use. Use 'jupyter notebook' to start."
  '';
}

