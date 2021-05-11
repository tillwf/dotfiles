" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

" autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror
autocmd VimEnter * wincmd w

set laststatus=2
""""""""""""""""""""""""""""""
" airline
""""""""""""""""""""""""""""""
let g:airline_theme             = 'powerlineish'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1
let g:airline_powerline_fonts   = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Leader
let mapleader = " "
set backspace=2 " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set laststatus=2 " Always display the status line
set autowrite " Automatically :write before running commands

augroup vimrcEx
autocmd!
	" When editing a file, always jump to the last known cursor position.
	" Don't do it for commit messages, when the position is invalid, or when
	" inside an event handler (happens when dropping a file on gvim).
	autocmd BufReadPost *
	\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
	\ exe "normal g`\"" |
	\ endif
	" Set syntax highlighting for specific file types
	autocmd BufRead,BufNewFile Appraisals set filetype=ruby
	autocmd BufRead,BufNewFile *.md set filetype=markdown
	" Enable spellchecking for Markdown
	autocmd FileType markdown setlocal spell
	" Automatically wrap at 80 characters for Markdown
" 	autocmd BufRead,BufNewFile *.md setlocal textwidth=80
	" Automatically wrap at 72 characters and spell check git commit messages
	autocmd FileType gitcommit setlocal textwidth=72
	autocmd FileType gitcommit setlocal spell
	" Allow stylesheets to autocomplete hyphenated words
	autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
	" Use Ag over Grep
	set grepprg=ag\ --nogroup\ --nocolor
	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif


" Color scheme
" colorscheme github
highlight NonText guibg=#060606
highlight Folded guibg=#0A0A0A guifg=#9090D0
" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1
" Numbers
set number
set numberwidth=5
" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Get off my lawn
" nnoremap <Left> :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up> :echoe "Use k"<CR>
" nnoremap <Down> :echoe "Use j"<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
	source ~/.vimrc.local
endif

