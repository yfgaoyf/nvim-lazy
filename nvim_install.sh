#!/bin/bash

#install dot-config-nvim to ~/.config/nvim
[ -d ~/.config ] || { mkdir ~/.config; }
cp -rf dot-config-nvim ~/.config/nvim

#install dot-local-share-nvim to ~/.local/share/nvim
[ -d ~/.local/share ] || { mkdir -p ~/.local/share; }
cp -rf dot-local-share-nvim ~/.local/share/nvim

#install bin-nvim-linux64 to ~/.local/bin
[ -d ~/.local/bin ] || { mkdir -p ~/.local/bin; }
cp -rf bin-nvim-linux64 ~/.local/bin/nvim-linux64

#update ~/.bashrc
echo 'export PATH=~/.local/bin/nvim-linux64/bin:$PATH' >> ~/.bashrc

#update mason command link
./tools/update-mason-bin-link.sh
