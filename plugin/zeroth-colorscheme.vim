
if exists('g:loaded_zerothcs')
    finish
endif
let g:loaded_zerothcs = 1

if !exists('g:zerothcs_colors_path')
    let g:zerothcs_colors_path = expand('$HOME') . '/.vim'
endif
set rtp+=g:zerothcs_colors_path
call system('mkdir -p ' . g:zerothcs_colors_path.'/colors')

command! -nargs=* -complete=customlist,s:Zcs_Complete_Params ZerothCS call zerothcs#Load_CS(<f-args>)
function! s:Zcs_Complete_Params(arg, line, pos)
    let l = split(a:line[:a:pos-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
    let n = len(l) - index(l, 'ZerothCS') - 1
    if n == 1
        return zerothcs#Complete_Colors(l[1])
    endif
    return []
endfunction

