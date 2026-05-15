require("nvchad.configs.lspconfig").defaults() -- Lista de servidores

local servers = { "html", "cssls", "tailwindcss", "ts_ls", "eslint", "dockerls", "docker_compose_language_service" }
vim.lsp.enable(servers)
