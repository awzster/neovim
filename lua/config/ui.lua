-- lua/config/ui.lua
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
       max_length = 140,
       show_buffer_close_icons = false,
       show_filename_only = true,
       show_modified_status = true, -- Shows indicator when the buffer is modified.

     -- fmt = function(name, bufnr)
     --   if name == "" then name = "[No Name]" end
     --   local filename = vim.fn.fnamemodify(name, ":t")
     --   return string.format("[%d %s]", bufnr, filename)
     -- end,
     }
   },
    lualine_z = { 'tabs' },
  },
  extensions = { 'quickfix', 'nvim-tree', 'aerial' }
})

-- nvim-tree
--require("nvim-tree").setup()
require("nvim-tree").setup({
  sort_by = "modification_time", -- сортировка по времени изменения
  -- другие опции...
})
vim.keymap.set("n", "<F12>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    -- Делает поиск нечувствительным к регистру
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",

    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    path_display = { "truncate" },
  },
})

require("telescope").load_extension("aerial")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help" })
vim.keymap.set("n", "<leader>o", function() builtin.lsp_document_symbols() 
end, { desc = "Document Symbols" })
vim.keymap.set('n', '<leader>fs', function()
  require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })
end, { desc = 'Grep word under cursor' })

vim.keymap.set("n", "<leader>sa", function()
    require("telescope").extensions.aerial.aerial()
end, { desc = "Search Symbols (Aerial)" })

-- Переключение на N-й буфер в списке (1–9) по <Leader> + цифра
for i = 1, 9 do
  vim.keymap.set("n", "<Leader>" .. i, function()
    -- Получаем список всех отображаемых буферов (listed = true)
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if bufs[i] then
      vim.cmd("buffer " .. bufs[i].bufnr)
    end
  end, { desc = "Switch to buffer #" .. i })
end

vim.keymap.set("i", "<C-\\>", function()
  require("luasnip").expand()
end, { silent = true })

vim.keymap.set({"i", "s"}, "<Tab>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").expand_or_jump()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { silent = true })

--[[ vim.keymap.set("i", "<C-l>", function()
  if require("luasnip").choice_active() then
    require("luasnip").change_choice(1)
  end
end, { silent = true }) ]]

vim.keymap.set("s", "<C-\\>", function()
  require("luasnip").expand()
end, { silent = true })

