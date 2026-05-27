# Fix Clangd Unknown Arguments Warning

## Problem
Clangd was showing "Unknown argument" warnings for various GCC-specific optimization flags in the Mars project.

## Solution
Updated the project-level `.clangd` configuration file to:
1. Remove specific unknown arguments
2. Suppress unknown_argument diagnostics

## Changes Made
Updated `/home/gaoyf/mars-project/.clangd`:

### Added to Remove list:
- `-fno-aggressive-loop-optimizations`
- `-fno-isolate-erroneous-paths-dereference`
- `-fno-tree-loop-distribute-patterns`
- `-fno-tree-switch-conversion`

### Added to Diagnostics.Suppress:
- `unknown_argument`

## Final Configuration
```yaml
CompileFlags:
  Remove:
    - -DCHIP_SUBSYS_BTH*
    - -fno-aggressive-loop-optimizations
    - -fno-isolate-erroneous-paths-dereference
    - -fno-tree-loop-distribute-patterns
    - -fno-tree-switch-conversion
  Add:
    - -UCHIP_SUBSYS_BTH
    - --target=arm-none-eabi
    - -ferror-limit=0

Diagnostics:
  Suppress:
    - unused-includes
    - pp_file_not_found
    - unknown_argument
```

## How to Apply
- Restart Neovim or run `:LspRestart`

## Future Maintenance
If new "Unknown argument" warnings appear:
1. Add the argument name to the `Remove` list in `.clangd`
2. Restart Neovim
