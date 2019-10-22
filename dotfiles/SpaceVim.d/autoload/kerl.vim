function! kerl#fix_long_line_hl()
  if &textwidth > 0
    let &colorcolumn=join(range(&textwidth+1,999),',')
  endif
endfunction

function! kerl#after() abort
  nnoremap <Space><Space>m :make<CR>
endfunction
