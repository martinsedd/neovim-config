return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      preset = "modern",
      delay = 200,
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      win = {
        border = "rounded",
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      },
      layout = {
        width = { min = 20 }, -- min width of the columns
        spacing = 3, -- spacing between columns
      },
    })

    -- Document existing key chains
    wk.add({
      { "<leader>c", group = "code" },
      { "<leader>d", group = "document" },
      { "<leader>e", group = "explorer" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "harpoon" },
      { "<leader>l", group = "lsp" },
      { "<leader>n", group = "noice" },
      { "<leader>q", group = "quit" },
      { "<leader>r", group = "rename" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "toggle" },
      { "<leader>w", group = "workspace" },
      { "<leader>x", group = "diagnostics" },
    })
  end,
}
