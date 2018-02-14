
let s:zcs_confpath = expand('<sfile>:p:h')

function! zerothcs#Load_CS(csname)
	let [is_git, url] = zerothcs#Get_URL_Of_CS(a:csname)
	if url ==# ''
		echoerr 'ZerothColor ' . a:csname . ' could not be found. its URL is not defined!'
		return
	endif

	let cspath = g:zerothcs_colors_path . '/colors/' . a:csname . '.vim'
	if !is_git && filereadable(cspath)
		exec 'colorscheme ' . a:csname
		return
	endif

	if is_git
		let [dirp, sherr, out] = s:clone_CS(url, g:zerothcs_colors_repodir)
		if dirp ==# ''
			echoerr 'ZerothCS: Could not clone repo: ' . url . ':' . sherr . ':' . out
			return
		endif
		exec 'set rtp+=' . dirp
		exec 'colorscheme ' . a:csname
	else
		call s:download_Wget(url, cspath)
		if !filereadable(cspath)
			echoerr 'Cannot download ' . url . '. FAIL.'
			return
		endif
	endif
	exec 'colorscheme ' . a:csname
endfunction

function! zerothcs#Get_URL_Of_CS(csname)
	let ret = s:getURL_Of_CS(a:csname, s:zcs_confpath . '/../colors_git.txt')
	if len(ret)
		return [1, ret]
	endif
	let ret = s:getURL_Of_CS(a:csname, s:zcs_confpath . '/../colors_paths.txt')
	return [0, ret]
endfunction

function! zerothcs#Get_AllColors_List()
	let ret  = s:readForNames(s:zcs_confpath . '/../colors_paths.txt')
	let ret += s:readForNames(s:zcs_confpath . '/../colors_git.txt')
	return ret
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

function! s:download_Wget(csurl, fpath)
	let cline = 'wget -q --no-check-certificate ' . shellescape(a:csurl) . " -O " . shellescape(a:fpath)
	call system(cline)
endfunction

function! s:clone_CS(csurl, dirpath)
	let slashi = strridx(a:csurl, '/')
	if slashi < 0
		return [0, 0, 1]
	endif
	let dirp = a:dirpath . '/' . a:csurl[slashi+1:]
	if isdirectory(dirp)
		return [dirp, 0, '']
	endif
	let cline = 'git clone ' . shellescape(a:csurl) . ' ' . dirp
	let [out, err, sherr] = s:execSystem(cline)
	return [sherr == 0 ? dirp : '', sherr, sherr == 0 ? out : err]
endfunction

function! s:readForNames(fname) abort
	let ret = []
	for line in readfile(a:fname)
		let i = stridx(line, ' ')
		if i > 0
			let ret = ret + [line[0:i-1]]
		endif
	endfor
	return ret
endfunction

function! s:getURL_Of_CS(csname, fpath) abort
	let ret = ''
	for line in readfile(a:fpath)
		if line =~# '^' . a:csname . ' '
			let len = strlen(a:csname)
			let ret = line[len+1:]
			break
		endif
	endfor
	return ret
endfunction

function! s:execSystem(cmd) abort
	let [sr, errfile] = [&shellredir, '._vim-zerothcs.ERR']
	if !(has('win32') || has('win64'))
		set shellredir=>%s\ 2>._vim-zerothcs.ERR
	endif
	let [out, err] = [system(a:cmd), join(readfile(errfile))]
	let &shellredir=sr
	call delete(errfile)
	return [out, err, v:shell_error]
endfunction

