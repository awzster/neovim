local adapters = require("codecompanion.adapters")

require("codecompanion").setup({
  -- Адаптеры
  adapters = {
    ollama = function()
      return adapters.extend("ollama", {
        schema = {
          model = {
            default = "qwen2.5-coder:14b", -- было 7b
            --default = "qwen2.5-coder:7b", -- поменяешь на 14b когда скачается
          },
          num_ctx = {
            default = 32768,
          },
          temperature = {
            default = 0.2,
          },
          top_p = {
            default = 0.95,
          },
        },
      })
    end,
  },

  -- Стратегии использования
  strategies = {
    -- Чат
    chat = {
      adapter = "ollama",
      roles = {
        llm = "CodeCompanion",
        user = "Me",
      },
      
      -- НОВОЕ: включаем контексты
      contexts = {
        "buffer",
        "file",
        "git",
        "lsp",
        "codebase",
      },
      
      opts = {
        system_prompt = function(opts)
          local rules_file = vim.fn.expand("~/.config/nvim/AI_RULES.md")
          local f = io.open(rules_file, "r")
          if f then
            local content = f:read("*all")
            f:close()
            return "Ты — опытный разработчик. Помогай писать и рефакторить код, СТРОГО соблюдая правила:\n\n" .. content
          end
          return "Ты — опытный разработчик. Помогай с кодом чётко и по делу."
        end,
      },
    },

    -- Инлайн-редактирование
    inline = {
      adapter = "ollama",
      keymaps = {
        accept_change = { modes = { n = "ga", v = "ga" } },
        reject_change = { modes = { n = "gr", v = "gr" } },
      },
    },

    -- Агент
    agent = {
      adapter = "ollama",
    },
  },

  -- Глобальные опции
  opts = {
    log_level = "ERROR",
    language = "ru",
    
    save_chats = {
      enabled = true,
      save_dir = vim.fn.expand("~/.config/nvim/codecompanion-chats"),
    },
    
    -- НОВОЕ: настройки контекста
    context_providers = {
      buffer = {
        opts = {
          max_lines = 2000,
        },
      },
      file = {
        opts = {
          max_lines = 2000,
        },
      },
    },
  },

  -- Быстрые действия
  prompt_library = {
    ["Explain"] = {
      strategy = "chat",
      description = "Объясни код",
      opts = {
        mapping = "<leader>ae",
        auto_submit = true,
      },
      prompts = {
        {
          role = "user",
          content = "Объясни этот код простыми словами. Что делает, какие подводные камни?\n\n```{{language}}\n{{input}}\n```",
        },
      },
    },
    ["Refactor"] = {
      strategy = "inline",
      description = "Отрефактори код",
      opts = {
        mapping = "<leader>ar",
        auto_submit = true,
      },
      prompts = {
        {
          role = "user",
          content = "Отрефактори этот код: упрости, убери дублирование, добавь обработку ошибок. Сохрани функциональность.\n\n```{{language}}\n{{input}}\n```",
        },
      },
    },
    ["Fix"] = {
      strategy = "chat",
      description = "Исправь баги",
      opts = {
        mapping = "<leader>af",
        auto_submit = true,
      },
      prompts = {
        {
          role = "user",
          content = "Найди и исправь баги в этом коде. Объясни, что было не так.\n\n```{{language}}\n{{input}}\n```",
        },
      },
    },
  },
})
