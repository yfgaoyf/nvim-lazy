let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let NvimTreeSetup =  1 
let NvimTreeRequired =  1 
silent only
silent tabonly
cd ~/test-msd
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +551 tests/besair_platform/besair_main.c
badd +16 health://
argglobal
%argdel
$argadd tests/besair_platform/besair_main.c
edit tests/besair_platform/besair_main.c
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
1,15fold
128,131fold
135,137fold
141,145fold
158,162fold
169,194fold
195,198fold
199,200fold
211,213fold
209,214fold
223,226fold
230,232fold
246,247fold
243,247fold
249,250fold
248,251fold
252,254fold
263,265fold
271,273fold
274,276fold
270,277fold
281,282fold
279,283fold
285,286fold
284,287fold
278,288fold
289,290fold
300,301fold
306,307fold
313,314fold
315,316fold
321,328fold
338,339fold
350,351fold
354,355fold
348,356fold
359,360fold
363,364fold
343,366fold
375,377fold
382,386fold
394,396fold
399,400fold
392,402fold
408,410fold
414,416fold
406,419fold
427,433fold
435,436fold
437,445fold
452,455fold
459,461fold
466,469fold
480,486fold
475,487fold
492,504fold
508,509fold
511,512fold
513,514fold
516,519fold
522,523fold
524,526fold
527,528fold
530,533fold
536,542fold
543,545fold
546,547fold
549,550fold
551,555fold
558,559fold
563,564fold
565,566fold
568,569fold
571,572fold
573,574fold
577,579fold
583,585fold
586,588fold
591,592fold
597,599fold
600,602fold
604,615fold
618,624fold
626,629fold
630,631fold
634,635fold
638,640fold
644,648fold
650,652fold
653,658fold
659,663fold
667,668fold
671,672fold
673,675fold
679,680fold
683,684fold
687,688fold
689,690fold
694,695fold
698,700fold
701,703fold
704,709fold
713,716fold
718,719fold
720,721fold
724,725fold
726,727fold
728,734fold
735,736fold
737,738fold
739,740fold
742,743fold
744,745fold
746,747fold
748,749fold
751,753fold
754,757fold
762,765fold
768,770fold
766,772fold
787,788fold
784,789fold
778,790fold
let &fdl = &fdl
let s:l = 551 - ((23 * winheight(0) + 22) / 45)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 551
normal! 06|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
