return {
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      keymap = {
        preset = 'none',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },
        
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then 
              return cmp.snippet_forward() 
            end
            return cmp.accept()
          end,
          'fallback',
        },
        
        ['<S-Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then 
              return cmp.snippet_backward() 
            end
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            end
          end,
          'fallback',
        },
        
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-l>'] = { 'show' },
      },
      
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },
      
      completion = {
        ghost_text = { 
          enabled = true,
          show_with_selection = true,
        },
        
        list = { 
          selection = { 
            preselect = true, 
            auto_insert = false 
          } 
        },
        
        menu = {
          border = 'rounded',
          winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection',
          
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind', gap = 1 },
            },
          },
        },
        
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = 'rounded' },
        },
        
        accept = { auto_brackets = { enabled = true } },
        
        -- ИСПРАВЛЕНО: убраны неизвестные поля
        trigger = {
          show_in_snippet = true,
        },
      },
      
      sources = {
        default = { 'snippets', 'buffer', 'lsp',  'path' },
        
        providers = {
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
            
            opts = {
              get_bufnrs = function()
                local bufs = {}
                local seen = {}
                
                local function add_buf(buf)
                  if not buf or buf == 0 then return end
                  if seen[buf] then return end
                  if not vim.api.nvim_buf_is_valid(buf) then return end
                  if vim.bo[buf].buftype ~= '' then return end
                  
                  seen[buf] = true
                  table.insert(bufs, buf)
                end
                
                for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                    add_buf(vim.api.nvim_win_get_buf(win))
                  end
                end
                
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.fn.buflisted(buf) == 1 then
                    add_buf(buf)
                  end
                end
                
                add_buf(vim.fn.bufnr('#'))
                add_buf(vim.api.nvim_get_current_buf())
                
                -- ОТЛАДКА
                local names = {}
                for _, b in ipairs(bufs) do
                  local n = vim.api.nvim_buf_get_name(b)
                  table.insert(names, n ~= '' and vim.fn.fnamemodify(n, ':t') or '[No Name]')
                end
                vim.notify('Buffer source: ' .. #bufs .. ' буферов: ' .. table.concat(names, ', '), vim.log.levels.DEBUG)
                
                return bufs
              end,
            },
            
            min_keyword_length = 2,
            score_offset = 100,
          },
          
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            score_offset = 60,
          },
          
          snippets = {
            name = 'Snippets',
            module = 'blink.cmp.sources.snippets',
            score_offset = 80,
          },
        },
      },
    },
    
    config = function(_, opts)
      require('blink.cmp').setup(opts)
      vim.notify('Blink.cmp загружен', vim.log.levels.INFO)
    end,
  },
}
