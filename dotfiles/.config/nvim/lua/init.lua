-- useful for commands like `5j` `5>>`
vim.opt.number = true
vim.opt.relativenumber = true
-- disable search highlight
vim.opt.hlsearch = false
-- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- onedark color theme
require('onedark').setup {
  style = 'deep'
}
require('onedark').load()

-- blazing fast and easy to configure Neovim statusline written in Lua
require('lualine').setup()

require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained",
  -- consistent syntax highlighting (rainbow needs this option)
  highlight = {
    enable = true
  },
  -- indentation based on treesitter for the `=` operator
  indent = { 
    enable = true
  },
  -- nvim-ts-rainbow: rainbow parentheses using tree-sitter.
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

-- adds indentation guides to all lines (including empty lines)
require('indent_blankline').setup {
  show_current_context = true,
  show_current_context_start = false,
}

-- smart and powerful comment plugin for neovim
require('Comment').setup()

-- a file manager for Neovim which lets you edit your filesystem like you edit text
require("dirbuf").setup {
    hash_padding = 2,
    show_hidden = true,
    sort_order = "default",
    write_cmd = "DirbufSync",
}

-- a file explorer tree for neovim written in lua
require("nvim-tree").setup {
  update_to_buf_dir = { enable = true },
  auto_reload_on_write = true,
  disable_netrw = false,
  hide_root_folder = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 30,
    height = 30,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
  renderer = {
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
  ignore_ft_on_setup = {},
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
