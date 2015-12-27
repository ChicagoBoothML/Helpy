#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# install advanced visualization tools
sudo pip install --upgrade git+git://github.com/bokeh/bokeh.git
sudo pip install --upgrade GGPlot
# sudo pip install --upgrade GNUPlot-Py --allow-external GNUPlot-Py --allow-unverified GNUPlot-Py   skip: cannot find

# brew install Expat
# brew install MakeDepend
# brew tap Homebrew/Science
# brew install --python --qt vtk5
# sudo pip install --upgrade MayaVi

sudo pip install --upgrade Plotly
