-- Plugin manager
require('config.lazy')
require("lazy").setup("plugins")

-- LSP Servers
vim.lsp.enable('rust_analyzer')

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Oil
vim.keymap.set("n", "<leader>op", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Yazi
vim.keymap.set("n", "<leader>cw", "<CMD>Oil<CR>", { desc = "Open yazi at the current file" })
vim.keymap.set("n", "<leader>cl", "<CMD>Oil<CR>", { desc = "Resume the last yazi session" })

-- Which key
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "file" },
  { "<leader>l", group = "lazy" },
  { "<leader>c", group = "yazi" },
  { "<leader>o", group = "oil" },

  -- Hide other keys, couldn't find a way to do it automatically in non-hackish way
  { "<leader>a", hidden=true},
  { "<leader>A", hidden=true},
  { "<leader>d", hidden=true},
  { "<leader>D", hidden=true},
  { "<leader>J", hidden=true},
  { "<leader>?", hidden=true},
  { "<leader>-", hidden=true},
})
