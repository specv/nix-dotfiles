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
