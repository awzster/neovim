local lspconfig = require('lspconfig')
local cmp_caps = require('blink.cmp').get_lsp_capabilities()

-- Отключаем ворнинги о депрекации для Neovim 0.11
vim.g.lspconfig_suppress_deprecation = true

-- Функция для включения форматирования при сохранении
local function enable_format_on_save(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      if client.name == "eslint" then
        vim.cmd("EslintFixAll")
      else
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end
    end,
    desc = "LSP: Format on save",
  })
end

local function on_attach(client, bufnr)
  -- Отключаем встроенное форматирование у ts_ls, чтобы не мешал ESLint
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "K",  vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
end

-- Настройка Mason
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "eslint", "html", "cssls", "ts_ls" },
  handlers = {
    -- Дефолтный обработчик
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = cmp_caps,
        on_attach = on_attach,
      })
    end,

    -- Настройка ESLint (JS): Исправляет и форматирует при сохранении
    ["eslint"] = function()
      lspconfig.eslint.setup({
        capabilities = cmp_caps,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          enable_format_on_save(client, bufnr)
        end,
      })
    end,

    -- Настройка CSS: Форматирует при сохранении
    ["cssls"] = function()
      lspconfig.cssls.setup({
        capabilities = cmp_caps,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          enable_format_on_save(client, bufnr)
        end,
        settings = {
          css = { validate = true },
          less = { validate = true },
          scss = { validate = true },
        },
      })
    end,

    -- Настройка HTML: БЕЗ форматирования при сохранении
    ["html"] = function()
      lspconfig.html.setup({
        capabilities = cmp_caps,
        on_attach = on_attach, -- Только биндинги клавиш, без enable_format_on_save
        settings = {
          html = { 
            format = { enable = false }, -- На всякий случай отключаем и в настройках сервера
            validate = { scripts = true, styles = true } 
          }
        }
      })
    end,

    -- Полностью глушим stylelint_lsp
    ["stylelint_lsp"] = function() end,
  },
})
