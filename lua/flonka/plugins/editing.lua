return {
  -- https://github.com/kylechui/nvim-surround
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-surround").setup {
      -- Configuration here, or leave empty to use defaults
    }
  end,
}
