# Neovim — code navigation & review guide

A reference for the LSP-powered setup in `init.lua`. Optimized for reading
unfamiliar code across many languages, not for being a primary editor in one.

## Bootstrap (run once after editing the config)

```
:Lazy sync           " install / update plugins
:MasonInstallAll     " install all LSP servers listed in ensure_installed
:Mason               " inspect / manage installed servers
:LspInfo             " verify a server is attached to the current buffer
:checkhealth         " sanity check the whole setup
```

Restart nvim, open a file in any supported language, and the matching LSP
attaches automatically.

## Code navigation — daily drivers

| Key       | What it does                  | Notes                                            |
| --------- | ----------------------------- | ------------------------------------------------ |
| `gd`      | Go to definition              | Telescope picker if multiple, jumps if one       |
| `gr`      | Find references               | Telescope picker — `<CR>` jumps, `<Esc>` cancels |
| `gi`      | Go to implementation          | Useful for interfaces / abstract methods         |
| `gy`      | Go to type definition         | The *type* of the symbol, not where it's used    |
| `K`       | Hover docs                    | Press `K` again to enter the float and scroll    |
| `<C-o>`   | Jump back (jumplist)          | The PhpStorm `cmd+[` equivalent                  |
| `<C-i>`   | Jump forward (jumplist)       | The PhpStorm `cmd+]` equivalent                  |
| `<C-]>`   | Tag-style jump                | Native vim, similar to `gd`                      |
| `gf`      | Open file under cursor        | E.g. import paths                                |
| `%`       | Jump to matching bracket      | Native vim                                       |
| `*` / `#` | Search word under cursor fwd/back | Native vim                                   |

## Symbol search — the killer feature for review

| Key          | What it does                                             |
| ------------ | -------------------------------------------------------- |
| `<leader>ds` | Document symbols — outline of current file              |
| `<leader>ws` | Workspace symbols — fuzzy-search any symbol in project   |
| `<leader>ff` | Find files                                               |
| `<leader>fg` | Live grep across project                                 |

`<leader>ws` is the standout — type `userController` and jump straight there
from anywhere in the project.

## Diagnostics (errors / warnings / hints)

| Key          | What it does                                          |
| ------------ | ----------------------------------------------------- |
| `]d` / `[d`  | Next / previous diagnostic, opens float with details  |
| `<leader>e`  | Show diagnostic float for current line                |
| `<leader>fd` | Telescope picker of all diagnostics in workspace      |

## Code actions & refactoring

| Key          | What it does                                                  |
| ------------ | ------------------------------------------------------------- |
| `<leader>ca` | Code actions menu (auto-imports, quick fixes, refactors)      |
| `<leader>rn` | Rename symbol across the whole project                        |

## Inside a Telescope picker

| Key                | What it does                          |
| ------------------ | ------------------------------------- |
| `<C-n>` / `<C-p>`  | Next / previous result                |
| `<CR>`             | Open selected                         |
| `<C-v>`            | Open in vertical split                |
| `<C-x>`            | Open in horizontal split              |
| `<C-t>`            | Open in new tab                       |
| `<C-/>`            | Show all keybindings (in insert mode) |
| `<Esc>`            | Close picker                          |

The Telescope picker replaces the old quickfix list — exit with `<Esc>` rather
than `:q`.

## A typical review flow

1. `<leader>ff` — open the entry file
2. `<leader>ds` — see file outline, jump to a function
3. `gd` on a call — into the implementation
4. `gr` on the function name — who else calls this? Skim the picker preview.
5. `<C-o>` repeatedly — walk back to where you started
6. `<leader>ws` — jump anywhere by symbol name
7. `]d` — next error/warning the LSP flags

The `<C-o>` / `<C-i>` jumplist is the most underused feature — every `gd`,
`gr`, search, etc. pushes onto it, so you can wander deep and walk back
step-by-step.

## Languages currently configured

Servers installed via Mason (`ensure_installed` in `init.lua`):

- `gopls` — Go
- `ts_ls` — TypeScript / JavaScript
- `pyright` — Python
- `rust_analyzer` — Rust
- `lua_ls` — Lua
- `clangd` — C / C++
- `bashls` — Shell
- `jsonls` — JSON
- `yamlls` — YAML
- `marksman` — Markdown

To add a language: append its server name to `ensure_installed` in `init.lua`,
restart nvim, run `:MasonInstallAll`. Servers are lazy — only the one matching
the current filetype runs, so the list can grow without slowing nvim down.
