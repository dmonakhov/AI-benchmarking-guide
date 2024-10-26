# Fixup setuptool issue  https://github.com/pypa/setuptools/issues/4483
sudo pip3 install --upgrade packaging==23.1

# fixup for windows characters
sudo apt-get install dos2unix

# Let's do everything in venv
sudo apt-get install python3-pip python3-pip
pip3 install virtualenv
#virtualenv env
source env/bin/activate

# FIXUP for nvjitlink package, without flush-attn fail to install.
export LD_LIBRARY_PATH=:$VIRTUAL_ENV/lib/python3.10/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH


# We are using DLAMI, so all we need is just install pip deps
pip3 install --no-cache-dir cmake
pip3 install --no-cache-dir packaging
pip3 install --no-cache-dir torch
pip3 install --no-cache-dir matplotlib
pip3 install --no-cache-dir scipy
pip3 install --no-cache-dir pandas
pip3 install --no-cache-dir numpy
pip3 install --no-cache-dir ninja
pip3 install --no-cache-dir torchvision
#pip3 install --no-cache-dir flash-attn # Not required for LLMBench
pip3 install --no-cache-dir docker
pip3 install --no-cache-dir prettytable

# Run tests
#python3 ./runner.py
#./run_llmbench.sh
