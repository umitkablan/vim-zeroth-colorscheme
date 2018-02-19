
let s:zcs_confpath = expand('<sfile>:p:h')
let s:lastcolor_fname = 'lastcolor.txt'

function! zerothcs#Load_CS(csname) abort
    if a:csname ==# ''
        let loaded = s:loadCS_Saved()
        if !loaded
            echoerr 'ZerothCS: No loaded colorscheme found!'
        endif
        return
    endif

    let [is_git, url] = zerothcs#Get_URL_Of_CS(a:csname)
    if url ==# ''
        echoerr 'ZerothColor ' . a:csname . ' could not be found. its URL is not defined!'
        return
    endif

    let dirp = ''
    if is_git
        let [dirp, err] = s:loadCS_ViaGit(url)
    else
        let err = s:loadCS_ViaWget(url, a:csname)
    endif

    if len(err)
        echoerr 'ZerothCS: ' . err
    else
        exec 'colorscheme ' . a:csname
        call s:saveCS(a:csname, dirp)
    endif
endfunction

function! zerothcs#Get_URL_Of_CS(csname) abort
    let ret = s:getURL_Of_CS(a:csname, s:zcs_confpath . '/../colors_git.txt')
    if len(ret)
        return [1, ret]
    endif
    let ret = s:getURL_Of_CS(a:csname, s:zcs_confpath . '/../colors_paths.txt')
    return [0, ret]
endfunction

function! zerothcs#Get_AllColors_List() abort
    let ret  = s:readForNames(s:zcs_confpath . '/../colors_paths.txt')
    let ret += s:readForNames(s:zcs_confpath . '/../colors_git.txt')
    return ret
endfunction

function! zerothcs#Complete_Colors(initials) abort
    let ret = []
    for i in zerothcs#Get_AllColors_List()
        if i =~# '^' . a:initials
            let ret = ret + [i]
        endif
    endfor
    return ret
endfunction

function! s:loadCS_Saved() abort
    let [csname, dirp] = s:readCS()
    if len(dirp)
        exec 'set rtp+=' . dirp
    endif
    if len(csname)
        exec 'colorscheme ' . csname
    endif
    return len(csname)
endfunction

function! s:loadCS_ViaGit(url) abort
    let [dirp, sherr, out] = s:clone_CS(a:url, g:zerothcs_colors_repodir)
    if dirp ==# ''
        return [dirp, 'Could not clone repo: ' . a:url . ':' . sherr . ':' . out]
    endif
    exec 'set rtp+=' . dirp
    return [dirp, '']
endfunction

function! s:loadCS_ViaWget(url, csname) abort
    let cspath = g:zerothcs_colors_path . '/colors/' . a:csname . '.vim'
    if filereadable(cspath)
        return ''
    endif

    let [out, err, sherr] = s:execSystem('wget -q --no-check-certificate ' . shellescape(a:url) . ' -O ' . shellescape(cspath))
    if sherr
        call delete(cspath)
        return 'wget ' . a:url . ' err:' . err . ' sherr:' . sherr . ' - ' . out
    endif
    return ''
endfunction

function! s:clone_CS(csurl, dirpath) abort
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

function! s:saveCS(csname, dirpath) abort
    call writefile([a:csname . ' ' . a:dirpath], g:zerothcs_colors_repodir . '/' . s:lastcolor_fname)
endfunction

function! s:readCS() abort
    let [csname, dirpath] = ['', '']
    try
        let line = readfile(g:zerothcs_colors_repodir . '/' . s:lastcolor_fname)[0]
        let spacei = stridx(line, ' ')
        if spacei > 0
            let [csname, dirpath] = [line[0:spacei-1], line[spacei+1:]]
        endif
    catch /.*/
    endtry
    return [csname, dirpath]
endfunction
