-- lua/config/plugins.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- базовые
  { "tpope/vim-surround" },
  { "skywind3000/asyncrun.vim" },
  { "vim-scripts/xml.vim", lazy = false },

-- навигация по парным элементам (if/else, скобки, теги)
  { "andymass/vim-matchup" },

  -- автозакрытие скобок/кавычек
  { "echasnovski/mini.pairs", version = false, config = function()
    require('mini.pairs').setup()
  end },

  -- автозакрытие HTML/XML тегов (стабильнее ts-autotag для старых шаблонов)
  { "alvan/vim-closetag" },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context" },

  -- темы
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "sainnhe/everforest", lazy = true, priority = 1000 },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.cmd("colorscheme gruvbox-material")
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#ff0000", bold = true })
    end,
  },
  { "tanvirtin/monokai.nvim", lazy = true, priority = 1000 },

  -- aerial
  {
    "stevearc/aerial.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("aerial").setup({})
      require("telescope").load_extension("aerial")
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end,
  },

  -- UI
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- diagnostics
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

  -- форматирование
  { "stevearc/conform.nvim", event = "VeryLazy" },

  -- LSP
  { "williamboman/mason.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim", "nvim-lspconfig" } },

  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip").config.setup({
        enable_autosnippets = true,
        store_selection_keys = "<C-\\>",
      })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" }
      })
    end
  },
  -- Comment
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      block_comment_enabled = true,
      comment_empty = false,
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          --mode = "buffers", -- "buffers" | "tabs"
          --numbers = "ordinal", -- или "ordinal" | "buffer_id" | "none"
          --diagnostics = "nvim_lsp",
          -- Показывает иконки, если есть nvim-web-devicons
          separator_style = "slant", -- или "thick" / "thin"
          always_show_bufferline = true,
          show_buffer_close_icons = false,
          persist_buffer_sort = true,
          show_buffer_icons = true,
          mode = "buffers",
        }
      })
    end
  },

  { import = "plugins" },
},
{
  lockfile = "/home/za/.config/nvim/lazy-lock.json",
})
