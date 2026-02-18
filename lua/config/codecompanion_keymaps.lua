-- codecompanion_keymaps.lua

local opts = { noremap = true, silent = true }
local visual_opts = { noremap = true, silent = true, mode = "v" }

-- Основные команды
vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", opts) -- Toggle чата
vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<CR>", opts)      -- Палитра действий

-- Выделение + действия (visual mode)
vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanionInline<CR>", opts)        -- Инлайн редактирование
vim.keymap.set("v", "<leader>ae", "<cmd>CodeCompanionChat Explain<CR>", opts)  -- Объяснить код
vim.keymap.set("v", "<leader>ar", "<cmd>CodeCompanionChat Refactor<CR>", opts) -- Рефакторинг
vim.keymap.set("v", "<leader>af", "<cmd>CodeCompanionChat Fix<CR>", opts)      -- Исправить баги
vim.keymap.set("v", "<leader>ad", "<cmd>CodeCompanionChat Docs<CR>", opts)     -- Документация

-- Буфер + чат
vim.keymap.set("n", "<leader>ab", "<cmd>CodeCompanionChat Add<CR>", opts)      -- Добавить буфер в чат
vim.keymap.set("v", "<leader>as", "<cmd>CodeCompanionChat Send<CR>", opts)     -- Отправить выделенное

-- Навигация по чатам (если несколько)
vim.keymap.set("n", "<leader>an", "<cmd>CodeCompanionChat Next<CR>", opts)     -- Следующий чат
vim.keymap.set("n", "<leader>ap", "<cmd>CodeCompanionChat Prev<CR>", opts)     -- Предыдущий чат

-- Быстрый доступ к последнему чату
vim.keymap.set("n", "<leader>a<leader>", "<cmd>CodeCompanionChat<CR>", opts)
