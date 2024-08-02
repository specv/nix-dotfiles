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
-- number of screen lines to use for the command-line
vim.opt.cmdheight = 0
-- highlight current line
vim.opt.cursorline = true
-- disable netrw(builtin file explorer)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
-- for `which-key`
vim.opt.timeoutlen = 300
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

-- soothing pastel theme for (Neo)vim
require("catppuccin").setup {
  flavour = "frappe",
  transparent_background = true,
}
vim.cmd.colorscheme "catppuccin"

-- navigate your code with search labels, enhanced character motions and Treesitter integration
require("flash").setup {
  jump = {
    autojump = false,
  },
  modes = {
    -- a regular search with `/` or `?`
    search = {
      enabled = false
    },
    -- `f`, `F`, `t`, `T`, `;` and `,` motions
    char = {
      enabled = true,
      jump_labels = false
    }
  },
}
vim.keymap.set({ "n","o","x" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#2e7de9", fg = "#c8d3f5", bold = true })
vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#ff966c", fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e", bold = true })

-- blazing fast and easy to configure Neovim statusline written in Lua
require("lualine").setup {
  options = {
    theme = "catppuccin"
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

-- smart and powerful comment plugin for neovim
require("Comment").setup()

-- auto insert matching brackets, parens, quotes
require("nvim-autopairs").setup()

-- highlight colors
require("nvim-highlight-colors").setup()

-- a file explorer that lets you edit your filesystem like a normal Neovim buffer
require("oil").setup()

-- find, filter, preview, pick
require("telescope").setup {
  defaults = {
    -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
    mappings = {
      i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
        ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
      }
    }
  }
}

-- displays a popup with possible keybindings of the command you started typing
require("which-key").setup { 
  delay = 200,
  spec = {
    { "<leader>-", "<C-w>s", desc = "Split Window Below" },
    { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>b", group = "buffers" },
    { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>bh", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
    { "<leader>bl", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "<leader>br", "<cmd>e #<cr>", desc = "Switch to Recent Buffer" },
    { "<leader>bs", "<cmd>:ls<cr>", desc = "List Buffers" },
    { "<leader>bx", "<cmd>:bd<cr>", desc = "Delete Buffer" },
    { "<leader>f", group = "files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>s", group = "search" },
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
    { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy Find Current Buffer" },
    { "<leader>t", group = "tabs" },
    { "<leader>t$", "<cmd>tablast<cr>", desc = "Last Tab" },
    { "<leader>t0", "<cmd>tabfirst<cr>", desc = "First Tab" },
    { "<leader>t1", "1gt", desc = "Go to Tab 1" },
    { "<leader>t2", "2gt", desc = "Go to Tab 2" },
    { "<leader>t3", "3gt", desc = "Go to Tab 3" },
    { "<leader>t4", "4gt", desc = "Go to Tab 4" },
    { "<leader>t5", "5gt", desc = "Go to Tab 5" },
    { "<leader>t6", "6gt", desc = "Go to Tab 6" },
    { "<leader>t7", "7gt", desc = "Go to Tab 7" },
    { "<leader>t8", "8gt", desc = "Go to Tab 8" },
    { "<leader>t9", "9gt", desc = "Go to Tab 9" },
    { "<leader>tX", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
    { "<leader>th", "<cmd>tabprevious<cr>", desc = "Previous Tab" },
    { "<leader>tl", "<cmd>tabnext<cr>", desc = "Next Tab" },
    { "<leader>tn", "<cmd>tabnew<cr>", desc = "New Tab" },
    { "<leader>tr", "g<tab>", desc = "Switch to Recent Tab" },
    { "<leader>tt", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Tabs" },
    { "<leader>tx", "<cmd>tabclose<cr>", desc = "Close Tab" },
    { "<leader>w", group = "windows" },
    { "<leader>w-", "<C-w>s", desc = "Split Window Below" },
    { "<leader>wh", "<C-w>h", desc = "Go to Left Window" },
    { "<leader>wj", "<C-w>j", desc = "Go to Lower Window" },
    { "<leader>wk", "<C-w>k", desc = "Go to Upper Window" },
    { "<leader>wl", "<C-w>l", desc = "Go to Right Window" },
    { "<leader>wr", "<C-w>p", desc = "Switch to Recent Window" },
    { "<leader>ww", "<cmd>Telescope windows<cr>", desc = "Windows" },
    { "<leader>wx", "<C-w>c", desc = "Delete Window" },
    { "<leader>w|", "<C-w>v", desc = "Split Window Right" },
    { "<leader>|", "<C-w>v", desc = "Split Window Right" },
  }
}
vim.keymap.set({ "n", "i" }, "<C-s>", "<esc>:w<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i" }, "<C-x>", "<esc>:q<CR>", { noremap = true, silent = true })

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
