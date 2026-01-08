-- lua/config/conform.lua
local conform = require("conform")

-- Флаг для отслеживания состояния форматирования при сохранении
local format_on_save_enabled = true

-- Функция для переключения состояния
local function toggle_format_on_save()
  format_on_save_enabled = not format_on_save_enabled
  local status = format_on_save_enabled and "включено" or "отключено"
  vim.notify("Форматирование при сохранении: " .. status, vim.log.levels.INFO)
end

-- Переопределяем поведение conform при сохранении
conform.setup({
  formatters_by_ft = {
    javascript       = { "eslint_d" },
    javascriptreact  = { "eslint_d" },
    typescript       = { "eslint_d" },
    typescriptreact  = { "eslint_d" },
    json             = { "prettier" },
    css              = { "prettier" },
  },
  formatters = {
    xmllint = {
      command = "xmllint",
      args = { "--format", "--recover", "-" },
      stdin = true,
    },
  },
  format_on_save = function(bufnr)
    -- Возвращаем настройки только если включено
    if format_on_save_enabled then
      return {
        timeout_ms = 2000,
        lsp_fallback = false,
      }
    else
      return nil -- отключает форматирование при сохранении
    end
  end,
})

-- Создаем пользовательскую команду
vim.api.nvim_create_user_command("FormatOnSaveToggle", toggle_format_on_save, {})

-- === ВАЖНО: создаём команду :Format ===
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.line1 ~= args.line2 then
    range = { args.line1, args.line2 }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, {
  desc = "Format current buffer or range",
  range = true,
})

conform.formatters.eslint_d = {
  prepend_args = { "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
  cwd = function(_) return vim.env.HOME end,
}

