-- ~/.config/nvim/lua/diagnostics.lua

-- Загружаем и настраиваем lsp_lines
require("lsp_lines").setup()

-- Иконки для диагностики
local severity_icons = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN]  = "",
  [vim.diagnostic.severity.INFO]  = "",
  [vim.diagnostic.severity.HINT]  = ""
}

-- Единая конфигурация диагностики
-- ВАЖНО: virtual_text = false — обязательно для работы lsp_lines
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = severity_icons[vim.diagnostic.severity.ERROR],
      [vim.diagnostic.severity.WARN]  = severity_icons[vim.diagnostic.severity.WARN],
      [vim.diagnostic.severity.INFO]  = severity_icons[vim.diagnostic.severity.INFO],
      [vim.diagnostic.severity.HINT]  = severity_icons[vim.diagnostic.severity.HINT],
    },
  },
})

-- Глобальное состояние для переключения между lsp_lines и virtual_text
local lsp_lines_enabled = true

local function toggle_lsp_lines()
  lsp_lines_enabled = not lsp_lines_enabled

  if lsp_lines_enabled then
    -- Включаем lsp_lines → отключаем virtual_text
    vim.diagnostic.config({ virtual_text = false })
    require("lsp_lines").toggle()
  else
    -- Включаем virtual_text → отключаем lsp_lines
    vim.diagnostic.config({
      virtual_text = {
        prefix = function(diagnostic)
          return severity_icons[diagnostic.severity] or "●"
        end,
      },
    })
    require("lsp_lines").toggle()
  end

  vim.notify("Diagnostics: " .. (lsp_lines_enabled and "lines" or "virtual_text"))
end

-- Клавиша для переключения режимов
vim.keymap.set("n", "<leader>dl", toggle_lsp_lines, { desc = "Toggle diagnostics lines/text" })

-- Глобальный тумблер показа/скрытия всех диагностик
local diagnostics_visible = true
vim.keymap.set("n", "<leader>df", function()
  diagnostics_visible = not diagnostics_visible
  if diagnostics_visible then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
  vim.notify("Diagnostics: " .. (diagnostics_visible and "shown" or "hidden"))
end, { desc = "Toggle diagnostics visibility" })

require("lsp_lines").toggle()  -- ← включить lsp_lines сразу
