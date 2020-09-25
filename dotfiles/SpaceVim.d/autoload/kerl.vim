function RandomSeed() abort
  let cmd = '/bin/sh -c "xxd -l 8 -p /dev/random"'
  let res = substitute(system(cmd), '[^0-9a-fA-F]', '', 'g')
  execute "normal! a0x" . res . "\<Esc>"
endfunction

function! kerl#before() abort
  autocmd BufRead,BufNewFile,BufFilePre dune setfiletype dune
  autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

  let g:indentLine_setConceal = 0
  set textwidth=80

  " LaTeX stuff
  let g:vimtex_view_method = 'mupdf'
  let g:vimtex_quickfix_method = 'pplatex'
  let g:neomake_tex_enabled_makers = ['proselint', 'chktex']

  " Python stuff
  let g:neomake_python_isort_maker = {
        \ 'exe': 'isort',
        \ 'args': ['--check'],
        \ 'errorformat': 'ERROR: %f %m',
        \ }
  let g:neomake_python_enabled_makers = ['flake8', 'isort']

  " RandomSeed
  nnoremap <Space>is :call RandomSeed()<CR>

  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
endfunction
