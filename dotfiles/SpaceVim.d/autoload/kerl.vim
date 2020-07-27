function! kerl#before() abort
  autocmd BufRead,BufNewFile,BufFilePre dune setfiletype dune
  autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

  let g:indentLine_setConceal = 0
  set textwidth=80

  " LaTeX stuff
  let g:vimtex_view_method = 'mupdf'
  let g:vimtex_quickfix_method = 'pplatex'
  let g:neomake_tex_enabled_makers = ['proselint', 'chktex']
endfunction
