local M = {}

M.current_ai_model = "qwen2.5:7b" -- Дефолтное значение

-- 🚀 Оптимизация nvm PATH
-- Ищем последнюю версию Node.js один раз при загрузке
local home = os.getenv("HOME")
if home then
    -- Используем более быстрый поиск без полной загрузки bash профиля (-lc) если возможно
    local cmd = 'ls -d ' .. home .. '/.nvm/versions/node/*/bin 2>/dev/null | sort -V | tail -n1'
    local handle = io.popen(cmd)
    if handle then
        local nvm_bin = handle:read("*l")
        handle:close()
        if nvm_bin and #nvm_bin > 0 then
            vim.env.PATH = nvm_bin .. ":" .. (vim.env.PATH or "")
        end
    end
end

-- 📝 Утилита: Имя файла с номером буфера (для Lualine)
M.filename_with_bufnr = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(bufnr)
    local filename = vim.fn.fnamemodify(name, ":t")
    if filename == "" then filename = "[No Name]" end
    
    -- Исправил твой формат: %d для номера, %s для имени
    return string.format("[%d] %s", bufnr, filename)
end

-- 🔢 Утилита: Код символа (Unicode) под курсором
M.char_code = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1], cursor[2]
    
    -- Получаем строку и символ аккуратным способом
    local line = vim.api.nvim_get_current_line()
    local char = line:sub(col + 1, col + 1)

    if char == "" or char == " " then return "" end

    local cp = vim.fn.char2nr(char)
    if cp and cp > 0 then
        return string.format("U+%04X", cp)
    end
    return ""
end

-- 🤖 AI: Смена модели Ollama для Minuet
M.change_minuet_model = function(model_name)
    local ok, minuet = pcall(require, 'minuet')
    if not ok then
        vim.notify("Minuet plugin not found", vim.log.levels.ERROR)
        return
    end

    M.current_ai_model = model_name -- Запоминаем выбор

    minuet.setup({
        -- Используем правильное имя провайдера
        provider = 'openai_compatible', 
        provider_options = {
            openai_compatible = {
                model = model_name,
                end_point = 'http://127.0.0.1:11434/v1/chat/completions',
                name = 'Ollama',
                stream = true,
                optional = {
                    max_tokens = 256,
                    top_p = 0.9,
                    temperature = 0.2,
                },
            }
        }
    })
    
    vim.notify("AI Model (Ollama): " .. model_name, vim.log.levels.INFO, { title = "Minuet" })
end

-- Функция для Lualine
M.get_ai_status = function()
    return "🤖 " .. M.current_ai_model
end

return M
