# tree-sitter GLIBC mismatch

## Symptom

On nvim startup, parser installs fail:

```
[nvim-treesitter/install/scala]: Compiling parser
[nvim-treesitter/install/scala] error: Error during "tree-sitter build": tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.39' not found (required by tree-sitter)
```

Any parser may appear in the error; the failure is in the `tree-sitter` CLI itself, not the parser source.

## Root cause

`nvim-treesitter` `main` branch compiles parsers at install time using the `tree-sitter` CLI. LazyVim auto-installs the CLI via Mason if it isn't on `PATH` (see `lazyvim/util/treesitter.lua` → `ensure_treesitter_cli`).

Mason's `tree-sitter-cli` package ships a prebuilt binary (`tree-sitter-linux-x64`). Starting with `v0.26.x`, that binary is built on a host with GLIBC ≥ 2.39. Systems with older glibc (Ubuntu 22.04 / Pop!_OS 22.04 → glibc 2.35) can't run it.

Mason also prepends its bin directory to nvim's `PATH` (`mason.nvim/lua/mason/settings.lua` → `PATH = "prepend"`), so even a working `tree-sitter` elsewhere on `PATH` is shadowed.

## Debug steps

1. Confirm system glibc:
   ```sh
   ldd --version | head -1
   ```
2. Confirm the broken binary:
   ```sh
   ~/.local/share/nvim/mason/bin/tree-sitter --version
   # → tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.39' not found
   ```
3. Confirm nvim resolves the Mason copy, not a system one:
   ```sh
   nvim --headless -c "lua print(vim.fn.exepath('tree-sitter'))" -c "qa!"
   ```

## Fix

Build `tree-sitter-cli` from source against system glibc, then drop the Mason package so the cargo binary is the only one nvim sees.

```sh
cargo install tree-sitter-cli --no-default-features
```

`--no-default-features` disables the `qjs-rt` feature, which pulls in `rquickjs-sys` → `bindgen` → `libclang`. Without it, the build succeeds with stock tooling.

```vim
:MasonUninstall tree-sitter-cli
```

This removes `~/.local/share/nvim/mason/bin/tree-sitter` (symlink) and `~/.local/share/nvim/mason/packages/tree-sitter-cli/`.

## Verify

`tree-sitter` resolves to the cargo binary inside nvim:

```sh
nvim --headless -c "lua print(vim.fn.exepath('tree-sitter'))" -c "qa!"
# → /home/<user>/.cargo/bin/tree-sitter
```

A parser install actually compiles:

```sh
nvim --headless -c "lua require('nvim-treesitter').install({'scala'}, { summary = true }):wait()" -c "qa!"
# → [nvim-treesitter/install/scala]: Language installed
```

## Will Mason reinstall it?

No, as long as the cargo binary stays on `PATH`. `LazyVim/lua/lazyvim/util/treesitter.lua` (`ensure_treesitter_cli`) only invokes Mason when `vim.fn.executable("tree-sitter") == 0`. No `mason-tool-installer` is configured, and `:MasonUpdate` only refreshes the registry.

If `~/.cargo/bin/tree-sitter` ever disappears, the LazyVim util will reinstall via Mason as a failsafe — restoring the same broken state. Re-run the two commands in [Fix](#fix).
