"==========================================================
" GENERAL SETTINGS
"==========================================================
"
"----------------------------------------------------------
" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
"----------------------------------------------------------
set nocompatible
set number
"set hidden "for LustyExplorer

let mapleader = ","
let g:mapleader = ","

set exrc
set secure

"
"----------------------------------------------------------
" Enable file type detection. Use the default filetype settings.
" Also load indent files, to automatically do language-dependent indenting.
"----------------------------------------------------------
filetype  plugin on
filetype  indent on
"
"----------------------------------------------------------
" ==> Switch syntax highlighting on.
"----------------------------------------------------------
syntax    on            
if  has("win16") || has("win32") || has("win64") || has("win95")
  "  set backupdir =$VIM\vimfiles\backupdir
  "  set dictionary=$VIM\vimfiles\wordlists/german.list
else
  set backupdir =$HOME/.vim/backupdir
  set dictionary=$HOME/.vim/wordlists/english.list
  set directory=$HOME/.vim/swapdir
endif
"
"----------------------------------------------------------
" Various settings
"----------------------------------------------------------
"== indent
set autoindent        " copy indent from current line
set smartindent       " smart autoindenting 
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab        
set cinoptions+=g0,h2

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set laststatus=2
"set relativenumber
set undofile

"== SEARCH 
set hlsearch        " highlightthe last used search pattern
set incsearch       " do incremental searching
set ignorecase      " Ignore case when searching
"== ETC 
set autoread        " read open changed files again 
set autowrite       " write a modified buffer on each :next
""" backspacing over everything in insert mode
set backspace=indent,eol,start  
set backup             " keep a backup file
"set browsedir=current  
""" scan the files given with the 'dictionary' option
set complete+=k      
set history=50     
""" strings to use in 'list' mode
"set listchars=tab:>.,eol:\$     
"set mouse=nv         " enable the use of the mouse
"set magic           
"set cb=unnamed
"set nowrap           " do not wrap lines
set popt=left:8pc,right:3pc   " print options
set ruler             " show the cursor position all the time
set showcmd           " display incomplete commands
set visualbell        " visual bell instead of beeping
set wildignore=*.bak,*.o,*.e,*~ 
set wildmenu    " command-line completion in an enhanced mode
set smartcase                   " TODO
"set showmatch
"set mat=2       "How many tenths of a second to blink TODO
"
"-------------------------------------------------------
" The current directory is the directory of the file 
" in the current window.
"-------------------------------------------------------
if has("autocmd")
  autocmd BufEnter * :lchdir %:p:h
  "autocmd BufWritePost .vimrc source %
  "autocmd filetype html,xml set listchars-=tab:>.
endif
"
"-------------------------------------------------------
"  highlight paired brackets
"-------------------------------------------------------
highlight MatchParen ctermbg=blue guibg=lightyellow


"-------------------------------------------------------
"  HOTKEYS
"-------------------------------------------------------
noremap   <silent>  <F2>             :NERDTreeToggle<CR>
inoremap  <silent>  <F2>        <C-C>:NERDTreeToggle<CR>

noremap   <silent>  '1        :b 1<CR>
noremap   <silent>  '2        :b 2<CR>
noremap   <silent>  '3        :b 3<CR>
noremap   <silent>  '4        :b 4<CR>

"== Fast switching between buffers
noremap  <silent> <s-tab>       :if &modifiable && !&readonly && 
      \                      &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
inoremap  <silent> <s-tab>  <C-C>:if &modifiable && !&readonly && 
      \                      &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

"== Man page in vertical split
map <leader>v <Plug>(Vman)
map <leader>m <Plug>(Vman)


"------------------------------------------------------------
" VIM-PLUG
"------------------------------------------------------------
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes
Plug 'sickill/vim-monokai'
Plug 'vim-utils/vim-man'
Plug 'tomasr/molokai'
"Plug 'vim-scripts/c.vim'
"Plug 'digitaltoad/vim-pug'
"Plug 'pangloss/vim-javascript'
"Plug 'posva/vim-vue'
"Plug 'lervag/vimtex'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py  --clang-completer --tern-completer' }
call plug#end()



"------------------------------------------------------------
" PLUGIN
"------------------------------------------------------------
"== TAGLIST 
let tlist_perl_settings  = 'perl;c:constants;f:formats;l:labels;p:packages;s:subroutines;d:subroutines;o:POD'

"== CTRL
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*pdf,*png,*.o,*.root

"------------------------------------------------------------
" APPREANCE
"------------------------------------------------------------
set guifont=Monaco:h13
colorscheme molokai
set background=dark
let g:molokai_original = 1

"------------------------------------------------------------
" additional filetype
"------------------------------------------------------------
augroup filetype
  au!
  au! BufRead,BufNewFile *.C    set filetype=cpp
augroup END

"------------------------------------------------------------
" TEST
"------------------------------------------------------------
"cmap w!! w !sudo tee % >/dev/null
"vmap Q gq
"nmap Q gqap
"nnoremap ; :
"set nobackup
set noswapfile
set modelines=0
"set foldmethod=syntax
"set foldlevel=3
"set foldtext=v:folddashes.substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g') 
"let Tlist_Show_One_File = 1
set fencs=ucs-bom,utf-8,cp949

"" Javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
" set foldmethod=syntax
" set conceallevel=1

