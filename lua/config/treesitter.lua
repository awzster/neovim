-- lua/config/treesitter.lua
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

configs.setup({
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "lua", "markdown", "markdown_inline" },
  
  highlight = { 
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  
  -- ТО ЧТО МЫ ДОБАВИЛИ: Умное выделение по Enter
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",    -- Нажми Enter, чтобы начать выделение
      node_incremental = "<CR>",  -- Нажми еще раз, чтобы расширить (блок -> функция -> класс)
      scope_incremental = false,
      node_decremental = "<BS>",  -- Backspace, чтобы уменьшить область
    },
  },

  matchup = { enable = true },
  
  indent = {
    enable = true,
    disable = { "javascript", "typescript" }, 
  },
})

-- Настройка Context (уже работает)
local context_ok, context = pcall(require, "treesitter-context")
if context_ok then
  context.setup({
    enable = true,
    max_lines = 3,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    zindex = 20,
  })
  
  --vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#2c2c2c" })
-- Настройка цветов для липкой строки (nvim-treesitter-context)
-- Используем цвета, характерные для Solarized
vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#073642', fg = '#93a1a1' }) -- Темно-синий фон Solarized
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#073642', fg = '#586e75' })

-- Дополнительно: можно выделить нижнюю границу, чтобы она не сливалась с кодом
vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { sp = '#839496', underline = true })
end
