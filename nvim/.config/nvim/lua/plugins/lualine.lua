return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Custom theme tweaks for your purple/neon aesthetic
    local lualine = require('lualine')

    lualine.setup({
      options = {
        theme = 'auto',
        -- Slanted separators for that modern look
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true, -- Single statusline at the very bottom
        refresh = { statusline = 1000 },
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { 
          { 'filename', path = 1, symbols = { modified = '  ', readonly = '', unnamed = '' } } 
        },
        lualine_x = { 
          'diagnostics', 
          'encoding', 
          'filetype' 
        },
        lualine_y = { 'progress' },
        lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'oil', 'fugitive', 'mason' },
    })
  end,
}
