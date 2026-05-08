return {
  "nvim-tree/nvim-tree.lua",
  opts = function(_, opts)
    -- Iconos git
    opts.renderer = {
      icons = {
        glyphs = {
          git = {
            unstaged = "󰄱",
            staged = "󰱒",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    }

    -- Keymaps personalizados
    local api = require "nvim-tree.api"
    local prev_on_attach = opts.on_attach
    opts.on_attach = function(bufnr)
      if prev_on_attach then
        prev_on_attach(bufnr)
      else
        api.config.mappings.default_on_attach(bufnr)
      end

      local function map(key, action, desc)
        vim.keymap.set("n", key, action, {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        })
      end

      map("l", api.node.open.edit, "Open")
      map("h", function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "directory" and node.open then
          api.node.open.edit()
        else
          api.node.navigate.parent_close()
        end
      end, "Close / Parent")
    end

    return opts
  end,
}
