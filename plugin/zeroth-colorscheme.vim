if exists('g:loaded_zerothcs')
    finish
endif
let g:loaded_zerothcs = 1

if !exists('g:zerothcs_colors_path')
    let g:zerothcs_colors_path = expand('$HOME') . '/.vim'
else
    set rtp+=g:zerothcs_colors_path
    call system('mkdir -p ' . g:zerothcs_colors_path . '/colors')
endif

if !exists('g:zerothcs_colors_repodir')
    let g:zerothcs_colors_repodir = expand('$HOME') . '/.vim/zerothcs_colors'
endif
call system('mkdir -p ' . g:zerothcs_colors_repodir)

if !exists('g:zerothcs_default_git_repo ')
    let g:zerothcs_default_git_repo = 'https://github.com'
endif

command! -nargs=* -complete=customlist,s:Zcs_Complete_Params ZerothCS call zerothcs#Load_CS(<q-args>)

function! s:Zcs_Complete_Params(arg, line, pos)
    let l = split(a:line[:a:pos-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
    let n = len(l) - index(l, 'ZerothCS') - 1
    if n == 1
        return zerothcs#Complete_Colors(l[1])
    endif
    return []
endfunction

if !exists('g:zerothcs_autostart')
    let g:zerothcs_autostart = 1
endif

if g:zerothcs_autostart
    ZerothCS
endif
