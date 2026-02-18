-- ~/.config/nvim/init.lua

-- 0) базовые модули
require("config.utils")              -- nvm PATH, helpers

-- 1) lazy + плагины
require("config.plugins")            -- объявление плагинов

-- 2) конфигурации по плагинам/подсистемам
require("config.ui")                 -- lualine / nvim-tree / telescope
--require("config.cmp")                -- nvim-cmp
require("config.lsp")                -- mason / lspconfig / eslint, ts_ls
require("config.treesitter")         -- treesitter базовые модули
require("config.autopairs_autotag")  -- autopairs + autotag
require("config.conform")            -- форматирование eslint_d / prettier
require("config.diagnostics")        -- lsp_lines и переключатели
require("config.persistence")        -- mkview/loadview + lastpos
require("config.filetypes")          -- xsl → xml
--require("config.codecompanion")
--require("config.codecompanion_keymaps")

-- 3) .vim-подключения (как у тебя было)
vim.cmd("source ~/.config/nvim/src/functions.vim")
vim.cmd("source ~/.config/nvim/src/keymaps.vim")
vim.cmd("source ~/.config/nvim/src/plugin-config.vim")

require("config.ai_simple")

-- 4) общее
--vim.o.completeopt = "menu,menuone,noselect"
vim.opt.fileencoding = "utf-8"
vim.opt.encoding = 'utf-8'

vim.keymap.set("c", "<S-Insert>", "<C-r>+")

vim.cmd([[
  filetype plugin indent on
  syntax enable
]])
--vim.cmd("filetype plugin indent on")

-- Навигация стрелками в wildmenu
vim.cmd([[
  cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
  cnoremap <expr> <Up>   wildmenumode() ? "\<C-p>" : "\<Up>"
]])

-- Тема
vim.cmd("colorscheme gruvbox-material")

-- GUI
if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "FiraCode Nerd Font Mono:h17"
end

-- Определяем кастомные группы подсветки для cmp
vim.api.nvim_set_hl(0, "CmpPmenu", {
  bg = "#3c3836",  -- фон меню (как bg у gruvbox-material medium)
  fg = "#d4be98",  -- цвет текста
})

vim.api.nvim_set_hl(0, "CmpPmenuSel", {
  bg = "#3399cc",  -- ваш акцентный цвет
  fg = "#ffffff",  -- белый текст
  bold = true,
})

-- Оптимизация буфера обмена
vim.opt.clipboard = "unnamedplus" -- Использовать системный буфер по умолчанию

-- Если виснет, явно укажи провайдер (для x11/KDE)
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = 'xclip -selection clipboard',
    ['*'] = 'xclip -selection primary',
  },
  paste = {
    ['+'] = 'xclip -selection clipboard -o',
    ['*'] = 'xclip -selection primary -o',
  },
  cache_enabled = 1,
}

-- Функция для принудительной покраски Treesitter Context
local function set_context_colors()
    -- Цвета в стиле Solarized Dark (очень контрастные для Gruvbox)
    vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#002b36', fg = '#839496' })
    vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#002b36', fg = '#586e75' })
    -- Тонкое подчеркивание, чтобы отделить от основного кода
    vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { sp = '#93a1a1', underline = true })
end

-- Запускаем сразу
set_context_colors()

-- И вешаем на событие смены темы, чтобы Gruvbox не сбросил наши настройки
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_context_colors,
})
