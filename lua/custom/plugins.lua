local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rust_recommended_style = 0
    end
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    init = function()
      return require "custom.configs.rust_config"
    end,
    --opts = function()
    --  return require "custom.configs.rust-tools"
    --end,
    --config = function(_, opts)
    --  require('rust-tools').setup(opts)
    --end
  },
  {
    'nvim-lua/plenary.nvim',
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
    init = function()
      return require "custom.configs.dap_config"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    init = function()
      return require "custom.configs.treesitter-context"
    end,
  },
  {
    'saecki/crates.nvim',
    ft = {"rust", "toml"},
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      crates.show()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      table.insert(M.sources, {name = "crates"})
      return M
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    init = function()
      return require "custom.configs.symbol-outline"
    end,
  },
}
return plugins
