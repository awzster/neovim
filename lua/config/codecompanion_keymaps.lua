-- CodeCompanion keymaps
-- Adjust commands if your installed version uses different names (see :help codecompanion)

local opts = { noremap = true, silent = true }

-- Chat
vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat<CR>", opts)

-- Inline (apply / rewrite selection)
vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanionInline<CR>", opts)

-- Agent / Actions (often opens an action palette or agent UI)
vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<CR>", opts)

-- Optional: toggle chat visibility, if supported in your version
-- vim.keymap.set("n", "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", opts)

