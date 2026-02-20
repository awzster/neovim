-- lua/config/ui.lua
-- UI: nvim-tree, telescope

-- ═══════════════════════════════════════════════════════════
-- NVIM-TREE
-- ═══════════════════════════════════════════════════════════

require("nvim-tree").setup({
  sort_by = "modification_time",
  renderer = {
    group_empty = true,
  },
})

-- ═══════════════════════════════════════════════════════════
-- TELESCOPE
-- ═══════════════════════════════════════════════════════════
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    path_display = { "truncate" },
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
    },
  },
})

-- Extensions
telescope.load_extension("aerial")

-- Keymaps
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
vim.keymap.set("n", "<leader>fs", function()
  builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fa", function()
  telescope.extensions.aerial.aerial()
end, { desc = "Search symbols (Aerial)" })

-- ═══════════════════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════════════════
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yank" })
vim.keymap.set("n", "<leader>r", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })
vim.keymap.set("n", "<F2>", "bve", { desc = "Select word" })
--nmap <F2> bve

local utils = require("config.utils")
-- lualine
require('lualine').setup({
  options = {
    theme = 'catppuccin',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { utils.filename_with_bufnr },
    --lualine_c = { 'buffers' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location', utils.char_code },
  },
  tabline = {
   lualine_c = {
     {
       'buffers',
       mode = 2,
       max_length = 190,
       show_buffer_close_icons = false,
       show_filename_only = true,
       show_modified_status = true, -- Shows indicator when the buffer is modified.

     }
   },
    lualine_z = { 'tabs' },
  },
  extensions = { 'quickfix', 'nvim-tree', 'aerial' }
})

for i = 1, 9 do
  local index = i
  vim.keymap.set("n", "<Leader>" .. index, function()
    -- Получаем список всех ПЕРЕЧИСЛЕННЫХ буферов (buflisted)
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    
    if bufs[index] then
      -- bufs[index].bufnr — это реальный ID буфера (например, 3)
      vim.api.nvim_set_current_buf(bufs[index].bufnr)
    else
      vim.notify("Buffer " .. index .. " not found in list", vim.log.levels.WARN)
    end
  end, { desc = "Switch to listed buffer #" .. index })
end

vim.keymap.set("n", "<F12>", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Toggle file tree" })
-- Навигация по буферам
vim.keymap.set("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("i", "<S-Left>", "<Esc><cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("i", "<S-Right>", "<Esc><cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("i", "<C-Tab>", "<Esc><cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("i", "<C-\\>", function()
  require("luasnip").expand()
end, { silent = true })

