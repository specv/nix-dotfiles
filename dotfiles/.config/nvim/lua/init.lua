-- useful for commands like `5j` `5>>`
vim.opt.number = true
vim.opt.relativenumber = true
-- enables 24-bit RGB color in the TUI
vim.opt.termguicolors = true
-- disable vim automatic visual mode on mouse select
vim.opt.mouse = ""
-- yanking/pasting on system clipboard directly
vim.opt.clipboard = "unnamedplus"
-- highlight search
vim.opt.hlsearch = true
-- incremental search
vim.opt.incsearch = true
-- case-insensitive search by default. i.e. `/foo\c`
vim.opt.ignorecase = true
-- mixed-case search. lower case for case-insensitive, upper case for case-sensitive
-- use \C to force the pattern to be case-sensitive. \C can go anywhere in the search. e.g. `/\Cinclude` `/include\C`
vim.opt.smartcase = true
-- highlight current line
vim.opt.cursorline = true
-- disable netrw(builtin file explorer)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Indent Blankline: adds indentation guides to all lines (including empty lines)
-- rainbow-delimiters.nvim integration
local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
require("rainbow-delimiters.setup").setup { highlight = highlight }
require("ibl").setup {
  -- Scope requires treesitter to be set up.
  scope = {
    show_start = false,
    show_end = false,
    highlight = highlight,
  },
}

-- tokyonight color theme
require("tokyonight").setup {
  style = "moon"
}
vim.cmd("colorscheme tokyonight")

-- navigate your code with search labels, enhanced character motions and Treesitter integration
require("flash").setup {
  jump = {
    autojump = false,
  },
  modes = {
    -- a regular search with `/` or `?`
    search = {
      enabled = true
    },
    -- `f`, `F`, `t`, `T`, `;` and `,` motions
    char = {
      enabled = true,
      jump_labels = false
    }
  },
}
vim.keymap.set({ "n","o","x" }, "s", function() require("flash").jump() end, { desc = "Flash" })

-- blazing fast and easy to configure Neovim statusline written in Lua
require("lualine").setup {
  options = {
    theme = "tokyonight"
  }
}

require("nvim-treesitter.configs").setup {
  -- consistent syntax highlighting
  highlight = {
    enable = true
  },
  -- indentation based on treesitter for the `=` operator
  indent = { 
    enable = true
  },
}

-- open your Kitty scrollback buffer with Neovim
require('kitty-scrollback').setup()

-- smart and powerful comment plugin for neovim
require("Comment").setup()

-- auto insert matching brackets, parens, quotes
require("nvim-autopairs").setup()

-- highlight colors
require('nvim-highlight-colors').setup()

-- a file manager for Neovim which lets you edit your filesystem like you edit text
require("dirbuf").setup {
  hash_padding = 2,
  show_hidden = true,
  sort_order = "default",
  write_cmd = "DirbufSync",
}

-- a file explorer tree for neovim written in lua
require("nvim-tree").setup {
  hijack_directories = { enable = true },
  auto_reload_on_write = true,
  disable_netrw = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    root_folder_label = false,
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      git = false,
      profile = false,
    },
  },
}
