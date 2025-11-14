-- lua/config/autopairs_autotag.lua

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

-- Уведомление о загрузке (до setup)
print("🔍 autopairs.lua загружен!")

npairs.setup({
  check_ts = true,
  ts_config = {
    -- Только комментарии блокируют автопары, строки — нет
    javascript = { "comment" },
    typescript = { "comment" },
    tsx = { "comment" },
    lua = { "comment" },
    python = { "comment" },
    ruby = { "comment" },
    go = { "comment" },
    rust = { "comment" },
  },
  disable_in_macro = true,
  disable_filetype = { "text", "markdown", "help" },
})

-- autotag через прямой setup (новый API)
require("nvim-ts-autotag").setup({
  filetypes = {
    "html", "xml", "xsl",
    "javascriptreact", "typescriptreact", "jsx", "tsx",
    "vue", "svelte", "rescript",
    "heex", "eex", "erb", "astro", "glimmer", "handlebars", "hbs",
  },
})


-- Удаляем стандартное правило для '
npairs.remove_rule("'")

-- Добавляем новое — без проверок
npairs.add_rule(Rule("'", "'"))

npairs.remove_rule('"')
npairs.add_rule(Rule('"', '"'))
