#!/bin/bash

#find invalid link for linux
#find ~/.local/share/nvim/ -type l ! -exec test -e {} \; -exec ls -ld {} \;

#update the link to the right location
ln -f -s  ~/.local/share/nvim/mason/packages/shfmt/shfmt_v3.9.0_linux_amd64 ~/.local/share/nvim/mason/bin/shfmt 
ln -f -s  ~/.local/share/nvim/mason/packages/autopep8/venv/bin/autopep8 ~/.local/share/nvim/mason/bin/autopep8 
ln -f -s  ~/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7 ~/.local/share/nvim/mason/bin/OpenDebugAD7 
ln -f -s  ~/.local/share/nvim/mason/packages/debugpy/debugpy ~/.local/share/nvim/mason/bin/debugpy 
ln -f -s  ~/.local/share/nvim/mason/packages/clangd/clangd_19.1.0/bin/clangd ~/.local/share/nvim/mason/bin/clangd 
ln -f -s  ~/.local/share/nvim/mason/packages/cpplint/venv/bin/cpplint ~/.local/share/nvim/mason/bin/cpplint 
ln -f -s  ~/.local/share/nvim/mason/packages/asm-lsp/bin/asm-lsp ~/.local/share/nvim/mason/bin/asm-lsp 
ln -f -s  ~/.local/share/nvim/mason/packages/stylua/stylua ~/.local/share/nvim/mason/bin/stylua 
ln -f -s  ~/.local/share/nvim/mason/packages/debugpy/debugpy-adapter ~/.local/share/nvim/mason/bin/debugpy-adapter 
ln -f -s  ~/.local/share/nvim/mason/packages/clang-format/venv/bin/clang-format ~/.local/share/nvim/mason/bin/clang-format 
ln -f -s  ~/.local/share/nvim/mason/packages/lua-language-server/lua-language-server ~/.local/share/nvim/mason/bin/lua-language-server 
ln -f -s  ~/.local/share/nvim/mason/packages/rust-analyzer/rust-analyzer-x86_64-unknown-linux-gnu ~/.local/share/nvim/mason/bin/rust-analyzer 
ln -f -s  ~/.local/share/nvim/mason/packages/bash-debug-adapter/bash-debug-adapter ~/.local/share/nvim/mason/bin/bash-debug-adapter 
ln -f -s  ~/.local/share/nvim/mason/packages/zk/zk ~/.local/share/nvim/mason/bin/zk 
ln -f -s  ~/.local/share/nvim/mason/packages/checkmake/checkmake-0.2.2.linux.amd64 ~/.local/share/nvim/mason/bin/checkmake 
ln -f -s  ~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter ~/.local/share/nvim/mason/bin/js-debug-adapter 
ln -f -s  ~/.local/share/nvim/mason/packages/checkmake/man1/checkmake.1 ~/.local/share/nvim/mason/share/man/man1/checkmake.1 
ln -f -s  ~/.local/share/nvim/mason/packages/clangd/mason-schemas/lsp.json ~/.local/share/nvim/mason/share/mason-schemas/lsp/clangd.json

