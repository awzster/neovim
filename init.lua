-- ~/.config/nvim/init.lua
-- Минималистичная конфигурация

-- ═══════════════════════════════════════════════════════════
-- 1. LEADER
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- 2. БАЗОВЫЕ ОПЦИИ
-- ═══════════════════════════════════════════════════════════
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.clipboard = "unnamedplus"

-- Clipboard xclip
vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection primary",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection primary -o",
  },
  cache_enabled = 1,
}

-- Отступы
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cindent = true

-- UI
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.scrolloff = 5
vim.opt.showcmd = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,min:4,sbr"
vim.opt.showbreak = ">>"
vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "-" }

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- История и бэкапы
vim.opt.history = 10000
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo/"
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup/"
vim.opt.backupcopy = "yes"
vim.opt.writebackup = true

-- Фолды
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.opt.foldlevelstart = 99

-- GUI
if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "FiraCode Nerd Font Mono:h17"
end

-- ═══════════════════════════════════════════════════════════
-- 3. ФАЙЛТАЙПЫ
-- ═══════════════════════════════════════════════════════════
vim.filetype.add({
  extension = {
    xsl = "xml",
    jsp = "jsp",
  },
})

-- ═══════════════════════════════════════════════════════════
-- 4. ПЛАГИНЫ (lazy.nvim)
-- ═══════════════════════════════════════════════════════════
require("config.plugins")

-- ═══════════════════════════════════════════════════════════
-- 5. АВТОЗАГРУЗКА КОНФИГОВ
-- ═══════════════════════════════════════════════════════════
local config_modules = {
  "utils",
  "ui",
  "lsp",
  "treesitter",
  "autopairs_autotag",
  "conform",
  "diagnostics",
  "ai_simple",
}

for _, module in ipairs(config_modules) do
  local ok, err = pcall(require, "config." .. module)
  if not ok then
    vim.notify("Failed to load config." .. module .. ": " .. err, vim.log.levels.WARN)
  end
end

-- ═══════════════════════════════════════════════════════════
-- 6. ФУНКЦИИ (из functions.vim)
-- ═══════════════════════════════════════════════════════════
local function nr_bufs()
  local count = 0
  for i = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(i) == 1 then
      count = count + 1
    end
  end
  return count
end

function _G.DeployCurrentBuffer()
  vim.cmd("update")
  local filename = vim.fn.expand("%:t")
  local filepath = vim.fn.expand("%:p:h")
  vim.cmd("!/home/za/usr/bin/deploy-vim.sh " .. filename .. " " .. filepath)
  vim.cmd("edit")
  local buffer_count = nr_bufs()
  print(buffer_count)
  if buffer_count == 1 then
    vim.cmd("quit")
  else
    vim.cmd("bd")
  end
end

function _G.MergeCurrentBuffer()
  vim.cmd("update")
  local filename = vim.fn.expand("%:t")
  local filepath = vim.fn.expand("%:p:h")
  vim.cmd("AsyncRun copy2dev.sh " .. filename .. " " .. filepath)
  vim.notify("Merged: " .. filename, vim.log.levels.INFO)
end

function _G.MergeAllBuffers()
  local current_buf = vim.fn.bufnr("%")
  vim.cmd("bufdo !copy2dev.sh %:t %:p:h")
  vim.cmd("buffer " .. current_buf)
end

function _G.TrimWhitespace()
  local save = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.winrestview(save)
end

function _G.TabToSpace()
  local save = vim.fn.winsaveview()
  vim.cmd([[%s/\t/  /g]])
  vim.fn.winrestview(save)
end

-- ═══════════════════════════════════════════════════════════
-- 7. KEYMAPS
-- ═══════════════════════════════════════════════════════════
local map = vim.keymap.set

-- Очистка поиска
map("n", "<leader><leader>", ":noh<CR>", { silent = true })

-- Сплит строки (важно!)
map("n", "S", "i<cr><esc>^mwgk:silent! s/\\v +$//<cr>:noh<cr>`w", { silent = true })
map("n", "Q", "a<cr><esc>^mwgk:silent! s/\\v +$//<cr>:noh<cr>`w", { silent = true })

-- Чёрная дыра
map("n", "s", '"_d')
map("n", "ss", '"_dd')
map("n", "x", '"_x')
map("n", "X", '"_X')

-- Выделение вставленного
map("n", "<leader>p", "`[v`]")

-- Поиск выделенного
map("v", "//", 'y/<C-r>"<CR>')

-- Отключаем стандартное поведение Ctrl+Z (suspend)
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<Esc>u", { desc = "Undo" })
vim.keymap.set("v", "<C-z>", "<Esc>u", { desc = "Undo" })

-- Timestamp
map("n", "<F8>", function()
  local timestamp = os.date("%d/%m/%y %H:%M:%S")
  vim.api.nvim_put({ "", timestamp, "", "" }, "l", true, true)
  vim.cmd("write")
end)

-- Функции
map("n", "<leader>t", _G.TrimWhitespace)
map("n", ";d", _G.DeployCurrentBuffer)
map("n", ";l", _G.MergeCurrentBuffer)
map("n", ";a", _G.MergeAllBuffers)

-- Wildmenu стрелками
map("c", "<Down>", function()
  return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
end, { expr = true })
map("c", "<Up>", function()
  return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
end, { expr = true })

-- Shift+Insert
map("c", "<S-Insert>", "<C-r>+")

-- ═══════════════════════════════════════════════════════════
-- 8. АВТОКОМАНДЫ
-- ═══════════════════════════════════════════════════════════
-- Persistence (mkview/loadview)
vim.opt.viewoptions = { "cursor", "folds" }

vim.api.nvim_create_autocmd("BufWinLeave", {
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    pcall(vim.cmd, "silent! mkview")
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    if not pcall(vim.cmd, "silent loadview") then
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local lnum, col = mark[1], mark[2]
      local last = vim.api.nvim_buf_line_count(args.buf)
      if lnum > 0 and lnum <= last then
        pcall(vim.api.nvim_win_set_cursor, 0, { lnum, col })
      end
    end
  end,
})

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


-- Treesitter Context цвета
local function setup_context_colors()
  vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#002b36", fg = "#839496" })
  vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#002b36", fg = "#586e75" })
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { sp = "#93a1a1", underline = true })
end
setup_context_colors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_context_colors })
