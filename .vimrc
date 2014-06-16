set pastetoggle=<F4>

if has("syntax")
  syntax on                       " syntax highlighting on
                                  " (makes code and config files more readable)
endif

set background=dark             " If using a dark background, instead of the
                                " usual white background in Terminal
                                " (makes darker colors brighter)

set nocp                        " set vi non-compatible
set nobk                        " set no backup file
set ai                          " set autoindent
set si                          " set smart indent

set ru                          " show ruler
set sc                          " show commands
set nu                          " show line number
set vb                          " use visual bell instead of beeping

set wmnu                        " use wildmenu
set smd                         " set show mode
set incsearch                   " Used for incremental searching
                                " (useful when searching large text files)

set is                          " set immediate search matching
set ic                          " set ignore case on search
set scs                         " ignore ignore case on uppercase
set hlsearch                    " highlight search terms

set noeb                        " no error bell
set noet                        " use tabs for tabs, not spaces
set nosol                       " up and down use columns not start of line
set bs=2                        " indent,eol,start
set shm=at                      " shortmess a(filmnrwx) all, t truncate

set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class

set mouse=a                     " scroll using the scroll wheel

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

set tabstop=8                   " Sets the tab size to 8
                                " (tabs are usually 8 spaces)
set expandtab                   " Tab key inserts spaces instead of tabs
set softtabstop=4

set shiftwidth=4                " Sets spaces used for (auto)indent
set shiftround                  " Indent to nearest tabstop


set ch=2                        " set command height
-"set vbs=1                     " sets verbose level (0,1,2,5,8,9,12,15)


set exrc
set viminfo='20,\"50
set ruf=%l,%c%V%r%m
let is_bash=1
set laststatus=2

if has("syntax")
  syntax on
endif

set showcmd
set showmatch


set spellsuggest=5

match Error /\s\+$/
