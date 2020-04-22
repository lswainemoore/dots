:let mapleader = ","

:imap jj <Esc>

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

" STRIP TRAILING WHITESPACE
" source https://unix.stackexchange.com/a/75438
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * if &ft =~ 'sh\|perl\|python' | :call <SID>StripTrailingWhitespaces() | endif

" VISUALIZE WHITESPACE
" see: https://gist.github.com/simonista/8703722
set listchars=tab:▸\ ,eol:¬,space:.
map <leader>l :set list!<CR> " Toggle tabs and EOL

# MAKE DELETE WORK IN INSERT MODE
set backspace=indent,eol,start

" RANDOM STUFF
syntax on
set number
set ruler
filetype plugin indent on

" GOOD RESOURCES
" https://gist.github.com/simonista/8703722
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" https://vimconfig.com
" https://learnvimscriptthehardway.stevelosh.com

" TODO
" get vundle set up
" install https://github.com/Vimjas/vim-python-pep8-indent
