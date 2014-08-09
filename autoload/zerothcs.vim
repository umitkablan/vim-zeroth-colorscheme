
let s:zcs_confpath = expand('<sfile>:p:h')

function! zerothcs#Load_CS(csname)
	let cspath = g:zerothcs_colors_path . '/colors/' . a:csname . '.vim'
	if !filereadable(cspath)
		let url = zerothcs#Get_URL_Of_CS(a:csname)
		if url == ""
			echoerr 'Color ' . a:csname . ' could not be found. its URL is not defined!'
			return
		endif
		call zerothcs#Dload_CS(url, cspath)
		if !filereadable(cspath)
			echoerr 'Cannot download ' . url . '. FAIL.'
			return
		endif
	endif
	exec 'colorscheme ' . a:csname
endfunction

function! zerothcs#Get_URL_Of_CS(csname)
	let ret = ""
	let fname = s:zcs_confpath . "/../colors_paths.txt"
	for line in readfile(fname)
		if line =~# '^' . a:csname . ' '
			let len = strlen(a:csname)
			let ret = line[len+1:]
			break
		endif
	endfor
	return ret
endfunction

function! zerothcs#Get_AllColors_List()
	let ret = []
	let fname = s:zcs_confpath . "/../colors_paths.txt"
	for line in readfile(fname)
		let i = stridx(line, ' ')
		if i > 0
			let ret = ret + [line[0:i-1]]
		endif
	endfor
	return ret
endfunction

function! zerothcs#Dload_CS(csurl, fpath)
	let cline  = 'wget -q ' . shellescape(a:csurl) . " -O " . shellescape(a:fpath)
	call system(cline)
endfunction

function! zerothcs#Complete_Colors(initials)
	let ret = []
	for i in zerothcs#Get_AllColors_List()
		if i =~# '^' . a:initials
			let ret = ret + [i]
		endif
	endfor
	return ret
endfunction

