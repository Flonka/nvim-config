return {
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          "n",
          "<leader>hp",
          require("gitsigns").preview_hunk,
          { buffer = bufnr, desc = "Preview git hunk" }
        )

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ "n", "v" }, "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
        vim.keymap.set({ "n", "v" }, "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
      end,
    },
  },
  {
    "ruifm/gitlinker.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local gitlinker = require "gitlinker"

      gitlinker.setup {
        callbacks = {
          -- Bitbucket onpremise server
          ["bitbucket.crosskey.fi"] = function(url_data)
            -- Create a table to store the split parts
            local repoSplit = {}
            -- Use string.gmatch to iterate over the string parts
            for part in url_data.repo:gmatch "[^/]+" do
              table.insert(repoSplit, part)
            end

            local url = "https://" .. url_data.host
            if url_data.port then
              url = url .. ":" .. url_data.port
            end

            url = url .. "/projects/" .. repoSplit[1] .. "/repos/" .. repoSplit[2] .. "/browse"

            if url_data.file then
              url = url .. "/" .. url_data.file
            end

            if url_data.rev then
              url = url .. "?at=" .. url_data.rev
            end

            if url_data.lstart then
              url = url .. "#" .. url_data.lstart
              if url_data.lend then
                url = url .. "-" .. url_data.lend
              end
            end
            return url
          end,
        },
      }
      -- Open on remote
      vim.keymap.set("n", "<leader>gY", function()
        gitlinker.get_buf_range_url("n", { action_callback = gitlinker.actions.open_in_browser })
      end, { desc = "Open file on git remote", silent = true })

      vim.keymap.set("v", "<leader>gY", function()
        gitlinker.get_buf_range_url("v", { action_callback = gitlinker.actions.open_in_browser })
      end, { desc = "Open file on git remote", silent = true })

      vim.keymap.set("n", "<leader>gB", function()
        gitlinker.get_repo_url { action_callback = gitlinker.actions.open_in_browser }
      end, { desc = "Open base repository on remote", silent = true })
    end,
  },
}
