function! DeployCurrentBuffer()
  update
  exec '!/home/za/usr/bin/deploy-vim.sh %:t %:p:h'
  edit
  let buffer_count = NrBufs()
  echo buffer_count
  if (buffer_count == 1)
    quit
  endif
  :bd
endfunction

function! NrBufs()
  let i = bufnr('$')
  let j = 0
  while i >= 1
    if buflisted(i)
      let j+=1
    endif
    let i-=1
  endwhile
  return j
endfunction

function! MergeCurrentBuffer()
  update
  exec 'AsyncRun copy2dev.sh %:t %:p:h'
endfunction

function! MergeAllBuffers()
  ":let buf=bufnr('%') | exec 'bufdo !copy2dev.sh %:t %:p:h' | exec 'b' buf
  :let buf=bufnr('%') | exec 'bufdo !copy2dev.sh %:t %:p:h' | exec 'b' buf

endfunction

function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

function! EscapeString (string)
  let string=a:string
  let string = escape(string, '^$.*\/~[]')
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction

function! TabToSpace()
    let l:save = winsaveview()
    %s/\t/  /g
    call winrestview(l:save)
endfunction

if has("autocmd")
    autocmd FileType {xml,xslt,html,css} setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235
    autocmd! bufwritepost $MYVIMRC source $MYVIMRC
endif

