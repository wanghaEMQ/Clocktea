"
" wangha
" 2020/8/16
"
" Clocktea need timer supported in vim
"
" Install:
" 1. download this srcipt file
" 2. source Clocktea.vim
"
" Usage:
" input \":Clocktea\" in command
"

" size of window
let win_w = winwidth('%')
let win_h = winheight('%')

:echo "weight:" win_w
:echo "height:" win_h

let is_windows = 0
let is_linux = 0

" platform select
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let is_windows = 1
	:echo "p:windows"
else
    let is_linux = 1
	:echo "p:linux"
endif

" date
function! Getdate()
	if(exists("*strftime"))
		return strftime("=======%Y/%m/%d=======")
	else
		return "Function strftime is not supported."
	endif
endfunction

" time
function! Gettime()
	if(exists("*strftime"))
		return strftime("========%H:%M:%S========")
	else
		return "Function strftime is not supported."
	endif
endfunction

" timestamp
"function! Gettimestamp()
"	let tstamp = strftime('%s000')
"	%s#<property name='p2.timestamp' value='\zs\d\+\ze'/>#\=tstamp#g
"	return tstamp
"endfunction

" update text
function! Generate_timeinfo(id)
	:1,$d "del content
	call append(line('^'), "~~~~~~~~Clocktea~~~~~~~~")
	call append(line('$'), Getdate())
	call append(line('$'), Gettime())
"	call append(line('$'), Gettimestamp())
	call append(line('$'), "")
	call append(line('$'), "########################")
endfunction

function! Clocktea()
	" tabnew can avoil screen flicker
	:tabnew Clocktea
	"TODO FIX: exit the tab will cause origin file be change when timer is running.
	let timer = timer_start(1000, 'Generate_timeinfo', {'repeat': 10})
"	:call Generate_timeinfo()
endfunction

" add to env:
:command! Clocktea call Clocktea()
:Clocktea

