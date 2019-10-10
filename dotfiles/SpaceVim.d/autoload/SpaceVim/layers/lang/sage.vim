"=============================================================================
" sage.vim --- sage layer file for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Martin Pépin < kerl@wkerl.me >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#sage#plugins() abort
  let plugins = []
  call add(plugins, ['petrushka/vim-sage'])
  return plugins
endfunction
