-- Java LSP (Eclipse JDT LS)
-- Экспериментальное подключение для JSP

local jdtls = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    local filename = vim.api.nvim_buf_get_name(args.buf)

    -- Пока тестируем только JSP
    if not filename:match("%.jsp$") then
      return
    end

    vim.lsp.start({
      name = "jdtls",
      cmd = { jdtls },
      root_dir = vim.fn.getcwd(),
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      on_attach = function(client)
        -- Не позволяем LSP форматировать JSP
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    }, {
      bufnr = args.buf,
    })
  end,
})
