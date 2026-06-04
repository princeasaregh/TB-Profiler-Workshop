#!/bin/bash

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

conda install -n base -c conda-forge mamba -y

mamba create -n tbprofiler \
-c conda-forge \
-c bioconda \
tb-profiler -y

conda activate tbprofiler

tb-profiler update_tbdb

echo "TB-Profiler installation complete."
