return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    open_mapping = [[<C-t>]],
    auto_chdir = true,
    -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
    direction = "float",
    --   float_opts = {
    --   -- The border key is *almost* the same as 'nvim_open_win'
    --   -- see :h nvim_open_win for details on borders however
    --   -- the 'curved' border is a custom border type
    --   -- not natively supported but implemented in this plugin.
    --   border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    --   -- like `size`, width and height can be a number or function which is passed the current terminal
    --   width = <value>,
    --   height = <value>,
    --   winblend = 3,
    --   zindex = <value>,
    -- },
    float_opts = {
      border = "rounded",
    },
  },
}
