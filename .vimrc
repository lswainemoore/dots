" KEEP THIS UP TOP
:let mapleader = ","

" PLUGINS

" AUTO-INSTALL
" see: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
" and: https://github.com/junegunn/vim-plug/issues/894#issuecomment-544796656
" (makes it work without curl)
if empty(glob('~/.vim/autoload/plug.vim'))
  let s:downloadurl = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let s:destinedirectory = $HOME . "/.vim/autoload"
  let s:destinefile = s:destinedirectory . "/plug.vim"

  if !isdirectory(s:destinedirectory)
    call mkdir(s:destinedirectory, "p")
  endif

  if executable("curl")
    silent execute '!curl --output ' . s:destinefile .
        \ ' --create-dirs --location --fail --silent ' . s:downloadurl

  else
    silent execute '!wget --output-document ' . s:destinefile .
        \ ' --no-host-directories --force-directories --quiet ' . s:downloadurl
  endif

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mg979/vim-visual-multi'
" Plug 'terryma/vim-multiple-cursors'  " i didn't love this one as much but it's better supported
Plug 'vim-airline/vim-airline'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
call plug#end()

" EMMET CUSTOMIZATION
" only allow for html/css
let g:user_emmet_install_global = 0  
autocmd FileType html,css EmmetInstall
" new leader
let g:user_emmet_leader_key=','

" FZF CUSTOMIZATION
nnoremap <c-p> :FZF<cr>
nnoremap <leader>e :Tags<cr>
nnoremap <leader>r :BTags<cr>
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -V -R --excmd=number --exclude="*.pyc" --exclude="*.min.js" --exclude="*.zip" --exclude="*compiled.js" --exclude="local/*"'
command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})
nnoremap <leader>b :FZFMru<cr>
nnoremap <leader>d :call fzf#vim#tags('^' . expand('<cword>'), {'options': '--exact --select-1 --exit-0 +i'})<CR>

let g:airline#extensions#tabline#enabled = 1

" PREVIEW WINDOW
" source: https://github.com/junegunn/fzf.vim/issues/800#issuecomment-552224315
let plugins_dir='~/.vim/plugged' 
let preview_file = plugins_dir . "/fzf.vim/bin/preview.sh"
command! -bang -nargs=* Tags
  \ call fzf#vim#tags(<q-args>, {
  \      'down': '40%',
  \      'options': '
  \         --with-nth 1,2
  \         --preview-window="70%"
  \         --preview ''' . preview_file . ' {2}:$(echo {3} | cut -d ";" -f 1)'''
  \ }, <bang>0)

" SUBLIME-LIKE LINE DELETION
:imap <c-S-k> <esc>ddi
:map <c-S-k> dd

" TOGGLE COMMENTING (WITH BLOCK SUPPORT)
" source: https://stackoverflow.com/a/24046914
let s:comment_map = { 
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "python": '#',
    \   "ruby": '#',
    \   "rust": '\/\/',
    \   "sh": '#',
    \   "desktop": '#',
    \   "fstab": '#',
    \   "conf": '#',
    \   "profile": '#',
    \   "bashrc": '#',
    \   "bash_profile": '#',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "vim": '"',
    \   "tex": '%',
    \ }
function! ToggleComment()
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ "^\\s*" . comment_leader . " " 
            " Uncomment the line
            execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
        else 
            if getline('.') =~ "^\\s*" . comment_leader
                " Uncomment the line
                execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
            else
                " Comment the line
                execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
            end
        end
    else
        echo "No comment leader found for filetype"
    end
endfunction
nnoremap <leader>cc :call ToggleComment()<cr>
vnoremap <leader>cc :call ToggleComment()<cr>

" HELPER FUNCTION TO PREVENT FUNCTIONS FROM OVERWRITING STATE
" src: https://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" STRIP TRAILING WHITESPACE FOR CERTAIN FILES
" src: https://unix.stackexchange.com/a/75438 and https://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
autocmd BufWritePre * if &ft =~ 'sh\|perl\|python\|javascript\|html' | :call Preserve("%s/\\s\\+$//e") | endif

" VISUALIZE WHITESPACE
" see: https://gist.github.com/simonista/8703722
set listchars=tab:▸\ ,eol:¬,space:.
map <leader>l :set list!<CR> " Toggle tabs and EOL

" MAKE DELETE WORK IN INSERT MODE
set backspace=indent,eol,start

" GIT DIFF
" source: https://www.monolune.com/showing-git-diff-in-vim/
function GitDiff()
    :silent write
    :silent execute '!git diff --color=always -- ' . fnameescape(expand('%:p')) . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction
nnoremap <leader>gd :call GitDiff()<cr>

" GIT ADD CURRENT FILE
" adapted from above ^
function GitAdd()
    :silent write
    :silent execute '!git add ' . fnameescape(expand('%:p'))
    :redraw!
endfunction
nnoremap <leader>ga :call GitAdd()<cr>

" GIT RESET CURRENT FILE
" adapted from above ^^
function GitReset()
    :silent write
    :silent execute '!git reset ' . fnameescape(expand('%:p'))
    :redraw!
endfunction
nnoremap <leader>gr :call GitReset()<cr>

" RELOAD CONFIG (META)
" see: https://superuser.com/a/132030
nnoremap <leader>lo :so $MYVIMRC<cr>
"
" RANDOM STUFF
syntax on
set number
set relativenumber
set expandtab
set shiftwidth=4 smarttab
filetype plugin indent on
" note that we're doing something slightly different from just escape here, to
" prevent from going backward on escape
" see: https://vim.fandom.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
:imap jj <C-O>:stopinsert<CR>
:imap jkj <c-o>

" CHEATING
set mouse=n

" BETTER FOLDING
" source: https://unix.stackexchange.com/a/141104
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" CORRECT TABBING FOR HTML, JS
" see: https://vi.stackexchange.com/a/12917
autocmd BufRead,BufNewFile *.htm,*.html,*.js setlocal tabstop=2 shiftwidth=2 softtabstop=2

" FOR VIM-AIRLINE
" set ruler  " disabling while using vim-airline
set noshowmode  " see https://github.com/vim-airline/vim-airline/issues/538

" TAB TO COMPLETE
" source: https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

inoremap ipdb import ipdb; ipdb.set_trace()

" GOOD RESOURCES
" https://gist.github.com/simonista/8703722
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" https://vimconfig.com
" https://learnvimscriptthehardway.stevelosh.com


" TODO
