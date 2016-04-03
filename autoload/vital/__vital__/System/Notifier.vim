"=============================================================================
" FILE: autoload/vital/__vital__/System/Notifier.vim
" AUTHOR: haya14busa
" License: MIT license
" Reference: https://github.com/mikaelbr/node-notifier
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_loaded(V) abort
  let s:Prelude = a:V.import('Prelude')
  let s:Process = a:V.import('Process')
  let s:notifiers = [
  \   a:V.import('System.Notifier.NotifySend')
  \ ]
  for notifier in s:notifiers
    if notifier.available()
      let s:default_notifier = notifier
    endif
  endfor
endfunction

function! s:_vital_depends() abort
  return [
  \   'Prelude',
  \   'Process',
  \   'System.Notifier.NotifySend',
  \ ]
endfunction

function! s:notify(arg) abort
  if !exists('s:default_notifier')
    return s:_throw('does not support your platform')
  endif
  let option = a:arg
  if type(a:arg) is# type('')
    let option = {}
    let option.message = a:arg
  endif
  if !has_key(option, 'message')
    return s:_throw('message is required')
  endif
  echo s:default_notifier.build_command(option)
  return s:Process.system(s:default_notifier.build_command(option))
endfunction

function! s:_throw(message) abort
  throw printf('vital: System.Notifier: %s', a:message)
endfunction

" DEBUG
if expand('%:p') ==# expand('<sfile>:p')
  call s:_vital_loaded(vital#vital#of())
endif


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
