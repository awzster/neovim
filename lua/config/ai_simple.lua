-- Простой AI интеграция без плагина

local OLLAMA_URL = "http://localhost:11434/api/generate"
local MODEL = "qwen2.5-coder:14b"

local function send_buffer(prompt_template)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content = table.concat(lines, "\n")
  local ft = vim.bo[buf].filetype
  local filename = vim.api.nvim_buf_get_name(buf)
  local line_count = #lines
  
  if line_count > 2000 then
    vim.notify("Файл большой: " .. line_count .. " строк", vim.log.levels.WARN)
  end
  
  local prompt = string.format(
    prompt_template or "Проанализируй этот %s файл (%s):\n\n```%s\n%s\n```",
    ft, filename, ft, content
  )
  
  vim.cmd("botright vnew")
  local out_buf = vim.api.nvim_get_current_buf()
  vim.bo[out_buf].buftype = "nofile"
  vim.bo[out_buf].filetype = "markdown"
  vim.api.nvim_buf_set_name(out_buf, "AI: " .. filename)
  
  vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, {
    "# " .. MODEL,
    "",
    "*Загрузка...*",
    "",
  })
  
  local body = vim.json.encode({
    model = MODEL,
    prompt = prompt,
    stream = false,
    options = { num_ctx = 32768, temperature = 0.2 },
  })
  
  vim.fn.jobstart({"curl", "-s", "-X", "POST", OLLAMA_URL, 
    "-H", "Content-Type: application/json",
    "-d", body}, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then return end
      local response = table.concat(data, "\n")
      local ok, decoded = pcall(vim.json.decode, response)
      vim.schedule(function()
        if ok and decoded and decoded.response then
          vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, vim.split(decoded.response, "\n"))
        else
          vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, {"Ошибка", response})
        end
      end)
    end,
  })
end

-- Команды
vim.api.nvim_create_user_command("AIAnalyze", function()
  send_buffer()
end, {})

vim.api.nvim_create_user_command("AIRefactor", function()
  send_buffer("Отрефактори этот %s файл. Сохрани функциональность:\n\n```%s\n%s\n```")
end, {})

-- Keymaps
vim.keymap.set("n", "<leader>az", ":AIAnalyze<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ar", ":AIRefactor<CR>", {noremap = true, silent = true})
