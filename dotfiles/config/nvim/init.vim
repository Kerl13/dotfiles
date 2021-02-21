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
let g:lightline = {'colorscheme': 'seoul256'}

" ---[ Indentation ]---

nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv

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

" ---[ Quickfix shortcuts ]---

nnoremap <leader>qo :<c-u>copen<cr>
nnoremap <leader>qc :<c-u>cclose<cr>
nnoremap <leader>qn :<c-u>cnext<cr>
nnoremap <leader>qp :<c-u>cprev<cr>

" ---[ Installed plugins ]---

call plug#begin(stdpath('data') . '/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'nvim-lua/completion-nvim'
Plug 'dense-analysis/ale'
Plug 'lervag/vimtex'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'Raimondi/delimitMate'
Plug 'itchyny/lightline.vim'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

" ---[ Builtin lsp server ]---

lua require('lspconfig').ocamllsp.setup{}

nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> g0         <cmd>lua vim.lsp.buf.document_symbol()<cr>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> <leader>lr <cmd>lua vim.lsp.buf.rename()<cr>

" Disable diagnostics when in insert mode.
lua <<EOF
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
     vim.lsp.diagnostic.on_publish_diagnostics, {
       underline = true,
       virtual_text = false,
       signs = true,
       update_in_insert = false,
     }
  )
EOF

" ---[ Ultisnips ]---

" XXX. I didn't find a way to prevent Ultisnips from defining mappings.
" So let's just define a random mappings and go on…
let g:UltiSnipsExpandTrigger = '<c-tab>'
let g:UltiSnipsListSnippets = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
snoremap <silent> <tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>

" ---[ Autocompletion ]---

autocmd BufEnter * lua require'completion'.on_attach()

set completeopt=menuone,noinsert
set shortmess+=c

let g:completion_confirm_key = ""
let g:completion_enable_snippet = 'UltiSnips'
imap <expr> <tab>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<tab>"

" ---[ ALE ]---

let g:ale_open_list = 1
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_linters_ignore = {
      \ 'python': ['mypy'],
      \ 'tex': ['lacheck'],
      \}

" ---[ Navigate to next/previous error ]---

nmap <silent> <leader>ep :call <sid>previous_error()<cr>
nmap <silent> <leader>en :call <sid>next_error()<cr>

function s:next_error()
  if (luaeval('vim.lsp.buf.server_ready()'))
    lua vim.lsp.diagnostic.goto_next()
  else
    ALENextWrap
  endif
endfunction

function s:previous_error()
  if (luaeval('vim.lsp.buf.server_ready()'))
    lua vim.lsp.diagnostic.goto_prev()
  else
    ALEPreviousWrap
  endif
endfunction

" ---[ Show symbol documentation ]---

nnoremap <silent> K :call <sid>document()<cr>

function s:document()
  if (luaeval('vim.lsp.buf.server_ready()'))
    lua vim.lsp.buf.hover()
  else
    Man
  endif
endfunction

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
