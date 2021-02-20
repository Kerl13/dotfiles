filetype plugin indent on

" ---[ Basic [n]vim configuration ]---

" Jump to last position on file reopening
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! `\"" | endif

set whichwrap=b,s,<,>,[,]
set listchars=tab:\ \ ⊣,trail:-,nbsp:␣
set list
set mouse=a
set splitright
set number
set signcolumn=number
set colorcolumn=80
set textwidth=80
set spelllang=en_gb

" Tabulations
set tabstop=2
set shiftwidth=2
set smartindent
set expandtab

nnoremap <space> <Nop>
let mapleader = " "
let maplocalleader = " "

colorscheme gruvbox

" ---[ Installed plugins ]---

call plug#begin(stdpath('data') . '/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'},
Plug 'lervag/vimtex',
Plug 'ap/vim-buftabline',
Plug 'scrooloose/nerdcommenter',
Plug 'tpope/vim-repeat',
Plug 'tpope/vim-surround',

call plug#end()

" ---[ Buffers & windows management ]---

set hidden
nnoremap <leader>bd :<C-u>bdelete<cr>
nnoremap <leader>bn :<C-u>bnext<cr>
nnoremap <leader>bp :<C-u>bprev<cr>

nnoremap <tab> <C-w>w
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ---[ NERDCommenter configuration ]---

let g:NERDSpaceDelims=1

" ---[ Indentation ]---

nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv

" ---[ Coc configuration ]---

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)

" Show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming
nmap <leader>lr <Plug>(coc-rename)

" Integration with the statusline
" XXX. Breaks the default statusline ?!
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Diagnostics
nnoremap <silent><nowait> <leader>d :<C-u>CocDiagnostics<cr>
nnoremap <silent>         <leader>k :<C-u>call CocAction('diagnosticPrevious')<cr>
nnoremap <silent>         <leader>j :<C-u>call CocAction('diagnosticNext')<cr>

" ---[ Tree-sitter ]---

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
