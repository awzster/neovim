-- ~/.config/nvim/lua/diagnostics.lua

-- Иконки и цвета
local severity_icons = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN]  = "",
  [vim.diagnostic.severity.INFO]  = "",
  [vim.diagnostic.severity.HINT]  = ""
}

-- Цвета из gruvbox-material (medium dark)
-- Подходит для большинства случаев; измените, если используете soft/hard
local colors = {
  lightRed    = "#ff9966",
  red    = "#ea6962",
  yellow = "#d8a657",
  blue   = "#7daea3",
  green  = "#a9b665",
}

local function set_diagnostic_highlights()
  -- Текст ошибок
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red,    bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = colors.yellow, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = colors.blue })
  vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = colors.green })

  -- 🔥 ЗАМЕНА: используем underline + fg вместо undercurl + sp
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, fg = colors.lightRed })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { underline = true, fg = colors.yellow })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { underline = true, fg = colors.blue })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { underline = true, fg = colors.green })

  -- Знаки в signcolumn
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = colors.red,    bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn",  { fg = colors.yellow, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo",  { fg = colors.blue })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint",  { fg = colors.green })
end

-- Применяем после загрузки темы (и сразу)
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diagnostic_highlights })
set_diagnostic_highlights()

-- Регистрация знаков с иконками
for severity, icon in pairs(severity_icons) do
  vim.fn.sign_define("DiagnosticSign" .. vim.diagnostic.severity[severity]:gsub("^%l", string.upper), {
    text = icon,
    texthl = "DiagnosticSign" .. vim.diagnostic.severity[severity]:gsub("^%l", string.upper),
    linehl = "",
    numhl = "",
  })
end

-- Основная конфигурация диагностики (БЕЗ virtual_text!)
vim.diagnostic.config({
  virtual_text = false,        -- ✅ отключено
  signs = true,                -- ✅ знаки включены
  underline = true,            -- ✅ подчёркивание включено
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- === УПРАВЛЕНИЕ LSP_LINES ===
-- Загружаем lsp_lines, но НЕ включаем сразу
require("lsp_lines").setup()

-- Флаг: изначально ВЫКЛЮЧЕН
_G.lsp_lines_enabled = false

-- Функция переключения
local function toggle_lsp_lines()
  _G.lsp_lines_enabled = not _G.lsp_lines_enabled
  require("lsp_lines").toggle()
  vim.notify("lsp_lines: " .. (_G.lsp_lines_enabled and "ON" or "OFF"), _G.lsp_lines_enabled and vim.log.levels.INFO or vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>dl", toggle_lsp_lines, { desc = "Toggle lsp_lines" })

-- === POPUP ПО НАВЕДЕНИЮ ===
-- Показываем диагностическое окно при удержании курсора
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("DiagnosticsPopup", { clear = true }),
  callback = function()
    local opts = {
      focus = false,
      scope = "cursor",
      close_events = { "CursorMoved", "InsertEnter", "BufHidden" },
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

vim.o.updatetime = 300  -- 300 мс → popup появляется быстро
