-- lua/config/ui.lua
-- UI: nvim-tree, telescope

-- ═══════════════════════════════════════════════════════════
-- NVIM-TREE
-- ═══════════════════════════════════════════════════════════

require("nvim-tree").setup({
  sort_by = "modification_time",
  renderer = {
    group_empty = true,
  },
})

-- ═══════════════════════════════════════════════════════════
-- TELESCOPE
-- ═══════════════════════════════════════════════════════════
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    path_display = { "truncate" },
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
    },
  },
})

-- Extensions
telescope.load_extension("aerial")
require('telescope').load_extension('fzf')
-- Keymaps
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })

-- Поиск слова под курсором (Normal mode) или выделения (Visual mode)
vim.keymap.set({ "n", "v" }, "<leader>fs", builtin.grep_string, { desc = "Grep selection/word" })
--[[ vim.keymap.set("n", "<leader>fs", function()
  builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" }) ]]

-- Поиск слова под курсором ТОЛЬКО в открытых буферах
vim.keymap.set("n", "<leader>fS", function()
  require('telescope.builtin').grep_string({ 
    grep_open_files = true 
  })
end, { desc = "Telescope: Search word under cursor in open buffers" })

vim.keymap.set("n", "<leader>fa", function()
  telescope.extensions.aerial.aerial()
end, { desc = "Search symbols (Aerial)" })

-- 🎯 Прыжки по коду (Интеллектуальные)
-- Вместо стандартного gd/gr теперь используем Telescope
vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Telescope: Definition" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Telescope: References" })
vim.keymap.set("n", "<leader>fi", builtin.lsp_implementations, { desc = "Telescope: Implementations" })

-- 📝 Символы (Функции/Переменные)
-- Идеально для жирных контроллеров AngularJS
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Telescope: Symbols in Project" })

-- ↩️ Возврат к последнему поиску (Гениальная вещь!)
-- Если ты что-то искал, перешел в файл, а потом хочешь вернуться к списку поиска
vim.keymap.set("n", "<leader>f<leader>", builtin.resume, { desc = "Telescope: Resume last search" })

-- 📂 Последние открытые файлы (Быстрее, чем лезть в дерево)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope: Recent files" })

-- 🔎 Поиск во всех открытых буферах (Когда помнишь код, но не помнишь файл)
vim.keymap.set("n", "<leader>f/", function()
  builtin.live_grep({ grep_open_files = true })
end, { desc = "Telescope: Search in open buffers" })
-- ═══════════════════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════════════════
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yank" })
--vim.keymap.set("n", "<leader>r", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })
vim.keymap.set("n", "<F2>", "bve", { desc = "Select word" })
--nmap <F2> bve
--map("n", "<leader>p", "`[v`]")

local utils = require("config.utils")
-- lualine
require('lualine').setup({
  options = {
    theme = 'catppuccin',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { utils.filename_with_bufnr },
    --lualine_c = { 'buffers' },
    lualine_x = { utils.get_ai_status, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', utils.char_code },
  },
  -- tabline = {
  --   lualine_c = {
  --     {
  --       'buffers',
  --       mode = 2,
  --       max_length = 190,
  --       show_buffer_close_icons = false,
  --       show_filename_only = true,
  --       show_modified_status = true,
  --
  --     }
  --   },
  --   lualine_z = { 'tabs' },
  -- },
  extensions = { 'quickfix', 'nvim-tree', 'aerial' }
})

for i = 1, 9 do
  local index = i
  vim.keymap.set("n", "<Leader>" .. index, function()
    -- Получаем список всех ПЕРЕЧИСЛЕННЫХ буферов (buflisted)
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    
    if bufs[index] then
      -- bufs[index].bufnr — это реальный ID буфера (например, 3)
      vim.api.nvim_set_current_buf(bufs[index].bufnr)
    else
      vim.notify("Buffer " .. index .. " not found in list", vim.log.levels.WARN)
    end
  end, { desc = "Switch to listed buffer #" .. index })
end

vim.keymap.set("n", "<F12>", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Toggle file tree" })
-- Навигация по буферам
vim.keymap.set("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("i", "<S-Left>", "<Esc><cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("i", "<S-Right>", "<Esc><cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("i", "<C-Tab>", "<Esc><cmd>bnext<cr>", { desc = "Next buffer" })

-- Переместить текущий буфер влево (Ctrl + Shift + Left)
vim.keymap.set("n", "<C-S-Left>", "<Cmd>BufferLineMovePrev<CR>", { silent = true, desc = "Buffer: Move Left" })

-- Переместить текущий буфер вправо (Ctrl + Shift + Right)
vim.keymap.set("n", "<C-S-Right>", "<Cmd>BufferLineMoveNext<CR>", { silent = true, desc = "Buffer: Move Right" })


vim.keymap.set("i", "<C-\\>", function()
  require("luasnip").expand()
end, { silent = true })

-- Замена выделенного текста
vim.keymap.set("x", "<leader><leader>r", function()
    local old_reg = vim.fn.getreg('"')
    local old_regtype = vim.fn.getregtype('"')

    vim.cmd('normal! "vy')
    local selection = vim.fn.getreg('v')

    vim.fn.setreg('"', old_reg, old_regtype)

    selection = vim.fn.escape(selection, [[\/.*$^~[]])

    local cmd = ":%s/" .. selection .. "//gci"
    local keys = vim.api.nvim_replace_termcodes(cmd .. string.rep("<Left>", 4), true, false, true)

    vim.api.nvim_feedkeys(keys, "n", false)
end, { desc = "Substitute visual selection" })


-- Глобальный биндинг: работает всегда, когда активен любой LSP сервер
vim.keymap.set("n", "<leader>rn", function()
  vim.lsp.buf.rename()
end, { desc = "LSP: Smart Rename" })

-- === ДОП: полный список ошибок по хоткею (опционально) ===
vim.keymap.set("n", "<leader>dd", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostics at cursor" })

vim.keymap.set("n", "<leader>de", function()
  vim.diagnostic.setloclist()
end, { desc = "Open diagnostics in loclist" })

vim.api.nvim_create_user_command("RemoveComment", function()
    -- Сохраняем позицию курсора, чтобы он не улетел в начало файла
    local save_cursor = vim.fn.getpos(".")
    
    -- Выполняем замену: 
    -- \_.\{-} — это "ленивый" поиск через любые символы включая переносы
    -- 'e' в конце подавляет ошибку, если комментариев в файле нет
    vim.cmd([[%s/\/\*\_.\{-}\*\/\s*//gce]])
    
    -- Возвращаем курсор на место
    vim.fn.setpos(".", save_cursor)
    
    print("Cleaned up! CSS comments removed.")
end, { desc = "Удаляет все многострочные комментарии /* ... */ из текущего буфера" })
  -- to remeber
  --[[ map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "K",  vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action") ]]

-- Создаем команду для ручного ввода: :MinuetModel qwen2.5-coder:7b
vim.api.nvim_create_user_command('MinuetModel', function(opts)
    change_minuet_model(opts.args)
end, { nargs = 1 })

-- Выбор модели Ollama для Minuet через Telescope
vim.keymap.set('n', '<leader>om', function()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local utils = require("config.utils")

    --local models = { "crow-coder", "qwen2.5-coder:7b", "codellama" }

-- Получаем список моделей прямо из Ollama
    local models = {}
    -- Команда берет вывод 'ollama list', пропускает заголовок и забирает первую колонку
    local handle = io.popen("ollama list | tail -n +2 | awk '{print $1}'")
    if handle then
        for line in handle:lines() do
            if line ~= "" then table.insert(models, line) end
        end
        handle:close()
    end

    -- На случай, если Ollama не запущена или моделей нет
    if #models == 0 then 
        models = { "qwen2.5-coder:7b" } 
    end

    pickers.new({}, {
        prompt_title = "🤖 Select AI Model",
        finder = finders.new_table { results = models },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local model_name = selection[1]

                -- 1. Сначала закрываем Telescope
                actions.close(prompt_bufnr)

                -- 2. Откладываем выполнение логики до следующего тика Neovim
                -- Это позволит Treesitter-context и другим плагинам успокоиться
                vim.schedule(function()
                    utils.change_minuet_model(model_name)
                end)
            end)
            return true
        end,
    }):find()
end, { desc = "Telescope: Change Ollama model" })
