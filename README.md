# Factorio Mods

This repository contains [my mods](https://mods.factorio.com/user/hub).

## Workspace

This repository is designed to be edited using Visual Studio Code and heavily relies on the [justarandomgeek/vscode-factoriomod-debug](https://github.com/justarandomgeek/vscode-factoriomod-debug) extension.

After the initial project import, run install the recommended vscode addons and run task (ctrl+shift+p) `Factorio: Generate Typedefs`.
First file dialog, navigate to: `{{factorio_path}}/doc-html/runtime-api.json`
Second file dialog, choose path: `{{project_path}}/runtime-api.lua`

For more information visit: https://github.com/justarandomgeek/vscode-factoriomod-debug#factorio-api-autocompletion

The repository contains a utility script `mods.sh` for packaging, local installation and publishing of mods.
