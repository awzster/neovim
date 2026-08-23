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
vim.keymap.set('i', '<S-Insert>', '<C-r>*', { silent = true })
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yank" })
--vim.keymap.set("n", "<leader>r", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })
vim.keymap.set("n", "<F2>", "bve", { desc = "Select word" })
--map("n", "<leader>p", "`[v`]")


local utils = require("config.utils")
-- lualine
require('lualine').setup({
  options = {
    theme = 'auto',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { utils.filename_with_bufnr },
    --lualine_c = { 'buffers' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', utils.char_code },
  },
  extensions = { 'quickfix', 'nvim-tree', 'aerial' }
})

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("bufferline").go_to(i, true)
  end, { silent = true, desc = "BufferLine: Go to tab " .. i })
end

vim.keymap.set("n", "<F12>", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Toggle file tree" })
-- Normal mode: Навигация по визуальному порядку
vim.keymap.set("n", "<S-Left>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer (visual)" })
vim.keymap.set("n", "<S-Right>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer (visual)" })
vim.keymap.set("n", "<C-Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer (visual)" })

-- Insert mode: Выход в Normal и переключение
-- (используем <Cmd>...<CR> для чистоты, но <Esc> в начале необходим)
vim.keymap.set("i", "<S-Left>", "<Esc><Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer (visual)" })
vim.keymap.set("i", "<S-Right>", "<Esc><Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer (visual)" })
vim.keymap.set("i", "<C-Tab>", "<Esc><Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer (visual)" })


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
    vim.cmd([[%s/\/\*\_.\{-}\*\/\s*//gce]])
    
    -- Возвращаем курсор на место
    vim.fn.setpos(".", save_cursor)
    
    print("Cleaned up! CSS comments removed.")
end, { desc = "Удаляет все многострочные комментарии /* ... */ из текущего буфера" })


