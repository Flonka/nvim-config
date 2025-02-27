-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.

-- local lsputil = require "lspconfig.util"
local servers = {
  -- clangd = {},
  gopls = {
    -- root_dir = lsputil.root_pattern("go.work", "go.mod", ".git")
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
  pyright = {},
  -- rust_analyzer = {},
  ts_ls = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  dotls = {},
  -- jdtls , set filetypes to "nil" workaround to disable nvim-lspconfig client.
  -- In order to install the lsp via mason, but use the nvim-jdtls plugin via ftplugin setup.
  jdtls = { filetypes = { "nil" } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}
