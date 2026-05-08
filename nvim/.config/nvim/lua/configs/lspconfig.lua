require("nvchad.configs.lspconfig").defaults()-- Lista de servidores

local servers = { "html", "cssls", "tailwindcss", "ts_ls" }
vim.lsp.enable(servers)
