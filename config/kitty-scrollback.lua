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
-- hide status line
vim.opt.laststatus = 0

-- soothing pastel theme for (Neo)vim
require("catppuccin").setup({
  flavour = "frappe",
  transparent_background = true,
})
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

-- open your Kitty scrollback buffer with Neovim
require('kitty-scrollback').setup {
  {
    paste_window = {
      yank_register_enabled = false
    }
  }
}
