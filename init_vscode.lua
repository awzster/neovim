-- VSCode Neovim: minimal vim-core
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

local is_vscode = vim.g.vscode ~= nil

-- Base options (vim-like)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250

-- Helper to call VS Code commands
local function vsc(cmd)
  return function()
    vim.fn.VSCodeNotify(cmd)
  end
end

-- Core leader mappings (adjust later)
vim.keymap.set("n", "<leader>f", vsc("workbench.action.quickOpen"), { silent = true })
vim.keymap.set("n", "<leader>g", vsc("workbench.action.findInFiles"), { silent = true })
vim.keymap.set("n", "<leader>r", vsc("editor.action.rename"), { silent = true })
vim.keymap.set("n", "<leader>a", vsc("editor.action.quickFix"), { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>=", vsc("editor.action.formatDocument"), { silent = true })
vim.keymap.set("v", "<leader>=", vsc("editor.action.formatSelection"), { silent = true })

-- Minimal plugin set for VSCode Neovim (avoid loading full nvim config)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if vim.loop.fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup({
    { "tpope/vim-surround" },
    { "numToStr/Comment.nvim", opts = {} },
  },
    {
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })
end

-- Delete without yanking (black hole register)
vim.keymap.set("n", "s", '"_d', { noremap = true })
vim.keymap.set("n", "ss", '"_dd', { noremap = true })
-- Single-char delete without yanking
vim.keymap.set("n", "x", '"_x', { noremap = true })

-- Navigation / search
vim.keymap.set("n", "<leader>p", vsc("workbench.action.quickOpen"), { silent = true })         -- files (alias)
vim.keymap.set("n", "<leader>/", vsc("actions.find"), { silent = true })                      -- find in file
vim.keymap.set("n", "<leader>?", vsc("workbench.action.findInFiles"), { silent = true })      -- ripgrep in workspace
vim.keymap.set("n", "<leader>s", vsc("workbench.action.showAllSymbols"), { silent = true })   -- symbols (workspace)
vim.keymap.set("n", "<leader>o", vsc("workbench.action.gotoSymbol"), { silent = true })       -- symbols (file)

-- LSP-like actions
vim.keymap.set("n", "gd", vsc("editor.action.revealDefinition"), { silent = true })
vim.keymap.set("n", "gr", vsc("editor.action.referenceSearch.trigger"), { silent = true })
vim.keymap.set("n", "K",  vsc("editor.action.showHover"), { silent = true })
vim.keymap.set("n", "<leader>rn", vsc("editor.action.rename"), { silent = true })
vim.keymap.set("n", "<leader>ca", vsc("editor.action.quickFix"), { silent = true })

-- Diagnostics
vim.keymap.set("n", "[d", vsc("editor.action.marker.prev"), { silent = true })
vim.keymap.set("n", "]d", vsc("editor.action.marker.next"), { silent = true })
vim.keymap.set("n", "<leader>d", vsc("workbench.actions.view.problems"), { silent = true })   -- Problems panel

-- Buffers / editors
vim.keymap.set("n", "<leader>b", vsc("workbench.action.showAllEditors"), { silent = true })   -- list editors
vim.keymap.set("n", "<leader>q", vsc("workbench.action.closeActiveEditor"), { silent = true })-- close current
vim.keymap.set("n", "<leader>Q", vsc("workbench.action.closeAllEditors"), { silent = true })  -- close all

-- Terminal
vim.keymap.set("n", "<leader>t", vsc("workbench.action.terminal.toggleTerminal"), { silent = true })
vim.keymap.set("n", "S", "i<CR><Esc>", { noremap = true, silent = true })

-- Uses VS Code default *build* task on purpose:
-- runTask(label) opens picker when called from extensions
-- ;l = save + run default build task (merge)
vim.keymap.set("n", ";l", function()
  vim.cmd("update")
  vim.fn.VSCodeNotify("workbench.action.tasks.build")
end, { noremap = true, silent = true })

local vscode = require("vscode")

-- Visual: format selection (like vim's "=" idea, but real formatter)
vim.keymap.set("x", "=", function()
  vscode.call("editor.action.formatSelection")
end, { noremap = true, silent = true })

-- VS Code folding via vscode-neovim
local function vsc(cmd)
  return function()
    vim.fn.VSCodeNotify(cmd)
  end
end

vim.keymap.set('n', 'zc', vsc('editor.fold'), { silent = true })
vim.keymap.set('n', 'zo', vsc('editor.unfold'), { silent = true })
vim.keymap.set('n', 'za', vsc('editor.toggleFold'), { silent = true })

vim.keymap.set('n', 'zM', vsc('editor.foldAll'), { silent = true })
vim.keymap.set('n', 'zR', vsc('editor.unfoldAll'), { silent = true })

vim.keymap.set('n', 'zm', vsc('editor.foldLevel1'), { silent = true })
vim.keymap.set('n', 'zr', vsc('editor.unfoldLevel1'), { silent = true })

local function vsc(cmd)
  return function()
    vim.fn.VSCodeNotify(cmd)
  end
end

local function vsc_range(cmd)
  return function()
    vim.fn.VSCodeNotifyRange(cmd)
  end
end

-- \= : toggle line comment (как правило удобнее в реальной жизни)
-- vim.keymap.set({ 'n', 'v' }, '\\=', vsc_range('editor.action.commentLine'), { silent = true })

-- Если хочешь именно блочный коммент /* ... */:
vim.keymap.set({ 'n', 'v' }, '<leader>=', vsc_range('editor.action.blockComment'), { silent = true })

vim.keymap.set('n', '<leader>c', vsc('editor.action.rename'), { silent = true })

vim.api.nvim_create_user_command('Bdelete', function()
  vim.fn.VSCodeNotify('workbench.action.closeActiveEditor')
end, {})

vim.keymap.set('n', '<leader>1', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex1')
end, { silent = true })
vim.keymap.set('n', '<leader>2', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex2')
end, { silent = true })
vim.keymap.set('n', '<leader>3', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex3')
end, { silent = true })
vim.keymap.set('n', '<leader>4', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex4')
end, { silent = true })
vim.keymap.set('n', '<leader>5', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex5')
end, { silent = true })
vim.keymap.set('n', '<leader>6', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex6')
end, { silent = true })
vim.keymap.set('n', '<leader>7', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex7')
end, { silent = true })
vim.keymap.set('n', '<leader>8', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex8')
end, { silent = true })
vim.keymap.set('n', '<leader>9', function()
  vim.fn.VSCodeNotify('workbench.action.openEditorAtIndex9')
end, { silent = true })

