function! kerl#before() abort
  autocmd BufRead,BufNewFile,BufFilePre dune setfiletype dune
  autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif
  let g:indentLine_setConceal = 0
  set textwidth=80
endfunction
