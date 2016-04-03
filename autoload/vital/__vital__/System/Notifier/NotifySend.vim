"=============================================================================
" FILE: autoload/vital/__vital__/System/Notifier/NotifySend.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_loaded(V) abort
  let s:I = a:V.import('Data.String.Interpolation')
  let s:Process = a:V.import('Process')
endfunction

function! s:_vital_depends() abort
  return {
  \   'modules': [
  \     'Data.String.Interpolation',
  \     'Process',
  \   ],
  \ }
endfunction

" DEBUG
if expand('%:p') ==# expand('<sfile>:p')
  call s:_vital_loaded(vital#vital#of())
endif

" # notify-send --help
" Usage:
"   notify-send [OPTION...] <SUMMARY> [BODY] - create a notification
"
" Help Options:
"   -?, --help                        Show help options
"
" Application Options:
"   -u, --urgency=LEVEL               Specifies the urgency level (low, normal, critical).
"   -t, --expire-time=TIME            Specifies the timeout in milliseconds at which to expire the notification.
"   -a, --app-name=APP_NAME           Specifies the app name for the icon
"   -i, --icon=ICON[,ICON...]         Specifies an icon filename or stock icon to display.
"   -c, --category=TYPE[,TYPE...]     Specifies the notification category.
"   -h, --hint=TYPE:NAME:VALUE        Specifies basic extra data to pass. Valid types are int, double, string and byte.
"   -v, --version                     Version of the package.

let s:command = 'notify-send'

function! s:notify(option) abort
  return s:Process.system(s:build_command(a:option))
endfunction

function! s:available() abort
  return executable(s:command)
endfunction

function! s:build_command(option) abort
  let command = s:command
  let options = s:_build_option_str(a:option)
  if has_key(a:option, 'title')
    let summary = shellescape(a:option.title)
    let body = shellescape(a:option.message)
  else
    let summary = shellescape(a:option.message)
    let body = ''
  endif
  let cmd = s:I.interpolate('${command} ${options} ${summary} ${body}', l:)
  return cmd
endfunction

function! s:_build_option_str(option) abort
  let options = []
  if has_key(a:option, 'icon')
    let options += ['--icon=' . shellescape(expand(a:option.icon))]
  endif
  return join(options, ' ')
endfunction

function! s:_example() abort
  let vim_png = s:ImageDir . '/Image/vim48x48.png'
  call s:notify({
  \   'title': 'Vim',
  \   'message': 'http://www.vim.org/',
  \   'icon': vim_png,
  \ })
endfunction

" DEBUG
if expand('%:p') ==# expand('<sfile>:p')
  let s:ImageDir = expand('<sfile>:h')
  call s:_example()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
