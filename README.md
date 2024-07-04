# Neovim config

You can see here most of my personal [Neovim](https://github.com/neovim/neovim) config. Hope you will find some useful parts to include in you own config (or at least inspiration ;) ).

## Context

I've been using Vim for close to 10 years, decided to move to Neovim, rewrite my vimrc in Lua and look for new plugins. A couple months of tweaks have passed and I feel my config has converged to a mostly stable point. That's when I've decided to open-source most of it.

I write code in Python and Django so the config is written with that use case in mind.

I use Neovim 0.9.5 (on 0.10.0 treesitter highlighting doesn't work, at least with my config) inside tmux on Ubuntu which is run through [Multipass](https://multipass.run) on MacOS in [iTerm2](https://iterm2.com) so some mappings (especially for moving between tabs/splits) can be specific to this setup.

## List of plugins and customizations

This section doesn't mention customizations that are just setting simple options found in a given plugin's docs. If you are curious which options I've chosen, you can find them in the source code.

For info on helper functions used throughout this config see [this section](#helpers-used-in-writing-this-config-file).

### Text object plugins

- [vim-textobj-user](https://github.com/kana/vim-textobj-user)
- [vim-textobj-indent](https://github.com/kana/vim-textobj-indent)
- [vim-textobj-parameter](https://github.com/sgur/vim-textobj-parameter)
- [vim-textobj-python](https://github.com/bps/vim-textobj-python)
- [vim-textobj-variable-segment](https://github.com/Julian/vim-textobj-variable-segment)
- [vim-textobj-xmlattr](https://github.com/whatyouhide/vim-textobj-xmlattr)
- [vim-textobj-chainmember](https://github.com/D4KU/vim-textobj-chainmember)
- [vim-textobj-chunk](https://github.com/Chun-Yang/vim-textobj-chunk):
    - I use `b` (as in block) instead of default `c` because `c` means Python class in [vim-textobj-python](https://github.com/bps/vim-textobj-python).
- [vim-textobj-brace](https://github.com/Julian/vim-textobj-brace):
    - I use `o` (looks similar to `()`) instead of default `b` because I use `b` in [vim-textobj-chunk](https://github.com/Chun-Yang/vim-textobj-chunk) (see previous item in this list).


### Tim Pope's plugins

- [vim-commentary](https://github.com/tpope/vim-commentary)
- [vim-repeat](https://github.com/tpope/vim-repeat)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [vim-surround](https://github.com/tpope/vim-surround):
    - I've disabled insert mode mappings (undocumented flag).

### Snippets (luasnip)

- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip):
    - `htmldjango` files include `html` snippets,
    - `python` files include `django` snippets.

### Autocomplete (nvim-cmp)

- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [cmp-path](https://github.com/hrsh7th/cmp-path)
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [cmp-cmdline-history](https://github.com/dmitmel/cmp-cmdline-history)
- [cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
- [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp):
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) autocompletes from all open buffers not just the active one,
    - `cmdline` search (`/` and `?`) autocompletes from the current buffer,
    - `cmdline` (`:`) autocompletes first from [cmp-path](https://github.com/hrsh7th/cmp-path) then falls back to [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) and [cmp-cmdline-history](https://github.com/dmitmel/cmp-cmdline-history).

### Language server plugins (mason, lspconfig)

- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim):
    - use [pyright language server](https://github.com/microsoft/pyright) for Python.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig):
    - no Python type checking,
    - no import sorting for Python (for that I use [isort](https://github.com/PyCQA/isort), see [below](#linting-and-formatting)),
    - mapping for showing all diagnostics in location list,
    - mapping for "go to definition" using LSP.

### Linting and formatting

- [nvim-lint](https://github.com/mfussenegger/nvim-lint):
    - use [flake8](https://github.com/PyCQA/flake8) for Python,
    - use [djlint](https://github.com/djlint/djLint) for Django templates,
    - automatically run linters on file open and save.
- [conform.nvim](https://github.com/stevearc/conform.nvim)
    - use [isort](https://github.com/PyCQA/isort) and [black](https://github.com/psf/black) for Python,
    - use [stylua](https://github.com/JohnnyMorganz/StyLua) for Lua,
    - commands for disabling/re-enabling autoformat on file save.

### Undo-related plugins

- [undotree](https://github.com/mbbill/undotree)
- [highlight-undo.nvim](https://github.com/tzachar/highlight-undo.nvim)
- [nvim-fundo](https://github.com/kevinhwang91/nvim-fundo)

### Plugins to make neovim look nicer

- [dracula.nvim](https://github.com/Mofiqul/dracula.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim):
    - besides filetype, showing also the language of treesitter parser for the line where the cursor is (it means that in HTML file if the cursor is in a script or style block, instead of just `html` you will see `html.javascript` or `html.css`, respectively),
    - show [vim-zoom](https://github.com/dhruvasagar/vim-zoom) marker.
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim):
    - showing tabs at the top, not buffers.
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim)

### Treesitter plugins

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)

### Telescope

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim):
    - trim whitespace at the beginning of lines found by grep,
    - to_fuzzy_refine for grep,
    - mapping for searching for files in home directory,
    - mapping for grepping string under cursor using word match,
    - mapping for searching for Python files.
- [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- [smart-open.nvim](https://github.com/danielfalk/smart-open.nvim):
    - use for finding files in current working directory.

### Other plugins

- [vim-yoink](https://github.com/svermeulen/vim-yoink):
    - paste with `p` doesn't swap in visual mode, `P` swaps (by default it's the other way around).
- [vim-lastplace](https://github.com/farmergreg/vim-lastplace)
- [vim-zoom](https://github.com/dhruvasagar/vim-zoom)
- [leap.nvim](https://github.com/ggandor/leap.nvim)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

### Other customizations

Mostly oneliners:

- mappings to tabedit/split/vsplit file relative to the directory of the current buffer,
- smart home - Home key cycles between first nonblank character on the line and the beginning of the line,
- treat long, wrapped lines as separate lines for moving around in them,
- search for visual selection,
- using `n` and `N` while searching centers on the line with the match,
- enter command line with semicolon (it's easier to type and I don't use the builtin mapping for semicolon),
- quickly repeat last command,
- select just pasted text,
- delete trailing whispace on save for Python and Lua files,
- recognize \*requirements\*.txt as requirements filetype.

## Helpers used in writing this config file

### Creating mappings Vim style

In my opinion creating mappings in vim using `nnoremap` and friends is much nicer and easier to read then neovim's `vim.keymap.set` and passing `opts`. That's why at the top of `init.lua` I create functions under `map` scope, so the rest of the config file can create mappings like: 

```lua
-- Smart Home
map.noremap_silent_expr({ "n", "v" }, "<Home>", "col('.') == match(getline('.'),'\\S')+1 ? 'g0' : 'g^'")
map.inoremap_silent_expr("<Home>", "col('.') == match(getline('.'),'\\S')+1 ? '<C-O>g0' : '<C-O>g^'")
```

By default all mappings created this way use `unique = true` (based on [this tip](https://nanotipsforvim.prose.sh/prevent-duplicate-keybindings)).

There are also two more helpers for creating mappings. When I use `map.cnoremap` I always mean just `:` command line but in neovim the meaning is broader. That's why I wrote `map.cnoremap_colon`:

```lua
-- easy going up in dirs
map.cnoremap_colon("..", "../")
map.cnoremap_colon("...", "../../")
map.cnoremap_colon("....", "../../../")
map.cnoremap_colon(".....", "../../../../")
```

Moreover, for some `map.cnoremap_colon` mappings I want to trigger them just at the beginning of the `:` command line (I could just use user commands for that but they have to start with an uppercase letter so they are harder to type and they don't expand in place). That's why I wrote `map.cnoremap_colon_prefix`:

```lua
-- easy tabedit/split/vsplit relative to the directory of the current buffer
map.cnoremap_colon_prefix("tt", "tabedit '.expand('%:h').'/")
map.cnoremap_colon_prefix("ss", "split '.expand('%:h').'/")
map.cnoremap_colon_prefix("vv", "vsplit '.expand('%:h').'/")
```

### Using names next to plugin configs in lazy

Based on [lazy.nvim docs](https://lazy.folke.io/spec/examples) the plugin specs should look like:
```lua
{
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright" },
            })
        end,
    },
}
```

However, when there are a lot of plugins I prefer to add names for each plugin spec and wrap it in `values` call before passing to `lazy`. In my opinion when scrolling through the file it's easier to find the config for a given plugin.

```lua
values({
    mason = {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    mason_lspconfig = {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright" },
            })
        end,
    },
})
```

## Custom treesitter highlights and injections

[python_highlights.scm](python_highlights.scm) file contains treesitter queries to highlight the docstrings of Python's module/class/function/attribute as comment, not as string. To use it copy the file to `after/queries/python/highlights.scm`.

[python_injections.scm](python_injections.scm) file contains a treesitter query to treat content of Python strings that include HTML tags or Django templates tags as `htmldjango` (changes highlighting and commenting with [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)). To use it copy the file to `after/queries/python/injections.scm`.

## License

Config files are released under the Apache 2.0 license (same as Neovim itself).
