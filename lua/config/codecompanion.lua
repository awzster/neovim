local adapters = require("codecompanion.adapters")

require("codecompanion").setup(
{
  adapters =
  {
    http =
    {
      qwen = function()
        return adapters.extend("openai_compatible",
        {
          name = "qwen",
          env =
          {
            url = vim.env.OPENAI_BASE_URL,
            api_key = "OPENAI_API_KEY",
            chat_url = "/v1/chat/completions",
            -- при необходимости можно добавить:
            -- models_endpoint = "/v1/models",
          },
          schema =
          {
            model =
            {
              default = vim.env.OPENAI_MODEL,
            },
          },
        })
      end,
    },
  },

  interactions =
  {
    chat =
    {
      adapter = "qwen",
    },
    inline =
    {
      adapter = "qwen",
    },
    -- cmd = { adapter = "qwen" }, -- опционально
  },

  opts =
  {
    log_level = "INFO",
  },
})

