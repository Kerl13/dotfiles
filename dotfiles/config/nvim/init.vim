filetype plugin indent on

" Jump to last position on file reopening
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! `\"" | endif

set whichwrap=b,s,<,>,[,]
set listchars=tab:\ \ ⊣,trail:-,nbsp:␣
set list
set mouse=a
set splitright
set number

colorscheme gruvbox

" Tabs
set tabstop=2
set shiftwidth=2
set smartindent
set expandtab

" Shortcuts for moving between windows.
nnoremap <tab> <C-w>w
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Remain in visual mode after indenting
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv

" Plugin management
call plug#begin(stdpath('data') . '/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
" Plug 'dense-analysis/ale',
Plug 'neoclide/coc.nvim', {'branch': 'release'},
call plug#end()

" ocaml-merlin
let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Tree-sitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "vv",
      node_incremental = "v",
      node_decremental = "V",
      scope_incremental = "s",
    }
  }
}
EOF
