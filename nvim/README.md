# nvim

A minimal, single-file Neovim config targeting **Neovim 0.12+**.

The whole config is one ~165-line `init.lua`. No plugin manager beyond the
built-in `vim.pack`, no `lazy.nvim`, no abstraction layers. Everything is
plain Lua you can read top-to-bottom in a couple of minutes.

## Requirements

- **Neovim 0.12 or newer** (`brew install neovim`)
- A few system tools the config relies on:

  ```sh
  brew install tree-sitter-cli ripgrep lua-language-server yaml-language-server
  brew install haskell-language-server   # optional, only if you write Haskell
  ```

  | Tool | Used by |
  |---|---|
  | `tree-sitter-cli` | nvim-treesitter (compiles parsers) |
  | `ripgrep` | `<leader>f`, `<leader>/`, `<leader>?` (mini.pick) |
  | `lua-language-server` | `lua_ls` |
  | `yaml-language-server` | `yamlls` |
  | `haskell-language-server` | `hls` |

  The `ty` Python LSP is installed automatically by Mason.

## Installation

The config is stowed from the parent `dotfiles` repo. From the repo root:

```sh
stow nvim
```

That symlinks `nvim/.config/nvim/` into `~/.config/nvim/`. Launch `nvim`
and `vim.pack` will fetch all plugins on first start, then nvim-treesitter
will compile its parsers (one-off; see the prompts).

## Layout

```
nvim/.config/nvim/
├── init.lua              # everything lives here
└── nvim-pack-lock.json   # auto-managed by vim.pack — commit this
```

`init.lua` is split into 6 sections, in this order:

1. **options** — tabs, line numbers, clipboard, search, completion popup
2. **plugins** — `vim.pack.add` + each plugin's `setup()`
3. **treesitter** — parser install list + `FileType` autocmd
4. **LSP** — `vim.lsp.config` / `vim.lsp.enable` + `LspAttach` autocmd
5. **keymaps** — global maps grouped by purpose
6. **python helpers** — select / yank / delete the `def` above the cursor

To change behaviour, edit the relevant section. To add a new LSP server:
append its name to the list inside `vim.lsp.enable({...})` and (if
needed) install its binary.

## Plugins

| Plugin | Purpose |
|---|---|
| [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim) | colorscheme (transparent) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | syntax highlighting (`main` branch) |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | default LSP server configs |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | install LSP servers without leaving nvim |
| [mini.pick](https://github.com/echasnovski/mini.pick) | fuzzy file/grep/help picker |
| [mini.extra](https://github.com/echasnovski/mini.extra) | extra pickers (workspace symbols) |
| [mini.pairs](https://github.com/echasnovski/mini.pairs) | auto-close brackets/quotes |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | edit the filesystem like a buffer |

## Keymaps

Leader is `<Space>`.

### Files & buffers
| Key | Action |
|---|---|
| `<leader>w` | write buffer |
| `<leader>q` | quit |
| `<leader>o` | save current file & re-source it |
| `<leader>v` | edit `$MYVIMRC` (this file) |
| `<leader>s` | swap to the alternate buffer |
| `<leader>O` | open Oil file browser |

### Find / search
| Key | Action |
|---|---|
| `<leader>f` | find files (ripgrep) |
| `<leader>h` | help tags |
| `<leader>/` | live grep |
| `<leader>?` | live grep word under cursor |
| `<leader>F` | workspace LSP symbols |
| `<Esc>` | clear search highlight |

### LSP (active when a server attaches)
| Key | Action |
|---|---|
| `gd` / `gD` | definition / declaration |
| `gi` | implementation |
| `gr` | references |
| `<leader>e` | open diagnostic float |
| `<leader>lf` | format buffer |
| `<CR>` (insert) | accept selected completion item |

### Editing
| Key | Action |
|---|---|
| `<leader>y` (n/v/x) | yank to system clipboard |
| `n` / `N` | search next/prev, recentred |
| `<C-d>` / `<C-u>` | half-page jump, recentred |

### Python (when cursor is inside or below a `def`)
| Key | Action |
|---|---|
| `<leader>vm` | visual-select the `def` |
| `<leader>ym` | yank the `def` |
| `<leader>dm` | delete the `def` |

## Updating plugins

```vim
:lua vim.pack.update()
```

Then commit the updated `nvim-pack-lock.json`.

## Troubleshooting

- **`tree-sitter` ENOENT errors at startup** → install `tree-sitter-cli` (see Requirements).
- **An LSP isn't attaching** → run `:checkhealth vim.lsp`. Most common cause is a missing binary on `$PATH`.
- **Treesitter highlights missing for a language** → add the language to `ts_langs` in the treesitter section, restart, accept the parser install prompt.
- **Fresh machine, nothing works** → walk through Requirements, then `stow nvim`, then launch `nvim` and let `vim.pack` install everything.
