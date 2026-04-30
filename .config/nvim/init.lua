-- Minimal, learning-friendly Neovim config.
-- Each option is commented so you can toggle and feel the difference.

-- =========================
-- General Config
-- =========================

-- Leader key: space (kept minimal on purpose)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI and ergonomics
vim.opt.number = true             -- Show absolute line numbers
vim.opt.relativenumber = true     -- Show relative numbers for faster motions
vim.opt.cursorline = true         -- Highlight current line for focus
vim.opt.signcolumn = "yes"        -- Keep sign column to avoid text shifting
vim.opt.scrolloff = 8             -- Keep 8 lines visible above/below cursor

-- Indentation
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.tabstop = 4               -- Display width of a tab character
vim.opt.shiftwidth = 4            -- Indent size for << and >>
vim.opt.smartindent = true        -- Smart auto-indenting on new lines

-- Searching
vim.opt.ignorecase = true         -- Case-insensitive search...
vim.opt.smartcase = true          -- ...unless you use uppercase in the query
vim.opt.incsearch = true          -- Show matches as you type

-- Files and undo
vim.opt.undofile = true           -- Persistent undo across sessions
vim.opt.updatetime = 250          -- Faster CursorHold events (LSP, diagnostics)
vim.opt.swapfile = false          -- Disable swapfile (use undo instead)

-- Better completion menu behavior
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Use the system clipboard for all yank/paste operations.
-- y/d/p will read/write the macOS clipboard, so cmd+v works in other apps.
vim.opt.clipboard = "unnamedplus"

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- General Plugins
-- =========================

require("lazy").setup({
  -- Detect indent style automatically per file
  { "tpope/vim-sleuth" },

  -- Git signs in the gutter (added/changed/deleted indicators)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Seamless navigation between Vim splits and tmux panes
  { "christoomey/vim-tmux-navigator" },

  -- Theme: Catppuccin (polished, balanced)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Fuzzy finder for files and text (optional but high leverage)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/" },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
    end,
  },

  -- File tree sidebar
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          local opts = { buffer = bufnr, noremap = true, silent = true }

          api.config.mappings.default_on_attach(bufnr)

          -- l/h to expand/collapse like other file tree UIs
          vim.keymap.set("n", "l", api.node.open.edit, opts)
          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
          -- Esc to jump back to the file buffer
          vim.keymap.set("n", "<Esc>", "<C-w>p", opts)
        end,
        view = {
          width = 35,
        },
        actions = {
          change_dir = {
            restrict_above_cwd = true,
          },
          open_file = {
            quit_on_open = true,
          },
        },
        renderer = {
          group_empty = true,    -- collapse empty nested folders into one line (e.g. a/b/c)
        },
      })

      vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeToggle<cr>")
    end,
  },

  -- =========================
  -- Treesitter (syntax highlighting)
  -- =========================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "go", "gomod", "gosum",
        "typescript", "tsx", "javascript",
        "python", "rust", "lua", "c", "cpp",
        "bash", "json", "yaml", "markdown", "markdown_inline",
      },
      highlight = { enable = true },
    },
  },

  -- =========================
  -- Markdown inline rendering
  -- =========================
  -- Renders headings, lists, code blocks, tables, checkboxes inline in the
  -- buffer. Buffer stays editable; toggle with :RenderMarkdown toggle.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
  },

  -- =========================
  -- LSP: Mason + lspconfig
  -- =========================
  { "mason-org/mason.nvim", config = true },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "ts_ls",
          "pyright",
          "rust_analyzer",
          "lua_ls",
          "clangd",
          "bashls",
          "jsonls",
          "yamlls",
          "marksman",
        },
      })
    end,
  },
})

-- =========================
-- Per-server LSP overrides
-- =========================
-- Defaults from nvim-lspconfig are applied automatically; only customize here.

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- =========================
-- LSP & navigation keymaps
-- =========================
local opts = { noremap = true, silent = true }
local tb = function(name)
  return function() require("telescope.builtin")[name]() end
end

-- Jump to symbol info (Telescope picker shows preview + fuzzy filter)
vim.keymap.set("n", "gd", tb("lsp_definitions"), opts)        -- go to definition
vim.keymap.set("n", "gr", tb("lsp_references"), opts)         -- find references
vim.keymap.set("n", "gi", tb("lsp_implementations"), opts)    -- implementations of interface
vim.keymap.set("n", "gy", tb("lsp_type_definitions"), opts)   -- go to type definition
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)             -- hover docs
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)   -- rename symbol
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- code actions

-- Symbol outline / project-wide symbol search
vim.keymap.set("n", "<leader>ds", tb("lsp_document_symbols"), opts)
vim.keymap.set("n", "<leader>ws", tb("lsp_dynamic_workspace_symbols"), opts)

-- Diagnostics
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>fd", tb("diagnostics"), opts)

-- Format on save for Go files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- :q exits nvim even when nvim-tree is open alongside one file buffer.
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local wins = vim.api.nvim_list_wins()
    local real_wins = 0
    for _, w in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(w)
      local is_tree = vim.api.nvim_buf_get_name(buf):match("NvimTree_")
      local is_floating = vim.api.nvim_win_get_config(w).relative ~= ""
      if not is_tree and not is_floating then
        real_wins = real_wins + 1
      end
    end
    if real_wins <= 1 then
      vim.cmd("qa")
    end
  end,
})
