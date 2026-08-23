-- Интеграция с Kimi Code CLI (kimi -p)
-- Бинарник: ~/.kimi-code/bin/kimi

local M = {}

local KIMI_BIN = vim.fn.expand("~/.kimi-code/bin/kimi")

-- Запуск kimi -p асинхронно
local function run_kimi(prompt, callback)
  local stdout = {}
  local stderr = {}

  local job_id = vim.fn.jobstart({ KIMI_BIN, "-p", prompt }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(stdout, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.list_extend(stderr, data)
      end
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code ~= 0 then
          callback(nil, table.concat(stderr, "\n"))
          return
        end

        local output = table.concat(stdout, "\n")
        -- Обрезаем служебную строку о возобновлении сессии
        output = output:gsub("\nTo resume this session:.*$", "")
        output = output:gsub("^%s*", ""):gsub("%s*$", "")
        callback(output, nil)
      end)
    end,
  })

  if job_id <= 0 then
    callback(nil, "Не удалось запустить kimi")
  end
end

-- Создаёт/переключается в правый буфер для результата
local function open_result_buffer(title)
  vim.cmd("botright vnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_name(buf, title)
  return buf
end

-- Возвращает выделение (visual) или весь буфер
local function get_context()
  local mode = vim.fn.mode()
  local is_visual = mode == "v" or mode == "V" or mode == "\22" -- Ctrl-V

  if is_visual then
    -- Копируем выделение в регистр v — самый надёжный способ
    vim.cmd([[normal! "vy]])
    local selection = vim.fn.getreg("v")
    vim.fn.setreg("v", "")
    return selection, "selection"
  end

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return table.concat(lines, "\n"), "buffer"
end

-- Общая функция: отправить промпт и показать результат
local function ask_kimi(prompt_template, title)
  local content, source = get_context()
  local ft = vim.bo.filetype
  local filename = vim.fn.expand("%:t")

  local prompt = string.format(
    "Отвечай кратко и по делу, без внутренних рассуждений.\n\n" .. prompt_template,
    ft, filename, ft, content
  )

  local buf = open_result_buffer(title .. ": " .. filename)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "# " .. title,
    "",
    "*Думает...*",
    "",
  })

  run_kimi(prompt, function(result, err)
    if err then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "# " .. title,
        "",
        "**Ошибка:**",
        "",
        err,
      })
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
    end
  end)
end

-- Публичные команды
function M.analyze()
  ask_kimi(
    "Проанализируй этот %s файл (%s). Объясни, что делает код, укажи потенциальные проблемы и подводные камни.\n\n```%s\n%s\n```",
    "Kimi Analyze"
  )
end

function M.explain()
  ask_kimi(
    "Объясни этот %s код (%s) простыми словами. Что делает и зачем нужен каждый блок?\n\n```%s\n%s\n```",
    "Kimi Explain"
  )
end

function M.refactor()
  ask_kimi(
    "Отрефактори этот %s код (%s). Упрости, убери дублирование, улучши читаемость, сохрани функциональность. Верни только результат в виде кода без лишних пояснений.\n\n```%s\n%s\n```",
    "Kimi Refactor"
  )
end

function M.fix()
  ask_kimi(
    "Найди и исправь баги в этом %s файле (%s). Объясни, что было не так, и верни исправленный код.\n\n```%s\n%s\n```",
    "Kimi Fix"
  )
end

-- Произвольный запрос с подставленным контекстом
function M.prompt(input)
  local content = get_context()
  local ft = vim.bo.filetype
  local filename = vim.fn.expand("%:t")
  local prompt = string.format(
    "Отвечай кратко и по делу, без внутренних рассуждений.\n\n%s\n\nКонтекст — файл %s (%s):\n\n```%s\n%s\n```",
    input, filename, ft, ft, content
  )

  local buf = open_result_buffer("Kimi: " .. filename)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "# Kimi",
    "",
    "*Думает...*",
    "",
  })

  run_kimi(prompt, function(result, err)
    if err then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "# Kimi",
        "",
        "**Ошибка:**",
        "",
        err,
      })
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
    end
  end)
end

-- Команды
vim.api.nvim_create_user_command("KimiAnalyze", M.analyze, { range = true, desc = "Kimi: analyze file/selection" })
vim.api.nvim_create_user_command("KimiExplain", M.explain, { range = true, desc = "Kimi: explain file/selection" })
vim.api.nvim_create_user_command("KimiRefactor", M.refactor, { range = true, desc = "Kimi: refactor file/selection" })
vim.api.nvim_create_user_command("KimiFix", M.fix, { range = true, desc = "Kimi: fix bugs" })
vim.api.nvim_create_user_command("KimiPrompt", function(opts)
  M.prompt(opts.args)
end, { nargs = "+", range = true, desc = "Kimi: arbitrary prompt" })

-- Keymaps
vim.keymap.set({ "n", "v" }, "<leader>ka", M.analyze, { desc = "Kimi: Analyze" })
vim.keymap.set({ "n", "v" }, "<leader>ke", M.explain, { desc = "Kimi: Explain" })
vim.keymap.set({ "n", "v" }, "<leader>kr", M.refactor, { desc = "Kimi: Refactor" })
vim.keymap.set({ "n", "v" }, "<leader>kf", M.fix, { desc = "Kimi: Fix" })
vim.keymap.set({ "n", "v" }, "<leader>kp", function()
  vim.ui.input({ prompt = "Kimi: " }, function(input)
    if input and #input > 0 then
      M.prompt(input)
    end
  end)
end, { desc = "Kimi: Prompt" })

return M
