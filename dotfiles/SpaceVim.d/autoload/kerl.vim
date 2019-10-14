function! kerl#fix_long_line_hl()
  let &colorcolumn=join(range(&textwidth+1,999),',')
endfunction
