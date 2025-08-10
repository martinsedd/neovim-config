-- Disable netrw at the absolute earliest point
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw_gitignore = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.netrw_nogx = 1

-- Suppress error messages
vim.opt.shortmess:append("F")

require("config.lazy")
require("config.options")
require("config.keymaps")
