"
" wangha
" 2020/8/16
"
" Clocktea need timer supported in vim
"
" Install:
" 1. download this srcipt file
" 2. source Clocktea.vim
" 3. mv Clocktea.vim to $HOME/.vim/Clocktea.vim
"
" Usage:
" input \":Clocktea\" in vim command
"
" Test:(Recommand at now)
" 1. vim Clocktea.vim
" 2. type \":so %\"
"

" size of window
let g:win_w = winwidth('%')
let g:win_h = winheight('%')

let g:is_windows = 0
let g:is_linux = 0

" platform select
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let is_windows = 1
else
    let is_linux = 1
endif

" date
function! Getdate()
	if(exists("*strftime"))
		let timec = strftime('%Y / %m / %d')
		return timec
	else
		return "Function strftime is not supported."
	endif
endfunction

" time
function! Gettime()
	if(exists("*strftime"))
		return strftime("%H : %M : %S")
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

" color setting
function! Color()
	:highlight CT_header ctermbg=red guibg=green ctermfg=yellow
	:highlight CT_footer ctermbg=green guibg=red ctermfg=blue
	:call matchadd('CT_header', '.*Clocktea.*')
	:call matchadd('CT_footer', '########################')
"	:call matchadd('Error', '===.*:.*:.*===')
"	:call matchadd('Error', '==.*\/.*\/.*==')
endfunction

" update text
function! Generate_timeinfo(id)
	:1,$d "del content
	call append(line('^'), "~~~~~~~~Clocktea~~~~~~~~")

	if(g:is_linux)
		call append(line('$'), "PLATFORM: LINUX")
	elseif(g:is_windows)
		call append(line('$'), "PLATFORM: WINDOWS")
	else
		call append(line('$'), "UNSUPPRTED PLATFORM")
	endif

	call append(line('$'), "ABOUT SIZE H: ".g:win_h." W ".g:win_w)
	call append(line('$'), "")

	call append(line('$'), "==".Getdate()."==")
	call append(line('$'), "===".Gettime()."===")
	call append(line('$'), "")
	call append(line('$'), "TimerID: ".a:id)
"	call append(line('$'), Gettimestamp())
	call append(line('$'), "")
	call append(line('$'), "########################")

	" FIX: the Performance is bad due to system()
	" MODIFY: ":" should be flashing every .5 sec
	" TODO code figlet with vimL
	let @t=system('figlet "'.Gettime().'"')
	:7pu d
	:14pu t
endfunction

function! Clocktea()
	" tabnew can avoil screen flicker
	:tabnew Clocktea
	let @d=system('figlet "'.Getdate().'"')
	if(g:is_linux)
		call Color()
		"TODO FIX: exit the tab will cause origin file be change when timer is running.
		let g:timer = timer_start(1000, 'Generate_timeinfo', {'repeat': 5})
	elseif(g:is_windows)
		call append(line('^'), "windows is not supported now. thanks for your supporting.")
		call append(line('$'), "")
	else
		call append(line('^'), "your platform is not supported now. thanks for your supporting.")
		call append(line('$'), "")
	endif
endfunction

function! Close()
	" clear when close
	" include timer
	:call timer_stop(g:timer)
endfunction

" add to env:
:command! Clocktea call Clocktea()
:Clocktea

