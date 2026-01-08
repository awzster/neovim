--/config/plugins.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/lazy.nvim", version = false },

  -- базовые
  --  { "drmingdrmer/xptemplate" },
  { "tpope/vim-surround" },
  { "andymass/vim-matchup" },
  { "osyo-manga/vim-anzu" },
  { "skywind3000/asyncrun.vim" },
  { "kshenoy/vim-signature" },
  { 'othree/xml.vim' },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- пары и теги
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter/nvim-treesitter" },

  -- темы
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "sainnhe/everforest", lazy = true, priority = 1000 },
  { "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      --vim.g.gruvbox_material_background = "medium" -- или "hard", "soft"
      vim.g.gruvbox_material_background = 'medium' -- Максимальный контраст
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd("colorscheme gruvbox-material")
      vim.g.gruvbox_material_enable_bold = 1

      -- Сразу задаём PmenuSel
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#ff0000", bold = true })
    end,
  },
  { "tanvirtin/monokai.nvim", lazy = true, priority = 1000 },

  {
    "stevearc/aerial.nvim",
    lazy = false,            -- Снять ленивую загрузку
    priority = 1000,         -- Высокий приоритет загрузки
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      -- Убедитесь, что Telescope указан как зависимость (если нет в другом месте)
      "nvim-telescope/telescope.nvim" 
    },
    config = function()
      require("aerial").setup({
        -- ... ваши настройки ...
      })

      -- Это нужно, даже если вы добавили в ui.lua, для гарантии
      require("telescope").load_extension("aerial") 

      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end
  },

  -- UI
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" } },

  -- diagnostics
  --{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
  { "lsp_lines.nvim" },

  -- форматирование
  { "stevearc/conform.nvim", event = "VeryLazy" },

  -- LSP
  { "williamboman/mason.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim", "nvim-lspconfig" } },

  {
    "L3MON4D3/LuaSnip",
    -- Убираем зависимость от friendly-snippets
    config = function()
      require("luasnip").config.setup({
        enable_autosnippets = true,
        -- Опционально: сохранять выделение при раскрытии
        store_selection_keys = "<C-\\>", -- или ваша клавиша
      })

      -- Загружаем только сниппеты из ~/.config/nvim/snippets
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" }
      })
    end
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",           -- уже объявлен выше, но можно повторить
      "saadparwaiz1/cmp_luasnip",   -- источник для сниппетов
      "hrsh7th/cmp-nvim-lsp",       -- LSP-дополнение
      "hrsh7th/cmp-path",           -- пути
      "hrsh7th/cmp-buffer",         -- слова из буфера
      "hrsh7th/cmp-cmdline",        -- для командной строки (опционально)
    },
    config = function()
      require("config.cmp")
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      --- Включаем поддержку блочных комментариев
      --- и настраиваем поведение по умолчанию
      toggler = {
        line = "gcc",      -- построчный комментарий
        block = "gbc",     -- блочный комментарий
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      --- Главное: включаем автоопределение — блок для выделения >1 строки
      block_comment_enabled = true,
      --- Опционально: всегда использовать блок при визуальном выделении
      --- (это то, что тебе нужно!)
      comment_empty = false,
    },  config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies =
      {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    config = function()
      require("config.codecompanion")
    end,
  },
})

