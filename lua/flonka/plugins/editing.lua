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

  -- Formatting plugin
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
          typescript = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          lua = { "stylua" },
          go = { "goimports", "gofumpt" },
          python = { "black" },
          groovy = { "npm-groovy-lint" },
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
    config = function()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'

      vim.defer_fn(function()
        require("nvim-treesitter.configs").setup {
          -- Add languages to be installed here that you want installed for treesitter
          ensure_installed = {
            "bash",
            "css",
            "csv",
            "dot",
            "go",
            "html",
            "java",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "regex",
            "sql",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
          },

          sync_install = false,
          ignore_install = {},
          modules = {},

          -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
          auto_install = false,

          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<c-space>",
              node_incremental = "<c-space>",
              scope_incremental = "<c-s>",
              node_decremental = "<M-space>",
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
              },
              goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
              },
              goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
              },
              goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ["<leader>a"] = "@parameter.inner",
              },
              swap_previous = {
                ["<leader>A"] = "@parameter.inner",
              },
            },
          },
        }
      end, 0)
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      require("todo-comments").setup {}
    end,
  },
}
