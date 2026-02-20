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
      
      -- НОВОЕ: keymap для командной строки
      cmdline = {
        keymap = {
          preset = 'none',
          --['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          -- Стрелки для навигации
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<Up>'] = { 'select_prev', 'fallback' },
          -- Ctrl+J/K как в обычном режиме
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<C-k>'] = { 'select_prev', 'fallback' },
          -- Принятие
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-y>'] = { 'select_and_accept' },
          -- Отмена
          ['<C-e>'] = { 'hide' },
          ['<C-c>'] = { 'cancel' },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then return { 'buffer' } end
          if type == ':' then return { 'cmdline' } end
          return {}
        end,
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
        
        trigger = {
          show_in_snippet = true,
        },
      },
      
sources = {
        -- 'snippets' в начале — это ок, но LSP обычно важнее буфера
        default = { 'snippets', 'buffer', 'lsp', 'path' },
        
        providers = {
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
            -- Указываем, какие буферы сканировать
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.api.nvim_buf_is_valid(bufnr) 
                         and vim.bo[bufnr].buftype == "" -- только обычные файлы
                end, vim.api.nvim_list_bufs())
              end,
            },
            -- min_keyword_length = 2 — это хорошо для JS
            min_keyword_length = 2,
            -- ВАЖНО: снижаем score_offset. 
            -- Если у буфера 100, а у LSP 60, буфер завалит вам весь список мусором.
            -- Обычно ставят ниже LSP.
            score_offset = 15, 
          },
          
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            score_offset = 100, -- LSP должен быть в приоритете
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
      vim.notify('Blink.cmp are loaded', vim.log.levels.INFO)
    end,
  },
}
