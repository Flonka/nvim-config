return {
  -- https://github.com/kylechui/nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      ---@diagnostic disable-next-line missing-fields
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BuFNewFile" },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", event = { "BufReadPost", "BuFNewFile" }, opts = {} },

  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local conform = require "conform"

      local format_options = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 5000,
      }

      conform.setup {
        formatters_by_ft = {
          javascript = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          lua = { "stylua" },
          go = { "goimports", "gofumpt" },
          -- python = { "isort", "black" },
        },
        format_on_save = format_options,
      }

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format(format_options)
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },
}
