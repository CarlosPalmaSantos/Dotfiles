return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      handler_opts = { border = "rounded" },
      auto_close_after = nil,
      floating_window = true,
      hint_enable = false,
      always_trigger = false,
      toggle_key = "<M-x>",
    },
  },
}
