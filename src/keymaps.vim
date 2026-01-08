" Быстрые команды
nmap <leader>t :call TrimWhitespace()<CR>
nmap <leader>s :so ~/.vimrc<CR>
nmap <silent> <leader><leader> :noh<CR>
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w
nnoremap Q a<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

nmap ;d : call DeployCurrentBuffer()<cr><esc>
nmap ;l :silent call MergeCurrentBuffer()<cr>:redraw<cr>
nmap ;a :call MergeAllBuffers()<cr>
"nmap ;t :set noexpandtab<cr>:retab!<cr>
nmap ;t :call TabToSpace()<cr>
nmap ;s :set expandtab<cr>

" Буферы и вкладки
map <S-left> :bp<cr>
nmap <S-left> :bp<cr>
imap <S-left> <ESC>:bp<cr>i
map <S-right> :bn<cr>
nmap <S-right> :bn<cr>
imap <S-right> <ESC>:bn<cr>i
map <C-Tab> :bn<cr>
nmap <C-Tab> :bn<cr>
imap <C-Tab> <ESC>:bn<cr>i

" Вырезать-копировать-вставить через Ctrl
vnoremap <C-X> "+x
vnoremap <C-C> "+y

" Домашние клавиши
noremap <home> <S-^>
inoremap <home> <Esc> <S-^> I

noremap <C-BS> db
inoremap <C-BS> <Esc>dbi

imap <F2> <Esc> <C-O>vae
nmap <F2> vae

inoremap <C-Del> <Esc>cw
noremap <C-Del> cw

imap <C-F3> <Esc>*
nmap <C-F3> *

imap <C-'> <C-X><C-O>

" Быстрое выделение последнего вставленного текста
nnoremap <expr> <leader>p '`[' . strpart(getregtype(), 0, 1) . '`]'

" Быстрое удаление без копирования
nnoremap s "_d
nnoremap ss "_dd
" Быстрое удаление символа без копирования
nnoremap x "_x
nnoremap X "_X

nmap <F4> :e ~/.vimrc<cr>
nmap <F2> bve
"nnoremap <silent> <F9> :TlistToggle<CR>
nnoremap <F8> Go<Esc>O<Esc>:put =strftime(\"%d/%m/%y %H:%M:%S\")<cr>o<Esc>o<Esc>:w<cr>
nmap <C-Z> :undo<cr>
imap <C-Z> <Esc> :undo<cr>
vnoremap // y/<C-R>"<CR>

"COC
" Вызов меню автодополнения вручную
inoremap <C-n> <C-n>
inoremap <C-p> <C-p>

" Навигация по выпадающему меню автодополнения
inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : "\<C-n>" 
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<C-p>"

inoremap <S-Insert> <C-r>+
nnoremap <S-Insert> "+p
