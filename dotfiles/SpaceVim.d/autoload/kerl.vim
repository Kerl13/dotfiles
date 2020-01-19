function! kerl#before() abort
  autocmd BufRead,BufNewFile,BufFilePre dune setfiletype dune
endfunction
