# CLAUDE.md

Personal fork of [Alexis12119/nvim-config](https://github.com/Alexis12119/nvim-config).
See README.md for architecture, structure, and features.

## Repo layout

- `upstream` remote → Alexis12119/nvim-config (upstream source)
- `origin` remote → serpro69/nvim-config (this fork)
- `main` branch tracks `upstream/main` — never commit custom changes here
- `master` branch is the working branch with personal customizations rebased on `main`

## Sync workflow

Run `make update`. It creates a dated backup branch from `origin/master`, pulls all remotes, rebases `main` on `upstream/main`, then rebases `master` on `main`. See `Makefile` for details.

After sync, resolve any rebase conflicts in `master` and run `:Lazy sync` in neovim.

## Customization conventions

- Personal overrides go in `lua/config/overrides/` (globals.lua for early, init.lua for late) to minimize rebase conflicts with upstream.
- Plugin specs live in `lua/plugins/<category>/` using LazySpec format. Group by category (ai, editor, integration, lsp, ui, etc.).
- Upstream uses LazyVim extras (`lazyvim.json`) for language support — toggle via `:LazyExtras` rather than deleting plugin files.

## Known workarounds

- `dadbod-grip.nvim`: plugin ships a broken `lazy.lua` (nameless spec fragment). The `build` hook in `lua/plugins/integration/dadbod-grip.lua` overwrites it with an empty spec, marks it `--assume-unchanged` in git, and clears the pkg cache. If Lazy reports local changes for this plugin after sync, run `:Lazy build dadbod-grip.nvim`.
