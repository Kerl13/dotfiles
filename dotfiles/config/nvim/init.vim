filetype plugin indent on

" ---[ Basic [n]vim configuration ]---

" Jump to last position on file reopening
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! `\"" | endif

" Make the quickfix/loclist buffer unlisted (they are not shown by :bnext) and smaller
" than default (10 lines).
au FileType qf setlocal nobuflisted
au FileType ll setlocal nobuflisted


set whichwrap=b,s,<,>,[,]
set listchars=tab:\ \ ⊣,trail:-,nbsp:␣
set list
set mouse=a
set splitright
set number
set signcolumn=number
set colorcolumn=+1
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

" ---[ Quickfix ]---

nnoremap <leader>qo :<c-u>copen<cr>
nnoremap <leader>qc :<c-u>cclose<cr>
nnoremap <leader>qn :<c-u>cnext<cr>
nnoremap <leader>qp :<c-u>cprev<cr>

" Automatically adjust the quickfix height.
" Source: https://gist.github.com/juanpabloaj/5845848
au FileType qf call <sid>AdjustWindowHeight(2, 10)
function! s:AdjustWindowHeight(minheight, maxheight)
  let l = 1
  let n_lines = 0
  let w_width = winwidth(0)
  while l <= line('$')
    " number to float for division
    let l_len = strlen(getline(l)) + 0.0
    let line_width = l_len / w_width
    let n_lines += float2nr(ceil(line_width))
    let l += 1
  endwhile
  exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

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
Plug 'joom/latex-unicoder.vim'

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

" ---[ Lightline ]---

let g:lightline = {
  \'colorscheme': 'seoul256',
  \'active':{
  \  'left': [['mode', 'paste'],
  \           ['readonly', 'filename', 'modified','lsp']]
  \},
  \'component_function': {'lsp': 'LspStatus'}
  \}

function! LspStatus() abort
  let err = 0
  let warn = 0
  let info = 0
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let err = luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")
    let warn = luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
  else
    let counts = ale#statusline#Count(bufnr(''))
    let err = counts.error + counts.style_error
    let warn = counts.warning + counts.style_warning
    let info = counts.info
  endif
  let s = ''
  if err > 0
    let s .= 'E:' . err
  endif
  if warn > 0
    let s .= ((s == '') ? '' : ' ') . 'W:' . warn
  endif
  if info > 0
    let s .= ((s == '') ? '' : ' ') . 'I:' . info
  endif
  if s == ''
    return '✔'
  else
    return s
  endif
endfunction

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

" ---[ Latex-unicoder ]---

let g:unicoder_cancel_normal = 1
let g:unicoder_cancel_insert = 1
let g:unicoder_cancel_visual = 1
nnoremap gL :<c-u>call unicoder#start(0)<cr>
nnoremap gl F\ve:call unicoder#selection()<cr>
vnoremap gl :<c-u>call unicoder#selection()<cr>

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
