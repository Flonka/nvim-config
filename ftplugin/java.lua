-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- https://github.com/mfussenegger/nvim-jdtls
local home = os.getenv "HOME"

-- 💀
-- This is the default if not provided, you can remove it. Or adjust as needed.
-- One dedicated LSP server & client will be started per unique root_dir
local root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew" }
-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local config = {
  -- The command that starts the language server
  --
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  --
  cmd = {

    -- 💀
    --"/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin/java", -- or '/path/to/java17_or_newer/bin/java'
    "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java",
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    -- Lombok support
    "-javaagent:"
      .. home
      .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",

    -- 💀
    "-jar",
    -- "/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar",
    vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls"
      .. "/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    "-configuration",
    -- "/path/to/jdtls_install_location/config_SYSTEM",
    vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls" .. "/config_mac",
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    -- 💀
    -- See `data directory configuration` section in the README
    "-data",
    -- "/path/to/unique/per/project/workspace/folder",
    workspace_folder,
  },
  root_dir = root_dir,
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      -- home = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
      format = {
        -- enabled = false,
        -- tabSize = 1,
        -- insertSpaces = false,
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          url = "~/code/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
